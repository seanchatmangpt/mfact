-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
/-!
# Standing Algebra

Pipeline:
`candidate → finite experiment → theorem admission`.

Crown law:
finite verification cannot authorize theorem standing.

Preserves:
evidence class and claim ceiling.

Excludes:
ambient theorem authority and silent promotion.

Falsifier:
`Standing.finiteVerified.canClaimTheorem = true`.
-/

namespace ProcInt.Playground.Swarm11

/-- Evidence standing carried by a claim. -/
inductive Standing where
  | candidateOnly
  | finiteVerified
  | refuted
  | proven
  | blocked
  | unknown
  | unsupported
  deriving Repr, DecidableEq, Inhabited, BEq

namespace Standing

/--
The theorem-claim gate.

Law: only kernel-proven standing authorizes a theorem claim.
Carrier: standing algebra.
Admission: `proven` must be established outside this Boolean projection.
Preserves: no-ambient-theorem-authority.
Refuses: finite evidence as theorem evidence.
Claim ceiling: theorem authorization only.
-/
def canClaimTheorem : Standing → Bool
  | .proven => true
  | _ => false

/-- Whether a complete finite experiment produced a result. -/
def hasFiniteResult : Standing → Bool
  | .finiteVerified => true
  | .refuted => true
  | _ => false

@[simp] theorem finiteVerified_not_theorem :
    Standing.finiteVerified.canClaimTheorem = false := rfl

@[simp] theorem proven_can_claim_theorem :
    Standing.proven.canClaimTheorem = true := rfl

end Standing

/-- Maximum claim surface authorized by a declaration or experiment. -/
inductive ClaimCeiling where
  | candidate
  | finiteDomain
  | theorem
  deriving Repr, DecidableEq, Inhabited, BEq

/-- Claim text coupled to evidence standing and an explicit ceiling. -/
structure Claim where
  name : String
  standing : Standing
  ceiling : ClaimCeiling
  deriving Repr, DecidableEq, BEq

namespace Claim

/-- Conservative executable claim-ceiling check. -/
def authorized (claim : Claim) : Bool :=
  match claim.ceiling with
  | .candidate => true
  | .finiteDomain => claim.standing.hasFiniteResult
  | .theorem => claim.standing.canClaimTheorem

end Claim

end ProcInt.Playground.Swarm11
