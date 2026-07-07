import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

/-- Firing the fresh short-circuit transition `t*` at the final marking `[o]`
returns exactly the initial marking `[i]`: `t*` consumes `[o]` (its `pre` is
`W.finalMarking`) and produces `[i]` (its `post` is `W.initialMarking`), so
this is `fire_pre_self` transported along `shortCircuit_pre_inr` /
`shortCircuit_post_inr`. -/
theorem WfNet.shortCircuit_fire_star {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.fire W.finalMarking (Sum.inr ()) = W.initialMarking := by
  have h := W.shortCircuit.fire_pre_self (Sum.inr () : T ⊕ Unit)
  rwa [W.shortCircuit_pre_inr, W.shortCircuit_post_inr] at h

/-- The fresh short-circuit transition `t*` steps the final marking `[o]` to
the initial marking `[i]`: it is enabled at `[o]` (its `pre` weight is exactly
`[o]`) and firing it produces `[i]` by `shortCircuit_fire_star`. -/
theorem WfNet.shortCircuit_step_star {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
  ⟨W.shortCircuit_enabled_star, (W.shortCircuit_fire_star).symm⟩

end ProcInt
