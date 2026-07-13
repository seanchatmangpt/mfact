-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib
import ProcInt.Playground.Swarm11.Supply

/-!
# Swarm Capability Geometry

Pipeline:
`node capabilities + obligation requirement → covering coalitions → minimal coalitions`.

Crown law:
distinct minimal covering coalitions are incomparable under node inclusion.

Preserves:
capability requirements and coalition membership.

Excludes:
resource feasibility, timing feasibility, or AtomVM runtime reachability unless supplied separately.

Falsifier:
two distinct minimal covers are nested.
-/

namespace ProcInt.Playground.Swarm11

namespace Swarm

/--
A coalition covers an obligation when every required capability is provided by at least one member.

Law: capability coverage is existential per required capability.
Carrier: finite node coalition.
Admission: explicit membership in the coalition.
Preserves: capability identity.
Refuses: resource and timing feasibility by implication.
Claim ceiling: capability geometry.
-/
def Covers {Node Capability : Type}
    (members : Finset Node)
    (hasCapability : Node → Capability → Prop)
    (requires : Capability → Prop) : Prop :=
  ∀ capability, requires capability →
    ∃ node, node ∈ members ∧ hasCapability node capability

/-- Strict finite-set inclusion expressed without relying on order notation. -/
def StrictSubset {Node : Type}
    (smaller larger : Finset Node) : Prop :=
  smaller ⊆ larger ∧ ¬ larger ⊆ smaller

/--
A minimal covering coalition covers the requirement and no strict subcoalition does.
-/
def MinimalCover {Node Capability : Type}
    (members : Finset Node)
    (hasCapability : Node → Capability → Prop)
    (requires : Capability → Prop) : Prop :=
  Covers members hasCapability requires ∧
    ∀ smaller, StrictSubset smaller members →
      ¬ Covers smaller hasCapability requires

/--
Distinct minimal covering coalitions are incomparable.

Law: minimality excludes proper containment in either direction.
Carrier: finite capability coalitions.
Admission: both coalitions satisfy `MinimalCover`.
Preserves: the shared capability requirement.
Refuses: conclusions about cost, latency, or resource feasibility.
Claim ceiling: theorem.
-/
theorem minimalCovers_incomparable
    {Node Capability : Type}
    {left right : Finset Node}
    {hasCapability : Node → Capability → Prop}
    {requires : Capability → Prop}
    (leftMinimal : MinimalCover left hasCapability requires)
    (rightMinimal : MinimalCover right hasCapability requires)
    (hDistinct : left ≠ right) :
    (¬ left ⊆ right) ∧ (¬ right ⊆ left) := by
  constructor
  · intro hLeftRight
    have hNotRightLeft : ¬ right ⊆ left := by
      intro hRightLeft
      apply hDistinct
      apply Finset.ext
      intro node
      constructor
      · intro hNodeLeft
        exact hLeftRight hNodeLeft
      · intro hNodeRight
        exact hRightLeft hNodeRight
    exact (rightMinimal.2 left ⟨hLeftRight, hNotRightLeft⟩) leftMinimal.1
  · intro hRightLeft
    have hNotLeftRight : ¬ left ⊆ right := by
      intro hLeftRight
      apply hDistinct
      apply Finset.ext
      intro node
      constructor
      · intro hNodeLeft
        exact hLeftRight hNodeLeft
      · intro hNodeRight
        exact hRightLeft hNodeRight
    exact (leftMinimal.2 right ⟨hRightLeft, hNotLeftRight⟩) rightMinimal.1

/-- Local swarm state. No global database is implied by this structure. -/
structure LocalState
    (Node Material Obligation Receipt : Type) where
  node : Node
  semanticEpoch : Nat
  inventory : Supply.Inventory Material
  obligations : List Obligation
  receipts : List Receipt

end Swarm

end ProcInt.Playground.Swarm11
