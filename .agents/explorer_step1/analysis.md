# Ticket 013 and Ticket 015 Investigation Report

## Executive Summary
This report documents the current status of the repository with respect to **Ticket 013** (gap audit findings) and **Ticket 015** (reconciliation and re-certification requirements). The infinite-transition countermodel theorem has been demoted to `STATED` status, and the `countermodel_not_promoted` guard is active. The Aeneas `aeneasDecl` is successfully bound to the correct `ReplayCounts` struct. A deduplication bug in the `justfile` has been identified as the root cause of 13 duplicate blocks accumulating in `release/standing.env`. The release tag `v26.7.7-procint-certified` is currently present and aligned with HEAD, but needs to be re-cut once the Ticket 015 staged and working tree changes are committed.

---

## 1. Ticket 013 Findings & Current Status

### 1.1 Countermodel Theorem
- **Status**: The infinite-transition countermodel theorem (`ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded`) and its sorry-backed dependencies (`crownCounter_sound`, `crownCounter_not_bounded`) have been demoted to `STATED` (unproven).
- **Location**: In `packs/lean-math-pack/fragments/workflow_countermodel.ttl` (lines 114, 124, 143, 157, 193), status is declared as `"stated"`.
- **Manifest**: In `release/release-manifest.json`, the artifact is listed with `"proven": false`:
  ```json
  "name": "ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded",
  "hash": "4a1cf62ef7375314afec662b8fe53923a397fa19fb4ab0d6fd1bca6d120c72eb",
  "axioms": [],
  "proven": false
  ```
- **Standing**: In `release/standing.env`, it is correctly recorded as `WFNET_INFINITE_TRANSITION_COUNTERMODEL=STATED`.

### 1.2 AxiomAudit
- **Location**: `procint/AxiomAudit.lean`
- **Status**: The countermodel theorem and its sorry-lemmas are **not** present in `AxiomAudit.lean`. This is correct because they are `stated` (not `proven`), so they do not have a kernel-level `#print axioms` guard rendered in this file.

### 1.3 Negative Controls & Gates
- **Gates**: In `release/gates.json`, the `countermodel_not_promoted` gate is populated and evaluates to `true`.
- **Negative Control Script**: `scripts/countermodel_negative_controls.sh` is present and runs successfully. It generates a mock poisoned manifest without the countermodel theorem, attempts to claim `PROVEN` in a temporary `standing.env`, and verifies that the build/test script would reject the promotion and fall back to `STATED`.
- **Gates Script Integration**: `scripts/build_manifest.py` contains the mechanical gate check. It inspects the catalog parser results: if any of the three countermodel declarations are set to `proven`, it triggers `COUNTERMODEL_PROMOTION_REFUSED` and sets the `countermodel_not_promoted` gate to `false`.

### 1.4 Correspondence Theorems & Ledger
- **Correspondence Fragment**: Located at `packs/lean-math-pack/fragments/verif.ttl`. It defines the Pilot correspondence obligation `verif:Obl_token_replay_counts_corr`.
- **Ledger**: The manifest ledger `.mfact/artifacts.toml` lists all ledgered files, including `procint/AxiomAudit.lean` and `procint/ProcInt.lean`.

---

## 2. Aeneas `aeneasDecl` Binding Identification

### 2.1 Definition Location
- The Aeneas declaration name binding is defined in the correspondence fragment `packs/lean-math-pack/fragments/verif.ttl` at line 23:
  ```turtle
  verif:aeneasDecl "ReplayCounts" ;
  ```
- The status builder `scripts/build_verif.py` parses this field and populates it in:
  - `release/verif-receipt.json` as `"aeneasDecl": "ReplayCounts"` (line 9).
  - `research/verif/obligations.toml` as `aeneas_decl = "ReplayCounts"` (line 20).

### 2.2 Real Aeneas Declaration Name
- **Lean Output File**: `/Users/sac/wasm4pm-compat/verify/lean/Wasm4pmVerify/Generated/Wasm4pmCore.lean`
- **Declaration**:
  ```lean
  structure ReplayCounts where
    produced : Std.U64
    consumed : Std.U64
    missing : Std.U64
    remaining : Std.U64
  ```
- **Namespace**: `Wasm4pmVerify.Generated`
- **Correct Binding Name**: `ReplayCounts` (qualified as `Wasm4pmVerify.Generated.ReplayCounts`).
- **Verification**: The generated structure is imported by `dist/verif/lean/Wasm4pmVerify/Corr/token_replay_counts_corr.lean` (which is copied to `/Users/sac/wasm4pm-compat/verify/lean/Wasm4pmVerify/Corr/token_replay_counts_corr.lean`) and is type-checked against the correspondence theorem:
  ```lean
  theorem token_replay_counts_corr
      (gen : Wasm4pmVerify.Generated.ReplayCounts)
  ```
  Both the `dist` copy and the materialized `wasm4pm-compat` copy are aligned, referencing `Wasm4pmVerify.Generated.ReplayCounts`.

---

## 3. standing.env Deduplication Bug Analysis

### 3.1 Location
- The generation and modification of `release/standing.env` is handled in `justfile` under the `test` recipe (line 156) and the `manufacture-post-release` recipe (line 309).

### 3.2 Bug Description
In the `test` recipe (`justfile:156`), the script attempts to strip old keys using `grep -v`:
```bash
grep -v '^PROCINT_|^WFNET_CROWN_EQUIVALENCE=|^WFNET_INFINITE_TRANSITION_COUNTERMODEL=' release/standing.env > /tmp/se.$$ && mv /tmp/se.$$ release/standing.env
```
- **The Issue**: Standard `grep` treats `|` as a literal character rather than an alternation operator because Extended Regular Expressions (ERE) are not enabled.
- **The Consequence**: The pattern `^PROCINT_|^WFNET_CROWN_EQUIVALENCE=...` does not match the lines starting with `PROCINT_` or `WFNET_`. Therefore, no lines are removed, and new blocks of 7 lines are appended to `release/standing.env` on every run of `just test` or related release checks.
- **Current Impact**: `release/standing.env` currently contains **13 duplicate blocks** (91 duplicated lines) of the correctness ladder status.

### 3.3 Proposed Fixes
Two options exist to fix the deduplication in `justfile:156`:
1. **Enable ERE**: Add the `-E` flag to `grep`:
   ```bash
   grep -E -v '^PROCINT_|^WFNET_CROWN_EQUIVALENCE=|^WFNET_INFINITE_TRANSITION_COUNTERMODEL=' release/standing.env
   ```
2. **Multiple passes**: Pipe multiple basic `grep -v` calls:
   ```bash
   grep -v '^PROCINT_' release/standing.env | grep -v '^WFNET_CROWN_EQUIVALENCE=' | grep -v '^WFNET_INFINITE_TRANSITION_COUNTERMODEL='
   ```

---

## 4. Git Status and Tag Verification

### 4.1 Git Status
- **HEAD Commit**: `404b4c9febdd886b0e320518b14258e79980e5e9`
- **Working Tree**: Currently dirty. There are several files staged in the index (including `release-manifest.json`, `standing.env`, `verif-receipt.json`, and `scripts/build_verif.py`). 

### 4.2 Current Release Tag
- The release tag `v26.7.7-procint-certified` is present.
- It points exactly to commit `404b4c9febdd886b0e320518b14258e79980e5e9` (which is the current HEAD).
- **Ancestor Check**: `git merge-base --is-ancestor` returns `ANCESTOR` since the tag commit is equal to HEAD.

### 4.3 Re-cut Requirements
- **Need to Re-cut**: Yes. While the current tag is technically an ancestor of HEAD, it represents the state *before* the Ticket 015 staged and unstaged working tree changes.
- **Re-certification Trigger**: Once the deduplication bug is fixed in the `justfile`, the tree is cleaned, and all staged changes are committed, a new commit will be created. The tag `v26.7.7-procint-certified` must then be deleted and re-cut at that final commit to ensure it certifies the exact manifest and release hashes produced in this reconciliation cycle.
