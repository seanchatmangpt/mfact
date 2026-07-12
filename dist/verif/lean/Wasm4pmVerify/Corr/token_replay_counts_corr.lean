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
-- Aeneas image          : Wasm4pmVerify.Generated.ReplayCounts
-- Rendered status        : DECLARED
import Mathlib
import ProcInt.Conformance.TokenReplay
import Wasm4pmVerify.Abs
import Wasm4pmVerify.Generated.Wasm4pmCore

open Aeneas Aeneas.Std Result ControlFlow Error Wasm4pmVerify.Generated

namespace Wasm4pmVerify.Corr

theorem token_replay_counts_corr
    (gen : Wasm4pmVerify.Generated.ReplayCounts)
    (hm : gen.missing.val ≤ gen.consumed.val)
    (hr : gen.remaining.val ≤ gen.produced.val) :
    let spec := Wasm4pmVerify.toSpec gen hm hr
    (spec.missing_le = hm) ∧
    (spec.remaining_le = hr) ∧
    (ProcInt.fitness spec =
       (1 - (gen.missing.val : ℚ) / (gen.consumed.val : ℚ)) / 2 +
         (1 - (gen.remaining.val : ℚ) / (gen.produced.val : ℚ)) / 2) ∧
    (fitness_num gen = Result.ok (core.num.U64.saturating_sub gen.consumed gen.missing)) ∧
    ((fitness_den gen = Result.ok Option.none ∨ ∃ d, fitness_den gen = Result.ok (Option.some d))) := by
  intro spec
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rfl
  · rfl
  · rfl
  · rfl
  · unfold fitness_den
    cases h : U64.checked_add gen.produced gen.remaining with
    | none => left; rfl
    | some d => right; exact ⟨d, rfl⟩

end Wasm4pmVerify.Corr
