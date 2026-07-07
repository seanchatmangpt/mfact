import Mfact.CertifiedRelease

namespace Mfact

/-- The closed objection type for a certified release.

A valid objection is a constructor, not rhetoric: each constructor demands
a machine-checkable witness that a specific certification gate failed.
There is no constructor for "I am not convinced". -/
inductive ValidObjection (R : CertifiedRelease) : Type where
  /-- Witness that the release contains a `sorry`. -/
  | sorryPresent (h : R.gates.sorryFree = false)
  /-- Witness that some theorem depends on an unauthorized axiom. -/
  | unauthorizedAxiom (h : R.gates.axiomsClean = false)
  /-- Witness that a fixture (positive or negative) failed. -/
  | fixtureFailure (h : R.gates.fixturesPass = false)
  /-- Witness that required evidence is missing from the manifest. -/
  | missingEvidence (h : R.gates.evidenceComplete = false)

/-- **Closed-objection theorem.** A release whose gates all passed admits
no valid objection: the objection type is uninhabited. Criticism of such a
release must therefore attack the gate definitions themselves — a finite,
typed surface — not the artifact. -/
theorem no_valid_objection (R : CertifiedRelease) (hall : R.gates.allPass) :
    ValidObjection R → False := by
  obtain ⟨hs, ha, hf, he⟩ := hall
  intro o
  cases o with
  | sorryPresent h => rw [hs] at h; exact Bool.noConfusion h
  | unauthorizedAxiom h => rw [ha] at h; exact Bool.noConfusion h
  | fixtureFailure h => rw [hf] at h; exact Bool.noConfusion h
  | missingEvidence h => rw [he] at h; exact Bool.noConfusion h

end Mfact
