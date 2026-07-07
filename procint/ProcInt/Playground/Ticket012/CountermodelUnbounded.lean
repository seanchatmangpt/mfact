import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Playground.Ticket012.CountermodelTypes
import ProcInt.Playground.Ticket012.CountermodelReachability

namespace ProcInt.Playground.Ticket012

/-! # Ticket012: CountermodelUnbounded

Unboundedness proof for the countermodel net's short-circuit.

This demonstrates that without the [Finite T] hypothesis, the crown-jewel
theorem (soundness iff liveness and boundedness of short-circuit) can fail.
The countermodel net is unbounded under short-circuit even though it has a
bounded finite counterpart.
-/

/-- For any bound k, we can reach a marking where q has at least k+1 tokens,
violating the boundedness requirement. -/
theorem crownCounter_not_bounded :
    ¬ ∃ k, crownCounterWfNet.shortCircuit.Bounded crownCounterWfNet.initialMarking k := by
  intro ⟨k, hb⟩
  -- Assume boundedness with bound k
  -- Consider the reachable marking with k+1 tokens at q and marker at c(k+1)
  have hreach : crownCounterWfNet.shortCircuit.Reaches
      crownCounterWfNet.initialMarking (intermediateMarking (k + 1)) :=
    WfNet.reaches_shortCircuit crownCounterWfNet (crownCounter_reaches_mid (k + 1))
  -- Apply the boundedness assumption
  have hbound := hb (intermediateMarking (k + 1)) hreach CrownCounterPlace.q
  -- At place q, the intermediate marking has k+1 tokens
  have hq := intermediateMarking_q (k + 1)
  rw [hq] at hbound
  -- But boundedness says all places have ≤ k tokens
  omega

/-- The countermodel workflow net's short-circuit is unbounded from its initial marking. -/
theorem crownCounterWfNet_unbounded :
    ¬ ∃ k, crownCounterWfNet.shortCircuit.Bounded crownCounterWfNet.initialMarking k :=
  crownCounter_not_bounded

end ProcInt.Playground.Ticket012
