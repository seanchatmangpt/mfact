# KERNEL: Kernel and theorem testing

## Family law

Kernel admission is necessary but not sufficient for crown standing. A theorem must also be specialized, composed, dependency-audited, and shown non-vacuous when the claim requires those surfaces.

## Mandatory implementation sequence

1. Name the exact proposition and controlled carrier.
2. Write the theorem or concrete specialization.
3. Inspect transitive axiom dependencies for crown declarations.
4. Construct at least one satisfiable concrete witness.
5. Do not infer product or runtime consequences from local theorem admission.

## Core-team anti-patterns

- Counting theorem keywords.
- Treating `lake build` as proof of the prose claim.
- Using an impossible hypothesis so the theorem fires vacuously.

## Lean/Lake skeleton

```lean
example (x : α) (h : P x) : Q x := by
  exact generic_theorem x h

#print axioms generic_theorem
```

## Test instances in this family

## T001 — Kernel admission test

**Stable instance:** `MFW.TST.KERNEL.ADMISSION.001`

**Question:** Does the declaration survive Lean elaboration and kernel checking?

**Canonical mechanism:** `Lean declaration / lake build`

**Canonical MFW instance:** ProcInt theorem module admission

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.ADMISSION.001` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Lean declaration / lake build**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T002 — Theorem proof test

**Stable instance:** `MFW.TST.KERNEL.THEOREM_PROOF.002`

**Question:** Is the stated proposition actually inhabited?

**Canonical mechanism:** `theorem/example`

**Canonical MFW instance:** Replay equivalence law

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.THEOREM_PROOF.002` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **theorem/example**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T003 — Lemma specialization test

**Stable instance:** `MFW.TST.KERNEL.SPECIALIZATION.003`

**Question:** Does a generic theorem fire on the intended concrete carrier?

**Canonical mechanism:** `example applying theorem`

**Canonical MFW instance:** SOC2 concrete closure specialization

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.SPECIALIZATION.003` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **example applying theorem**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T004 — Theorem composition test

**Stable instance:** `MFW.TST.KERNEL.COMPOSITION.004`

**Question:** Do multiple proved theorems compose on one shared carrier?

**Canonical mechanism:** `shared witness + chained theorem applications`

**Canonical MFW instance:** residue → tenancy → execution → replay

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.COMPOSITION.004` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **shared witness + chained theorem applications**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T005 — Assumption audit

**Stable instance:** `MFW.TST.KERNEL.ASSUMPTION_AUDIT.005`

**Question:** Which theorem hypotheses are necessary, redundant, or too strong?

**Canonical mechanism:** `hypothesis inventory + removal companions`

**Canonical MFW instance:** Separated / Finite / well-founded assumptions

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.ASSUMPTION_AUDIT.005` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **hypothesis inventory + removal companions**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T006 — Axiom dependency test

**Stable instance:** `MFW.TST.KERNEL.AXIOM_DEP.006`

**Question:** Which axioms are transitively reachable from a theorem?

**Canonical mechanism:** `Lean.collectAxioms / #print axioms`

**Canonical MFW instance:** crown theorem axiom allowlist

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.AXIOM_DEP.006` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **Lean.collectAxioms / #print axioms**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T007 — No-sorry test

**Stable instance:** `MFW.TST.KERNEL.NO_SORRY.007`

**Question:** Does any controlled declaration depend on sorryAx?

**Canonical mechanism:** `compiled environment inspection`

**Canonical MFW instance:** ProcInt namespace audit

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.NO_SORRY.007` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **compiled environment inspection**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

## T008 — Non-vacuity test

**Stable instance:** `MFW.TST.KERNEL.NON_VACUITY.008`

**Question:** Can the theorem fire on a genuine witness with satisfiable hypotheses?

**Canonical mechanism:** `concrete positive witness`

**Canonical MFW instance:** nonidentity ClosureOperator

### LLM implementation recipe

1. Declare `MFW.TST.KERNEL.NON_VACUITY.008` in the test metadata/header.
2. Name the exact controlled carrier used by this instance.
3. State the law or observable before writing the fixture.
4. Implement the smallest positive witness that can exercise the law.
5. Add the exact negative/refusal surface where this test class requires one.
6. Produce evidence using **concrete positive witness**.
7. Record the claim ceiling; do not generalize beyond the carrier and evidence class.
8. Link the result to the next theorem/standing edge or explicitly emit a gap.

### Pass condition

The test answers its stated question using the declared mechanism and the result is
machine-derived from the controlled artifact/declaration.

### Automatic refusal

Refuse this test instance as `MISCLASSIFIED_TEST` when the implementation merely
uses a generic `example`, `native_decide`, snapshot, or build success without
exercising the specific law above.

