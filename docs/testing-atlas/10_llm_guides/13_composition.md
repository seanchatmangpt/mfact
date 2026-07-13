# COMPOSITION: Cross-theorem composition testing

## Family law

Composition tests require one shared concrete object to cross theorem boundaries. Adjacent theorem names in a file are not composition.

## Mandatory implementation sequence

1. Choose one concrete carrier.
2. Apply theorem A and retain its exact output/witness.
3. Feed that witness into theorem B.
4. Continue without rebuilding an unrelated analogue.
5. Prove the terminal consequence.

## Core-team anti-patterns

- Six unrelated examples with similar names.
- Reconstructing each layer from hand-authored data.
- Using prose arrows as correspondence edges.

## Lean/Lake skeleton

```lean
def world : World := ...

theorem composed : Final world := by
  have hA : A world := theoremA ...
  have hB : B world := theoremB hA
  have hC : C world := theoremC hB
  exact theoremFinal hC
```

## Test instances in this family

## T063 — Composition test

**Stable instance:** `MFW.TST.COMPOSITION.CROSS_THEOREM.063`

**Question:** Do neighboring theorem layers connect on the same concrete object?

**Canonical mechanism:** `shared carrier + chained proofs`

**Canonical MFW instance:** Closure→Residue→Tenancy→Execution→Replay

### LLM implementation recipe

1. Declare `MFW.TST.COMPOSITION.CROSS_THEOREM.063` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **shared carrier + chained proofs**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

