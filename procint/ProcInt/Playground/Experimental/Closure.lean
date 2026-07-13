-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Experiment

/-!
# Bounded Executable Closure

Pipeline:
`seed → consequence step → normalization → fixed-point check → witness/refusal`.

Crown law:
the runtime rail gains closure standing only after executable stabilization is
observed; fuel exhaustion is a typed refusal.

Preserves:
seed consequences; duplicate-insensitive membership.

Excludes:
claiming least-fixed-point theorems from the bounded runner.

Standing:
runtime closure instrument.

Correspondence debt:
no theorem states that an arbitrary `step` produces the mathematical least fixed point.

Falsifier:
fuel exhaustion returns a state as though it were closed.

Downstream:
residue diagnostics and autonomous-resolution experiments.
-/

namespace ProcInt.Playground.Experimental

/-- Boolean membership over a finite list. -/
def memB {α : Type} [DecidableEq α] (x : α) (xs : List α) : Bool :=
  decide (x ∈ xs)

/-- Boolean finite-set inclusion, interpreting lists extensionally. -/
def subsetB {α : Type} [DecidableEq α] (xs ys : List α) : Bool :=
  xs.all (fun x => memB x ys)

/-- Boolean finite-set equality, ignoring order and duplicates. -/
def setEqB {α : Type} [DecidableEq α] (xs ys : List α) : Bool :=
  subsetB xs ys && subsetB ys xs

/-- Duplicate-free canonicalization preserving first occurrence order. -/
def normalize {α : Type} [DecidableEq α] (xs : List α) : List α :=
  xs.eraseDups

/-- Typed refusal for bounded closure execution. -/
inductive ClosureRefusal where
  | fuelExhausted (fuel : Nat) (lastCardinality : Nat)
  deriving Repr, DecidableEq, BEq

/--
Executable stabilization witness.

Law: `stabilized` proves the boolean extensional fixed-point check returned true.
Carrier: bounded runtime closure.
Admission: constructed only in the successful branch of `closeWithFuel`.
Preserves: stabilized state and round count.
Refuses: least-fixed-point authority.
Receipt: state plus rounds plus proof field.
Claim ceiling: runtime fixed-point observation.
-/
structure FixedPointWitness {α : Type} [DecidableEq α]
    (step : List α → List α) where
  state : List α
  rounds : Nat
  stabilized :
    setEqB (normalize (state ++ step state)) state = true

private def closeWithFuelAux {α : Type} [DecidableEq α]
    (step : List α → List α) (originalFuel : Nat) :
    Nat → Nat → List α →
      Except ClosureRefusal (FixedPointWitness step)
  | 0, _, current =>
      .error (.fuelExhausted originalFuel current.length)
  | fuel + 1, rounds, current =>
      let next := normalize (current ++ step current)
      if h : setEqB next current = true then
        .ok {
          state := current
          rounds := rounds
          stabilized := by
            simpa [next] using h
        }
      else
        closeWithFuelAux step originalFuel fuel (rounds + 1) next

/--
Runs consequence expansion until extensional stabilization or fuel exhaustion.

Law: success carries a `FixedPointWitness`.
Carrier: bounded closure actuator.
Admission: explicit fuel.
Preserves: consequence accumulation by `current ++ step current`.
Refuses: `fuelExhausted`.
Actuation: pure recursion on fuel.
Receipt: success witness or typed refusal.
Replay: deterministic for fixed `step`, fuel, and seed.
Complexity: at most `fuel` expansion rounds.
Claim ceiling: executable stabilization only.
-/
def closeWithFuel {α : Type} [DecidableEq α]
    (step : List α → List α) (fuel : Nat) (seed : List α) :
    Except ClosureRefusal (FixedPointWitness step) :=
  closeWithFuelAux step fuel fuel 0 (normalize seed)


/-- Boolean projection of bounded closure success for executable tests. -/
def closureSucceeded {α : Type} [DecidableEq α]
    {step : List α → List α}
    (result : Except ClosureRefusal (FixedPointWitness step)) : Bool :=
  match result with
  | .ok _ => true
  | .error _ => false

end ProcInt.Playground.Experimental
