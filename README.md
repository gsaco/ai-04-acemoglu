# Better advice, weaker learning?

**Acemoglu, Kong & Ozdaglar (2026), _AI, Human Cognition and Knowledge Collapse_, NBER WP 34910.** [Repository](https://github.com/gsaco/ai-04-acemoglu) · [Supplied paper](w34910.pdf) · [Five-minute deck](presentation.pdf) · [Extended deck](extra/presentation-extended.pdf)

**Question.** Can personalized AI improve individual decisions while eroding the human learning that sustains public knowledge? The mechanism combines private information acquisition with an uninternalized public-learning spillover. **Numbering correction:** Section 2 of this PDF is related literature; the static setup is §§3.1–3.5, especially Observation 1 in §3.4.

**Agent’s problem.** Taking inherited public precision $X$ and agentic precision $\tau_A$ as given, a short-lived, atomistic agent chooses $e\geq0$. Independent Gaussian information gives $Y=\sigma^{-2}+\lambda_Ie+\tau_A$. Posterior-mean predictions succeed within a unit error band with probability $G(z)=2\Phi(\sqrt z)-1$. Omitting the constant $f(0,0)$,

$$\max_{e\geq0}\;U=\Delta_GG(X)+\Delta_XG(X)G(Y)-e^\alpha/\alpha.$$

**Main static result, with conditions.** The paper imposes monotone production, $\Delta_I=0$, $\Delta_X>0$, $\Delta_G+\Delta_X=1$, $\alpha>1$, $\lambda_I>0$, and finite $\tau_A\geq0$. For $X>0$ and $\sigma^{-2}>0$, with Gaussian independent signals and no privately internalized public-learning return, $g=G'>0$ and $g'(z)=-(1+z^{-1})g(z)/2<0$. Therefore,

$$U_{eX}=\Delta_X\lambda_Ig(X)g(Y)>0,\qquad U_{e\tau_A}=\Delta_XG(X)\lambda_Ig'(Y)<0.$$

The unique interior optimum solves $\Delta_XG(X)\lambda_Ig(Y)=e^{\alpha-1}$. Strict concavity implies $e_X^*>0$ and $e_{\tau_A}^*<0$. At $X=0$, the optimum is $e^*=0$; the strict interior claims do not apply. Sources: pp. 8, 12–14.

**Is welfare increasing in accuracy?** At fixed $X>0$, optimized static utility increases: $v_{\tau_A}=\Delta_XG(X)g(Y)>0$. Long-run welfare also includes the loss of public knowledge. The paper’s single-peak claims require Assumption 2, $\sigma^{-2}\geq\sqrt2-1$, and the baseline model with positive $I,\lambda_G,\Sigma^2$. If $\alpha-1>1/4$, the high steady state attracts all $X_1>0$; its welfare rises below a finite maximizer $\tau_A^*\geq0$, falls above it, and tends to zero. If $0<\alpha-1<1/4$ and a positive branch exists, $0\leq\tau_A^*<\tau_A^c$; realized welfare also depends on whether $X_1$ is above or below the unstable threshold. For $\tau_A>\tau_A^c$, collapse is global. These statements exclude $\alpha-1=1/4$ and do not settle $\tau_A=\tau_A^c$. **An interior optimum is not guaranteed.** Sources: Propositions 3, 5, 10–11; pp. 18, 20, 25–26. Dynamic results are read-only.

**Assumption audit and added work.** Section 5 changes AI-assisted aggregation, synthetic public signals, and effort bundling. It never relaxes **$\Delta_I=0$**, the absence of standalone value from context-specific knowledge. My AI-assisted static extension allows $\Delta_I>0$: both signs survive, but $U_e(0;0,\tau_A)=\Delta_I\lambda_Ig(\sigma^{-2}+\tau_A)>0$. Exact zero-effort collapse loses its boundary premise. [SymPy checks](extra/static_checks.py) verify six identities; 444 numerical optima have FOC residuals below $2.5\times10^{-15}$. These are illustrations, not dynamic replications or empirical estimates.

**Deliverables.** [Raw prompt/answer excerpts](prompts.md); [derivations and source map](extra/analysis.md); [oral script](extra/oral-notes.md); [build instructions](extra/README.md). **Still required:** your authentic handwritten photo in `hand/derivation.jpg`; both decks currently show an explicit pending panel. See [hand/](hand/README.md).
