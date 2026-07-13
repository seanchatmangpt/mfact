-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Dogfood.Guard

/-!
# Lifecycle Off the By-Construction Crutch (Operation Dogfood, Wave 3)

Pipeline:
`arbitrary event trace → decidable receipt/grounding checks → bridge to the fused
dynamics → idempotence and duplicate refusal → composed resume from a receipt`.

Crown law:
the PRD §5 hard invariant `{a | actuated(a) ∧ ¬receipted(a)} = ∅` stated and decided over
**arbitrary** traces (`receiptCheck_false_iff`), not over states whose type makes orphans
unrepresentable — exactly the gap `ROADMAP_SOC2_MATH.md §3(c)` names for
`zero_unreceipted_completion` (`MFW/Runtime.lean:62`, a structure-field unpacking). The
bridge theorem (`renderCompletion_receiptCheck`) then proves the fused `completeStep`
dynamics only ever produce traces the dynamic checker admits, connecting the two worlds
in the honest direction.

Preserves:
receipt-per-actuation and observation-per-receipt across trace membership; the replayed
final state across the receipt boundary (`resume_from_receipt`).

Excludes:
any claim that a passing `receiptCheck` proves the *runtime* produced the trace — trace
admission is Lean-side; producing honest traces is the consumer's obligation (FR-13,
PRD §6.5); cryptographic receipt authenticity (`Replay.Receipt`'s own docstring already
scopes it to mathematical consequence binding).

Standing:
kernel-proven theorems over the trace model; finite-domain for the demo checks.

Falsifier:
a trace containing an actuation with no receipt (or a receipt with no observation) that
the combined check admits; or a guarded re-completion that yields a second receipt
instead of a typed refusal.

Downstream:
`Swarm11Verifier` (checks fold), `AxiomAuditDogfood`.

Claim ceiling: theorem for the trace laws; finite-domain for the demo checks.
-/

namespace ProcInt.Playground.Dogfood

open ProcInt.Playground.MFW
open ProcInt.Playground.Glue
open ProcInt.Playground.Swarm11

/-! ## The event-trace model

Three event kinds, deliberately separating the press release's triad: `actuate` (the
mutation intent was executed), `observe` (the real consequence was admitted), `receipt`
(the consequence was sealed). "Expected effect ≠ observed consequence" is the law that
`receipt` requires `observe`, never just `actuate`. -/

/-- One lifecycle event for action identifier `a`. -/
inductive LifecycleEvent (α : Type) where
  | actuate (a : α)
  | observe (a : α)
  | receipt (a : α)
  deriving Repr, DecidableEq

/-- Per-event receipt obligation against a fixed trace: every actuation must have a
receipt somewhere in the trace. -/
def eventReceiptOk {α : Type} [DecidableEq α] (t : List (LifecycleEvent α)) :
    LifecycleEvent α → Bool
  | .actuate a => decide (LifecycleEvent.receipt a ∈ t)
  | .observe _ => true
  | .receipt _ => true

/-- **The PRD §5 hard invariant, decidable over arbitrary traces**: no actuation without
a receipt. -/
def receiptCheck {α : Type} [DecidableEq α] (t : List (LifecycleEvent α)) : Bool :=
  t.all (eventReceiptOk t)

/-- Per-event grounding obligation: every receipt must be grounded in an observed
consequence — a receipt manufactured from the planned effect alone is inadmissible. -/
def eventGroundedOk {α : Type} [DecidableEq α] (t : List (LifecycleEvent α)) :
    LifecycleEvent α → Bool
  | .actuate _ => true
  | .observe _ => true
  | .receipt a => decide (LifecycleEvent.observe a ∈ t)

/-- The expected-effect ≠ observed-consequence law, decidable: receipts only from
observations. -/
def groundedCheck {α : Type} [DecidableEq α] (t : List (LifecycleEvent α)) : Bool :=
  t.all (eventGroundedOk t)

/-- Combined lifecycle admissibility. -/
def lifecycleCheck {α : Type} [DecidableEq α] (t : List (LifecycleEvent α)) : Bool :=
  receiptCheck t && groundedCheck t

/-- **The iff theorem.** `receiptCheck` fails exactly when an orphan actuation exists:
`receiptCheck t = false ↔ ∃ a, actuate a ∈ t ∧ receipt a ∉ t`. This is the hard
invariant for values NOT built through `ExecutionState` — orphans are representable
here and are refuted by decision, not by unrepresentability. -/
theorem receiptCheck_false_iff {α : Type} [DecidableEq α]
    (t : List (LifecycleEvent α)) :
    receiptCheck t = false ↔
      ∃ a, LifecycleEvent.actuate a ∈ t ∧ LifecycleEvent.receipt a ∉ t := by
  constructor
  · intro h
    rw [receiptCheck, Bool.eq_false_iff] at h
    have h' : ¬ ∀ e ∈ t, eventReceiptOk t e = true := by
      intro hall
      exact h (List.all_eq_true.mpr hall)
    push_neg at h'
    obtain ⟨e, he, hne⟩ := h'
    cases e with
    | actuate a =>
        refine ⟨a, he, ?_⟩
        intro hmem
        exact hne (by simp [eventReceiptOk, hmem])
    | observe a => exact absurd rfl hne
    | receipt a => exact absurd rfl hne
  · rintro ⟨a, ha, hnr⟩
    rw [receiptCheck, Bool.eq_false_iff]
    intro hall
    have := List.all_eq_true.mp hall _ ha
    simp [eventReceiptOk] at this
    exact hnr this

/-- The mirror iff for grounding: `groundedCheck` fails exactly when some receipt has no
observed consequence behind it — the impersonation witness. -/
theorem groundedCheck_false_iff {α : Type} [DecidableEq α]
    (t : List (LifecycleEvent α)) :
    groundedCheck t = false ↔
      ∃ a, LifecycleEvent.receipt a ∈ t ∧ LifecycleEvent.observe a ∉ t := by
  constructor
  · intro h
    rw [groundedCheck, Bool.eq_false_iff] at h
    have h' : ¬ ∀ e ∈ t, eventGroundedOk t e = true := by
      intro hall
      exact h (List.all_eq_true.mpr hall)
    push_neg at h'
    obtain ⟨e, he, hne⟩ := h'
    cases e with
    | actuate a => exact absurd rfl hne
    | observe a => exact absurd rfl hne
    | receipt a =>
        refine ⟨a, he, ?_⟩
        intro hmem
        exact hne (by simp [eventGroundedOk, hmem])
  · rintro ⟨a, ha, hno⟩
    rw [groundedCheck, Bool.eq_false_iff]
    intro hall
    have := List.all_eq_true.mp hall _ ha
    simp [eventGroundedOk] at this
    exact hno this

/-! ## Bridge to the fused dynamics

`completeStep` (`Glue/RuntimeReplay.lean:58`) fuses completion with receipt, which is
why `zero_unreceipted_completion` holds by construction. Rendering a completion trace
into lifecycle events shows the fused dynamics only produce traces the dynamic checker
admits — the by-construction world is a subset of the dynamically-checked world. -/

/-- Render a completion trace as lifecycle events: each completion actuates, observes,
and receipts its node (the fusion, made explicit). -/
def renderCompletion {n : Nat} (tr : List (Fin n)) : List (LifecycleEvent (Fin n)) :=
  tr.flatMap fun i => [.actuate i, .observe i, .receipt i]

/-- The bridge: fused-dynamics traces always pass the trace-level hard invariant. -/
theorem renderCompletion_receiptCheck {n : Nat} (tr : List (Fin n)) :
    receiptCheck (renderCompletion tr) = true := by
  rw [receiptCheck, List.all_eq_true]
  intro e he
  simp only [renderCompletion, List.mem_flatMap] at he
  obtain ⟨i, hi, hei⟩ := he
  simp at hei
  rcases hei with rfl | rfl | rfl
  · simp only [eventReceiptOk, decide_eq_true_eq, renderCompletion, List.mem_flatMap]
    exact ⟨i, hi, by simp⟩
  · rfl
  · rfl

/-- The bridge, grounding half: fused-dynamics traces are also observation-grounded. -/
theorem renderCompletion_groundedCheck {n : Nat} (tr : List (Fin n)) :
    groundedCheck (renderCompletion tr) = true := by
  rw [groundedCheck, List.all_eq_true]
  intro e he
  simp only [renderCompletion, List.mem_flatMap] at he
  obtain ⟨i, hi, hei⟩ := he
  simp at hei
  rcases hei with rfl | rfl | rfl
  · rfl
  · rfl
  · simp only [eventGroundedOk, decide_eq_true_eq, renderCompletion, List.mem_flatMap]
    exact ⟨i, hi, by simp⟩

/-! ## Step idempotence and duplicate refusal (NFR-8) -/

/-- Raw-step idempotence: re-applying a completion changes nothing — replay convergence
at the state level. -/
theorem completeStep_idem {n : Nat} (p : StrictOrder n) (i : Fin n)
    (s : ExecutionState n) :
    completeStep p i (completeStep p i s) = completeStep p i s := by
  refine executionState_ext rfl ?_ ?_
  · funext j
    exact propext ⟨fun h => h.elim Or.inl id, Or.inr⟩
  · funext j
    exact propext ⟨fun h => h.elim Or.inl id, Or.inr⟩

/-- Guarded duplicate refusal: re-completing an already-completed node is a typed
refusal (`notEnabled`), never a second receipt. Together with `completeStep_idem` this
is NFR-8: replay yields the same state or a refusal, never a duplicate. -/
theorem guarded_refuses_duplicate {n : Nat} (p : StrictOrder n)
    (s : ExecutionState n) (i : Fin n)
    [DecidablePred s.authorized] [DecidablePred s.completed]
    (hdone : s.completed i) :
    guardedCompleteStep p s i = .error (.notEnabled i) := by
  unfold guardedCompleteStep
  rw [dif_neg]
  intro hE
  have hE' : ¬ s.completed i ∧ ∀ j, p.before j i → s.completed j := hE
  exact hE'.1 hdone

/-! ## Composed resume (NFR-7)

Resuming from a manufactured receipt's final state and continuing equals the single
full run — `replay_append` (`Swarm11/Replay.lean:40`) composed across the receipt
boundary. -/

/-- Resume-from-receipt: continuing a suffix from a receipt's bound final state is
exactly the full-trace replay. -/
theorem resume_from_receipt {Event State : Type} (step : Event → State → State)
    (leading suffix : List Event) (s0 : State) :
    Replay.replay step suffix (Replay.manufactureReceipt step s0 leading).final =
      Replay.replay step (leading ++ suffix) s0 :=
  (Replay.replay_append step leading suffix s0).symm

/-! ## Concrete fixtures: honest, orphan, impersonation -/

/-- The honest lifecycle: actuate, observe, receipt. -/
def honestTrace : List (LifecycleEvent Nat) := [.actuate 0, .observe 0, .receipt 0]

/-- The orphan negative fixture: actuated, observed, never receipted. -/
def orphanTrace : List (LifecycleEvent Nat) := [.actuate 0, .observe 0]

/-- The impersonation countermodel: a receipt manufactured directly from the planned
effect, with no observed consequence — passes the receipt check alone, refused by the
grounding check (Vision 2030 falsifier #5). -/
def impersonationTrace : List (LifecycleEvent Nat) := [.actuate 0, .receipt 0]

/-- Impersonation is refused by the combined check even though `receiptCheck` alone
passes — the separation between the two checks IS the expected≠observed law. -/
theorem impersonation_refused :
    receiptCheck impersonationTrace = true ∧
      groundedCheck impersonationTrace = false ∧
      lifecycleCheck impersonationTrace = false := by
  refine ⟨by decide, by decide, by decide⟩

/-- The demo resume: replaying `[3]` from the receipt of `[1, 2]` equals replaying
`[1, 2, 3]` from scratch (over the toy additive state). -/
def resumeDemoStep (e : Nat) (s : Nat) : Nat := s + e

/-! ## Executable checks (folded into `swarm11-verify` at Wave 5) -/

instance : DecidablePred (completeStep freeOrder2 0 demoFinal).completed := fun i =>
  inferInstanceAs (Decidable (i = 0 ∨ demoFinal.completed i))

/-- Standing-aware checks, `AuditFlow.checks`-style. -/
def lifecycleChecks : List (String × Bool) := [
  ("lifecycle-honest-trace-admitted", lifecycleCheck honestTrace),
  ("lifecycle-orphan-actuation-refused", !(receiptCheck orphanTrace)),
  ("lifecycle-orphan-witness-is-decidable",
    decide (LifecycleEvent.actuate 0 ∈ orphanTrace ∧
      LifecycleEvent.receipt 0 ∉ orphanTrace)),
  ("lifecycle-impersonation-passes-receipt-check-alone",
    receiptCheck impersonationTrace),
  ("lifecycle-impersonation-refused-by-grounding",
    !(groundedCheck impersonationTrace) && !(lifecycleCheck impersonationTrace)),
  ("lifecycle-fused-dynamics-render-admitted",
    lifecycleCheck (renderCompletion [(0 : Fin 2), 1])),
  ("lifecycle-duplicate-completion-refused-typed",
    match guardedCompleteStep freeOrder2 demoFinal 0 with
    | .error (.notEnabled _) => true
    | _ => false),
  ("lifecycle-raw-step-idempotent-pointwise",
    decide (∀ j : Fin 2,
      (completeStep freeOrder2 0 demoFinal).completed j ↔ demoFinal.completed j)),
  ("lifecycle-resume-from-receipt-equals-full-run",
    Replay.replay resumeDemoStep [3]
        (Replay.manufactureReceipt resumeDemoStep 0 [1, 2]).final ==
      Replay.replay resumeDemoStep [1, 2, 3] 0)
]

-- Build-time verification: every check passes at elaboration.
#guard lifecycleChecks.all (·.2)

end ProcInt.Playground.Dogfood
