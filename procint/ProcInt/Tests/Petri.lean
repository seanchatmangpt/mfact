-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

/-! # ProcInt.Tests.Petri

Petri-net oracles (Level 1, proof-style since markings are Finsupp and hence noncomputable): the one-place-one-transition sequence net — enabledness at the initial marking and the token-moving firing equation. -/

namespace ProcInt

/-- Simple-sequence oracle net: one transition consuming from place 0 and
producing into place 1 (the smallest nontrivial Petri net, Murata 1989 Fig. 1
family). -/
noncomputable def seqNet : PetriNet (Fin 2) (Fin 1) :=
  { pre := fun _ => Finsupp.single 0 1, post := fun _ => Finsupp.single 1 1 }

-- The single transition is enabled at the initial marking [p0].
example : seqNet.Enabled (Finsupp.single 0 1) 0 := by
  unfold PetriNet.Enabled seqNet; exact le_refl _
-- Firing moves the token: fire [p0] t = [p1].
example : seqNet.fire (Finsupp.single 0 1) 0 = Finsupp.single 1 1 := by
  unfold PetriNet.fire seqNet
  simp


end ProcInt
