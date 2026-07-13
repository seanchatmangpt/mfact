-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11.Workflow
import ProcInt.Playground.Swarm11.Supply
import ProcInt.Playground.Swarm11.Swarm
import ProcInt.Playground.Swarm11.Replay
import ProcInt.Playground.Swarm11.Experiment
import ProcInt.Playground.Swarm11.Correspondence.AtomVM

/-!
# Crown Witnesses

This module contains concrete, executable finite witnesses used by the live verifier.
They do not replace the general theorems in the imported rails.
-/

namespace ProcInt.Playground.Swarm11

namespace Crown

/-- Two independent sample events. -/
inductive Event where
  | incrementLeft
  | incrementRight
  deriving Repr, DecidableEq, BEq

/-- Concrete deterministic state for replay witnesses. -/
abbrev State := Nat × Nat

/-- Concrete deterministic transition function. -/
def step : Event → State → State
  | .incrementLeft, (left, right) => (left + 1, right)
  | .incrementRight, (left, right) => (left, right + 1)

/-- The two sample events commute in every state. -/
theorem sampleEvents_commute :
    Replay.Commute step .incrementLeft .incrementRight := by
  intro state
  cases state
  rfl

/-- Canonical sample trace. -/
def sampleTrace : List Event := [
  .incrementLeft,
  .incrementRight,
  .incrementLeft
]

/-- Canonical exact replay receipt. -/
def sampleReceipt : Replay.Receipt Event State :=
  Replay.manufactureReceipt step (0, 0) sampleTrace

/-- Concrete finite theorem-mining probe. -/
def additionIdentityExperiment : FiniteExperiment Nat where
  name := "nat-add-zero-0-1023"
  worlds := List.range 1024
  law := fun value => decide (value + 0 = value)
  render := toString

/-- Concrete refutation probe. -/
def parityExperiment : FiniteExperiment Nat where
  name := "all-naturals-under-16-even"
  worlds := List.range 16
  law := fun value => value % 2 = 0
  render := toString

/-- Runtime check that the concrete receipt final state matches replay. -/
def sampleReceiptCheck : Bool :=
  decide (
    Replay.replay step sampleReceipt.trace sampleReceipt.initial =
      sampleReceipt.final)

/-- Runtime check of the concrete independent-event swap. -/
def sampleSwapCheck : Bool :=
  decide (
    Replay.replay step
        [.incrementLeft, .incrementRight] (0, 0) =
      Replay.replay step
        [.incrementRight, .incrementLeft] (0, 0))

/-- Standing-aware crown checks consumed by `Verifier`. -/
def checks : List (String × Bool) := [
  ("addition-finite-verified",
    additionIdentityExperiment.run.standing == Standing.finiteVerified),
  ("parity-refuted",
    parityExperiment.run.standing == Standing.refuted),
  ("receipt-replays",
    sampleReceiptCheck),
  ("independent-swap-preserves-consequence",
    sampleSwapCheck),
  ("finite-verification-not-theorem",
    !Standing.finiteVerified.canClaimTheorem)
]

end Crown

end ProcInt.Playground.Swarm11
