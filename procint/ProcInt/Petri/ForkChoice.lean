-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

set_option linter.unusedSectionVars false

/-! # ProcInt.Petri.ForkChoice

Fork-choice termination and head uniqueness for the S8 heaviest-chain law
(strata-consensus-pack `CONSENSUS_CONSTANTS`, `TIE_BREAK = "lower-nonce"`:
equal-total-work tips resolve to the lower tip nonce; no wall-clock, no RNG,
no node identity).

A chain DAG is a finite block type with parent links, per-block heights
(bounded by a protocol constant `heightCap`), cumulative chain work, and
nonces. `selectTip` walks from a block toward the heaviest child, terminating
by well-founded recursion on the remaining height budget
`heightCap - height`. `IsHead` selects the block whose heaviest-work /
lower-nonce order is maximal; heads are unique because the order is total and
(work, nonce) identifies a block.
-/

namespace ProcInt

/-- Protocol constants for the fork-choice court (mirrors
`strata-consensus-pack` `CONSENSUS_CONSTANTS`: `TIE_BREAK = "lower-nonce"`). -/
structure ForkChoiceConstants where
  /-- hard height cap of the chain DAG -/
  heightCap : ℕ
  /-- tie-break nonce cap (documentation constant; the uniqueness proof needs
  no nonce bound, only the lower-nonce rule itself) -/
  nonceCap : ℕ

/-- A finite chain DAG: blocks carry height, cumulative chain work, and a
nonce; `parent` links each block to its predecessor. Law fields enforce
well-formedness: parents are strictly lower, work accumulates, and (work,
nonce) identifies a block (making the lower-nonce tie-break pick a unique
head). -/
structure ChainDag (α : Type) [Fintype α] where
  height : α → ℕ
  work : α → ℕ
  nonce : α → ℕ
  parent : α → Option α
  /-- a parent is strictly lower than its child -/
  parent_lt : ∀ b, ∀ p ∈ (parent b), height p < height b
  /-- cumulative work: a child outweighs its parent -/
  work_mono : ∀ b, ∀ p ∈ (parent b), work p < work b
  /-- blocks are identified by (work, nonce) — the fork-choice key -/
  key_inj : ∀ a b, work a = work b → nonce a = nonce b → a = b

variable {α : Type} [Fintype α] [DecidableEq α]

/-- The strict "better tip" order: heavier work wins; equal work resolves to
the lower nonce (`TIE_BREAK = "lower-nonce"`). -/
def Better (d : ChainDag α) (a b : α) : Prop :=
  d.work a > d.work b ∨ (d.work a = d.work b ∧ d.nonce a < d.nonce b)

theorem better_irrefl (d : ChainDag α) (b : α) : ¬ Better d b b := by
  intro h
  rcases h with h | ⟨h, n⟩
  · omega
  · omega

theorem better_trans (d : ChainDag α) {a b c : α} (h1 : Better d a b) (h2 : Better d b c) :
    Better d a c := by
  rcases h1 with h1 | ⟨e1, n1⟩
  · rcases h2 with h2 | ⟨e2, n2⟩
    · exact Or.inl (by omega)
    · exact Or.inl (by omega)
  · rcases h2 with h2 | ⟨e2, n2⟩
    · exact Or.inl (by omega)
    · exact Or.inr ⟨by omega, by omega⟩

/-- Trichotomy: the tie-break order decides every pair (totality is what makes
the head unique; equal work and equal nonce force equal blocks by
`key_inj`). -/
theorem better_total (d : ChainDag α) (a b : α) : a = b ∨ Better d a b ∨ Better d b a := by
  rcases lt_trichotomy (d.work a) (d.work b) with h | h | h
  · exact Or.inr (Or.inr (Or.inl h))
  · rcases lt_trichotomy (d.nonce a) (d.nonce b) with n | n | n
    · exact Or.inr (Or.inl (Or.inr ⟨h, n⟩))
    · exact Or.inl (d.key_inj a b h n)
    · exact Or.inr (Or.inr (Or.inr ⟨h.symm, n⟩))
  · exact Or.inr (Or.inl (Or.inl h))

/-- A head is a block not strictly beaten by any block under the
heaviest-work / lower-nonce order. -/
def IsHead (d : ChainDag α) (b : α) : Prop := ∀ x, ¬ Better d x b

/-- **Head existence**: a nonempty chain DAG admits a head — take the max-work
block, then the min-nonce block among the max-work blocks. -/
theorem head_exists (d : ChainDag α) [Nonempty α] : ∃ b, IsHead d b := by
  obtain ⟨m, hmax⟩ := Finite.exists_max (α := α) (fun b => d.work b)
  -- the max-work class is a finite nonempty set; pick its min-nonce element
  have hfin : {x : α | d.work x = d.work m}.Finite := Set.toFinite _
  have hne : {x : α | d.work x = d.work m}.Nonempty := ⟨m, rfl⟩
  obtain ⟨c, hcmax, hcmin⟩ := Set.exists_min_image {x : α | d.work x = d.work m}
    (fun x => d.nonce x) hfin hne
  refine ⟨c, fun x hx => ?_⟩
  have hxle : d.work x ≤ d.work m := hmax x
  have hcm : d.work c = d.work m := hcmax
  rcases hx with hx | ⟨he, hn⟩
  · omega
  · have hxc : d.work x = d.work c := by omega
    have hmem : d.work x = d.work m := by omega
    have hmin := hcmin x hmem
    omega

/-- **Head uniqueness (TIE_BREAK lower-nonce)**: two heads are equal. -/
theorem head_unique (d : ChainDag α) {b c : α} (hb : IsHead d b) (hc : IsHead d c) :
    b = c := by
  rcases better_total d b c with e | h1 | h2
  · exact e
  · exact absurd h1 (hc b)
  · exact absurd h2 (hb c)

/-- The maximum-height budget: any head sits at a block whose height is
bounded by the protocol height cap. -/
theorem head_height_le (d : ChainDag α) {b : α} (_hb : IsHead d b)
    {H : ℕ} (hcap : ∀ x, d.height x ≤ H) : d.height b ≤ H := hcap b

/-- The children of a block: blocks whose parent is that block. -/
def children (d : ChainDag α) (b : α) : Finset α :=
  Finset.univ.filter (fun c => d.parent c = some b)

theorem mem_children {d : ChainDag α} {b c : α} :
    c ∈ children d b ↔ d.parent c = some b := by
  simp [children]

/-- Existence of a heaviest child of a nonempty child set: maximal work,
minimal nonce on ties (`TIE_BREAK = "lower-nonce"`). -/
theorem heaviestChild_exists (d : ChainDag α) (b : α) (hne : children d b ≠ ∅) :
    ∃ c, d.parent c = some b ∧ ∀ x, d.parent x = some b → ¬ Better d x c := by
  have hne' : (children d b).Nonempty := Finset.nonempty_of_ne_empty hne
  obtain ⟨m, hm, hmax⟩ := Finset.exists_max_image (s := children d b) (fun x => d.work x) hne'
  obtain ⟨c, hc, hcmin⟩ := Finset.exists_min_image
    (s := (children d b).filter (fun x => d.work x = d.work m)) (fun x => d.nonce x)
    ⟨m, Finset.mem_filter.2 ⟨hm, rfl⟩⟩
  have hchild : d.parent c = some b := mem_children.1 (Finset.mem_filter.1 hc).1
  have hcm : d.work c = d.work m := (Finset.mem_filter.1 hc).2
  refine ⟨c, hchild, ?_⟩
  intro x hx hbet
  have hxc : c ∈ children d b := mem_children.2 hchild
  have hxm : d.work x ≤ d.work m := hmax x (mem_children.2 hx)
  have hcm2 : d.work c ≤ d.work m := hmax c hxc
  rcases hbet with h | ⟨he, hn⟩
  · omega
  · have hwm : d.work x = d.work m := by omega
    have hx' : x ∈ (children d b).filter (fun x => d.work x = d.work m) :=
      Finset.mem_filter.2 ⟨mem_children.2 hx, hwm⟩
    have h1 := hcmin x hx'
    have h2 := hcmin c (Finset.mem_filter.2 ⟨hxc, hcm⟩)
    omega

/-- A chosen heaviest child of a nonempty child set (classical choice over the
existence lemma; deterministic because the choice is unique up to the
totality of the tie-break order). -/
noncomputable def heaviestChild (d : ChainDag α) (b : α) (hne : children d b ≠ ∅) : α :=
  Classical.choose (heaviestChild_exists d b hne)

theorem heaviestChild_mem (d : ChainDag α) (b : α) (hne : children d b ≠ ∅) :
    d.parent (heaviestChild d b hne) = some b :=
  (Classical.choose_spec (heaviestChild_exists d b hne)).1

theorem heaviestChild_is_max (d : ChainDag α) (b : α) (hne : children d b ≠ ∅) :
    ∀ x, d.parent x = some b → ¬ Better d x (heaviestChild d b hne) :=
  (Classical.choose_spec (heaviestChild_exists d b hne)).2

/-- The well-founded measure: remaining height budget under the protocol cap. -/
def tipMeasure (d : ChainDag α) (K : ForkChoiceConstants) (b : α) : ℕ :=
  K.heightCap - d.height b

/-- **Termination measure lemma**: a child strictly decreases the measure,
because parents are strictly lower than children and heights are capped by
the protocol `heightCap`. -/
theorem tipMeasure_lt_of_parent {d : ChainDag α} {K : ForkChoiceConstants} {b c : α}
    (hc : d.parent c = some b) (hcap : ∀ x, d.height x ≤ K.heightCap) :
    tipMeasure d K c < tipMeasure d K b := by
  have hlt : d.height b < d.height c := d.parent_lt c b hc
  have hb := hcap b
  have hc' := hcap c
  unfold tipMeasure
  omega

/-- `selectTip` walks from a block to the heaviest chain tip above it: if the
block has no children it is a tip; otherwise descend into the heaviest child
(heavier work first, equal work resolved to the lower nonce via
`heaviestChild`). Well-founded on the remaining height budget
`K.heightCap - height`: each recursive call strictly decreases `tipMeasure`
by `tipMeasure_lt_of_parent`, so the walk terminates after at most
`heightCap` steps. -/
noncomputable def selectTip (d : ChainDag α) (K : ForkChoiceConstants)
    (hcap : ∀ x, d.height x ≤ K.heightCap) : (b : α) → α
  | b =>
    if h : children d b = ∅ then b
    else
      have : tipMeasure d K (heaviestChild d b h) < tipMeasure d K b :=
        tipMeasure_lt_of_parent (heaviestChild_mem d b h) hcap
      selectTip d K hcap (heaviestChild d b h)
  termination_by b => tipMeasure d K b
  decreasing_by exact this

/-- Terminal blocks of the walk are exactly the leaves of the DAG. -/
theorem selectTip_eq_self_of_isTip (d : ChainDag α) (K : ForkChoiceConstants)
    (hcap : ∀ x, d.height x ≤ K.heightCap) (b : α) (htip : children d b = ∅) :
    selectTip d K hcap b = b := by
  rw [selectTip, dif_pos htip]

end ProcInt
