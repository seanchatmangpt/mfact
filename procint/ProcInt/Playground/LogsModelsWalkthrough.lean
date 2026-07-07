-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

/-! # Playground: one order-fulfillment case, three ways

A single trace — order placed, payment received, order shipped — read as
an `EventLog` (`ProcInt.Logs`), a `BpmnProcess` (`ProcInt.Models.Bpmn`), and
a discovered `Dfg` (`ProcInt.Models.Dfg`, the `alg_dfg` registry entry).
Same data, three of the library's process-representation formalisms. -/

namespace ProcInt.Playground

/-- The three activities of one order-fulfillment case. -/
inductive Activity where
  | orderPlaced
  | paymentReceived
  | orderShipped
  deriving DecidableEq, Repr

open Activity

/-- The case as a trace of bare (unresourced) events, in order. -/
def orderTrace : Trace Activity where
  caseId := "order-1"
  events := [Event.simple orderPlaced 0, Event.simple paymentReceived 1,
             Event.simple orderShipped 2]

/-- The case as a one-trace event log. -/
def orderLog : EventLog Activity := [orderTrace]

#eval orderLog.eventCount

/-- The trace is well-formed: its timestamps are non-decreasing. -/
example : orderLog.wellFormed := by
  intro t ht
  simp only [orderLog, List.mem_singleton] at ht
  subst ht
  simp only [Trace.Monotone, orderTrace, List.isChain_cons_cons, List.IsChain.singleton,
    Event.simple]
  exact ⟨by omega, by omega, trivial⟩

/-- The same three activities as a minimal BPMN process: start → place
order → receive payment → ship order → end. -/
def orderProcess : BpmnProcess where
  nodes :=
    [ ⟨"start", .startEvent⟩, ⟨"place", .task "place order"⟩,
      ⟨"pay", .task "receive payment"⟩, ⟨"ship", .task "ship order"⟩,
      ⟨"end", .endEvent⟩ ]
  edges :=
    [ ⟨"start", "place"⟩, ⟨"place", "pay"⟩, ⟨"pay", "ship"⟩, ⟨"ship", "end"⟩ ]

#eval orderProcess.nodes.length

/-- The order process has exactly one start and one end event, and every
edge lands on a declared node — the ledgered `BpmnProcess.WellFormed`. -/
example : orderProcess.WellFormed := by
  refine ⟨by decide, by decide, ?_⟩
  intro e he
  fin_cases he <;> exact ⟨by decide, by decide⟩

/-- The directly-follows graph discovered from the trace's activity
sequence (`dfgOfTrace`, the algorithm catalogued as `alg_dfg`). -/
def orderDfg : Dfg Activity := dfgOfTrace orderTrace.activities

#eval orderDfg.edges.length
#eval orderDfg.weight orderPlaced paymentReceived

/-- A trace of 3 events yields exactly 2 directly-follows edges — the
ledgered `dfgOfTrace_edges_length` law, instantiated on this case. -/
example : orderDfg.edges.length = 2 :=
  dfgOfTrace_edges_length orderTrace.activities

-- The registry entry for the algorithm this file's `Dfg` discovery exercises.
#eval alg_dfg.label

end ProcInt.Playground
