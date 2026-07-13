-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib

/-!
# Stoichiometric Supply Conservation

Pipeline:
`inventory + admitted activity count × stoichiometric column → next inventory`.

Crown law:
a conservative activity preserves the unweighted global inventory total.

Preserves:
exact integer material balance.

Excludes:
economic value conservation, mass conservation with unequal unit weights, and logistics timing.

Falsifier:
a column whose coefficient sum is zero changes `total`.
-/

namespace ProcInt.Playground.Swarm11

namespace Supply

open scoped BigOperators

/-- Integer inventory vector indexed by material type. -/
abbrev Inventory (Material : Type) := Material → Int

/--
Stoichiometric activity matrix.

`coeff material activity` is the signed inventory change produced by one unit of activity.
-/
structure Stoichiometry (Material Activity : Type) where
  coeff : Material → Activity → Int

/-- Applies an integer number of activity units to inventory. -/
def applyActivity {Material Activity : Type}
    (matrix : Stoichiometry Material Activity)
    (activity : Activity)
    (units : Int)
    (inventory : Inventory Material) : Inventory Material :=
  fun material => inventory material + units * matrix.coeff material activity

/-- Unweighted total over a finite material universe. -/
def total {Material : Type} [Fintype Material] [DecidableEq Material]
    (inventory : Inventory Material) : Int :=
  ∑ material, inventory material

/-- A stoichiometric column is conservative when its coefficients sum to zero. -/
def ConservativeAt {Material Activity : Type}
    [Fintype Material] [DecidableEq Material]
    (matrix : Stoichiometry Material Activity)
    (activity : Activity) : Prop :=
  ∑ material, matrix.coeff material activity = 0

/--
Conservative stoichiometric activities preserve the unweighted inventory total.

Law: `Σ(S·a) = 0 → total(x + k(S·a)) = total(x)`.
Carrier: finite integer inventory vectors.
Admission: explicit `ConservativeAt` proof.
Preserves: unweighted total.
Refuses: weighted physical-mass or economic-value interpretation.
Claim ceiling: theorem.
-/
theorem total_applyActivity_of_conservative
    {Material Activity : Type}
    [Fintype Material] [DecidableEq Material]
    (matrix : Stoichiometry Material Activity)
    (activity : Activity)
    (inventory : Inventory Material)
    (units : Int)
    (hConservative : ConservativeAt matrix activity) :
    total (applyActivity matrix activity units inventory) = total inventory := by
  unfold total applyActivity ConservativeAt at *
  calc
    (∑ material, (inventory material + units * matrix.coeff material activity))
        = (∑ material, inventory material) +
            ∑ material, units * matrix.coeff material activity := by
              rw [Finset.sum_add_distrib]
    _ = (∑ material, inventory material) +
          units * (∑ material, matrix.coeff material activity) := by
            rw [Finset.mul_sum]
    _ = ∑ material, inventory material := by
          simp [hConservative]

/-- A nonnegative inventory state. -/
def Nonnegative {Material : Type}
    (inventory : Inventory Material) : Prop :=
  ∀ material, 0 ≤ inventory material

/-- Material requirements expressed as natural quantities. -/
abbrev Requirement (Material : Type) := Material → Nat

/-- Inventory can satisfy a requirement when every required quantity is available. -/
def Feasible {Material : Type}
    (inventory : Inventory Material)
    (requirement : Requirement Material) : Prop :=
  ∀ material, Int.ofNat (requirement material) ≤ inventory material

end Supply

end ProcInt.Playground.Swarm11
