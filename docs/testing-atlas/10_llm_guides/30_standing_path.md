# STANDING_PATH: Gap, edge, and standing-path coverage

## Family law

Crown standing depends on required admitted edges, not file count or isolated theorem count.

## Mandatory implementation sequence

1. Declare the required crown path as exact nodes and edges.
2. Resolve each node to a controlled artifact/declaration.
3. Resolve each edge to a theorem, correspondence witness, or explicit gap.
4. Compute reachability and coverage.
5. Allow `ALIVE` only when every required edge is admitted.

## Core-team anti-patterns

- Modules with adjacent names standing in for edges.
- Path coverage based on prose arrows.
- A verifier that passes when the expected check list is empty.

## Lean/Lake skeleton

```lean
structure RequiredEdge where
  source : NodeId
  target : NodeId
  witnessName : Name

structure StandingPathReceipt where
  required : Finset RequiredEdge
  admitted : Finset RequiredEdge
  complete : admitted = required
```

## Test instances in this family

## T132 — Gap/edge coverage test

**Stable instance:** `MFW.TST.STANDING_PATH.EDGE_COVERAGE.132`

**Question:** Are all declared mathematical/correspondence edges represented by admitted proofs or explicit gaps?

**Canonical mechanism:** `theorem graph audit`

**Canonical MFW instance:** MFW wave graph

### LLM implementation recipe

1. Declare `MFW.TST.STANDING_PATH.EDGE_COVERAGE.132` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem graph audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T133 — Standing path coverage test

**Stable instance:** `MFW.TST.STANDING_PATH.PATH_COVERAGE.133`

**Question:** Does every crown claim have a complete admitted path from controlled source to crown consequence?

**Canonical mechanism:** `required-edge graph reachability`

**Canonical MFW instance:** TTL→ggen→Lean→Lake→audit crown path

### LLM implementation recipe

1. Declare `MFW.TST.STANDING_PATH.PATH_COVERAGE.133` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **required-edge graph reachability**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

