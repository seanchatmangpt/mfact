# REGRESSION: Regression testing

## Family law

Every escaped defect manufactures a permanent, named witness tied to the defect's causal class.

## Mandatory implementation sequence

1. Record defect date/name.
2. Reduce to the smallest reproducer.
3. Place it under a stable regression path.
4. Assert the old bad behavior cannot recur.
5. Link the regression to the relevant crown/test instance IDs.

## Core-team anti-patterns

- A vague `bugfix_test`.
- Deleting regression fixtures after refactors.
- Testing the patch implementation rather than the escaped behavior.

## Lean/Lake skeleton

```lean
namespace Regression.Y2026M07D13.StandingForgery

example : ¬ ForgeableStanding := by
  ...

end Regression.Y2026M07D13.StandingForgery
```

## Test instances in this family

## T062 — Regression test

**Stable instance:** `MFW.TST.REGRESSION.ESCAPED_DEFECT.062`

**Question:** Does a previously escaped defect remain permanently caught?

**Canonical mechanism:** `one bug→one fixture`

**Canonical MFW instance:** SocketShadow / StandingForgery / ParallelProjection

### LLM implementation recipe

1. Declare `MFW.TST.REGRESSION.ESCAPED_DEFECT.062` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **one bug→one fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

