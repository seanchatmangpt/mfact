# CONCURRENCY: Concurrency and causal-order testing

## Family law

Concurrency standing comes from independence/commutation and causal-order theorems, not from a `.par` constructor or width count.

## Mandatory implementation sequence

1. Define the real state and real transitions.
2. Define or derive independence.
3. Prove pairwise commutation for admitted independent events.
4. Prove adjacent swap invariance.
5. Lift to linear extensions of the same finite causal order.
6. Add a race counterexample.
7. Test maximality of selected concurrent sets separately.

## Core-team anti-patterns

- Using two Nat counters unrelated to the scenario.
- Treating `.par` as proof of independence.
- Serializing POWL and still claiming preserved concurrency.

## Lean/Lake skeleton

```lean
def Independent (a b : Event) : Prop := ...

theorem commute_of_independent
    (h : Independent a b) :
    step b (step a s) = step a (step b s) := by
  ...
```

## Test instances in this family

## T071 — Pairwise commutation test

**Stable instance:** `MFW.TST.CONCURRENCY.PAIRWISE_COMMUTE.071`

**Question:** Do declared independent events commute?

**Canonical mechanism:** `Commute theorem`

**Canonical MFW instance:** freeze identity vs preserve logs on real state

### LLM implementation recipe

1. Declare `MFW.TST.CONCURRENCY.PAIRWISE_COMMUTE.071` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Commute theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T072 — Independent adjacent swap test

**Stable instance:** `MFW.TST.CONCURRENCY.ADJ_SWAP.072`

**Question:** Does swapping adjacent independent events preserve replay?

**Canonical mechanism:** `adjacent-swap theorem`

**Canonical MFW instance:** oriented swap replay

### LLM implementation recipe

1. Declare `MFW.TST.CONCURRENCY.ADJ_SWAP.072` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **adjacent-swap theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T073 — Linear-extension equivalence test

**Stable instance:** `MFW.TST.CONCURRENCY.LINEXT.073`

**Question:** Do two linear extensions of one finite poset replay equally?

**Canonical mechanism:** `LinExt theorem`

**Canonical MFW instance:** receipt causal DAG

### LLM implementation recipe

1. Declare `MFW.TST.CONCURRENCY.LINEXT.073` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **LinExt theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T074 — Diamond property test

**Stable instance:** `MFW.TST.CONCURRENCY.DIAMOND.074`

**Question:** Do two independent one-step branches rejoin?

**Canonical mechanism:** `diamond theorem`

**Canonical MFW instance:** concurrent cloud transitions

### LLM implementation recipe

1. Declare `MFW.TST.CONCURRENCY.DIAMOND.074` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **diamond theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T075 — Race/conflict counterexample test

**Stable instance:** `MFW.TST.CONCURRENCY.RACE.075`

**Question:** Can a claimed-independent pair be shown noncommuting?

**Canonical mechanism:** `counterexample`

**Canonical MFW instance:** delete vs snapshot

### LLM implementation recipe

1. Declare `MFW.TST.CONCURRENCY.RACE.075` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **counterexample**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T076 — Maximal concurrent-set test

**Stable instance:** `MFW.TST.CONCURRENCY.MAX_SET.076`

**Question:** Is the selected enabled set maximal and pairwise independent?

**Canonical mechanism:** `finite search + proof`

**Canonical MFW instance:** automatic POWL concurrency

### LLM implementation recipe

1. Declare `MFW.TST.CONCURRENCY.MAX_SET.076` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **finite search + proof**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

