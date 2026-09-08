#!/usr/bin/env python3
"""Build all endpoints, inspect their kernel axioms, pin the checked bytes.
No third-party Python dependencies. Run: python3 lean/verify.py
"""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parent
ENDPOINTS = [
    'gaussianCalculus', 'observation1', 'generalizedObservation',
    'firstOrderCondition', 'curvature', 'stationaryUniqueness',
    'conditionalResponseSigns', 'staticWelfare', 'baselineBoundary',
    'extensionBoundary',
]
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}

def run(args):
    completed = subprocess.run(args, cwd=ROOT, text=True, stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT)
    print(completed.stdout, end='', flush=True)
    if completed.returncode:
        raise RuntimeError(f'Failed ({completed.returncode}): {args}')
    return completed.stdout

def without_comments(text):
    # Lean supports nested block comments. Preserve noncomment bytes for the scan.
    result, i, depth = [], 0, 0
    while i < len(text):
        if text.startswith('/-', i):
            depth += 1; i += 2
        elif depth and text.startswith('-/', i):
            depth -= 1; i += 2
        elif depth:
            i += 1
        elif text.startswith('--', i):
            end = text.find('\n', i)
            i = len(text) if end < 0 else end
        else:
            result.append(text[i]); i += 1
    if depth:
        raise RuntimeError('Unterminated Lean comment')
    return ''.join(result)

def main():
    audit = ROOT/'audit'
    audit.mkdir(exist_ok=True)
    # A failed recheck must not leave an old success report masquerading as current.
    report_path = audit/'validation.json'
    report_path.write_text(json.dumps({'status':'running','endpoints':ENDPOINTS},indent=2)+'\n')
    source = json.loads((audit/'source.json').read_text())
    pdf = ROOT/source['file']
    pdf_status = 'not present; formal build does not require PDF'
    if pdf.exists():
        actual = hashlib.sha256(pdf.read_bytes()).hexdigest()
        if actual != source['sha256']:
            raise RuntimeError('Supplied PDF differs from pinned source')
        pdf_status = 'sha256 matches'
    for f in sorted(ROOT.glob('*.lean')):
        code = without_comments(f.read_text())
        banned = re.search(r'\b(sorry|admit|axiom|native_decide)\b', code)
        if banned:
            raise RuntimeError(f'Forbidden proof escape in {f.name}: {banned.group()}')
    version = run(['lake','env','lean','--version']).strip()
    build = run(['lake','build'])
    (audit/'build.log').write_text(build)
    output = run(['lake','env','lean','-DwarningAsError=true','Audit.lean'])
    (audit/'axioms.log').write_text(output)
    found = {}
    for name, raw in re.findall(r"'AKO26\.(\w+)' depends on axioms:\s*\[([^\]]*)\]", output):
        axioms = [a.strip() for a in raw.split(',') if a.strip()]
        unknown = set(axioms)-ALLOWED
        if unknown:
            raise RuntimeError(f'{name}: unexpected axioms {unknown}')
        found[name] = axioms
    for name in re.findall(r"'AKO26\.(\w+)' does not depend on any axioms", output):
        found[name] = []
    if set(found) != set(ENDPOINTS):
        raise RuntimeError(f'Axiom audit coverage mismatch: {set(found)}')
    paths = sorted(ROOT.glob('*.lean')) + [ROOT/n for n in
            ['lakefile.toml','lake-manifest.json','lean-toolchain','verify.py']]
    hashes = {str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    result = {
        'status':'passed', 'checked_at_utc':datetime.now(timezone.utc).isoformat(),
        'lean_version':version, 'paper_source':pdf_status, 'endpoint_count':len(found),
        'endpoint_axioms':found, 'local_axioms':0, 'proof_holes':0,
        'native_decide_uses':0, 'source_hashes':hashes,
        'nonvacuity':'Audit.lean checks admissible baseline/extension parameter witnesses and a feasible improvement.',
        'semantic_review':'Source mapping reviewed by the authoring AI; not independently human certified.',
        'scope':'Selected static endpoints, not full paper; no dynamics or steady-state welfare proof.'}
    report_path.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
    print(f'PASS: {len(found)} exact-type endpoints; no proof holes or added axioms.')

if __name__ == '__main__':
    try:
        main()
    except Exception as exc:
        (ROOT/'audit'/'validation.json').write_text(json.dumps({'status':'failed','error':str(exc)},indent=2)+'\n')
        print(f'FAIL: {exc}', file=sys.stderr)
        sys.exit(1)
