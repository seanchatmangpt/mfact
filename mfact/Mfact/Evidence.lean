namespace Mfact

/-- Closed vocabulary of evidence kinds the factory recognizes. -/
inductive EvidenceKind where
  /-- The Lean kernel accepted the artifact. -/
  | kernelCheck
  /-- `#print axioms` output pinned to the trusted axiom set. -/
  | axiomAudit
  /-- A malformed variant was refused (negative fixture passed). -/
  | negativeFixture
  /-- A build receipt (hash-chained) for the producing step. -/
  | buildReceipt
  /-- A process trace of the manufacturing run itself. -/
  | processTrace
  deriving Repr, DecidableEq

/-- One piece of evidence about a subject artifact. -/
structure Evidence where
  kind : EvidenceKind
  /-- Identifier of the artifact the evidence is about. -/
  subject : String
  /-- BLAKE3 hex-64 hash of the evidence payload. -/
  hash : String
  deriving Repr, DecidableEq

end Mfact
