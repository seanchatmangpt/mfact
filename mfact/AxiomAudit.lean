import Mfact

/-! # Axiom audit — mfact package

Machine-checked evidence that the headline results rest only on the
trusted axiom set `[propext, Classical.choice, Quot.sound]` and contain
no `sorryAx` (transitively). The build breaks if any audited declaration
picks up an unexpected axiom. -/

/-- info: 'Mfact.no_valid_objection' does not depend on any axioms -/
#guard_msgs in #print axioms Mfact.no_valid_objection

/-- info: 'Mfact.admit_ok_faithful' does not depend on any axioms -/
#guard_msgs in #print axioms Mfact.admit_ok_faithful

/-- info: 'Mfact.admit_refuses_of_uncovered' depends on axioms: [propext] -/
#guard_msgs in #print axioms Mfact.admit_refuses_of_uncovered

/-- info: 'Mfact.Manifest.proven_le_total' depends on axioms: [propext] -/
#guard_msgs in #print axioms Mfact.Manifest.proven_le_total
