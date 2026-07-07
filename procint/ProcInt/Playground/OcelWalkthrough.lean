-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt
import ProcInt.Playground.LogsModelsWalkthrough

/-! # Playground: the order-fulfillment case as an object-centric log

The same order-fulfillment story, now as an `OCEL` (`ProcInt.Ocel.Core`):
one order object and one customer object, three events relating to them,
queried via `OCPQ` predicates (`ProcInt.Ocpq.Query`, `ProcInt.Ocpq.Cardinality`). -/

namespace ProcInt.Playground

/-- The three events of the case, as OCEL event identifiers. -/
inductive EventId where
  | placed
  | paid
  | shipped
  deriving DecidableEq, Repr

/-- The two objects of the case: the order itself, and the customer who
placed it. -/
inductive Obj where
  | order1
  | customer1
  deriving DecidableEq, Repr

inductive ObjType where
  | orderType
  | customerType
  deriving DecidableEq, Repr

/-- The order-fulfillment case as an OCEL: `placed` relates to both the
order and the customer (the customer places the order); `paid`/`shipped`
relate only to the order. Attribute valuations are all absent (`none`) —
this walkthrough only exercises the relational structure. -/
def orderOcel : OCEL EventId Obj Activity ObjType String String where
  evtype
    | .placed => .orderPlaced
    | .paid => .paymentReceived
    | .shipped => .orderShipped
  time
    | .placed => 0
    | .paid => 1
    | .shipped => 2
  objtype
    | .order1 => .orderType
    | .customer1 => .customerType
  e2o :=
    [ (.placed, "places", .order1), (.placed, "places", .customer1),
      (.paid, "pays", .order1), (.shipped, "ships", .order1) ]
  o2o := [(.customer1, "owns", .order1)]
  eaval := fun _ _ => none
  oaval := fun _ _ _ => none

-- The `placed` event relates to both the order and the customer.
#eval (orderOcel.objectsOf .placed).length

/-- `paid` relates only to the order — the ledgered `OcpqPredicate` E2O
predicate is satisfied for `order1` and, since `EventId`/`Obj`/`String` are
all decidable, checked by `decide`. -/
example : (OcpqPredicate.e2oRel .paid .order1 "pays").Sat orderOcel := by decide

/-- Every event in this log relates to between 1 and 2 objects — an OCPQ
cardinality bound, checked via the ledgered `CardBound.sat_cardObjects_iff`
bridge to `OcpqPredicate.cardObjects`. -/
def eventObjectBound : CardBound where
  min := 1
  max := 2
  le := by decide

example :
    (OcpqPredicate.cardObjects (O := Obj) (Q := String) .placed 1 2).Sat orderOcel :=
  (CardBound.sat_cardObjects_iff orderOcel .placed eventObjectBound).mpr
    (by decide)

end ProcInt.Playground
