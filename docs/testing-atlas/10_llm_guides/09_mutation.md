# MUTATION: Mutation testing

## Family law

A mutation suite is valuable only when a named witness kills a deliberate semantic defect.

## Mandatory implementation sequence

1. Copy the smallest semantic unit into a named mutant.
2. Change exactly one law.
3. Reuse the same observable used by the real implementation.
4. Construct a killer witness.
5. Assert real and mutant results differ.

## Core-team anti-patterns

- Mutants that do not compile.
- Changing many behaviors at once.
- Counting a mutant as killed because an unrelated lint failed.

## Lean/Lake skeleton

```lean
def mutant : X → Y := ... -- one deliberate law violation

example : real killer ≠ mutant killer := by
  native_decide
```

## Test instances in this family

## T055 — Mutation test

**Stable instance:** `MFW.TST.MUTATION.KILL_MUTANT.055`

**Question:** Would the suite fail if a known-bad implementation replaced the real one?

**Canonical mechanism:** `named mutant + killer witness`

**Canonical MFW instance:** bindDropSeqRight / closureWithoutIdempotence / replayReverseParents

### LLM implementation recipe

1. Declare `MFW.TST.MUTATION.KILL_MUTANT.055` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **named mutant + killer witness**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

