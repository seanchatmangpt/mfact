## 2026-07-07T23:54:25Z

<USER_REQUEST>
Your identity: teamwork_preview_worker (worker_m3).
Your working directory is: /Users/sac/mfact/.agents/worker_m3.

Your task is to implement Milestone 3: Fix Ticket 013 Certification Gaps and verify everything passes.

Please follow these steps in order:

1. Update `pylab/src/mpops/standing_guard/server.py`:
   In `check_orphan_artifacts`, skip `paper/main.tex` to avoid false positives (since `main.tex` is hand-authored and not a generated artifact):
   ```python
   if rel_str == "paper/main.tex":
       continue
   ```

2. Update `packs/lean-math-pack/templates/corr_module.lean.tmpl`:
   Add the two necessary imports to the top of the template:
   ```lean
   import Mathlib
   import ProcInt.Conformance.TokenReplay
   import Wasm4pmVerify.Abs
   import Wasm4pmVerify.Generated
   ```

3. Update `packs/lean-math-pack/fragments/verif.ttl`:
   - Change `verif:aeneasDecl "TBD" ;` to `verif:aeneasDecl "ReplayCounts" ;`
   - Rewrite the `verif:obligationStatement` to use our new 5-conjunct theorem and proof. Use this exact code:
   ```ttl
     verif:obligationStatement """theorem token_replay_counts_corr
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
       ((fitness_den gen = Result.ok None ∨ ∃ d, fitness_den gen = Result.ok (Some d))) := by
     intro spec
     refine ⟨?_, ?_, ?_, ?_, ?_⟩
     · rfl
     · rfl
     · rfl
     · rfl
     · unfold fitness_den
       simp only [Bind.bind, Pure.pure]
       cases h : U64.checked_add gen.produced gen.remaining with
       | none => left; rfl
       | some d => right; exact ⟨d, rfl⟩""" ;
   ```

4. Update `scripts/build_manifest.py`:
   Add the `countermodel_not_promoted` guard checking that the countermodel theorem and dependencies are not status "proven". If any are proven, log "COUNTERMODEL_PROMOTION_REFUSED" and make sure the guard is False. Include:
   ```python
   # Check if countermodel or dependencies are promoted to proven
   deps = [
       'ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded',
       'ProcInt.crownCounter_sound',
       'ProcInt.crownCounter_not_bounded',
   ]
   countermodel_promoted = False
   for d in decls:
       if d['name'] in deps and d['status'] == 'proven':
           countermodel_promoted = True

   if countermodel_promoted:
       print("COUNTERMODEL_PROMOTION_REFUSED: Countermodel must remain STATED")

   gates = {
       'sorryFree': True,
       'axiomsClean': True,
       'fixturesPass': True,
       'evidenceComplete': all(bool(d['auditMsg']) for d in decls
                               if d['status'] == 'proven'
                               and d['kind'] not in ('example', 'guard')),
       'countermodel_not_promoted': not countermodel_promoted,
   }
   ```

5. Update `scripts/build_ledger.py`:
   Add the three generated files (`release/verif-receipt.json`, `release/replay_report.json`, `release/docs_report.json`) to the explicit list of ledgered artifacts at the bottom:
   ```python
       ('release/verif-receipt.json', 'scripts/build_verif.py',
        ['packs/lean-math-pack/fragments/verif.ttl']),
       ('release/replay_report.json', 'scripts/independent_replay.sh',
        ['release/release-manifest.json']),
       ('release/docs_report.json', 'scripts/build_docs.sh',
        ['release/release-manifest.json']),
   ```

6. Update `justfile`:
   In the `regen-check:` recipe, run `python3 scripts/build_verif.py` before `cat`:
   ```just
   regen-check:
       python3 scripts/build_verif.py > /dev/null
       cat packs/lean-math-pack/fragments/*.ttl > packs/lean-math-pack/ontology.ttl
       python3 scripts/build_quadrature.py > /dev/null
       rm -f ggen.lock
       ggen sync run > /dev/null
       python3 scripts/build_ledger.py > /dev/null
       git diff --exit-code -- $(grep '^path = ' .mfact/artifacts.toml | cut -d'"' -f2 | grep -v 'standing.env\|artifacts.toml' | sort -u | tr '\n' ' ') || (echo "REFUSED: ARTIFACT_DRIFT_REFUSED — unreplayable edit or stale render detected above" && exit 1)
       @echo "regen-check: all ledgered artifacts reproducible from source"
   ```

7. Git track all new/modified files to prepare for checks:
   Run:
   `git add PROJECT.md pylab/src/mpops/standing_guard/ pylab/tests/test_standing_guard.py`

8. Run the build & verification commands in order:
   - `just render`
   - `just verif-materialize`
   - `just verif-lake-build`
   - `just verif-status`
   - `just build`
   - `just audit`
   - `just manifest`
   - `just eval-tex`
   - `just standing-quadrature`
   - `just test`
   - `just check`
   - `just release`

9. Run the Standing Guard scan (`uv run python -m mpops.standing_guard.server` or via python call) and verify that it reports ZERO blockers. Save the final scan results to `/Users/sac/mfact/.agents/worker_m3/final_scan_results.json`.

10. Report back with the paths of modified files, commands run, build results, and the final scan results.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

</USER_REQUEST>
