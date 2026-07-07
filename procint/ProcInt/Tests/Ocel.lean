-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Ocel.Core

/-! # ProcInt.Tests.Ocel

OCEL 2.0 oracles (Level 1-2): the order-to-items pattern (one event, two related objects), the dual event projection, and the absent-object case projecting to nothing. -/

namespace ProcInt

/-- Order-to-items oracle log (OCEL 2.0 canonical pattern): one place_order
event relating to two item objects, with a sibling O2O relation. -/
def ocelOracle : OCEL String String String String String String :=
  { evtype := fun _ => "place_order", time := fun _ => 0,
    objtype := fun _ => "item",
    e2o := [("e1", "creates", "o1"), ("e1", "creates", "o2")],
    o2o := [("o1", "sibling", "o2")],
    eaval := fun _ _ => none, oaval := fun _ _ _ => none }

-- E2O projection: the order event touches exactly its two items, in order.
#guard ocelOracle.objectsOf "e1" == ["o1", "o2"]
-- Dual projection: item o1 participates in exactly the order event.
#guard ocelOracle.eventsOf "o1" == ["e1"]
-- Absent-object case: an unknown event projects to nothing (no phantom relations).
#guard ocelOracle.objectsOf "e_missing" == ([] : List String)


end ProcInt
