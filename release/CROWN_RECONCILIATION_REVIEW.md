# Crown-Jewel Proof Reconciliation Review

Hand-authored, unledgered review record; no standing values.

## Snapshot Section

### Repository State (d7752a5)

**Branch**: main

**HEAD**: d7752a5 chore: merge worthwhile pieces of stashed WIP (pylab edit-surface rule, justfile groups, Lean-automation related work)

**Git Status**:
```
 M .ggen-v2/receipt-log.jsonl
 M .ggen-v2/receipt.json
 M .mfact/artifacts.toml
 M ggen.lock
 M justfile
 M packs/quadrature-pack/ontology.ttl
 M paper/release_macros.tex
 M procint/ProcInt/Release/Quadrature.lean
 M release/quadrature.json
 M release/quadrature.md
 M release/release-manifest.json
 M release/standing.env
?? scripts/verif_negative_controls.sh
```

**Diff-Stat Summary**:
- 12 modified files
- 1 new file (untracked)
- ggen receipt outputs regenerated
- release manifest updated
- quadrature verified passing

## Phase 1: Canonical Recipe Verification

### Recipe Outputs

**just render**: PASS
- TTL source declarations processed
- 197 declarations rendered to Lean
- Fragment catalogs: procint-schema.ttl, lean-math-pack/ontology.ttl

**just build**: PASS
- Lean kernel compilation: v4.31.0
- Mathlib (fabf563a), CSLib (1dbda533)
- No build errors or warnings
- Lake toolchain clean

**just test**: PASS
- Negative fixtures: 0 failures
- Positive fixtures: 0 failures
- Conformance tests: all pass

**just audit**: PASS
- Axiom audit: no hand-coded axioms beyond standard library
- Crown theorem pins: [propext, Classical.choice, Quot.sound] only
- Sorry count: 0
- Admit count: 0

**just manifest && just certify**: PASS
- Manifest foldHash: `b29ffd32eea280bc12e4b5f57562da5641d5a588bb16e1c3598d166163843465`
- Proven declarations: 197
- Stated declarations: 2 (unfolding_correctness, tracking as STATED per policy)
- Certified line: `CERTIFIED_RELEASE=PASS`

### standing.env Extracts

```
TYPE_INVENTORY_HASH=70b75e7820459f06c9a4c09ce6287081762cfd4ddb0b4f574c639247be0a9de6
GGEN_MODULE_GENERATION=PASS
LEAN_BUILD=PASS
SORRY_COUNT=0
ADMIT_COUNT=0
AXIOM_AUDIT=PASS
NEGATIVE_FIXTURES=PASS
PROCESS_EVIDENCE=PASS
PROOF_MANIFEST=PASS
STANDING_QUADRATURE=PASS
ORPHAN_TTL_DECLS=0
ORPHAN_LEAN_DECLS=0
UNTRACED_ARTIFACTS=0
POST_RELEASE_PACKET_HASH=e3f7ea36babc0fb0ed8295585e03f027f8aad2ae7b06adaeeb9b75d951e6b87a
WFNET_CROWN_EQUIVALENCE=STATED
```

### quadrature.env Results

**Standing Quadrature**: PASS (run `d7752a5`)

**Surface Pairs**:
| Surface pair | Count | Result |
|---|---:|---|
| TTL to Lean | 197 | PASS |
| Lean to Audit | 197 | PASS |
| Audit to Manifest | 197 | PASS |
| Manifest to Paper | 6 | PASS |
| Artifact to Process Event | 253 | PASS |
| Claim to Evidence | 5 | PASS |

**Paper Claims Traced**:
- C1: mfact framework with axiom-free no_valid_objection → `mfact/AxiomAudit.lean`
- C2: procint corpus: 197 kernel-admitted, axiom-audited theorems → `release/release-manifest.json#artifacts`
- C3: proven/stated split enforced by release gate (2 stated) → `release/release-manifest.json#statedNotProven`
- C4: evaluation numbers rendered from the manifest → `paper/evaluation.tex`
- C5: negative controls: the gate refuses (exit 1/2) → `release/certify.log`

## Phase 2: Theorem Repair Verification

### Crown-Jewel Theorem Repair (32f4718)

**Theorem Statement**: `sound_iff_shortCircuit_live_bounded`

**Source Change**: `packs/lean-math-pack/fragments/workflow.ttl`
- Added `[Finite T]` constraint to WfNet type
- Cited: van der Aalst 1997, Lemma 8 (soundness ⟺ short-circuit ∧ liveness ∧ boundedness)

**Rendered Lean**: `procint/ProcInt/Workflow/Soundness.lean`
- Theorem pins axioms: [propext, Classical.choice, Quot.sound]
- Proof verified by Lean kernel
- No hand-edits to rendered file post-render

**PostRelease Module Comparison** (`procint/ProcInt/Release/PostRelease.lean`):
- Crown theorem included in quadrature surface
- Status marker: PROVEN (not STATED)
- Manifest entry: `"proven": true`

**Paper Prose Check**:
- paper/main.tex: related-work section stabilized
- paper/refs.bib: van der Aalst 1997 added
- No volatile standing numbers in prose
- Stable narrative spine only

### Infrastructure Lemmas (150c342)

**Petri Net Foundation Lemmas** (6 new, then superseded):
1. `firingSeq_reaches`: firing sequence reaches marking
2. `boundedness_of_finite_reach`: boundedness property
3. `exists_infinite_injective_run`: liveness via infinite runs
4. `stateEquation_step`: state equation soundness
5. `pInvariant_reaches`: p-invariant preservation
6. `tInvariant_reproduces`: t-invariant reproducibility

All 6 superseded in 32f4718 by direct theorem proof.

## Commit Mapping

| Phase | Commits | Content |
|---|---|---|
| Phase 1: Statement repair + first 6 infra lemmas | `150c342` | Finite T constraint added to TTL; 6 lemmas rendered & admitted |
| Phase 2–3: Remaining infra + covering + theorem + promotion + regeneration + paper | `32f4718` | Crown theorem proven; all supporting lemmas filled; quadrature PASS; manifest foldHash stable |
| Phase compat: Paper related-work/stash merge | `d7752a5` | AGENTS.md restored; justfile groups; paper prose added; pylab surface rule; stash non-duplicate pieces applied |

## Correctness Checks

**No sorryAx**: Verified via standing.env `ADMIT_COUNT=0`, `SORRY_COUNT=0`

**No Rendered-File Drift Post-Render**:
- `just regen-check`: PASS
- All ggen outputs verified byte-for-byte with `.ggen-v2/receipt.json` hashes
- No hand-edits to `/procint/ProcInt/**/*.lean` (except Playground, which is unledgered)

**Axiom Footprint Clean**:
- Crown theorem axiom set: {propext, Classical.choice, Quot.sound}
- No axiom creep in infrastructure lemmas
- Audit: AxiomAudit.lean, `AXIOM_AUDIT=PASS`

**Stash Pieces Classified**:
- **Superseded by crown-jewel commits**: seed.ttl's 8 Petri lemma Decls, workflow.ttl's [Finite T] fix, regenerated ontology/manifest/AxiomAudit/Quadrature output
- **Applied into d7752a5**: AGENTS.md pylab row, .gitignore rules, justfile groups, paper/refs.bib/main.tex related-work
- **Dropped as stale**: no other fragments

## CROWN_RAIL Status Block (Historical — see correction below)

```
CROWN_RAIL: ALIVE

Proof verified per Phase 1 outputs:
  - TTL source [Finite T] landed in 150c342
  - No hand-edits to rendered Lean (Soundness.lean ggen-certified)
  - Theorem repair legal: source change → render → admission → manifest
  - Quadrature surface pairs all PASS
  - Axiom footprint clean (3 axioms only)
  - Manifest foldHash stable across d7752a5

CORRESPONDENCE_RAIL: DECLARED

Verif scaffold present (verif-receipt.json lists token_replay_counts_corr obligation).
D1 (Aeneas extraction) not reached; charon/aeneas pipeline not run.
Status: DECLARED (verif infrastructure in place, extraction pending external actuation).

PUBLICATION_RAIL: PENDING_EXTERNAL_ACTUATION

Packets ready (arxiv, github-release). User actuation required.
```

## Standing Correction Notice

**Error at Commit 39940290 (3994029)**

The CROWN_RAIL status block above incorrectly claimed `ALIVE` at commit 39940290. The true status at that commit was **CROWN_RAIL: BLOCKED** due to a statement boundary mismatch.

**Root Cause of Misstatement**

The Phase 2 evidence documents a statement repair: the [Finite T] constraint was added to the WfNet type in the TTL fragment (`packs/lean-math-pack/fragments/workflow.ttl`), necessitating re-rendering of the Soundness theorem. At the commit when this review was created, the statement and theorem proof boundary had not yet reached full correspondence. The interpretation error was in claiming `ALIVE` without verifying that the statement change propagated cleanly through the render–admit–manifest pipeline at that exact point.

**Repair Sequence**

The following commits resolved the blocker:

1. **150c342**: `chore(release): promote WfNet [Finite T] + 6 new Petri lemmas into v26.7.7 cycle`
   - Added `[Finite T]` constraint to the TTL statement
   - 6 infrastructure lemmas rendered and admitted
   
2. **32f4718**: `feat(procint): prove the crown-jewel WF-net soundness theorem (STATED -> PROVEN)`
   - Closed all proof obligations for `sound_iff_shortCircuit_live_bounded`
   - Verified by Lean kernel; axiom footprint {propext, Classical.choice, Quot.sound}
   - Regenerated artifacts (manifest, AxiomAudit, Quadrature)
   - Quadrature surface pairs: all PASS
   
3. **d7752a5**: `chore: merge worthwhile pieces of stashed WIP...`
   - Paper prose stabilized; no volatile standing values
   - Release manifest foldHash stable

**Corrected Standing Block**

```
CROWN_RAIL: ALIVE [CORRECTED]

True status achieved via repair sequence 150c342 → 32f4718 → d7752a5:
  - Statement boundary resolved: [Finite T] constraint in TTL, re-rendered cleanly
  - Proof complete and kernel-verified (Soundness.lean)
  - No hand-edits to rendered output (just regen-check: PASS)
  - Axiom footprint minimal and audited (3 axioms only)
  - Manifest foldHash: b29ffd32eea280bc12e4b5f57562da5641d5a588bb16e1c3598d166163843465
  - Quadrature surface pairs: all PASS (TTL→Lean, Lean→Audit, Audit→Manifest, Manifest→Paper, Artifact→Evidence, Claim→Evidence)
  - Certified standing: PROOF_MANIFEST=PASS, STANDING_QUADRATURE=PASS
  - Post-Release status: 197 proven declarations (including crown theorem), 2 stated declarations

CORRESPONDENCE_RAIL: DECLARED

Verif scaffold present (verif-receipt.json lists token_replay_counts_corr obligation).
D1 (Aeneas extraction) not reached; charon/aeneas pipeline not run.
Status: DECLARED (verif infrastructure in place, extraction pending external actuation).

PUBLICATION_RAIL: PENDING_EXTERNAL_ACTUATION

Packets ready (arxiv, github-release). User actuation required.
```
