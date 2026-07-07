-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

/-! # Playground: token-replay fitness on a worked example

A worked instance of `ProcInt.fitness` (`ProcInt.Conformance.TokenReplay`),
the Rozinat–van der Aalst token-replay conformance metric. This is the
number a conformance-checking pipeline reports for one (model, log) replay:
given how many tokens were produced/consumed during replay and how many had
to be invented (`missing`) or were left over (`remaining`), `fitness`
scores the replay in `[0, 1]`.

See `ProcInt.ReplayCounts` and `ProcInt.fitness` for the ledgered
definitions and their soundness proofs (`fitness_mem_unitInterval`,
`fitness_perfect`). This file only instantiates them on concrete numbers. -/

namespace ProcInt.Playground

/-- A replay where the log mostly matches the model: 10 tokens produced,
8 consumed, 1 had to be invented (`missing`), 2 were left over
(`remaining`). Proof fields discharge by `decide` on these literals. -/
def sampleReplay : ReplayCounts where
  produced := 10
  consumed := 8
  missing := 1
  remaining := 2
  missing_le := by decide
  remaining_le := by decide

#eval fitness sampleReplay

/-- `fitness` on `sampleReplay` works out to (1/2)(1 - 1/8) + (1/2)(1 - 2/10)
= 7/16 + 2/5 = 67/80. -/
example : fitness sampleReplay = 67 / 80 := by
  unfold fitness sampleReplay
  norm_num

/-- A perfect replay — the log exactly matches the model, so nothing is
missing or left over — always scores 1, by the ledgered `fitness_perfect`. -/
def perfectReplay : ReplayCounts where
  produced := 4
  consumed := 4
  missing := 0
  remaining := 0
  missing_le := by decide
  remaining_le := by decide

example : fitness perfectReplay = 1 :=
  fitness_perfect perfectReplay rfl rfl

end ProcInt.Playground
