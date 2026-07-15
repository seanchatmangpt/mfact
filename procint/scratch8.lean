import Mathlib

def toPseudoMetricSpace {α : Type} (dist : α → α → ℝ)
  (dist_self : ∀ a, dist a a = 0)
  (dist_comm : ∀ a b, dist a b = dist b a)
  (dist_triangle : ∀ a b c, dist a c ≤ dist a b + dist b c) : PseudoMetricSpace α :=
{
  dist := dist
  dist_self := dist_self
  dist_comm := dist_comm
  dist_triangle := dist_triangle
}
