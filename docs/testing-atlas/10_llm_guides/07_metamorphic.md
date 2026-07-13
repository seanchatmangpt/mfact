# METAMORPHIC: Metamorphic testing

## Family law

A metamorphic test transforms an input lawfully and demands preservation of a declared observable. The transformation and preserved observable must both be explicit.

## Mandatory implementation sequence

1. Define `transform : X → X`.
2. Define `observe : X → Y`.
3. State the admission condition for the transform.
4. Prove or finitely test `observe (transform x) = observe x`.
5. Add a non-admitted transform that demonstrates why the condition matters.

## Core-team anti-patterns

- Comparing raw bytes when semantic canonicalization is the law.
- Calling arbitrary perturbation metamorphic.
- Forgetting to state what is preserved.

## Lean/Lake skeleton

```lean
def LawfulTransform (x : X) : Prop := ...

theorem metamorphic_preserves
    (x : X) (h : LawfulTransform x) :
    observe (transform x) = observe x := by
  ...
```

## Test instances in this family

## T041 — Independent event reordering test

**Stable instance:** `MFW.TST.METAMORPHIC.EVENT_REORDER.041`

**Question:** Does lawful reordering preserve consequence?

**Canonical mechanism:** `transform input then compare outputs`

**Canonical MFW instance:** swap independent receipt events

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.EVENT_REORDER.041` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **transform input then compare outputs**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T042 — Graph triple reordering test

**Stable instance:** `MFW.TST.METAMORPHIC.TRIPLE_REORDER.042`

**Question:** Does triple order preserve canonical semantic result?

**Canonical mechanism:** `permute triples`

**Canonical MFW instance:** RDF graph canonicalization

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.TRIPLE_REORDER.042` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **permute triples**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T043 — Blank-node canonicalization test

**Stable instance:** `MFW.TST.METAMORPHIC.BNODE_CANON.043`

**Question:** Does reserialization/canonicalization preserve bound identity?

**Canonical mechanism:** `rename/canonicalize/compare`

**Canonical MFW instance:** skos:notation binding handles

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.BNODE_CANON.043` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **rename/canonicalize/compare**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T044 — Duplicate observation elimination test

**Stable instance:** `MFW.TST.METAMORPHIC.DUP_OBS.044`

**Question:** Does duplicating an admitted observation leave consequence unchanged?

**Canonical mechanism:** `duplicate then normalize`

**Canonical MFW instance:** observation dedup

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.DUP_OBS.044` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **duplicate then normalize**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T045 — Workflow normalization test

**Stable instance:** `MFW.TST.METAMORPHIC.WORKFLOW_NORM.045`

**Question:** Does normalization preserve workflow consequence?

**Canonical mechanism:** `normalize/interpret compare`

**Canonical MFW instance:** seq/par normal form

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.WORKFLOW_NORM.045` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **normalize/interpret compare**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T046 — Scale refinement test

**Stable instance:** `MFW.TST.METAMORPHIC.SCALE_REFINE.046`

**Question:** Does lawful refinement preserve the expected aggregate/spectrum relation?

**Canonical mechanism:** `refine partition/scale`

**Canonical MFW instance:** multifractal scale schedule

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.SCALE_REFINE.046` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **refine partition/scale**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T047 — Equivalent partition representation test

**Stable instance:** `MFW.TST.METAMORPHIC.PARTITION_EQ.047`

**Question:** Do equivalent partitions yield equal admitted observables?

**Canonical mechanism:** `reencode partition`

**Canonical MFW instance:** joint moment field

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.PARTITION_EQ.047` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **reencode partition**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T048 — Receipt replay metamorphic test

**Stable instance:** `MFW.TST.METAMORPHIC.RECEIPT_REPLAY.048`

**Question:** Does replay of an equivalent trace preserve final consequence?

**Canonical mechanism:** `TraceEq/replay compare`

**Canonical MFW instance:** receipt DAG trace

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.RECEIPT_REPLAY.048` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **TraceEq/replay compare**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T049 — Tenant permutation test

**Stable instance:** `MFW.TST.METAMORPHIC.TENANT_PERM.049`

**Question:** Does bijective tenant renaming preserve isolation laws?

**Canonical mechanism:** `rename tenant tags`

**Canonical MFW instance:** tenancy residue

### LLM implementation recipe

1. Declare `MFW.TST.METAMORPHIC.TENANT_PERM.049` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **rename tenant tags**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

