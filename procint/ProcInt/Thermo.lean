import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace Thermo

/-- A thermodynamic state. -/
structure State where
  U : ℝ -- Internal energy
  S : ℝ -- Entropy

/-- The Helmholtz free energy of a state at a given temperature. -/
noncomputable def helmholtz (state : State) (T : ℝ) : ℝ :=
  state.U - T * state.S

/-- A process from state S to state G. -/
structure Process (S G : State) where
  W : ℝ -- Work done by the system
  Q : ℝ -- Heat absorbed by the system
  T : ℝ -- Temperature of the environment
  T_pos : T > 0
  first_law : G.U - S.U = Q - W
  second_law : Q ≤ T * (G.S - S.S)

/-- The true thermodynamic process-work functional F(S,G) 
    representing the maximum extractable work between state S and state G. -/
noncomputable def F (S G : State) (T : ℝ) : ℝ :=
  helmholtz S T - helmholtz G T

/-- The work done in any process is bounded by the process-work functional. -/
theorem work_bounds {S G : State} (p : Process S G) :
    p.W ≤ F S G p.T := by
  have h1 : p.Q ≤ p.T * (G.S - S.S) := p.second_law
  have h2 : G.U - S.U = p.Q - p.W := p.first_law
  unfold F helmholtz
  linarith

end Thermo
