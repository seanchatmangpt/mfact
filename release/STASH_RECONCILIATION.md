# Stash Reconciliation Record

Unledgered review of stashed WIP recovery and classification.

## Dangling Commit (Recovery Pointer)

**Commit Hash**: 7bc70a9a02cc3375dd3e8aae0ab9f3014333a630

This commit served as the base for stashed changes during parallel work on the crown-jewel proof campaign. The stash was created while HEAD was at `1654a9b` (three commits behind the main proof work at that time).

**Stash Base Branch**: none — the repository is in a detached-HEAD state, currently at
`1faf0bc` ("chore: regen artifacts"), with `184e3a3` ("chore: commit final post-victory
receipt and ledger artifacts") as a verified ancestor commit
(`git merge-base --is-ancestor 184e3a3 1faf0bc` succeeds). No branch named
`feat/crown-jewel-wip` exists (`git branch -a` lists only `main` and `remotes/origin/main`;
`git rev-parse --verify feat/crown-jewel-wip` fails). The crown-jewel proof-campaign work
described below was carried out and reconciled entirely on this detached HEAD; no branch
checkout is required to reproduce it.

**Creation Context**: Stash captured work-in-progress from a separate research thread that included both draft theorem statements, infrastructure lemma sketches, and paper revisions. The stash was not applied until after both the formal proof campaign (32f4718, 150c342) completed and published, at which point the non-superseded fragments were cherry-picked into d7752a5.

## Stash Hunk Classification Results

**Phase 3: Classification Outcome**

### CROWN_CAMPAIGN (Superseded by Formal Proof Work)

Files in stash that were already superseded by commits 32f4718 and 150c342:

1. **packs/lean-math-pack/fragments/seed.ttl**
   - Superseding commit: 150c342
   - Content: 8 Petri lemma declarations (infrastructure sketches)
   - Status: Byte-for-byte duplicate in rendered output; dropped from stash application

2. **packs/lean-math-pack/fragments/workflow.ttl**
   - Superseding commit: 150c342 (Finite T constraint added)
   - Content: WfNet [Finite T] type refinement
   - Status: Superseded; no hand-edits needed

3. **procint/ProcInt/Workflow/Soundness.lean** (ggen-rendered copy)
   - Superseding commit: 32f4718
   - Status: Regenerated via ggen from corrected TTL; no hand-edit conflict

4. **procint/AxiomAudit.lean, release/release-manifest.json, release/quadrature.* (all generated)**
   - Superseding commit: 32f4718
   - Status: Re-rendered via ggen; stash copy was outdated

### PAPER_RELATED_WORK (Applied in d7752a5)

Files from stash that contained stable narrative prose (no standing values) and were integrated into the final paper:

1. **paper/refs.bib**
   - Content added: Lean 4 automation infrastructure citations
     - Lean4Lean, Lean Copilot, Lean-auto, LeanExplore, mathlib4dataset
     - van der Aalst 1997 (Lemma 8 for crown theorem)
   - Status: Applied in d7752a5; prose-lint clean

2. **paper/main.tex**
   - Content added: Related-work section paragraphs
     - Lean 4 automation ecosystem context
     - LLM Lean3/4 syntax-confusion failure mode
     - mfact's untrusted-candidate stance motivation
   - Status: Applied in d7752a5; stable prose spine only (no volatile numbers)

### PYLAB_EXPLORATORY (Applied in d7752a5)

Unledgered research surface changes that restore edit-surface permission and add new recipes:

1. **AGENTS.md**
   - Content: Restored `pylab/**` edit-surface table row and unledgered-surface paragraph
   - Status: Was referenced in other locations but missing from ledger; re-added in d7752a5
   - Impact: Re-enables hand-authored Python research edits (TPOT2, pm4py, powl, ocpa, pddl-plus-parser)

2. **justfile**
   - Content added: `[group(...)]` tags for `just --list` organization
   - New recipes: pylab, tactic-search, docs-serve
   - Status: Applied in d7752a5; aids workflow

3. **.gitignore**
   - Content added: genetic-tactic-search scratch/log output exclusion
   - Status: Applied in d7752a5

### UNKNOWN (No Unclassified Fragments)

All hunks in the stash were classified as either:
- CROWN_CAMPAIGN (superseded, dropped)
- PAPER_RELATED_WORK (applied, stable prose)
- PYLAB_EXPLORATORY (applied, edit-surface)

No unclassified or ambiguous fragments remain.

## Summary

| Category | Files | Disposition | Commit |
|---|---|---|---|
| CROWN_CAMPAIGN | 4 (lemmas + generated output) | Dropped (superseded) | — |
| PAPER_RELATED_WORK | 2 (refs.bib, main.tex) | Applied | d7752a5 |
| PYLAB_EXPLORATORY | 3 (AGENTS.md, justfile, .gitignore) | Applied | d7752a5 |
| UNKNOWN | 0 | — | — |

**Total stash hunks processed**: 9 hunks
**Net result**: Non-duplicate pieces integrated; superseded duplicates discarded
**Verification**: All applied fragments appear in d7752a5 diff

## Stash Integrity Notes

- No hand-edits to generated files (`.mfact/artifacts.toml`-ledgered outputs) were applied
- All applied changes are either prose (paper) or configuration (edit-surfaces, recipes)
- Standing values were not carried over in any form
- The stash application was a one-time reconciliation; stash was not re-applied afterward
