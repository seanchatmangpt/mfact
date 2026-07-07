import Mfact.Candidate
import Mfact.Refusal
import Mfact.Evidence

namespace Mfact

/-- Evidence kinds every admission must present. -/
def requiredKinds : List EvidenceKind := [.kernelCheck, .axiomAudit]

/-- An admitted artifact: a candidate together with evidence covering every
required kind. The `covers` field is a proof — the only way to construct an
`Admitted` value is to discharge it, so admission cannot be asserted-in. -/
structure Admitted where
  candidate : Candidate
  evidence : List Evidence
  covers : ∀ k ∈ requiredKinds, ∃ e ∈ evidence, e.kind = k

/-- Total admission gate: either an `Admitted` value carrying its own proof,
or a typed `Refusal`. No panic path exists. -/
def admit (c : Candidate) (ev : List Evidence) : Except Refusal Admitted :=
  if h : ∀ k ∈ requiredKinds, ∃ e ∈ ev, e.kind = k then
    .ok ⟨c, ev, h⟩
  else
    .error (.missingEvidence "required evidence kind absent")

/-- Admission is faithful: an admitted value returned by `admit` presents
exactly the candidate and evidence it was given. -/
theorem admit_ok_faithful (c : Candidate) (ev : List Evidence) (a : Admitted)
    (h : admit c ev = .ok a) : a.candidate = c ∧ a.evidence = ev := by
  unfold admit at h
  split at h
  · cases h; exact ⟨rfl, rfl⟩
  · cases h

/-- Admission is honest: `admit` refuses whenever coverage fails. -/
theorem admit_refuses_of_uncovered (c : Candidate) (ev : List Evidence)
    (h : ¬ ∀ k ∈ requiredKinds, ∃ e ∈ ev, e.kind = k) :
    admit c ev = .error (.missingEvidence "required evidence kind absent") := by
  unfold admit
  simp [h]

end Mfact
