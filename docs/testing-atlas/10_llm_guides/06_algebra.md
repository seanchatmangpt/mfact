# ALGEBRA: Algebraic law testing

## Family law

Algebraic laws should be theorem rails plus independent generated attacks on concrete instances.

## Mandatory implementation sequence

1. State the law generically.
2. Prove it under explicit assumptions.
3. Specialize it to a real MFW carrier.
4. Generate concrete values and attack the specialized implementation.
5. Add a mutant that violates the law where practical.

## Core-team anti-patterns

- Proving a tautological copy of the implementation.
- Using one handpicked example as the law.
- Naming syntax `free monad` without the universal property if that is the claim.

## Lean/Lake skeleton

```lean
theorem op_assoc (a b c : α) :
    op (op a b) c = op a (op b c) := by
  ...

example : op (op concreteA concreteB) concreteC =
    op concreteA (op concreteB concreteC) := by
  exact op_assoc _ _ _
```

## Test instances in this family

## T033 — Identity law test

**Stable instance:** `MFW.TST.ALGEBRA.IDENTITY.033`

**Question:** Does the identity law hold?

**Canonical mechanism:** `theorem + generated attack`

**Canonical MFW instance:** Workflow.bind right identity

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.IDENTITY.033` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem + generated attack**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T034 — Associativity test

**Stable instance:** `MFW.TST.ALGEBRA.ASSOCIATIVITY.034`

**Question:** Does associativity hold?

**Canonical mechanism:** `theorem + generated attack`

**Canonical MFW instance:** Workflow.bind associativity

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.ASSOCIATIVITY.034` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem + generated attack**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T035 — Idempotence test

**Stable instance:** `MFW.TST.ALGEBRA.IDEMPOTENCE.035`

**Question:** Does applying the operator twice equal once?

**Canonical mechanism:** `theorem + property attack`

**Canonical MFW instance:** closure idempotence

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.IDEMPOTENCE.035` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem + property attack**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T036 — Monotonicity test

**Stable instance:** `MFW.TST.ALGEBRA.MONOTONICITY.036`

**Question:** Does order preservation hold?

**Canonical mechanism:** `theorem`

**Canonical MFW instance:** closure monotonicity

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.MONOTONICITY.036` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T037 — Extensivity test

**Stable instance:** `MFW.TST.ALGEBRA.EXTENSIVITY.037`

**Question:** Is the input contained in its closure?

**Canonical mechanism:** `theorem`

**Canonical MFW instance:** closure extensivity

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.EXTENSIVITY.037` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T038 — Commutativity test

**Stable instance:** `MFW.TST.ALGEBRA.COMMUTATIVITY.038`

**Question:** Do independent operations commute?

**Canonical mechanism:** `theorem + generated attack`

**Canonical MFW instance:** independent replay steps

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.COMMUTATIVITY.038` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem + generated attack**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T039 — Absorption test

**Stable instance:** `MFW.TST.ALGEBRA.ABSORPTION.039`

**Question:** Does the domain-specific absorption law hold?

**Canonical mechanism:** `theorem`

**Canonical MFW instance:** normalization/closure absorption

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.ABSORPTION.039` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T040 — Distributivity test

**Stable instance:** `MFW.TST.ALGEBRA.DISTRIBUTIVITY.040`

**Question:** Does composition distribute over the declared operator?

**Canonical mechanism:** `theorem`

**Canonical MFW instance:** workflow/process algebra law

### LLM implementation recipe

1. Declare `MFW.TST.ALGEBRA.DISTRIBUTIVITY.040` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

