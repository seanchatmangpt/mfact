import re

with open("ProcInt/Workflow/Countermodel.lean", "r") as f:
    content = f.read()

# Replace the cases blocks with safe explicit blocks
# Find all occurrences of cases p followed by bullets
old_cases = """          cases p
          · simp
          · simp
          · simp
          · rename_i m; simp; split_ifs <;> omega"""

new_cases = """          cases p
          · simp
          · simp
          · simp
          · rename_i m; simp; try split_ifs <;> try omega"""

content = content.replace(old_cases, new_cases)

# Also fix the `ext p` vs `intro p` and `dsimp` things.
# I actually already had `ext p` and `intro p` separate in my Countermodel.lean!
# Let's check if the error was in Countermodel.lean or my macro.
# The error in my lake build was:
# ProcInt/Workflow/Countermodel.lean:241:6: Tactic `apply` failed: could not unify the conclusion of `@Relation.ReflTransGen.single`
# Wait! I didn't fix `crownCounter_reaches_final` correctly!
