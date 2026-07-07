-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

/-! # Petri net reachability walkthrough

A tiny two-place, two-transition Petri net (`P = Bool`, `T = Bool`) whose
single token cycles between the two places. Instantiates
`ProcInt.PetriNet` (Net.lean), the firing rule (Firing.lean), the
state equation (StateEquation.lean), place invariants (Invariants.lean),
and firing-sequence reachability (Reachability.lean). -/

namespace ProcInt.Playground

/-- Transition `true` moves the token from place `true` to place `false`;
transition `false` moves it back. Demonstrates `ProcInt.PetriNet`. -/
noncomputable def cycleNet : PetriNet Bool Bool where
  pre  := fun t => if t then Finsupp.single true 1 else Finsupp.single false 1
  post := fun t => if t then Finsupp.single false 1 else Finsupp.single true 1

/-- Initial marking: one token at place `true`, none at `false`. -/
noncomputable def m0 : Marking Bool := Finsupp.single true 1

/-- Marking after firing transition `true`: the token sits at `false`. -/
noncomputable def m1 : Marking Bool := Finsupp.single false 1

/-- Firing transition `true` at `m0` yields `m1`
(`ProcInt.PetriNet.Step`, Firing.lean). -/
theorem step1 : cycleNet.Step m0 true m1 := by
  constructor
  · show cycleNet.pre true ≤ m0
    simp [cycleNet, m0]
  · show m1 = cycleNet.fire m0 true
    ext p
    fin_cases p <;> simp [PetriNet.fire, cycleNet, m0, m1]

/-- Firing transition `false` at `m1` yields `m0` again
(`ProcInt.PetriNet.Step`, Firing.lean). -/
theorem step2 : cycleNet.Step m1 false m0 := by
  constructor
  · show cycleNet.pre false ≤ m1
    simp [cycleNet, m1]
  · show m0 = cycleNet.fire m1 false
    ext p
    fin_cases p <;> simp [PetriNet.fire, cycleNet, m0, m1]

/-- The firing sequence `[true, false]` takes `m0` back to `m0`
(`ProcInt.PetriNet.FiringSeq`, Reachability.lean). -/
def fseq : cycleNet.FiringSeq m0 [true, false] m0 :=
  .cons step1 (.cons step2 (.nil m0))

/-- `m0` is reachable from `m0` via the above cycle
(`ProcInt.PetriNet.firingSeq_reaches`, Reachability.lean). -/
theorem reaches_m0_m0 : cycleNet.Reaches m0 m0 :=
  PetriNet.firingSeq_reaches fseq

/-- Murata's state equation for the single firing `m0 —true→ m1`
(`ProcInt.PetriNet.stateEquation_step`, StateEquation.lean). -/
theorem stateEq_step1 :
    Marking.toInt m1 = Marking.toInt m0 + cycleNet.change true :=
  PetriNet.stateEquation_step cycleNet step1

/-- The constant weighting `1` is a P-invariant of `cycleNet`: firing either
transition moves one token between places, so the weighted total token
count never changes (`ProcInt.PetriNet.IsPInvariant`, Invariants.lean). -/
theorem constWeighting_isPInvariant :
    cycleNet.IsPInvariant (fun _ => (1 : ℤ)) := by
  intro t
  fin_cases t <;>
    simp [weighSum, cycleNet, PetriNet.change, Finsupp.sum_sub_index, Finsupp.sum_single_index]

/-- The firing sequence `[true, false]` is a T-invariant of `cycleNet`: its
incidence columns cancel, since the token returns to its starting place
(`ProcInt.PetriNet.IsTInvariantSeq`, Invariants.lean). -/
theorem cycleSeq_isTInvariant : cycleNet.IsTInvariantSeq [true, false] := by
  show cycleNet.change true + (cycleNet.change false + 0) = 0
  ext p
  fin_cases p <;> simp [PetriNet.change, cycleNet]

/-- Murata's Theorem 16 (reproduction) applied to the cycle: since its
Parikh vector is a T-invariant, firing `[true, false]` from `m0` reproduces
`m0` exactly (`ProcInt.PetriNet.tInvariant_reproduces`, Invariants.lean). -/
theorem cycle_reproduces_m0 :
    (m0 : Marking Bool) = m0 :=
  PetriNet.tInvariant_reproduces cycleNet fseq cycleSeq_isTInvariant

end ProcInt.Playground
