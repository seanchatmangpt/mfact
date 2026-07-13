# COUNTERMODEL: Counterexample and countermodel testing

## Family law

Counterexample work must distinguish first failure, least-cost failure, and a genuine model showing a theorem boundary is necessary.

## Mandatory implementation sequence

1. Name the candidate stronger claim.
2. Remove exactly one hypothesis or weaken one law.
3. Construct a witness satisfying the remaining assumptions.
4. Prove the conclusion fails.
5. For minimal counterexamples, prove minimality under the declared order rather than attaching a cost field.

## Core-team anti-patterns

- Returning the first failure and calling it minimal.
- Changing multiple hypotheses at once.
- A negative example that also violates the original theorem assumptions.

## Lean/Lake skeleton

```lean
structure Countermodel where
  world : World
  remainingAssumptions : Remaining world
  conclusionFails : ¬ Conclusion world

-- For minimality, include:
-- ∀ y, cost y < cost world → Candidate y
```

## Test instances in this family

## T050 — Counterexample test

**Stable instance:** `MFW.TST.COUNTERMODEL.COUNTEREXAMPLE.050`

**Question:** Can a concrete witness refute a candidate law?

**Canonical mechanism:** `finite witness`

**Canonical MFW instance:** mutant workflow law

### LLM implementation recipe

1. Declare `MFW.TST.COUNTERMODEL.COUNTEREXAMPLE.050` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **finite witness**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T051 — Minimal counterexample test

**Stable instance:** `MFW.TST.COUNTERMODEL.MIN_COUNTEREXAMPLE.051`

**Question:** Is the reported falsifier least under an explicit cost/order?

**Canonical mechanism:** `argmin + proof/witness`

**Canonical MFW instance:** least-cost failing architecture world

### LLM implementation recipe

1. Declare `MFW.TST.COUNTERMODEL.MIN_COUNTEREXAMPLE.051` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **argmin + proof/witness**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T052 — Countermodel test

**Stable instance:** `MFW.TST.COUNTERMODEL.COUNTERMODEL.052`

**Question:** Can a model satisfy weakened assumptions while falsifying the stronger conclusion?

**Canonical mechanism:** `construct model`

**Canonical MFW instance:** infinite-transition crown countermodel

### LLM implementation recipe

1. Declare `MFW.TST.COUNTERMODEL.COUNTERMODEL.052` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **construct model**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T053 — Hypothesis-removal test

**Stable instance:** `MFW.TST.COUNTERMODEL.HYP_REMOVAL.053`

**Question:** Does removing hypothesis H permit conclusion failure?

**Canonical mechanism:** `companion theorem fixture`

**Canonical MFW instance:** tenancy without Separated

### LLM implementation recipe

1. Declare `MFW.TST.COUNTERMODEL.HYP_REMOVAL.053` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **companion theorem fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T054 — Boundary test

**Stable instance:** `MFW.TST.COUNTERMODEL.BOUNDARY.054`

**Question:** Is the exact theorem fence necessary?

**Canonical mechanism:** `paired positive/negative worlds`

**Canonical MFW instance:** Finite T boundary

### LLM implementation recipe

1. Declare `MFW.TST.COUNTERMODEL.BOUNDARY.054` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **paired positive/negative worlds**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

