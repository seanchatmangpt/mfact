-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Foundations.Metric
import ProcInt.Conformance.TokenReplay

/-! # ProcInt.Conformance.Quality

Quality dimensions of process models bounded to the unit interval (van der Aalst, Process Mining: Data Science in Action, 2016, quality dimensions; wasm4pm-compat docs/METRIC_LAW.md Between01 law). UnitRat is the subtype of rationals in [0,1]; QualityProfile packages fitness, precision, generalization, and simplicity as UnitRat fields so out-of-range metrics are unrepresentable; F1 is the harmonic mean of fitness and precision, proved to stay in [0,1]. Ports QualityProfile and the metric newtypes from wasm4pm-compat src/conformance.rs. -/

namespace ProcInt

/-- The value 0 as a unit-interval rational. -/
def UnitRat.zero : UnitRat := ⟨0, by norm_num⟩

/-- The value 1 as a unit-interval rational. -/
def UnitRat.one : UnitRat := ⟨1, by norm_num⟩

/-- A quality profile over van der Aalst's four process-mining quality
dimensions — fitness, precision, generalization, simplicity — each bounded to
[0,1] by construction (wasm4pm-compat docs/METRIC_LAW.md; QualityProfile in
src/conformance.rs). -/
structure QualityProfile where
  fitness : UnitRat
  precision : UnitRat
  generalization : UnitRat
  simplicity : UnitRat

/-- The perfect quality profile: all four dimensions equal to 1. -/
def QualityProfile.perfect : QualityProfile :=
  ⟨UnitRat.one, UnitRat.one, UnitRat.one, UnitRat.one⟩

/-- The token-replay fitness of any ReplayCounts, packaged as a unit-interval
rational via the proved bounds — the computed metric always satisfies the
Between01 law by construction. -/
def ReplayCounts.fitnessUnit (c : ReplayCounts) : UnitRat :=
  ⟨fitness c, fitness_nonneg c, fitness_le_one c⟩

/-- F1: the harmonic mean 2fp/(f+p) of fitness and precision (van der Aalst
quality dimensions; F1 in wasm4pm-compat src/conformance.rs). The ℚ convention
x/0 = 0 makes the f = p = 0 corner total. -/
def f1 (f p : UnitRat) : ℚ := 2 * f.val * p.val / (f.val + p.val)

/-- F1 is nonnegative. -/
theorem f1_nonneg (f p : UnitRat) : 0 ≤ f1 f p := by
  have hf := f.property.1
  have hp := p.property.1
  unfold f1
  positivity

/-- F1 is at most 1: the harmonic mean of two unit-interval quantities stays
in the unit interval (Between01 law, wasm4pm-compat docs/METRIC_LAW.md). -/
theorem f1_le_one (f p : UnitRat) : f1 f p ≤ 1 := by
  obtain ⟨hf0, hf1⟩ := f.property
  obtain ⟨hp0, hp1⟩ := p.property
  unfold f1
  rcases eq_or_lt_of_le (add_nonneg hf0 hp0) with h | h
  · rw [← h, div_zero]
    norm_num
  · rw [div_le_one h]
    nlinarith [mul_nonneg (sub_nonneg.mpr hf1) hp0, mul_nonneg (sub_nonneg.mpr hp1) hf0]


end ProcInt
