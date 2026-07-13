-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11.Standing

/-!
# Finite Experimental Mathematics

Pipeline:
`finite worlds → executable law → first counterexample or finite verification`.

Crown law:
the finite runner has no code path to `Standing.proven`.

Preserves:
world order and first failing witness.

Excludes:
finite agreement as theorem proof.

Falsifier:
`FiniteExperiment.run` returns `proven`.
-/

namespace ProcInt.Playground.Swarm11

/-- Executable conjecture over an explicit finite world list. -/
structure FiniteExperiment (World : Type) where
  name : String
  worlds : List World
  law : World → Bool
  render : World → String

/-- First failing finite world. -/
structure Counterexample where
  experiment : String
  world : String
  ordinal : Nat
  deriving Repr, DecidableEq, BEq

/-- Receipt from an exhaustive finite-world experiment. -/
structure ExperimentReport where
  name : String
  checkedCases : Nat
  standing : Standing
  counterexample : Option Counterexample
  deriving Repr, DecidableEq, BEq

namespace FiniteExperiment

private def firstFailureAux {World : Type}
    (experiment : FiniteExperiment World) :
    List World → Nat → Option Counterexample
  | [], _ => none
  | world :: rest, ordinal =>
      if experiment.law world then
        firstFailureAux experiment rest (ordinal + 1)
      else
        some {
          experiment := experiment.name
          world := experiment.render world
          ordinal := ordinal
        }

/-- First failing world in declared source order. -/
def firstFailure {World : Type}
    (experiment : FiniteExperiment World) : Option Counterexample :=
  firstFailureAux experiment experiment.worlds 0

/--
Runs the declared finite experiment exhaustively.

Law: no failure gives `finiteVerified`; a failure gives `refuted`.
Carrier: finite experiment.
Admission: the exact finite world list is explicit.
Preserves: first-failure order.
Refuses: `proven`.
Claim ceiling: finite domain.
-/
def run {World : Type}
    (experiment : FiniteExperiment World) : ExperimentReport :=
  match experiment.firstFailure with
  | none => {
      name := experiment.name
      checkedCases := experiment.worlds.length
      standing := .finiteVerified
      counterexample := none
    }
  | some counterexample => {
      name := experiment.name
      checkedCases := experiment.worlds.length
      standing := .refuted
      counterexample := some counterexample
    }

/-- The finite experiment runner cannot manufacture theorem standing. -/
theorem run_standing_ne_proven {World : Type}
    (experiment : FiniteExperiment World) :
    experiment.run.standing ≠ Standing.proven := by
  unfold run
  cases experiment.firstFailure <;> simp

end FiniteExperiment

end ProcInt.Playground.Swarm11
