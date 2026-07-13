-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11.Crown

/-!
# Ledger Bridge: A Non-Toy StepCorrespondence Inhabitant, and a Kernel-Checked Negative

Pipeline:
`Crown's (Nat × Nat) counter pair → a genuinely differently-shaped runtime ledger
(total, signed diff) → an explicit invertible encoding → a checked commuting square`.

This file supplies two artifacts against `StepCorrespondence`
(`ProcInt.Playground.Swarm11.Correspondence.AtomVM`):

1. `crownLedgerCorrespondence` — a real inhabitant whose `encodeState` is a
   non-identity change of coordinates between two structurally different
   types (`Nat × Nat` vs. a two-field record carrying a `Nat` and an `Int`),
   unlike the toy inhabitant in `Swarm11Tests/Correspondence.lean`
   (`Int.ofNat` between `Nat` and `Int`, with `abstractStep = runtimeStep`
   literally the same function). This is a "non-identity model-to-model
   bridge": both sides are checked Lean objects and the one-step square is
   admitted, but neither side is an external runtime. It does not license
   calling this a "real substrate correspondence" to any concrete external
   runtime (praxis's F16/F18, or a native runtime model) — that remains
   open, tracked in `ROADMAP_CLOUD_MATH.md` under CL1.
2. `no_log_correspondence` — a kernel-checked disproof that an append-log
   runtime (`logStep`, which records the full event list in order) can be
   bridged to `Crown.step` for *any* `encodeState`, because `Crown.step`
   commutes on `incrementLeft`/`incrementRight` (`Crown.sampleEvents_commute`)
   while list-append never commutes on two distinct events. This is the
   concrete failure mode `StepCorrespondence` must rule out: an abstract step
   that forgets order cannot be bridged to a runtime step that remembers it.

Crown law:
a one-step admitted correspondence lifts by induction to every finite trace
(`Correspondence.replay_preserved`); this file only supplies/refutes
one-step witnesses, it does not re-derive that lift.

Preserves:
event identity and encoded state consequence, for the admitted inhabitant only.

Excludes:
any claim that `crownLedgerCorrespondence` witnesses a real external runtime;
any claim that `StepCorrespondence` is inhabited for arbitrary
`(AbstractState, RuntimeState)` pairs — `no_log_correspondence` is the
counterexample showing it is not, in general.

Falsifier:
`crownLedgerCorrespondence.preservesStep` fails to typecheck, or
`no_log_correspondence`'s premises turn out to be jointly satisfiable.
-/

namespace ProcInt.Playground.Swarm11

namespace Correspondence

namespace LedgerBridge

open ProcInt.Playground.Swarm11.Correspondence

/-- A runtime state genuinely differently shaped from Crown's `Nat × Nat`:
total event count plus signed left-minus-right difference. -/
structure Ledger where
  total : Nat
  diff : Int
  deriving Repr, DecidableEq

/-- Explicit, invertible change of coordinates from Crown's counter pair to a
`Ledger`. Not the identity, not a relabeling: `total` sums the pair, `diff`
takes the signed difference. Invertible because
`(total, diff) ↦ ((total + diff) / 2, (total - diff) / 2)` recovers
`(left, right)` exactly (not proved here — `StepCorrespondence` only
requires the forward square, not that `encodeState` be a bijection). -/
def encodeLedger (s : Nat × Nat) : Ledger :=
  ⟨s.1 + s.2, (s.1 : Int) - (s.2 : Int)⟩

/-- Ledger-shaped runtime transition matching `Crown.step`'s effect under
`encodeLedger`: every event increases the total by one; `incrementLeft`
increases the signed diff, `incrementRight` decreases it. -/
def ledgerStep : Crown.Event → Ledger → Ledger
  | .incrementLeft, ledger => ⟨ledger.total + 1, ledger.diff + 1⟩
  | .incrementRight, ledger => ⟨ledger.total + 1, ledger.diff - 1⟩

/-- The one-step commuting square: encoding a `Crown.step` transition equals
running `ledgerStep` on the already-encoded state. Genuine `Nat`/`Int` cast
arithmetic per branch, closed by `omega` after unfolding the definitions and
splitting the record equality — not `rfl`. -/
theorem encodeLedger_preservesStep :
    ∀ (event : Crown.Event) (state : Nat × Nat),
      encodeLedger (Crown.step event state) = ledgerStep event (encodeLedger state) := by
  intro event state
  obtain ⟨left, right⟩ := state
  cases event <;>
    simp [Crown.step, ledgerStep, encodeLedger, Ledger.mk.injEq] <;>
    omega

/-- The real, non-identity model-to-model bridge: Crown's `(Nat × Nat)`
counter pair correctly steps into a genuinely differently-shaped `Ledger`
record. See the file header for the honest scope of this claim: a bridge
between two checked Lean models, not a substrate correspondence to any
external runtime. -/
def crownLedgerCorrespondence :
    StepCorrespondence Crown.Event (Nat × Nat) Ledger where
  encodeState := encodeLedger
  abstractStep := Crown.step
  runtimeStep := ledgerStep
  preservesStep := encodeLedger_preservesStep

/-!
## Negative example: order-forgetting abstractions cannot bridge to
order-remembering runtimes

`logStep` below records every event, in order, in a growing list — a
faithful model of "the runtime never discards information". The theorem
`no_log_correspondence` shows this is exactly the wrong direction for
`StepCorrespondence`: no `encodeState : Nat × Nat → List Crown.Event` can
make `logStep` a valid `runtimeStep` for `Crown.step`, because `Crown.step`
commutes on `incrementLeft`/`incrementRight` (`Crown.sampleEvents_commute`)
but `logStep` never commutes on two distinct events. Concretely witnessed at
the abstract state `(1, 0)` (`left > 0`).
-/

/-- Append-log runtime: every event is recorded, in order, at the end of the
list. Genuinely order-preserving, unlike `Crown.step`'s `Nat × Nat` counter,
which forgets the order in which commuting events arrived. -/
def logStep : Crown.Event → List Crown.Event → List Crown.Event :=
  fun event state => state ++ [event]

/-- No `encodeState` function can make `logStep` a valid `runtimeStep` for
`Crown.step`: the abstract side loses the order in which
`incrementLeft`/`incrementRight` were applied (they commute, per
`Crown.sampleEvents_commute`), but the log-append side can never lose it
(`List.append_cancel_left` witnesses that appending two distinct events in
different orders yields different lists). Concretely derived at the abstract
state `(1, 0)`, assuming a hypothetical `preserves` square and deriving
`False` from the two differently-ordered but abstractly-equal encoded
traces. -/
theorem no_log_correspondence
    (encodeState : Nat × Nat → List Crown.Event)
    (preserves :
      ∀ (event : Crown.Event) (state : Nat × Nat),
        encodeState (Crown.step event state) = logStep event (encodeState state)) :
    False := by
  have hLeftFirst :
      encodeState (Crown.step .incrementRight (Crown.step .incrementLeft (1, 0))) =
        encodeState (1, 0) ++ [.incrementLeft, .incrementRight] := by
    have step1 := preserves .incrementLeft (1, 0)
    have step2 := preserves .incrementRight (Crown.step .incrementLeft (1, 0))
    rw [step1] at step2
    simpa [logStep, List.append_assoc] using step2
  have hRightFirst :
      encodeState (Crown.step .incrementLeft (Crown.step .incrementRight (1, 0))) =
        encodeState (1, 0) ++ [.incrementRight, .incrementLeft] := by
    have step1 := preserves .incrementRight (1, 0)
    have step2 := preserves .incrementLeft (Crown.step .incrementRight (1, 0))
    rw [step1] at step2
    simpa [logStep, List.append_assoc] using step2
  have hCommute :
      Crown.step .incrementRight (Crown.step .incrementLeft (1, 0)) =
        Crown.step .incrementLeft (Crown.step .incrementRight (1, 0)) :=
    Crown.sampleEvents_commute (1, 0)
  rw [hCommute, hRightFirst] at hLeftFirst
  have hCancel := List.append_cancel_left hLeftFirst
  simp at hCancel

/-- Corollary in the bundled `StepCorrespondence` form: no inhabitant of
`StepCorrespondence Crown.Event (Nat × Nat) (List Crown.Event)` can have
`abstractStep := Crown.step` and `runtimeStep := logStep` simultaneously,
for any choice of `encodeState`. -/
theorem no_ledgerLog_correspondence :
    ¬ ∃ correspondence :
        StepCorrespondence Crown.Event (Nat × Nat) (List Crown.Event),
      correspondence.abstractStep = Crown.step ∧
        correspondence.runtimeStep = logStep := by
  rintro ⟨correspondence, hAbstract, hRuntime⟩
  refine no_log_correspondence correspondence.encodeState ?_
  intro event state
  have h := correspondence.preservesStep event state
  rw [hAbstract, hRuntime] at h
  exact h

end LedgerBridge

end Correspondence

end ProcInt.Playground.Swarm11
