-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import Aesop

/-! # ProcInt.Petri.Aesop

Custom Aesop rules for Petri Net transitions and reachability (automated proof support). -/

namespace ProcInt

attribute [aesop safe (rule_sets := [petri])] PetriNet.Enabled
attribute [aesop safe (rule_sets := [petri])] PetriNet.Step
attribute [aesop safe (rule_sets := [petri])] PetriNet.Reaches
attribute [aesop safe (rule_sets := [petri])] PetriNet.FiringSeq


end ProcInt
