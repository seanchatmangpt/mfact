-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-! A tiny concrete OCEL 2.0 log — one Order object and one Item object linked
by a `contains` O2O edge, with three events (place, ship, return) — used below
to exercise `ProcInt.Ocel.Lifecycle` and `ProcInt.Ocel.Relations` on real data
rather than abstract variables. -/

-- Events 1 = place, 2 = ship, 3 = return; objects 100 = the Order, 200 = the Item.
def demoLog : OCEL ℕ ℕ String String String String where
  evtype := fun e => if e = 1 then "place" else if e = 2 then "ship" else "return"
  time := fun e => e
  objtype := fun o => if o = 100 then "Order" else "Item"
  e2o := [(1, "places", 100), (2, "ships", 100), (2, "contains", 200), (3, "returns", 200)]
  o2o := [(100, "contains", 200)]
  eaval := fun _ _ => none
  oaval := fun _ _ _ => none

-- `ProcInt.OCEL.eventsOf`: the Order (100) shows up in the place and ship events.
#eval demoLog.eventsOf 100

-- `ProcInt.OCEL.objectsOf`: the ship event (2) touches both the Order and the Item.
#eval demoLog.objectsOf 2

-- `ProcInt.OCEL.e2oProj`: the qualified (qualifier, object) pairs attached to
-- the ship event.
#eval demoLog.e2oProj 2

-- `ProcInt.OCEL.o2oProj`: the qualified (qualifier, target) pairs whose source
-- is the Order.
#eval demoLog.o2oProj 100

/-- `ProcInt.OCEL.eventsOf 100` (place, ship) is already time-ordered by event
id, witnessing `ProcInt.OCEL.TimeOrdered`. -/
example : demoLog.TimeOrdered (demoLog.eventsOf 100) := by
  unfold OCEL.TimeOrdered
  decide

/-- `demoLog.eventsOf 100` is trivially a lifecycle of the Order object: it is
its own permutation and is time-ordered, witnessing `ProcInt.OCEL.IsLifecycle`. -/
example : demoLog.IsLifecycle 100 (demoLog.eventsOf 100) :=
  ⟨List.Perm.refl _, by unfold OCEL.TimeOrdered; decide⟩

/-- The Order and the Item interact because they are both linked to the ship
event (2), witnessing `ProcInt.OCEL.Interacts`. -/
example : demoLog.Interacts 100 200 :=
  ⟨2, by decide, by decide⟩

/-- Interaction is symmetric (`ProcInt.OCEL.interacts_symm`): from Order-Item
interacting we get Item-Order interacting. -/
example : demoLog.Interacts 200 100 :=
  OCEL.interacts_symm demoLog (⟨2, by decide, by decide⟩ : demoLog.Interacts 100 200)

/-- The raw qualified triple `(2, "ships", 100)` in the E2O table puts 100 into
`objectsOf 2`, witnessing soundness of the projection
(`ProcInt.OCEL.mem_objectsOf`). -/
example : (100 : ℕ) ∈ demoLog.objectsOf 2 :=
  OCEL.mem_objectsOf demoLog (e := 2) (q := "ships") (o := 100) (by decide)

/-- A concrete `ProcInt.LifecycleStep`: the Order's phase activates from
created to active. -/
example : LifecycleStep .created .active :=
  .activate

/-- A concrete `ProcInt.LifecycleStep`: the Order's phase archives from active
to archived. -/
example : LifecycleStep .active .archived :=
  .archive

/-- The archived phase is terminal (`ProcInt.archived_terminal`): it never
steps back to created. -/
example : ¬ LifecycleStep .archived .created :=
  archived_terminal .created

/-- Lifecycle steps are irreflexive (`ProcInt.lifecycleStep_irrefl`): the
active phase never steps to itself. -/
example : ¬ LifecycleStep .active .active :=
  lifecycleStep_irrefl .active

end ProcInt.Playground
