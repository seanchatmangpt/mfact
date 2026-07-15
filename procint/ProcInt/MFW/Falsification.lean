namespace ProcInt.MFW

/-- Represents an admitted transformation within the MFW framework. -/
structure Transformation deriving Inhabited

/-- Represents runtime defect evidence gathered empirically. -/
structure DefectEvidence deriving Inhabited

/-- [Notation Authority §38] The Empirical Falsifier (F).
    Evaluates whether the provided runtime defect evidence falsifies the given transformation. -/
opaque empiricalFalsifier : Transformation → DefectEvidence → Prop

/-- The status of a Transformation. -/
inductive Status
| Admitted
| Revoked
deriving Inhabited, Repr, BEq

/-- Represents the context or registry of transformations at a given point in time. -/
structure Context deriving Inhabited

/-- Looks up the status of a transformation in a given context. -/
opaque getStatus : Context → Transformation → Status

/-- [Notation Authority §38] Conditions for revocation.
    Given an admitted transformation in a context, if there is defect evidence such that
    the empirical falsifier holds, it satisfies the condition for revocation. -/
def revocationCondition (ctx : Context) (T : Transformation) (E : DefectEvidence) : Prop :=
  getStatus ctx T = Status.Admitted ∧ empiricalFalsifier T E

/-- Applies revocation to a context, yielding a new context. -/
opaque revoke : Context → Transformation → Context

/-- [Notation Authority §38] The Empirical Falsification Loop.
    It asserts that if a revocation condition is met for transformation T and evidence E
    in context ctx, then the new context after revocation must have the status of T set
    to Revoked. -/
def empiricalFalsificationLoop (ctx : Context) (T : Transformation) (E : DefectEvidence) : Prop :=
  revocationCondition ctx T E → getStatus (revoke ctx T) T = Status.Revoked

end ProcInt.MFW
