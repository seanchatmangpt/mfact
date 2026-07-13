-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.MFW.Order
import ProcInt.Playground.MFW.Runtime
import ProcInt.Playground.Swarm11.Replay

/-!
# Runtime Replay Bridge (C x B)

Pipeline:
`ExecutionState completion step → structural concurrency (Order.Concurrent) →
Commute witness → Swarm11.Replay's TraceEq/replay machinery`.

This file is the cross-layer glue between two independently-proven layers that had no admitted
correspondence between them before this wave: the BRCE runtime layer
(`ProcInt.Playground.MFW.Runtime`, `ExecutionState`/`zero_unreceipted_completion`) and the
causal-replay layer (`ProcInt.Playground.Swarm11.Replay`, `Commute`/`TraceEq`/`replay_eq_of_traceEq`).
`completeStep` is the concrete, receipt-preserving event-application function for
`ExecutionState`; `concurrent_commute` is the correspondence map showing that layer's
"which pairs of events may commute" question is answered by `Order.Concurrent`; and
`frontier_interleaving_replay_eq` transports `Replay`'s trace-equivalence-preserves-replay
theorem onto that concrete step function, by direct instantiation (no new proof machinery).

Crown law:
`Concurrent p i j → Commute (completeStep p) i j`, hence any two `completeStep p`-traces
related by the admitted commuting-swap closure `TraceEq` replay to the same `ExecutionState`.

Preserves:
`completionReceipted` (BRCE: no completed node is ever left unreceipted) across every
`completeStep` application, and `authorized` unconditionally (this step never authorizes or
revokes authorization; it only records completion+receipt of an already-authorized node).

Excludes:
enforcement of `MayStart`/`Enabled` — `completeStep` does not check that `i` was actually
enabled before marking it complete; that precondition is the caller's obligation, tracked
separately by `MFW.Order.Enabled`/`MayStart`. This file is only about *replay commutativity*
of the completion-recording step, not about *scheduling legality*.

Falsifier:
two `Concurrent` nodes whose `completeStep` applications, in either order, produce different
final `ExecutionState`s.
-/

namespace ProcInt.Playground.Glue

open ProcInt.Playground.MFW
open ProcInt.Playground.Swarm11

/--
Records completion and receipt of node `i` in one finite partial-order region, leaving
`authorized` and every other node's `completed`/`receipted` status unchanged.

`receipted` is updated in lockstep with `completed` (both flip to `True` at exactly `i`,
`False`-relative-to-`i` unchanged elsewhere) so that `ExecutionState.completionReceipted`
(BRCE: no completed node is ever left unreceipted) survives the step — proved immediately
below as the `completionReceipted` field obligation, not assumed.
-/
def completeStep (p : StrictOrder n) (i : Fin n) (s : ExecutionState n) : ExecutionState n where
  authorized := s.authorized
  completed := fun j => j = i ∨ s.completed j
  receipted := fun j => j = i ∨ s.receipted j
  completionReceipted := by
    intro j hj
    rcases hj with hj | hj
    · exact Or.inl hj
    · exact Or.inr (s.completionReceipted j hj)

/--
`ExecutionState` equality reduces to equality of its three predicate fields: the fourth field
(`completionReceipted`) is a proof of a `Prop`, hence definitionally irreducible to a unique
inhabitant (Lean's built-in proof irrelevance) once the first three fields agree, so no fourth
hypothesis is needed or possible to state independently.
-/
theorem executionState_ext {s t : ExecutionState n}
    (hAuthorized : s.authorized = t.authorized)
    (hCompleted : s.completed = t.completed)
    (hReceipted : s.receipted = t.receipted) :
    s = t := by
  cases s
  cases t
  subst hAuthorized; subst hCompleted; subst hReceipted
  rfl

/--
`completeStep p` at any two nodes `i j` commutes, in the sense required by
`Swarm11.Replay.Commute`. `Concurrent p i j` is accepted as the hypothesis (it is the
physically meaningful applicability condition: only structurally-concurrent completions are
ever legitimately reordered by a caller, since `Order.Enabled`/`MayStart` is what prevents a
causally-ordered pair from both being simultaneously eligible in the first place) but is not
consumed by this specific derivation: `completeStep`'s field updates are `Prop`-valued
disjunctive unions (`fun k => k = i ∨ s.completed k`), and `Or` is commutative/associative for
*every* `i j` (`or_left_comm`), independent of whether `i = j`. This is a strictly stronger
fact about this concrete representation than the task's minimal requirement, reported honestly
rather than manufacturing an unneeded case split on `i ≠ j`.
-/
theorem concurrent_commute (p : StrictOrder n) {i j : Fin n} (h : Concurrent p i j) :
    Replay.Commute (completeStep p) i j := by
  intro s
  refine executionState_ext rfl ?_ ?_
  · funext k
    show (k = j ∨ (k = i ∨ s.completed k)) = (k = i ∨ (k = j ∨ s.completed k))
    exact propext or_left_comm
  · funext k
    show (k = j ∨ (k = i ∨ s.receipted k)) = (k = i ∨ (k = j ∨ s.receipted k))
    exact propext or_left_comm

/--
The payoff: any two `completeStep p`-event-traces related by the admitted commuting-swap
closure `Replay.TraceEq` (built, in particular, from `concurrent_commute` witnesses at each
swap site) replay to the identical final `ExecutionState`. Direct instantiation of
`Replay.replay_eq_of_traceEq` at `Event := Fin n`, `State := ExecutionState n`,
`step := completeStep p` — no new replay machinery, exactly the cross-layer correspondence
this file exists to admit.
-/
theorem frontier_interleaving_replay_eq (p : StrictOrder n)
    {left right : List (Fin n)}
    (hEquivalent : Replay.TraceEq (completeStep p) left right)
    (s : ExecutionState n) :
    Replay.replay (completeStep p) left s = Replay.replay (completeStep p) right s :=
  Replay.replay_eq_of_traceEq (completeStep p) hEquivalent s

end ProcInt.Playground.Glue
