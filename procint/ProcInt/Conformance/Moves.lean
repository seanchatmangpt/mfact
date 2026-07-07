-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Conformance.Moves

Alignment moves and the standard cost function for conformance checking (Carmona, van Dongen, Solti, Weidlich, Conformance Checking, Springer 2018, ch. 7; Adriansyah, Aligning Observed and Modeled Behavior, PhD thesis TU Eindhoven 2011). Ports the SyncMove/LogOnlyMove/ModelOnlyMove witnesses of wasm4pm-compat src/conformance.rs into a single inductive with a total cost function. -/

namespace ProcInt

/-- An alignment move between an event-log trace over activities α and a
process-model run over transitions T (Carmona, van Dongen, Solti, Weidlich,
Conformance Checking 2018, ch. 7; Adriansyah 2011). A synchronous move pairs a
log activity with a model transition; a log-only move is an insertion the model
could not match; a model-only move is a skipped required step; a silent-model
move fires an invisible (tau) transition. Ported from the SyncMove, LogOnlyMove,
ModelOnlyMove witnesses in wasm4pm-compat src/conformance.rs. -/
inductive Move (α T : Type*) where
  | sync (a : α) (t : T)
  | logOnly (a : α)
  | modelOnly (t : T)
  | silentModel (t : T)

/-- The standard cost function on alignment moves (Adriansyah 2011; Carmona et
al. 2018): synchronous and silent-model moves are free, log-only and model-only
moves cost 1. -/
def Move.cost {α T : Type*} : Move α T → ℕ
  | .sync _ _ => 0
  | .logOnly _ => 1
  | .modelOnly _ => 1
  | .silentModel _ => 0

/-- Whether a move is cost-free under the standard cost function, i.e. a
synchronous or silent-model move. -/
def Move.isCostFree {α T : Type*} : Move α T → Bool
  | .sync _ _ => true
  | .logOnly _ => false
  | .modelOnly _ => false
  | .silentModel _ => true

/-- The standard cost of any single move is at most 1 (Carmona et al. 2018,
standard cost function). -/
theorem Move.cost_le_one {α T : Type*} (m : Move α T) : m.cost ≤ 1 := by
  cases m <;> simp [Move.cost]

/-- A move has zero standard cost exactly when it is synchronous or
silent-model (Adriansyah 2011). -/
theorem Move.cost_eq_zero_iff {α T : Type*} (m : Move α T) :
    m.cost = 0 ↔ m.isCostFree = true := by
  cases m <;> simp [Move.cost, Move.isCostFree]


end ProcInt
