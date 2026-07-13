# INVENTORY: Proof dependency and theorem-inventory testing

## Family law

The theorem inventory must be exact where the crown depends on exact declarations. Existence, kind, module, axiom set, claim class, and manifest representation are separate checks.

## Mandatory implementation sequence

1. Load the compiled environment.
2. Read the expected theorem-name manifest.
3. Resolve each exact name.
4. Inspect ConstantInfo kind.
5. Collect transitive axioms.
6. Reconcile claim metadata and artifact manifest.
7. Compare actual and expected crown theorem sets.

## Core-team anti-patterns

- `theoremCount != 0`.
- Counting declarations by source keywords.
- Ignoring extra unexpected crown theorems when exact inventory is required.

## Lean/Lake skeleton

```lean
structure ExpectedTheorem where
  name : Name
  module : Name
  allowedAxioms : NameSet
  claimClass : ClaimClass

-- Compare exact expected/actual sets.
```

## Test instances in this family

## T105 — Expected theorem existence test

**Stable instance:** `MFW.TST.INVENTORY.EXISTS.105`

**Question:** Does each required theorem name exist?

**Canonical mechanism:** `environment lookup`

**Canonical MFW instance:** crown theorem manifest

### LLM implementation recipe

1. Declare `MFW.TST.INVENTORY.EXISTS.105` in the test metadata/header.
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

## T106 — Theorem kind test

**Stable instance:** `MFW.TST.INVENTORY.KIND.106`

**Question:** Is the declaration actually a theorem rather than def/axiom?

**Canonical mechanism:** `ConstantInfo inspection`

**Canonical MFW instance:** expected theorem

### LLM implementation recipe

1. Declare `MFW.TST.INVENTORY.KIND.106` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **ConstantInfo inspection**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T107 — Theorem module location test

**Stable instance:** `MFW.TST.INVENTORY.MODULE.107`

**Question:** Is the theorem exported from the intended module boundary?

**Canonical mechanism:** `module/name audit`

**Canonical MFW instance:** MFW residue theorem

### LLM implementation recipe

1. Declare `MFW.TST.INVENTORY.MODULE.107` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **module/name audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T108 — Allowed axiom dependency test

**Stable instance:** `MFW.TST.INVENTORY.AXIOM_ALLOWLIST.108`

**Question:** Are transitive theorem axioms a subset of the allowed set?

**Canonical mechanism:** `collectAxioms`

**Canonical MFW instance:** crown theorems

### LLM implementation recipe

1. Declare `MFW.TST.INVENTORY.AXIOM_ALLOWLIST.108` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **collectAxioms**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T109 — Claim class test

**Stable instance:** `MFW.TST.INVENTORY.CLAIM_CLASS.109`

**Question:** Does theorem standing/claim metadata match its permitted claim ceiling?

**Canonical mechanism:** `claim metadata reconciliation`

**Canonical MFW instance:** FINITE_VERIFIED vs PROVEN

### LLM implementation recipe

1. Declare `MFW.TST.INVENTORY.CLAIM_CLASS.109` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **claim metadata reconciliation**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T110 — Manifest representation test

**Stable instance:** `MFW.TST.INVENTORY.MANIFEST.110`

**Question:** Is each admitted theorem/artifact represented in the manifest?

**Canonical mechanism:** `environment↔manifest set equality`

**Canonical MFW instance:** mfact manifest

### LLM implementation recipe

1. Declare `MFW.TST.INVENTORY.MANIFEST.110` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **environment↔manifest set equality**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T111 — Exact theorem inventory equality test

**Stable instance:** `MFW.TST.INVENTORY.EXACT_SET.111`

**Question:** Does the actual theorem set equal the expected set?

**Canonical mechanism:** `set equality`

**Canonical MFW instance:** crown inventory

### LLM implementation recipe

1. Declare `MFW.TST.INVENTORY.EXACT_SET.111` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **set equality**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

