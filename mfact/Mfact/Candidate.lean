namespace Mfact

/-- An untrusted candidate artifact proposed for admission.

Producers — LLMs included — can only ever mint a `Candidate`. Nothing
downstream treats a candidate as mathematics until it passes the
admission gate; generation is not standing. -/
structure Candidate where
  /-- Stable identifier of the artifact (module path, theorem name, …). -/
  id : String
  /-- Identity of the (untrusted) producer. -/
  producer : String
  /-- BLAKE3 hex-64 hash of the candidate payload. -/
  contentHash : String
  deriving Repr, DecidableEq

end Mfact
