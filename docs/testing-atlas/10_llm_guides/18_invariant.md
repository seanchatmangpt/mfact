# INVARIANT: Invariant preservation testing

## Family law

Invariant preservation is a transition theorem: if I holds before an admitted step, I holds after.

## Mandatory implementation sequence

1. Define `Invariant : State → Prop`.
2. Define admitted transition relation/function.
3. Prove preservation for every constructor/path.
4. Generate bounded states and attack the theorem's executable implementation.
5. Add a conflict/counterexample for non-admitted steps.

## Core-team anti-patterns

- Checking the invariant only at the initial state.
- A Boolean validator with no refusal cause when causality matters.
- Calling a syntax metric an operational invariant.

## Lean/Lake skeleton

```lean
def Preserves (step : State → State) (I : State → Prop) : Prop :=
  ∀ s, I s → I (step s)

theorem admittedStep_preserves : Preserves admittedStep Invariant := by
  ...
```

## Test instances in this family

## T070 — Invariant preservation test

**Stable instance:** `MFW.TST.INVARIANT.PRESERVATION.070`

**Question:** Does every admitted transition preserve invariant I?

**Canonical mechanism:** `Preserves theorem + generated attack`

**Canonical MFW instance:** zero unreceipted completion / tenant separation

### LLM implementation recipe

1. Declare `MFW.TST.INVARIANT.PRESERVATION.070` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Preserves theorem + generated attack**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

