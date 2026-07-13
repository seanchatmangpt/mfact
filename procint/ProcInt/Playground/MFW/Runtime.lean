-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.MFW.POWL

/-!
# Rust, Erlang, WASM, AtomVM, and Arrazo projection

The projection keeps the admitted POWL object as the semantic authority.
`route` chooses a heterogeneous runtime target.  Runtime behavior receives
standing only through `ExecutableCorrespondence`.
-/

namespace ProcInt.Playground.MFW

/-- A heterogeneous deployment of one admitted POWL workflow. -/
structure Deployment where
  workflow : POWL
  standing : POWL.Admitted workflow
  route : Activity → RuntimeTarget

namespace Deployment

def ofAdmitted (w : AdmittedPOWL) (route : Activity → RuntimeTarget) : Deployment :=
  { workflow := w.workflow, standing := w.standing, route }

/-- Projection never changes the source workflow. -/
theorem source_preserved (w : AdmittedPOWL) (route : Activity → RuntimeTarget) :
    (ofAdmitted w route).workflow = w.workflow := rfl

end Deployment

inductive RuntimeEvent
  | started (activity : Activity) (target : RuntimeTarget)
  | completed (activity : Activity) (receipt : Receipt)
  | refused (activity : Activity) (reason : String)
deriving Repr

abbrev RuntimeTrace := List RuntimeEvent

/-- The exact bridge required before runtime traces inherit POWL standing. -/
structure ExecutableCorrespondence
    (deployment : Deployment) (powlBehavior : RuntimeTrace → Prop)
    (runtimeBehavior : RuntimeTrace → Prop) : Prop where
  sound : ∀ trace, runtimeBehavior trace → powlBehavior trace
  complete : ∀ trace, powlBehavior trace → runtimeBehavior trace
  consequenceReceipted : ∀ trace activity receipt,
    runtimeBehavior trace →
    RuntimeEvent.completed activity receipt ∈ trace →
    receipt.binds activity

/-- State for one finite partial-order region. -/
structure ExecutionState (n : Nat) where
  authorized : Fin n → Prop
  completed : Fin n → Prop
  receipted : Fin n → Prop
  completionReceipted : ∀ i, completed i → receipted i

def MayStart (p : StrictOrder n) (s : ExecutionState n) (i : Fin n) : Prop :=
  Enabled p s.completed i ∧ s.authorized i

/-- BRCE consequence: a closed execution state contains no unreceipted completion. -/
theorem zero_unreceipted_completion (s : ExecutionState n) :
    ¬ ∃ i, s.completed i ∧ ¬ s.receipted i := by
  intro h
  obtain ⟨i, hdone, hnoreceipt⟩ := h
  exact hnoreceipt (s.completionReceipted i hdone)

/-- A deterministic all-Rust projection. -/
def rustDeployment (w : AdmittedPOWL) : Deployment :=
  .ofAdmitted w (fun _ => .rust)

/-- A deterministic all-Erlang/OTP projection. -/
def erlangDeployment (w : AdmittedPOWL) : Deployment :=
  .ofAdmitted w (fun _ => .erlang)

/-- A deterministic WASM sandbox projection. -/
def wasmDeployment (w : AdmittedPOWL) : Deployment :=
  .ofAdmitted w (fun _ => .wasm)

/-- An AtomVM edge projection. -/
def atomVMDeployment (w : AdmittedPOWL) : Deployment :=
  .ofAdmitted w (fun _ => .atomVM)

/--
An Arrazo-style heterogeneous route.  The capability router is deliberately
separate from POWL: Arrazo selects the executor; POWL remains the process law.
-/
def arrazoRoute (a : Activity) : RuntimeTarget :=
  match a.id % 4 with
  | 0 => .rust "rust-worker"
  | 1 => .erlang "otp@workflow"
  | 2 => .wasm "wasm4pm"
  | _ => .atomVM "edge@atomvm"

def arrazoDeployment (w : AdmittedPOWL) : Deployment :=
  .ofAdmitted w arrazoRoute

end ProcInt.Playground.MFW
