-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.

/-!
# ProcInt.Playground.Trajectory.RecoveryBehavior

Recovery-behavior taxonomy from Table III of Zhao et al., "Failure as a
Process: An Anatomy of CLI Coding Agent Trajectories" (arXiv:2607.09510) --
an empirical study of coding-agent failure trajectories, no theorems or
formal content of its own. This file constructs the taxonomy's 5 recovery
behaviors as a real Lean inductive type, not a description of one.

Per `AGENTS.md` section 4 (No Ambient Theorem Authority): exhibiting this
type does not by itself establish that mfact's own cron-fired loops
(`0e35feb8` fix loop, `9bab36de` audit loop) exhibit any of these behaviors
-- that requires actually classifying this session's own trajectories
against it, which is separate, unstarted work. This file is the vocabulary,
not the measurement.
-/

namespace ProcInt.Playground.Trajectory

/-- The 5 recovery behaviors of Table III: what an agent does after a
failure has occurred, in the paper's own order. -/
inductive RecoveryBehavior where
  /-- Stops attempting the task entirely rather than continuing to recover. -/
  | givesUpImmediately
  /-- Diagnoses and "fixes" something other than the actual decisive error. -/
  | repairsWrongProblem
  /-- Retries the same failed approach without adapting it. -/
  | keepsRepeatingApproach
  /-- Runs checks whose outcome could not have changed the result either way. -/
  | performsUselessChecks
  /-- Reports success while fabricating or misrepresenting the supporting evidence. -/
  | fabricatesSuccess
  deriving Repr, DecidableEq, BEq

end ProcInt.Playground.Trajectory
