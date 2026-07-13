# FINITE: Executable finite testing

## Family law

Finite executable evidence is bounded evidence. `#guard` is untrusted evaluation; `native_decide` can produce a proof for a decidable proposition but does not generalize beyond the encoded finite proposition.

## Mandatory implementation sequence

1. State the finite universe explicitly.
2. Choose `#guard` for executable smoke checks.
3. Choose `native_decide` for decidable proof obligations.
4. Record checked-case counts from execution, never from input length after short-circuiting.

## Core-team anti-patterns

- Promoting finite verification to general theorem standing.
- Reporting unvisited cases as checked.
- Hiding the finite universe in generator code.

## Lean/Lake skeleton

```lean
#guard classifier sample = expected

example : ∀ x ∈ finiteWorlds, invariant x := by
  native_decide
```

## Test instances in this family

## T024 — Boolean guard test

**Stable instance:** `MFW.TST.FINITE.BOOL_GUARD.024`

**Question:** Does an executable Bool evaluate to true?

**Canonical mechanism:** `#guard`

**Canonical MFW instance:** regime classifier case

### LLM implementation recipe

1. Declare `MFW.TST.FINITE.BOOL_GUARD.024` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#guard**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T025 — Finite decision test

**Stable instance:** `MFW.TST.FINITE.DECIDE.025`

**Question:** Does a decidable proposition hold on a concrete finite witness?

**Canonical mechanism:** `decide / example`

**Canonical MFW instance:** receipt ancestry property

### LLM implementation recipe

1. Declare `MFW.TST.FINITE.DECIDE.025` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **decide / example**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T026 — Native decision test

**Stable instance:** `MFW.TST.FINITE.NATIVE_DECIDE.026`

**Question:** Can compiled decision produce a proof of the proposition?

**Canonical mechanism:** `native_decide`

**Canonical MFW instance:** finite world invariant

### LLM implementation recipe

1. Declare `MFW.TST.FINITE.NATIVE_DECIDE.026` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **native_decide**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T027 — Example-table test

**Stable instance:** `MFW.TST.FINITE.TABLE.027`

**Question:** Do named finite cases match expected outputs?

**Canonical mechanism:** `List cases + assertions`

**Canonical MFW instance:** singularity routing table

### LLM implementation recipe

1. Declare `MFW.TST.FINITE.TABLE.027` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **List cases + assertions**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T028 — Exhaustive finite-domain test

**Stable instance:** `MFW.TST.FINITE.EXHAUSTIVE.028`

**Question:** Does the property hold for every value in an explicit finite universe?

**Canonical mechanism:** `Fintype/list universe + native_decide`

**Canonical MFW instance:** all TinyWorkflow worlds at depth n

### LLM implementation recipe

1. Declare `MFW.TST.FINITE.EXHAUSTIVE.028` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Fintype/list universe + native_decide**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

