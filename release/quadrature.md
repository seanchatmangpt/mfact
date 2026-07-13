# Standing Quadrature — v26.7.7

`PASS` (run `ee624be`). ggen renders. Lean admits. mfact certifies.

The release is not evaluated only by whether Lean builds. It is evaluated
by whether the declaration catalog, admitted Lean corpus, process
evidence, release manifest, and paper claims form a closed standing graph.
The quadrature check rejects orphan declarations, unsupported claims,
untraced artifacts, and manifest–paper divergence. The closure is
kernel-checked: `procint/ProcInt/Release/Quadrature.lean` is rendered from
the same graph and `lake build Quadrature` refuses it if any surface pair
diverges.

## Surface pairs

| Surface pair | Count | Result |
|---|---:|---|
| TTL to Lean | 203 | PASS |
| Lean to Audit | 203 | PASS |
| Audit to Manifest | 203 | PASS |
| Manifest to Paper | 6 | PASS |
| Artifact to Process Event | 260 | PASS |
| Claim to Evidence | 5 | PASS |

## Traced paper claims

| Claim | Evidence |
|---|---|
| C1: mfact framework with axiom-free no_valid_objection | `mfact/AxiomAudit.lean` |
| C2: procint corpus: 203 kernel-admitted, axiom-audited theorems | `release/release-manifest.json#artifacts` |
| C3: proven/stated split enforced by release gate (2 stated) | `release/release-manifest.json#statedNotProven` |
| C4: evaluation numbers rendered from the manifest | `paper/evaluation.tex` |
| C5: negative controls: the gate refuses (exit 1/2) | `release/certify.log` |

## Surfaces

- TTL catalog: 203 proven declarations
- Paper: 5 traced claims, 6 evaluation numbers checked against the manifest
- Process: 10 run events (receipt-chain append order; no wall clock)
