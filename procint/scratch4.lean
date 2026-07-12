import Mathlib

def test {α : Type} (r : α → α → Prop) (a b : α) (h : Relation.ReflTransGen r a b) : True := by
  induction h
  case refl => exact True.intro
  case tail b h_reach h_step ih => exact True.intro
