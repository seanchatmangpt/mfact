-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.TypedWorkflow

/-!
# Deterministic Receipt and Replay Probe

Pipeline:
`closed workflow → deterministic serial interpreter → trace → receipt → replay check`.

Crown law:
the same pure interpreter, closed syntax, and input manufacture the same receipt.

Preserves:
input, output, event order, and deterministic fingerprint material.

Excludes:
cryptographic receipt claims; parallel-runtime adequacy; external hidden state.

Standing:
deterministic executable replay probe.

Correspondence debt:
`fingerprintNat` is intentionally non-cryptographic and must be replaced or bridged
to the repository's BLAKE3 receipt rail before production authority transfers.

Falsifier:
self-replay fails for `receiptOf`.

Downstream:
finite replay experiments and crown reports.
-/

namespace ProcInt.Playground.Experimental

/-- One deterministic interpreter event. -/
structure TraceEvent where
  op : String
  before : Nat
  after : Nat
  deriving Repr, DecidableEq, BEq

/-- Deterministic execution state. -/
structure ExecState where
  value : Nat
  trace : List TraceEvent
  deriving Repr, DecidableEq, BEq

/--
Deterministic serial interpretation of closed workflow syntax.

Law: sequence is left-then-right; parallel is deliberately serialized left-then-right;
choice is deliberately left-biased.
Carrier: executable probe, not a concurrency runtime.
Admission: workflow has `Empty` sockets.
Preserves: deterministic trace order.
Refuses: claims about real parallel scheduling.
Actuation: pure function.
Claim ceiling: interpreter probe only.
-/
def runClosed
    (sem : String → Nat → Nat)
    (w : Workflow String Empty)
    (input : Nat) : ExecState :=
  match w with
  | .socket impossible => nomatch impossible
  | .atom op =>
      let output := sem op input
      {
        value := output
        trace := [{ op := op, before := input, after := output }]
      }
  | .seq left right =>
      let first := runClosed sem left input
      let second := runClosed sem right first.value
      {
        value := second.value
        trace := first.trace ++ second.trace
      }
  | .par left right =>
      let first := runClosed sem left input
      let second := runClosed sem right first.value
      {
        value := second.value
        trace := first.trace ++ second.trace
      }
  | .choice left _ =>
      runClosed sem left input

/-- Deterministic, non-cryptographic string fingerprint for experiment receipts. -/
def fingerprintString (s : String) : Nat :=
  s.toList.foldl (fun hash c => hash * 167 + c.toNat) 2166136261

/-- Deterministic, non-cryptographic trace fingerprint. -/
def fingerprintTrace (events : List TraceEvent) : Nat :=
  events.foldl
    (fun hash event =>
      hash * 257 +
        fingerprintString event.op +
        event.before * 17 +
        event.after * 31)
    1469598103934665603

/--
Experimental replay receipt.

Law: receipt material is derived from deterministic interpreter output.
Carrier: finite replay probe.
Admission: produced by `receiptOf`.
Preserves: input, output, trace length, trace fingerprint.
Refuses: cryptographic integrity claims.
Receipt: this structure is the experimental receipt.
Claim ceiling: deterministic local replay only.
-/
structure ReplayReceipt where
  input : Nat
  output : Nat
  traceLength : Nat
  fingerprint : Nat
  deriving Repr, DecidableEq, BEq, ReflBEq, LawfulBEq

/-- Manufactures a replay receipt from a deterministic run. -/
def receiptOf
    (sem : String → Nat → Nat)
    (w : Workflow String Empty)
    (input : Nat) : ReplayReceipt :=
  let result := runClosed sem w input
  {
    input := input
    output := result.value
    traceLength := result.trace.length
    fingerprint := fingerprintTrace result.trace
  }

/-- Recompute-and-compare replay check. -/
def replays
    (sem : String → Nat → Nat)
    (w : Workflow String Empty)
    (receipt : ReplayReceipt) : Bool :=
  receiptOf sem w receipt.input == receipt

@[simp] theorem self_replay
    (sem : String → Nat → Nat)
    (w : Workflow String Empty)
    (input : Nat) :
    replays sem w (receiptOf sem w input) = true := by
  have h : receiptOf sem w (receiptOf sem w input).input = receiptOf sem w input := rfl
  simp [replays, h]

end ProcInt.Playground.Experimental
