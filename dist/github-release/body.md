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
d3631ee81cf916bf0e5f6e36712ea4e985930b38f9be16092e37f7e630c832b9  paper/arxiv-submission.tar.gz
97d2f1db73ddc57bbe6e9a7a9a2d74ea7aafb47b132c6a63e83e9e38271f5c70  paper/main.pdf
17dc5992ca3a999b42d3bbc1ee0fbd0e64e8a697feb64889ab8fcb01c05d0faf  release/release-manifest.json
```

This packet was manufactured; publishing it is a human action
(PENDING_EXTERNAL_ACTUATION).
