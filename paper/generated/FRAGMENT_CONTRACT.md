# Paper Fragment Contract

Generated TeX fragments in this directory must:

1. Contain no `\documentclass`.
2. Contain no `\begin{document}` or `\end{document}`.
3. Contain no bibliography commands.
4. Use only macros defined by `main.tex` or `generated/release_macros.tex`.
5. Escape all manifest-derived strings.
6. Compile under `latexmk` from a clean checkout.
7. Include a generated-file header naming their source and generator.
8. Be reproducible from `release-manifest.json` and `standing.env`
   (via `just standing-quadrature`).
9. Never upgrade STATED to PROVEN.
10. Never hand-author release counts, hashes, or standing statuses.

Human writes interpretation. ggen writes standing. Lean admits witnesses.
mfact certifies release. LaTeX imports receipts. PDF reports consequence.
