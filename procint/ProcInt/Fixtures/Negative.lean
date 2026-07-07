-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Logs.Event
import ProcInt.Logs.Trace
import ProcInt.Conformance.TokenReplay

/-! # ProcInt.Fixtures.Negative

Negative fixtures: malformed instances that must be REJECTED, the Lean analogue of wasm4pm-compat trybuild tests/ui/compile_fail. Each is a #guard_msgs (error) block whose docstring is the exact error Lean produces — the fixture fails closed if the rejection ever stops happening (message drift) or starts happening for a different reason. -/

namespace ProcInt

-- A `ReplayCounts` with `missing = 5 > consumed = 4` cannot be
-- constructed — the `missing_le` field demands a proof of `5 ≤ 4`, which
-- `decide` correctly refutes. Negative fixture: refusal is the pass condition.
/-- error: Tactic `decide` proved that the proposition
  5 ≤ 4
is false -/
#guard_msgs in
example : ReplayCounts := ⟨4, 4, 5, 0, by decide, by decide⟩

-- A trace with events at timestamps 5 then 0 is not monotone —
-- attempting to `decide` it fails to close the goal. Negative fixture:
-- refusal is the pass condition.
/-- error: Tactic `decide` proved that the proposition
  List.IsChain (fun a b => a.timestamp ≤ b.timestamp)
    { caseId := "case-2", events := [Event.simple "a" 5, Event.simple "b" 0] }.events
is false -/
#guard_msgs in
example :
    Trace.Monotone
      (⟨"case-2", [Event.simple "a" 5, Event.simple "b" 0]⟩ : Trace String) := by
  unfold Trace.Monotone
  decide


end ProcInt
