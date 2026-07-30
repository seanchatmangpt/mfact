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

/-! ## Multi-trace log aggregation

W4PM-LEAN-GALL-023: wasm4pm's real `discover_dfg_from_log`
(`wasm4pm/src/discovery.rs`, lines ~28-75) aggregates directly-follows edge
counts across an entire event *log* (a `List (List α)` of traces), not a
single trace: it accumulates `edge_counts : BTreeMap<(u32,u32), usize>` over
every trace's adjacent pairs, and separately tallies `start_activities`/
`end_activities` frequency maps keyed by each trace's first/last activity.
`dfgOfTrace` (above) only ever models one trace, matching the 009 ledger's
"single-trace, unweighted" gap note for the `dfg` row. The definitions and
theorems below close that gap on the Lean side: they model multi-trace
aggregation as a genuine append-and-count operation over `dfgOfTrace`, not
mere concatenation. -/

/-- Merge two DFGs' edge lists by literal list append. This is the
"raw" combination step — it does NOT itself aggregate a repeated
`(a, b)` pair spanning both sides into one summed-frequency edge;
`Dfg.weight` (already defined above) performs that aggregation via its
`filter`/`foldr` sum, exactly mirroring wasm4pm's `BTreeMap` accumulation
by key. Appending first, weighing second, is what lets `dfgOfLog_weight_eq_sum`
below state the real aggregation law without needing a second, redundant
normalization pass baked into the merge itself. -/
def Dfg.append (d₁ d₂ : Dfg α) : Dfg α :=
  ⟨d₁.edges ++ d₂.edges⟩

/-- Discover the DFG of an entire event log: fold `dfgOfTrace` over every
trace and append the results. This is the multi-trace counterpart of
`dfgOfTrace`, matching `discover_dfg_from_log`'s loop over
`col.trace_offsets` (`discovery.rs:41-61`), which visits every trace and
accumulates directly-follows pairs into one shared `edge_counts` map. -/
def dfgOfLog (log : List (List α)) : Dfg α :=
  (log.map dfgOfTrace).foldr Dfg.append ⟨[]⟩

/-- The empty log (no traces at all) yields the empty DFG — the base case
of `discover_dfg_from_log`'s fold, where `col.trace_offsets` has no
trace-spanning windows to visit. -/
theorem dfgOfLog_nil : (dfgOfLog ([] : List (List α))).edges = [] := rfl

/-- A singleton log (exactly one trace) reduces `dfgOfLog` back to plain
`dfgOfTrace` on that trace — the multi-trace definition specializes to the
existing single-trace one exactly when there is only one case, matching
`discover_dfg_from_log` on a one-trace `AdmittedEventLog`. This is the
consistency theorem connecting the new aggregation definition to the
already-proven single-trace `dfgOfTrace` lemmas above. -/
theorem dfgOfLog_singleton (t : List α) :
    (dfgOfLog [t]).edges = (dfgOfTrace t).edges := by
  show (Dfg.append (dfgOfTrace t) (dfgOfLog ([] : List (List α)))).edges
      = (dfgOfTrace t).edges
  simp [Dfg.append, dfgOfLog]

/-- Generic fact about `List.foldr` with an additive accumulator over the
`(α × α × ℕ)` carrier `Dfg.weight` folds over: folding
`fun e acc => e.2.2 + acc` from a starting value `z` equals the sum of
every edge's frequency component, plus `z`. This is what makes
`Dfg.weight`'s `foldr`-based sum a genuine additive aggregator rather than
an opaque fold — the fact `dfgOfLog_weight_eq_sum` below relies on. -/
private theorem foldr_add_offset (l : List (α × α × ℕ)) (z : ℕ) :
    l.foldr (fun e acc => e.2.2 + acc) z = (l.map (fun e => e.2.2)).sum + z := by
  induction l with
  | nil => simp
  | cons e l ih =>
    simp only [List.foldr_cons, List.map_cons, List.sum_cons]
    rw [ih]
    omega

/-- Appending two DFGs' edge lists (via `Dfg.append`) makes `Dfg.weight`
additive: the combined weight of `a → b` across the merge is exactly the
sum of each side's own weight. This is the aggregation law underlying
`discover_dfg_from_log`'s `BTreeMap` accumulation
(`*edge_counts.entry((from,to)).or_default() += 1`, `discovery.rs:50-53`)
applied one trace at a time — a directly-follows pair's total count across
several traces is the sum of its count within each trace. -/
theorem Dfg.append_weight [DecidableEq α] (d₁ d₂ : Dfg α) (a b : α) :
    (d₁.append d₂).weight a b = d₁.weight a b + d₂.weight a b := by
  simp only [Dfg.weight, Dfg.append, List.filter_append, List.foldr_append,
    foldr_add_offset]
  ring

/-- The aggregated weight `dfgOfLog` assigns to a directly-follows pair
`(a, b)` across a whole log is exactly the sum, over every trace in the
log, of that pair's frequency within the single-trace DFG of each trace —
the real content of wasm4pm's `BTreeMap` accumulation summed across every
trace's inner loop, restated on the Lean carrier via `Dfg.weight` and the
additivity law `Dfg.append_weight` above. Combined with `dfgOfLog_singleton`,
this closes the 009 ledger's "Rust aggregates multi-trace with counts ...
not modeled" gap for the `dfg` row: a multi-trace log's per-pair weight is
now a real, proven sum over the log's traces, not left unmodeled. -/
theorem dfgOfLog_weight_eq_sum [DecidableEq α] (log : List (List α)) (a b : α) :
    (dfgOfLog log).weight a b =
      (log.map (fun t => (dfgOfTrace t).weight a b)).sum := by
  induction log with
  | nil => rfl
  | cons t ts ih =>
    show (Dfg.append (dfgOfTrace t) (dfgOfLog ts)).weight a b
        = (dfgOfTrace t).weight a b + (ts.map (fun s => (dfgOfTrace s).weight a b)).sum
    rw [Dfg.append_weight, ih]

/-- The activity that begins a trace, if the trace is nonempty. Port of
`discover_dfg_from_log`'s `col.vocab[col.events[start]]` lookup
(`discovery.rs:55-57`), which reads the first event of each nonempty
trace's column-window. -/
def traceStart (t : List α) : Option α :=
  t.head?

/-- The activity that ends a trace, if the trace is nonempty. Port of
`discover_dfg_from_log`'s `col.vocab[col.events[end-1]]` lookup
(`discovery.rs:58-60`), the last event of each nonempty trace's window. -/
def traceEnd (t : List α) : Option α :=
  t.getLast?

/-- Start-activity frequency map over a log: how many traces in the log
begin with a given activity `a`. Models wasm4pm's `start_activities`
`BTreeMap<String, usize>` in `DFG` (`discover_dfg_from_log`,
`discovery.rs:55-57`), which increments one counter per trace at the
trace's first activity. Empty traces contribute no start (matching
`col.trace_offsets` skipping `start >= end`, `discovery.rs:44-46`). -/
def startActivities [DecidableEq α] (log : List (List α)) (a : α) : ℕ :=
  (log.filterMap traceStart).count a

/-- End-activity frequency map over a log, dual to `startActivities`.
Models wasm4pm's `end_activities` map (`discovery.rs:58-60`). -/
def endActivities [DecidableEq α] (log : List (List α)) (a : α) : ℕ :=
  (log.filterMap traceEnd).count a

/-- The empty log's start-activity count is 0 for every activity — no
traces means no trace-starts to tally, matching `discover_dfg_from_log`'s
loop over zero trace windows. -/
theorem startActivities_nil [DecidableEq α] (a : α) :
    startActivities ([] : List (List α)) a = 0 := rfl

/-- A singleton log of one nonempty trace `a :: rest` has start-activity
count exactly 1 for its own first activity `a` — the base case connecting
`startActivities` to a single trace's actual first element, mirroring
`discover_dfg_from_log` incrementing `start_activities[a]` by exactly one
for a one-trace log beginning with `a`. -/
theorem startActivities_singleton_self [DecidableEq α] (a : α) (rest : List α) :
    startActivities [a :: rest] a = 1 := by
  simp [startActivities, traceStart]

/-- Dual to `startActivities_singleton_self`: a singleton log of one
nonempty trace `rest ++ [a]` has end-activity count exactly 1 for its own
last activity `a`, mirroring `discover_dfg_from_log` incrementing
`end_activities[a]` by exactly one for a one-trace log ending in `a`. -/
theorem endActivities_singleton_self [DecidableEq α] (a : α) (rest : List α) :
    endActivities [rest ++ [a]] a = 1 := by
  simp [endActivities, traceEnd]


end ProcInt
