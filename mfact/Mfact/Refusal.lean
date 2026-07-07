namespace Mfact

/-- Closed vocabulary of refusals.

Every way the factory can reject a candidate is a constructor here;
there is no catch-all and no silent default. A refusal is data, not a
panic. -/
inductive Refusal where
  /-- The Lean kernel rejected the candidate. -/
  | kernelRejected (diagnostic : String)
  /-- The candidate (or a dependency) contains `sorry` (`sorryAx`). -/
  | sorryPresent (declName : String)
  /-- The candidate depends on an axiom outside the trusted set. -/
  | unauthorizedAxiom (axiomName : String)
  /-- A required evidence kind was not presented at admission. -/
  | missingEvidence (kind : String)
  /-- The candidate's model shape is malformed (closed-world violation). -/
  | malformedModel (reason : String)
  /-- A negative fixture failed to refuse, or a positive fixture failed. -/
  | fixtureFailure (fixture : String)
  /-- The candidate payload hash does not match its declared hash. -/
  | hashMismatch (expected actual : String)
  deriving Repr, DecidableEq

end Mfact
