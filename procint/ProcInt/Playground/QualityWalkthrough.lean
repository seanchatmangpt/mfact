-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-! ## Quality walkthrough

Concrete worked instances over `ProcInt.Conformance.Quality` (van der Aalst's
four quality dimensions bounded to the unit interval) and the token-replay
fitness metric of `ProcInt.Conformance.TokenReplay`, plus a couple of
citations from the 55-breed registry in `ProcInt.Registry.Breeds`. -/

/-- A concrete token-replay tally: of 8 tokens that had to be consumed, 2 were
missing (created artificially to let a transition fire); of 10 tokens
produced, 1 was left behind unconsumed. Demonstrates `ProcInt.ReplayCounts`
(Rozinat & van der Aalst 2008). -/
def qualityReplay : ReplayCounts :=
  { produced := 10
    consumed := 8
    missing := 2
    remaining := 1
    missing_le := by decide
    remaining_le := by decide }

-- The Rozinat-Aalst fitness of qualityReplay: (1/2)(1 - 2/8) + (1/2)(1 - 1/10)
-- = (1/2)(3/4) + (1/2)(9/10) = 3/8 + 9/20 = 33/40, per `ProcInt.fitness`.
#eval fitness qualityReplay

/-- The same fitness value repackaged as a `UnitRat`, via
`ProcInt.ReplayCounts.fitnessUnit`, which carries the proved Between01
bounds so an out-of-range fitness is unrepresentable. -/
def qualityFitnessUnit : UnitRat := qualityReplay.fitnessUnit

#eval qualityFitnessUnit.val

/-- A concrete `ProcInt.QualityProfile`: fitness taken from the replay above,
precision/generalization/simplicity given as separate unit-interval literals
(each discharged by `norm_num`). Demonstrates `ProcInt.QualityProfile`
(van der Aalst 2016 quality dimensions). -/
def qualityProfile : QualityProfile :=
  { fitness := qualityFitnessUnit
    precision := ⟨(9 : ℚ) / 10, by norm_num⟩
    generalization := ⟨(7 : ℚ) / 10, by norm_num⟩
    simplicity := ⟨(4 : ℚ) / 5, by norm_num⟩ }

#eval qualityProfile.fitness.val
#eval qualityProfile.precision.val

-- The perfect profile has all four dimensions equal to 1, per
-- `ProcInt.QualityProfile.perfect`.
example : QualityProfile.perfect.fitness.val = 1 := rfl

-- F1, the harmonic mean of fitness and precision (ProcInt.f1), evaluated on
-- qualityProfile's fitness (33/40) and precision (9/10): 2·(33/40)·(9/10) /
-- ((33/40) + (9/10)) = (297/200) / (69/40) = 99/115.
#eval f1 qualityProfile.fitness qualityProfile.precision

-- F1 of the perfect profile's fitness/precision (both 1) is 1, matching the
-- harmonic-mean identity 2·1·1/(1+1) = 1.
#eval f1 QualityProfile.perfect.fitness QualityProfile.perfect.precision

-- Two registry citations from `ProcInt.Registry.Breeds`: the Prolog breed
-- (Kowalski 1974, flat-term Robinson unification) and the MDP breed
-- (Bellman 1957, value iteration to the Bellman fixed point).
#eval breed_prolog.label
#eval breed_mdp.citation

end ProcInt.Playground
