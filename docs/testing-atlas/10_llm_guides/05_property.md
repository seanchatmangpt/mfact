# PROPERTY: Property-based and generative testing

## Family law

Property testing searches for falsifiers; it never promotes a candidate law to PROVEN.

## Mandatory implementation sequence

1. Define the property independently of the generator.
2. Build a generator that covers ordinary and rare regimes.
3. Add shrinking with an explicit size/cost order.
4. Record seed/configuration and minimized falsifier.
5. Send surviving laws to theorem admission separately.

## Core-team anti-patterns

- Calling 100,000 samples a proof.
- Uniform generation when failures live in sparse regimes.
- A shrinker that changes the semantic class being tested.

## Lean/Lake skeleton

```lean
-- Pseudocode shape; adapt to Plausible APIs pinned in the project.
-- plausible (config := cfg) propertyName
-- Generator and shrinker must be named artifacts.
```

## Test instances in this family

## T029 — Property-based test

**Stable instance:** `MFW.TST.PROPERTY.PROPERTY_BASED.029`

**Question:** Does a law survive generated samples?

**Canonical mechanism:** `Plausible/Testable`

**Canonical MFW instance:** closure idempotence over generated carriers

### LLM implementation recipe

1. Declare `MFW.TST.PROPERTY.PROPERTY_BASED.029` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Plausible/Testable**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T030 — Random generation test

**Stable instance:** `MFW.TST.PROPERTY.RANDOM_GEN.030`

**Question:** Can generated carriers expose unexpected failures?

**Canonical mechanism:** `Plausible Gen`

**Canonical MFW instance:** receipt DAG / workflow generator

### LLM implementation recipe

1. Declare `MFW.TST.PROPERTY.RANDOM_GEN.030` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Plausible Gen**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T031 — Shrinking test

**Stable instance:** `MFW.TST.PROPERTY.SHRINK.031`

**Question:** Can a failing generated case be reduced to a smaller falsifier?

**Canonical mechanism:** `Plausible shrink / custom shrinker`

**Canonical MFW instance:** minimal workflow counterexample

### LLM implementation recipe

1. Declare `MFW.TST.PROPERTY.SHRINK.031` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Plausible shrink / custom shrinker**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T032 — Distribution-sensitive generation

**Stable instance:** `MFW.TST.PROPERTY.DISTRIBUTION.032`

**Question:** Are rare but important regimes intentionally sampled?

**Canonical mechanism:** `weighted generator`

**Canonical MFW instance:** cross-tenant and sparse-scale regimes

### LLM implementation recipe

1. Declare `MFW.TST.PROPERTY.DISTRIBUTION.032` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **weighted generator**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

