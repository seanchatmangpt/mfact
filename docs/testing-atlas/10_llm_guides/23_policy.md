# POLICY: Linter and repository-policy testing

## Family law

Repository policy tests are environment/module-graph audits. Prefer compiled declarations and exact sets over grep.

## Mandatory implementation sequence

1. Enumerate the controlled declaration/module universe.
2. Derive actual facts from the environment/import graph.
3. Compare against exact policy predicates.
4. Emit typed findings with declaration/module names.
5. Refuse standing on any required policy violation.

## Core-team anti-patterns

- Regex theorem counts.
- Searching source text for `sorry` as the sole audit.
- Allowing empty expected sets to pass accidentally.

## Lean/Lake skeleton

```lean
structure PolicyFinding where
  code : PolicyCode
  declaration? : Option Name
  module? : Option Name
  detail : String

-- Auditor returns `Except (Array PolicyFinding) PolicyReceipt`.
```

## Test instances in this family

## T095 — No-sorry policy test

**Stable instance:** `MFW.TST.POLICY.NO_SORRY.095`

**Question:** Are controlled declarations free of sorryAx dependencies?

**Canonical mechanism:** `environment auditor`

**Canonical MFW instance:** ProcInt

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.NO_SORRY.095` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **environment auditor**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T096 — No-admit policy test

**Stable instance:** `MFW.TST.POLICY.NO_ADMIT.096`

**Question:** Are proof-admission escape hatches absent from controlled source?

**Canonical mechanism:** `syntax/environment audit`

**Canonical MFW instance:** ProcInt

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.NO_ADMIT.096` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **syntax/environment audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T097 — Forbidden-import policy test

**Stable instance:** `MFW.TST.POLICY.FORBIDDEN_IMPORT.097`

**Question:** Are disallowed imports absent?

**Canonical mechanism:** `environment/module graph audit`

**Canonical MFW instance:** N3/default escape-hatch modules

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.FORBIDDEN_IMPORT.097` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **environment/module graph audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T098 — No giant Mathlib umbrella import test

**Stable instance:** `MFW.TST.POLICY.NO_UMBRELLA.098`

**Question:** Are leaf modules using bounded imports?

**Canonical mechanism:** `import graph policy`

**Canonical MFW instance:** core theorem modules

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.NO_UMBRELLA.098` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **import graph policy**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T099 — Semantic-coordinate completeness test

**Stable instance:** `MFW.TST.POLICY.SEMANTIC_COORDS.099`

**Question:** Does every public declaration expose required semantic coordinates?

**Canonical mechanism:** `declaration metadata auditor`

**Canonical MFW instance:** Law/Carrier/Admission/Preserves/Refuses/Claim ceiling

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.SEMANTIC_COORDS.099` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **declaration metadata auditor**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T100 — Every RefusalCode tested policy

**Stable instance:** `MFW.TST.POLICY.REFUSAL_COVERAGE.100`

**Question:** Does each refusal constructor have a positive trigger fixture?

**Canonical mechanism:** `constructor inventory vs tests`

**Canonical MFW instance:** typed refusal algebra

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.REFUSAL_COVERAGE.100` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **constructor inventory vs tests**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T101 — Every crown theorem countermodel-card policy

**Stable instance:** `MFW.TST.POLICY.COUNTERMODEL_CARD.101`

**Question:** Does each crown claim name hypothesis-removal/countermodel obligations?

**Canonical mechanism:** `claim-card auditor`

**Canonical MFW instance:** crown theorem rail

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.COUNTERMODEL_CARD.101` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **claim-card auditor**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T102 — Generated provenance policy

**Stable instance:** `MFW.TST.POLICY.PROVENANCE.102`

**Question:** Does each generated artifact carry canonical provenance?

**Canonical mechanism:** `manifest/env audit`

**Canonical MFW instance:** ggen outputs

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.PROVENANCE.102` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **manifest/env audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T103 — Claimed theorem exists policy

**Stable instance:** `MFW.TST.POLICY.CLAIM_EXISTS.103`

**Question:** Does every machine-readable claim resolve to a real theorem declaration?

**Canonical mechanism:** `environment lookup`

**Canonical MFW instance:** claim matrix

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.CLAIM_EXISTS.103` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **environment lookup**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T104 — No orphan modules policy

**Stable instance:** `MFW.TST.POLICY.NO_ORPHANS.104`

**Question:** Is every intended module reachable from a declared build/import root?

**Canonical mechanism:** `module graph reachability`

**Canonical MFW instance:** ProcInt umbrella

### LLM implementation recipe

1. Declare `MFW.TST.POLICY.NO_ORPHANS.104` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **module graph reachability**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

