import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

/-- If a firing sequence of the short-circuited net runs from `M` to `M'`,
then either it never fires `t*` (in which case it is, verbatim, a firing
sequence of the original net from `M` to `M'`), or `t*` fires at some point,
and the marking `M1` immediately before its first occurrence is reachable
from `M` in the original net and already dominates the final marking
(`[o] ≤ M1`). -/
theorem WfNet.shortCircuit_seq_split {P T : Type} [DecidableEq P] {W : WfNet P T}
    {M M' : Marking P} {σ : List (T ⊕ Unit)}
    (h : W.shortCircuit.FiringSeq M σ M') :
    (∃ σ', W.net.FiringSeq M σ' M') ∨
      (∃ M1, W.net.Reaches M M1 ∧ W.finalMarking ≤ M1) := by
  induction h with
  | nil M => exact Or.inl ⟨[], .nil M⟩
  | @cons Ma Mb Mc t σ' hstep hrest ih =>
      cases t with
      | inl t0 =>
          have hstep0 : W.net.Step Ma t0 Mb := (WfNet.shortCircuit_step_inl W Ma Mb t0).mp hstep
          rcases ih with ⟨σ0, hσ0⟩ | ⟨M1, hReach, hle⟩
          · exact Or.inl ⟨t0 :: σ0, .cons hstep0 hσ0⟩
          · exact Or.inr ⟨M1, Relation.ReflTransGen.head ⟨t0, hstep0⟩ hReach, hle⟩
      | inr u =>
          obtain ⟨⟩ := u
          have hEnabled : W.shortCircuit.Enabled Ma (Sum.inr ()) := hstep.1
          have hle : W.finalMarking ≤ Ma := hEnabled
          exact Or.inr ⟨Ma, Relation.ReflTransGen.refl, hle⟩

end ProcInt

#print axioms ProcInt.WfNet.shortCircuit_seq_split
