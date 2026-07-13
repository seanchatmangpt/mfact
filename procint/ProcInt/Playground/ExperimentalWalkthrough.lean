-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental

namespace ProcInt.Playground.ExperimentalWalkthrough

open ProcInt.Playground.Experimental

-- additionIdentityProbe checks 1024 finite worlds; kernel `decide` needs more than
-- the default recursion budget to reduce that traversal.
set_option maxRecDepth 8192

example : Standing.FINITE_VERIFIED.canClaimTheorem = false := by
  decide

example : Standing.PROVEN.canClaimTheorem = true := by
  decide

example : additionIdentityProbe.run.standing = .FINITE_VERIFIED := by
  decide

example : parityConjecture.run.standing = .REFUTED := by
  decide

example : parityConjecture.run.counterexample.isSome = true := by
  decide

example : spanRankProxy sampleHeaders > 0 := by
  decide

example : momentSeparation [1, 2, 3] [2, 2] [1, 3] > 0 := by
  decide

example :
    replays arithmeticSemantics replayWorkflow
      (receiptOf arithmeticSemantics replayWorkflow 7) = true := by
  simp

def rawToPlan : TWorkflow .raw .plan :=
  .atom "plan"

def receiptToReplay : TWorkflow .receipt .replay :=
  .atom "replay"

/--
error: Application type mismatch: The argument
  receiptToReplay
has type
  TWorkflow Color.receipt Color.replay
but is expected to have type
  TWorkflow Color.plan ?m.3
in the application
  rawToPlan.seq receiptToReplay
-/
#guard_msgs(error) in
#check TWorkflow.seq rawToPlan receiptToReplay

def closureStep (state : List Nat) : List Nat :=
  if state.contains 0 then [1] else []

example : closureSucceeded (closeWithFuel closureStep 4 [0]) = true := by
  decide

def residueCloses (support : List Nat) : Bool :=
  support.contains 2 || (support.contains 0 && support.contains 1)

example :
    setEqB (minimalResidue [0, 1, 2] residueCloses) [[2], [0, 1]] = true := by
  decide


example :
    (workflowRightIdentityExperiment 1).run.standing = .FINITE_VERIFIED := by
  decide

example :
    (workflowAssociativityExperiment 1).run.standing = .FINITE_VERIFIED := by
  decide

example :
    observationalClassCount (workflowWorlds 1) workflowCandidateLaws > 1 := by
  decide

example :
    (initialBestWorkflowBasisWorld 1).isSome = true := by
  decide

example :
    polynomialDegreeProxy 6 squareObservations = some 2 := by
  decide

def mutantIdentityExperiment :
    FiniteExperiment (Workflow TinyOp TinySocket) where
  name := "mutant-right-identity"
  worlds := workflowWorlds 1
  law := fun w => decide (bindDropSeqRight w Workflow.socket = w)
  render := reprStr

example : mutantIdentityExperiment.run.standing = .REFUTED := by
  decide

example :
    (mutantIdentityExperiment.minimalCounterexampleBy
      (fun w => (Workflow.openSockets w).length)).isSome = true := by
  decide

end ProcInt.Playground.ExperimentalWalkthrough
