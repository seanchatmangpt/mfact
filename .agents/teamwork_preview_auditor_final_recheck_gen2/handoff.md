# Handoff Report — Final Audit Re-check

## 1. Observation

- **Detached HEAD Tag Mismatch**: At checkout tag `v26.7.7-procint-certified` (`e523d74`), the committed file `release/FINAL_STATUS.md` at line 18 reads:
  ```
  TAG_COMMIT=991e89a
  ```
  However, running `git rev-parse HEAD` returns:
  ```
  e523d7458668a0430bcea6a07d8dce4e98212f28
  ```
- **just release Failure**: Running `just release` at commit `e523d74` fails with the following output:
  ```
  git diff --exit-code -- $(grep '^path = ' .mfact/artifacts.toml | cut -d'"' -f2 | grep -v 'standing.env\|artifacts.toml' | sort -u | tr '\n' ' ') || (echo "REFUSED: ARTIFACT_DRIFT_REFUSED — unreplayable edit or stale render detected above" && exit 1)
  diff --git a/release/FINAL_STATUS.md b/release/FINAL_STATUS.md
  index 73f4ce0..b6b5245 100644
  --- a/release/FINAL_STATUS.md
  +++ b/release/FINAL_STATUS.md
  @@ -15,14 +15,14 @@ CORE_TOTAL_DECLS=397
   CORE_STATED=7
   RENDERED_COMMIT=945bfca
   TAG_EXPECTED=v26.7.7-procint-certified
  -TAG_COMMIT=991e89a
  +TAG_COMMIT=e523d74
   ```
- **Standing Guard Scan on HEAD**: Running the Standing Guard scanner on HEAD (`f9b5bc9`) outputted:
  ```
  TOTAL FINDINGS: 58
  BLOCKERS: 2
  {'gap_class': 6, 'severity': 'BLOCKER', 'refusal_code': 'TAG_ANCESTRY_FAIL', 'path_or_target': 'v26.7.7-procint-certified', 'evidence': 'Tag v26.7.7-procint-certified (e523d745) is not an ancestor of HEAD or runIdentifier (945bfca5)', 'expected': 'Tag is an ancestor of HEAD and runIdentifier', 'actual': 'is_ancestor_head=False, is_ancestor_run_id=True', 'recommended_action': 'Rebase/merge HEAD onto the release tag or recreate the tag at a proper ancestor commit.', 'standing_status': 'REFUSED'}
  ```

---

## 2. Logic Chain

1. **Self-Contradictory Tag Reference**: The committed release status files (`release/FINAL_STATUS.md` and `release/final_status.json`) reference `991e89a` as the release tag commit. However, the tag `v26.7.7-procint-certified` actually points to a sibling commit `e523d74` (as observed from ref lookup).
2. **Re-rendering Causes Drift**: Because of this discrepancy, any attempt to run `just release` or `just regen-check` from a clean tag checkout will automatically recompute the tag commit as `e523d74`. This mismatches the committed value of `991e89a`, triggering `ARTIFACT_DRIFT_REFUSED` and failing the build.
3. **HEAD Ancestry Break**: The HEAD commit (`f9b5bc9`) has diverged from the tag commit (`e523d74`). As a result, the tag is no longer an ancestor of HEAD, triggering a Standing Guard blocker `TAG_ANCESTRY_FAIL`.
4. **Verifiability Fails**: Since the release cannot be built or verified from the tagged commit or HEAD without failing, the self-verifiability of the release has been violated.

---

## 3. Caveats

- We assumed that `e523d74` represents the release commit as it is the target of the `v26.7.7-procint-certified` tag.
- The `Tests` package of Lean was compiled manually to bypass an ordering bug in `build_verif.py`, but even after compiling, the release still fails due to the tag commit mismatch.

---

## 4. Conclusion

- **Verdict**: INTEGRITY VIOLATION (Reject)
- **Status**: FAILED
- The release artifacts have drifted from the actual tag commit. The tag must be recut or the status files reconstructed to point to the correct, unified commit.

---

## 5. Verification Method

To independently verify this failure:
1. Checkout the tag:
   ```bash
   git checkout v26.7.7-procint-certified
   ```
2. Discard local agent changes:
   ```bash
   git checkout -- release/standing.env
   ```
3. Run `just check` (note: it may require compiling `Tests` target manually if the lake build directory is clean, via `lake build Tests` in `procint/`).
4. Run `just release` and observe it failing with `ARTIFACT_DRIFT_REFUSED` on `release/FINAL_STATUS.md`.
