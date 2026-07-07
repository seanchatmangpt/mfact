-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Models.Dfg

Directly-Follows Graphs: activities as nodes, frequency-weighted directly-follows relations as edges, and single-trace DFG discovery by adjacent-pair counting. Port of wasm4pm-compat dfg.rs (Dfg, DfgEdge, DfgWeight, discover_ocel_dfg); canonical source: van der Aalst, Process Mining: Data Science in Action, 2016. -/

namespace ProcInt

/-- A Directly-Follows Graph: activities of type α connected by
frequency-weighted directly-follows edges. Port of wasm4pm-compat
`dfg.rs` `Dfg`/`DfgEdge`/`DfgWeight` (van der Aalst, Process Mining, 2016). -/
structure Dfg (α : Type u) where
  edges : List (α × α × ℕ)

/-- The nodes of a DFG: every activity occurring as a source or target
of some edge, deduplicated. Port of `dfg.rs` `Dfg::nodes`. -/
def Dfg.nodes [DecidableEq α] (d : Dfg α) : List α :=
  (d.edges.map (·.1) ++ d.edges.map (·.2.1)).dedup

/-- Total observed frequency of the directly-follows relation a → b:
sum of weights over all matching edges. Port of `dfg.rs` edge lookup. -/
def Dfg.weight [DecidableEq α] (d : Dfg α) (a b : α) : ℕ :=
  (d.edges.filter (fun e => e.1 = a ∧ e.2.1 = b)).foldr (fun e acc => e.2.2 + acc) 0

/-- Discover the DFG of a single trace: each adjacent pair contributes one
edge of frequency 1. Mirrors `discover_ocel_dfg` restricted to one case
(dfg.rs, windows(2) pair counting). -/
def dfgOfTrace (t : List α) : Dfg α :=
  ⟨(t.zip t.tail).map (fun p => (p.1, p.2, 1))⟩

/-- A trace of length n yields exactly n - 1 directly-follows edges —
the adjacent-pair count law of `discover_ocel_dfg` (dfg.rs windows(2)). -/
theorem dfgOfTrace_edges_length (t : List α) :
    (dfgOfTrace t).edges.length = t.length - 1 := by
  cases t with
  | nil => rfl
  | cons a t =>
    simp [dfgOfTrace, List.length_zip]

/-- The empty trace has no directly-follows edges (dfg.rs: no windows(2)
pairs on an empty event list). -/
theorem dfgOfTrace_nil : (dfgOfTrace ([] : List ℕ)).edges = [] := rfl

/-- A DFG discovered from a trace assigns every edge frequency 1
(single-case discovery, dfg.rs edge_map initialisation). -/
theorem dfgOfTrace_freq_one (t : List α) :
    ∀ e ∈ (dfgOfTrace t).edges, e.2.2 = 1 := by
  intro e he
  simp [dfgOfTrace] at he
  obtain ⟨a, b, _, rfl⟩ := he
  rfl


end ProcInt
