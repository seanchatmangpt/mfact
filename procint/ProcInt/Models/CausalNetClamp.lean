-- Hand-written (NOT ggen-rendered): characterizes the clamp-then-rescale
-- transformation wasm4pm applies to `dependencyMeasure` before storing it as
-- `CausalRelation.strength`. Companion to `CausalNet.lean`, not a replacement
-- for it -- `dependencyMeasure` itself is untouched.
import Mathlib
import ProcInt.Models.CausalNet

/-! # ProcInt.Models.CausalNetClamp

`wasm4pm`'s `build_causal_heuristic` (`wasm4pm/src/causal_graph.rs`) does not store the
signed `dependencyMeasure` directly. For each ordered pair `(a, b)` it computes
`strength = max(dependencyMeasure(ab, ba), 0)`, then rescales by `* 1000.0` and casts to
`usize` before optionally keeping the relation if `strength >= threshold`. The clamp step
runs before the rescale/cast and is the step that breaks `dependencyMeasure_antisymm`
(W4PM-LEAN-GALL-016's finding): the antisymmetric signed pair `(dependencyMeasure ab ba,
dependencyMeasure ba ab)` collapses to `(max(x,0), max(-x,0))`, which is no longer an
antisymmetric pair (both are ≥ 0).

This file states precisely what *is* still true of that collapsed pair, rather than
pretending the lost antisymmetry can be recovered. -/

namespace ProcInt

/-- The clamped measure wasm4pm actually stores (pre-rescale): `dependencyMeasure`
composed with clamp-to-nonnegative. Port of the `.max(0.0)` call in
`build_causal_heuristic` (`causal_graph.rs`), applied to the ℚ-valued signed measure
before wasm4pm's own separate `* 1000.0` cast to `usize`. -/
def clampedMeasure (ab ba : ℕ) : ℚ :=
  max (dependencyMeasure ab ba) 0

/-- The clamp never produces a negative value: `clampedMeasure` lands in `[0, 1)`,
inheriting `dependencyMeasure`'s upper bound (`dependencyMeasure_lt_one`). -/
theorem clampedMeasure_nonneg (ab ba : ℕ) : 0 ≤ clampedMeasure ab ba := by
  unfold clampedMeasure
  exact le_max_right _ _

theorem clampedMeasure_lt_one (ab ba : ℕ) : clampedMeasure ab ba < 1 := by
  unfold clampedMeasure
  exact max_lt (dependencyMeasure_lt_one ab ba) one_pos

/-- What is preserved through the clamp, exactly: the sum of the two clamped
directions recovers the magnitude of the original signed measure. This is the
precise sense in which the clamp is "lossy but not destructive of everything" --
querying *both* `clampedMeasure ab ba` and `clampedMeasure ba ab` together still
determines `|dependencyMeasure ab ba|`, even though neither value alone carries a
sign. Follows from `dependencyMeasure_antisymm` and `max(x,0) + max(-x,0) = |x|`. -/
theorem clampedMeasure_add_swap_eq_abs (ab ba : ℕ) :
    clampedMeasure ab ba + clampedMeasure ba ab = |dependencyMeasure ab ba| := by
  unfold clampedMeasure
  have hswap : dependencyMeasure ba ab = - dependencyMeasure ab ba :=
    dependencyMeasure_antisymm ba ab
  rw [hswap]
  rcases le_total 0 (dependencyMeasure ab ba) with h | h
  · rw [max_eq_left h, max_eq_right (by linarith), abs_of_nonneg h]
    ring
  · rw [max_eq_right h, max_eq_left (by linarith), abs_of_nonpos h]
    ring

/-- What is lost through the clamp, exactly: the two clamped directions can never
both be strictly positive. This is the formal counterpart of wasm4pm's real
behaviour -- for any ordered pair, at most one of the two `CausalRelation`
entries `(a,b)` / `(b,a)` can clear a positive `threshold` in
`build_causal_heuristic`, because the other direction's clamped value is
provably `0`. The direction that *does* survive is recoverable only by which
side is nonzero, never from magnitude comparison of two positive numbers --
there is no case where wasm4pm's output set contains two positive strengths
for the same unordered pair. -/
theorem clampedMeasure_mul_swap_eq_zero (ab ba : ℕ) :
    clampedMeasure ab ba * clampedMeasure ba ab = 0 := by
  unfold clampedMeasure
  have hswap : dependencyMeasure ba ab = - dependencyMeasure ab ba :=
    dependencyMeasure_antisymm ba ab
  rw [hswap]
  rcases le_total 0 (dependencyMeasure ab ba) with h | h
  · rw [max_eq_right (by linarith : - dependencyMeasure ab ba ≤ 0)]
    ring
  · rw [max_eq_right h]
    ring

/-- Symmetric counts clamp to zero on both sides (special case of both theorems
above at `x = 0`): a self-pair contributes nothing to either direction, matching
`dependencyMeasure_self`. -/
theorem clampedMeasure_self (n : ℕ) : clampedMeasure n n = 0 := by
  unfold clampedMeasure
  rw [dependencyMeasure_self]
  simp

end ProcInt
