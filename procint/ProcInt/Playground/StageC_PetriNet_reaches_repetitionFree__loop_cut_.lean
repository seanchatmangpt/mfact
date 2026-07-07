import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability

/-! Playground scratch file for Stage C step:
`PetriNet.reaches_repetitionFree` (loop-cut).

Hand-authored, unledgered. Never rendered by ggen. -/

namespace ProcInt

variable {P T : Type}

/-- Data-level recursion computing the list of markings visited *after*
each transition of `σ`, starting from `M0`, using the deterministic `fire`
function directly (not the `Step` relation, so this is plain structural
recursion on `σ`, independent of any `FiringSeq` proof). -/
noncomputable def PetriNet.markingSeq (N : PetriNet P T) : Marking P → List T → List (Marking P)
  | _, [] => []
  | M, t :: σ => N.fire M t :: N.markingSeq (N.fire M t) σ

/-- The full trace of markings visited along `σ` starting at `M0`,
including the starting marking. -/
noncomputable def PetriNet.markingTrace (N : PetriNet P T) (M0 : Marking P) (σ : List T) :
    List (Marking P) :=
  M0 :: N.markingSeq M0 σ

@[simp] theorem PetriNet.markingSeq_nil (N : PetriNet P T) (M : Marking P) :
    N.markingSeq M [] = [] := rfl

theorem PetriNet.markingSeq_cons (N : PetriNet P T) (M : Marking P) (t : T) (σ : List T) :
    N.markingSeq M (t :: σ) = N.fire M t :: N.markingSeq (N.fire M t) σ := rfl

@[simp] theorem PetriNet.markingSeq_length (N : PetriNet P T) (M : Marking P) (σ : List T) :
    (N.markingSeq M σ).length = σ.length := by
  induction σ generalizing M with
  | nil => rfl
  | cons t σ ih => simp [markingSeq_cons, ih]

@[simp] theorem PetriNet.markingTrace_length (N : PetriNet P T) (M0 : Marking P) (σ : List T) :
    (N.markingTrace M0 σ).length = σ.length + 1 := by
  simp [markingTrace]

/-- Splitting lemma: a firing sequence `M0 --σ--> M` can be split at any
index `i ≤ σ.length` into a prefix ending at the `i`-th trace marking and a
suffix starting there. This connects the data-level `markingSeq` /
`markingTrace` to the proof-level `FiringSeq` relation. -/
theorem PetriNet.FiringSeq.split (N : PetriNet P T) {M0 M : Marking P} {σ : List T}
    (h : N.FiringSeq M0 σ M) (i : ℕ) (hi : i ≤ σ.length) :
    N.FiringSeq M0 (σ.take i)
        ((N.markingTrace M0 σ).get ⟨i, by simp [markingTrace_length]; omega⟩) ∧
    N.FiringSeq ((N.markingTrace M0 σ).get ⟨i, by simp [markingTrace_length]; omega⟩)
        (σ.drop i) M := by
  induction h generalizing i with
  | nil M =>
      simp only [List.length_nil] at hi
      have : i = 0 := by omega
      subst this
      refine ⟨?_, ?_⟩ <;> simp [markingTrace, PetriNet.FiringSeq.nil]
  | @cons M0 M1 M t σ' hstep hσ' ih =>
      cases i with
      | zero =>
          refine ⟨?_, ?_⟩
          · simpa [markingTrace, markingSeq_cons] using PetriNet.FiringSeq.nil M0
          · simpa [markingTrace, markingSeq_cons] using PetriNet.FiringSeq.cons hstep hσ'
      | succ i' =>
          have hi' : i' ≤ σ'.length := by simpa using hi
          obtain ⟨ihL, ihR⟩ := ih i' hi'
          have hM1 : M1 = N.fire M0 t := hstep.2
          have hget : (N.markingTrace M0 (t :: σ')).get
                ⟨i' + 1, by simp [markingTrace_length]; omega⟩
              = (N.markingTrace M1 σ').get ⟨i', by simp [markingTrace_length]; omega⟩ := by
            simp [markingTrace, markingSeq_cons, hM1]
          constructor
          · rw [hget]
            simpa [List.take_cons] using PetriNet.FiringSeq.cons hstep ihL
          · rw [hget]
            simpa [List.drop_cons] using ihR

/-- Composition of two firing sequences into one over the concatenated
transition list. -/
theorem PetriNet.FiringSeq.trans (N : PetriNet P T) {M0 M1 M2 : Marking P} {σ1 σ2 : List T}
    (h1 : N.FiringSeq M0 σ1 M1) (h2 : N.FiringSeq M1 σ2 M2) :
    N.FiringSeq M0 (σ1 ++ σ2) M2 := by
  induction h1 with
  | nil M => simpa using h2
  | cons hstep _ ih => exact .cons hstep (ih h2)

/-- **Loop-cut / repetition-free reachability.** If `M` is reachable from
`M0`, it is reachable by a firing sequence whose visited markings
(including both endpoints) are pairwise distinct. -/
theorem PetriNet.reaches_repetitionFree (N : PetriNet P T) {M0 M : Marking P}
    (h : N.Reaches M0 M) :
    ∃ σ, N.FiringSeq M0 σ M ∧ (N.markingTrace M0 σ).Pairwise (· ≠ ·) := by
  obtain ⟨σ0, hσ0⟩ := N.reaches_firingSeq h
  suffices H : ∀ n (σ : List T), σ.length ≤ n → N.FiringSeq M0 σ M →
      ∃ σ', N.FiringSeq M0 σ' M ∧ (N.markingTrace M0 σ').Pairwise (· ≠ ·) by
    exact H σ0.length σ0 le_rfl hσ0
  intro n
  induction n using Nat.strong_induction_on with
  | _ n IH =>
    intro σ hlen hσ
    by_cases hnodup : (N.markingTrace M0 σ).Pairwise (· ≠ ·)
    · exact ⟨σ, hσ, hnodup⟩
    · have hnodup' : ¬ (N.markingTrace M0 σ).Nodup := by
        rw [List.nodup_iff_pairwise_ne]; exact hnodup
      rw [List.nodup_iff_injective_get] at hnodup'
      simp only [Function.Injective, not_forall] at hnodup'
      obtain ⟨a, b, hab, hne⟩ := hnodup'
      obtain ⟨i, j, hij, heq⟩ :
          ∃ i j : Fin (N.markingTrace M0 σ).length, i.1 < j.1 ∧
            (N.markingTrace M0 σ).get i = (N.markingTrace M0 σ).get j := by
        rcases lt_or_gt_of_ne (fun heqv => hne (Fin.ext heqv)) with hlt | hlt
        · exact ⟨a, b, hlt, hab⟩
        · exact ⟨b, a, hlt, hab.symm⟩
      have hi_le : i.1 ≤ σ.length := by
        have hb := i.2; simp [markingTrace_length] at hb; omega
      have hj_le : j.1 ≤ σ.length := by
        have hb := j.2; simp [markingTrace_length] at hb; omega
      obtain ⟨splitI1, splitI2⟩ := hσ.split N i.1 hi_le
      obtain ⟨splitJ1, splitJ2⟩ := hσ.split N j.1 hj_le
      -- The Fin used inside `split` and `i`/`j` themselves agree by proof
      -- irrelevance on the `.isLt` field (both have value `i.1` / `j.1`).
      have hMi : (N.markingTrace M0 σ).get ⟨i.1, by simp [markingTrace_length]; omega⟩
          = (N.markingTrace M0 σ).get i := by cases i; rfl
      have hMj : (N.markingTrace M0 σ).get ⟨j.1, by simp [markingTrace_length]; omega⟩
          = (N.markingTrace M0 σ).get j := by cases j; rfl
      rw [hMi] at splitI1 splitI2
      rw [hMj] at splitJ1 splitJ2
      have hglue : N.FiringSeq M0 (σ.take i.1) ((N.markingTrace M0 σ).get j) := heq ▸ splitI1
      have hnew : N.FiringSeq M0 (σ.take i.1 ++ σ.drop j.1) M := hglue.trans N splitJ2
      have hshort : (σ.take i.1 ++ σ.drop j.1).length < σ.length := by
        have ht : (σ.take i.1).length = i.1 := by
          rw [List.length_take]; omega
        have hd : (σ.drop j.1).length = σ.length - j.1 := List.length_drop
        simp [ht, hd]
        omega
      have hshort_n : (σ.take i.1 ++ σ.drop j.1).length < n :=
        lt_of_lt_of_le hshort hlen
      exact IH _ hshort_n _ le_rfl hnew

end ProcInt

#print axioms ProcInt.PetriNet.reaches_repetitionFree
