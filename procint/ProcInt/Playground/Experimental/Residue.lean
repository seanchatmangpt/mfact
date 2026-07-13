-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Closure
import Batteries.Data.List.Basic

/-!
# Finite Minimal-Antichain Residue Probe

Pipeline:
`finite obligation universe → powerset enumeration → sufficient supports → minimal supports`.

Crown law:
the executable probe searches every subsequence support of the declared finite
obligation universe and retains only supports with no sufficient proper sub-support.

Preserves:
obligation order and explicit finite universe.

Excludes:
claiming a general antichain theorem without monotonicity assumptions on `closes`.

Standing:
finite experimental residue rail.

Falsifier:
a returned support has a sufficient proper sub-support.

Downstream:
counterexample mining for residue algorithms; autonomous-resolution experiments.
-/

namespace ProcInt.Playground.Experimental

/-- Proper finite sub-supports generated from list subsequences. -/
def properSubsupports {α : Type} (support : List α) : List (List α) :=
  support.sublists.filter (fun s => s.length < support.length)

/-- Executable minimal-sufficiency predicate. -/
def minimalSupportB {α : Type}
    (closes : List α → Bool) (support : List α) : Bool :=
  closes support &&
    (properSubsupports support).all (fun smaller => !(closes smaller))

/--
Exhaustively computes minimal sufficient supports in a finite obligation universe.

Law: every returned support satisfies `minimalSupportB`.
Carrier: finite powerset/subsequence search.
Admission: universe is finite and explicit.
Preserves: source order.
Refuses: infinite-universe interpretation.
Actuation: exhaustive subsequence enumeration.
Complexity: exponential in universe length.
Claim ceiling: finite-domain residue probe.
-/
def minimalResidue {α : Type}
    (obligationUniverse : List α) (closes : List α → Bool) : List (List α) :=
  obligationUniverse.sublists.filter (minimalSupportB closes)

/-- Pairwise incomparability check for one pair of supports. -/
def incomparableB {α : Type} [DecidableEq α]
    (a b : List α) : Bool :=
  (!(subsetB a b)) && (!(subsetB b a))

/-- Executable antichain check over finite supports. -/
def antichainB {α : Type} [DecidableEq α]
    (supports : List (List α)) : Bool :=
  let indexed := supports.zipIdx.map (fun p => (p.2, p.1))
  indexed.all fun indexedA =>
    indexed.all fun indexedB =>
      if indexedA.1 = indexedB.1 then
        true
      else
        incomparableB indexedA.2 indexedB.2

/-- Finite residue report. -/
structure ResidueReport (α : Type) where
  supports : List (List α)
  antichain : Bool

/-- Manufactures a finite residue report. -/
def residueReport {α : Type} [DecidableEq α]
    (obligationUniverse : List α) (closes : List α → Bool) : ResidueReport α :=
  let supports := minimalResidue obligationUniverse closes
  {
    supports := supports
    antichain := antichainB supports
  }

end ProcInt.Playground.Experimental
