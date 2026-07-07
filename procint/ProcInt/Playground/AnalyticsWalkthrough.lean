-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt
import ProcInt.Playground.LogsModelsWalkthrough

/-! # Playground: slicing the order-fulfillment case by activity

A `ProcessCube` (`ProcInt.Analytics.Cube`) over the same order-fulfillment
trace from `LogsModelsWalkthrough`, dimensioned by activity — the
`CubeDimensionKind.activity` view of van der Aalst's process cubes. -/

namespace ProcInt.Playground

/-- The order-fulfillment events, cubed by their own activity label. -/
def orderCube : ProcessCube (Event Activity) Activity where
  events := orderTrace.events
  dim := Event.activity

-- The `paymentReceived` cell: exactly the payment event.
#eval (orderCube.cell .paymentReceived).length

/-- Every event in the `paymentReceived` cell is a cube event, and every
event in a cell projects to that cell's dimension value — the ledgered
`cell_subset`/`cell_dim` laws, instantiated on this cube. -/
example (e : Event Activity) (h : e ∈ orderCube.cell .paymentReceived) :
    e ∈ orderCube.events ∧ e.activity = .paymentReceived :=
  ⟨cell_subset h, cell_dim h⟩

/-- A slice covering both `orderPlaced` and `paymentReceived` contains the
`orderPlaced` cell entirely — the ledgered `cell_subset_slice` law. -/
example (e : Event Activity) (h : e ∈ orderCube.cell .orderPlaced) :
    e ∈ orderCube.slice [.orderPlaced, .paymentReceived] :=
  cell_subset_slice h (by simp)

end ProcInt.Playground
