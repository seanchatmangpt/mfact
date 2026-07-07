import Mfact.Manifest

namespace Mfact

/-- Results of the certification gates. Each field is computed by an
external check (build, axiom audit, fixtures, evidence reconciliation)
and mirrored here as data the objection type interrogates. -/
structure GateResults where
  sorryFree : Bool
  axiomsClean : Bool
  fixturesPass : Bool
  evidenceComplete : Bool
  deriving Repr, DecidableEq

/-- All gates passed. -/
def GateResults.allPass (g : GateResults) : Prop :=
  g.sorryFree = true ∧ g.axiomsClean = true ∧
  g.fixturesPass = true ∧ g.evidenceComplete = true

instance (g : GateResults) : Decidable g.allPass := by
  unfold GateResults.allPass; infer_instance

/-- A certified release object: the manifest plus its gate results. -/
structure CertifiedRelease where
  manifest : Manifest
  gates : GateResults

end Mfact
