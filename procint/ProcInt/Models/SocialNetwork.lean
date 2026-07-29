-- Written by hand for W4PM-LEAN-GALL-030b (not ggen-rendered — no ontology
-- entry exists yet for this cluster; a future `ggen sync` may supersede it).
import Mathlib

/-! # ProcInt.Models.SocialNetwork

Resource-perspective social-network graph construction: handover-of-work and
working-together networks, as discovered from a single trace's resource
sequence. Port of wasm4pm `social_network.rs`
(`discover_handover_network_from_log`, `discover_working_together_network_from_log`).

Both constructions are pure graph-building (no optimization, no search) —
tractable to characterize exactly by an iff-law relating edge membership to
the trace's resource sequence, which is what this file proves.
-/

namespace ProcInt

/-! ## Handover-of-work network

Port of `social_network.rs::discover_handover_network_from_log`, lines 15-58:
for a single trace's resource sequence, an edge `(r1, r2)` is emitted for
every adjacent pair of DISTINCT consecutive resources (`if r1 != r2`). -/

/-- Handover edges of a resource sequence: every adjacent pair `(a, b)` with
`a ≠ b`. Port of the `for i in 0..resources.len()-1 { if r1 != r2 { ... } }`
loop in `discover_handover_network_from_log` — `rs.zip rs.tail` is exactly
the list of consecutive pairs `(rs[i], rs[i+1])`. -/
def handoverEdges [DecidableEq α] (rs : List α) : List (α × α) :=
  (rs.zip rs.tail).filter (fun p => decide (p.1 ≠ p.2))

/-- **Handover correctness law**: `(a, b)` is a handover edge of `rs` iff `a`
and `b` are distinct AND `(a, b)` is a consecutive pair of `rs`, i.e.
`(a, b) ∈ rs.zip rs.tail` — which is itself the standard List encoding of
"`a` and `b` occur at some adjacent position `i`, `i+1`". This is the exact
edge-membership law of `discover_handover_network_from_log`. -/
theorem handoverEdges_iff [DecidableEq α] (rs : List α) (a b : α) :
    (a, b) ∈ handoverEdges rs ↔ (a, b) ∈ rs.zip rs.tail ∧ a ≠ b := by
  unfold handoverEdges
  simp [List.mem_filter]

/-- The handover network of the empty trace and of any singleton trace has
no edges (no consecutive pair exists). Matches `discover_handover_network_
from_log`'s loop bound `resources.len().saturating_sub(1)`. -/
theorem handoverEdges_nil [DecidableEq α] : handoverEdges ([] : List α) = [] := rfl

theorem handoverEdges_singleton [DecidableEq α] (a : α) : handoverEdges [a] = [] := rfl

/-- A handover edge always relates two DISTINCT resources — the `a ≠ b`
guard (`if r1 != r2`) is load-bearing, not vacuous: no resource ever hands
work over to itself in this construction. -/
theorem handoverEdges_irrefl [DecidableEq α] (rs : List α) (a : α) :
    (a, a) ∉ handoverEdges rs := by
  intro h
  rw [handoverEdges_iff] at h
  exact h.2 rfl

/-! ## Working-together network

Port of `social_network.rs::discover_working_together_network_from_log`,
lines 73-116: for a single trace, take the SET of distinct resources
appearing in it (Rust: `BTreeSet`, here: `List.dedup`), then emit an edge
for every unordered pair of two distinct resources both in that set
(Rust's `for i in 0..sorted.len() { for j in i+1..sorted.len() { ... } }`
over the sorted distinct list — every unordered pair realized exactly once). -/

/-- Working-together edges of a resource sequence: all ordered pairs `(a,
b)` with `a ≠ b` drawn from the trace's distinct-resource set. Two
resources `a`, `b` are connected iff both occur (anywhere) in `rs` and are
different — this is the SET-level invariant that `discover_working_
together_network_from_log`'s sorted-index double loop realizes; which of
`(a,b)`/`(b,a)` is emitted is an arbitrary tie-break of no semantic
consequence (the edge is symmetric), so we characterize the full ordered
relation here. -/
def workingTogetherEdges [DecidableEq α] (rs : List α) : List (α × α) :=
  (rs.dedup ×ˢ rs.dedup).filter (fun p => decide (p.1 ≠ p.2))

/-- **Working-together correctness law**: `(a, b)` is a working-together
edge of `rs` iff `a` and `b` are distinct and BOTH occur somewhere in `rs`
(co-occurrence in the same trace/case) — exactly the semantics of
`discover_working_together_network_from_log`'s per-case resource-set
all-pairs construction. -/
theorem workingTogetherEdges_iff [DecidableEq α] (rs : List α) (a b : α) :
    (a, b) ∈ workingTogetherEdges rs ↔ a ∈ rs ∧ b ∈ rs ∧ a ≠ b := by
  unfold workingTogetherEdges
  simp [List.mem_filter, List.mem_product, and_assoc]

/-- The working-together network of the empty trace has no edges (no
resource occurs, so no pair can co-occur). -/
theorem workingTogetherEdges_nil [DecidableEq α] :
    workingTogetherEdges ([] : List α) = [] := rfl

/-- A working-together edge always relates two DISTINCT resources — a
resource never "works together with itself", matching the Rust loop's
strict `j in i+1..` bound (never pairs an index with itself). -/
theorem workingTogetherEdges_irrefl [DecidableEq α] (rs : List α) (a : α) :
    (a, a) ∉ workingTogetherEdges rs := by
  intro h
  rw [workingTogetherEdges_iff] at h
  exact h.2.2 rfl

/-- A trace where every event has the same single resource produces no
working-together edges: the distinct-resource set has at most one element,
so no distinct pair can co-occur (matches the Rust double loop never
firing when `sorted.len() ≤ 1`). Restated directly from the correctness
law, without needing to compute `dedup` of a constant list. -/
theorem workingTogetherEdges_constant [DecidableEq α] (a : α) (n : ℕ) :
    workingTogetherEdges (List.replicate n a) = [] := by
  apply List.eq_nil_iff_forall_not_mem.mpr
  rintro ⟨x, y⟩ hxy
  rw [workingTogetherEdges_iff] at hxy
  obtain ⟨hx, hy, hne⟩ := hxy
  rw [List.eq_of_mem_replicate hx, List.eq_of_mem_replicate hy] at hne
  exact hne rfl

end ProcInt
