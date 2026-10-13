-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib

/-!
# ProcInt.Playground.Multifractal.LevelSet

Generic exact and banded level-set constructors.
-/

namespace ProcInt.Playground.Multifractal

/-- Exact level set of an observable. -/
def levelSet {X A : Type*} (φ : X → A) (a : A) : Set X :=
  {x | φ x = a}

/-- Real-valued level set with absolute tolerance `ε`. -/
def bandLevelSet {X : Type*} (φ : X → ℝ) (a ε : ℝ) : Set X :=
  {x | |φ x - a| ≤ ε}

/-- Predicate-defined level set; useful when the observable is a convergence law. -/
def predicateLevelSet {X A : Type*} (P : A → X → Prop) (a : A) : Set X :=
  {x | P a x}

@[simp]
theorem mem_levelSet_iff {X A : Type*} (φ : X → A) (a : A) (x : X) :
    x ∈ levelSet φ a ↔ φ x = a :=
  Iff.rfl

@[simp]
theorem mem_bandLevelSet_iff {X : Type*} (φ : X → ℝ) (a ε : ℝ) (x : X) :
    x ∈ bandLevelSet φ a ε ↔ |φ x - a| ≤ ε :=
  Iff.rfl

/-- Increasing tolerance can only enlarge a banded level set. -/
theorem bandLevelSet_mono {X : Type*} (φ : X → ℝ) (a : ℝ) {ε δ : ℝ}
    (hεδ : ε ≤ δ) : bandLevelSet φ a ε ⊆ bandLevelSet φ a δ := by
  intro x hx
  exact hx.trans hεδ

end ProcInt.Playground.Multifractal
