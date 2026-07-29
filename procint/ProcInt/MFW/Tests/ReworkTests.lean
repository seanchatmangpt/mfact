import ProcInt.MFW.Rework

namespace ProcInt.MFW.Tests

open ProcInt.MFW

-- Witness pair: `hasL1Loop` is discriminating, not a tautology or contradiction.
example : hasL1Loop ([1, 1, 2] : List Nat) = true := by decide
example : hasL1Loop ([1, 2, 3] : List Nat) = false := by decide

-- `hasL2Loop` fires on an `a,b,a` triple, and correctly does NOT fire on an
-- `a,a,a` triple (that is an L1 loop, tested separately — the Rust doc
-- comment "Excludes length-1 loops" is exercised here, not just asserted).
example : hasL2Loop ([1, 2, 1] : List Nat) = true := by decide
example : hasL2Loop ([1, 2, 3] : List Nat) = false := by decide
example : hasL2Loop ([1, 1, 1] : List Nat) = false := by decide

example : hasRework ([1, 2, 3, 4] : List Nat) = false := by decide
example : hasRework ([1, 2, 1, 3] : List Nat) = true := by decide

-- No custom axioms and no `sorry`: only the two standard trusted kernel
-- axioms (`propext`, `Quot.sound`) that essentially every nontrivial Lean
-- proof depends on.
#print axioms ProcInt.MFW.hasL1Loop_iff

end ProcInt.MFW.Tests
