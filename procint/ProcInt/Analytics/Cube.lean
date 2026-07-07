-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Analytics.Cube

Process cubes: dimensions as projections α → β, cube cells as preimages of a dimension value, and slices over value sets, with cell-subset and cell-in-slice containment laws. Ported from wasm4pm-compat process_cube.rs (ProcessCube, CubeDimension, CubeCell, CubeSlice, CubeDimensionKind). Canon: van der Aalst 2013, Process Cubes: Slicing, Dicing, Rolling Up and Drilling Down Event Data. -/

namespace ProcInt

/-- Cube dimension kinds (process_cube.rs `CubeDimensionKind`):
activity, resource, time, data attribute, object type, case attribute.
Canon: van der Aalst 2013, Process Cubes. -/
inductive CubeDimensionKind where
  | activity
  | resource
  | time
  | dataAttribute
  | objectType
  | caseAttribute
deriving DecidableEq, Repr

/-- A process cube over events α with one dimension as a projection α → β
(process_cube.rs `ProcessCube` with `CubeDimension` as projection). -/
structure ProcessCube (α β : Type*) where
  events : List α
  dim : α → β

/-- A cube cell: the preimage of a dimension value (process_cube.rs `CubeCell`). -/
def ProcessCube.cell {α β : Type*} [DecidableEq β] (c : ProcessCube α β) (v : β) : List α :=
  c.events.filter (fun e => c.dim e = v)

/-- A cube slice: events whose dimension value lies in a chosen value set
(process_cube.rs `CubeSlice`). -/
def ProcessCube.slice {α β : Type*} [DecidableEq β] (c : ProcessCube α β) (vs : List β) : List α :=
  c.events.filter (fun e => c.dim e ∈ vs)

/-- Every event in a cell is an event of the cube (cell ⊆ cube). -/
theorem cell_subset {α β : Type*} [DecidableEq β] {c : ProcessCube α β} {v : β} {e : α}
    (h : e ∈ c.cell v) : e ∈ c.events := by
  simp [ProcessCube.cell, List.mem_filter] at h
  exact h.1

/-- Every event in a cell projects to the cell's dimension value (preimage law). -/
theorem cell_dim {α β : Type*} [DecidableEq β] {c : ProcessCube α β} {v : β} {e : α}
    (h : e ∈ c.cell v) : c.dim e = v := by
  simp [ProcessCube.cell, List.mem_filter] at h
  exact h.2

/-- A cell is contained in any slice whose value set contains the cell's value
(slice ⊆ cube refinement, van der Aalst 2013). -/
theorem cell_subset_slice {α β : Type*} [DecidableEq β] {c : ProcessCube α β}
    {v : β} {vs : List β} {e : α} (h : e ∈ c.cell v) (hv : v ∈ vs) :
    e ∈ c.slice vs := by
  simp [ProcessCube.cell, List.mem_filter] at h
  simp [ProcessCube.slice, List.mem_filter]
  exact ⟨h.1, by rw [h.2]; exact hv⟩


end ProcInt
