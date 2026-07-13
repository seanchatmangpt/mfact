-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
/-!
# Standing Algebra

Pipeline:
`candidate → finite experiment → counterexample/refutation or theorem admission`.

Crown law:
finite verification never promotes itself to theorem standing.

Preserves:
claim identity; evidence class; explicit claim ceiling.

Excludes:
ambient theorem authority; boolean-only status collapse; silent promotion.

Standing:
foundational executable rail.

Falsifier:
`FINITE_VERIFIED` is accepted by `canClaimTheorem`.

Downstream:
`Experiment`, `Crown`, verifier output.
-/

namespace ProcInt.Playground.Experimental

/--
Standing state for an experimental mathematical claim.

Law: theorem authority is carried only by `PROVEN`.
Carrier: claim-state algebra.
Admission: constructors are explicit; there is no implicit promotion function.
Preserves: the evidence class that justified the state.
Refuses: collapse of finite evidence into theorem authority.
Claim ceiling: `FINITE_VERIFIED` may justify a finite-domain claim, never a theorem claim.
-/
inductive Standing where
  | CANDIDATE_ONLY
  | FINITE_VERIFIED
  | REFUTED
  | PROVEN
  | BLOCKED
  | UNKNOWN
  | UNSUPPORTED
  deriving Repr, DecidableEq, Inhabited, BEq

/--
Whether the standing state authorizes a theorem claim.

Law: only `PROVEN` returns true.
Carrier: `Standing → Bool`.
Admission: kernel standing must already have been established elsewhere.
Preserves: no-ambient-theorem-authority.
Refuses: `FINITE_VERIFIED`, `CANDIDATE_ONLY`, and every non-proof state.
Claim ceiling: theorem-claim gate only; it says nothing about runtime reachability.
-/
def Standing.canClaimTheorem : Standing → Bool
  | .PROVEN => true
  | _ => false

/--
Whether the standing state contains a finite-domain experimental result.

Law: `FINITE_VERIFIED` and `REFUTED` both carry a completed finite search.
Carrier: experimental standing.
Admission: the finite search has terminated.
Preserves: distinction between agreement and counterexample.
Refuses: `UNKNOWN` as evidence.
Claim ceiling: finite searched domain only.
-/
def Standing.hasFiniteResult : Standing → Bool
  | .FINITE_VERIFIED => true
  | .REFUTED => true
  | _ => false

/-- Claim surface authorized by evidence. -/
inductive ClaimCeiling where
  | candidate
  | finiteDomain
  | theorem
  deriving Repr, DecidableEq, Inhabited, BEq

/--
A named claim with explicit standing and ceiling.

Law: claim text and authority travel together.
Carrier: proof/manufacturing metadata.
Admission: standing is explicit.
Preserves: claim identity and authority boundary.
Refuses: prose-only standing.
Receipt: serializable by `Repr`.
Claim ceiling: carried in `ceiling`.
-/
structure Claim where
  name : String
  standing : Standing
  ceiling : ClaimCeiling
  deriving Repr, DecidableEq, BEq

/--
Checks that a claim ceiling does not exceed its standing.

Law: theorem ceilings require `PROVEN`; finite ceilings require a completed finite result.
Carrier: `Claim → Bool`.
Admission: conservative authority check.
Preserves: claim name.
Refuses: theorem claims from finite experiments.
Claim ceiling: this is the local ceiling gate itself.
-/
def Claim.authorized (c : Claim) : Bool :=
  match c.ceiling with
  | .candidate => true
  | .finiteDomain => c.standing.hasFiniteResult
  | .theorem => c.standing.canClaimTheorem

@[simp] theorem finiteVerified_not_theorem :
    Standing.FINITE_VERIFIED.canClaimTheorem = false := rfl

@[simp] theorem proven_can_claim_theorem :
    Standing.PROVEN.canClaimTheorem = true := rfl

end ProcInt.Playground.Experimental
