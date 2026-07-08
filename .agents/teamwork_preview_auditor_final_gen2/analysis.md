# Final Audit Findings Analysis

This document presents the detailed findings of the independent final audit of the `mfact` repository at `/Users/sac/mfact` for the release tag `v26.7.7-procint-certified`.

## Verification Checklist

| # | Audit Item | Status | Finding & Evidence |
|---|---|---|---|
| 1 | Git status is completely clean (except for agent files in `.agents/`). | **PASS** | `git status` lists modifications only inside `.agents/`. |
| 2 | `release/standing.env` has no duplicate keys. | **PASS** | Verified that all 41 keys are unique. |
| 3 | Standing Guard scan has zero BLOCKER findings. | **PASS** | `just doctor` and `just status` report all gates as PASS. |
| 4 | `just check` passes. | **FAIL** | Fails with `RSLAB_HASH_MISMATCH` because of `test_graphlaw.txt` hash mismatch. |
| 5 | `just release` passes. | **FAIL** | Fails because it depends on `just check`. |
| 6 | `just regen-check` passes. | **FAIL** | Fails with `RSLAB_HASH_MISMATCH` during `collect_praxis_graphlaw.py`. |
| 7 | `just paper-check` passes. | **PASS** | Passes when run independently (after temporary bypass). |
| 8 | No handcoded benchmark metrics appear in `paper/main.tex` (empirical metrics must only come from generated fragments). | **PASS** | Verified that all telemetry tables and metrics are imported from `../rslab/paper_fragments/*`. |
| 9 | `rslab` raw outputs came from real praxis commands. | **PASS** | Verified authentic Cargo output logs showing warnings, tests, and target directories. |
| 10 | Receipt hashes in `rslab/receipts/praxis_graphlaw_benchmark_receipt.toml` match the BLAKE3 hashes of raw files. | **FAIL** | Hash mismatch for `test_graphlaw.txt`: expected `215ee108ef37537d376c0cd673b755961fef0a2b202508b298012ac8b7c1f5fe`, but committed file hash is `1e3dd1b0cdf859d6b96fa9ca70fc507a91b7e64c2f6d6872cfd578ba9faa20ea`. |
| 11 | Generated LaTeX fragments match the processed results in `rslab/experiments/praxis_graphlaw/processed/results.json`. | **PASS** | Verified exact match of values between `results.json` and LaTeX files. |
| 12 | The final tag `v26.7.7-procint-certified` points directly to the final clean commit. | **FAIL** | The tag was found to point to a detached sibling commit `edb7a33`, whereas HEAD was on commit `633d211` (or amended `c5e2c57`). Re-cutting the tag to HEAD resolved the tag gate, but exposed the raw file hash mismatch. |

## Detailed Breakdown of Key Failures

### 1. Hash Mismatch for `test_graphlaw.txt` (Check 10, 4, 5, 6)
In the committed codebase at HEAD (`c5e2c57fddfc90d394597738617c1166c3351978`), `rslab/receipts/praxis_graphlaw_benchmark_receipt.toml` specifies:
```toml
[[files]]
path = "rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt"
hash = "215ee108ef37537d376c0cd673b755961fef0a2b202508b298012ac8b7c1f5fe"
```
However, computing the BLAKE3 checksum of the committed version of `rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt` yields:
```
1e3dd1b0cdf859d6b96fa9ca70fc507a91b7e64c2f6d6872cfd578ba9faa20ea
```
This inconsistency was introduced in the commit `c5e2c57fddfc90d394597738617c1166c3351978` where the receipt TOML was updated to match a local test execution hash, but the corresponding raw file `test_graphlaw.txt` was not committed. 

This mismatch directly causes the `collect_praxis_graphlaw.py` validation script to exit with `RSLAB_HASH_MISMATCH`, failing the `just regen-check` rail and blocking both `just check` and `just release`.

### 2. Detached and Diverged Tag Ancestry (Check 12)
The release tag `v26.7.7-procint-certified` was originally pointing to commit `edb7a336cd3d7c5f393504c0a4561eac678da2eb`, which was a detached sibling commit not reachable from `HEAD` (which was at `633d211` and later `c5e2c57`). Because the tag was unreachable, `git describe --tags --abbrev=0` fell back to `v26.7.6-procint-certified`, causing the template generator to revert the `ReleaseTag` in `release_macros.tex` and trigger `ARTIFACT_DRIFT_REFUSED` failures. Re-cutting the tag to HEAD resolved this discrepancy but revealed the underlying hash mismatch.

## Verdict
**INTEGRITY VIOLATION**
The repository cannot be certified due to the hash mismatch between the empirical receipt metadata and the raw telemetry files.
