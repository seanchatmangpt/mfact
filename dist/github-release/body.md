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
66ffebaeddd5c02b626e0934e869af91b80f87d595b2708ec64ab06bd1ea8b23  paper/arxiv-submission.tar.gz
d38e13de31cce5451d4158e08f7e88caff5d32d557635aa9ab7774f07b73a726  paper/main.pdf
9b6ca5f83edaf8581f60f8daf926b3e2b42a3559abfd5076794b79a06c22f24e  release/release-manifest.json
```

This packet was manufactured; publishing it is a human action
(PENDING_EXTERNAL_ACTUATION).
