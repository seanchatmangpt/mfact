-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Glue.RuntimeReplay
import ProcInt.Playground.Dogfood.Outcome

/-!
# Pre-Actuation Guard and Approval Coverage (Operation Dogfood, Wave 2)

Pipeline:
`approval (plan digest + mutation set + bound) → authorized predicate → guarded step →
typed refusal or completion → trace-level zero-unauthorized-completion`.

Crown law:
on traces built from the guarded step, no completed node is ever unauthorized —
`{i | completed i ∧ ¬ authorized i} = ∅` earned by dynamics (`zero_unauthorized_completion`
below), mirroring the shape of `zero_unreceipted_completion` (`MFW/Runtime.lean:62`) but
NOT holding by construction: the countermodel section exhibits the unguarded
`completeStep` (`Glue/RuntimeReplay.lean:58`) completing an unauthorized node, exactly the
enforcement gap that file's docstring discloses ("Excludes: enforcement of
`MayStart`/`Enabled`").

Preserves:
`authorized` across every step (`guardedTrace_authorized_invariant`); the
completed-implies-authorized invariant across guarded traces.

Excludes:
any `Crypto.ComputationallyBinding` claim for `Approval.planDigest` — it is a plain `Nat`
label in the `Runtime.Deterministic` dialect (AGENTS.md §4 predicate namespace
separation: a digest here binds a refusal to the plan it was checked against, nothing
more); any claim that this guard is enforced by the praxis runtime — that is a consumer
obligation (FR-9's runtime half).

Standing:
kernel-proven theorems over the guarded relational semantics; finite-domain for the
concrete demo checks.

Falsifier:
a `GuardedTrace` whose final state contains a completed-but-unauthorized node, or a
`guardedCompleteStep` returning `.ok` for a node failing `MayStart`.

Downstream:
`Swarm11Verifier` (checks fold), `AxiomAuditDogfood`, `Lifecycle.lean` (Wave 3).

Claim ceiling: theorem for the trace laws; finite-domain for the demo checks.
-/

namespace ProcInt.Playground.Dogfood

open ProcInt.Playground.MFW
open ProcInt.Playground.Glue

/-! ## Approval coverage (FR-8's mathematical shape) -/

/-- An approval: the plan digest it was granted against, the exact mutation surface it
covers, and the budget bound. The digest is a label (see module docstring), the mutation
set is the law: `covers` is decidable and refusals carry the digest, so a refusal is
data binding the rejected action to the plan it was checked against. -/
structure Approval (Action : Type) [DecidableEq Action] where
  planDigest : Nat
  mutationSet : Finset Action
  fuelBound : Nat

/-- Typed refusal at the approval boundary: the press release's
"return to the permission boundary" is this constructor — the action, and the digest of
the plan whose approval failed to cover it. -/
inductive ApprovalRefusal (Action : Type) where
  | outsideMutationSet (action : Action) (planDigest : Nat)
  deriving Repr

/-- Decidable coverage: an action is covered iff it lies in the approved mutation set. -/
def Approval.covers {Action : Type} [DecidableEq Action]
    (app : Approval Action) (a : Action) : Bool :=
  a ∈ app.mutationSet

/-- The negative law: outside the mutation set, coverage is `false` — never a default
grant. -/
theorem Approval.not_mem_not_covers {Action : Type} [DecidableEq Action]
    (app : Approval Action) {a : Action} (h : a ∉ app.mutationSet) :
    app.covers a = false := by
  simp [Approval.covers, h]

/-- Admission at the permission boundary: covered actions pass through unchanged;
uncovered actions are refused with the binding digest. -/
def Approval.admit {Action : Type} [DecidableEq Action]
    (app : Approval Action) (a : Action) : Except (ApprovalRefusal Action) Action :=
  if app.covers a then .ok a else .error (.outsideMutationSet a app.planDigest)

/-- Soundness: an admitted action was covered and is returned unchanged. -/
theorem Approval.admit_ok_covers {Action : Type} [DecidableEq Action]
    (app : Approval Action) {a b : Action} (h : app.admit a = .ok b) :
    app.covers a = true ∧ b = a := by
  unfold Approval.admit at h
  by_cases hc : app.covers a = true
  · simp [hc] at h
    exact ⟨hc, h.symm⟩
  · simp [Bool.not_eq_true] at hc
    simp [hc] at h

/-- Fail-closed: an uncovered action is refused, and the refusal carries the digest of
the plan it was checked against (the FR-8 binding, in data). -/
theorem Approval.not_covered_refused {Action : Type} [DecidableEq Action]
    (app : Approval Action) {a : Action} (h : a ∉ app.mutationSet) :
    app.admit a = .error (.outsideMutationSet a app.planDigest) := by
  unfold Approval.admit
  simp [app.not_mem_not_covers h]

/-! ## The executable pre-actuation guard (FR-9's mathematical shape) -/

/-- `Enabled` is decidable whenever completion is: the guard can actually run. -/
instance decidableEnabled (p : StrictOrder n) (done : Fin n → Prop) [DecidablePred done]
    (i : Fin n) : Decidable (Enabled p done i) :=
  inferInstanceAs (Decidable (¬ done i ∧ ∀ j, p.before j i → done j))

/-- Typed refusal for the pre-actuation guard: which gate failed, at which node. -/
inductive GuardRefusal (n : Nat) where
  | notEnabled (i : Fin n)
  | notAuthorized (i : Fin n)
  deriving Repr, DecidableEq, BEq

/-- The guarded completion step: checks `Enabled` then `authorized` (together exactly
`MayStart`, `MFW/Runtime.lean:58`) before delegating to the unguarded `completeStep`.
Refusal is data, never a silent skip and never a panic. -/
def guardedCompleteStep (p : StrictOrder n) (s : ExecutionState n) (i : Fin n)
    [DecidablePred s.authorized] [DecidablePred s.completed] :
    Except (GuardRefusal n) (ExecutionState n) :=
  if hE : Enabled p s.completed i then
    if hA : s.authorized i then
      .ok (completeStep p i s)
    else
      .error (.notAuthorized i)
  else
    .error (.notEnabled i)

/-- Relational guarded step: a transition exists only under `MayStart`. This is the
semantics the executable guard is proven sound against. -/
inductive GuardedStep (p : StrictOrder n) :
    ExecutionState n → Fin n → ExecutionState n → Prop where
  | mk (s : ExecutionState n) (i : Fin n) (h : MayStart p s i) :
      GuardedStep p s i (completeStep p i s)

/-- Inversion: every guarded step carries its `MayStart` witness. -/
theorem GuardedStep.mayStart {p : StrictOrder n} {s s' : ExecutionState n} {i : Fin n}
    (h : GuardedStep p s i s') : MayStart p s i := by
  cases h with
  | mk hms => exact hms

/-- Soundness of the executable guard: `.ok` states are exactly guarded transitions —
the guard never admits a node failing `MayStart` (NFR-2 fail-closed, mechanized). -/
theorem guardedCompleteStep_ok_sound {p : StrictOrder n} {s s' : ExecutionState n}
    {i : Fin n} [DecidablePred s.authorized] [DecidablePred s.completed]
    (h : guardedCompleteStep p s i = .ok s') : GuardedStep p s i s' := by
  unfold guardedCompleteStep at h
  split at h
  next hE =>
    split at h
    next hA =>
      injection h with h'
      subst h'
      exact GuardedStep.mk s i ⟨hE, hA⟩
    next => simp at h
  next => simp at h

/-! ## The trace-level theorem: unauthorized completion is zero, earned by dynamics -/

/-- A guarded trace: a chain of guarded steps. Refusals do not appear here — a refused
step produces no transition, so an unauthorized node can never enter `completed`. -/
inductive GuardedTrace (p : StrictOrder n) :
    ExecutionState n → List (Fin n) → ExecutionState n → Prop where
  | nil (s : ExecutionState n) : GuardedTrace p s [] s
  | cons {s s' s'' : ExecutionState n} {i : Fin n} {rest : List (Fin n)}
      (hstep : GuardedStep p s i s') (htrace : GuardedTrace p s' rest s'') :
      GuardedTrace p s (i :: rest) s''

/-- One guarded step preserves `authorized` exactly (`completeStep` passes it through). -/
theorem guardedStep_authorized_invariant {p : StrictOrder n}
    {s s' : ExecutionState n} {i : Fin n} (h : GuardedStep p s i s') :
    s'.authorized = s.authorized := by
  cases h with
  | mk _ => rfl

/-- `authorized` is invariant across guarded traces: the guard consults authority, it
never manufactures or revokes it. -/
theorem guardedTrace_authorized_invariant {p : StrictOrder n}
    {s sF : ExecutionState n} {tr : List (Fin n)} (h : GuardedTrace p s tr sF) :
    sF.authorized = s.authorized := by
  induction h with
  | nil _ => rfl
  | cons hstep _ ih => exact ih.trans (guardedStep_authorized_invariant hstep)

/-- One guarded step preserves the completed-implies-authorized invariant: the newly
completed node is authorized by its own `MayStart` witness, old nodes by hypothesis. -/
theorem guardedStep_preserves_inv {p : StrictOrder n}
    {s s' : ExecutionState n} {i : Fin n} (hstep : GuardedStep p s i s')
    (hinv : ∀ j, s.completed j → s.authorized j) :
    ∀ j, s'.completed j → s'.authorized j := by
  cases hstep with
  | mk hms =>
      have hms' : Enabled p s.completed i ∧ s.authorized i := hms
      intro j hj
      have hj' : j = i ∨ s.completed j := hj
      show s.authorized j
      rcases hj' with rfl | hold
      · exact hms'.2
      · exact hinv j hold

/-- The inductive invariant lifted across whole guarded traces. -/
theorem completed_implies_authorized_of_guarded {p : StrictOrder n}
    {s sF : ExecutionState n} {tr : List (Fin n)} (h : GuardedTrace p s tr sF) :
    (∀ i, s.completed i → s.authorized i) → ∀ i, sF.completed i → sF.authorized i := by
  induction h with
  | nil _ => exact id
  | cons hstep _ ih => exact fun hinv => ih (guardedStep_preserves_inv hstep hinv)

/-- **The permission analog of the hard invariant, earned dynamically.** From an
initially-clean state, every guarded trace ends with zero unauthorized completions:
`{i | completed i ∧ ¬ authorized i} = ∅`. Mirrors `zero_unreceipted_completion`'s shape
but is a theorem about the guarded dynamics, not a structure field — the countermodel
below shows it FAILS for the unguarded step, so the guard is load-bearing. -/
theorem zero_unauthorized_completion {p : StrictOrder n}
    {s0 sF : ExecutionState n} {tr : List (Fin n)} (h : GuardedTrace p s0 tr sF)
    (hinit : ∀ i, ¬ s0.completed i) :
    ¬ ∃ i, sF.completed i ∧ ¬ sF.authorized i := by
  rintro ⟨i, hc, hna⟩
  exact hna (completed_implies_authorized_of_guarded h
    (fun j hj => absurd hj (hinit j)) i hc)

/-! ## Concrete demo: approval-derived authorization, no vacuity

`AuditFlow.s0` authorizes every step vacuously (`fun _ => True`,
`SOC2/AuditFlow.lean:330`). Here authorization is derived from an `Approval`'s mutation
set instead: node `0` is covered, node `1` is not — so the demo exercises both the admit
and the refuse paths, and the unguarded countermodel is stated on the same data. -/

/-- Two fully concurrent nodes (empty precedence). -/
def freeOrder2 : StrictOrder 2 where
  before := fun _ _ => False
  decidableBefore := fun _ _ => inferInstanceAs (Decidable False)
  irrefl := fun _ h => h
  trans := fun h => h.elim

/-- The demo approval: plan digest label `26713`, mutation set covering node `0` only. -/
def appDemo : Approval (Fin 2) where
  planDigest := 26713
  mutationSet := {0}
  fuelBound := MAX_PLAN_DEPTH

/-- Initial demo state with approval-derived (non-vacuous) authorization. -/
def demoState : ExecutionState 2 where
  authorized := fun i => i ∈ appDemo.mutationSet
  completed := fun _ => False
  receipted := fun _ => False
  completionReceipted := fun _ h => h.elim

instance : DecidablePred demoState.authorized := fun i =>
  inferInstanceAs (Decidable (i ∈ appDemo.mutationSet))

instance : DecidablePred demoState.completed := fun _ =>
  inferInstanceAs (Decidable False)

/-- Both demo nodes are enabled initially (nothing completed, no precedence). -/
theorem demoState_enabled (i : Fin 2) : Enabled freeOrder2 demoState.completed i :=
  ⟨fun h => h, fun _ hj => hj.elim⟩

/-- Node `1` is genuinely unauthorized under the demo approval. -/
theorem demoState_not_authorized_1 : ¬ demoState.authorized 1 := by
  show ¬ ((1 : Fin 2) ∈ appDemo.mutationSet)
  decide

/-- Node `0` is authorized under the demo approval. -/
theorem demoState_authorized_0 : demoState.authorized 0 := by
  show (0 : Fin 2) ∈ appDemo.mutationSet
  decide

/-- The guard admits the covered node. -/
theorem guarded_admits_covered :
    guardedCompleteStep freeOrder2 demoState 0 =
      .ok (completeStep freeOrder2 0 demoState) := by
  unfold guardedCompleteStep
  rw [dif_pos (demoState_enabled 0), dif_pos demoState_authorized_0]

/-- The guard refuses the uncovered node with the precise typed refusal. -/
theorem guarded_refuses_unauthorized :
    guardedCompleteStep freeOrder2 demoState 1 = .error (.notAuthorized 1) := by
  unfold guardedCompleteStep
  rw [dif_pos (demoState_enabled 1), dif_neg demoState_not_authorized_1]

/-- **Countermodel (formalizing `Glue/RuntimeReplay.lean:33-37`).** The unguarded
`completeStep` happily completes the unauthorized node: on the same data the guard
refuses, the raw step manufactures a completed-but-unauthorized state. The guard is
therefore load-bearing — `zero_unauthorized_completion` is not free. -/
theorem unguarded_completes_unauthorized :
    ∃ i, (completeStep freeOrder2 1 demoState).completed i ∧
      ¬ (completeStep freeOrder2 1 demoState).authorized i := by
  refine ⟨1, Or.inl rfl, ?_⟩
  intro h
  exact demoState_not_authorized_1 h

/-- The guarded-reachable final state (only node `0` is reachable under the guard). -/
def demoFinal : ExecutionState 2 := completeStep freeOrder2 0 demoState

instance : DecidablePred demoFinal.completed := fun i =>
  inferInstanceAs (Decidable (i = 0 ∨ False))

instance : DecidablePred demoFinal.authorized := fun i =>
  inferInstanceAs (Decidable (i ∈ appDemo.mutationSet))

/-- The single-step guarded trace reaching `demoFinal`. -/
theorem demoTrace : GuardedTrace freeOrder2 demoState [0] demoFinal :=
  .cons (.mk demoState 0 ⟨demoState_enabled 0,
    show (0 : Fin 2) ∈ appDemo.mutationSet by decide⟩) (.nil demoFinal)

/-- `zero_unauthorized_completion` instantiated at the concrete guarded trace. -/
theorem demoFinal_zero_unauthorized :
    ¬ ∃ i, demoFinal.completed i ∧ ¬ demoFinal.authorized i :=
  zero_unauthorized_completion demoTrace (fun _ h => h)

/-! ## Executable checks (folded into `swarm11-verify` at Wave 5) -/

/-- Discriminator for admitted guard results. -/
def isAdmitted {n : Nat} : Except (GuardRefusal n) (ExecutionState n) → Bool
  | .ok _ => true
  | .error _ => false

/-- Discriminator for the not-authorized refusal. -/
def isNotAuthorizedRefusal {n : Nat} : Except (GuardRefusal n) (ExecutionState n) → Bool
  | .error (.notAuthorized _) => true
  | _ => false

instance : DecidablePred (completeStep freeOrder2 1 demoState).completed := fun i =>
  inferInstanceAs (Decidable (i = 1 ∨ False))

instance : DecidablePred (completeStep freeOrder2 1 demoState).authorized := fun i =>
  inferInstanceAs (Decidable (i ∈ appDemo.mutationSet))

/-- Standing-aware checks, `AuditFlow.checks`-style: every entry independently
re-decided over the concrete demo data. -/
def guardChecks : List (String × Bool) := [
  ("guard-approval-covers-in-set", appDemo.covers 0),
  ("guard-approval-refuses-outside-set", !(appDemo.covers 1)),
  ("guard-admit-refusal-carries-plan-digest",
    match appDemo.admit 1 with
    | .error (.outsideMutationSet _ d) => d == 26713
    | _ => false),
  ("guard-approved-step-admitted",
    isAdmitted (guardedCompleteStep freeOrder2 demoState 0)),
  ("guard-unapproved-step-refused-typed",
    isNotAuthorizedRefusal (guardedCompleteStep freeOrder2 demoState 1)),
  ("guard-unguarded-step-completes-unauthorized-countermodel",
    decide ((completeStep freeOrder2 1 demoState).completed 1) &&
      !(decide ((completeStep freeOrder2 1 demoState).authorized 1))),
  ("guard-final-state-zero-unauthorized-completion",
    decide (∀ i : Fin 2, demoFinal.completed i → demoFinal.authorized i))
]

-- Build-time verification: every check passes at elaboration.
#guard guardChecks.all (·.2)

end ProcInt.Playground.Dogfood
