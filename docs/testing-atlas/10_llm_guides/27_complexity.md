# COMPLEXITY: Complexity-law testing

## Family law

Formal complexity uses a mathematical cost semantics. Runtime benchmarking is a separate rail.

## Mandatory implementation sequence

1. Define an abstract operation counter.
2. Relate input size to the counter.
3. Prove the upper/lower bound.
4. Benchmark the real implementation separately.
5. Audit prose so it never conflates the two.

## Core-team anti-patterns

- Deriving Big-O from timings.
- Using wall-clock time in a theorem carrier.
- Calling a formal counter a nanosecond claim.

## Lean/Lake skeleton

```lean
def operations : Input → Nat := ...

theorem operations_le (x : Input) :
    operations x ≤ bound (size x) := by
  ...
```

## Test instances in this family

## T126 — Complexity-law test

**Stable instance:** `MFW.TST.COMPLEXITY.FORMAL_BOUND.126`

**Question:** Can an abstract operation counter be formally bounded by f(|x|)?

**Canonical mechanism:** `Nat cost semantics + theorem`

**Canonical MFW instance:** workflow traversal / residue search

### LLM implementation recipe

1. Declare `MFW.TST.COMPLEXITY.FORMAL_BOUND.126` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Nat cost semantics + theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T127 — Formal-vs-measured complexity distinction test

**Stable instance:** `MFW.TST.COMPLEXITY.MEASURE_DISTINCTION.127`

**Question:** Are formal operation bounds kept separate from wall-clock benchmark claims?

**Canonical mechanism:** `claim reconciliation`

**Canonical MFW instance:** complexity theorem vs measured benchmark

### LLM implementation recipe

1. Declare `MFW.TST.COMPLEXITY.MEASURE_DISTINCTION.127` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **claim reconciliation**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

