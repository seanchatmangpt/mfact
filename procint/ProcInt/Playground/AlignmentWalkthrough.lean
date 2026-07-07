-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-! Worked instances of `ProcInt.Move`, `ProcInt.alignmentCost`,
`ProcInt.logProjection`/`ProcInt.modelProjection`, and `ProcInt.IsAlignment`
(`ProcInt/Conformance/Moves.lean`, `ProcInt/Conformance/Alignment.lean`),
using a toy log trace `["a", "b", "c"]` and a toy model with transitions
`ℕ`. -/

/-- A perfectly-fitting alignment: every move is synchronous, so it
reproduces the trace `["a", "b", "c"]` on the log side (`ProcInt.IsAlignment`)
and the run `[1, 2, 3]` on the model side, at zero cost
(`ProcInt.alignmentCost`, `ProcInt.Move.cost`). -/
def perfectAlignment : List (Move String ℕ) :=
  [Move.sync "a" 1, Move.sync "b" 2, Move.sync "c" 3]

example : logProjection perfectAlignment = ["a", "b", "c"] := rfl
example : modelProjection perfectAlignment = [1, 2, 3] := rfl
example : IsAlignment perfectAlignment ["a", "b", "c"] := rfl
example : alignmentCost perfectAlignment = 0 := rfl

-- every move of `perfectAlignment` is synchronous, hence cost-free.
#eval perfectAlignment.map Move.isCostFree

/-- A deviating alignment for the same trace: an extra log activity `"x"`
that the model could not match (`Move.logOnly`), and a required model step
`5` that the log never performed (`Move.modelOnly`). The log projection
still reproduces `["a", "x", "b", "c"]` exactly (`ProcInt.IsAlignment`), but
the total cost is now `2` (one per deviation, `ProcInt.Move.cost`). -/
def deviatingAlignment : List (Move String ℕ) :=
  [Move.sync "a" 1, Move.logOnly "x", Move.sync "b" 2, Move.modelOnly 5,
    Move.sync "c" 3]

example : logProjection deviatingAlignment = ["a", "x", "b", "c"] := rfl
example : modelProjection deviatingAlignment = [1, 2, 5, 3] := rfl
example : IsAlignment deviatingAlignment ["a", "x", "b", "c"] := rfl
example : alignmentCost deviatingAlignment = 2 := rfl

-- concatenating the perfect and deviating alignments adds their costs
-- (`ProcInt.alignmentCost_append`): 0 + 2 = 2.
example :
    alignmentCost (perfectAlignment ++ deviatingAlignment) = 2 := by
  rw [alignmentCost_append]
  rfl

/-- A silent-model move (an invisible/tau transition, `Move.silentModel`) is
cost-free just like a synchronous move (`ProcInt.Move.cost_eq_zero_iff`), and
contributes to the model projection but not the log projection. -/
def alignmentWithTau : List (Move String ℕ) :=
  [Move.sync "a" 1, Move.silentModel 99, Move.sync "b" 2]

example : logProjection alignmentWithTau = ["a", "b"] := rfl
example : modelProjection alignmentWithTau = [1, 99, 2] := rfl
example : alignmentCost alignmentWithTau = 0 := by
  have h := (alignmentCost_zero_iff_all_costfree alignmentWithTau).mpr
  apply h
  intro m hm
  simp [alignmentWithTau] at hm
  rcases hm with h | h | h <;> subst h <;> rfl

end ProcInt.Playground
