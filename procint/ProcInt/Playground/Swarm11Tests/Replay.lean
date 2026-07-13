-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11

namespace ProcInt.Playground.Swarm11Tests

-- Sub-namespaced per file: this file and Correspondence.lean each declare
-- their own local `Event` type. In the source package both lived directly
-- under the shared `ProcIntTests` namespace, which collides the moment the
-- umbrella file imports both (found while integrating: `lake build` on the
-- umbrella fails with "environment already contains 'Event.rec'" — a real
-- defect in the delivered source, not introduced here).
namespace ReplayWalkthrough

open ProcInt.Playground.Swarm11
open ProcInt.Playground.Swarm11.Replay

inductive Event where
  | incrementLeft
  | incrementRight
  deriving Repr, DecidableEq, BEq

abbrev State := Nat × Nat

def step : Event → State → State
  | .incrementLeft, (left, right) => (left + 1, right)
  | .incrementRight, (left, right) => (left, right + 1)

theorem commute :
    Commute step Event.incrementLeft Event.incrementRight := by
  intro state
  cases state
  rfl

example :
    replay step
        [Event.incrementLeft, Event.incrementRight] (0, 0) =
      replay step
        [Event.incrementRight, Event.incrementLeft] (0, 0) := by
  exact replay_adjacent_swap_of_commute
    step [] [] Event.incrementLeft Event.incrementRight (0, 0) commute

example :
    ValidReceipt step
      (manufactureReceipt step (0, 0)
        [Event.incrementLeft, Event.incrementRight]) := by
  exact manufacturedReceipt_valid step (0, 0)
    [Event.incrementLeft, Event.incrementRight]

end ReplayWalkthrough

end ProcInt.Playground.Swarm11Tests
