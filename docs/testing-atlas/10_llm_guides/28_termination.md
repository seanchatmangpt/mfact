# TERMINATION: Termination and descent testing

## Family law

Kernel recursion checking, mathematical well-foundedness, and finite descent experiments are three distinct rails.

## Mandatory implementation sequence

1. Make recursive Lean definitions pass the kernel termination checker.
2. Define the mathematical refinement relation.
3. Prove it well founded or map it to a known well-founded relation.
4. Attack bounded manufactured refinement steps for non-descent.
5. Keep perpetual-system stability separate from job termination.

## Core-team anti-patterns

- Using task-count decrease when refinement can split one task into many.
- Calling bounded finite descent a general well-founded theorem.
- Trying to prove a perpetual cloud/swarm terminates.

## Lean/Lake skeleton

```lean
def Refines (child parent : Obligation) : Prop := ...

theorem refines_wf : WellFounded Refines := by
  ...

-- Separate finite experiment: all generated steps decrease rank.
```

## Test instances in this family

## T128 — Kernel termination checking

**Stable instance:** `MFW.TST.TERMINATION.KERNEL.128`

**Question:** Does Lean accept structural/well-founded recursion?

**Canonical mechanism:** `termination checker`

**Canonical MFW instance:** recursive definitions

### LLM implementation recipe

1. Declare `MFW.TST.TERMINATION.KERNEL.128` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **termination checker**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T129 — Well-founded termination theorem

**Stable instance:** `MFW.TST.TERMINATION.WELL_FOUNDED.129`

**Question:** Is the mathematical refinement relation well founded?

**Canonical mechanism:** `WellFounded / DM-style theorem`

**Canonical MFW instance:** workflow obligation multiset

### LLM implementation recipe

1. Declare `MFW.TST.TERMINATION.WELL_FOUNDED.129` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **WellFounded / DM-style theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T130 — Finite experimental descent test

**Stable instance:** `MFW.TST.TERMINATION.FINITE_DESCENT.130`

**Question:** Do all manufactured bounded refinement steps decrease the declared measure?

**Canonical mechanism:** `finite worlds + native_decide/property attack`

**Canonical MFW instance:** obligation refinement corpus

### LLM implementation recipe

1. Declare `MFW.TST.TERMINATION.FINITE_DESCENT.130` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **finite worlds + native_decide/property attack**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

