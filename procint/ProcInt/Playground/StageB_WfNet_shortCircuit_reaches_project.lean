import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

-- Locally-named primed copies of the two prior Stage B facts (not yet ported
-- to TTL/rendered), so this file can be verified standalone today. Proof
-- text is byte-identical to the previous chain step's output.

theorem WfNet.shortCircuit_fire_star' {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.fire W.finalMarking (Sum.inr ()) = W.initialMarking := by
  have h := W.shortCircuit.fire_pre_self (Sum.inr () : T ⊕ Unit)
  rwa [W.shortCircuit_pre_inr, W.shortCircuit_post_inr] at h

theorem WfNet.shortCircuit_step_star' {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
  ⟨W.shortCircuit_enabled_star, (W.shortCircuit_fire_star').symm⟩

/-- The key shared lemma: given that "reaching-or-exceeding the final marking
forces equality with it" (`H`), every marking reachable in the
short-circuited net is also reachable in the original net — the fresh
transition `t*` only ever fires from `finalMarking`, closing straight back to
`initialMarking`, so it never introduces a marking unreachable in the
original net. -/
theorem WfNet.shortCircuit_reaches_project {P T : Type} [DecidableEq P] {W : WfNet P T}
    (H : ∀ M, W.net.Reaches W.initialMarking M → W.finalMarking ≤ M → M = W.finalMarking) :
    ∀ M, W.shortCircuit.Reaches W.initialMarking M → W.net.Reaches W.initialMarking M := by
  intro M h
  induction h with
  | refl => exact Relation.ReflTransGen.refl
  | @tail Mprev M hprev hstep ih =>
      obtain ⟨t, ht⟩ := hstep
      cases t with
      | inl t =>
          have ht' : W.net.Step Mprev t M := (WfNet.shortCircuit_step_inl W Mprev M t).mp ht
          exact ih.tail ⟨t, ht'⟩
      | inr u =>
          obtain ⟨u⟩ := u
          have hEnabled : W.shortCircuit.Enabled Mprev (Sum.inr ()) := ht.1
          have hle : W.finalMarking ≤ Mprev := hEnabled
          have hMprevEq : Mprev = W.finalMarking := H Mprev ih hle
          have hfire : M = W.shortCircuit.fire Mprev (Sum.inr ()) := ht.2
          have hMeq : M = W.initialMarking := by
            rw [hfire, hMprevEq, W.shortCircuit_fire_star']
          rw [hMeq]
          exact Relation.ReflTransGen.refl

end ProcInt
