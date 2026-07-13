# LAKE: Lake and package testing

## Family law

Lake tests verify package graph, targets, test-driver wiring, and build behavior. They do not replace theorem tests.

## Mandatory implementation sequence

1. Test package configuration and dependency pins.
2. Build each public library/executable target.
3. Exercise custom standing projections as separate targets.
4. Test the configured `lake test` driver.
5. Use a downstream fixture package.
6. Compare clean/incremental and selected-target behavior.

## Core-team anti-patterns

- One `lake build` as the entire suite.
- A test driver that succeeds with zero expected checks.
- Custom targets that only print prose status.

## Lean/Lake skeleton

```lean
-- lakefile target surface should expose orthogonal projections:
-- standing
-- claims
-- refusals
-- correspondence
-- residue
-- receipts
-- replay
-- crown
```

## Test instances in this family

## T083 — Package configuration test

**Stable instance:** `MFW.TST.LAKE.PACKAGE_CONFIG.083`

**Question:** Does lakefile configuration resolve as intended?

**Canonical mechanism:** `lake package test`

**Canonical MFW instance:** pinned toolchain and targets

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.PACKAGE_CONFIG.083` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **lake package test**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T084 — Dependency resolution test

**Stable instance:** `MFW.TST.LAKE.DEPENDENCY.084`

**Question:** Are exact dependencies/revisions resolved?

**Canonical mechanism:** `lake update/manifest audit`

**Canonical MFW instance:** mathlib pin

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.DEPENDENCY.084` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **lake update/manifest audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T085 — Library build test

**Stable instance:** `MFW.TST.LAKE.LIB_BUILD.085`

**Question:** Does the declared Lean library build?

**Canonical mechanism:** `lake build Lib`

**Canonical MFW instance:** ProcInt

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.LIB_BUILD.085` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **lake build Lib**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T086 — Executable build test

**Stable instance:** `MFW.TST.LAKE.EXE_BUILD.086`

**Question:** Does the executable target build?

**Canonical mechanism:** `lake build exe`

**Canonical MFW instance:** verifier

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.EXE_BUILD.086` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **lake build exe**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T087 — Custom target test

**Stable instance:** `MFW.TST.LAKE.CUSTOM_TARGET.087`

**Question:** Does a custom Lake target manufacture its declared projection?

**Canonical mechanism:** `lake build target`

**Canonical MFW instance:** standing/claims/residue

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.CUSTOM_TARGET.087` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **lake build target**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T088 — Test driver test

**Stable instance:** `MFW.TST.LAKE.TEST_DRIVER.088`

**Question:** Does lake test execute the configured test driver?

**Canonical mechanism:** `lake test`

**Canonical MFW instance:** crown verifier

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.TEST_DRIVER.088` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **lake test**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T089 — Package-as-dependency test

**Stable instance:** `MFW.TST.LAKE.AS_DEP.089`

**Question:** Can a downstream Lake package import the public surface?

**Canonical mechanism:** `fixture package`

**Canonical MFW instance:** consumer of ProcInt

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.AS_DEP.089` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **fixture package**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T090 — Clean build test

**Stable instance:** `MFW.TST.LAKE.CLEAN_BUILD.090`

**Question:** Does a fresh checkout/cache state build?

**Canonical mechanism:** `clean + build`

**Canonical MFW instance:** release boundary

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.CLEAN_BUILD.090` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **clean + build**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T091 — Incremental build test

**Stable instance:** `MFW.TST.LAKE.INCREMENTAL.091`

**Question:** Does a targeted change rebuild only/admit the expected targets?

**Canonical mechanism:** `touch/change + Lake trace audit`

**Canonical MFW instance:** dependency graph

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.INCREMENTAL.091` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **touch/change + Lake trace audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T092 — Build target selection test

**Stable instance:** `MFW.TST.LAKE.TARGET_SELECT.092`

**Question:** Do named targets build the intended projection only?

**Canonical mechanism:** `lake build target`

**Canonical MFW instance:** standing vs claims

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.TARGET_SELECT.092` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **lake build target**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T093 — Install/release behavior test

**Stable instance:** `MFW.TST.LAKE.INSTALL_RELEASE.093`

**Question:** Does install/release packaging preserve expected files and metadata?

**Canonical mechanism:** `package/release fixture`

**Canonical MFW instance:** mfact release

### LLM implementation recipe

1. Declare `MFW.TST.LAKE.INSTALL_RELEASE.093` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **package/release fixture**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

