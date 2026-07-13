-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.MFW.Multifractal
import Std.Tactic

/-!
# Kernel-checked order-fulfillment example

The production subworkflow follows the POWL paper's dependency geometry:

* gather materials before execute production;
* schedule production before execute production;
* schedule production before notify customer.
-/

namespace ProcInt.Playground.MFW.Examples

open ProcInt.Playground.MFW

def productionActivity (i : Fin 4) : Activity :=
  match i.val with
  | 0 => { id := 0, label := "gather-production-materials", capability := "inventory" }
  | 1 => { id := 1, label := "schedule-production", capability := "planning" }
  | 2 => { id := 2, label := "execute-production", capability := "actuation" }
  | _ => { id := 3, label := "notify-customer", capability := "communication" }

def productionBefore (i j : Fin 4) : Prop :=
  (i.val = 0 ∧ j.val = 2) ∨
  (i.val = 1 ∧ j.val = 2) ∨
  (i.val = 1 ∧ j.val = 3)

def productionOrder : StrictOrder 4 where
  before := productionBefore
  decidableBefore := by
    intro i j
    unfold productionBefore
    exact inferInstance
  irrefl := by
    intro i h
    rcases h with h | h | h <;> omega
  trans := by
    intro i j k hij hjk
    rcases hij with hij | hij | hij <;>
      rcases hjk with hjk | hjk | hjk <;> omega

def productionChild (i : Fin 4) : POWL :=
  .activity (productionActivity i)

def productionWorkflow : POWL :=
  .partialOrder 4 productionChild productionOrder

theorem productionWorkflow_admitted : POWL.Admitted productionWorkflow := by
  exact .partialOrder productionChild productionOrder (by omega)
    (fun i => .activity (productionActivity i))

def admittedProduction : AdmittedPOWL :=
  { workflow := productionWorkflow, standing := productionWorkflow_admitted }

def binaryChoiceEdge : ChoiceNode 2 → ChoiceNode 2 → Prop
  | .start, .item _ => True
  | .item _, .finish => True
  | _, _ => False

def binaryChoiceGraph : ChoiceGraph 2 where
  edge := binaryChoiceEdge
  decidableEdge := by
    intro a b
    unfold binaryChoiceEdge
    cases a <;> cases b <;> exact inferInstance
  noIntoStart := by
    intro x h
    cases x <;> contradiction
  noOutFinish := by
    intro x h
    cases x <;> contradiction
  allOnRoute := by
    intro i
    constructor
    · exact .step trivial
    · exact .step trivial

def stockActivity : Activity :=
  { id := 10, label := "collect-items-from-stock", capability := "inventory" }

def fulfillmentChild (i : Fin 2) : POWL :=
  if i.val = 0 then productionWorkflow else .activity stockActivity

def fulfillmentWorkflow : POWL :=
  .choiceGraph 2 fulfillmentChild binaryChoiceGraph

theorem fulfillmentWorkflow_admitted : POWL.Admitted fulfillmentWorkflow := by
  apply POWL.Admitted.choiceGraph fulfillmentChild binaryChoiceGraph (by omega)
  intro i
  unfold fulfillmentChild
  split
  · exact productionWorkflow_admitted
  · exact .activity stockActivity

def admittedFulfillment : AdmittedPOWL :=
  { workflow := fulfillmentWorkflow, standing := fulfillmentWorkflow_admitted }

def productionMass : RegionProfile where
  regionId := 1
  scale := 2
  totalWork := 40
  criticalSpan := 25
  reachWeight := 8
  expectedVisits := 1
  spanLeWork := by omega

/--
Shared proof shape for a finite `Concurrent` check on `productionOrder`: refute
both directions of `productionBefore`'s three-way disjunction by `omega` on the
underlying `Fin 4` values. Every concrete-pair example below is one
instantiation of this same script — named once here instead of copy-pasted at
each call site (the original package repeated this verbatim across two files
for the `(0, 1)` case alone).
-/
macro "prod_concurrent_tac" : tactic =>
  `(tactic| (refine ⟨by decide, ?_, ?_⟩ <;> intro h <;> rcases h with h | h | h <;> omega))

example : Concurrent productionOrder (0 : Fin 4) (1 : Fin 4) := by prod_concurrent_tac

example : Concurrent productionOrder (0 : Fin 4) (3 : Fin 4) := by prod_concurrent_tac

/-- Negative companion to the two checks above: a directly-ordered pair is not
concurrent. -/
example : ¬ Concurrent productionOrder (0 : Fin 4) (2 : Fin 4) := by
  intro h
  exact h.2.1 (Or.inl ⟨rfl, rfl⟩)

example : productionMass.structuralMass = 15 := by decide

example : productionMass.expectedMass = 120 := by decide

example : (arrazoDeployment admittedFulfillment).workflow = fulfillmentWorkflow := rfl

/-- Proven Arrazo routing table for the four production activities — kernel-
checked in place of the original package's `Main.lean`, which only printed
these values via `IO.println` without asserting them. -/
example : arrazoRoute (productionActivity 0) = .rust "rust-worker" := rfl

example : arrazoRoute (productionActivity 1) = .erlang "otp@workflow" := rfl

example : arrazoRoute (productionActivity 2) = .wasm "wasm4pm" := rfl

example : arrazoRoute (productionActivity 3) = .atomVM "edge@atomvm" := rfl

end ProcInt.Playground.MFW.Examples
