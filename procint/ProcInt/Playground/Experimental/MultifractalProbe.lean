-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Replay

/-!
# Finite Multiscale Moment Probe

Pipeline:
`finite masses × q-grid → moment signatures → multiscale signatures → separation rank proxy`.

Crown law:
mass distributions with equal first moment may be separated by higher moments.

Preserves:
finite mass cells, q-grid order, and scale order.

Excludes:
classical Rényi dimension, Hausdorff spectrum, or asymptotic `τ(q)` authority.

Standing:
finite combinatorial multifractal probe.

Correspondence debt:
bridge to `ProcInt.Multifractal.PartitionFunction` is required before these finite
Nat moments inherit the real-valued measure-theoretic interpretation.

Falsifier:
the finite probe is described as a theorem about asymptotic multifractal spectra.

Downstream:
conjecture generation, scale-selection experiments, workflow mass profiling.
-/

namespace ProcInt.Playground.Experimental

/-- Finite mass cells at one experimental scale. -/
abbrev MassProfile := List Nat

/--
Integer q-moment of a finite mass profile.

Law: `M_q = Σ m_i^q`.
Carrier: finite natural-number mass cells.
Admission: `q : Nat`.
Preserves: cell multiplicity.
Refuses: negative or real q-orders.
Claim ceiling: finite moment calculation.
-/
def massMoment (q : Nat) (masses : MassProfile) : Nat :=
  masses.foldl (fun total mass => total + mass ^ q) 0

/-- Moment signature over an explicit q-grid. -/
def momentSignature (qs : List Nat) (masses : MassProfile) : List Nat :=
  qs.map (fun q => massMoment q masses)

/-- Multiscale moment field over explicit finite scale profiles. -/
def multiscaleSignature
    (qs : List Nat) (scales : List MassProfile) : List (List Nat) :=
  scales.map (momentSignature qs)

/-- Number of distinct moment signatures across scales. -/
def signatureDistinctness
    (qs : List Nat) (scales : List MassProfile) : Nat :=
  (multiscaleSignature qs scales).eraseDups.length

/-- Number of q-orders that separate two finite mass profiles. -/
def momentSeparation
    (qs : List Nat) (left right : MassProfile) : Nat :=
  (qs.filter (fun q => massMoment q left != massMoment q right)).length

/-- Finite profile of constructor counts by workflow depth. -/
def workflowMassProfile {Op Socket : Type}
    (w : Workflow Op Socket) : List Nat :=
  let rec go : Workflow Op Socket → Nat → List (Nat × Nat)
    | .socket _, depth => [(depth, 1)]
    | .atom _, depth => [(depth, 1)]
    | .seq left right, depth =>
        (depth, 1) :: (go left (depth + 1) ++ go right (depth + 1))
    | .par left right, depth =>
        (depth, 1) :: (go left (depth + 1) ++ go right (depth + 1))
    | .choice left right, depth =>
        (depth, 1) :: (go left (depth + 1) ++ go right (depth + 1))
  let depthMass := go w 0
  let maxDepth := depthMass.foldl (fun best item => Nat.max best item.1) 0
  (List.range (maxDepth + 1)).map fun depth =>
    (depthMass.filter (fun item => item.1 = depth)).length

/--
Executable conjecture: first moments do not distinguish `[2,2]` from `[1,3]`.

This theorem is exact finite arithmetic, not an asymptotic multifractal theorem.
-/
theorem equal_first_moment_example :
    massMoment 1 [2, 2] = massMoment 1 [1, 3] := by
  decide

/-- Higher moments separate the same equal-total-mass profiles. -/
theorem second_moment_separates_example :
    massMoment 2 [2, 2] ≠ massMoment 2 [1, 3] := by
  decide

end ProcInt.Playground.Experimental
