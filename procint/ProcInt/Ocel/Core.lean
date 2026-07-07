-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Ocel.Core

Object-centric event logs, OCEL 2.0 (Berti, Koren, et al., arXiv 2403.01975, Def. 1-2): the OCEL structure with typed events and objects, discrete time, qualified E2O/O2O relations, time-stable event attributes and time-indexed object attributes, plus the derived object/event projections. Port of wasm4pm-compat src/ocel.rs (struct OCEL, OCEDO formal layer). -/

namespace ProcInt

/-- Object-centric event log, OCEL 2.0 (arXiv 2403.01975, Def. 1-2). An OCEL over
event set E, object set O, event types ET, object types OT, qualifiers Q and
attribute values V carries: an event-type map, a discrete timestamp map, an
object-type map, qualified event-to-object and object-to-object relations, and
attribute valuations — event attributes are time-stable, object attributes are
time-indexed (oaval takes a timestamp). Port of wasm4pm-compat src/ocel.rs
struct OCEL (OCEDO formal layer L = (E, O, eval, oaval)). -/
structure OCEL (E O ET OT Q V : Type) where
  evtype : E → ET
  time : E → ℕ
  objtype : O → OT
  e2o : List (E × Q × O)
  o2o : List (O × Q × O)
  eaval : E → String → Option V
  oaval : O → String → ℕ → Option V

/-- Objects related to event e via the qualified E2O relation (OCEL 2.0 Def. 2;
wasm4pm-compat src/ocel.rs fn e2o, projected to the object component). -/
def OCEL.objectsOf {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) (e : E) : List O :=
  (L.e2o.filter (fun t => decide (t.1 = e))).map (fun t => t.2.2)

/-- Events related to object o via the qualified E2O relation (OCEL 2.0 Def. 2;
the object-side projection dual to objectsOf). -/
def OCEL.eventsOf {E O ET OT Q V : Type} [DecidableEq O]
    (L : OCEL E O ET OT Q V) (o : O) : List E :=
  (L.e2o.filter (fun t => decide (t.2.2 = o))).map (fun t => t.1)

/-- The E2O projection of an event never exceeds the size of the raw qualified
relation table (filter-then-map length bound). -/
theorem OCEL.objectsOf_length_le {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) (e : E) :
    (L.objectsOf e).length ≤ L.e2o.length := by
  simpa [OCEL.objectsOf] using List.length_filter_le _ L.e2o

/-- The dual bound for the object-side projection: eventsOf is a sublist-sized
selection of the qualified E2O relation table. -/
theorem OCEL.eventsOf_length_le {E O ET OT Q V : Type} [DecidableEq O]
    (L : OCEL E O ET OT Q V) (o : O) :
    (L.eventsOf o).length ≤ L.e2o.length := by
  simpa [OCEL.eventsOf] using List.length_filter_le _ L.e2o


end ProcInt
