# FLOW: World-centered flow and scenario testing

## Family law

Flow tests are world-centered. A positive scenario and its negative companion should use the same domain vocabulary and differ at the exact violated invariant.

## Mandatory implementation sequence

1. Name the world and business/control purpose.
2. Construct a genuine nonidentity carrier.
3. Run the coherent theorem chain.
4. Build a violation companion by breaking one admission condition.
5. State the scenario-only claim ceiling.

## Core-team anti-patterns

- Calling a flow a new general theorem.
- Handwaving missing intermediate maps.
- Positive and negative fixtures using unrelated models.

## Lean/Lake skeleton

```lean
namespace Playground.SOC2.AuditFlow
-- one concrete two-tenant world
-- positive theorem chain
end Playground.SOC2.AuditFlow

namespace Playground.SOC2.AuditFlowViolation
-- same vocabulary, exact broken hypothesis
end Playground.SOC2.AuditFlowViolation
```

## Test instances in this family

## T064 — Flow/scenario test

**Stable instance:** `MFW.TST.FLOW.SCENARIO.064`

**Question:** Does one concrete world exercise a coherent multi-law path?

**Canonical mechanism:** `positive flow + negative companion`

**Canonical MFW instance:** SOC2 two-tenant audit / contractor exfiltration

### LLM implementation recipe

1. Declare `MFW.TST.FLOW.SCENARIO.064` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **positive flow + negative companion**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

