-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Std

/-!
# Multifractal Workflow: basic admitted objects

The runtime names are representation targets.  A target acquires production
standing only through an executable correspondence and receipts.
-/

namespace ProcInt.Playground.MFW

/-- An atomic workflow activity before it is assigned to a runtime. -/
structure Activity where
  id : Nat
  label : String
  capability : String
deriving Repr, DecidableEq, BEq

/-- Runtime families supported by the workflow projection. -/
inductive Backend
  | rust
  | erlang
  | wasm
  | atomVM
deriving Repr, DecidableEq, BEq

/-- A concrete placement selected for an admitted activity. -/
structure RuntimeTarget where
  backend : Backend
  engine : String
  node : String
deriving Repr, DecidableEq, BEq

namespace RuntimeTarget

def rust (engine : String := "native-rust") : RuntimeTarget :=
  { backend := .rust, engine, node := "local" }

def erlang (node : String := "nonode@nohost") : RuntimeTarget :=
  { backend := .erlang, engine := "OTP", node }

def wasm (engine : String := "wasm4pm") : RuntimeTarget :=
  { backend := .wasm, engine, node := "wasm-sandbox" }

def atomVM (node : String := "edge") : RuntimeTarget :=
  { backend := .atomVM, engine := "AtomVM", node }

end RuntimeTarget

inductive ReceiptKind
  | admission
  | authorization
  | consequence
deriving Repr, DecidableEq, BEq

/-- A small formal receipt surface.  The digest is supplied by the runtime. -/
structure Receipt where
  artifactId : Nat
  activityId : Nat
  backend : Backend
  kind : ReceiptKind
  digest : String
deriving Repr, DecidableEq, BEq

def Receipt.binds (r : Receipt) (a : Activity) : Prop :=
  r.activityId = a.id

@[simp] theorem Receipt.binds_iff (r : Receipt) (a : Activity) :
    r.binds a ↔ r.activityId = a.id := Iff.rfl

end ProcInt.Playground.MFW
