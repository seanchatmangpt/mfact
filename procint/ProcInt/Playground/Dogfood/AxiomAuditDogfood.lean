-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Dogfood.Lifecycle
import ProcInt.Playground.Dogfood.PowlBounds

/-! # Axiom audit — Operation Dogfood Wave 1-4 theorems (hand-authored)

Instantiates testing-atlas **T006** (`Lean.collectAxioms` / `#print axioms`) and **T007**
(no `sorryAx`) — pattern copied from `SOC2/AxiomAuditSOC2.lean` — against every theorem
introduced by the Dogfood waves (`Outcome`, `Guard`, `Lifecycle`, `PowlBounds`), none of
which is covered by the ggen-rendered `procint/AxiomAudit.lean` (ontology catalog only).
Every asserted info string below is the exact kernel-computed transitive axiom set; a
mismatch is a build error. All 49 sets are subsets of
`[propext, Classical.choice, Quot.sound]`; none contains `sorryAx`.

**Claim ceiling.** Axiom-cleanliness only. This is not evidence that `SearchOutcome`,
`Approval`, `LifecycleEvent`, or the layer measure model the PRD's runtime concepts
correctly — those are `CORRESPONDENCE`-edge questions (AGENTS.md §4), out of scope for
T006/T007.
-/

namespace ProcInt.Playground.Dogfood.AxiomAuditDogfood

/-- info: 'ProcInt.Playground.Dogfood.searchGo_found' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.searchGo_found

/-- info: 'ProcInt.Playground.Dogfood.searchGo_exhausted_all_failed' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.searchGo_exhausted_all_failed

/-- info: 'ProcInt.Playground.Dogfood.searchGo_exhausted_length_le' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.searchGo_exhausted_length_le

/-- info: 'ProcInt.Playground.Dogfood.searchGo_bounded_frontier' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.searchGo_bounded_frontier

/-- info: 'ProcInt.Playground.Dogfood.searchGo_bounded_fuel_lt' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.searchGo_bounded_fuel_lt

/-- info: 'ProcInt.Playground.Dogfood.bound_hit_bounded' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.bound_hit_bounded

/-- info: 'ProcInt.Playground.Dogfood.full_fuel_not_bounded' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.full_fuel_not_bounded

/-- info: 'ProcInt.Playground.Dogfood.all_failed_exhausted' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.all_failed_exhausted

/-- info: 'ProcInt.Playground.Dogfood.exhausted_stable' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.exhausted_stable

/-- info: 'ProcInt.Playground.Dogfood.resume_eq_combined' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.resume_eq_combined

/-- info: 'ProcInt.Playground.Dogfood.naive_projection_conflates' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.naive_projection_conflates

/-- info: 'ProcInt.Playground.Dogfood.naive_projection_lossy' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.naive_projection_lossy

/-- info: 'ProcInt.Playground.Dogfood.outcomeOfExperiment_never_bounded' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.outcomeOfExperiment_never_bounded

/-- info: 'ProcInt.Playground.Dogfood.outcomeOfExperiment_exhausted_iff' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.outcomeOfExperiment_exhausted_iff

/-- info: 'ProcInt.Playground.Dogfood.pddlSearchOutcome_found_valid' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.pddlSearchOutcome_found_valid

/--
info: 'ProcInt.Playground.Dogfood.pddlSearchOutcome_exhausted_infeasible' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.pddlSearchOutcome_exhausted_infeasible

/-- info: 'ProcInt.Playground.Dogfood.pddlSearchOutcome_singleton_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.pddlSearchOutcome_singleton_iff

/-- info: 'ProcInt.Playground.Dogfood.Approval.not_mem_not_covers' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.Approval.not_mem_not_covers

/-- info: 'ProcInt.Playground.Dogfood.Approval.admit_ok_covers' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.Approval.admit_ok_covers

/-- info: 'ProcInt.Playground.Dogfood.Approval.not_covered_refused' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.Approval.not_covered_refused

/-- info: 'ProcInt.Playground.Dogfood.GuardedStep.mayStart' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.GuardedStep.mayStart

/-- info: 'ProcInt.Playground.Dogfood.guardedCompleteStep_ok_sound' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.guardedCompleteStep_ok_sound

/-- info: 'ProcInt.Playground.Dogfood.guardedStep_authorized_invariant' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.guardedStep_authorized_invariant

/-- info: 'ProcInt.Playground.Dogfood.guardedTrace_authorized_invariant' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.guardedTrace_authorized_invariant

/-- info: 'ProcInt.Playground.Dogfood.guardedStep_preserves_inv' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.guardedStep_preserves_inv

/-- info: 'ProcInt.Playground.Dogfood.completed_implies_authorized_of_guarded' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.completed_implies_authorized_of_guarded

/-- info: 'ProcInt.Playground.Dogfood.zero_unauthorized_completion' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.zero_unauthorized_completion

/-- info: 'ProcInt.Playground.Dogfood.guarded_admits_covered' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.guarded_admits_covered

/-- info: 'ProcInt.Playground.Dogfood.guarded_refuses_unauthorized' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.guarded_refuses_unauthorized

/-- info: 'ProcInt.Playground.Dogfood.unguarded_completes_unauthorized' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.unguarded_completes_unauthorized

/-- info: 'ProcInt.Playground.Dogfood.demoTrace' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.demoTrace

/-- info: 'ProcInt.Playground.Dogfood.demoFinal_zero_unauthorized' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.demoFinal_zero_unauthorized

/-- info: 'ProcInt.Playground.Dogfood.receiptCheck_false_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.receiptCheck_false_iff

/-- info: 'ProcInt.Playground.Dogfood.groundedCheck_false_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.groundedCheck_false_iff

/-- info: 'ProcInt.Playground.Dogfood.renderCompletion_receiptCheck' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.renderCompletion_receiptCheck

/-- info: 'ProcInt.Playground.Dogfood.renderCompletion_groundedCheck' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.renderCompletion_groundedCheck

/-- info: 'ProcInt.Playground.Dogfood.completeStep_idem' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.completeStep_idem

/-- info: 'ProcInt.Playground.Dogfood.guarded_refuses_duplicate' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.guarded_refuses_duplicate

/-- info: 'ProcInt.Playground.Dogfood.resume_from_receipt' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.resume_from_receipt

/-- info: 'ProcInt.Playground.Dogfood.impersonation_refused' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.impersonation_refused

/-- info: 'ProcInt.Playground.Dogfood.Bounded.mono' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.Bounded.mono

/-- info: 'ProcInt.Playground.Dogfood.expandLayer_bounds_strictly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.expandLayer_bounds_strictly

/-- info: 'ProcInt.Playground.Dogfood.mem_foldr_sum' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.mem_foldr_sum

/-- info: 'ProcInt.Playground.Dogfood.bounded_atomLayers_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.bounded_atomLayers_lt

/-- info: 'ProcInt.Playground.Dogfood.powl_refinement_manufactureStep' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.powl_refinement_manufactureStep

/-- info: 'ProcInt.Playground.Dogfood.powl_refinement_chains_terminate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.powl_refinement_chains_terminate

/-- info: 'ProcInt.Playground.Dogfood.demoChild_bounded' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.demoChild_bounded

/-- info: 'ProcInt.Playground.Dogfood.demoRefine_strict' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.demoRefine_strict

/-- info: 'ProcInt.Playground.Dogfood.demo_expansion_bounded_at_depth' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Dogfood.demo_expansion_bounded_at_depth

end ProcInt.Playground.Dogfood.AxiomAuditDogfood
