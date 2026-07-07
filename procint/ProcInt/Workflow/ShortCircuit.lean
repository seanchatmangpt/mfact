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

/-- Firing the fresh transition `t*` at the final marking `[o]` lands back at
the initial marking `[i]`, closing the cycle (van der Aalst 1997, the `N̄`
construction). -/
theorem WfNet.shortCircuit_fire_star {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.fire W.finalMarking (Sum.inr ()) = W.initialMarking := by
  have h := W.shortCircuit.fire_pre_self (Sum.inr () : T ⊕ Unit)
  rwa [W.shortCircuit_pre_inr, W.shortCircuit_post_inr] at h

/-- The fresh transition `t*` steps the short-circuited net from the final
marking `[o]` back to the initial marking `[i]`. -/
theorem WfNet.shortCircuit_step_star {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
  ⟨W.shortCircuit_enabled_star, (W.shortCircuit_fire_star).symm⟩

/-- Split a short-circuited firing sequence at the first occurrence of the
fresh transition `t*`: either the whole run stays inside the original net, or
it reaches, entirely inside the original net, a marking that already covers
the final marking `[o]` (the point right before `t*` first fires). -/
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

/-- If every original-net marking reachable from `[i]` and covering `[o]`
already equals `[o]` (proper completion), then every short-circuited run from
`[i]` is in fact a run of the original net (`t*` never needs to fire, since
firing it would require having already reached `[o]`, at which point it just
loops back to `[i]`). Stated generally over the hypothesis `H` so it can be
reused both from `proper_of_bounded` and from `Sound.proper_completion`. -/
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
            rw [hfire, hMprevEq, W.shortCircuit_fire_star]
          rw [hMeq]
          exact Relation.ReflTransGen.refl


end ProcInt
