# CORRESPONDENCE: Refinement and correspondence testing

## Family law

Correspondence exists only for maps inside mfact's controlled chain. Every map names the source carrier, target carrier, preserved structure, and theorem.

## Mandatory implementation sequence

1. Define source and target carriers.
2. Define the projection map.
3. Name the invariant/observable preserved.
4. Prove the commuting square.
5. For multi-stage maps, prove composition agreement.

## Core-team anti-patterns

- A structure named `AtomVMStateProjection` with no AtomVM semantics.
- Copying identical fields into two records.
- Expanding mfact's obligation into external runtime implementation.

## Lean/Lake skeleton

```lean
structure Correspondence where
  project : A → B
  preserves : ∀ x, invariantB (project x) = invariantA x

 theorem compose_agrees ... : projectBC (projectAB x) = projectAC x := by
  ...
```

## Test instances in this family

## T068 — Refinement/correspondence preservation test

**Stable instance:** `MFW.TST.CORRESPONDENCE.PRESERVE.068`

**Question:** Does a controlled map preserve the declared invariant?

**Canonical mechanism:** `map + preservation theorem`

**Canonical MFW instance:** TTL declaration→generated Lean declaration

### LLM implementation recipe

1. Declare `MFW.TST.CORRESPONDENCE.PRESERVE.068` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **map + preservation theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T069 — Correspondence composition test

**Stable instance:** `MFW.TST.CORRESPONDENCE.COMPOSE.069`

**Question:** Do composed controlled maps equal the declared direct projection?

**Canonical mechanism:** `commuting diagram theorem`

**Canonical MFW instance:** TTL→Lean→manifest vs direct claim projection

### LLM implementation recipe

1. Declare `MFW.TST.CORRESPONDENCE.COMPOSE.069` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **commuting diagram theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

