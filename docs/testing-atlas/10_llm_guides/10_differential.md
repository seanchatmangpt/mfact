# DIFFERENTIAL: Differential testing

## Family law

Differential tests compare two implementations only after declaring one shared semantics or semantic digest.

## Mandatory implementation sequence

1. Name implementations A and B.
2. Define the shared input domain.
3. Define semantic observation/digest.
4. Run both on identical inputs.
5. Compare semantic result, not incidental allocation/order data.

## Core-team anti-patterns

- Comparing two copy-pasted identical definitions and calling it runtime correspondence.
- Comparing only success/failure booleans.
- Ignoring refusal-class divergence.

## Lean/Lake skeleton

```lean
def SemanticallyEqual (a b : Result) : Prop :=
  digest a = digest b ∧ refusalClass a = refusalClass b

example : SemanticallyEqual (implA input) (implB input) := by
  ...
```

## Test instances in this family

## T056 — Differential test

**Stable instance:** `MFW.TST.DIFFERENTIAL.IMPL_COMPARE.056`

**Question:** Do two implementations of one admitted semantics produce equal results?

**Canonical mechanism:** `run A/B + semantic digest`

**Canonical MFW instance:** recursive vs fold replay; naive vs seminaive closure; interpreter variants

### LLM implementation recipe

1. Declare `MFW.TST.DIFFERENTIAL.IMPL_COMPARE.056` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **run A/B + semantic digest**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

