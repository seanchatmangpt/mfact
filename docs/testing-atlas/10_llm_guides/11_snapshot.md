# SNAPSHOT: Golden and snapshot testing

## Family law

Snapshots detect drift. They do not establish semantics unless paired with theorem or correspondence evidence.

## Mandatory implementation sequence

1. Choose the exact rendered surface.
2. Canonicalize nondeterministic fields.
3. Review and commit the expected artifact.
4. Fail on drift.
5. When updating, explain whether the law changed or only representation changed.

## Core-team anti-patterns

- Blindly blessing new expected output.
- Snapshotting timestamps/random IDs.
- Using a golden file as a theorem.

## Lean/Lake skeleton

```lean
-- Typical Lake/script shape:
-- produce canonical output
-- compare against reviewed expected file
-- nonzero exit on drift
```

## Test instances in this family

## T057 — Golden output test

**Stable instance:** `MFW.TST.SNAPSHOT.GOLDEN_OUTPUT.057`

**Question:** Does stdout/stderr equal the reviewed expected output?

**Canonical mechanism:** `expected file`

**Canonical MFW instance:** verifier report

### LLM implementation recipe

1. Declare `MFW.TST.SNAPSHOT.GOLDEN_OUTPUT.057` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **expected file**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T058 — Diagnostic snapshot

**Stable instance:** `MFW.TST.SNAPSHOT.DIAG_SNAPSHOT.058`

**Question:** Did public compiler/refusal diagnostics remain stable?

**Canonical mechanism:** `expected messages`

**Canonical MFW instance:** negative fixture output

### LLM implementation recipe

1. Declare `MFW.TST.SNAPSHOT.DIAG_SNAPSHOT.058` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **expected messages**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T059 — Pretty-printer snapshot

**Stable instance:** `MFW.TST.SNAPSHOT.PRETTY.059`

**Question:** Did rendered Lean syntax/terms drift?

**Canonical mechanism:** `pretty output compare`

**Canonical MFW instance:** generated declaration rendering

### LLM implementation recipe

1. Declare `MFW.TST.SNAPSHOT.PRETTY.059` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **pretty output compare**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T060 — Generated artifact snapshot

**Stable instance:** `MFW.TST.SNAPSHOT.ARTIFACT.060`

**Question:** Did canonical TTL/ggen output drift?

**Canonical mechanism:** `content/hash compare`

**Canonical MFW instance:** generated Lean module

### LLM implementation recipe

1. Declare `MFW.TST.SNAPSHOT.ARTIFACT.060` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **content/hash compare**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T061 — Manifest snapshot

**Stable instance:** `MFW.TST.SNAPSHOT.MANIFEST.061`

**Question:** Did the expected artifact graph drift?

**Canonical mechanism:** `manifest compare`

**Canonical MFW instance:** mfact artifact inventory

### LLM implementation recipe

1. Declare `MFW.TST.SNAPSHOT.MANIFEST.061` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **manifest compare**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

