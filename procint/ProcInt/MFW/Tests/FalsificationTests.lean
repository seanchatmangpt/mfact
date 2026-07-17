import ProcInt.MFW.Falsification

namespace ProcInt.MFW.Tests

/-!
# ProcInt.MFW.Tests.FalsificationTests

This file verifies the Definition of Done for `ProcInt.MFW.Falsification`.
It constructs a concrete integration scenario where a transformation's admission
is revoked due to observed defect evidence, using the empirical falsifier definitions.
All scenarios are parameterized over an explicit `FalsificationTheory` instance.
-/

/--
  Scenario:
  Assume a context `ctx` where `T` is admitted, and there is defect evidence `E` such that
  the empirical falsifier holds (i.e. `revocationCondition Th ctx T E`).
  Under the assumption that `empiricalFalsificationLoop Th ctx T E` is satisfied,
  we prove that `Th.getStatus (Th.revoke ctx T) T` is `Status.Revoked`.
-/
theorem revocation_scenario (Th : FalsificationTheory) (ctx : Context) (T : Transformation)
  (E : DefectEvidence)
  (h_loop : empiricalFalsificationLoop Th ctx T E)
  (h_cond : revocationCondition Th ctx T E) :
  Th.getStatus (Th.revoke ctx T) T = Status.Revoked := by
  exact h_loop h_cond

/--
  Scenario refinement:
  We can show that if we have `Th.getStatus ctx T = Status.Admitted` and
  `Th.empiricalFalsifier T E`, then the revocation condition holds.
-/
theorem revocation_condition_holds (Th : FalsificationTheory) (ctx : Context)
  (T : Transformation) (E : DefectEvidence)
  (h_admitted : Th.getStatus ctx T = Status.Admitted)
  (h_falsified : Th.empiricalFalsifier T E) :
  revocationCondition Th ctx T E := by
  exact ⟨h_admitted, h_falsified⟩

/--
  Combining the two:
  If a transformation `T` is admitted in `ctx`, and there is defect evidence `E` that
  falsifies it, then assuming the loop holds, the revoked context has `T`'s status as
  `Status.Revoked`.
-/
theorem verify_revocation (Th : FalsificationTheory) (ctx : Context) (T : Transformation)
  (E : DefectEvidence)
  (h_loop : empiricalFalsificationLoop Th ctx T E)
  (h_admitted : Th.getStatus ctx T = Status.Admitted)
  (h_falsified : Th.empiricalFalsifier T E) :
  Th.getStatus (Th.revoke ctx T) T = Status.Revoked :=
  revocation_scenario Th ctx T E h_loop
    (revocation_condition_holds Th ctx T E h_admitted h_falsified)

/-- Concrete witness theory: every transformation reports `Admitted` and the empirical
falsifier always fires. `revoke` is forced to be a no-op because `Context` carries no
state (it is an empty structure), so this theory violates the falsification loop. -/
def alwaysFalsifyingTheory : FalsificationTheory where
  empiricalFalsifier := fun _ _ => True
  getStatus := fun _ _ => Status.Admitted
  revoke := fun ctx _ => ctx

/-- Concrete witness theory: every transformation reports `Revoked` and the empirical
falsifier never fires. The revocation condition is unsatisfiable here, and the
falsification loop holds because every status already reads `Revoked`. -/
def neverFalsifyingTheory : FalsificationTheory where
  empiricalFalsifier := fun _ _ => False
  getStatus := fun _ _ => Status.Revoked
  revoke := fun ctx _ => ctx

-- Witness pair: statement-adequacy check — `revocationCondition` accepts the admitted,
-- falsified configuration under `alwaysFalsifyingTheory` and provably rejects the same
-- inputs under `neverFalsifyingTheory` (status reads `Revoked`, falsifier never fires).
example : revocationCondition alwaysFalsifyingTheory {} {} {} :=
  ⟨rfl, True.intro⟩

example : ¬ revocationCondition neverFalsifyingTheory {} {} {} := by
  intro h
  exact h.2

-- Witness pair: statement-adequacy check — `empiricalFalsificationLoop` accepts
-- `neverFalsifyingTheory` (the antecedent is unsatisfiable and the conclusion already
-- holds) and provably rejects `alwaysFalsifyingTheory`, whose identity `revoke` leaves
-- a falsified transformation `Admitted` after revocation.
example : empiricalFalsificationLoop neverFalsifyingTheory {} {} {} :=
  fun _ => rfl

example : ¬ empiricalFalsificationLoop alwaysFalsifyingTheory {} {} {} := by
  intro h
  exact nomatch h ⟨rfl, True.intro⟩

end ProcInt.MFW.Tests
