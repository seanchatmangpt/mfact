-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11

namespace ProcInt.Playground.Swarm11Tests

open ProcInt.Playground.Swarm11

example : Standing.finiteVerified.canClaimTheorem = false := by
  rfl

example : Standing.proven.canClaimTheorem = true := by
  rfl

-- Crown.additionIdentityExperiment checks 1024 finite worlds; kernel `decide`
-- needs more than the default recursion budget to reduce that traversal
-- (same fix as ProcInt.Playground.ExperimentalWalkthrough's identical case).
set_option maxRecDepth 8192 in
example :
    (Crown.additionIdentityExperiment.run.standing =
      Standing.finiteVerified) := by
  decide

example :
    Crown.parityExperiment.run.standing = Standing.refuted := by
  decide

end ProcInt.Playground.Swarm11Tests
