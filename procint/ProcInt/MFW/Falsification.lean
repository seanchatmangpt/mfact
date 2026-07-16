namespace ProcInt.MFW

/-- Represents an admitted transformation within the MFW framework. -/
structure Transformation deriving Inhabited

/-- Represents runtime defect evidence gathered empirically. -/
structure DefectEvidence deriving Inhabited

/-- The status of a Transformation. -/
inductive Status
| Admitted
| Revoked
deriving Inhabited, Repr, BEq

/-- Represents the context or registry of transformations at a given point in time. -/
structure Context deriving Inhabited

/-- A falsification theory: the abstract operations of the empirical falsification loop,
    bundled as explicit hypotheses. Any consumer must be parameterized over an instance,
    making the assumed operations visible rather than hidden global axioms. -/
structure FalsificationTheory where
  /-- [Notation Authority §38] The Empirical Falsifier (F).
      Evaluates whether the provided runtime defect evidence falsifies the given
      transformation. -/
  empiricalFalsifier : Transformation → DefectEvidence → Prop
  /-- Looks up the status of a transformation in a given context. -/
  getStatus : Context → Transformation → Status
  /-- Applies revocation to a context, yielding a new context. -/
  revoke : Context → Transformation → Context

/-- [Notation Authority §38] Conditions for revocation.
    Given an admitted transformation in a context, if there is defect evidence such that
    the empirical falsifier holds, it satisfies the condition for revocation. -/
def revocationCondition (Th : FalsificationTheory) (ctx : Context) (T : Transformation)
    (E : DefectEvidence) : Prop :=
  Th.getStatus ctx T = Status.Admitted ∧ Th.empiricalFalsifier T E

/-- [Notation Authority §38] The Empirical Falsification Loop.
    It asserts that if a revocation condition is met for transformation T and evidence E
    in context ctx, then the new context after revocation must have the status of T set
    to Revoked. -/
def empiricalFalsificationLoop (Th : FalsificationTheory) (ctx : Context) (T : Transformation)
    (E : DefectEvidence) : Prop :=
  revocationCondition Th ctx T E → Th.getStatus (Th.revoke ctx T) T = Status.Revoked

end ProcInt.MFW
