-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11.Replay

/-!
# Abstract Actor to AtomVM Transition Correspondence

Pipeline:
`abstract step + runtime step + state encoding + one-step commuting square → replay correspondence`.

Crown law:
a one-step admitted correspondence lifts by induction to every finite trace.

Preserves:
event identity and encoded state consequence.

Excludes:
claiming that AtomVM realizes the abstract step without constructing the witness.

Falsifier:
`preservesStep` holds but a finite trace breaks replay correspondence.
-/

namespace ProcInt.Playground.Swarm11

namespace Correspondence

/--
Admitted one-step correspondence between an abstract transition system and a runtime transition system.

`RuntimeState` may be an AtomVM model, but this structure does not grant AtomVM authority by name.
-/
structure StepCorrespondence
    (Event AbstractState RuntimeState : Type) where
  encodeState : AbstractState → RuntimeState
  abstractStep : Event → AbstractState → AbstractState
  runtimeStep : Event → RuntimeState → RuntimeState
  preservesStep :
    ∀ event state,
      encodeState (abstractStep event state) =
        runtimeStep event (encodeState state)

/--
One-step correspondence lifts to all finite replay traces.

Law:
`encode(replay abstract trace s) = replay runtime trace (encode s)`.
Carrier: deterministic finite traces.
Admission: inhabited `StepCorrespondence`.
Preserves: complete finite replay consequence.
Refuses: ambient runtime correspondence.
Claim ceiling: theorem conditional on the explicit bridge.
-/
theorem replay_preserved
    {Event AbstractState RuntimeState : Type}
    (correspondence :
      StepCorrespondence Event AbstractState RuntimeState)
    (trace : List Event)
    (initial : AbstractState) :
    correspondence.encodeState
        (Replay.replay correspondence.abstractStep trace initial) =
      Replay.replay correspondence.runtimeStep trace
        (correspondence.encodeState initial) := by
  induction trace generalizing initial with
  | nil => rfl
  | cons event rest inductionHypothesis =>
      simp only [Replay.replay]
      rw [inductionHypothesis, correspondence.preservesStep]

end Correspondence

end ProcInt.Playground.Swarm11
