-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.Experiment

/-!
# Conjecture Geometry and Finite Experimental Design

Pipeline:
`candidate laws × finite worlds → truth signatures → observational classes → world gain`.

Crown law:
a world is information-bearing when adding it separates candidate laws that were
observationally indistinguishable on the already selected worlds.

Preserves:
candidate-law identity; world identity; exact Boolean observations.

Excludes:
Shannon information, VC dimension, statistical power, or global optimal-design claims.

Standing:
finite combinatorial geometry of executable conjectures.

Correspondence debt:
probabilistic information gain requires an admitted probability model; theorem-search
utility requires an admitted bridge from finite separation to proof-manufacturing cost.

Falsifier:
duplicate truth signatures are counted as independent semantic directions.

Downstream:
basis-vector test selection, conjecture triage, workflow-law mining.
-/

namespace ProcInt.Playground.Experimental

/--
Named executable law over a common world carrier.

Law: identity and Boolean observation travel together.
Carrier: finite conjecture family.
Admission: `law` is total on the carrier.
Preserves: candidate name.
Refuses: theorem standing by construction.
Claim ceiling: executable candidate law.
-/
structure NamedLaw (α : Type) where
  name : String
  law : α → Bool

/-- Truth signature of one law over an ordered finite world list. -/
def lawSignature {α : Type}
    (worlds : List α) (law : α → Bool) : List Bool :=
  worlds.map law

/-- Hamming distance between two Boolean signatures, truncated to their shared length. -/
def signatureHamming (left right : List Bool) : Nat :=
  ((List.zipWith (fun a b => a != b) left right).filter id).length

/-- Finite observational distance between two laws on the declared world list. -/
def lawDistance {α : Type}
    (worlds : List α) (left right : NamedLaw α) : Nat :=
  signatureHamming (lawSignature worlds left.law) (lawSignature worlds right.law)

/-- Signature of one candidate law on the selected experimental worlds. -/
def candidateSignature {α : Type}
    (selected : List α) (candidate : NamedLaw α) : List Bool :=
  selected.map candidate.law

/--
Number of observational equivalence classes induced on candidate laws.

Law: candidates with equal truth signatures occupy the same finite observational class.
Carrier: finite candidate × selected-world incidence geometry.
Admission: explicit finite lists.
Preserves: exact signatures.
Refuses: interpreting class count as linear-algebraic rank.
Claim ceiling: finite observational partition count.
-/
def observationalClassCount {α : Type}
    (selected : List α) (candidates : List (NamedLaw α)) : Nat :=
  (candidates.map (candidateSignature selected)).eraseDups.length

/--
Gain in observational class count contributed by adding one world.

Law: gain is the post-selection class count minus the current class count.
Carrier: finite experimental design.
Admission: explicit selected worlds and candidate-law family.
Preserves: candidate family.
Refuses: entropy interpretation without a probability distribution.
Claim ceiling: finite combinatorial separation gain.
-/
def worldGain {α : Type}
    (selected : List α) (candidates : List (NamedLaw α)) (world : α) : Nat :=
  observationalClassCount (world :: selected) candidates -
    observationalClassCount selected candidates

/--
Greedily selects the world with maximal finite conjecture-separation gain.

Law: strict gain improvement replaces the current best; ties preserve source order.
Carrier: finite experimental design.
Admission: candidate worlds are explicit.
Preserves: selected-world history and candidate-law family.
Refuses: global optimal-design claim.
Complexity: linear candidate-world scan times repeated finite signature construction.
Claim ceiling: greedy finite design heuristic.
-/
def chooseMaxWorldGain {α : Type}
    (selected : List α)
    (candidates : List (NamedLaw α))
    (worlds : List α) : Option α :=
  match worlds with
  | [] => none
  | first :: rest =>
      some <| rest.foldl
        (fun best candidate =>
          if worldGain selected candidates best < worldGain selected candidates candidate
          then candidate
          else best)
        first

end ProcInt.Playground.Experimental
