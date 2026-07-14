# mfact v26.7.13 — procint certified release

`mfact` manufactures `procint`: a Lean 4 process-intelligence corpus whose
declarations live in an RDF/Turtle catalog, are rendered by `ggen`, admitted
by the Lean kernel, and certified with computed receipts. ggen renders;
Lean admits; mfact certifies.

- **401** declarations recorded in the catalog
- **203** theorems kernel-admitted and axiom-audited
  (footprint within propext / Classical.choice / Quot.sound)
- **2** statements formalized but honestly STATED, not proven
  (the WF-net soundness equivalence remains PROVEN)
- Standing Quadrature closed: TTL x Lean x Manifest x ProcessEvidence x
  PaperClaims, zero orphans, kernel-admitted witness
- Genesis-folded release hash: `74900dc3fc5aa2e6ad46224655f65ecd2e49636c91ac2204614e16cbe1521f32`

Reproduce: see `README_REPRODUCIBILITY.md` and `release/replay_plan.json`
at tag `v26.7.13-procint-certified`.

## Checksums (BLAKE3)

```
0b969f3522b938c1c7d4fe465b99b0adb7f1e34655d85585adf965d3d9f3ed71  paper/arxiv-submission.tar.gz
463676a46db6f78d17143f155a26fbfe013034a7e4ccce36ee286a9e4e8721a9  paper/main.pdf
ab9ae7d1c93e1bc85965eb5f54c9103eec65c870e2f1936f866b0daed75b1301  release/release-manifest.json
```

This packet was manufactured; publishing it is a human action
(PENDING_EXTERNAL_ACTUATION).
