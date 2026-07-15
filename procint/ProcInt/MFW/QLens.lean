import ProcInt.MFW.TransformBasic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace ProcInt.MFW

open Classical
open Finset

/-! # §30 q-Parameterized Pressure Lens -/

/-- A positive probability distribution over a finite type α. -/
structure PositiveFiniteProb (α : Type) [Fintype α] where
  p : α → ℝ
  pos : ∀ x, 0 < p x
  sum_eq_one : ∑ x, p x = 1

/-- A (possibly zero) probability distribution over α. -/
structure FiniteProb (α : Type) [Fintype α] where
  p : α → ℝ
  nonneg : ∀ x, 0 ≤ p x
  sum_eq_one : ∑ x, p x = 1

/-- The q-parameterized pressure lens deformation. -/
noncomputable def qLens {α : Type} [Fintype α] [Nonempty α] (q : ℝ) (prob : PositiveFiniteProb α) : FiniteProb α :=
  let unnorm := fun x => (prob.p x) ^ q
  let Z := ∑ x, unnorm x
  have hpos : ∀ x, 0 < unnorm x := fun x => Real.rpow_pos_of_pos (prob.pos x) q
  have hz : 0 < Z := sum_pos (fun x _ => hpos x) (by simp)
  { p := fun x => unnorm x / Z,
    nonneg := fun x => div_nonneg (le_of_lt (hpos x)) (le_of_lt hz),
    sum_eq_one := by
      dsimp [unnorm, Z]
      rw [← sum_div]
      exact div_self (ne_of_gt hz) }

/-- The q-lens ratio law: L_q(x)/L_q(y) = (p(x)/p(y))^q -/
theorem qLens_ratio_law {α : Type} [Fintype α] [Nonempty α] (q : ℝ) (prob : PositiveFiniteProb α) (x y : α) :
    (qLens q prob).p x / (qLens q prob).p y = (prob.p x / prob.p y) ^ q := by
  dsimp [qLens]
  -- (p(x)^q / Z) / (p(y)^q / Z) = p(x)^q / p(y)^q
  have h1 : ((prob.p x) ^ q / (∑ z, (prob.p z) ^ q)) / ((prob.p y) ^ q / (∑ z, (prob.p z) ^ q)) = (prob.p x) ^ q / (prob.p y) ^ q := by
    have hz : 0 < ∑ z, (prob.p z) ^ q := sum_pos (fun z _ => Real.rpow_pos_of_pos (prob.pos z) q) (by simp)
    rw [div_div_div_cancel_right₀ (ne_of_gt hz)]
  rw [h1]
  exact (Real.div_rpow (le_of_lt (prob.pos x)) (le_of_lt (prob.pos y)) q).symm

/-! # §31 Conserved Budget Apportionment -/

/-- A discrete budget apportionment of B resources across n components. -/
structure BudgetApportionment (B : ℕ) (n : ℕ) where
  alloc : Fin n → ℕ
  budget_conservation : ∑ i, alloc i = B

/-! # §32 Search Portfolio -/

/-- A search rail is either an exact completeness carrier or an exploitation rail
parameterized by a pressure exponent q. -/
inductive SearchRail
  | exact
  | exploit (q : ℝ)

/-- A search portfolio is a parallel composition of an exact completeness carrier
and a finite set of exploitation rails. -/
structure Portfolio where
  F0 : SearchRail
  is_exact : F0 = SearchRail.exact
  exploit_rails : Finset ℝ

/-! # Uninterpreted Variables for Portfolio Theory -/
variable (Served : SearchRail → ℕ → Prop)
variable (DestructivelyInterferes : SearchRail → SearchRail → Prop)
variable (Complete : SearchRail → Prop)
variable (PortfolioComplete : Portfolio → Prop)

/-! # §33 Persistent Service -/

/-- Persistent service guarantees the exact rail is scheduled infinitely often. -/
def PersistentService (F0 : SearchRail) : Prop :=
  ∀ k : ℕ, ∃ t > k, Served F0 t

/-! # §34 Exploitation Noninterference -/

/-- Exploitation noninterference requires that no exploitation rail destructively
interferes with the completeness carrier. -/
def Noninterference (P : Portfolio) : Prop :=
  ∀ q ∈ P.exploit_rails, ¬ DestructivelyInterferes (SearchRail.exploit q) P.F0

/-! # §35 Completeness Spine -/

/-- **Conjecture (Portfolio Completeness).**
If the exact rail is complete, receives persistent service, and is not destructively
interfered with, then the parallel portfolio is complete. 
Standing: CONJECTURAL. Requires an operational semantics for search rails. -/
def PortfolioCompletenessConjectural (P : Portfolio)
    (h_comp : Complete P.F0)
    (h_ps : PersistentService Served P.F0)
    (h_ni : Noninterference DestructivelyInterferes P) : Prop :=
    PortfolioComplete P

end ProcInt.MFW
