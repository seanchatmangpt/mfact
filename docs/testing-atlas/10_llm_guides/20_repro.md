# REPRO: Determinism and reproducibility testing

## Family law

Reproducibility tests compare semantic artifacts and standing under controlled execution variations.

## Mandatory implementation sequence

1. Freeze source/toolchain/dependency inputs.
2. Run two declared execution modes.
3. Canonicalize allowed nondeterminism.
4. Compare artifact hashes, theorem inventory, and standing.
5. Keep Lake trace freshness distinct from consequence receipts.

## Core-team anti-patterns

- Comparing timestamps.
- Calling equal build traces equal semantic consequences.
- Ignoring file enumeration nondeterminism.

## Lean/Lake skeleton

```lean
sameSource ∧ sameToolchain ∧ sameManifest
→ digest(run modeA) = digest(run modeB)
→ standing(run modeA) = standing(run modeB)
```

## Test instances in this family

## T077 — Repeatability/determinism test

**Stable instance:** `MFW.TST.REPRO.REPEAT.077`

**Question:** Do repeated runs on identical admitted inputs match exactly?

**Canonical mechanism:** `repeat + digest compare`

**Canonical MFW instance:** ggen/audit repeat

### LLM implementation recipe

1. Declare `MFW.TST.REPRO.REPEAT.077` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **repeat + digest compare**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T078 — Clean-vs-incremental reproducibility

**Stable instance:** `MFW.TST.REPRO.CLEAN_INCREMENTAL.078`

**Question:** Do clean and incremental builds manufacture the same artifacts/standing?

**Canonical mechanism:** `two build modes + digest`

**Canonical MFW instance:** Lake

### LLM implementation recipe

1. Declare `MFW.TST.REPRO.CLEAN_INCREMENTAL.078` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **two build modes + digest**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T079 — Serial-vs-parallel reproducibility

**Stable instance:** `MFW.TST.REPRO.SERIAL_PARALLEL.079`

**Question:** Do serial and parallel builds agree semantically?

**Canonical mechanism:** `build modes + digest`

**Canonical MFW instance:** Lake job scheduling

### LLM implementation recipe

1. Declare `MFW.TST.REPRO.SERIAL_PARALLEL.079` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **build modes + digest**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T080 — File-enumeration-order reproducibility

**Stable instance:** `MFW.TST.REPRO.ENUM_ORDER.080`

**Question:** Does filesystem enumeration order alter outputs?

**Canonical mechanism:** `permute enumeration`

**Canonical MFW instance:** manifest generation

### LLM implementation recipe

1. Declare `MFW.TST.REPRO.ENUM_ORDER.080` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **permute enumeration**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T081 — Process-restart reproducibility

**Stable instance:** `MFW.TST.REPRO.RESTART.081`

**Question:** Does restarting the manufacturing process preserve result?

**Canonical mechanism:** `restart/replay`

**Canonical MFW instance:** ggen pipeline

### LLM implementation recipe

1. Declare `MFW.TST.REPRO.RESTART.081` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **restart/replay**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T082 — Repeated-ggen reproducibility

**Stable instance:** `MFW.TST.REPRO.GGEN_REPEAT.082`

**Question:** Does ggen reach a fixed artifact point?

**Canonical mechanism:** `run twice + no delta`

**Canonical MFW instance:** projection idempotence

### LLM implementation recipe

1. Declare `MFW.TST.REPRO.GGEN_REPEAT.082` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **run twice + no delta**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

