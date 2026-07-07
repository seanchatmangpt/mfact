-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit

/-! # ProcInt.Workflow.Soundness

Classical soundness of workflow nets (van der Aalst 1997, Verification of Workflow Nets): option to complete, proper completion, and no dead transitions as three INDEPENDENT clauses of one Prop-valued structure. Includes the crown-jewel statement (soundness iff liveness and boundedness of the short-circuited net, Lemma 8 / Theorem 11) as a stated Prop for the dedicated crown-jewel lane. Replaces the unverified soundness typestates of wasm4pm-compat src/petri.rs. -/

namespace ProcInt

/-- Soundness of a workflow net (van der Aalst 1997, Verification of Workflow
Nets, Def 7 of soundness / classical soundness). The three clauses are
INDEPENDENT and formalized separately, per the process-mining canon:
(i) option to complete — from every marking reachable from `[i]` the final
marking `[o]` is reachable; (ii) proper completion — any reachable marking
covering `[o]` equals `[o]`; (iii) no dead transitions — every transition can
fire in some marking reachable from `[i]`. This replaces the unverified
`SoundnessClaimed`/`SoundnessWitnessed` typestates of wasm4pm-compat
`src/petri.rs` with the actual proposition. -/
structure WfNet.Sound {P T : Type} [DecidableEq P] (W : WfNet P T) : Prop where
  option_to_complete : ∀ M, W.net.Reaches W.initialMarking M →
    W.net.Reaches M W.finalMarking
  proper_completion : ∀ M, W.net.Reaches W.initialMarking M →
    W.finalMarking ≤ M → M = W.finalMarking
  no_dead_transitions : ∀ t, ∃ M M', W.net.Reaches W.initialMarking M ∧ W.net.Step M t M'

/-- A sound workflow net reaches its final marking from its initial marking:
instantiate option-to-complete at `[i]` itself. -/
theorem WfNet.Sound.reaches_final {P T : Type} [DecidableEq P] {W : WfNet P T}
    (h : W.Sound) : W.net.Reaches W.initialMarking W.finalMarking :=
  h.option_to_complete W.initialMarking Relation.ReflTransGen.refl

/-- In a sound workflow net every transition has an enabling marking reachable
from `[i]` (projection of the no-dead-transitions clause). -/
theorem WfNet.Sound.enabled_of_transition {P T : Type} [DecidableEq P] {W : WfNet P T}
    (h : W.Sound) (t : T) :
    ∃ M, W.net.Reaches W.initialMarking M ∧ W.net.Enabled M t := by
  obtain ⟨M, M', hr, hstep⟩ := h.no_dead_transitions t
  exact ⟨M, hr, hstep.1⟩

/-- Crown-jewel statement (van der Aalst 1997, Lemma 8 / Theorem 11): a
workflow net is sound iff its short-circuited net is live and bounded from
the initial marking `[i]`. Stated here as a `Prop`; the proof is manufactured
by a dedicated lane. -/
def WfNet.sound_iff_shortCircuit_live_bounded_statement {P T : Type} [DecidableEq P]
    (W : WfNet P T) : Prop :=
  W.Sound ↔ (W.shortCircuit.Live W.initialMarking ∧
    ∃ k, W.shortCircuit.Bounded W.initialMarking k)

/-- Ground-truth status of the crown-jewel theorem (van der Aalst 1997,
Lemma 8 / Theorem 11: soundness iff liveness and boundedness of the
short-circuited net) at this release. `"stated"` means the statement
`WfNet.sound_iff_shortCircuit_live_bounded_statement` is formalized and
type-checks, but no direction of the iff is discharged — this is not a
proven theorem in this release, and the paper must not claim otherwise.
Two supporting lemmas about `WfNet.Sound` (`reaches_final`,
`enabled_of_transition`) are proven and audited. -/
def crownJewel_status : String := "stated" 


end ProcInt
