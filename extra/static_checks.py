#!/usr/bin/env python3
"""Static checks only: no precision paths, steady-state search, or welfare simulation.
Run from any directory: python extra/static_checks.py
"""
from pathlib import Path
import csv, json, platform
import sympy as sp
import numpy as np
import scipy
from scipy.optimize import brentq
from scipy.special import erf
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parent
(ROOT / 'results').mkdir(exist_ok=True)
(ROOT / 'figures').mkdir(exist_ok=True)
e, X, a, lam, p, alpha = sp.symbols('e X a lambda p alpha', positive=True)
dI, dG, dX = sp.symbols('Delta_I Delta_G Delta_X', nonnegative=True)
z = sp.symbols('z', positive=True)
G = lambda q: sp.erf(sp.sqrt(q / 2))
g = lambda q: sp.exp(-q / 2) / sp.sqrt(2 * sp.pi * q)
Y = p + lam * e + a
U = dG * G(X) + (dI + dX * G(X)) * G(Y) - e**alpha / alpha
checks = {
 'Gprime': sp.simplify(sp.diff(G(z), z) - g(z)),
 'gprime': sp.simplify(sp.diff(g(z), z) + (1 + 1/z)*g(z)/2),
 'FOC': sp.simplify(sp.diff(U,e) - ((dI+dX*G(X))*lam*g(Y)-e**(alpha-1))),
 'U_eX': sp.simplify(sp.diff(U,e,X) - dX*lam*g(X)*g(Y)),
 'U_ea': sp.simplify(sp.diff(U,e,a) + (dI+dX*G(X))*lam*(1+1/Y)*g(Y)/2),
 'U_ee': sp.simplify(sp.diff(U,e,2) - ((dI+dX*G(X))*lam**2*sp.diff(g(z),z).subs(z,Y)-(alpha-1)*e**(alpha-2))),
}
assert all(v == 0 for v in checks.values()), checks
# Numerical illustration preserves Delta_G + Delta_I + Delta_X = 1.
PAR = dict(alpha=2., lam=1., p=1., dX=.6)
def Gn(q): return float(erf(np.sqrt(q/2)))
def gn(q): return float(np.exp(-q/2)/np.sqrt(2*np.pi*q))
def foc(eff, public, ai, standalone):
    return (standalone+PAR['dX']*Gn(public))*PAR['lam']*gn(PAR['p']+PAR['lam']*eff+ai)-eff**(PAR['alpha']-1)
def best(public, ai, standalone):
    if public == 0 and standalone == 0: return 0.
    hi = 1.
    while foc(hi,public,ai,standalone) > 0: hi *= 2
    return brentq(foc,0.,hi,args=(public,ai,standalone),xtol=1e-14)
def value(public, ai, standalone):
    eff=best(public,ai,standalone)
    return (1-standalone-PAR['dX'])*Gn(public)+(standalone+PAR['dX']*Gn(public))*Gn(PAR['p']+eff+ai)-eff**2/2
rows=[]
for di in (0.,.15):
    for xx in np.linspace(0,2,101):
        rows.append(dict(experiment='public_precision',X=xx,tau_A=1.,Delta_I=di,Delta_G=1-di-PAR['dX'],effort=best(xx,1.,di),value=value(xx,1.,di)))
    for aa in np.linspace(0,6,121):
        rows.append(dict(experiment='agentic_precision',X=1.,tau_A=aa,Delta_I=di,Delta_G=1-di-PAR['dX'],effort=best(1.,aa,di),value=value(1.,aa,di)))
with (ROOT/'results/static_grid.csv').open('w',newline='') as f:
    writer=csv.DictWriter(f,fieldnames=rows[0].keys());writer.writeheader();writer.writerows(rows)
max_residual=max(abs(foc(r['effort'],r['X'],r['tau_A'],r['Delta_I'])) for r in rows)
assert max_residual < 1e-11
for di in (0.,.15):
    re=[r for r in rows if r['Delta_I']==di and r['experiment']=='agentic_precision']
    assert np.all(np.diff([r['effort'] for r in re]) < 0)
    assert np.all(np.diff([r['value'] for r in re]) > 0)
    re=[r for r in rows if r['Delta_I']==di and r['experiment']=='public_precision']
    assert np.all(np.diff([r['effort'] for r in re]) > 0)
# Independent numerical derivatives against the IFT and the envelope theorem.
x0,a0,di0=1.,1.,0.
e0=best(x0,a0,di0); y0=1+e0+a0; h=1e-5
gp=lambda q: -(1+1/q)*gn(q)/2
uee=PAR['dX']*Gn(x0)*gp(y0)-1
ift_x=-PAR['dX']*gn(x0)*gn(y0)/uee
ift_a=-PAR['dX']*Gn(x0)*gp(y0)/uee
fd_x=(best(x0+h,a0,di0)-best(x0-h,a0,di0))/(2*h)
fd_a=(best(x0,a0+h,di0)-best(x0,a0-h,di0))/(2*h)
envelope=PAR['dX']*Gn(x0)*gn(y0)
fd_value=(value(x0,a0+h,di0)-value(x0,a0-h,di0))/(2*h)
assert abs(ift_x-fd_x)<1e-8 and abs(ift_a-fd_a)<1e-8 and abs(envelope-fd_value)<1e-8
report={
 'scope':'Static only; no dynamic or steady-state reproduction.',
 'versions':{'python':platform.python_version(),'sympy':sp.__version__,'scipy':scipy.__version__,'numpy':np.__version__,'matplotlib':matplotlib.__version__},
 'parameters':PAR,'Delta_I_values':[0,.15],
 'normalization':'Delta_G = 1 - Delta_I - Delta_X',
 'symbolic_residuals':{k:str(v) for k,v in checks.items()},
 'rows':len(rows),'max_FOC_residual':max_residual,
 'baseline_e_X1_tau1':e0,'extension_e_X0_tau1':best(0,1,.15),
 'IFT_vs_finite_difference':{'e_X':[ift_x,fd_x],'e_tau':[ift_a,fd_a],'value_tau':[envelope,fd_value]},
 'interpretation':'Both cross-partial signs survive Delta_I > 0, but effort at X=0 is positive for finite tau_A. Fixed-X optimized utility increases with AI accuracy. These checks do not imply a long-run welfare theorem.'
}
(ROOT/'results/checks.json').write_text(json.dumps(report,indent=2)+'\n')
plt.rcParams.update({'font.family':'DejaVu Sans','font.size':16,'axes.titlesize':15,'xtick.labelsize':13,'ytick.labelsize':13,'axes.spines.top':False,'axes.spines.right':False,'axes.labelcolor':'#23313d','text.color':'#23313d','axes.edgecolor':'#9aa4aa','svg.fonttype':'none'})
fig,axs=plt.subplots(1,2,figsize=(11.5,3.4),layout='constrained')
for di,color,style in [(0.,'#126b75','-'),(.15,'#ad591d','--')]:
    for ax,experiment,key in [(axs[0],'agentic_precision','tau_A'),(axs[1],'public_precision','X')]:
        sub=[r for r in rows if r['Delta_I']==di and r['experiment']==experiment]
        ax.plot([r[key] for r in sub],[r['effort'] for r in sub],color=color,ls=style,lw=2.5,label=rf'$\Delta_I={di:g}$')
axs[0].set(xlabel=r'Agentic precision $\tau_A$',ylabel=r'Optimal effort $e^*$',title=r'Substitution, holding $X=1$')
axs[1].set(xlabel=r'Public precision $X$',title=r'Complementarity, holding $\tau_A=1$')
for ax in axs: ax.set_ylim(bottom=0);ax.grid(axis='y',alpha=.15);ax.legend(frameon=False,fontsize=13)
fig.savefig(ROOT/'figures/static_checks.pdf')
fig.savefig(ROOT/'figures/static_checks.png',dpi=180)
print(json.dumps(report,indent=2))
