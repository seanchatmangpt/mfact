# Ticket 012: Baseline Workflow State

## Repository State at Baseline

**Date**: 2026-07-07
**Agent**: Agent 0 (Orchestrator / State Steward)
**Mission**: Verify baseline state for formalizing infinite-transition countermodel theorem

## Git State

**Branch**: `main`

**HEAD Commit**: `e329ef7cefd8d6248d773d9108f4aaaac2d89578`

**Dirty Tree**: YES

**Modified Files** (27 changed):
```
M .ggen-v2/receipt-log.jsonl
M .ggen-v2/receipt.json
M .gitignore
M .mfact/artifacts.toml
M dist/verif/lean/Wasm4pmVerify/Corr/token_replay_counts_corr.lean
M ggen.lock
M justfile
M packs/lean-math-pack/fragments/verif-status.generated.ttl
M packs/lean-math-pack/fragments/verif.ttl
M packs/lean-math-pack/ontology.ttl
M pylab/Dockerfile
M pylab/README.md
M pylab/docs/jira/26.7.7/tickets/index.md
M pylab/pyproject.toml
M pylab/tests/test_api.py
M pylab/tests/test_cli.py
M pylab/tests/test_import.py
M pylab/uv.lock
M release/verif-receipt.json
M research/verif/obligations.toml
M scripts/build_verif.py
D pylab/src/math_factory_pylab/__init__.py
D pylab/src/math_factory_pylab/api.py
D pylab/src/math_factory_pylab/cli.py
D pylab/src/math_factory_pylab/mcp_procint/__init__.py
D pylab/src/math_factory_pylab/mcp_procint/server.py
D pylab/src/math_factory_pylab/py.typed
```

**Untracked Files** (16 new):
```
?? docs/HONEST_D1_STATEMENT.md
?? paper/PAPER_SECTIONS_DRAFT.md
?? paper/PROSE_LINT_RULES_CORRESPONDENCE.md
?? paper/STEP_8_INDEX.md
?? pylab/docs/jira/26.7.7/tickets/ticket_009_mpops_cli.md
?? pylab/docs/jira/26.7.7/tickets/ticket_009_receipt.md
?? pylab/docs/jira/26.7.7/tickets/ticket_010_mpops_rename.md
?? pylab/docs/jira/26.7.7/tickets/ticket_010_receipt.md
?? pylab/src/mpops/
?? pylab/tests/test_reporting_cli.py
?? scripts/verif_assemble_pipeline.sh
?? scripts/verif_build_toolchain.sh
?? scripts/verif_materialize.sh
?? scripts/verif_negative_controls.sh
```

## Baseline Verification Results

### Build Verification

**Command**: `just build`

**Result**: ✓ SUCCESS

```
cd procint && /Users/sac/.elan/bin/lake build
Build completed successfully (8613 jobs).
cd mfact && /Users/sac/.elan/bin/lake build AxiomAudit mfact
Build completed successfully (22 jobs).
```

### Audit Verification

**Command**: `just audit`

**Result**: ✓ SUCCESS

```
cd procint && /Users/sac/.elan/bin/lake build AxiomAudit
Build completed successfully (8614 jobs).
```

### Manifest Generation

**Command**: `just manifest`

**Result**: ✓ SUCCESS

```
python3 scripts/build_manifest.py
artifacts=388 proven=197 stated=2 modules=52 foldHash=c528304f40660e304d444dd1ad2a2edbeac0d6f7c12ae3368e2577c9d38ea9e0
gates: {'sorryFree': True, 'axiomsClean': True, 'fixturesPass': True, 'evidenceComplete': True}
```

## Release Manifest State

**Release Version**: v26.7.7

**Current FoldHash**: `c528304f40660e304d444dd1ad2a2edbeac0d6f7c12ae3368e2577c9d38ea9e0`

### Artifact Counts

| Metric | Value |
|--------|-------|
| Total Artifacts | 388 |
| Proven | 197 |
| Stated (not proven) | 2 |
| Modules | 52 |

### Gates

All gates PASS:

| Gate | Status |
|------|--------|
| sorryFree | ✓ True |
| axiomsClean | ✓ True |
| fixturesPass | ✓ True |
| evidenceComplete | ✓ True |

### Crown Theorem Status

**Theorem**: `ProcInt.WfNet.sound_iff_shortCircuit_live_bounded`

**Status**: **PROVEN** ✓

Metadata from manifest:
```json
{
  "name": "ProcInt.WfNet.sound_iff_shortCircuit_live_bounded",
  "hash": "90dbe18e54d8185e62a19321c2f7c73c777622ccbfed92609acf388f2192534c",
  "axioms": ["propext", "Classical.choice", "Quot.sound"],
  "proven": true
}
```

### Stated (Non-Proven) Declarations

Two declarations remain in STATED status (formalized, not yet proven):

1. `ProcInt.BranchingProcess.isUnfoldingOf_statement`
2. `ProcInt.WfNet.sound_iff_shortCircuit_live_bounded_statement`

## Crown Rail Status

**ALIVE** ✓

**Confirmation**: Ticket 012 starts from crown rail ALIVE.

### Evidence

1. All baseline verification commands completed with exit status 0
2. All build and audit gates pass
3. Manifest generated successfully
4. Crown theorem (`WfNet.sound_iff_shortCircuit_live_bounded`) is PROVEN
5. FoldHash consistent with manifest generation
6. Repository in valid baseline state despite dirty tree (expected from prior work)

## Terminal State

**Status**: `READY`

The repository is in a valid baseline state for formalizing the infinite-transition countermodel theorem. The crown rail is ALIVE and the proof infrastructure is sound.
