-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Residue
import ProcInt.Playground.Experimental.Tropical
import ProcInt.Playground.Experimental.DifferenceProbe

/-!
# Experimental Crown Instrument

Pipeline:
`semantic geometry + finite law mining + residue + replay + multiscale + tropical probes`
`→ one standing-aware report`.

Crown law:
the report never infers theorem standing from finite verification.

Preserves:
per-rail standing and explicit bridge debt.

Excludes:
ambient correspondence among experimental rails.

Standing:
composite instrumentation rail.

Falsifier:
the report labels a finite experiment `PROVEN`.

Downstream:
`procint_experiment` executable and manufacturing receipts.
-/

namespace ProcInt.Playground.Experimental

/-- Sample semantic headers used to exercise the span instrument. -/
def sampleHeaders : List SemanticHeader := [
  {
    artifact := "Workflow.bind_assoc"
    coordinates := [.object, .carrier, .law, .preservation, .falsifier, .claim]
    claim := {
      name := "workflow substitution associativity"
      standing := .PROVEN
      ceiling := .theorem
    }
  },
  {
    artifact := "FiniteExperiment.run"
    coordinates := [
      .object, .carrier, .law, .admission, .refusal, .experiment,
      .receipt, .replay, .claim
    ]
    claim := {
      name := "finite law mining"
      standing := .FINITE_VERIFIED
      ceiling := .finiteDomain
    }
  },
  {
    artifact := "TWorkflow.seq"
    coordinates := [.carrier, .law, .admission, .boundary, .refusal, .claim]
    claim := {
      name := "typed workflow composition"
      standing := .PROVEN
      ceiling := .theorem
    }
  }
]

/-- Small finite experiment intentionally refuted by the first odd natural. -/
def parityConjecture : FiniteExperiment Nat where
  name := "all-small-naturals-even"
  worlds := List.range 16
  law := fun n => n % 2 = 0
  render := toString

/-- Small finite experiment verifying the identity `n + 0 = n` on an explicit domain. -/
def additionIdentityProbe : FiniteExperiment Nat where
  name := "nat-add-zero-small-world"
  worlds := List.range 1024
  law := fun n => decide (n + 0 = n)
  render := toString

/-- Deterministic arithmetic semantics for replay experiments. -/
def arithmeticSemantics (op : String) (input : Nat) : Nat :=
  if op = "inc" then input + 1
  else if op = "double" then input * 2
  else input

/-- Closed workflow used by the replay instrument. -/
def replayWorkflow : Workflow String Empty :=
  .seq (.atom "inc") (.atom "double")

/-- Example tropical graph with two weighted cycles. -/
def tropicalExample : TropicalMatrix := [
  [.val 0, .val 3],
  [.val 1, .val 1]
]

/--
Standing-aware composite experimental report.

Law: fields are direct outputs from independent rails.
Carrier: verifier-facing value object.
Admission: all component functions are total on their explicit finite inputs.
Preserves: rail separation.
Refuses: cross-rail theorem transfer.
Receipt: `Repr` projection plus deterministic component values.
Replay: pure reconstruction.
Claim ceiling: experimental instrument.
-/
structure CrownReport where
  semanticSpanRank : Nat
  additionProbe : ExperimentReport
  parityProbe : ExperimentReport
  replayReceipt : ReplayReceipt
  replayVerified : Bool
  momentSeparation : Nat
  conjectureClasses : Nat
  bestWorkflowBasisWorld : Option (Workflow TinyOp TinySocket)
  workflowRightIdentityProbe : ExperimentReport
  workflowAssociativityProbe : ExperimentReport
  squareDegreeProxy : Option Nat
  tropicalTrace : List Trop
  bridgeDebt : List String
  deriving Repr

/-- Manufactures the composite experimental crown report. -/
def crownReport : CrownReport :=
  let receipt := receiptOf arithmeticSemantics replayWorkflow 7
  {
    semanticSpanRank := spanRankProxy sampleHeaders
    additionProbe := additionIdentityProbe.run
    parityProbe := parityConjecture.run
    replayReceipt := receipt
    replayVerified := replays arithmeticSemantics replayWorkflow receipt
    momentSeparation := momentSeparation [1, 2, 3, 4, 5] [2, 2] [1, 3]
    conjectureClasses :=
      observationalClassCount (workflowWorlds 1) workflowCandidateLaws
    bestWorkflowBasisWorld := initialBestWorkflowBasisWorld 1
    workflowRightIdentityProbe := (workflowRightIdentityExperiment 1).run
    workflowAssociativityProbe := (workflowAssociativityExperiment 1).run
    squareDegreeProxy := polynomialDegreeProxy 6 squareObservations
    tropicalTrace := frozenPhaseTrace tropicalExample 8
    bridgeDebt := [
      "POWL_AIR_ADEQUACY",
      "LEAN_RUST_GRAFT",
      "MULTIFRACTAL_MEASURE_CORRESPONDENCE",
      "PLANNER_OFFSPRING_P13",
      "BLAKE3_RECEIPT_BRIDGE"
    ]
  }

end ProcInt.Playground.Experimental
