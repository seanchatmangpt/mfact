# mfact v26.7.7 — procint certified release

`mfact` manufactures `procint`: a Lean 4 process-intelligence corpus whose
declarations live in an RDF/Turtle catalog, are rendered by `ggen`, admitted
by the Lean kernel, and certified with computed receipts. ggen renders;
Lean admits; mfact certifies.

- **397** declarations recorded in the catalog
- **197** theorems kernel-admitted and axiom-audited
  (footprint within propext / Classical.choice / Quot.sound)
- **7** statements formalized but honestly STATED, not proven
  (the WF-net soundness equivalence remains PROVEN)
- Standing Quadrature closed: TTL x Lean x Manifest x ProcessEvidence x
  PaperClaims, zero orphans, kernel-admitted witness
- Genesis-folded release hash: `942facf32d48cd1a26c0f06b9396c6c150ab4d95d601bd090a8e1b9e7ef2d434`

Reproduce: see `README_REPRODUCIBILITY.md` and `release/replay_plan.json`
at tag `v26.7.7-procint-certified`.

## Checksums (BLAKE3)

```
89e37a9eba6064a2afb6d7f5a8edfab090a76e07c9dea5ac913baaa1168d5786  paper/arxiv-submission.tar.gz
e25b942a93c3a62645bfd63f0b2209f017edfc20f7e33419b9b6a307ec64ee51  paper/main.pdf
84758648d87a1c58e48c867d640273fc89620011f59de8c9f1339d0c31014aca  release/release-manifest.json
```

This packet was manufactured; publishing it is a human action
(PENDING_EXTERNAL_ACTUATION).
