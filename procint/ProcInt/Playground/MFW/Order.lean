-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.MFW.Basic

/-!
# Finite strict partial orders

POWL automatic concurrency is the incomparability exposed by a strict partial
order.  Enabled nodes form an antichain without the runtime inventing a
parallel block.
-/

namespace ProcInt.Playground.MFW

/-- A finite strict partial order over `Fin n`. -/
structure StrictOrder (n : Nat) where
  before : Fin n → Fin n → Prop
  decidableBefore : DecidableRel before
  irrefl : ∀ i, ¬ before i i
  trans : ∀ {i j k}, before i j → before j k → before i k

instance (p : StrictOrder n) : DecidableRel p.before := p.decidableBefore

/-- Two distinct nodes are structurally concurrent when neither precedes the other. -/
def Concurrent (p : StrictOrder n) (i j : Fin n) : Prop :=
  i ≠ j ∧ ¬ p.before i j ∧ ¬ p.before j i

/-- `done` is the receipted completion predicate for the current region. -/
def Enabled (p : StrictOrder n) (done : Fin n → Prop) (i : Fin n) : Prop :=
  ¬ done i ∧ ∀ j, p.before j i → done j

/-- A predicate-selected family of nodes is an antichain. -/
def IsAntichain (p : StrictOrder n) (selected : Fin n → Prop) : Prop :=
  ∀ i, selected i → ∀ j, selected j → i ≠ j → Concurrent p i j

/-- Distinct enabled nodes are necessarily incomparable. -/
theorem enabled_concurrent
    (p : StrictOrder n) (done : Fin n → Prop) {i j : Fin n}
    (hi : Enabled p done i) (hj : Enabled p done j) (hne : i ≠ j) :
    Concurrent p i j := by
  refine ⟨hne, ?_, ?_⟩
  · intro hij
    exact hi.1 (hj.2 i hij)
  · intro hji
    exact hj.1 (hi.2 j hji)

/-- The automatically enabled frontier is an antichain. -/
theorem enabled_frontier_isAntichain
    (p : StrictOrder n) (done : Fin n → Prop) :
    IsAntichain p (Enabled p done) := by
  intro i hi j hj hne
  exact enabled_concurrent p done hi hj hne

end ProcInt.Playground.MFW
