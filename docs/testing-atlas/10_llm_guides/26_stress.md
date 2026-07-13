# STRESS: Stress and scale testing

## Family law

Stress tests locate resource or combinatorial failure boundaries; they are not speed benchmarks.

## Mandatory implementation sequence

1. Choose one stress dimension.
2. Generate a monotone parameter sweep.
3. Record first refusal/failure/resource limit.
4. Distinguish intentional bounded refusal from uncontrolled crash.
5. Turn unexpected crashes into regression fixtures.

## Core-team anti-patterns

- Changing many stress dimensions simultaneously.
- Treating timeout as proof of asymptotic complexity.
- Ignoring expected boundary/refusal semantics.

## Lean/Lake skeleton

```lean
for n in stressSizes do
  let result ← runFixture n
  record n result
-- classify: admitted / bounded-refusal / heartbeat / memory / crash
```

## Test instances in this family

## T118 — Stress/scale test

**Stable instance:** `MFW.TST.STRESS.SCALE.118`

**Question:** At what input scale does the system fail or exceed resources?

**Canonical mechanism:** `parameter sweep`

**Canonical MFW instance:** workflow worlds / theorem count

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.SCALE.118` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **parameter sweep**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T119 — Stack overflow test

**Stable instance:** `MFW.TST.STRESS.STACK.119`

**Question:** Can deep recursion overflow the execution stack?

**Canonical mechanism:** `deep fixture`

**Canonical MFW instance:** workflow bind

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.STACK.119` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **deep fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T120 — Recursion limit test

**Stable instance:** `MFW.TST.STRESS.RECURSION.120`

**Question:** Does recursion-depth policy refuse or fail at the intended boundary?

**Canonical mechanism:** `deep syntax fixture`

**Canonical MFW instance:** recursive workflow

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.RECURSION.120` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **deep syntax fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T121 — Heartbeat exhaustion test

**Stable instance:** `MFW.TST.STRESS.HEARTBEAT.121`

**Question:** Can elaboration/proof search exceed heartbeat bounds?

**Canonical mechanism:** `bounded heartbeat fixture`

**Canonical MFW instance:** expensive proof search

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.HEARTBEAT.121` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **bounded heartbeat fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T122 — Memory exhaustion test

**Stable instance:** `MFW.TST.STRESS.MEMORY.122`

**Question:** What input triggers unacceptable memory growth?

**Canonical mechanism:** `large finite fixture`

**Canonical MFW instance:** residue enumeration

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.MEMORY.122` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **large finite fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T123 — Typeclass explosion test

**Stable instance:** `MFW.TST.STRESS.TYPECLASS.123`

**Question:** Can instance search branch pathologically?

**Canonical mechanism:** `instance graph fixture`

**Canonical MFW instance:** semantic coordinate classes

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.TYPECLASS.123` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **instance graph fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T124 — Elaboration blowup test

**Stable instance:** `MFW.TST.STRESS.ELAB_BLOWUP.124`

**Question:** Can generated syntax cause superlinear elaboration failure?

**Canonical mechanism:** `parametric generated module`

**Canonical MFW instance:** deep TWorkflow

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.ELAB_BLOWUP.124` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **parametric generated module**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T125 — Exponential residue generation test

**Stable instance:** `MFW.TST.STRESS.EXP_RESIDUE.125`

**Question:** Does exhaustive support enumeration show expected exponential boundary?

**Canonical mechanism:** `n-support sweep`

**Canonical MFW instance:** minimal residue

### LLM implementation recipe

1. Declare `MFW.TST.STRESS.EXP_RESIDUE.125` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **n-support sweep**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

