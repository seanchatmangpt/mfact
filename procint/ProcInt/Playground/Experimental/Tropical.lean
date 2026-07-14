-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.MultifractalProbe

/-!
# Finite Tropical Frozen-Phase Probe

Pipeline:
`max-plus matrix → tropical powers → diagonal cycle score → finite frozen-path proxy`.

Crown law:
matrix multiplication uses max-plus composition: alternative paths combine by
maximum and sequential path weights combine by addition.

Preserves:
finite graph dimension and path weight composition.

Excludes:
Perron-Frobenius spectral radius, zero-temperature limit, or planner frozen-phase
correspondence.

Standing:
finite max-plus experimental rail.

Correspondence debt:
the paper's `P13` planner-to-offspring bridge remains `UNSUPPORTED`.

Falsifier:
ordinary addition/multiplication is silently interpreted as tropical composition.

Downstream:
frozen-path conjecture mining and finite workflow pressure probes.
-/

namespace ProcInt.Playground.Experimental

/-- Max-plus scalar with an explicit negative-infinity element. -/
inductive Trop where
  | bot
  | val (value : Int)
  deriving Repr, DecidableEq, Inhabited, BEq

namespace Trop

/-- Tropical maximum. -/
def max : Trop → Trop → Trop
  | .bot, right => right
  | left, .bot => left
  | .val left, .val right => .val (Max.max left right)

/-- Tropical multiplication, implemented as addition of finite weights. -/
def plus : Trop → Trop → Trop
  | .bot, _ => .bot
  | _, .bot => .bot
  | .val left, .val right => .val (left + right)

/-- Maximum of a finite tropical list. -/
def maxList : List Trop → Trop :=
  List.foldl Trop.max .bot

end Trop

/-- Parallel map for multithreaded List processing. -/
def parMap {α β : Type} (f : α → β) (xs : List α) : List β :=
  let tasks := xs.map (fun x => Task.spawn (fun _ => f x))
  tasks.map Task.get

/-- Finite max-plus matrix represented as rows. -/
abbrev TropicalMatrix := List (List Trop)

private def tropicalAt (row : List Trop) (index : Nat) : Trop :=
  (row[index]?).getD .bot

private def column (matrix : TropicalMatrix) (index : Nat) : List Trop :=
  matrix.map (fun row => tropicalAt row index)

/-- Tropical dot product. -/
def tropicalDot (left right : List Trop) : Trop :=
  Trop.maxList (List.zipWith Trop.plus left right)

/-- Width of the first matrix row, or zero for an empty matrix. -/
def matrixWidth (matrix : TropicalMatrix) : Nat :=
  match matrix with
  | [] => 0
  | row :: _ => row.length

/--
Finite tropical matrix multiplication.

Law: `(A ⊗ B)ᵢⱼ = maxₖ (Aᵢₖ + Bₖⱼ)`.
Carrier: finite list matrices.
Admission: dimensions are interpreted by list width; missing cells behave as `⊥`.
Preserves: max-plus path composition.
Refuses: rectangular-well-formedness theorem.
Complexity: cubic in dense square matrix dimension up to list overhead.
Claim ceiling: finite executable matrix probe.
-/
def tropicalMul
    (left right : TropicalMatrix) : TropicalMatrix :=
  parMap (fun row =>
    (List.range (matrixWidth right)).map fun j =>
      tropicalDot row (column right j)
  ) left

/-- Tropical identity matrix of dimension `n`. -/
def tropicalIdentity (n : Nat) : TropicalMatrix :=
  (List.range n).map fun i =>
    (List.range n).map fun j =>
      if i = j then .val 0 else .bot

/-- Tropical matrix power. -/
def tropicalPow (matrix : TropicalMatrix) : Nat → TropicalMatrix
  | 0 => tropicalIdentity matrix.length
  | n + 1 => tropicalMul (tropicalPow matrix n) matrix

/-- Maximum diagonal weight after exactly `steps` tropical transitions. -/
def diagonalCycleScore
    (matrix : TropicalMatrix) (steps : Nat) : Trop :=
  let powered := tropicalPow matrix steps
  Trop.maxList <|
    (List.range powered.length).map fun i =>
      tropicalAt ((powered[i]?).getD []) i

/-- Finite sequence of diagonal cycle scores across a step horizon. -/
def frozenPhaseTrace
    (matrix : TropicalMatrix) (horizon : Nat) : List Trop :=
  parMap (diagonalCycleScore matrix) (List.range (horizon + 1))

end ProcInt.Playground.Experimental
