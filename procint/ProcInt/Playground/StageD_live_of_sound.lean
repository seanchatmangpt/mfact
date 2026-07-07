import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

theorem WfNet.live_of_sound {P T : Type} [DecidableEq P] {W : WfNet P T}
    (h : W.Sound) : W.shortCircuit.Live W.initialMarking := by
  intro M hReachSC t'
  have hReachNetM : W.net.Reaches W.initialMarking M :=
    WfNet.shortCircuit_reaches_project h.proper_completion M hReachSC
  cases t' with
  | inl t =>
      -- route M to final marking inside the original net
      have hReachFinal : W.net.Reaches M W.finalMarking :=
        h.option_to_complete M hReachNetM
      -- fire t* to loop back to initial marking
      have hStepStar : W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
        WfNet.shortCircuit_step_star W
      -- t is enabled at some marking reachable from initial marking
      obtain ⟨M'', hReachM'', hEnM''⟩ := h.enabled_of_transition t
      -- assemble: M --(SC)--> finalMarking --t*--> initialMarking --(SC)--> M''
      have hReachSC1 : W.shortCircuit.Reaches M W.finalMarking :=
        WfNet.reaches_shortCircuit W hReachFinal
      have hReachSC2 : W.shortCircuit.Reaches W.finalMarking W.initialMarking :=
        Relation.ReflTransGen.single ⟨Sum.inr (), hStepStar⟩
      have hReachSC3 : W.shortCircuit.Reaches W.initialMarking M'' :=
        WfNet.reaches_shortCircuit W hReachM''
      have hReachTotal : W.shortCircuit.Reaches M M'' :=
        (hReachSC1.trans hReachSC2).trans hReachSC3
      have hEnSC : W.shortCircuit.Enabled M'' (Sum.inl t) :=
        (WfNet.shortCircuit_enabled_inl W M'' t).mpr hEnM''
      exact ⟨M'', hReachTotal, hEnSC⟩
  | inr u =>
      obtain ⟨⟩ := u
      have hReachFinal : W.net.Reaches M W.finalMarking :=
        h.option_to_complete M hReachNetM
      have hReachSCFinal : W.shortCircuit.Reaches M W.finalMarking :=
        WfNet.reaches_shortCircuit W hReachFinal
      have hEnStar : W.shortCircuit.Enabled W.finalMarking (Sum.inr ()) :=
        WfNet.shortCircuit_enabled_star W
      exact ⟨W.finalMarking, hReachSCFinal, hEnStar⟩

#print axioms WfNet.live_of_sound

end ProcInt
