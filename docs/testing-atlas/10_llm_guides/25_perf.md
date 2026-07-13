# PERF: Performance and benchmark testing

## Family law

Benchmark measurements are empirical evidence. Never promote wall-clock results into formal complexity theorems.

## Mandatory implementation sequence

1. Name the benchmark instance and input size.
2. Separate test-size and benchmark-size inputs.
3. Emit stable custom metrics where needed.
4. Record toolchain/hardware context outside theorem standing.
5. Compare trends/regressions against explicit thresholds.

## Core-team anti-patterns

- One noisy timing.
- Mixing benchmark claims into theorem docstrings.
- Calling O(n) because a chart looks linear.

## Lean/Lake skeleton

```lean
-- Emit domain metrics in the benchmark harness, e.g.
-- measurement: residue_candidates 1024 count
-- measurement: proof_branches 87 count
-- Keep separate from formal operation-count theorems.
```

## Test instances in this family

## T112 — Compile benchmark

**Stable instance:** `MFW.TST.PERF.COMPILE.112`

**Question:** How long does generated code compilation/execution take?

**Canonical mechanism:** `benchmark harness`

**Canonical MFW instance:** compiled verifier

### LLM implementation recipe

1. Declare `MFW.TST.PERF.COMPILE.112` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **benchmark harness**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T113 — Elaboration benchmark

**Stable instance:** `MFW.TST.PERF.ELAB.113`

**Question:** How expensive is elaboration?

**Canonical mechanism:** `elab benchmark`

**Canonical MFW instance:** large theorem module

### LLM implementation recipe

1. Declare `MFW.TST.PERF.ELAB.113` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **elab benchmark**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T114 — Lake benchmark

**Stable instance:** `MFW.TST.PERF.LAKE.114`

**Question:** How expensive are Lake graph operations/targets?

**Canonical mechanism:** `Lake benchmark`

**Canonical MFW instance:** standing target

### LLM implementation recipe

1. Declare `MFW.TST.PERF.LAKE.114` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Lake benchmark**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T115 — Build benchmark

**Stable instance:** `MFW.TST.PERF.BUILD.115`

**Question:** How expensive is the whole package build?

**Canonical mechanism:** `build benchmark`

**Canonical MFW instance:** ProcInt

### LLM implementation recipe

1. Declare `MFW.TST.PERF.BUILD.115` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **build benchmark**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T116 — Size benchmark

**Stable instance:** `MFW.TST.PERF.SIZE.116`

**Question:** How large are source/olean/ilean/artifact outputs?

**Canonical mechanism:** `size metrics`

**Canonical MFW instance:** generated modules

### LLM implementation recipe

1. Declare `MFW.TST.PERF.SIZE.116` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **size metrics**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T117 — Custom metric benchmark

**Stable instance:** `MFW.TST.PERF.CUSTOM_METRIC.117`

**Question:** Can domain-specific measurements be emitted and tracked?

**Canonical mechanism:** `measurement output`

**Canonical MFW instance:** residue candidate count / proof branching

### LLM implementation recipe

1. Declare `MFW.TST.PERF.CUSTOM_METRIC.117` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **measurement output**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

