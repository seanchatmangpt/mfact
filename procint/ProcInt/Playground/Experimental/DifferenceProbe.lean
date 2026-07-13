-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.WorkflowWorlds

/-!
# Finite-Difference Conjecture Probe

Pipeline:
`integer observations → successive finite differences → first zero layer → degree proxy`.

Crown law:
a zero finite-difference layer on the supplied finite sequence is an experimental
signature, not a theorem that an unknown generating function is polynomial.

Preserves:
observation order and exact integer arithmetic.

Excludes:
interpolation theorem authority; infinite-sequence extrapolation; analytic continuation.

Standing:
classical experimental-mathematics probe for sequence structure.

Falsifier:
the returned degree proxy is called the degree of an unobserved generating law.

Downstream:
workflow-growth probes, tropical traces after numeric projection, conjecture manufacture.
-/

namespace ProcInt.Playground.Experimental

/-- First forward differences of an integer observation sequence. -/
def firstDifferences : List Int → List Int
  | [] => []
  | [_] => []
  | left :: right :: rest =>
      (right - left) :: firstDifferences (right :: rest)

/-- Successive finite-difference layers, including the source observations. -/
def differenceTable : Nat → List Int → List (List Int)
  | 0, observations => [observations]
  | fuel + 1, observations =>
      observations :: differenceTable fuel (firstDifferences observations)

/-- Boolean zero-layer observation. -/
def isZeroLayer (layer : List Int) : Bool :=
  !layer.isEmpty && layer.all (fun value => value = 0)

/--
Index of the first nonempty all-zero finite-difference layer.

Law: layer zero is the observation sequence itself.
Carrier: finite integer sequence.
Admission: explicit finite difference depth.
Preserves: exact arithmetic and layer order.
Refuses: polynomial-generation theorem.
Claim ceiling: finite difference signature.
-/
def firstZeroDifferenceLayer
    (fuel : Nat) (observations : List Int) : Option Nat :=
  let layers := (differenceTable fuel observations).zipIdx.map (fun p => (p.2, p.1))
  match layers.find? (fun indexed => isZeroLayer indexed.2) with
  | none => none
  | some indexed => some indexed.1

/--
Finite polynomial-degree upper-bound proxy from a zero difference layer.

Law: a zero layer at index `k+1` reports proxy degree `k`.
Carrier: finite-difference experiment.
Admission: a zero layer was observed.
Preserves: zero-layer index.
Refuses: theorem about the unknown infinite generator.
Claim ceiling: finite degree proxy.
-/
def polynomialDegreeProxy
    (fuel : Nat) (observations : List Int) : Option Nat :=
  match firstZeroDifferenceLayer fuel observations with
  | some (layer + 1) => some layer
  | _ => none

/-- Canonical finite square observations. -/
def squareObservations : List Int := [0, 1, 4, 9, 16, 25, 36]

/-- Exact finite computation: the square observations reach a zero third-difference layer. -/
theorem square_degree_proxy_two :
    polynomialDegreeProxy 6 squareObservations = some 2 := by
  decide

end ProcInt.Playground.Experimental
