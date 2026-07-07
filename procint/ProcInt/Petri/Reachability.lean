-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Firing

/-! # ProcInt.Petri.Reachability

Reachability as the reflexive-transitive closure of the firing relation, firing sequences as an inductive predicate, and the two-way correspondence between them (Murata 1989, section II.D, reachability set R(M0); van der Aalst 1997 relies on this correspondence for WF-net soundness). -/

namespace ProcInt

/-- Reachability: the reflexive-transitive closure of the one-step firing
relation (Murata 1989, section II.D, reachability set R(M0)). -/
def PetriNet.Reaches {P T : Type} (N : PetriNet P T) : Marking P → Marking P → Prop :=
  Relation.ReflTransGen (fun M M' => ∃ t, N.Step M t M')

/-- A firing sequence σ from M to M'' — the list of transitions fired, in
order (Murata 1989, firing sequences). -/
inductive PetriNet.FiringSeq {P T : Type} (N : PetriNet P T) :
    Marking P → List T → Marking P → Prop
  | nil (M : Marking P) : PetriNet.FiringSeq N M [] M
  | cons {M M' M'' : Marking P} {t : T} {σ : List T} :
      N.Step M t M' → PetriNet.FiringSeq N M' σ M'' → PetriNet.FiringSeq N M (t :: σ) M''

/-- Append a final step to a firing sequence (the snoc lemma, derived by
induction — dual of the cons constructor). -/
theorem PetriNet.FiringSeq.snoc {P T : Type} {N : PetriNet P T}
    {M M' M'' : Marking P} {σ : List T} {t : T}
    (hσ : N.FiringSeq M σ M') (h : N.Step M' t M'') : N.FiringSeq M (σ ++ [t]) M'' := by
  induction hσ with
  | nil _ => exact .cons h (.nil M'')
  | cons hstep _ ih => exact .cons hstep (ih h)

/-- Every firing sequence witnesses reachability (Murata 1989: soundness
direction of the firing-sequence characterization of R(M0)). -/
theorem PetriNet.firingSeq_reaches {P T : Type} {N : PetriNet P T}
    {M M' : Marking P} {σ : List T}
    (h : N.FiringSeq M σ M') : N.Reaches M M' := by
  induction h with
  | nil _ => exact Relation.ReflTransGen.refl
  | cons hstep _ ih => exact Relation.ReflTransGen.head ⟨_, hstep⟩ ih

/-- Every reachable marking is reached by some firing sequence (Murata 1989:
completeness direction of the firing-sequence characterization of R(M0)). -/
theorem PetriNet.reaches_firingSeq {P T : Type} {N : PetriNet P T}
    {M M' : Marking P}
    (h : N.Reaches M M') : ∃ σ, N.FiringSeq M σ M' := by
  induction h with
  | refl => exact ⟨[], .nil M⟩
  | tail _ hstep ih =>
      obtain ⟨σ, hσ⟩ := ih
      obtain ⟨t, ht⟩ := hstep
      exact ⟨σ ++ [t], hσ.snoc ht⟩

/-- Reachability is stable under adding a constant offset to both markings:
if M' is reachable from M, then M' + A is reachable from M + A (Stage A
infrastructure lemma — token-conserving translation of reachability facts,
Murata 1989 section II.D). -/
theorem PetriNet.reaches_add {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} (A : Marking P) (h : N.Reaches M M') :
    N.Reaches (M + A) (M' + A) := by
  induction h with
  | refl => exact Relation.ReflTransGen.refl
  | tail _ hstep ih =>
      obtain ⟨t, ht⟩ := hstep
      exact Relation.ReflTransGen.tail ih ⟨t, N.step_add A ht⟩

theorem PetriNet.firingSeq_support_subset {P T : Type} [Fintype T] [DecidableEq P]
    {N : PetriNet P T} {M0 M : Marking P} {σ : List T}
    (h : N.FiringSeq M0 σ M) :
    M.support ⊆ M0.support ∪ Finset.univ.biUnion (fun t => (N.post t).support) := by
  induction h with
  | nil M => exact Finset.subset_union_left
  | @cons Ma Mb Mc t σ' hstep _ ih =>
      -- hstep : N.Step Ma t Mb, ih : Mc.support ⊆ Mb.support ∪ univ.biUnion post
      have hfire : Mb = Ma - N.pre t + N.post t := hstep.2
      have hsub1 : Mb.support ⊆ (Ma - N.pre t).support ∪ (N.post t).support := by
        rw [hfire]; exact Finsupp.support_add
      have hsub2 : (Ma - N.pre t).support ⊆ Ma.support := Finsupp.support_tsub
      have hpost : (N.post t).support ⊆ Finset.univ.biUnion (fun t => (N.post t).support) :=
        Finset.subset_biUnion_of_mem (fun t => (N.post t).support) (Finset.mem_univ t)
      have hMb : Mb.support ⊆ Ma.support ∪ Finset.univ.biUnion (fun t => (N.post t).support) := by
        intro x hx
        rcases Finset.mem_union.mp (hsub1 hx) with hx' | hx'
        · exact Finset.mem_union_left _ (hsub2 hx')
        · exact Finset.mem_union_right _ (hpost hx')
      intro x hx
      rcases Finset.mem_union.mp (ih hx) with hx' | hx'
      · rcases Finset.mem_union.mp (hMb hx') with hx'' | hx''
        · exact Finset.mem_union_left _ hx''
        · exact Finset.mem_union_right _ hx''
      · exact Finset.mem_union_right _ hx'


end ProcInt
