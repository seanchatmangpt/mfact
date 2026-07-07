-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

/-! # Playground: STRIPS/PDDL classical planning

A tiny two-step order-fulfillment plan (pack, then ship) exercising
`ProcInt.PddlAction`, `ProcInt.PddlAction.apply`, and
`ProcInt.PddlPlan.valid` (`ProcInt.Planning.Pddl`, formalizing Fikes &
Nilsson 1971 STRIPS / PDDL 3.1 sequential-plan semantics).

This formalizes the state-transition semantics that a STRIPS/PDDL planner
implements — such as `bcinr-pddl`'s own "PDDL → POWL tape" pipeline, or the
`l2p` toolkit's natural-language-to-PDDL generation (`breed_l2p`) — as a
citation only. No correspondence is proven here between this Lean model
and any specific external planner's code; per AGENTS.md, STATED semantic
descriptions never become PROVEN claims about a system by assertion. -/

namespace ProcInt.Playground

/-- The three world-state atoms of a one-order fulfillment domain. -/
inductive PlaygroundAtom where
  | ordered
  | packed
  | shipped
  deriving DecidableEq, Repr

open PlaygroundAtom

/-- `pack`: applicable once `ordered` holds; adds `packed`, deletes nothing. -/
def packAction : PddlAction PlaygroundAtom :=
  { pre := {ordered}, add := {packed}, del := ∅ }

/-- `ship`: applicable once `packed` holds; adds `shipped`, deletes nothing. -/
def shipAction : PddlAction PlaygroundAtom :=
  { pre := {packed}, add := {shipped}, del := ∅ }

/-- The two-step sequential plan: pack, then ship. -/
def fulfillmentPlan : ProcInt.PddlPlan PlaygroundAtom := [packAction, shipAction]

-- Starting from `{ordered}`, the plan reaches a state containing `shipped`.
#eval PddlPlan.validCheck ({ordered} : Finset PlaygroundAtom) {shipped} fulfillmentPlan

/-- The plan is valid (`ProcInt.PddlPlan.valid`): fully decidable since
`validCheck` is a computable `Bool`-valued fold, so `decide` closes it
without unfolding by hand. -/
example : PddlPlan.valid ({ordered} : Finset PlaygroundAtom) {shipped} fulfillmentPlan := by
  unfold PddlPlan.valid
  decide

-- Skipping `pack` and shipping directly is inapplicable: `packed` never
-- holds, so `shipAction` is never enabled from `{ordered}` alone.
#eval PddlPlan.validCheck ({ordered} : Finset PlaygroundAtom) {shipped} [shipAction]

example : ¬ PddlPlan.valid ({ordered} : Finset PlaygroundAtom) {shipped} [shipAction] := by
  unfold PddlPlan.valid
  decide

/-- Instance of `PddlAction.mem_add_mem_apply`: after `packAction` fires,
`packed` is present in the resulting state regardless of the starting
state's other contents. -/
example : PlaygroundAtom.packed ∈ PddlAction.apply ({ordered} : Finset PlaygroundAtom) packAction :=
  PddlAction.mem_add_mem_apply _ packAction (by decide)

end ProcInt.Playground
