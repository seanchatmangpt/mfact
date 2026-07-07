# mfact v26.7.7 — procint certified release

`mfact` manufactures `procint`: a Lean 4 process-intelligence corpus whose
declarations live in an RDF/Turtle catalog, are rendered by `ggen`, admitted
by the Lean kernel, and certified with computed receipts. ggen renders;
Lean admits; mfact certifies.

- **318** declarations recorded in the catalog
- **145** theorems kernel-admitted and axiom-audited
  (footprint within propext / Classical.choice / Quot.sound)
- **2** statements formalized but honestly STATED, not proven
  (the WF-net soundness equivalence remains STATED)
- Standing Quadrature closed: TTL x Lean x Manifest x ProcessEvidence x
  PaperClaims, zero orphans, kernel-admitted witness
- Genesis-folded release hash: `e25724e88d4b2ee396b7442d5604dafa1b6da9fd6c61614ebd4062ad073c080d`

Reproduce: see `README_REPRODUCIBILITY.md` and `release/replay_plan.json`
at tag `v26.7.7-procint-certified`.

## Checksums (BLAKE3)

```
bba7ac0a13ed7ac7c00f0b0c65d67f1ff8fb0f06df134bc9b616ca70cd6e45e5  paper/arxiv-submission.tar.gz
fd67d3932d367d000ab3aae15f31a425fbf44ffef2ce2f59e15b1a269e5cb97c  paper/main.pdf
729ce0d2d9ab90dd5abe4a19c995c46ffbd2da6c6e1e48b3252f60ab3a8f1ee6  release/release-manifest.json
```

This packet was manufactured; publishing it is a human action
(PENDING_EXTERNAL_ACTUATION).
