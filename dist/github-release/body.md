# mfact v26.7.6 — procint certified release

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
- Genesis-folded release hash: `a138ee84d0c08e0e946e0d0bb805a563b8304cf268eb97e6b9784bd36279fd86`

Reproduce: see `README_REPRODUCIBILITY.md` and `release/replay_plan.json`
at tag `v26.7.6-procint-certified`.

## Checksums (BLAKE3)

```
ee760a19638fa0b643ce1de22ab8fc23a1f754fd06e889720b89488a817ab49c  paper/arxiv-submission.tar.gz
91a98227f5eb460dbfd4449a8307d8364458e4f0f9e4d67bccf47d45dcc73123  paper/main.pdf
c07897846c90d9a044176b42928876b35f5d5a84a4a85e42a891fd24b466bf2c  release/release-manifest.json
```

This packet was manufactured; publishing it is a human action
(PENDING_EXTERNAL_ACTUATION).
