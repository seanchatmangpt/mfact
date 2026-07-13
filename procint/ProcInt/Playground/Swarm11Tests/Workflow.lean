-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11

namespace ProcInt.Playground.Swarm11Tests

open ProcInt.Playground.Swarm11

inductive Op where
  | plan
  | ship
  deriving Repr, DecidableEq, BEq

inductive Hole where
  | source
  | destination
  deriving Repr, DecidableEq, BEq

def workflow : Workflow Op Hole :=
  .seq (.hole .source) (.hole .destination)

def substitute : Hole → Workflow Op Hole
  | .source => .atom .plan
  | .destination => .atom .ship

example :
    Workflow.bind workflow Workflow.hole = workflow := by
  exact Workflow.bind_right_identity workflow

example :
    Workflow.bind
        (Workflow.bind workflow substitute)
        Workflow.hole =
      Workflow.bind workflow
        (fun holeId => Workflow.bind (substitute holeId) Workflow.hole) := by
  exact Workflow.bind_assoc workflow substitute Workflow.hole

example :
    Workflow.bind workflow substitute =
      .seq (.atom .plan) (.atom .ship) := by
  rfl

end ProcInt.Playground.Swarm11Tests
