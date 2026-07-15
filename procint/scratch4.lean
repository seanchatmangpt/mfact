import Mathlib

def toPseudoMetricSpace {α : Type} (dist : α → α → ℝ)
  (dist_self : ∀ a, dist a a = 0)
  (dist_comm : ∀ a b, dist a b = dist b a)
  (dist_triangle : ∀ a b c, dist a c ≤ dist a b + dist b c) : PseudoMetricSpace α :=
PseudoMetricSpace.ofDist dist dist_self dist_comm dist_triangle

