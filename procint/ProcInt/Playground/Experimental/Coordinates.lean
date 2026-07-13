-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Standing

/-!
# Semantic Span Geometry

Pipeline:
`semantic headers → coordinate union → basis gain → density report`.

Crown law:
a new artifact is information-bearing only to the extent that it contributes
coordinates not already represented by the current semantic span.

Preserves:
coordinate identity; local standing; claim ceiling.

Excludes:
word count as information density; duplicated prose as new rank.

Standing:
finite combinatorial proxy for hyperdimensional semantic span.

Correspondence debt:
this is not Shannon entropy, Kolmogorov complexity, or vector-space rank.

Falsifier:
the proxy is presented as an information-theoretic theorem rather than an
explicit finite coordinate model.

Downstream:
`Crown`, verifier output, DfCM artifact selection.
-/

namespace ProcInt.Playground.Experimental

/--
Orthogonal semantic coordinates used by the compile-time design protocol.

Law: coordinates identify distinct questions about an artifact.
Carrier: finite semantic basis.
Admission: coordinate constructors are explicit.
Preserves: coordinate identity across headers.
Refuses: free-form labels in the density calculation.
Claim ceiling: finite coordinate model only.
-/
inductive Coordinate where
  | object
  | carrier
  | law
  | admission
  | preservation
  | boundary
  | refusal
  | falsifier
  | actuation
  | receipt
  | replay
  | complexity
  | correspondence
  | claim
  | descent
  | experiment
  deriving Repr, DecidableEq, Inhabited, BEq

/-- Canonical finite coordinate universe. -/
def allCoordinates : List Coordinate := [
  .object, .carrier, .law, .admission, .preservation, .boundary,
  .refusal, .falsifier, .actuation, .receipt, .replay, .complexity,
  .correspondence, .claim, .descent, .experiment
]

/--
Structured semantic metadata for one artifact.

Law: coordinates and authority are carried together.
Carrier: finite semantic header.
Admission: standing and claim ceiling are explicit.
Preserves: artifact identity.
Refuses: density scoring without authority metadata.
Claim ceiling: `claim.ceiling`.
-/
structure SemanticHeader where
  artifact : String
  coordinates : List Coordinate
  claim : Claim
  deriving Repr, DecidableEq, BEq

/-- Duplicate-free coordinates carried by one header. -/
def SemanticHeader.span (h : SemanticHeader) : List Coordinate :=
  h.coordinates.eraseDups

/-- Number of distinct semantic coordinates carried by one header. -/
def SemanticHeader.coordinateCount (h : SemanticHeader) : Nat :=
  h.span.length

/-- Duplicate-free semantic span of a collection of headers. -/
def semanticSpan (hs : List SemanticHeader) : List Coordinate :=
  (hs.flatMap SemanticHeader.span).eraseDups

/-- Finite semantic rank proxy: number of represented coordinates. -/
def spanRankProxy (hs : List SemanticHeader) : Nat :=
  (semanticSpan hs).length

/-- Coordinates in `candidate` not represented by `basis`. -/
def basisGainCoordinates
    (basis : List SemanticHeader) (candidate : SemanticHeader) : List Coordinate :=
  candidate.span.filter (fun c => !((semanticSpan basis).contains c))

/-- Number of new semantic coordinates contributed by a candidate artifact. -/
def basisGain (basis : List SemanticHeader) (candidate : SemanticHeader) : Nat :=
  (basisGainCoordinates basis candidate).length

/-- Coordinate overlap between two headers. -/
def coordinateOverlap (a b : SemanticHeader) : Nat :=
  (a.span.filter (fun c => b.span.contains c)).length

/-- Hamming-style distance over the canonical finite coordinate universe. -/
def semanticHamming (a b : SemanticHeader) : Nat :=
  (allCoordinates.filter (fun c => a.span.contains c != b.span.contains c)).length

/--
Selects one artifact with maximal semantic basis gain.

Law: ties preserve left-to-right source order.
Carrier: greedy finite basis selection.
Admission: all candidates already carry explicit standing.
Preserves: candidate identity.
Refuses: interpreting greedy gain as global optimality.
Complexity: linear scan times finite coordinate-union cost.
Claim ceiling: experimental selection heuristic.
-/
def chooseMaxBasisGain
    (basis candidates : List SemanticHeader) : Option SemanticHeader :=
  match candidates with
  | [] => none
  | x :: xs =>
      some <| xs.foldl
        (fun best candidate =>
          if basisGain basis best < basisGain basis candidate
          then candidate
          else best)
        x

end ProcInt.Playground.Experimental
