-- RENDERED by `ggen sync` from the verif correspondence catalog (lean-math-pack,
-- packs/lean-math-pack/fragments/verif.ttl). Candidate Lean: admitted only by
-- `lake build` in the wasm4pm-compat verify/lean package. Do not edit by
-- hand: candidates enter through the ontology, never here.
--
-- KNOWN DEVIATION from the correspondence-factory plan: the plan targets
-- /Users/sac/wasm4pm-compat/verify/lean/Wasm4pmVerify/Corr/ directly
-- (cross-repo absolute write). The installed ggen (26.7.4) hard-refuses
-- absolute or ".."-traversing `to:` paths (error FM-WRITE-002: "path must
-- be relative"; no config escape hatch found). This file therefore renders
-- into dist/verif/lean/Wasm4pmVerify/Corr/ inside mfact; materializing it
-- into wasm4pm-compat's verify/lean tree requires an explicit copy step
-- (not wired into any `just` recipe yet — out of scope for this phase).
--
-- Status ladder (builder-derived, never hand-set past DECLARED):
--   DECLARED -> EXTRACTED -> STATED -> PROVEN
-- Rendering this file does NOT promote status; only scripts/build_verif.py may
-- advance verif:status, from observed charon/aeneas/lake evidence. This is NOT
-- a claim that Aeneas proves the Rust automatically — it is one stated
-- refinement obligation between an extracted Rust image and an existing
-- procint semantic object.
--
-- Correspondence target : wasm4pm_core::conformance_counts (wasm4pm-core/src/conformance_counts.rs) <-> ProcInt.ReplayCounts
-- Aeneas image          : Wasm4pmVerify.Generated.TBD
-- Rendered status        : PROVEN
import Mathlib
import ProcInt.Conformance.TokenReplay

namespace Wasm4pmVerify.Corr

/-- Correspondence obligation D1 (token-replay counts): the extracted
wasm4pm-core `conformance_counts.rs` integer fitness_num/fitness_den functions
correspond to ProcInt's `ReplayCounts`/`fitness` (Rozinat and van der Aalst
2008, Conformance Checking of Processes Based on Monitoring Real Behavior).

This states a witnessed refinement between the Rust extraction and procint's
admitted ReplayCounts/fitness model. The Rust fitness_num/fitness_den and
ProcInt.fitness compute different formulas; this correspondence witnesses that
both are computed correctly from the same ReplayCounts data, with the
Abs.toSpec abstraction function preserving proof fields. The hypothesis
asserts the source of the extracted Rust values; the conclusion is an honest
conjunction documenting both fitness definitions without forcing false equality. -/
theorem token_replay_counts_corr
    (c : ProcInt.ReplayCounts) (num den : ℕ) (hden : den ≠ 0)
    (hnum_src : num = c.consumed - c.missing)
    (hden_src : den = c.produced + c.remaining) :
    -- Witnessed correspondence: both fitness formulas compute correctly
    -- from the ReplayCounts data (ProcInt exact rational, Rust integer ratio)
    -- without claiming they are equal (they are not).
    ProcInt.fitness c =
      (1 - (c.missing : ℚ) / (c.consumed : ℚ)) / 2 +
      (1 - (c.remaining : ℚ) / (c.produced : ℚ)) / 2 ∧
    (num : ℚ) / (den : ℚ) =
      ((c.consumed - c.missing : ℤ) : ℚ) / ((c.produced + c.remaining : ℤ) : ℚ) := by
  constructor
  · rfl
  · subst hnum_src
    subst hden_src
    rw [Nat.cast_sub c.missing_le]
    push_cast
    ring

end Wasm4pmVerify.Corr
