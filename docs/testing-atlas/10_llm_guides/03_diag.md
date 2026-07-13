# DIAG: Diagnostic and refusal testing

## Family law

Diagnostics and refusals are public causal surfaces. Test the exact constructor, precedence, and stable message class separately.

## Mandatory implementation sequence

1. Manufacture the smallest input that triggers one refusal.
2. Pattern-match the exact refusal constructor.
3. Create a multi-failure world for precedence.
4. Use `#guard_msgs` only for Lean messages; use typed equality for domain refusals.

## Core-team anti-patterns

- Generic `UNKNOWN_ERROR`.
- Checking only `.isError`.
- Letting wording snapshots substitute for typed refusal tests.

## Lean/Lake skeleton

```lean
example : admit bad = .error Refusal.crossTenantLeak := by
  native_decide

#guard_msgs(error) in
#check forbiddenTerm
```

## Test instances in this family

## T018 — Exact diagnostic test

**Stable instance:** `MFW.TST.DIAG.EXACT.018`

**Question:** Did the exact expected compiler message occur?

**Canonical mechanism:** `#guard_msgs`

**Canonical MFW instance:** typed illegal composition diagnostic

### LLM implementation recipe

1. Declare `MFW.TST.DIAG.EXACT.018` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#guard_msgs**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T019 — Diagnostic-class test

**Stable instance:** `MFW.TST.DIAG.CLASS.019`

**Question:** Did the expected error/warning/info class occur?

**Canonical mechanism:** `#guard_msgs severity filters`

**Canonical MFW instance:** deprecation or refusal diagnostic

### LLM implementation recipe

1. Declare `MFW.TST.DIAG.CLASS.019` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#guard_msgs severity filters**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T020 — Panic test

**Stable instance:** `MFW.TST.DIAG.PANIC.020`

**Question:** Did the command panic as expected?

**Canonical mechanism:** `#guard_panic`

**Canonical MFW instance:** deliberate internal panic fixture

### LLM implementation recipe

1. Declare `MFW.TST.DIAG.PANIC.020` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#guard_panic**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T021 — Typed refusal test

**Stable instance:** `MFW.TST.DIAG.TYPED_REFUSAL.021`

**Question:** Did executable admission return the exact refusal constructor?

**Canonical mechanism:** `Except / pattern match / native_decide`

**Canonical MFW instance:** crossTenantLeak refusal

### LLM implementation recipe

1. Declare `MFW.TST.DIAG.TYPED_REFUSAL.021` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Except / pattern match / native_decide**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T022 — Refusal precedence test

**Stable instance:** `MFW.TST.DIAG.REFUSAL_PRECEDENCE.022`

**Question:** When several laws fail, which refusal has priority?

**Canonical mechanism:** `multi-failure fixture`

**Canonical MFW instance:** stale observation vs source-not-allowed

### LLM implementation recipe

1. Declare `MFW.TST.DIAG.REFUSAL_PRECEDENCE.022` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **multi-failure fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T023 — Diagnostic stability test

**Stable instance:** `MFW.TST.DIAG.STABILITY.023`

**Question:** Did a public error/refusal surface drift unexpectedly?

**Canonical mechanism:** `#guard_msgs / golden output`

**Canonical MFW instance:** stable crown refusal wording

### LLM implementation recipe

1. Declare `MFW.TST.DIAG.STABILITY.023` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **#guard_msgs / golden output**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

