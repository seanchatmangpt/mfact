-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Conformance.Moves
import ProcInt.Conformance.Alignment
import ProcInt.Conformance.TokenReplay

/-! # ProcInt.Tests.Conformance

Executable conformance oracles (Level 1): perfect-alignment cost 0, log-only deviation cost 1, projection behavior, and Rozinat-Aalst token-replay fitness values, all checked by #guard at elaboration time. -/

namespace ProcInt

-- Oracle: a perfect alignment (all synchronous moves) has cost 0
-- (Carmona et al. 2018, fitness of perfectly fitting traces).
#guard alignmentCost ([.sync "a" 1, .sync "b" 2] : List (Move String ℕ)) == 0
-- Oracle: one log-only deviation costs exactly 1 (standard cost function).
#guard alignmentCost ([.sync "a" 1, .logOnly "x", .silentModel 3] : List (Move String ℕ)) == 1
-- Log projection drops model-only and silent moves.
#guard logProjection ([.sync "a" 1, .modelOnly 2, .logOnly "b", .silentModel 3] : List (Move String ℕ)) == ["a", "b"]

-- Token-replay perfect-fitness oracle: (4,4,0,0) has fitness 1
-- (mirrors calculate_fitness(4,4,0,0) = 1.0, Rozinat-Aalst 2008).
#guard fitness ⟨4, 4, 0, 0, by decide, by decide⟩ == 1
-- Half-fitness oracle: (4,4,2,2) has fitness 1/2.
#guard fitness ⟨4, 4, 2, 2, by decide, by decide⟩ == (1 : ℚ) / 2


end ProcInt
