-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
--
-- Warm-up targets for scripts/genetic_tactic_search.py (see
-- docs/genetic-tactic-search.md). Each `-- SEARCH_TARGET: <id>` marker
-- names a theorem whose body is a bare `sorry` — the search script splices
-- candidate tactic sequences into a scratch copy of this file in place of
-- that `sorry` and checks the result against the Lean kernel. These are
-- deliberately small and tractable; the two real open obligations in
-- research/wfnet/obligations.toml are out of scope for this search until it
-- has been validated here.
import ProcInt
import ProcInt.Playground.PetriFiringWalkthrough

namespace ProcInt.Playground.TacticSearchWarmup

open Relation (ReflTransGen)

-- SEARCH_TARGET: nat_add_comm
/-- Pure-`Nat` sanity target, independent of any `ProcInt` definitions:
addition commutes. Closable by `omega`, `simp`, or `Nat.add_comm` directly. -/
theorem warmup_nat_add_comm (a b : Nat) : a + b = b + a := by
  sorry

-- SEARCH_TARGET: list_length_append
/-- Pure-`List` sanity target: the length of an append is the sum of
lengths. Closable by `simp`. -/
theorem warmup_list_length_append (l₁ l₂ : List Nat) :
    (l₁ ++ l₂).length = l₁.length + l₂.length := by
  sorry

-- SEARCH_TARGET: reach_refl
/-- Domain-relevant target: reachability is reflexive on the request→grant
net's flow-edge relation (`ProcInt.Playground.net`, defined in
`PetriFiringWalkthrough.lean`). Closable by `exact ReflTransGen.refl` or
`aesop`. -/
theorem warmup_reach_refl :
    ReflTransGen net.FlowEdge (Sum.inl Place.requested) (Sum.inl Place.requested) := by
  sorry

end ProcInt.Playground.TacticSearchWarmup
