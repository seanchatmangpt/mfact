-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.MinimalSupport
import Mathlib.Order.Antichain
import Mathlib.Data.Set.Subsingleton
import Mathlib.Data.Finset.Empty
import Mathlib.Data.Finset.Insert
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Finset.Lattice.Lemmas

/-!
# Residue antichain (Wave M0 — Crown I, obligation geometry)

Pipeline:
`MinimalSupport.lean (IsMinimalSupport, eq_of_subset_of_sufficient_of_isMinimalSupport) → this
file (ρ, residue_is_antichain, orFree_residue_subsingleton, residue_purity)`.

Crown law:
Crown I (`ROADMAP_MATH_SPINE.md` §1) types the residue as
`ρ : State × Goal → Antichain (Finset Obligation)`, not as a single residue state; disjunction
in the goal is multiplicity in the antichain. This file packages `IsMinimalSupport` (from
`MinimalSupport.lean`) as the set `residue C G g` (`ρ(G,g)` in the roadmap's shorthand, with the
semantic closure `C` carried as an explicit further parameter of this abstract wave — see
`EntailmentOrder.lean`) and proves it is genuinely an antichain under `⊆`, using
`Mathlib.Order.Antichain.IsAntichain` rather than a bespoke reimplementation.

Preserves:
genericity over `Obligation` and `C`; `residue_is_antichain` needs only `C.monotone`, not
extensivity or idempotence.

Excludes:
any broad crown theorem ("No broad crown theorem in this wave", `ROADMAP_MATH_SPINE.md` §4).
`orFree_residue_subsingleton` is proved for a *semantic* reading of "OR-free"
(`IsOrFree`, defined below) because `Obligation` carries no propositional connective structure
at this abstraction level — there is no `∨` to be syntactically free of. The correspondence from
a syntactic OR-freeness predicate on a concrete instantiated logic to `IsOrFree` is a `MISSING`
edge in the taxonomy of `AGENTS.md` §4 until a concrete `Obligation` and its connectives are
admitted; this file does not claim that bridge, only the semantic-level theorem.

Standing:
`residue_isAntichain`, `residue_is_antichain`, `orFree_residue_subsingleton`, and
`residue_purity` are `PROVEN` in this file (kernel-checked by
`lake build ProcInt.MFW.Residue.Antichain`), unconditionally for any
`C : SemanticClosure Obligation`. No `sorry`. `residue_purity` is the only theorem in this wave
that uses all three `ClosureOperator` laws (monotone, extensive, idempotent); the other three
use monotonicity alone.

Falsifier:
a proposition already in `C(G)` reported as unfinished work inside a minimal support — this is
exactly what `residue_purity` forbids (`ROADMAP_MATH_SPINE.md` §9, falsification surface).

Downstream:
Wave M1 (`ROADMAP_MATH_SPINE.md` §4, Dershowitz–Manna crown descent) and any concrete
`Obligation`/`C` instantiation.
-/

namespace ProcInt.MFW.Residue

variable {Obligation : Type*} [DecidableEq Obligation]

/-- `ρ(G,g)`: the set of minimal supports for goal `g` given context `G` under closure `C`.
Crown I types this as an `Antichain (Finset Obligation)`; `residue_isAntichain` below is the
proof obligation that makes that typing honest rather than asserted. -/
def residue (C : SemanticClosure Obligation) (G : Context Obligation) (g : Obligation) :
    Set (Support Obligation) :=
  {S | IsMinimalSupport C G g S}

variable {C : SemanticClosure Obligation} {G : Context Obligation} {g : Obligation}
  {S T : Support Obligation}

@[simp] theorem mem_residue : S ∈ residue C G g ↔ IsMinimalSupport C G g S := Iff.rfl

/-- `ρ(G,g)` is an antichain under `⊆`, in Mathlib's own `IsAntichain` sense: any two distinct
members are `⊆`-incomparable. -/
theorem residue_isAntichain : IsAntichain (· ⊆ ·) (residue C G g) := by
  intro S hS T hT hne hST
  exact hne (eq_of_subset_of_sufficient_of_isMinimalSupport hT hS.1 hST)

/-- The Wave M0 target theorem, stated in the roadmap's own notation:
`S, T ∈ ρ(G,g) ∧ S ⊆ T ⇒ S = T`. -/
theorem residue_is_antichain (hS : S ∈ residue C G g) (hT : T ∈ residue C G g) (hST : S ⊆ T) :
    S = T :=
  eq_of_subset_of_sufficient_of_isMinimalSupport hT hS.1 hST

/-- Semantic OR-freeness of a goal, at the abstraction level available to Wave M0. `Obligation`
has no propositional connective structure here (`Obligation.lean` deliberately leaves it an
uninterpreted `Type*`), so "OR-free" cannot be stated syntactically; this is the semantic gloss:
sufficiency is closed under intersection — no two supports witness a genuine either/or
branching. A concrete instantiated logic is responsible for showing its own syntactic
OR-freeness implies this predicate; that correspondence is out of scope for Wave M0. -/
def IsOrFree (C : SemanticClosure Obligation) (G : Context Obligation) (g : Obligation) : Prop :=
  ∀ S T : Support Obligation,
    IsSufficient C G g S → IsSufficient C G g T → IsSufficient C G g (S ∩ T)

/-- An OR-free goal has at most one minimal support. -/
theorem orFree_residue_subsingleton (hOrFree : IsOrFree C G g) :
    (residue C G g).Subsingleton := by
  intro S hS T hT
  have hInter : IsSufficient C G g (S ∩ T) := hOrFree S T hS.1 hT.1
  have hS' : S ∩ T = S :=
    eq_of_subset_of_sufficient_of_isMinimalSupport hS hInter Finset.inter_subset_left
  have hT' : S ∩ T = T :=
    eq_of_subset_of_sufficient_of_isMinimalSupport hT hInter Finset.inter_subset_right
  exact hS'.symm.trans hT'

/-- Residue purity — the `LogicalConsequence ≠ WorkflowActivity` law
(`ROADMAP_MATH_SPINE.md` §4, Wave M0 theorem list; §9 falsification surface): every minimal
support is disjoint from what the untouched context already entails. No minimal support ever
proposes, as unfinished work, an obligation that is already a consequence of `G` alone. Uses all
three `ClosureOperator` laws: extensivity locates `G ∪ S.erase a` below its own closure,
monotonicity moves `a`'s membership in `C G` up to `C (G ∪ S.erase a)`, and idempotence collapses
the resulting double closure. -/
theorem residue_purity (hS : S ∈ residue C G g) : S ∩ C G = ∅ := by
  by_contra hne
  obtain ⟨a, ha⟩ := Finset.nonempty_iff_ne_empty.mpr hne
  have haS : a ∈ S := (Finset.mem_inter.mp ha).1
  have haCG : a ∈ C G := (Finset.mem_inter.mp ha).2
  have hInsuff : ¬ IsSufficient C G g (S.erase a) := hS.2 a haS
  apply hInsuff
  have hGsub : G ⊆ G ∪ S.erase a := Finset.subset_union_left
  have haC' : a ∈ C (G ∪ S.erase a) := C.monotone hGsub haCG
  have hext : G ∪ S.erase a ⊆ C (G ∪ S.erase a) := C.le_closure (G ∪ S.erase a)
  have hEq : insert a (G ∪ S.erase a) = G ∪ S := by
    rw [← Finset.union_insert, Finset.insert_erase haS]
  have hsub : G ∪ S ⊆ C (G ∪ S.erase a) := by
    rw [← hEq]
    exact Finset.insert_subset haC' hext
  have hCsub : C (G ∪ S) ⊆ C (G ∪ S.erase a) := by
    have hm := C.monotone hsub
    rwa [C.idempotent] at hm
  exact hCsub hS.1

end ProcInt.MFW.Residue
