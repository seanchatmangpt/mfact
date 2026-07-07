-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Workflow.WfNet

/-! # ProcInt.Workflow.ShortCircuit

The short-circuited net of a workflow net (van der Aalst 1997, construction before Lemma 8): one fresh transition consuming the final marking and producing the initial marking, closing the net into a cycle. Conservativity lemmas: short-circuiting preserves pre/post weights, enabledness, steps, and reachability on the original transitions. -/

namespace ProcInt

/-- The short-circuited net `N̄` of a workflow net (van der Aalst 1997, before
Lemma 8): extend the transition set with one fresh transition `t*` (here the
`Sum.inr` unit) consuming one token from the sink and producing one token on
the source, closing the net into a cycle. Soundness of the WF-net is
equivalent to liveness plus boundedness of this net. -/
noncomputable def WfNet.shortCircuit {P T : Type} [DecidableEq P] (W : WfNet P T) :
    PetriNet P (T ⊕ Unit) where
  pre := fun t => match t with
    | .inl t => W.net.pre t
    | .inr _ => Finsupp.single W.sink 1
  post := fun t => match t with
    | .inl t => W.net.post t
    | .inr _ => Finsupp.single W.source 1

/-- The short-circuited net keeps the original pre-weights on original
transitions. -/
theorem WfNet.shortCircuit_pre_inl {P T : Type} [DecidableEq P] (W : WfNet P T) (t : T) :
    W.shortCircuit.pre (Sum.inl t) = W.net.pre t := rfl

/-- The short-circuited net keeps the original post-weights on original
transitions. -/
theorem WfNet.shortCircuit_post_inl {P T : Type} [DecidableEq P] (W : WfNet P T) (t : T) :
    W.shortCircuit.post (Sum.inl t) = W.net.post t := rfl

/-- The fresh transition `t*` consumes exactly the final marking `[o]`. -/
theorem WfNet.shortCircuit_pre_inr {P T : Type} [DecidableEq P] (W : WfNet P T) (u : Unit) :
    W.shortCircuit.pre (Sum.inr u) = W.finalMarking := rfl

/-- The fresh transition `t*` produces exactly the initial marking `[i]`. -/
theorem WfNet.shortCircuit_post_inr {P T : Type} [DecidableEq P] (W : WfNet P T) (u : Unit) :
    W.shortCircuit.post (Sum.inr u) = W.initialMarking := rfl

/-- Enabledness of an original transition is unchanged by short-circuiting. -/
theorem WfNet.shortCircuit_enabled_inl {P T : Type} [DecidableEq P] (W : WfNet P T)
    (M : Marking P) (t : T) :
    W.shortCircuit.Enabled M (Sum.inl t) ↔ W.net.Enabled M t := Iff.rfl

/-- Firing an original transition in the short-circuited net is exactly a step
of the original net: short-circuiting is conservative over `T`
(van der Aalst 1997, the `N̄` construction changes only `t*`). -/
theorem WfNet.shortCircuit_step_inl {P T : Type} [DecidableEq P] (W : WfNet P T)
    (M M' : Marking P) (t : T) :
    W.shortCircuit.Step M (Sum.inl t) M' ↔ W.net.Step M t M' := Iff.rfl

/-- Every reachability fact of the original workflow net transfers to the
short-circuited net (each original step is simulated by the `Sum.inl` copy of
its transition). -/
theorem WfNet.reaches_shortCircuit {P T : Type} [DecidableEq P] (W : WfNet P T)
    {M M' : Marking P} (h : W.net.Reaches M M') : W.shortCircuit.Reaches M M' :=
  Relation.ReflTransGen.mono (fun _ _ hstep =>
    match hstep with
    | ⟨t, ht⟩ => ⟨Sum.inl t, ht⟩) h

/-- The fresh transition `t*` is enabled at the final marking `[o]`. -/
theorem WfNet.shortCircuit_enabled_star {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.Enabled W.finalMarking (Sum.inr ()) := le_refl _


end ProcInt
