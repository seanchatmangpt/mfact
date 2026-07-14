import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

namespace ProcInt.BrokerCorrespondence

-- 1. Definition of places corresponding to Erlang broker state transitions
inductive BrokerPlace
  | idle
  | dispatched
  | actuated
  | failed
  | admitted
  | actToken
  | authToken
  deriving DecidableEq, Fintype, Repr

-- 2. Transitions corresponding to broker events
inductive BrokerTransition
  | dispatch
  | actuate_success
  | actuate_fail
  | admit
  deriving DecidableEq, Fintype, Repr

open BrokerPlace BrokerTransition

-- 3. Transition preconditions (pre-incidence multiset)
def pre : BrokerTransition → (BrokerPlace →₀ ℕ)
  | dispatch => Finsupp.single idle 1
  | actuate_success => Finsupp.single dispatched 1 + Finsupp.single actToken 1
  | actuate_fail => Finsupp.single dispatched 1 + Finsupp.single actToken 1
  | admit => Finsupp.single actuated 1 + Finsupp.single authToken 1

-- 4. Transition postconditions (post-incidence multiset)
def post : BrokerTransition → (BrokerPlace →₀ ℕ)
  | dispatch => Finsupp.single dispatched 1 + Finsupp.single actToken 1 + Finsupp.single authToken 1
  | actuate_success => Finsupp.single actuated 1
  | actuate_fail => Finsupp.single failed 1
  | admit => Finsupp.single admitted 1

-- 5. Petri Net definition
noncomputable def brokerNet : PetriNet BrokerPlace BrokerTransition := { pre := pre, post := post }

-- 6. Token Conservation Invariant definition
def lifecycleMarkingSum (M : Marking BrokerPlace) : ℕ :=
  M idle + M dispatched + M actuated + M failed + M admitted

/--
The main place-invariant theorem: every firing step in the broker net
conserves the single lifecycle token, matching Erlang's single-dispatch state constraint.
-/
theorem lifecycle_invariant_step (M M' : Marking BrokerPlace) (t : BrokerTransition)
  (h : brokerNet.Step M t M') : lifecycleMarkingSum M' = lifecycleMarkingSum M := by
  obtain ⟨hen, hfire⟩ := h
  unfold lifecycleMarkingSum
  rw [hfire]
  simp only [PetriNet.fire, Finsupp.add_apply, Finsupp.tsub_apply]
  have h_idle : (pre t) idle ≤ M idle := hen idle
  have h_dispatched : (pre t) dispatched ≤ M dispatched := hen dispatched
  have h_actuated : (pre t) actuated ≤ M actuated := hen actuated
  have h_failed : (pre t) failed ≤ M failed := hen failed
  have h_admitted : (pre t) admitted ≤ M admitted := hen admitted
  rcases t with | dispatch | actuate_success | actuate_fail | admit
  all_goals
    dsimp [pre, post, brokerNet] at *
    simp only [Finsupp.single_apply, Finsupp.add_apply] at *
    omega

end ProcInt.BrokerCorrespondence
