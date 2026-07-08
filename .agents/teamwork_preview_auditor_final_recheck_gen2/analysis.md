# Final Audit Re-check Analysis

This report documents the forensic findings from the final independent audit of the `mfact` repository.

## Audit Summary

- **Verdict**: INTEGRITY VIOLATION
- **Reason**: The repository fails the self-verifiability and reproducibility gates. The tagged commit `v26.7.7-procint-certified` (`e523d74`) has self-contradictory status files recording `TAG_COMMIT=991e89a`, which is a sibling commit. This causes `just release` and `just regen-check` to fail due to artifact drift (`ARTIFACT_DRIFT_REFUSED`). Furthermore, the HEAD branch has diverged from the tag commit, causing tag ancestry failures.

---

## Verifications by Item

### 1. Git Status
- **Status**: CLEAN (except for `.agents/` folders)
- **Details**: Checked out tag `v26.7.7-procint-certified` (`e523d74`) is clean.

### 2. Duplicates in `release/standing.env`
- **Status**: PASS
- **Details**: Verified that no duplicate keys exist in the environment file.

### 3. Standing Guard Scan
- **Status**: FAIL
- **Details**: 
  - On HEAD (`f9b5bc9`), the scanner reports 2 blockers:
    1. `ARTIFACT_DRIFT_REFUSED` on `release/standing.env` hash mismatch.
    2. `TAG_ANCESTRY_FAIL` because the tag is not an ancestor of HEAD.
  - On the tag commit (`e523d74`), the scan reports 0 blockers, but the workspace remains self-contradictory.

### 4. `just check`
- **Status**: FAIL
- **Details**:
  - Fails on HEAD due to `paper/release_macros.tex` tag resolving to `v26.7.6-procint-certified`.
  - Passes on tag commit `e523d74` only when run after manually compiling the `Tests` target (due to a circular dependency in the build/test cycle).

### 5. `just release`
- **Status**: FAIL
- **Details**: Fails on the tag commit `e523d74` with `ARTIFACT_DRIFT_REFUSED` because the tag commit stored in the manifest is `991e89a`. Regenerating final status results in `e523d74` as the tag commit, causing a mismatch in:
  - `release/FINAL_STATUS.md` (`TAG_COMMIT` changes from `991e89a` to `e523d74`)
  - `release/final_status.json` (`tagCommit` changes from `991e89a` to `e523d74`)
  - `paper/release_macros.tex` and packaging tarball checksums (`tarball_blake3` changes)
  - `procint/ProcInt/Release/PostRelease.lean` (`postReleasePacketHash` changes)

### 6. `just regen-check`
- **Status**: FAIL
- **Details**: Fails due to the same artifact drifts on `release/FINAL_STATUS.md`, `release/final_status.json`, and release macros.

### 7. `just paper-check`
- **Status**: PASS
- **Details**: Rebuilds the LaTeX PDF cleanly and the prose-lint script returns clean.

### 8. No Handcoded Metrics in `paper/main.tex`
- **Status**: PASS
- **Details**: All empirical metrics are imported from `rslab/paper_fragments/`.

### 9. Raw `rslab` Outputs authenticity
- **Status**: PASS
- **Details**: Verified that the outputs were generated from real praxis commands (logged in `command_log.txt` and `toolchain_context.txt`).

### 10. `rslab` Receipt Hashes
- **Status**: PASS
- **Details**: The hashes in `praxis_graphlaw_benchmark_receipt.toml` match the BLAKE3 hashes of all 6 raw files exactly.

### 11. Generated LaTeX Fragments Match Results
- **Status**: PASS
- **Details**: Table metrics (e.g. `875,808,862 ns`, `916.7 μs`, and `2.9059 ms`) match the processed values in `results.json` exactly.

### 12. Final Tag `v26.7.7-procint-certified`
- **Status**: FAIL
- **Details**: 
  - The tag points to `e523d74`, which is not HEAD.
  - The files committed at `e523d74` record `991e89a` as the tag commit.
