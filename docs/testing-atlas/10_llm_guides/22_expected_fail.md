# EXPECTED_FAIL: Expected-failure build testing

## Family law

An expected-failure fixture succeeds only when the illegal module/package fails for the intended reason.

## Mandatory implementation sequence

1. Place the illegal case in an isolated fixture.
2. Run Lean/Lake expecting nonzero exit.
3. Capture the intended diagnostic class or exact message.
4. Fail if it unexpectedly builds.
5. Fail if it fails for an unrelated parse/import error.

## Core-team anti-patterns

- Any nonzero exit counts as success.
- Broken fixture path masquerading as type rejection.
- Using only inline `#guard_msgs` when package-level reachability is the law.

## Lean/Lake skeleton

```lean
MustFail/
  StandingForgery.lean
  CrossTenantGraft.lean
  MissingDescent.lean

# Harness verifies expected nonzero exit plus intended diagnostic.
```

## Test instances in this family

## T094 — Expected-failure build test

**Stable instance:** `MFW.TST.EXPECTED_FAIL.BUILD.094`

**Question:** Does an illegal module/package fail to elaborate or build?

**Canonical mechanism:** `failing fixture package`

**Canonical MFW instance:** StandingForgery / CrossTenantGraft / MissingDescent

### LLM implementation recipe

1. Declare `MFW.TST.EXPECTED_FAIL.BUILD.094` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **failing fixture package**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

