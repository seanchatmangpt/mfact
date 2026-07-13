# ROUNDTRIP: Round-trip testing

## Family law

Exact round-trip and canonicalized round-trip are different laws and must have different test instances.

## Mandatory implementation sequence

1. Define encode and decode.
2. Choose exact or canonical equality.
3. State information intentionally lost, if any.
4. Prove/test the corresponding equation.
5. Add malformed-input refusal tests.

## Core-team anti-patterns

- Claiming exact round-trip after canonicalization.
- Ignoring blank-node identity or ordering normalization.
- Using string equality for semantic RDF equivalence.

## Lean/Lake skeleton

```lean
theorem roundtrip_exact (x : X) : decode (encode x) = .ok x := by
  ...

theorem roundtrip_canonical (x : X) :
    canonicalize (decode! (encode x)) = canonicalize x := by
  ...
```

## Test instances in this family

## T066 — Round-trip test

**Stable instance:** `MFW.TST.ROUNDTRIP.EXACT.066`

**Question:** Does decode(encode(x)) = x?

**Canonical mechanism:** `encode/decode theorem or executable check`

**Canonical MFW instance:** receipt/workflow serialization

### LLM implementation recipe

1. Declare `MFW.TST.ROUNDTRIP.EXACT.066` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **encode/decode theorem or executable check**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T067 — Canonicalized round-trip test

**Stable instance:** `MFW.TST.ROUNDTRIP.CANONICAL.067`

**Question:** Does canonicalize(decode(encode(x))) = canonicalize(x)?

**Canonical mechanism:** `canonicalized equality`

**Canonical MFW instance:** RDF blank-node-sensitive carrier

### LLM implementation recipe

1. Declare `MFW.TST.ROUNDTRIP.CANONICAL.067` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **canonicalized equality**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

