# mfact v26.7.7 — procint certified release

`mfact` manufactures `procint`: a Lean 4 process-intelligence corpus whose
declarations live in an RDF/Turtle catalog, are rendered by `ggen`, admitted
by the Lean kernel, and certified with computed receipts. ggen renders;
Lean admits; mfact certifies.

- **388** declarations recorded in the catalog
- **197** theorems kernel-admitted and axiom-audited
  (footprint within propext / Classical.choice / Quot.sound)
- **2** statements formalized but honestly STATED, not proven
  (the WF-net soundness equivalence remains PROVEN)
- Standing Quadrature closed: TTL x Lean x Manifest x ProcessEvidence x
  PaperClaims, zero orphans, kernel-admitted witness
- Genesis-folded release hash: `c528304f40660e304d444dd1ad2a2edbeac0d6f7c12ae3368e2577c9d38ea9e0`

Reproduce: see `README_REPRODUCIBILITY.md` and `release/replay_plan.json`
at tag `v26.7.7-procint-certified`.

## Checksums (BLAKE3)

```
bba7ac0a13ed7ac7c00f0b0c65d67f1ff8fb0f06df134bc9b616ca70cd6e45e5  paper/arxiv-submission.tar.gz
52deed4fac55757f94f86bbcaf8b0ea3c78de245c469985b388abf540d243c00  paper/main.pdf
59d50003f9f05092400d07a34b175531ae9e47e21aadc47daa52175cb05576ca  release/release-manifest.json
```

This packet was manufactured; publishing it is a human action
(PENDING_EXTERNAL_ACTUATION).
