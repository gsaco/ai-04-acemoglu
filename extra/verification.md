# Verification record

## Deliverables and scope

- Main source/PDF: `presentation.tex`, `presentation.pdf` — exactly 5 slides (title + four content slides), 16:9.
- Extended source/PDF: `extra/presentation-extended.tex`, `extra/presentation-extended.pdf` — 16 slides, 16:9.
- Equations are typeset in LaTeX. Original static charts are vector PDF graphics. There are no overlays, animations, or screenshots of the paper.
- The source document is the supplied February 2026 NBER WP 34910; citations use printed page numbers.
- No dynamic paths, steady-state roots, collapse thresholds, or long-run welfare curves were simulated.

## Compilation

Compiled with pdfLaTeX (TeX Live 2025) using the academic-slide skill's compile helper, which repeats passes to stabilize references. Portable commands, from each source's own directory:

```sh
pdflatex -interaction=nonstopmode -halt-on-error presentation.tex
pdflatex -interaction=nonstopmode -halt-on-error presentation.tex
```

For the extended deck, use `presentation-extended.tex` from `extra/`.

The final logs contain no overfull/underfull boxes, missing files, unresolved references/citations or remaining LaTeX warnings. Earlier vertical overflows were corrected by reducing chart height and trimming the final main slide's source line. An image-paragraph flow problem was corrected so text starts below, not beside, the charts.

## Visual audit

Both contact sheets and every individual rendered slide were inspected: main slides 1–5, extended slides 1–16. Titles, equations, tables, charts, captions and footers are separated and within the slide margins. Chart labels were enlarged. The missing-photo panels are intentional and clearly labeled.

Audit artifacts are available locally at:

- `extra/audit-main/audit_report.md`, `extra/audit-main/contact_sheet.png`, `extra/audit-main/pages/`
- `extra/audit-extended/audit_report.md`, `extra/audit-extended/contact_sheet.png`, `extra/audit-extended/pages/`

The auditor's automatic text-box heuristic flags the radical near “Welfare” on main slide 3, and chart axis tick/label bounding boxes on main slide 4 / extended slide 14. Individual rendered-slide inspection confirms these are bounding-box false positives: the visible glyphs and labels do not overlap. They are retained in the raw reports rather than suppressed.

The local Poppler extractor emitted an invalid XML control character in a math glyph on the extended deck. A temporary copy of the audit helper sanitized XML-forbidden control characters before parsing; the PDF and its rendered pages were unchanged. That allowed the text-box scan to finish. This workaround was for the audit parser, not the presentation content.

## Mathematical checks

`extra/static_checks.py` verifies six exact SymPy identities and 444 static optima. The maximum absolute FOC residual is approximately 2.436e-15. Comparative statics and the fixed-X envelope derivative are checked against central finite differences at an interior point. Numerical grid signs are consistent with the symbolic expressions. All checks pass; exact results and package versions are stored in `extra/results/checks.json`.

Production normalization is preserved when Delta_I is varied by adjusting Delta_G. The program contains no public-precision recursion or steady-state solver. The machine-readable welfare field is fixed-state static utility only.

## Outstanding requirement

**The submission is not complete until the student supplies a real photo of a derivation done by hand.** Save it as `hand/derivation.jpg`, recompile both decks, and inspect that photo's readability on the final main slide and extended slide 15. The current panels are not evidence of handwritten work.
