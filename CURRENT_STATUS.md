# Project Status Report

**Timestamp**: 2026-07-16 (post MFW claims-honesty pass)
**Standing**: PARTIAL_ALIVE — build and lint green; the cataloged labeling,
vacuous-predicate, and hidden-choice defects are repaired; the Crown conjecture
and its supporting conjectures remain CONJECTURAL/open.

## 1. Verification (2026-07-16)

Receipt: `.verif-toolchain/receipts/receipt-20260716T222045Z.txt` (Overall: PASS).
The receipt is procint-scoped (no root-workspace `lake build` is attested).

* `lake build ProcInt` (from `procint/`): exit 0, 8579 jobs
* `lake exe lint-style --procint Mathlib.Init` (from the repo root): exit 0
* Residual non-fatal warnings, both pre-existing:
  * `unreachableTactic` + `unusedTactic` at `procint/ProcInt/MFW/Tests.lean:152`
  * `String.mk` / `String.trim` deprecation notes emitted while compiling
    `scripts/lint-style.lean`

## 2. MFW Claims-Honesty Pass (2026-07-16)

The audit catalog in `procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` was resolved:

* Bodyless `opaque` declarations converted to explicit theory-structure hypotheses
  (`CausalOrderAssignment`, `ManufactureTheory`, `FalsificationTheory`,
  `ExploreExploitTheory`, `CompilerPipelineTheory`, `TemporalEntropyAssignment`),
  or deleted where unconsumed (`wassersteinWorkflowDist`).
* Theorem-shaped `def : Prop` declarations, including the Crown statement
  `KernelCharacterization` in `procint/ProcInt/MFW/Kernel.lean`, reframed as explicit
  conjectures with `Standing: CONJECTURAL` tags naming their blockers.
* Vacuous `True` predicates replaced with real constraining bodies
  (`validTopologicalSort` in `procint/ProcInt/MFW/Ledger.lean`, with decidable-instance
  positive and negative test fixtures; `HierarchicalScaleSystem.refines` in
  `procint/ProcInt/MFW/TransformBasic.lean`, now concluding `Powl.IsSubmodelOf`
  containment) or explicit hypothesis parameters.
* `Standing:` tag grammar normalized across MFW modules; the linter enforces the
  vocabulary (`CONJECTURAL` / `PROVEN` at declaration level).

These changes are honesty repairs, not proof closure: no conjecture was proven this pass.

## 2a. Round-1 Adversarial Review Repairs (2026-07-16, same day)

* `stateTraceOf` (`procint/ProcInt/MFW/Kernel.lean`) no longer uses `Classical.choice`
  (which returned one constant list for every behavior, degenerating `StateEquiv` into
  the total relation); it now replays events via `BehaviorTrace.stateTrace`, with
  faithfulness proved (`stateTrace_eq_some_stateTraceOf`).
* K2 `CausalEquiv` gained its equivalence lemmas (`causalEquiv_refl/symm/trans`),
  PROVEN relative to an explicit `CausalOrderAssignment`.
* `independentGenerators` (`Kernel.lean`) replaced its syntactic stand-in body with the
  documented semantic condition, parameterized over an explicit `KernelPathRewriting`
  hypothesis record.
* Unconstrained `Prop` data fields `Perturbation.lawful` and `LocalDimension.wellDefined`
  (`procint/ProcInt/MFW/IntrinsicDimension.lean`) were removed; lawfulness is enforced by
  the type of `Perturbation.perturbed`.
* The `mfact-core` Rust design contract moved from the gitignored `crates/` tree to
  `docs/MFACT_CORE_DESIGN.md` so it can be committed.

## 3. Historical Snapshot (2026-07-14, as recorded — not re-verified)

The following was recorded before the claims-honesty pass and has not been re-verified
against the 2026-07-16 receipt:

* Core release `v26.7.13` (tag `v26.7.13-procint-certified @ 650b388`), declarations 402,
  proven 204, gates recorded as PASS (`sorryFree`, `axiomsClean`, `fixturesPass`,
  `evidenceComplete`, quadrature, semantic/negative fixtures, oracle cases).
* `fhe_firing_equivalence` proof audited against FHE homomorphic valuation semantics;
  NIST PQC (`ML-KEM`, `ML-DSA`) formal-verification repositories documented.
* Toolchain: `elan-init` installed via Homebrew; pinned `lean4:v4.31.0` toolchain in use.

## See Also

- `AGENTS.md` — repository law, Standing Law, and the Constructive Lean Boundary status
- `procint/AGENTS.md` — nested procint agent law and the full standing vocabulary
- `procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` — the audit catalog resolved by this pass
- `docs/AGENT_FAILURE_MODES.md` — failure modes this pass was designed to avoid
- `MFW_THESIS_SUMMARY.md` — mathematical framework summary and open conjectures
- `docs/MFACT_CORE_DESIGN.md` — design contract for the (not yet existing) `mfact-core`
  Rust crate
