import Mathlib

def test {α : Type} (r : α → α → Prop) (a b : α) (h : Relation.ReflTransGen r a b) : True := by
  induction h with
  | refl => exact True.intro
  | tail _ _ _ => exact True.intro
