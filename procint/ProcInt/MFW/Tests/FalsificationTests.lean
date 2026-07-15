import ProcInt.MFW.Falsification

namespace ProcInt.MFW.Tests

/-!
# ProcInt.MFW.Tests.FalsificationTests

This file verifies the Definition of Done for `ProcInt.MFW.Falsification`.
It constructs a concrete integration scenario where a transformation's admission
is revoked due to observed defect evidence, using the empirical falsifier definitions.
-/

/--
  Scenario:
  Assume a context `ctx` where `T` is admitted, and there is defect evidence `E` such that
  the empirical falsifier holds (i.e. `revocationCondition ctx T E`).
  Under the assumption that `empiricalFalsificationLoop ctx T E` is satisfied,
  we prove that `getStatus (revoke ctx T) T` is `Status.Revoked`.
-/
theorem revocation_scenario (ctx : Context) (T : Transformation) (E : DefectEvidence)
  (h_loop : empiricalFalsificationLoop ctx T E)
  (h_cond : revocationCondition ctx T E) :
  getStatus (revoke ctx T) T = Status.Revoked := by
  exact h_loop h_cond

/--
  Scenario refinement:
  We can show that if we have `getStatus ctx T = Status.Admitted` and `empiricalFalsifier T E`,
  then the revocation condition holds.
-/
theorem revocation_condition_holds (ctx : Context) (T : Transformation) (E : DefectEvidence)
  (h_admitted : getStatus ctx T = Status.Admitted)
  (h_falsified : empiricalFalsifier T E) :
  revocationCondition ctx T E := by
  exact ⟨h_admitted, h_falsified⟩

/--
  Combining the two:
  If a transformation `T` is admitted in `ctx`, and there is defect evidence `E` that falsifies it,
  then assuming the loop holds, the revoked context has `T`'s status as `Status.Revoked`.
-/
theorem verify_revocation (ctx : Context) (T : Transformation) (E : DefectEvidence)
  (h_loop : empiricalFalsificationLoop ctx T E)
  (h_admitted : getStatus ctx T = Status.Admitted)
  (h_falsified : empiricalFalsifier T E) :
  getStatus (revoke ctx T) T = Status.Revoked :=
  revocation_scenario ctx T E h_loop (revocation_condition_holds ctx T E h_admitted h_falsified)

end ProcInt.MFW.Tests
