-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11

namespace ProcInt.Playground.Swarm11Tests

-- Sub-namespaced per file: see the note in Replay.lean for why (both files
-- declare their own local `Event`, which collides under the shared
-- ProcIntTests namespace the moment both are imported together).
namespace CorrespondenceWalkthrough

open ProcInt.Playground.Swarm11
open ProcInt.Playground.Swarm11.Correspondence

inductive Event where
  | increment
  deriving Repr, DecidableEq

def correspondence : StepCorrespondence Event Nat Int where
  encodeState := Int.ofNat
  abstractStep
    | .increment, state => state + 1
  runtimeStep
    | .increment, state => state + 1
  preservesStep := by
    intro event state
    cases event
    simp

example :
    correspondence.encodeState
        (Replay.replay correspondence.abstractStep
          [Event.increment, Event.increment] 3) =
      Replay.replay correspondence.runtimeStep
        [Event.increment, Event.increment]
        (correspondence.encodeState 3) := by
  exact replay_preserved correspondence
    [Event.increment, Event.increment] 3

end CorrespondenceWalkthrough

end ProcInt.Playground.Swarm11Tests
