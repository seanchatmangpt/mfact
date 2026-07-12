import Mathlib
import ProcInt.Models.Powl

namespace ProcInt.Powl

variable {α : Type*}

/-- HTN-style hierarchical decomposition step. An unresolved workflow state (atom)
mathematically spawns a child POWL layer `W_n+1`. -/
def expandLayer (refine : α → Option (Powl α)) : Powl α → Powl α
  | .atom a => match refine a with
    | some p => p
    | none => .atom a
  | .silent => .silent
  | .xor children => .xor (children.map (expandLayer refine))
  | .loop doP redoP => .loop (expandLayer refine doP) (expandLayer refine redoP)
  | .po children prec => .po (children.map (expandLayer refine)) prec

/-- A model is bounded by layer `n` if all its atoms have a layer strictly less than `n`. -/
inductive Bounded (layer : α → ℕ) (n : ℕ) : Powl α → Prop
  | atom (a : α) : layer a < n → Bounded layer n (.atom a)
  | silent : Bounded layer n .silent
  | xor (children : List (Powl α)) : (∀ c ∈ children, Bounded layer n c) → Bounded layer n (.xor children)
  | loop (doP redoP : Powl α) : Bounded layer n doP → Bounded layer n redoP → Bounded layer n (.loop doP redoP)
  | po (children : List (Powl α)) (prec : ℕ → ℕ → Prop) : (∀ c ∈ children, Bounded layer n c) → Bounded layer n (.po children prec)

theorem Bounded.mono {layer : α → ℕ} {n m : ℕ} (h_le : n ≤ m) {p : Powl α} (h : Bounded layer n p) : Bounded layer m p := by
  induction h with
  | atom a hl => exact .atom a (Nat.lt_of_lt_of_le hl h_le)
  | silent => exact .silent
  | xor children _ ih => exact .xor children ih
  | loop doP redoP _ _ ihDo ihRedo => exact .loop _ _ ihDo ihRedo
  | po children prec _ ih => exact .po children prec ih

/-- Strict bound theorem: if an expansion strictly respects layer hierarchy
(spawns child layers bounded by the parent's layer), then applying the expansion step
preserves the overall bound. -/
theorem expandLayer_bounds_strictly {layer : α → ℕ} {refine : α → Option (Powl α)}
    (h_strict : ∀ a p, refine a = some p → Bounded layer (layer a) p)
    {n : ℕ} {p : Powl α} (h : Bounded layer n p) :
    Bounded layer n (expandLayer refine p) := by
  induction h with
  | atom a hl =>
    rw [expandLayer]
    cases h_ref : refine a with
    | none => exact .atom a hl
    | some p' =>
      have hb := h_strict a p' h_ref
      exact hb.mono (Nat.le_of_lt hl)
  | silent =>
    rw [expandLayer]
    exact .silent
  | xor children _ ih =>
    rw [expandLayer]
    refine .xor _ ?_
    intro c hc
    rw [List.mem_map] at hc
    rcases hc with ⟨c', hc', rfl⟩
    exact ih c' hc'
  | loop doP redoP _ _ ihDo ihRedo =>
    rw [expandLayer]
    exact .loop _ _ ihDo ihRedo
  | po children prec _ ih =>
    rw [expandLayer]
    refine .po _ _ ?_
    intro c hc
    rw [List.mem_map] at hc
    rcases hc with ⟨c', hc', rfl⟩
    exact ih c' hc'

end ProcInt.Powl
