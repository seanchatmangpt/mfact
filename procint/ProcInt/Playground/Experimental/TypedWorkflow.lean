-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Workflow

/-!
# Colored Workflow Geometry

Pipeline:
`semantic colors → typed atoms → typed sequence/parallel/choice composition`.

Crown law:
sequence composition is only constructible when the output color of the left
workflow is definitionally the input color of the right workflow.

Preserves:
input/output color boundaries.

Excludes:
untyped graph splicing; runtime adequacy; POWL compiler correspondence.

Standing:
type-level composition rail.

Falsifier:
a color-mismatched `seq` term elaborates.

Downstream:
negative fixtures, typed recursive manufacture.
-/

namespace ProcInt.Playground.Experimental

/-- Semantic colors for workflow boundaries. -/
inductive Color where
  | raw
  | admitted
  | plan
  | action
  | artifact
  | receipt
  | replay
  | tensor (left right : Color)
  deriving Repr, DecidableEq, Inhabited, BEq

/--
Dependently typed workflow context.

Law: constructor indices encode composition boundaries.
Carrier: `Color → Color → Type`.
Admission: type elaboration.
Preserves: color boundaries by construction.
Refuses: mismatched sequential composition at elaboration.
Claim ceiling: typed syntax composition.
-/
inductive TWorkflow : Color → Color → Type where
  | id {color : Color} : TWorkflow color color
  | atom {input output : Color} (name : String) : TWorkflow input output
  | seq {input middle output : Color} :
      TWorkflow input middle → TWorkflow middle output →
      TWorkflow input output
  | par {input left right : Color} :
      TWorkflow input left → TWorkflow input right →
      TWorkflow input (.tensor left right)
  | choice {input output : Color} :
      TWorkflow input output → TWorkflow input output →
      TWorkflow input output

namespace TWorkflow

/-- Number of typed constructors in a workflow. -/
def size {input output : Color} :
    TWorkflow input output → Nat
  | .id => 1
  | .atom _ => 1
  | .seq left right => 1 + size left + size right
  | .par left right => 1 + size left + size right
  | .choice left right => 1 + size left + size right

/-- Erases colors into closed workflow syntax for deterministic test execution. -/
def erase {input output : Color} :
    TWorkflow input output → Workflow String Empty
  | .id => .atom "id"
  | .atom name => .atom name
  | .seq left right => .seq (erase left) (erase right)
  | .par left right => .par (erase left) (erase right)
  | .choice left right => .choice (erase left) (erase right)

end TWorkflow

end ProcInt.Playground.Experimental
