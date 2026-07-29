-- Hand-written for W4PM-LEAN-GALL-026 (not ggen-rendered — this file is a new,
-- purpose-built addition to the top-level ProcInt/ directory, following the same
-- pattern as `ProcInt/Playground.lean`/`ProcInt/Tests.lean`, NOT the Models/ ggen
-- pipeline described in AGENTS.md — no ontology entry exists for this file, so it is
-- not subject to the `ggen sync` rendering constraint that governs `Models/*.lean`.
import Mathlib
import ProcInt.Models.CausalNet

/-! # ProcInt.HeuristicMiner

Formalizes the THRESHOLD-FILTERING step of the Heuristics Miner discovery
procedure — not the `dependencyMeasure` formula itself, which is already proven
in `ProcInt.Models.CausalNet` (bounds, antisymmetry, self-zero; W4PM-LEAN-GALL-016).
Reuses `dependencyMeasure` from that file rather than redefining it.

Port target: `wasm4pm::advanced_algorithms::discover_heuristic_miner_from_log`
(`wasm4pm/src/advanced_algorithms.rs`, lines 15-72), which keeps an ordered edge
`a -> b` iff `dependencyMeasure count(a,b) count(b,a) >= dependency_threshold`.

Main result: **threshold monotonicity** — raising the discovery threshold never
adds an edge, only removes edges; the discovered edge set at a higher threshold
is a subset of the edge set at any lower threshold, for every activity alphabet
and every directly-follows count function. -/

namespace ProcInt

variable {α : Type*} [DecidableEq α]

/-- Whether the ordered pair `(a, b)` survives the Heuristics Miner's
threshold filter, given a directly-follows count function `count` (`count x y`
is `|x > y|`, the number of times `y` directly follows `x`) and a rational
threshold `t`. Port of the comparison
`(ab - ba) / (ab + ba + 1) >= dependency_threshold` in
`discover_heuristic_miner_from_log` (`advanced_algorithms.rs:59`). -/
def EdgeSurvives (count : α → α → ℕ) (t : ℚ) (a b : α) : Prop :=
  t ≤ dependencyMeasure (count a b) (count b a)

instance (count : α → α → ℕ) (t : ℚ) (a b : α) : Decidable (EdgeSurvives count t a b) :=
  inferInstanceAs (Decidable (t ≤ dependencyMeasure (count a b) (count b a)))

/-- The discovered edge set over a finite activity alphabet `acts` at threshold
`t`: all ordered pairs from `acts × acts` whose dependency measure clears the
threshold. Finite-set port of the `for (&(a, b), &count) in &follows { if ... }`
loop building `dfg.edges` in `discover_heuristic_miner_from_log`. -/
def edgeSetAt (acts : Finset α) (count : α → α → ℕ) (t : ℚ) : Finset (α × α) :=
  (acts ×ˢ acts).filter (fun p => EdgeSurvives count t p.1 p.2)

/-- **Threshold monotonicity.** Raising the dependency threshold from `t1` to a
higher (or equal) `t2` never adds an edge: the edge set discovered at `t2` is a
subset of the edge set discovered at `t1`. This is the discovery-procedure-level
theorem the task calls for — distinct from, and building on top of,
`dependencyMeasure`'s own already-proven bounds/antisymmetry/self-zero
properties in `ProcInt.Models.CausalNet`, which this file does not re-prove. -/
theorem edgeSetAt_antitone (acts : Finset α) (count : α → α → ℕ) {t1 t2 : ℚ}
    (h : t1 ≤ t2) : edgeSetAt acts count t2 ⊆ edgeSetAt acts count t1 := by
  intro p hp
  simp only [edgeSetAt, Finset.mem_filter, EdgeSurvives] at hp ⊢
  exact ⟨hp.1, le_trans h hp.2⟩

/-- Corollary, stated with an explicit strict-increase hypothesis to match the
common phrasing "a strictly higher threshold discovers no new edges": if
`t1 < t2` then every edge surviving at `t2` also survives at `t1`. -/
theorem edgeSetAt_antitone_of_lt (acts : Finset α) (count : α → α → ℕ) {t1 t2 : ℚ}
    (h : t1 < t2) : edgeSetAt acts count t2 ⊆ edgeSetAt acts count t1 :=
  edgeSetAt_antitone acts count h.le

/-- Reflexivity case, spelled out for completeness: the same threshold applied
twice discovers exactly the same edge set. -/
theorem edgeSetAt_eq_self (acts : Finset α) (count : α → α → ℕ) (t : ℚ) :
    edgeSetAt acts count t = edgeSetAt acts count t :=
  rfl

/-- **Finiteness / decidability.** For any finite activity alphabet, the
discovered edge set at any threshold is itself a finite set (a `Finset`,
computable by the `filter` above) — the discovery procedure always terminates
with a well-defined edge relation. Stated explicitly since the task lists this
as an acceptable alternative theorem; here it is a free corollary of
`edgeSetAt`'s type, not additional proof work. -/
theorem edgeSetAt_finite (acts : Finset α) (count : α → α → ℕ) (t : ℚ) :
    (edgeSetAt acts count t : Set (α × α)).Finite :=
  (edgeSetAt acts count t).finite_toSet

end ProcInt
