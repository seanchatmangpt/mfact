-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt
import ProcInt.Playground.LogsModelsWalkthrough

/-! # Playground: slicing the order-fulfillment cases two ways

A `ProcessCube` (`ProcInt.Analytics.Cube`) over the order-fulfillment
events from `LogsModelsWalkthrough`, dimensioned two independent ways: by
activity (`CubeDimensionKind.activity`) and, over both cases pooled
together, by which case each event belongs to (`CubeDimensionKind.time`-
style grouping) — a genuinely cross-cutting second dimension, not just a
restatement of the first. -/

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

/-- Which case an event belongs to, by its timestamp window
(`order-1`: t < 10, `order-2`: t ≥ 10) — a dimension independent of
activity, so this cube actually cross-cuts the activity-dimensioned one
above instead of restating it. -/
def caseOf (e : Event Activity) : String :=
  if e.timestamp < 10 then "order-1" else "order-2"

/-- Both order-fulfillment cases pooled, cubed by case. -/
def casesCube : ProcessCube (Event Activity) String where
  events := orderTrace.events ++ orderTrace2.events
  dim := caseOf

-- Each case cell has exactly its own 3 events.
#eval (casesCube.cell "order-1").length
#eval (casesCube.cell "order-2").length

/-- The `order-1` cell is disjoint from the `order-2` cell: no event's case
label is both — an immediate consequence of `cell_dim` on each side. -/
example (e : Event Activity) (h1 : e ∈ casesCube.cell "order-1")
    (h2 : e ∈ casesCube.cell "order-2") : False := by
  have := cell_dim h1
  have := cell_dim h2
  simp_all

end ProcInt.Playground
