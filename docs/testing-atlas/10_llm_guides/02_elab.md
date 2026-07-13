# ELAB: Elaboration and type-system testing

## Family law

Elaboration tests verify syntax, inferred indices, instance search, and proof-state shape. They do not prove mathematical semantics.

## Mandatory implementation sequence

1. Write a positive elaboration witness.
2. Write a localized negative witness with `#guard_msgs`.
3. Use `guard_expr`, `guard_target`, or `guard_hyp` when exact elaborated shape matters.
4. Keep illegal composition absent from the type, then test the diagnostic surface.

## Core-team anti-patterns

- Using `#check` only for positive cases.
- Calling a type mismatch a semantic theorem.
- Relying on autoImplicit to invent missing indices.

## Lean/Lake skeleton

```lean
#guard_msgs(error) in
#check illegalComposition

example : Goal := by
  guard_target = Goal
  exact proof
```

## Test instances in this family

## T009 — Positive elaboration test

**Stable instance:** `MFW.TST.ELAB.POSITIVE.009`

**Question:** Does intended syntax and type inference elaborate?

**Canonical mechanism:** `example/#check`

**Canonical MFW instance:** lawful TWorkflow composition

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.POSITIVE.009` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **example/#check**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T010 — Negative elaboration test

**Stable instance:** `MFW.TST.ELAB.NEGATIVE.010`

**Question:** Is illegal code rejected by elaboration?

**Canonical mechanism:** `#guard_msgs(error)`

**Canonical MFW instance:** illegal color composition

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.NEGATIVE.010` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#guard_msgs(error)**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T011 — Type mismatch fixture

**Stable instance:** `MFW.TST.ELAB.TYPE_MISMATCH.011`

**Question:** Does a forbidden indexed composition fail to type?

**Canonical mechanism:** `#guard_msgs(error) in #check`

**Canonical MFW instance:** raw→plan composed with receipt→replay

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.TYPE_MISMATCH.011` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#guard_msgs(error) in #check**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T012 — Instance synthesis test

**Stable instance:** `MFW.TST.ELAB.INSTANCE_SYNTH.012`

**Question:** Is the expected typeclass instance found?

**Canonical mechanism:** `#synth / elaboration`

**Canonical MFW instance:** DecidableEq / Fintype / LawfulBEq

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.INSTANCE_SYNTH.012` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#synth / elaboration**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T013 — Definitional equality test

**Stable instance:** `MFW.TST.ELAB.DEFEQ.013`

**Question:** Are expressions equal under reducible definitional equality?

**Canonical mechanism:** `guard_expr =`

**Canonical MFW instance:** normalized workflow expression

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.DEFEQ.013` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **guard_expr =**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T014 — Syntactic equality test

**Stable instance:** `MFW.TST.ELAB.SYNTACTIC_EQ.014`

**Question:** Are expressions structurally identical?

**Canonical mechanism:** `guard_expr =ₛ`

**Canonical MFW instance:** ggen-emitted term shape

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.SYNTACTIC_EQ.014` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **guard_expr =ₛ**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T015 — Alpha-equivalence test

**Stable instance:** `MFW.TST.ELAB.ALPHA_EQ.015`

**Question:** Are expressions equivalent modulo binder names?

**Canonical mechanism:** `guard_expr =ₐ`

**Canonical MFW instance:** generated theorem binder renaming

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.ALPHA_EQ.015` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **guard_expr =ₐ**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T016 — Goal-shape test

**Stable instance:** `MFW.TST.ELAB.GOAL_SHAPE.016`

**Question:** Did a tactic leave exactly the intended target?

**Canonical mechanism:** `guard_target`

**Canonical MFW instance:** residue proof subgoal shape

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.GOAL_SHAPE.016` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **guard_target**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T017 — Hypothesis-shape test

**Stable instance:** `MFW.TST.ELAB.HYP_SHAPE.017`

**Question:** Did elaboration/tactic state produce the intended local context?

**Canonical mechanism:** `guard_hyp`

**Canonical MFW instance:** closure assumptions in context

### LLM implementation recipe

1. Declare `MFW.TST.ELAB.HYP_SHAPE.017` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **guard_hyp**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

