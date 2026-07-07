-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-! Worked examples over `ProcInt.Analytics.Causality`, `ProcInt.Analytics.Correlation`,
and `ProcInt.Analytics.Lifecycle`. -/

/-- A concrete causal chain over order-processing steps: order → pay → ship,
each link's target matching the next link's source, exercising
`ProcInt.CausalChain` and the `ProcInt.linked` connectedness invariant. -/
def orderChain : CausalChain String :=
  { links := [⟨"order", "pay"⟩, ⟨"pay", "ship"⟩] }

/-- The order chain is consistent (`ProcInt.CausalChain.Consistent`): each
adjacent pair of links agrees, target-to-source. -/
example : orderChain.Consistent := by
  show linked orderChain.links
  simp only [orderChain, linked]
  trivial

-- A `CausalConsistency` verdict value (`ProcInt.CausalConsistency`).
#eval CausalConsistency.consistent

/-- A correlated log pairing case ids from two logs by shared case identifier,
exercising `ProcInt.CorrelatedLog` with `ProcInt.CorrelationSchema.byCase`
semantics: `keyA`/`keyB` both project to the case id, and every pair agrees. -/
def caseLog : CorrelatedLog (String × Nat) (String × Nat) Nat :=
  { keyA := fun p => p.2
    keyB := fun p => p.2
    pairs := [(("orderPlaced", 1), ("orderShipped", 1)), (("orderPlaced", 2), ("orderShipped", 2))] }

/-- The case log is correlated (`ProcInt.CorrelatedLog.Correlated`): both pairs
share the same case id under `keyA`/`keyB`. -/
example : caseLog.Correlated := by
  intro p hp
  fin_cases hp <;> rfl

/-- A `CorrelationKey` tagging a case id `1` under the by-case schema
(`ProcInt.CorrelationSchema.byCase`, `ProcInt.CorrelationKey`). -/
def caseKeyOne : CorrelationKey Nat := { schema := .byCase, key := 1 }

-- Building the correlated log by extending the empty log, via `correlated_cons`.
example : CorrelatedLog.Correlated
    (⟨(fun p : String × Nat => p.2), (fun p : String × Nat => p.2),
      [(("orderPlaced", 1), ("orderShipped", 1))]⟩ : CorrelatedLog (String × Nat) (String × Nat) Nat) :=
  correlated_cons (correlated_empty _ _) rfl

/-- A concrete `LifecycledObject` tracking a purchase order through its OCEL 2.0
lifecycle (`ProcInt.LifecycledObject`), currently in the `.active` phase. -/
def purchaseOrder : LifecycledObject String :=
  { inner := "PO-1001", phase := .active }

/-- The lawful activation transition `created → active`
(`ProcInt.LifecycleTransition.activate`) that would have produced
`purchaseOrder`'s current phase from a freshly created object. -/
example : LifecycleTransition .created purchaseOrder.phase :=
  LifecycleTransition.activate

/-- Modifying the active purchase order is a lawful transition
(`ProcInt.LifecycleTransition.modify`), landing in `.modified`. -/
example : LifecycleTransition purchaseOrder.phase .modified :=
  LifecycleTransition.modify

/-- Once archived, the only lawful successor phase is `.deleted`
(`ProcInt.archived_only_deletes`), demonstrated on the purchase order's
archival transition. -/
example : ∀ p, LifecycleTransition .archived p → p = .deleted :=
  fun _ h => archived_only_deletes h

end ProcInt.Playground
