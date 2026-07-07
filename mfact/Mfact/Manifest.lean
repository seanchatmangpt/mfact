import Lean.Data.Json
import Mfact.Evidence

namespace Mfact

open Lean

/-- One released artifact as recorded in the manifest. -/
structure ArtifactEntry where
  name : String
  /-- BLAKE3 hex-64 of the artifact source. -/
  hash : String
  /-- Transitive axiom set reported by `#print axioms`. -/
  axioms : List String
  /-- `true` = kernel-proven theorem; `false` = stated-not-proven. -/
  proven : Bool
  deriving ToJson, FromJson, Repr, DecidableEq

/-- Evidence entry in JSON-facing form. -/
structure EvidenceEntry where
  kind : String
  subject : String
  hash : String
  deriving ToJson, FromJson, Repr, DecidableEq

/-- The release manifest. Timestamps are deliberately absent from hashed
content: time enters receipts only from build-graph literals, never from a
wall clock. -/
structure Manifest where
  schema : String := "mfact.release.v1"
  release : String
  artifacts : List ArtifactEntry
  evidence : List EvidenceEntry
  /-- Names of theorem stubs that remain stated-not-proven. -/
  statedNotProven : List String
  /-- Genesis-folded BLAKE3 of the receipt chain up to this release. -/
  foldHash : String
  deriving ToJson, FromJson, Repr

/-- Count of proven artifacts in a manifest. -/
def Manifest.provenCount (m : Manifest) : Nat :=
  m.artifacts.filter (·.proven) |>.length

/-- Proven and stated artifacts partition the artifact list. -/
theorem Manifest.proven_le_total (m : Manifest) :
    m.provenCount ≤ m.artifacts.length := by
  exact List.length_filter_le _ _

end Mfact
