import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability

/-! Playground scratch file for Stage C step: `PetriNet.Run` order +
`IsStronglyAtomic` instance.  Hand-authored, unledgered — never rendered by
ggen.  Depends on the already-landed (but not yet ported) Stage C
`markingSeq`/`markingTrace`/`FiringSeq.split`/`FiringSeq.trans` machinery
from `StageC_PetriNet_reaches_repetitionFree__loop_cut_.lean`, reproduced
here locally. -/

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

/-- The trace of a prefix of `σ` is a (list-)prefix of the trace of `σ`. -/
theorem PetriNet.markingTrace_prefix_of_prefix {P T : Type} (N : PetriNet P T) (M0 : Marking P)
    {σ σ' : List T} (h : σ <+: σ') :
    N.markingTrace M0 σ <+: N.markingTrace M0 σ' := by
  obtain ⟨i, hi, rfl⟩ : ∃ i ≤ σ'.length, σ = σ'.take i :=
    ⟨σ.length, h.length_le, (List.prefix_iff_eq_take.mp h)⟩
  rw [markingTrace_take]
  exact List.take_prefix _ _

/-! ### `PetriNet.Run` : repetition-free valid firing sequences from `M0` -/

/-- A run of `N` from `M0` is a firing sequence (as a transition list `σ`)
that is valid (`N.FiringSeq M0 σ M` for some reached `M`) and
repetition-free in the sense of `reaches_repetitionFree`: its visited
marking trace has pairwise-distinct entries.  Bundled as a subtype of
`List T` (rather than a structure carrying `M` as data) so that two runs
are equal iff their underlying transition lists are equal — `M` is a
`Prop`-erased existential witness, uniquely determined by `σ` via
`FiringSeq` determinism but never needed as data for the order structure. -/
def PetriNet.Run {P T : Type} (N : PetriNet P T) (M0 : Marking P) : Type :=
  {σ : List T // ∃ M, N.FiringSeq M0 σ M ∧ (N.markingTrace M0 σ).Pairwise (· ≠ ·)}

namespace PetriNet.Run

variable {P T : Type} {N : PetriNet P T} {M0 : Marking P}

/-- Every prefix of a run's transition list is itself (the transition
list of) a run: `FiringSeq` restricts along `FiringSeq.split`, and
pairwise-distinctness of the trace restricts along the list-prefix
relation on `markingTrace` (a prefix is a sublist, and `Pairwise`
restricts to sublists). -/
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

/-- The order on runs: `r₁ ≤ r₂` iff `r₁`'s transition list is a prefix of
`r₂`'s. -/
instance : PartialOrder (PetriNet.Run N M0) where
  le r₁ r₂ := r₁.1 <+: r₂.1
  le_refl _ := List.prefix_rfl
  le_trans _ _ _ h₁ h₂ := h₁.trans h₂
  le_antisymm r₁ r₂ h₁ h₂ :=
    Subtype.ext (h₁.eq_of_length (h₁.length_le.antisymm h₂.length_le))

theorem le_iff (r₁ r₂ : PetriNet.Run N M0) : r₁ ≤ r₂ ↔ r₁.1 <+: r₂.1 := Iff.rfl

/-- The empty run: the unique run with no transitions fired. -/
def bot : PetriNet.Run N M0 :=
  ⟨[], M0, PetriNet.FiringSeq.nil M0, by simp [PetriNet.markingTrace]⟩

instance : OrderBot (PetriNet.Run N M0) where
  bot := bot
  bot_le _ := List.nil_prefix

/-- If `r₁ < r₂` then `r₁`'s transition list is strictly shorter. -/
theorem length_lt_of_lt {r₁ r₂ : PetriNet.Run N M0} (h : r₁ < r₂) :
    r₁.1.length < r₂.1.length := by
  obtain ⟨hle, hnot⟩ := h
  rcases lt_or_eq_of_le hle.length_le with hlt | heq
  · exact hlt
  · exact absurd (Subtype.ext (hle.eq_of_length heq) ▸ List.prefix_rfl) hnot

/-- The strict order on runs is well-founded: transition-list length
strictly increases along `<`, and `ℕ`'s usual order is well-founded. -/
theorem lt_wf : WellFounded (@LT.lt (PetriNet.Run N M0) _) :=
  have H : Subrelation (@LT.lt (PetriNet.Run N M0) _)
      (InvImage (· < ·) (fun r : PetriNet.Run N M0 => r.1.length)) :=
    fun {_ _} h => length_lt_of_lt h
  Subrelation.wf H <| InvImage.wf _ wellFounded_lt

instance : WellFoundedLT (PetriNet.Run N M0) := ⟨lt_wf⟩

/-- Runs of `N` from `M0` form a strongly atomic order: for `r₁ < r₂` there
is some `r` with `r₁ ⋖ r ≤ r₂` (immediate from well-foundedness of `<`, via
`IsStronglyAtomic.of_wellFounded_lt`; strict decreasing chains in `<` are
impossible since transition-list length strictly increases along `<` and
`ℕ` is well-ordered). -/
instance : IsStronglyAtomic (PetriNet.Run N M0) :=
  IsStronglyAtomic.of_wellFounded_lt lt_wf

/-- The prefix `r'.1.take i` of `r'`'s transition list, bundled back up as
a run (valid by `isRun_of_prefix`). -/
def takeRun (r' : PetriNet.Run N M0) (i : ℕ) : PetriNet.Run N M0 :=
  ⟨r'.1.take i, isRun_of_prefix r'.2 (List.take_prefix _ _)⟩

@[simp] theorem takeRun_val (r' : PetriNet.Run N M0) (i : ℕ) :
    (takeRun r' i).1 = r'.1.take i := rfl

/-- A prefix `σ'.take (i+1)` of `σ'` that is longer than a given prefix
`σ`, viewed as a run (via `takeRun`), strictly between `⟨σ,…⟩` and
`⟨σ',…⟩` in the run order — the key intermediate witness used to show
that a cover step changes transition-list length by exactly one. -/
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

/-- A cover step in the run order corresponds exactly to extending the
transition list by one transition: `r ⋖ r'` iff `r'`'s list has length
exactly one more than `r`'s. Given this, `r ⋖ r'` determines `r'` from `r`
and a single transition `t` (`r'.1 = r.1 ++ [t]`), which is the fact used
below to show the set of covers of any run is finite when `T` is finite. -/
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

/-- Given `r ⋖ r'`, the extending transition, extracted as the element of
`r'.1` at index `r.1.length` (the unique new entry, since `r'.1 = r.1 ++
[this element]`). -/
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

/-- **Local finiteness of the run order.** When `T` is finite, every run
has only finitely many one-step extensions (covers): each cover is
determined by the single transition it appends (`coverTransition`), an
injective map into the finite type `T`. This is exactly the local
finiteness hypothesis (`hfin`) required to apply Kőnig's infinity lemma
(`exists_seq_covby_of_forall_covby_finite`) to the run order. -/
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

end PetriNet.Run

end ProcInt
