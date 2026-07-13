# FAITHFULNESS: Faithfulness and claim-ceiling testing

## Family law

A claim card must not say more than the theorem AST and declared hypotheses support.

## Mandatory implementation sequence

1. Encode claim ID, theorem name, carrier, hypotheses, conclusion, exclusions, falsifier, and ceiling.
2. Resolve the theorem declaration.
3. Compare claim metadata to machine-derived theorem/inventory facts.
4. Require human-reviewed semantic mapping only where AST equality cannot express meaning.
5. Refuse claim promotion on mismatch.

## Core-team anti-patterns

- 'Global replay unique' attached to two Nat increments commuting.
- Using theorem names as semantic evidence.
- Treating docstrings as sole machine-checkable carriers.

## Lean/Lake skeleton

```lean
structure ClaimCard where
  claimId : String
  theoremName : Name
  carrier : String
  hypotheses : Array String
  conclusion : String
  exclusions : Array String
  falsifier : String
  ceiling : ClaimCeiling
```

## Test instances in this family

## T131 — Faithfulness/claim-ceiling test

**Stable instance:** `MFW.TST.FAITHFULNESS.CLAIM_CEILING.131`

**Question:** Does the theorem statement actually justify the prose/machine claim attached to it?

**Canonical mechanism:** `claim card ↔ theorem AST/metadata audit`

**Canonical MFW instance:** global replay claim vs local Nat commutation

### LLM implementation recipe

1. Declare `MFW.TST.FAITHFULNESS.CLAIM_CEILING.131` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **claim card ↔ theorem AST/metadata audit**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

