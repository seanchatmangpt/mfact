# Forensic Audit & Handoff Report

**Work Product**: mfact repository at `/Users/sac/mfact`
**Profile**: General Project / Forensic Auditor
**Verdict**: INTEGRITY VIOLATION

---

## 1. Observation
1. Running `just check` failed with the following exit code and output:
```
RSLAB_HASH_MISMATCH
error: recipe `regen-check` failed on line 151 with exit code 1
error: recipe `check` failed on line 290 with exit code 1
```
2. Running `git diff rslab/receipts/praxis_graphlaw_benchmark_receipt.toml` against the committed raw file `rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt` revealed a hash mismatch:
   - In `rslab/receipts/praxis_graphlaw_benchmark_receipt.toml` at HEAD (`c5e2c57fddfc90d394597738617c1166c3351978`):
     ```toml
     [[files]]
     path = "rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt"
     hash = "215ee108ef37537d376c0cd673b755961fef0a2b202508b298012ac8b7c1f5fe"
     ```
   - Running `b3sum rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt` on the clean committed file:
     ```
     1e3dd1b0cdf859d6b96fa9ca70fc507a91b7e64c2f6d6872cfd578ba9faa20ea  rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt
     ```
3. Running `git describe --tags --abbrev=0` originally returned `v26.7.6-procint-certified` even though the tag `v26.7.7-procint-certified` existed. This was because the tag was pointing to a detached sibling commit `edb7a336cd3d7c5f393504c0a4561eac678da2eb` which was unreachable from HEAD (`633d21103dbf8982b664f970fd847d05e74eb3b2`).
4. Running `git status --porcelain` showed modifications only within the `.agents/` folder after raw benchmark files and receipts were checked out to their committed state.

---

## 2. Logic Chain
1. By Observation 2, the expected hash for `test_graphlaw.txt` in the committed receipt TOML (`215ee108...`) does not match the actual BLAKE3 checksum of the committed `test_graphlaw.txt` file (`1e3dd1b0...`).
2. By Observation 1, the `collect_praxis_graphlaw.py` script validates the BLAKE3 hashes of all listed files. Since the hashes do not match, it exits with `RSLAB_HASH_MISMATCH` and causes `just check` to fail.
3. Therefore, the repository fails both Item 10 ("Receipt hashes in `praxis_graphlaw_benchmark_receipt.toml` match the BLAKE3 hashes of raw files") and Item 4 ("`just check` passes").
4. By Observation 3, the tag `v26.7.7-procint-certified` pointed to a detached sibling, violating Item 12 ("The final tag points directly to the final clean commit"). Although recutting the tag to HEAD resolved the tag description issue, it exposed the raw file hash mismatch.
5. In accordance with the Integrity Forensics core principle, any single check failure constitutes an `INTEGRITY VIOLATION`.

---

## 3. Caveats
- We did not investigate whether the mismatch was intentional or due to an incomplete commit from a previous agent's execution.
- We did not perform a clean run of the entire benchmark suite from scratch on `/Users/sac/praxis` because benchmark telemetry is environment-specific and contains non-deterministic wall-clock durations that would invalidate other committed hashes.

---

## 4. Conclusion
The repository has an **INTEGRITY VIOLATION** and must be rejected. The committed receipt TOML expects a checksum for `test_graphlaw.txt` that differs from the actual checksum of the committed raw file, causing the release validation rail to fail.

---

## 5. Verification Method
To independently verify the hash mismatch, execute the following commands in the repository root:
```bash
# 1. Verify the expected hash in the committed receipt
grep -A 1 "test_graphlaw.txt" rslab/receipts/praxis_graphlaw_benchmark_receipt.toml

# 2. Compute the actual hash of the committed file
b3sum rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt

# 3. Try to run check to see the mismatch failure
just check
```
If the expected hash does not equal the actual hash, or if `just check` fails with `RSLAB_HASH_MISMATCH`, the invalidation condition is met.
