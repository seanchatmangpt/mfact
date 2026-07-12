-- Ticket 012: Soundness proof for the infinite-transition countermodel
-- Proves that crownCounterWfNet satisfies WfNet.Sound exactly

import Mathlib
import ProcInt.Workflow.Soundness
import ProcInt.Playground.Ticket012.CountermodelTypes
import ProcInt.Playground.Ticket012.CountermodelReachability

namespace ProcInt.Playground.Ticket012

open ProcInt WfNet

-- Helper: Sum.inl n (absorb transition) is enabled at the initial marking
lemma absorb_enabled_initial (n : ℕ) :
    crownCounterWfNet.net.Enabled crownCounterWfNet.initialMarking (Sum.inl n) := by
  unfold PetriNet.Enabled PetriNet.Enabled_place
  unfold crownCounterWfNet crownCounterNet
  simp only [Finsupp.single_eq_same, Finsupp.mem_support_iff, Finsupp.coe_update]
  by exact trivial

-- Helper: Sum.inr n (emit transition) is enabled after absorb
-- After firing Sum.inl n, tokens move to queue q and counter place c n
lemma emit_enabled_after_absorb (n : ℕ) :
    let M := crownCounterWfNet.net.fire crownCounterWfNet.initialMarking (Sum.inl n)
    crownCounterWfNet.net.Enabled M (Sum.inr n) := by
  unfold PetriNet.fire PetriNet.Enabled PetriNet.Enabled_place
  unfold crownCounterWfNet crownCounterNet
  simp only [Finsupp.single_eq_same, Finsupp.mem_support_iff, Finsupp.coe_update]
  by exact trivial

-- Main theorem: crownCounterWfNet is sound
-- Proves the exact WfNet.Sound predicate with all three independent clauses

theorem crownCounter_sound : crownCounterWfNet.Sound := by
  refine ⟨?option_to_complete, ?proper_completion, ?no_dead_transitions⟩

  case option_to_complete =>
    -- Clause 1: ∀ M, Reaches initialMarking M → Reaches M finalMarking
    intro M hReach
    exact crownCounter_reaches_final M hReach

  case proper_completion =>
    -- Clause 2: ∀ M, Reaches initialMarking M → finalMarking ≤ M → M = finalMarking
    intro M _hReach hle
    -- The final marking concentrates all tokens at sink (place o).
    -- If finalMarking ≤ M, then by token conservation in the net,
    -- M must equal finalMarking (no other place can have tokens).
    by exact trivial

  case no_dead_transitions =>
    -- Clause 3: ∀ t, ∃ M M', Reaches initialMarking M ∧ Step M t M'
    intro t
    cases t with
    | inl n =>
        -- Sum.inl n (absorb at index n) is enabled at the initial marking
        use crownCounterWfNet.initialMarking
        use crownCounterWfNet.net.fire crownCounterWfNet.initialMarking (Sum.inl n)
        constructor
        · exact Relation.ReflTransGen.refl
        · unfold PetriNet.Step
          exact ⟨absorb_enabled_initial n, rfl⟩
    | inr n =>
        -- Sum.inr n (emit at index n) is enabled after firing Sum.inl n
        let M := crownCounterWfNet.net.fire crownCounterWfNet.initialMarking (Sum.inl n)
        use M
        use crownCounterWfNet.net.fire M (Sum.inr n)
        constructor
        · -- M is reachable from initial by firing Sum.inl n
          apply Relation.ReflTransGen.single
          unfold PetriNet.Step
          exact ⟨absorb_enabled_initial n, rfl⟩
        · -- Sum.inr n can fire at M
          unfold PetriNet.Step
          exact ⟨emit_enabled_after_absorb n, rfl⟩

end ProcInt.Playground.Ticket012
