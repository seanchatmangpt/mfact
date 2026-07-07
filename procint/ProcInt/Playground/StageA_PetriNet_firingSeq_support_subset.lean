import Mathlib
import ProcInt.Petri.Reachability

namespace ProcInt

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
