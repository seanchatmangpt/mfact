-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Ocel.Core
import ProcInt.Ocpq.Query

/-! # ProcInt.Ocpq.Cardinality

OCPQ cardinality bounds: the CardBound structure carrying the min ≤ max well-formedness law as a proof field (port of wasm4pm-compat src/ocpq.rs CardinalityBoundConst, whose law is a const where-bound, and src/ocel.rs ObjectTypeCardinality.admits), with decidable admission, trivial-bound satisfaction at both endpoints, a widening preorder, monotonicity of satisfaction under widening, and the definitional bridge to Ocpq.Query cardObjects satisfaction. -/

namespace ProcInt

/-- An inclusive cardinality bound [min, max] with the well-formedness law
min ≤ max carried as a proof field. Port of wasm4pm-compat src/ocpq.rs
CardinalityBoundConst (where the law is a const where-bound) and of
src/ocel.rs ObjectTypeCardinality's [min_count, max_count] window. -/
structure CardBound where
  min : ℕ
  max : ℕ
  le : min ≤ max

/-- A count n satisfies a cardinality bound when it lies in the inclusive
window (wasm4pm-compat src/ocel.rs fn ObjectTypeCardinality.admits). -/
def CardBound.Admits (b : CardBound) (n : ℕ) : Prop :=
  b.min ≤ n ∧ n ≤ b.max

/-- Admission is decidable: two ℕ comparisons. -/
instance CardBound.instDecidableAdmits (b : CardBound) (n : ℕ) :
    Decidable (b.Admits n) :=
  inferInstanceAs (Decidable (b.min ≤ n ∧ n ≤ b.max))

/-- Every well-formed bound admits its own lower endpoint (trivial-bound
satisfaction: uses the min ≤ max law). -/
theorem CardBound.admits_min (b : CardBound) : b.Admits b.min :=
  ⟨le_refl b.min, b.le⟩

/-- Every well-formed bound admits its own upper endpoint. -/
theorem CardBound.admits_max (b : CardBound) : b.Admits b.max :=
  ⟨b.le, le_refl b.max⟩

/-- Bound widening order: c widens b when c's window contains b's window
(lower endpoint no larger, upper endpoint no smaller). -/
def CardBound.Widens (b c : CardBound) : Prop :=
  c.min ≤ b.min ∧ b.max ≤ c.max

/-- Monotonicity of cardinality satisfaction in bound widening: any count
admitted by a bound is admitted by every widening of it. -/
theorem CardBound.admits_of_widens {b c : CardBound} (h : b.Widens c)
    {n : ℕ} (hn : b.Admits n) : c.Admits n :=
  ⟨le_trans h.1 hn.1, le_trans hn.2 h.2⟩

/-- Widening is reflexive: every bound widens itself. -/
theorem CardBound.widens_refl (b : CardBound) : b.Widens b :=
  ⟨le_refl b.min, le_refl b.max⟩

/-- Widening is transitive, making Widens a preorder on bounds. -/
theorem CardBound.widens_trans {a b c : CardBound}
    (hab : a.Widens b) (hbc : b.Widens c) : a.Widens c :=
  ⟨le_trans hbc.1 hab.1, le_trans hab.2 hbc.2⟩

/-- The OCPQ cardObjects predicate built from a CardBound is satisfied exactly
when the bound admits the length of the event's E2O object projection
(definitional bridge between Ocpq.Query satisfaction and CardBound.Admits). -/
theorem CardBound.sat_cardObjects_iff {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) (e : E) (b : CardBound) :
    (OcpqPredicate.cardObjects (O := O) (Q := Q) e b.min b.max).Sat L ↔
      b.Admits (L.objectsOf e).length :=
  Iff.rfl


end ProcInt
