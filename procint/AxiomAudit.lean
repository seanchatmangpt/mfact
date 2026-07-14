-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
import ProcInt

/-! # Axiom audit — procint package

Machine-checked evidence that every declaration recorded as `proven` in the
procint ontology rests only on the trusted axiom set
`[propext, Classical.choice, Quot.sound]` and carries no transitive
`sorryAx`. The build breaks on any drift between ontology and kernel. -/

/-- info: ProcInt.fhe_firing_equivalence : propext -/
#guard_msgs in #print axioms ProcInt.fhe_firing_equivalence


