# Repository verification

Audit completed on 14 September 2026 before the branch1-to-main merge.

## Result and scope

All executed checks pass. The repository meets the original assignment's file and presentation requirements: source paper, README, raw prompt record, one student-provided handwritten derivation photo, and a title slide plus four content slides. The extended deck and static experiments are additional material.

The proof coverage is explicitly partial: ten static Lean endpoints. Propositions 1–16, the Bayesian probability-space foundation and global optimizer existence are not formally proved. These limits are documented in [the whole-paper coverage audit](../lean/audit/full-paper-coverage.md); the original homework treats dynamic results as read-only.

## Checks performed

| Check | Result |
|---|---|
| Pinned Lean build and axiom audit | 10 endpoints pass; no proof holes, local axioms or `native_decide`. Only standard `propext`, `Classical.choice` and `Quot.sound` dependencies. |
| Paper and Lean source integrity | Supplied PDF hash and checked source/configuration hashes match [validation.json](../lean/audit/validation.json). |
| Fresh Python environment | Python 3.11.7; all packages in `requirements.txt` installed; `pip check` reports no broken requirements. |
| Static symbolic and numerical verification | 6 symbolic residuals equal zero; 444 optimal choices; maximum FOC residual 2.4356e-15; effort and welfare signs pass; finite differences agree. |
| Nonbaseline regression checks | Six cases across two parameter sets agree with the symbolic objective and an independent bounded optimizer. Learning productivity, prior precision and cost curvature were varied. |
| Presentation builds | Main: 5 pages. Extended: 16 pages. Both 16:9, compiled with pdfLaTeX/TeX Live 2025. No overfull/underfull boxes, unresolved references/citations or missing files. |
| Visual review | Both contact sheets and all 21 individual rendered pages inspected; no visible overlap, clipping or incorrectly oriented photographs. |
| Repository assets | Local Markdown links, JSON/SVG syntax, required files and JPEG format checked. |
| Git hygiene | Generated SyncTeX files removed from version control and ignored; whitespace/error checks pass. The deletion of the obsolete handwriting README on main is preserved. |

The saved baseline numerical results are unchanged after the code fix; the report's Python version now records the fresh environment. Numerical evidence remains separate from formal Lean verification.

## Fixes made during the audit

- Removed hard-coded baseline constants from the numerical payoff and derivative checks so they use the declared prior precision, learning productivity and cost exponent consistently.
- Corrected outdated statements that the handwritten photograph was missing, repaired the link to the hand folder, and updated the oral script and evidence map.
- Clarified that existence of the interior optimum uses concavity and boundary incentives, and that payoff (rather than an optimum) is concave.
- Updated the extended photo slide to distinguish the photographed baseline work from the separately presented extension and verdict.
- Documented Python 3.11 setup and the workaround for an incompatible personal TeX package overriding the installed distribution.

## Reproduction

Follow [extra/README.md](README.md) for the pinned Python environment and both slide builds, and [lean/README.md](../lean/README.md) for Lean installation. The core checks from the repository root are:

```sh
python3 lean/verify.py
.venv/bin/python -m pip check
.venv/bin/python extra/static_checks.py
```

The decks were compiled twice from each source's directory with `pdflatex -interaction=nonstopmode -halt-on-error`. On this machine, `TEXMFHOME` was set to an empty temporary directory to avoid an incompatible personal `hyperref` package; no installed TeX files were modified.

## Visual audit artifacts

Local, ignored artifacts are in `extra/audit-main/` and `extra/audit-extended/`. Each contains `audit_report.md`, `contact_sheet.png` and individual PNGs under `pages/`. The source/PDF pairs are [presentation.tex](../presentation.tex) / [presentation.pdf](../presentation.pdf) and [presentation-extended.tex](presentation-extended.tex) / [presentation-extended.pdf](presentation-extended.pdf).

The text-box heuristic flags the square-root glyph near “Welfare” on main page 3 and chart tick/axis-label bounding boxes on extended page 14. Individual-image inspection confirms these are bounding-box false positives. A temporary copy of the audit helper removed XML-forbidden control characters emitted by Poppler for one mathematical glyph; this changed only the parser input, not either PDF or its content.

## Handwritten evidence

The JPEG at [hand/derivation.jpg](../hand/derivation.jpg) appears on main page 5 and extended page 15. It documents the baseline Gaussian derivatives, FOC and cross-partials. The additional extension, fixed-variable labels, full sign-condition checklist and welfare verdict are not all on that photographed page; they are explained in the slides and analysis. The source photograph was not modified during this audit.
