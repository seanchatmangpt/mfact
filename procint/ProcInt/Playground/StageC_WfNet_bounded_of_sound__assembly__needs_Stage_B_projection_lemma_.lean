import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

/-! ### Reproduced Stage C prerequisites (loop-cut step) -/

noncomputable def PetriNet.markingSeq {P T : Type} (N : PetriNet P T) :
    Marking P → List T → List (Marking P)
  | _, [] => []
  | M, t :: σ => N.fire M t :: N.markingSeq (N.fire M t) σ

noncomputable def PetriNet.markingTrace {P T : Type} (N : PetriNet P T)
    (M0 : Marking P) (σ : List T) : List (Marking P) :=
  M0 :: N.markingSeq M0 σ

@[simp] theorem PetriNet.markingSeq_nil {P T : Type} (N : PetriNet P T) (M : Marking P) :
    N.markingSeq M [] = [] := rfl

theorem PetriNet.markingSeq_cons {P T : Type} (N : PetriNet P T) (M : Marking P) (t : T)
    (σ : List T) :
    N.markingSeq M (t :: σ) = N.fire M t :: N.markingSeq (N.fire M t) σ := rfl

@[simp] theorem PetriNet.markingSeq_length {P T : Type} (N : PetriNet P T) (M : Marking P)
    (σ : List T) :
    (N.markingSeq M σ).length = σ.length := by
  induction σ generalizing M with
  | nil => rfl
  | cons t σ ih => simp [markingSeq_cons, ih]

@[simp] theorem PetriNet.markingTrace_length {P T : Type} (N : PetriNet P T) (M0 : Marking P)
    (σ : List T) :
    (N.markingTrace M0 σ).length = σ.length + 1 := by
  simp [markingTrace]

theorem PetriNet.FiringSeq.split {P T : Type} (N : PetriNet P T) {M0 M : Marking P}
    {σ : List T} (h : N.FiringSeq M0 σ M) (i : ℕ) (hi : i ≤ σ.length) :
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

theorem PetriNet.FiringSeq.trans {P T : Type} (N : PetriNet P T) {M0 M1 M2 : Marking P}
    {σ1 σ2 : List T} (h1 : N.FiringSeq M0 σ1 M1) (h2 : N.FiringSeq M1 σ2 M2) :
    N.FiringSeq M0 (σ1 ++ σ2) M2 := by
  induction h1 with
  | nil M => simpa using h2
  | cons hstep _ ih => exact .cons hstep (ih h2)

/-- Inversion of `FiringSeq` on the empty transition list: the marking is
unchanged. -/
theorem PetriNet.FiringSeq.nil_inv {P T : Type} {N : PetriNet P T} {M M' : Marking P}
    (h : N.FiringSeq M [] M') : M = M' := by
  cases h with
  | nil _ => rfl

/-- Firing sequences are deterministic: the same starting marking and
transition list always reach the same final marking (immediate consequence
of `step_deterministic`, lifted along the `FiringSeq` induction). -/
theorem PetriNet.FiringSeq.deterministic {P T : Type} (N : PetriNet P T) {M0 M1 M2 : Marking P}
    {σ : List T} (h1 : N.FiringSeq M0 σ M1) (h2 : N.FiringSeq M0 σ M2) : M1 = M2 := by
  induction h1 generalizing M2 with
  | nil M => exact PetriNet.FiringSeq.nil_inv h2
  | cons hstep _ ih =>
      cases h2 with
      | cons hstep2 hσ'2 =>
          obtain rfl := N.step_deterministic hstep hstep2
          exact ih hσ'2

/-- Inversion of `FiringSeq` on a snoc'd transition list: peel off the last
step. Dual of `FiringSeq.snoc`. -/
theorem PetriNet.FiringSeq.append_singleton_inv {P T : Type} (N : PetriNet P T)
    {M0 M'' : Marking P} {σ : List T} {t : T} (h : N.FiringSeq M0 (σ ++ [t]) M'') :
    ∃ M', N.FiringSeq M0 σ M' ∧ N.Step M' t M'' := by
  induction σ generalizing M0 with
  | nil =>
      cases h with
      | cons hstep hrest =>
          cases hrest with
          | nil _ => exact ⟨M0, PetriNet.FiringSeq.nil M0, hstep⟩
  | cons t' σ' ih =>
      cases h with
      | cons hstep hrest =>
          obtain ⟨M', hM', hStep⟩ := ih hrest
          exact ⟨M', PetriNet.FiringSeq.cons hstep hM', hStep⟩

/-! ### `markingSeq`/`markingTrace` commute with `List.take` -/

theorem PetriNet.markingSeq_take {P T : Type} (N : PetriNet P T) (M0 : Marking P)
    (σ : List T) (i : ℕ) :
    N.markingSeq M0 (σ.take i) = (N.markingSeq M0 σ).take i := by
  induction σ generalizing M0 i with
  | nil => simp
  | cons t σ' ih =>
      cases i with
      | zero => simp
      | succ i' =>
          rw [List.take_succ_cons, markingSeq_cons, ih (N.fire M0 t) i',
            ← List.take_succ_cons (a := N.fire M0 t) (as := N.markingSeq (N.fire M0 t) σ'),
            markingSeq_cons]

theorem PetriNet.markingTrace_take {P T : Type} (N : PetriNet P T) (M0 : Marking P)
    (σ : List T) (i : ℕ) :
    N.markingTrace M0 (σ.take i) = (N.markingTrace M0 σ).take (i + 1) := by
  simp [markingTrace, markingSeq_take, List.take_succ_cons]

theorem PetriNet.markingTrace_prefix_of_prefix {P T : Type} (N : PetriNet P T) (M0 : Marking P)
    {σ σ' : List T} (h : σ <+: σ') :
    N.markingTrace M0 σ <+: N.markingTrace M0 σ' := by
  obtain ⟨i, hi, rfl⟩ : ∃ i ≤ σ'.length, σ = σ'.take i :=
    ⟨σ.length, h.length_le, (List.prefix_iff_eq_take.mp h)⟩
  rw [markingTrace_take]
  exact List.take_prefix _ _

/-- **Loop-cut / repetition-free reachability.** If `M` is reachable from
`M0`, it is reachable by a firing sequence whose visited markings
(including both endpoints) are pairwise distinct. (Reproduced from the
already-closed Stage C "loop-cut" Playground step.) -/
theorem PetriNet.reaches_repetitionFree {P T : Type} (N : PetriNet P T) {M0 M : Marking P}
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

/-! ### `PetriNet.Run` : repetition-free valid firing sequences from `M0` -/

def PetriNet.Run {P T : Type} (N : PetriNet P T) (M0 : Marking P) : Type :=
  {σ : List T // ∃ M, N.FiringSeq M0 σ M ∧ (N.markingTrace M0 σ).Pairwise (· ≠ ·)}

namespace PetriNet.Run

variable {P T : Type} {N : PetriNet P T} {M0 : Marking P}

theorem isRun_of_prefix {σ σ' : List T}
    (hr : ∃ M, N.FiringSeq M0 σ' M ∧ (N.markingTrace M0 σ').Pairwise (· ≠ ·))
    (hpre : σ <+: σ') :
    ∃ M, N.FiringSeq M0 σ M ∧ (N.markingTrace M0 σ).Pairwise (· ≠ ·) := by
  obtain ⟨M', hfire, hpw⟩ := hr
  have hlen : σ.length ≤ σ'.length := hpre.length_le
  refine ⟨(N.markingTrace M0 σ').get ⟨σ.length, by simp [PetriNet.markingTrace_length]; omega⟩,
    ?_, ?_⟩
  · have hσeq : σ = σ'.take σ.length := List.prefix_iff_eq_take.mp hpre
    have hres := (hfire.split N σ.length hpre.length_le).1
    rw [← hσeq] at hres
    exact hres
  · exact hpw.sublist (N.markingTrace_prefix_of_prefix M0 hpre).sublist

instance : PartialOrder (PetriNet.Run N M0) where
  le r₁ r₂ := r₁.1 <+: r₂.1
  le_refl _ := List.prefix_rfl
  le_trans _ _ _ h₁ h₂ := h₁.trans h₂
  le_antisymm r₁ r₂ h₁ h₂ :=
    Subtype.ext (h₁.eq_of_length (h₁.length_le.antisymm h₂.length_le))

theorem le_iff (r₁ r₂ : PetriNet.Run N M0) : r₁ ≤ r₂ ↔ r₁.1 <+: r₂.1 := Iff.rfl

def bot : PetriNet.Run N M0 :=
  ⟨[], M0, PetriNet.FiringSeq.nil M0, by simp [PetriNet.markingTrace]⟩

instance : OrderBot (PetriNet.Run N M0) where
  bot := bot
  bot_le _ := List.nil_prefix

@[simp] theorem bot_val : (⊥ : PetriNet.Run N M0).1 = [] := rfl

theorem length_lt_of_lt {r₁ r₂ : PetriNet.Run N M0} (h : r₁ < r₂) :
    r₁.1.length < r₂.1.length := by
  obtain ⟨hle, hnot⟩ := h
  rcases lt_or_eq_of_le hle.length_le with hlt | heq
  · exact hlt
  · exact absurd (Subtype.ext (hle.eq_of_length heq) ▸ List.prefix_rfl) hnot

theorem lt_wf : WellFounded (@LT.lt (PetriNet.Run N M0) _) :=
  have H : Subrelation (@LT.lt (PetriNet.Run N M0) _)
      (InvImage (· < ·) (fun r : PetriNet.Run N M0 => r.1.length)) :=
    fun {_ _} h => length_lt_of_lt h
  Subrelation.wf H <| InvImage.wf _ wellFounded_lt

instance : WellFoundedLT (PetriNet.Run N M0) := ⟨lt_wf⟩

instance : IsStronglyAtomic (PetriNet.Run N M0) :=
  IsStronglyAtomic.of_wellFounded_lt lt_wf

/-! ### Finiteness of one-step extensions (covers) given `[Fintype T]` -/

def takeRun (r' : PetriNet.Run N M0) (i : ℕ) : PetriNet.Run N M0 :=
  ⟨r'.1.take i, isRun_of_prefix r'.2 (List.take_prefix _ _)⟩

@[simp] theorem takeRun_val (r' : PetriNet.Run N M0) (i : ℕ) :
    (takeRun r' i).1 = r'.1.take i := rfl

theorem lt_take_succ_lt {r r' : PetriNet.Run N M0} (h : r < r') {i : ℕ}
    (hi1 : r.1.length ≤ i) (hi2 : i + 1 < r'.1.length) :
    r < takeRun r' (i + 1) ∧ takeRun r' (i + 1) < r' := by
  have hle : r.1 <+: r'.1 := h.le
  have hrlen : r.1.length ≤ r'.1.length := hle.length_le
  have hσeq : r.1 = r'.1.take r.1.length := List.prefix_iff_eq_take.mp hle
  have hpre1 : r.1 <+: r'.1.take (i + 1) := by
    rw [hσeq]
    exact List.take_prefix_take_left (by omega)
  constructor
  · refine ⟨hpre1, fun hcontra => ?_⟩
    have hlen2 := hcontra.length_le
    simp only [takeRun_val, List.length_take] at hlen2
    omega
  · refine ⟨List.take_prefix _ _, fun hcontra => ?_⟩
    have hlen2 := hcontra.length_le
    simp only [takeRun_val, List.length_take] at hlen2
    omega

theorem covBy_iff_length_succ {r r' : PetriNet.Run N M0} (h : r < r') :
    r ⋖ r' ↔ r'.1.length = r.1.length + 1 := by
  constructor
  · intro hcov
    by_contra hne
    have hlt := length_lt_of_lt h
    have hgap : r.1.length + 1 < r'.1.length := by omega
    obtain ⟨h1, h2⟩ := lt_take_succ_lt h (le_refl r.1.length) hgap
    exact hcov.2 h1 h2
  · intro hlen
    refine ⟨h, fun c h1 h2 => ?_⟩
    have hc1 := length_lt_of_lt h1
    have hc2 := length_lt_of_lt h2
    omega

noncomputable def coverTransition {r r' : PetriNet.Run N M0} (h : r ⋖ r') : T :=
  r'.1[r.1.length]'(by
    have hlen := (covBy_iff_length_succ h.lt).mp h
    omega)

theorem coverTransition_spec {r r' : PetriNet.Run N M0} (h : r ⋖ r') :
    r'.1 = r.1 ++ [coverTransition h] := by
  have hlen := (covBy_iff_length_succ h.lt).mp h
  have hpre : r.1 <+: r'.1 := h.le
  apply List.ext_getElem
  · simp [hlen]
  · intro n h1 h2
    rcases Nat.lt_or_ge n r.1.length with hn | hn
    · rw [List.getElem_append_left hn]
      exact (hpre.getElem hn).symm
    · have hn' : n = r.1.length := by omega
      subst hn'
      simp [coverTransition, List.getElem_append_right]

theorem finite_setOf_covBy [Fintype T] (r : PetriNet.Run N M0) :
    {x | r ⋖ x}.Finite := by
  have hinj : Function.Injective (fun x : {x // r ⋖ x} => coverTransition x.2) := by
    rintro ⟨r₁, h₁⟩ ⟨r₂, h₂⟩ heq
    simp only at heq
    have hσ : r₁.1 = r₂.1 := by
      rw [coverTransition_spec h₁, coverTransition_spec h₂, heq]
    exact Subtype.ext (Subtype.ext hσ)
  have hfin : Finite {x : PetriNet.Run N M0 // r ⋖ x} := Finite.of_injective _ hinj
  exact Set.finite_coe_iff.mp hfin

/-! ### The end marking of a run -/

/-- The marking reached at the end of a run (extracted from the run's
existential witness via choice; propositionally unique by
`FiringSeq.deterministic`). -/
noncomputable def endMarking (r : PetriNet.Run N M0) : Marking P := r.2.choose

theorem endMarking_spec (r : PetriNet.Run N M0) : N.FiringSeq M0 r.1 (endMarking r) :=
  r.2.choose_spec.1

theorem endMarking_pairwise (r : PetriNet.Run N M0) :
    (N.markingTrace M0 r.1).Pairwise (· ≠ ·) := r.2.choose_spec.2

/-- `endMarking` agrees with any other `FiringSeq` witness for the same
run (determinism transported through the choice). -/
theorem endMarking_eq_of_firingSeq {r : PetriNet.Run N M0} {M : Marking P}
    (h : N.FiringSeq M0 r.1 M) : endMarking r = M :=
  PetriNet.FiringSeq.deterministic N (endMarking_spec r) h

/-- `endMarking r` is exactly the last entry of `r`'s marking trace. -/
theorem endMarking_eq_get (r : PetriNet.Run N M0) :
    endMarking r = (N.markingTrace M0 r.1).get
      ⟨r.1.length, by simp [PetriNet.markingTrace_length]⟩ := by
  have hsplit := (endMarking_spec r).split N r.1.length le_rfl
  have htake : r.1.take r.1.length = r.1 := List.take_length
  have hdrop : r.1.drop r.1.length = [] := List.drop_length
  have h1 := hsplit.1
  rw [htake] at h1
  have h2 := hsplit.2
  rw [hdrop] at h2
  -- h1 : FiringSeq M0 r.1 (trace.get ⟨r.1.length,_⟩)
  -- h2 : FiringSeq (trace.get ⟨r.1.length,_⟩) [] (endMarking r)
  exact (PetriNet.FiringSeq.nil_inv h2).symm

/-- The end marking of a run is a marking reachable from `M0`. -/
theorem reaches_endMarking (r : PetriNet.Run N M0) : N.Reaches M0 (endMarking r) :=
  N.firingSeq_reaches (endMarking_spec r)

/-- `endMarking_eq_get`, restated in `getElem` bracket notation. -/
theorem endMarking_eq_getElem (r : PetriNet.Run N M0) :
    endMarking r = (N.markingTrace M0 r.1)[r.1.length]'
      (by simp [PetriNet.markingTrace_length]) := by
  simpa [List.get_eq_getElem] using endMarking_eq_get r

/-- Generalized form of `endMarking_eq_getElem`, letting the index be
supplied as an arbitrary `n` provably equal to `r.1.length` (useful when
`r.1.length` needs to be rewritten to some other expression, e.g. `i`,
before matching against another trace). -/
theorem endMarking_eq_getElem' (r : PetriNet.Run N M0) (n : ℕ) (hn : n = r.1.length)
    (h : n < (N.markingTrace M0 r.1).length) :
    endMarking r = (N.markingTrace M0 r.1)[n]'h := by
  subst hn; exact endMarking_eq_getElem r

end PetriNet.Run

/-! ### Every reachable marking is the end marking of some run -/

theorem PetriNet.exists_run_endMarking_eq {P T : Type} (N : PetriNet P T) {M0 M : Marking P}
    (h : N.Reaches M0 M) : ∃ r : PetriNet.Run N M0, PetriNet.Run.endMarking r = M := by
  obtain ⟨σ, hσ, hpw⟩ := N.reaches_repetitionFree h
  refine ⟨⟨σ, M, hσ, hpw⟩, ?_⟩
  exact PetriNet.Run.endMarking_eq_of_firingSeq hσ

/-! ### Unboundedness gives infinitely many runs -/

theorem PetriNet.infinite_run_of_unbounded {P T : Type} [DecidableEq P] (N : PetriNet P T)
    (M0 : Marking P) (hunbounded : ¬ ∃ k, N.Bounded M0 k) :
    Infinite (PetriNet.Run N M0) := by
  have hReachInf : Set.Infinite {M | N.Reaches M0 M} :=
    fun hfin => hunbounded (PetriNet.bounded_of_finite_reach N M0 hfin)
  haveI : Infinite {M // N.Reaches M0 M} := Set.infinite_coe_iff.mpr hReachInf
  classical
  let φ : {M // N.Reaches M0 M} → PetriNet.Run N M0 :=
    fun M => (N.exists_run_endMarking_eq M.2).choose
  have hφspec : ∀ M : {M // N.Reaches M0 M},
      PetriNet.Run.endMarking (φ M) = M.1 :=
    fun M => (N.exists_run_endMarking_eq M.2).choose_spec
  have hφinj : Function.Injective φ := by
    intro M1 M2 heq
    have h1 := hφspec M1
    have h2 := hφspec M2
    rw [heq] at h1
    exact Subtype.ext (h1.symm.trans h2)
  exact Infinite.of_injective φ hφinj

/-! ### The main Kőnig-lemma application -/

theorem PetriNet.exists_infinite_injective_run {P T : Type} [Fintype T] [DecidableEq P]
    (N : PetriNet P T) (M0 : Marking P) (hunbounded : ¬ ∃ k, N.Bounded M0 k) :
    ∃ g : ℕ → Marking P, Function.Injective g ∧ ∀ i, ∃ t, N.Step (g i) t (g (i + 1)) := by
  haveI : Infinite (PetriNet.Run N M0) := N.infinite_run_of_unbounded M0 hunbounded
  have hUniv : Set.Ici (⊥ : PetriNet.Run N M0) = Set.univ :=
    Set.eq_univ_of_forall (fun a => Set.mem_Ici.mpr bot_le)
  have hIciInf : (Set.Ici (⊥ : PetriNet.Run N M0)).Infinite := by
    rw [hUniv]; exact Set.infinite_univ
  obtain ⟨f, hf0, hfcov⟩ :=
    exists_orderEmbedding_covby_of_forall_covby_finite_of_bot
      (α := PetriNet.Run N M0) PetriNet.Run.finite_setOf_covBy
  -- length (f i).1 = i
  have hflen : ∀ i, (f i).1.length = i := by
    intro i
    induction i with
    | zero => rw [hf0]; simp [PetriNet.Run.bot_val]
    | succ n ih =>
        have := (PetriNet.Run.covBy_iff_length_succ (hfcov n).lt).mp (hfcov n)
        rw [this, ih]
  -- monotonicity of f
  have hfmono : ∀ {i j : ℕ}, i ≤ j → f i ≤ f j := by
    intro i j hij
    exact f.le_iff_le.mpr hij
  -- the transition witnessing each cover
  let t : ℕ → T := fun i => PetriNet.Run.coverTransition (hfcov i)
  have htspec : ∀ i, (f (i + 1)).1 = (f i).1 ++ [t i] :=
    fun i => PetriNet.Run.coverTransition_spec (hfcov i)
  -- the induced marking sequence
  let g : ℕ → Marking P := fun i => PetriNet.Run.endMarking (f i)
  -- Key case: distinct end markings for indices in strict order.
  have hkey : ∀ i j : ℕ, i < j → g i ≠ g j := by
    intro i j hlt hEq
    have hle : f i ≤ f j := hfmono (le_of_lt hlt)
    have hpre : (f i).1 <+: (f j).1 := hle
    have htrpre : N.markingTrace M0 (f i).1 <+: N.markingTrace M0 (f j).1 :=
      N.markingTrace_prefix_of_prefix M0 hpre
    have hlenfi : (N.markingTrace M0 (f i).1).length = i + 1 := by
      simp [PetriNet.markingTrace_length, hflen i]
    have hlenfj : (N.markingTrace M0 (f j).1).length = j + 1 := by
      simp [PetriNet.markingTrace_length, hflen j]
    have hiltfi : i < (N.markingTrace M0 (f i).1).length := by omega
    have hiltfj : i < (N.markingTrace M0 (f j).1).length := by omega
    have hjltfj : j < (N.markingTrace M0 (f j).1).length := by omega
    -- g i lands on index i of (f j)'s trace
    have hgi : g i = (N.markingTrace M0 (f j).1)[i]'hiltfj := by
      have e1 : g i = (N.markingTrace M0 (f i).1)[i]'hiltfi :=
        PetriNet.Run.endMarking_eq_getElem' (f i) i (hflen i).symm hiltfi
      have e2 : (N.markingTrace M0 (f i).1)[i]'hiltfi
          = (N.markingTrace M0 (f j).1)[i]'hiltfj := htrpre.getElem hiltfi
      exact e1.trans e2
    -- g j lands on index j of (f j)'s trace
    have hgj : g j = (N.markingTrace M0 (f j).1)[j]'hjltfj :=
      PetriNet.Run.endMarking_eq_getElem' (f j) j (hflen j).symm hjltfj
    have hpwj := PetriNet.Run.endMarking_pairwise (f j)
    rw [List.pairwise_iff_getElem] at hpwj
    exact hpwj i j hiltfj hjltfj hlt (hgi ▸ hgj ▸ hEq)
  refine ⟨g, ?_, ?_⟩
  · -- injectivity
    intro i j hij
    rcases lt_trichotomy i j with hlt | heq | hlt
    · exact absurd hij (hkey i j hlt)
    · exact heq
    · exact absurd hij.symm (hkey j i hlt)
  · -- consecutive Step
    intro i
    refine ⟨t i, ?_⟩
    have hend := PetriNet.Run.endMarking_spec (f (i + 1))
    rw [htspec i] at hend
    obtain ⟨M', hM', hStep⟩ := PetriNet.FiringSeq.append_singleton_inv N hend
    have : M' = g i := (PetriNet.Run.endMarking_eq_of_firingSeq hM').symm
    rwa [this] at hStep

/-! ### `PetriNet.unbounded_self_cover` : an unbounded net self-covers

Combine the infinite injective marking sequence above (Kőnig's lemma on the
`Run` order) with support confinement (`firingSeq_support_subset`, Stage A)
and Dickson's lemma over the confined finite-support markings
(`Marking.exists_le_of_support_subset`, Stage A / WQO) to find two indices
`m < n` along the sequence with `g m ≤ g n`; injectivity of `g` then forces
`R := g n - g m ≠ 0`, and the chain of `Step`s from `g m` to `g n` witnesses
`N.Reaches (g m) (g m + R)`. -/

theorem PetriNet.Run.endMarking_bot {P T : Type} (N : PetriNet P T) (M0 : Marking P) :
    PetriNet.Run.endMarking (⊥ : PetriNet.Run N M0) = M0 :=
  PetriNet.Run.endMarking_eq_of_firingSeq (PetriNet.FiringSeq.nil M0)

theorem PetriNet.unbounded_self_cover {P T : Type} [Fintype T] [DecidableEq P]
    (N : PetriNet P T) (M0 : Marking P) (hunbounded : ¬ ∃ k, N.Bounded M0 k) :
    ∃ M R : Marking P, N.Reaches M0 M ∧ N.Reaches M (M + R) ∧ R ≠ 0 := by
  haveI : Infinite (PetriNet.Run N M0) := N.infinite_run_of_unbounded M0 hunbounded
  have hUniv : Set.Ici (⊥ : PetriNet.Run N M0) = Set.univ :=
    Set.eq_univ_of_forall (fun a => Set.mem_Ici.mpr bot_le)
  have hIciInf : (Set.Ici (⊥ : PetriNet.Run N M0)).Infinite := by
    rw [hUniv]; exact Set.infinite_univ
  obtain ⟨f, hf0, hfcov⟩ :=
    exists_orderEmbedding_covby_of_forall_covby_finite_of_bot
      (α := PetriNet.Run N M0) PetriNet.Run.finite_setOf_covBy
  have hflen : ∀ i, (f i).1.length = i := by
    intro i
    induction i with
    | zero => rw [hf0]; simp [PetriNet.Run.bot_val]
    | succ n ih =>
        have := (PetriNet.Run.covBy_iff_length_succ (hfcov n).lt).mp (hfcov n)
        rw [this, ih]
  have hfmono : ∀ {i j : ℕ}, i ≤ j → f i ≤ f j := fun {i j} hij => f.le_iff_le.mpr hij
  let t : ℕ → T := fun i => PetriNet.Run.coverTransition (hfcov i)
  have htspec : ∀ i, (f (i + 1)).1 = (f i).1 ++ [t i] :=
    fun i => PetriNet.Run.coverTransition_spec (hfcov i)
  let g : ℕ → Marking P := fun i => PetriNet.Run.endMarking (f i)
  have hg0 : g 0 = M0 := by
    show PetriNet.Run.endMarking (f 0) = M0
    rw [hf0]
    exact PetriNet.Run.endMarking_bot N M0
  have hkey : ∀ i j : ℕ, i < j → g i ≠ g j := by
    intro i j hlt hEq
    have hle : f i ≤ f j := hfmono (le_of_lt hlt)
    have hpre : (f i).1 <+: (f j).1 := hle
    have htrpre : N.markingTrace M0 (f i).1 <+: N.markingTrace M0 (f j).1 :=
      N.markingTrace_prefix_of_prefix M0 hpre
    have hlenfi : (N.markingTrace M0 (f i).1).length = i + 1 := by
      simp [PetriNet.markingTrace_length, hflen i]
    have hlenfj : (N.markingTrace M0 (f j).1).length = j + 1 := by
      simp [PetriNet.markingTrace_length, hflen j]
    have hiltfi : i < (N.markingTrace M0 (f i).1).length := by omega
    have hiltfj : i < (N.markingTrace M0 (f j).1).length := by omega
    have hjltfj : j < (N.markingTrace M0 (f j).1).length := by omega
    have hgi : g i = (N.markingTrace M0 (f j).1)[i]'hiltfj := by
      have e1 : g i = (N.markingTrace M0 (f i).1)[i]'hiltfi :=
        PetriNet.Run.endMarking_eq_getElem' (f i) i (hflen i).symm hiltfi
      have e2 : (N.markingTrace M0 (f i).1)[i]'hiltfi
          = (N.markingTrace M0 (f j).1)[i]'hiltfj := htrpre.getElem hiltfi
      exact e1.trans e2
    have hgj : g j = (N.markingTrace M0 (f j).1)[j]'hjltfj :=
      PetriNet.Run.endMarking_eq_getElem' (f j) j (hflen j).symm hjltfj
    have hpwj := PetriNet.Run.endMarking_pairwise (f j)
    rw [List.pairwise_iff_getElem] at hpwj
    exact hpwj i j hiltfj hjltfj hlt (hgi ▸ hgj ▸ hEq)
  have hginj : Function.Injective g := by
    intro i j hij
    rcases lt_trichotomy i j with hlt | heq | hlt
    · exact absurd hij (hkey i j hlt)
    · exact heq
    · exact absurd hij.symm (hkey j i hlt)
  have hgstep : ∀ i, ∃ t', N.Step (g i) t' (g (i + 1)) := by
    intro i
    refine ⟨t i, ?_⟩
    have hend := PetriNet.Run.endMarking_spec (f (i + 1))
    rw [htspec i] at hend
    obtain ⟨M', hM', hStep⟩ := PetriNet.FiringSeq.append_singleton_inv N hend
    have hMg : M' = g i := (PetriNet.Run.endMarking_eq_of_firingSeq hM').symm
    rwa [hMg] at hStep
  have hgFS : ∀ i, N.FiringSeq M0 (f i).1 (g i) := fun i => PetriNet.Run.endMarking_spec (f i)
  set S : Finset P := M0.support ∪ Finset.univ.biUnion (fun t => (N.post t).support) with hSdef
  have hgsupp : ∀ i, (g i).support ⊆ S := fun i => N.firingSeq_support_subset (hgFS i)
  obtain ⟨m, n, hmn, hle⟩ := Marking.exists_le_of_support_subset S g hgsupp
  have hchain : ∀ i j, i ≤ j → N.Reaches (g i) (g j) := by
    intro i j hij
    induction j with
    | zero =>
        have hz : i = 0 := Nat.le_zero.mp hij
        subst hz; exact Relation.ReflTransGen.refl
    | succ k ih =>
        rcases Nat.lt_or_ge i (k + 1) with hlt | hge
        · have hik : i ≤ k := by omega
          obtain ⟨t', hstep⟩ := hgstep k
          exact (ih hik).tail ⟨t', hstep⟩
        · have hik : i = k + 1 := by omega
          subst hik; exact Relation.ReflTransGen.refl
  have hReachM : N.Reaches M0 (g m) := hg0 ▸ hchain 0 m (Nat.zero_le m)
  have hReachMN : N.Reaches (g m) (g n) := hchain m n (le_of_lt hmn)
  have heq : g m + (g n - g m) = g n := add_tsub_cancel_of_le hle
  refine ⟨g m, g n - g m, hReachM, ?_, ?_⟩
  · rw [heq]; exact hReachMN
  · intro hR0
    rw [hR0, add_zero] at heq
    exact (hginj.ne (ne_of_lt hmn)) heq

/-! ### Final assembly: soundness implies boundedness of the short-circuited net

`unbounded_self_cover` applied (by contradiction) to `W.shortCircuit`
produces a self-covering pump `M`, `R ≠ 0` reachable from `[i]` inside the
short-circuited net. The two projection steps (`shortCircuit_reaches_project`,
Stage B) translate this pump into a genuine original-net witness that the
final marking `[o]` is coverable by a strictly larger marking
`[o] + R`, `R ≠ 0`, from `[i]` — contradicting `Sound.proper_completion`. -/

theorem WfNet.bounded_of_sound {P T : Type} [DecidableEq P] [Fintype T] {W : WfNet P T}
    (h : W.Sound) : ∃ k, W.shortCircuit.Bounded W.initialMarking k := by
  by_contra hcon
  obtain ⟨M, R, hReachM, hReachMR, hRne⟩ :=
    PetriNet.unbounded_self_cover W.shortCircuit W.initialMarking hcon
  -- Project `M` back into the original net: `M` is net-reachable from `[i]`.
  have hReachNetM : W.net.Reaches W.initialMarking M :=
    WfNet.shortCircuit_reaches_project h.proper_completion M hReachM
  -- Option-to-complete: from `M`, the original net reaches the final marking.
  have hReachNetMFinal : W.net.Reaches M W.finalMarking :=
    h.option_to_complete M hReachNetM
  -- Embed that run into the short-circuited net, then shift it by `R`.
  have hReachSCMFinal : W.shortCircuit.Reaches M W.finalMarking :=
    WfNet.reaches_shortCircuit W hReachNetMFinal
  have hReachSCShift : W.shortCircuit.Reaches (M + R) (W.finalMarking + R) :=
    PetriNet.reaches_add W.shortCircuit R hReachSCMFinal
  -- Chain: `[i] --SC--> M --SC--> M + R --SC--> [o] + R`.
  have hReachSCTotal : W.shortCircuit.Reaches W.initialMarking (W.finalMarking + R) :=
    (hReachM.trans hReachMR).trans hReachSCShift
  -- Project the total run back into the original net.
  have hReachNetTotal : W.net.Reaches W.initialMarking (W.finalMarking + R) :=
    WfNet.shortCircuit_reaches_project h.proper_completion (W.finalMarking + R) hReachSCTotal
  -- Proper completion forces `[o] + R = [o]`, hence `R = 0`, contradiction.
  have hle : W.finalMarking ≤ W.finalMarking + R := le_self_add
  have heq : W.finalMarking + R = W.finalMarking :=
    h.proper_completion (W.finalMarking + R) hReachNetTotal hle
  apply hRne
  have h0 : W.finalMarking + R = W.finalMarking + 0 := by rwa [add_zero]
  exact add_left_cancel h0

end ProcInt
