-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Coordinates

/-!
# Finite Theorem Mining

Pipeline:
`finite worlds → executable law → first counterexample or finite verification`.

Crown law:
exhaustive agreement on the supplied finite world list yields `FINITE_VERIFIED`,
never `PROVEN`.

Preserves:
world order; first failing witness; law identity.

Excludes:
sampling presented as proof; erased counterexamples; silent domain widening.

Standing:
executable experimental-mathematics rail.

Falsifier:
`run` emits `PROVEN` without a theorem admission boundary.

Downstream:
counterexample harvesting, conjecture triage, `Crown`.
-/

namespace ProcInt.Playground.Experimental

/--
Finite executable conjecture.

Law: every listed world is checked by `law`.
Carrier: finite experiment.
Admission: `worlds` is the exact searched domain.
Preserves: first-counterexample order.
Refuses: ambient extension beyond `worlds`.
Claim ceiling: finite domain.
-/
structure FiniteExperiment (α : Type) where
  name : String
  worlds : List α
  law : α → Bool
  render : α → String

/-- Concrete counterexample harvested from a finite experiment. -/
structure Counterexample where
  experiment : String
  world : String
  ordinal : Nat
  deriving Repr, DecidableEq, BEq

/--
Report from a completed finite search.

Law: `REFUTED` carries the first failing world; `FINITE_VERIFIED` carries none.
Carrier: finite experiment receipt.
Admission: produced by `FiniteExperiment.run`.
Preserves: checked-case count and witness order.
Refuses: theorem standing.
Receipt: report fields bind experiment name, domain size, standing, and witness.
Claim ceiling: finite domain.
-/
structure ExperimentReport where
  name : String
  checkedCases : Nat
  standing : Standing
  counterexample : Option Counterexample
  deriving Repr, DecidableEq, BEq

private def findFirstFailureAux {α : Type}
    (e : FiniteExperiment α) : List α → Nat → Option Counterexample
  | [], _ => none
  | x :: xs, i =>
      if e.law x then
        findFirstFailureAux e xs (i + 1)
      else
        some {
          experiment := e.name
          world := e.render x
          ordinal := i
        }

/-- First failing world in source order, if one exists. -/
def FiniteExperiment.firstCounterexample {α : Type}
    (e : FiniteExperiment α) : Option Counterexample :=
  findFirstFailureAux e e.worlds 0

/--
Executes exhaustive finite verification over the declared world list.

Law: no failure → `FINITE_VERIFIED`; first failure → `REFUTED`.
Carrier: finite law miner.
Admission: experiment's world list is explicit.
Preserves: exact case count.
Refuses: promotion to `PROVEN`.
Actuation: deterministic list traversal.
Receipt: `ExperimentReport`.
Replay: rerunning the pure function yields the same report.
Claim ceiling: finite domain.
-/
def FiniteExperiment.run {α : Type}
    (e : FiniteExperiment α) : ExperimentReport :=
  match e.firstCounterexample with
  | none => {
      name := e.name
      checkedCases := e.worlds.length
      standing := .FINITE_VERIFIED
      counterexample := none
    }
  | some witness => {
      name := e.name
      checkedCases := e.worlds.length
      standing := .REFUTED
      counterexample := some witness
    }


/--
Least-cost failing witness under an explicit experimental cost function.

Law: among searched failing worlds, a cheaper witness replaces the current witness.
Carrier: finite counterexample shrinker.
Admission: the same explicit finite world list as the source experiment.
Preserves: failure of `law`.
Refuses: global minimality outside `worlds`; proof-minimization claims.
Actuation: deterministic left fold over failing worlds.
Receipt: returned `Counterexample` binds source ordinal and rendered world.
Complexity: linear in searched worlds, excluding `law`, `cost`, and `render`.
Claim ceiling: finite-domain counterexample minimization.
-/
def FiniteExperiment.minimalCounterexampleBy {α : Type}
    (e : FiniteExperiment α) (cost : α → Nat) : Option Counterexample :=
  let indexed := e.worlds.zipIdx.map (fun p => (p.2, p.1))
  let failures := indexed.filter (fun item => !(e.law item.2))
  match failures with
  | [] => none
  | first :: rest =>
      let best := rest.foldl
        (fun current candidate =>
          if cost candidate.2 < cost current.2 then candidate else current)
        first
      some {
        experiment := e.name
        world := e.render best.2
        ordinal := best.1
      }

@[simp] theorem run_ne_proven {α : Type} (e : FiniteExperiment α) :
    (e.run.standing == Standing.PROVEN) = false := by
  unfold FiniteExperiment.run
  cases e.firstCounterexample <;> simp <;> rfl

end ProcInt.Playground.Experimental
