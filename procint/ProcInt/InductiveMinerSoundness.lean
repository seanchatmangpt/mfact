-- Hand-written for W4PM-LEAN-GALL-026 (not ggen-rendered — new top-level addition,
-- same status as HeuristicMiner.lean: no ontology entry, not subject to the
-- Models/ ggen rendering constraint in AGENTS.md).
import Mathlib
import ProcInt.Models.ProcessTree

/-! # ProcInt.InductiveMinerSoundness

Formalizes the SEQUENCE-CUT detection criterion of the Inductive Miner discovery
algorithm (`wasm4pm::more_discovery::inductive_miner_recursive`,
`wasm4pm/src/more_discovery.rs:452-543`, `find_sequence_cut` at line 697), and
proves a soundness theorem connecting it to `ProcInt.ProcessTree.seq`'s already-
proven `language` function (`ProcInt.Models.ProcessTree`, W4PM-LEAN-GALL-015).

## Scope (stated honestly, per the task's own escape hatch)

The full Rust criterion partitions an arbitrary activity alphabet into two groups
via Kosaraju SCC condensation of the directly-follows graph, ordered by
reachability, and recurses on each group. Formalizing that full n-ary,
multi-trace, reachability-ordered criterion and proving a full language-equality
soundness theorem for it is **not attempted here** — it is out of reach for this
session (would require formalizing the SCC condensation itself as a first step).

**What IS proved**: the genuinely restricted but real 2-activity base case named
in the task brief. `SeqCutHolds log a b` holds iff `log` is nonempty and every
trace in it is exactly `[a, b]` — the simplest possible instance of "every trace,
restricted to activities in {a} ∪ {b}, has all {a}-activities before all
{b}-activities" (the general Sequence-cut criterion's defining property,
specialized to singleton groups where "restricted to" is vacuous and "before"
collapses to strict two-element ordering). The theorem below shows this
criterion holding on a log is **sound** with respect to the discovered tree:
whenever it holds, the log's trace set is *exactly* the language of
`ProcessTree.seq (ProcessTree.leaf a) (ProcessTree.leaf b)` — the tree
`inductive_miner_recursive` constructs from a 2-element Sequence cut of `{a}`,
`{b}` (each group recursing to its single-activity `leaf` base case,
`more_discovery.rs:456-458`, then wrapped in `ProcessTreeNode::sequence(...)`,
matching `ProcessTree.seq`).

**What remains open / future work** (explicitly, not silently): the n-ary case,
multi-activity groups on either side of the cut, the SCC/reachability
condensation criterion itself, and connecting this to the Rust `find_sequence_cut`
function's actual graph algorithm rather than its 2-activity special case. -/

namespace ProcInt

variable {α : Type*}

/-- The trace-level content of the Sequence-cut criterion, specialized to two
singleton activity groups `{a}` and `{b}`: the log is nonempty, and every trace
in it is exactly the two-element sequence `[a, b]` — i.e. every occurrence of
`a` precedes every occurrence of `b`, and no other activity appears. This is
the base case of `find_sequence_cut`'s criterion (`more_discovery.rs:697-...`)
that `inductive_miner_recursive` reaches when the SCC condensation of a
two-activity subset yields exactly the two singleton groups `{a}`, `{b}`
ordered `a` before `b`. -/
def SeqCutHolds (log : List (List α)) (a b : α) : Prop :=
  log ≠ [] ∧ ∀ t ∈ log, t = [a, b]

/-- The language of `seq (leaf a) (leaf b)` is exactly the singleton trace set
`{[a, b]}`. A direct consequence of `ProcessTree.language`'s `seq`/`leaf` cases
(`ProcInt.Models.ProcessTree`) — stated here as a lemma since the soundness
theorem below needs the *equality* of the singleton set, not just membership
(which `ProcessTree.mem_language_seq_leaf` already gives). -/
theorem seq_leaf_language_eq (a b : α) :
    ((ProcessTree.leaf a).seq (ProcessTree.leaf b)).language
      = ({[a, b]} : Set (List α)) := by
  ext w
  simp only [ProcessTree.language, seqLang, Set.mem_setOf_eq, Set.mem_singleton_iff]
  constructor
  · rintro ⟨u, hu, v, hv, rfl⟩
    rw [hu, hv]
    rfl
  · rintro rfl
    exact ⟨[a], rfl, [b], rfl, rfl⟩

/-- **Soundness (⊆ direction).** If the 2-activity Sequence-cut criterion
holds for a log over `{a}`, `{b}`, then every trace in the log is admitted by
the discovered tree `seq (leaf a) (leaf b)`'s language — the discovery
procedure never produces a tree that rejects one of its own input traces. -/
theorem seqCutHolds_subset_language (log : List (List α)) (a b : α)
    (h : SeqCutHolds log a b) :
    {w | w ∈ log} ⊆ ((ProcessTree.leaf a).seq (ProcessTree.leaf b)).language := by
  intro w hw
  rw [seq_leaf_language_eq]
  exact h.2 w hw

/-- **Soundness (exact match).** If the 2-activity Sequence-cut criterion holds
for a log, the log's trace set is *exactly* (not merely a subset of) the
language of the discovered tree `seq (leaf a) (leaf b)` — the strongest form of
soundness for this restricted case: no spurious traces are admitted, and no
real trace is rejected. -/
theorem seqCutHolds_traceSet_eq_language (log : List (List α)) (a b : α)
    (h : SeqCutHolds log a b) :
    {w | w ∈ log} = ((ProcessTree.leaf a).seq (ProcessTree.leaf b)).language := by
  rw [seq_leaf_language_eq]
  obtain ⟨t0, ht0⟩ : ∃ t, t ∈ log := by
    cases log with
    | nil => exact absurd rfl h.1
    | cons t ts => exact ⟨t, List.mem_cons_self⟩
  ext w
  simp only [Set.mem_setOf_eq, Set.mem_singleton_iff]
  constructor
  · exact h.2 w
  · intro hw
    have ht0' : t0 = [a, b] := h.2 t0 ht0
    rw [hw, ← ht0']
    exact ht0

end ProcInt
