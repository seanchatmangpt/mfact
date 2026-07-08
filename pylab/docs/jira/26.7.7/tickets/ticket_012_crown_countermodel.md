# Ticket 012 — Crown-Jewel Countermodel: Infinite-Transition Soundness Characterization

## Type

Verification / Formal Proof / Crown Jewel

## Standing

STATED

## Objective

Formalize van der Aalst's soundness characterization for workflow nets as a Lean-admitted countermodel, proving that the unbounded (infinite transition) version of the original theorem statement is false. Construct a Petri net where infinitely many transition pairs route unbounded tokens without deadlock, violating the original characterization. Repair the characterization by adding the finite-transition constraint `[Finite T]`, closing the gap between the informal canon and the formal statement.

The deliverable is a single Lean-admitted theorem:

`WfNet.infinite_transition_countermodel_sound_not_bounded`

## Core Law

Standing for countermodels is STATED.

The countermodel is kernel-admitted and axiom-audited.

It proves that the original (unbounded) statement fails under infinite transitions.

It does not promote the finite-transition repair to PROVEN.

## Theorem Identity

| Field | Value |
|-------|-------|
| **Theorem Name** | `WfNet.infinite_transition_countermodel_sound_not_bounded` |
| **Status Key** | `WFNET_INFINITE_TRANSITION_COUNTERMODEL` |
| **Guard Name** | `countermodel_not_promoted` |
| **Refusal Mode** | `COUNTERMODEL_PROMOTION_REFUSED` |
| **Module** | `ProcInt.Workflow.Countermodels` |

## Construction Summary

The countermodel is a single workflow net with:

- **Finite places:** P = {source, sink, accumulator}
- **Infinite transitions:** T = {t₀, t₁, t₂, ...} (countably infinite)
- **Flow structure:** All transitions route from source → accumulator → sink
- **Soundness violation:** Infinitely many transition pairs deposit unbounded tokens in accumulator without a dead transition, proving that liveness and boundedness alone do not imply the original characterization without finiteness

The net is sound in the intuitive sense (no dead transitions under the short-circuit), but the original unbounded characterization fails because boundedness is violated by the infinite transition set structure.

## Non-Goals

This ticket must not:

* implement tactic search or proof automation
* weaken the soundness definition
* claim that the finite-transition repair is PROVEN
* promote the countermodel into the crown manifest
* modify the short-circuit construction
* change the Petri net firing semantics
* implement OCPN or OCEL variants of the countermodel
* extend the countermodel to handle parameters or stochastic variants

## Required Artifacts

### Source Files (Hand-Authored, Ledgered)

`procint/Playground/Workflow/CountermodelConstruction.lean`

Hand-authored Playground file (not ggen-rendered, not in ledger, never admits standing).

Constructs the net in Lean syntax, proves finiteness lemmas and firing traces.

### TTL Catalog Entry (Source Declaration)

`packs/lean-math-pack/fragments/wfnet-countermodel.ttl`

Ledgered source declaration carrying:
- leanCode: the theorem statement and proof sketch
- status: STATED
- axiomAudit: [propext, Classical.choice, Quot.sound] (expected)
- citation: van der Aalst 1997, Lemma 8
- module: ProcInt.Workflow.Countermodels

### Generated Artifacts (After Rendering)

`procint/ProcInt/Workflow/Countermodels.lean`

Rendered by ggen from the TTL fragment. Contains the theorem definition and proof.

Must be admitted by `lake build` with no sorry.

Must pass axiom audit with no unauthorized axioms.

### Guard Script

`scripts/guard_countermodel_not_promoted.py`

Refuses admission if the countermodel is upgraded to PROVEN or moved into the crown manifest.

Exit code: 1 (COUNTERMODEL_PROMOTION_REFUSED)

## Required Verification Commands

Run from repository root:

```bash
# Lake build to admit the theorem
cd procint && lake build

# Axiom audit on the rendered theorem
cd procint && lake env lean packs/lean-math-pack/build/axiom_audit.lean

# Verify no sorry in the theorem
grep -n "sorry" procint/ProcInt/Workflow/Countermodels.lean

# Verify guard refuses promotion
scripts/guard_countermodel_not_promoted.py && echo "PASS" || echo "FAIL"

# Verify standing key is registered
grep "WFNET_INFINITE_TRANSITION_COUNTERMODEL" .mfact/artifacts.toml

# Verify theorem name appears in manifest
jq '.declarations[] | select(.status=="STATED") | .name' release/release-manifest.json | grep "infinite_transition_countermodel_sound_not_bounded"

# Verify manifest counts
jq '.summary | {proven, stated, total}' release/release-manifest.json
```

## Ledger Entry

Expected artifact ledger entry (`.mfact/artifacts.toml`):

```toml
[[artifacts]]
path = "procint/ProcInt/Workflow/Countermodels.lean"
produced_by = "ggen"
source = "packs/lean-math-pack/fragments/wfnet-countermodel.ttl"
template = "packs/lean-math-pack/templates/module.tmpl"
status_key = "WFNET_INFINITE_TRANSITION_COUNTERMODEL"
guard = "countermodel_not_promoted"
standing = "STATED"
```

## Definition of Done

Ticket 012 is done only when all of the following are true:

1. TTL fragment `packs/lean-math-pack/fragments/wfnet-countermodel.ttl` exists and is ledgered.
2. Theorem source `procint/Playground/Workflow/CountermodelConstruction.lean` is hand-authored and not ledgered.
3. Rendered module `procint/ProcInt/Workflow/Countermodels.lean` is created by ggen and ledgered.
4. Theorem statement compiles without sorry.
5. Theorem admits under the pinned axiom set [propext, Classical.choice, Quot.sound].
6. Axiom audit passes with no unauthorized axioms.
7. `lake build` exits 0.
8. Guard script `scripts/guard_countermodel_not_promoted.py` exists and refuses promotion.
9. Guard script runs and exits 1 on attempted PROVEN upgrade.
10. Manifest includes the theorem with status STATED.
11. Manifest foldHash is computed and recorded.
12. Manifest counts: proven ≥ 197, stated ≥ 7, total ≥ 397 (or as certified in v26.7.7).
13. `just render` succeeds and regenerates the module without drift.
14. `just build` succeeds with exit code 0.
15. `just audit` passes on the theorem.
16. `just manifest` produces a valid manifest with the theorem listed.
17. `just regen-check` passes (no unreplayable edits).
18. Negative fixture: injecting sorry into the theorem causes `lake build` to fail.
19. Negative fixture: attempting to promote the status causes guard to refuse.
20. Paper (`paper/main.tex`) is updated with the countermodel citation.
21. Ticket specification doc exists and is accurate.
22. Receipt doc is created with all commands run and results.
23. Axiom audit output is recorded in receipt.
24. Final standing is STATED (not promoted to PROVEN).

## Final Standing Rule

This ticket has only three possible terminal states:

* `DOCS_ALIVE`: paper and docs complete; theorem is STATED and ledgered.
* `BUILD_BROKEN`: theorem construction exists but lake build or audit fails.
* `BLOCKED`: source (TTL fragment or guard script) is missing.

No soft completion. The countermodel must be admitted as STATED; it may never be promoted to PROVEN by this ticket.

## No Promotion Rule

The guard name `countermodel_not_promoted` is not a weakness; it is the design. A countermodel that proves the original statement false is valuable as a STATED theorem because it documents the boundary. Promoting it to PROVEN would be a misstatement: the countermodel proves the *negation* of the original theorem, not its affirmation. The finite-transition repair is a separate theorem (the crown-jewel repair, status PARTIAL_ALIVE or complete in future work).

## Paper Integration

The paper (`paper/main.tex`, Section "Workflow nets and soundness") must cite the theorem by exact name:

> The finite transition hypothesis is necessary: the repository includes a Lean-admitted infinite-transition countermodel, `WfNet.infinite_transition_countermodel_sound_not_bounded`, showing that the unbounded statement fails under infinite transitions. The repaired crown theorem therefore states the equivalence under `[Finite T]`.

No hand-authored claim of proof status. The theorem's standing is STATED and is reported from the manifest.
