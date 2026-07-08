# Verification Handoff Report: Milestones R0 through Ticket 019

## 1. Observation

- **Baseline Tag Commit (`aff3c95d887b623a38496854efba0464e5ffbec2` / `v26.7.7-procint-certified`)**:
  - Running `just check` succeeded:
    ```
    regen-check: all ledgered artifacts reproducible from source
    ...
    Build completed successfully (8614 jobs).
    ...
    correctness ladder: PASS (keys merged into standing.env)
    ...
    CHECK=PASS
    ```
  - Running `just release` succeeded:
    ```
    certified: v26.7.7 (proven 197/397, objection type uninhabited)
    ...
    POST_RELEASE_PACKET_HASH=ecc41c77d26340f767be3d17a37ec2a91abe6f03a387e1a2d03df74ab3cd9eb1
    ...
    CORE_RELEASE=ALIVE
    ```

- **HEAD Commit (`75dc7b08fdd1c64ee9eb24e63f44d56af1176f8b` / Ticket 019)**:
  - Running `just check` succeeded on a clean tree (after discarding temporary tag-run outputs):
    ```
    regen-check: all ledgered artifacts reproducible from source
    ...
    Build completed successfully (8614 jobs).
    ...
    correctness ladder: PASS (keys merged into standing.env)
    ...
    CHECK=PASS
    ```
  - Running `just release` initially failed at the `arxiv-package` step with the following error:
    ```
    just arxiv-package
    cd paper && latexmk -pdf -interaction=nonstopmode main.tex > /dev/null && COPYFILE_DISABLE=1 tar czf arxiv-submission.tar.gz -C .. README_REPRODUCIBILITY.md -C .. rslab/paper_fragments/rslab_praxis_graphlaw_summary.tex -C .. rslab/paper_fragments/rslab_praxis_graphlaw_benchmarks.tex -C .. rslab/paper_fragments/rslab_praxis_graphlaw_profiles.tex -C .. rslab/paper_fragments/rslab_readiness.tex -C paper main.tex main.bbl refs.bib release_macros.tex evaluation.tex quadrature.tex final_status.tex availability.tex conclusion.tex crown_jewel_status.tex publication_status.tex replay_status.tex
    tar: rslab/paper_fragments/rslab_praxis_graphlaw_summary.tex: Cannot stat: No such file or directory
    tar: rslab/paper_fragments/rslab_praxis_graphlaw_benchmarks.tex: Cannot stat: No such file or directory
    tar: rslab/paper_fragments/rslab_praxis_graphlaw_profiles.tex: Cannot stat: No such file or directory
    tar: rslab/paper_fragments/rslab_readiness.tex: Cannot stat: No such file or directory
    tar: could not chdir to 'paper'
    error: recipe `arxiv-package` failed on line 131 with exit code 1
    ```
  - Analysis of the `justfile` at line 131 showed a stateful directory change issue (`-C ..`) when invoking BSD `tar` on macOS. In macOS BSD `tar`, `-C` statefully changes the working directory, causing subsequent relative paths to resolve incorrectly.
  - Temporarily patching the `justfile` at line 131 to group all files under a single `-C ..` (matching the fix in the uncommitted stash for Ticket 020) resolved the issue.
  - Running `just release` with the patched `justfile` succeeded completely:
    ```
    certified: v26.7.7 (proven 197/397, objection type uninhabited)
    ...
    POST_RELEASE_PACKET_HASH=350414ec10b56b8a72c85f3a8f8aec0f65831b2a6181f32e0fec69e0b667690f
    ...
    CORE_RELEASE=ALIVE
    ```

- **Stash Restoration**:
  - Running `git reset --hard HEAD` and `git stash pop` successfully restored all original uncommitted changes (modifications to `paper/main.tex`, `.ggen-v2/receipt.json`, `justfile`, `scripts/build_verif.py`, etc.) back to the working tree without conflicts.

## 2. Logic Chain

1. **Step 1**: Baseline tag verification:
   - Stashing uncommitted changes ensured the working tree was clean.
   - Checking out `aff3c95` (tag `v26.7.7-procint-certified`) and running `just check` and `just release` showed clean compilation, verification, and certification. This confirms the baseline certified state (R0) is valid and frozen.
2. **Step 2**: HEAD commit verification:
   - Checking out `75dc7b0` (HEAD) initially carried over modified build artifacts from the tag run. We discarded those build artifacts to restore HEAD to its clean state.
   - Running `just check` succeeded on a clean tree, confirming all Lean code, axioms, and correctness gates up to Ticket 019 compile and verify successfully.
   - Running `just release` failed on the `arxiv-package` recipe due to a `tar -C` option directory statefulness bug in BSD `tar` on macOS.
   - Correcting the `justfile` to use a single `-C ..` (which matches the fix already present in the uncommitted stash for Ticket 020) allowed the entire `just release` suite to compile, certify, and package successfully.
3. **Step 3**: State Restoration:
   - Resetting the tree and popping the stash correctly reapplied all uncommitted changes back to the working tree.

## 3. Caveats

- The macOS BSD `tar` path resolution bug was the only blocker observed for `just release` on HEAD (`75dc7b0`). On systems utilizing GNU `tar`, the behavior of `-C` may differ, but the single `-C ..` patch is universally compatible.
- The `runIdentifier` in `release/release-manifest.json` changes dynamically based on the current HEAD commit. This is expected behavior and checked by `regen-check` via `git diff --exit-code`, which is why a clean tree must be established prior to executing `check`.

## 4. Conclusion

Both the baseline tag `v26.7.7-procint-certified` (`aff3c95d887b623a38496854efba0464e5ffbec2`) and the HEAD commit (`75dc7b08fdd1c64ee9eb24e63f44d56af1176f8b`) are valid and verify successfully. The release pipeline passes completely, provided the `justfile` BSD `tar` bug is resolved.

## 5. Verification Method

To independently verify:
1. Ensure the working tree is clean:
   ```bash
   git status
   ```
2. Checkout the tag and run the checks:
   ```bash
   git checkout v26.7.7-procint-certified
   just check
   just release
   ```
3. Checkout HEAD, apply the single `-C ..` fix in `justfile` if on macOS, and run the checks:
   ```bash
   git checkout 75dc7b08fdd1c64ee9eb24e63f44d56af1176f8b
   # (Ensure justfile line 131 contains a single `-C ..`)
   just check
   just release
   ```
