# Ticket 013 — v26.7.7 Release Gap Audit

## Standing

`DECLARED` — this ticket documents findings and approved remediation
decisions; none of the fixes below have been executed yet.

## Source

Five parallel read-only Explore audits run 2026-07-07 against
`/Users/sac/mfact` (and `/Users/sac/wasm4pm-compat` for the correspondence
rail), immediately before a planned v26.7.7 release cut. Each audited a
distinct rail. Findings below are organized by rail, each tagged
BLOCKER / WARN / INFO with evidence paths, followed by the three
remediation decisions the user approved.

---

## Rail 1 — Release / Certification

Kernel-level gates are green (`sorryFree`, `axiomsClean`, `fixturesPass`,
`evidenceComplete` all true; `certify.log` reports `certified: v26.7.7
(proven 197/388)`; quadrature `STANDING_QUADRATURE=PASS`). But the release
is not cleanly cuttable:

- **BLOCKER** — `release/final_status.json`:
  `RENDERED_COMMIT_IS_ANCESTOR_OF_TAG=FAIL`. The certified tag
  `v26.7.7-procint-certified` points at commit `6f4c370`, but rendering has
  since happened at `3994029` and current HEAD `e329ef7` — neither is an
  ancestor of the tag. The frozen tag does not certify what's on disk now.
- **BLOCKER** — `just regen-check` (justfile:139) would REFUSE as-is: two
  ledgered Lean sources (`procint/ProcInt.lean`, `procint/AxiomAudit.lean`)
  are modified in the working tree, so its `git diff --exit-code` fails.
  `just check`/`just release` both start with `regen-check` and cannot pass.
- **BLOCKER** — `.mfact/artifacts.toml` ledger hash drift on 3 files vs
  on-disk b3sum: `procint/AxiomAudit.lean`, `procint/ProcInt.lean`, and
  `paper/correspondence_status.tex` (ledger `1b24c0cf…` vs disk `5864b9d4…`
  — see Rail 4 for why this one is a double blind spot).
- **BLOCKER** — the committed `release/verif-receipt.json` still records
  the D1 obligation as `DECLARED`/unproven; the `PROVEN` flip only exists in
  the uncommitted working tree. The paper's correspondence claim depends on
  state that isn't yet part of the certified record.
- **WARN** — `release/release-manifest.json` `runIdentifier` changed
  (`3994029`→`e329ef7`) but is uncommitted; `release/quadrature.json` still
  carries the stale `run_identifier="3994029"`.
- **WARN** — `release/standing.env` header still says "release v26.7.6" and
  predates the latest verif/quadrature regen; `regen-check` explicitly
  excludes `standing.env` and `artifacts.toml` from its drift check, so this
  staleness is invisible to the lock.
- **WARN** — `release/final_status.json`: `github_push` publication packet
  = BLOCKED (arxiv_upload/github_release are ALIVE).
- **INFO** — branch is 7 commits ahead of `origin/main`, unpushed.

## Rail 2 — D1 Correspondence

- **BLOCKER** — Materialized copy in `wasm4pm-compat/verify/lean/...
  /Corr/token_replay_counts_corr.lean` still carries a stale
  `-- Rendered status : STATED` header comment vs mfact's
  `dist/verif/lean/.../token_replay_counts_corr.lean` which says
  `PROVEN`. `just verif-materialize` was not re-run after the final render.
- **BLOCKER** — `wasm4pm-compat/verify/` is entirely untracked in git and
  not covered by `.gitignore`, including a 7.5 GB `verify/lean/.lake` build
  directory (mathlib + aeneas packages). A naive `git add` would commit the
  whole build tree.
- **BLOCKER** — Negative controls have no run receipt anywhere. The
  `verif-negative-controls` recipe exists but is not chained into
  `verif-pipeline`, and no log proves the three controls (a/b/c) were ever
  executed and refused correctly.
- **BLOCKER (deepest)** — The PROVEN theorem
  (`Corr/token_replay_counts_corr.lean`) does **not** import or reference
  `Wasm4pmVerify.Generated.Wasm4pmCore` or `Wasm4pmVerify.Abs.toSpec`. It
  quantifies only over `ProcInt.ReplayCounts` and plain `ℕ` — the
  Aeneas-extracted image and abstraction function are built and
  type-checked but never used by the theorem. The file header still reads
  `Aeneas image : Wasm4pmVerify.Generated.TBD`, and
  `release/verif-receipt.json` literally has `aeneasDecl: "TBD"`. The
  correspondence claim ("Rust extraction ↔ ProcInt spec") is currently
  asserted via hypothesis naming and prose, not machine-bound.
- **WARN** — Several stale prep docs inside `wasm4pm-compat/verify/`
  (`STEP3_PREPARATION_STATUS.md`, `HOLISTIC_REVIEW.md`,
  `LAKEFILE_AND_ABS_DESIGN.md`, `D1_PROOF_PREPARATION_CHECKLIST.md`) still
  describe the pipeline as unactivated/DECLARED, contradicting the current
  PROVEN state.
- **WARN** — The verify Lean package has a cross-repo path dependency on
  `../../../mfact/procint` — it cannot build standalone.

## Rail 3 — Paper

- **BLOCKER** — `paper/correspondence_status.tex` is required by the
  release build (`main.tex` `\ifreleasebuild` branch, no fallback) but is
  (a) untracked in git and (b) missing from the `arxiv-package` recipe's
  explicit fragment tar list (justfile:129). A reviewer extracting the
  arxiv tarball and running `latexmk` hits a missing-`\input` fatal error.
- **WARN** — `paper/evaluation.tex` is internally inconsistent: the
  corpus/axiom tables correctly say 197 proven theorems, but the wall-clock
  narrative paragraph still says "145" (frozen by
  `scripts/build_evaluation_tex.py`, which never touches that sentence).
  145 is also the literal `prose-lint` bans elsewhere as a stale count.
- **WARN** — `main.tex:636` hand-asserts "PROVEN" for D1 in prose,
  ungated by `prose-lint` — if D1 status ever regresses this line silently
  becomes false, which is exactly the falsifier class the paper itself
  warns against.
- **WARN** — Only 1 of the 8 lint rules proposed in
  `paper/PROSE_LINT_RULES_CORRESPONDENCE.md` is wired into the justfile's
  `prose-lint` recipe (the `Aeneas (proves|verified|...)` pattern). Rules
  2–8 (unscoped "verified"/"proven", D1 scope guard, "automatically",
  receipt-chain specificity, claims-without-falsifiers, "proof" for
  non-formal claims, completeness adverbs) are unimplemented.
- **INFO** — Four untracked prep docs (`paper/PAPER_SECTIONS_DRAFT.md`,
  `paper/PROSE_LINT_RULES_CORRESPONDENCE.md`, `paper/STEP_8_INDEX.md`,
  `docs/HONEST_D1_STATEMENT.md`) contain stale/aspirational claims
  (wrong `\input` paths, "Status: STATED" superseded by PROVEN, unchecked
  integration items). Harmless only because they aren't `\input`ed into
  `main.tex`; should be pruned or moved out of `paper/` before release.

## Rail 4 — Ledger / Regen Integrity

- **BLOCKER** — `paper/correspondence_status.tex` sits in a double blind
  spot: it is untracked (so `regen-check`'s `git diff --exit-code` never
  sees it) *and* its sole producer, `scripts/build_verif.py`, is only
  invoked by the `verif-status` recipe — never by `regen-check` or `check`.
  The release admission path never re-renders or verifies it, so its
  ledger-hash drift (see Rail 1) can ship undetected.
- **WARN** — `release/verif-receipt.json` carries standing
  (`status: "PROVEN"`) but is not itself a ledgered artifact in
  `.mfact/artifacts.toml` — only listed as a *source* for
  `correspondence_status.tex`. It is tracked and modified, so the risk is
  low, but the source-vs-artifact classification is not machine-checkable
  anywhere.
- **WARN** — `packs/lean-math-pack/fragments/workflow_countermodel.ttl` is
  untracked yet is silently concatenated into generated `ontology.ttl` by
  `regen-check`'s first line (`cat fragments/*.ttl > ontology.ttl`) — an
  unledgered, uncommitted source materially affects generated output.
- **INFO** — Receipt chain itself (`.ggen-v2/receipt.json` /
  `receipt-log.jsonl`) is internally consistent (matching `chain_hash`).
  Script wiring (`verif_build_toolchain.sh`, `verif_assemble_pipeline.sh`,
  `verif_negative_controls.sh`, `verif_materialize.sh`) is complete — all
  four exist and are justfile-referenced, though all four are untracked and
  `verif_materialize.sh` is missing its executable bit (harmless, invoked
  via `bash`).

## Rail 5 — Tickets / mpops / Countermodel

- **BLOCKER (most severe finding across all 5 rails)** — The countermodel
  theorem `WfNet.infinite_transition_countermodel_sound_not_bounded`
  (`procint/ProcInt/Workflow/Countermodel.lean:131`) depends on two lemmas
  that are still `sorry`-backed (`crownCounter_sound` at line 107,
  `crownCounter_not_bounded` at line 118). This module is imported into the
  main corpus (`procint/ProcInt.lean:19`), so the `sorryAx` dependency is
  real. Yet both `packs/lean-math-pack/ontology.ttl` and the untracked
  `packs/lean-math-pack/fragments/workflow_countermodel.ttl` declare this
  theorem — and its two sorry-backed dependencies — with
  `procint:status "proven"`. This is a live `STATED_PROMOTED_TO_PROVEN`
  violation already checked into the ledger source.
- **BLOCKER** — The guard that should have caught this does not exist
  anywhere in the repo: `WFNET_INFINITE_TRANSITION_COUNTERMODEL`,
  `countermodel_not_promoted`, and `COUNTERMODEL_PROMOTION_REFUSED` all
  return zero matches repo-wide. `release/gates.json` has only 4 hardcoded
  keys (`sorryFree`, `axiomsClean`, `fixturesPass`, `evidenceComplete`, all
  `true`) with no mechanism tied to this specific theorem.
- **BLOCKER (build)** — `procint/AxiomAudit.lean` was modified to add
  `#guard_msgs` checks for the countermodel theorem and its sorry-lemmas,
  but the expected strings are prose captions (e.g. "Crown-jewel theorem
  counterexample: …") rather than real `#print axioms` output — which for
  a `sorry` proof emits `depends on axioms: [… sorryAx]`. `just audit` is
  expected to fail against the current tree; a previously-recorded green
  `just audit` baseline predates these changes and is stale.
- **WARN** — Ticket 010 (mpops rename) is ~90% done: the public
  `math-factory-pylab` script entry is removed and `mpops` works
  end-to-end (`mpops report status/doctor/next` all implemented and
  tested), but `pyproject.toml:156,168` still reference
  `math_factory_pylab.api:app` in server-launch command strings. Both
  ticket 009 and 010 receipts assert `ALIVE` while their own `## Standing`
  fields still say `DECLARED`, and the 010 receipt names the wrong entry
  point (stale evidence).
- **INFO** — `pylab/docs/jira/26.7.7/tickets/index.md`'s only recent change
  was adding rows for 009/010; ticket 012 (`ticket_012_workflow_state.md`,
  a baseline-state snapshot, terminal state `READY`) was never added to the
  index and is orphaned.
- **INFO** — `research/verif/obligations.toml` and `ontology.ttl` flip
  `token_replay_counts_corr` from `DECLARED`→`PROVEN` in the dirty tree;
  cross-check this promotion has a real receipt (it does — see Rail 2 —
  but the binding gap there means the claim's scope needs to be reworded or
  the theorem needs to be rebound, per the decision below).

---

## Approved remediation decisions (user-selected, not yet executed)

1. **Countermodel**: demote `WfNet.infinite_transition_countermodel_sound_not_bounded`
   (and its two sorry-backed lemmas) to `STATED` in both `ontology.ttl` and
   `fragments/workflow_countermodel.ttl`. Fix `AxiomAudit.lean`'s
   `#guard_msgs` to expect the honest `sorryAx`-bearing axiom list instead
   of prose captions. Add the missing `countermodel_not_promoted` guard
   (see AGENTS.md guardrail below) so this cannot silently recur. Proving
   the two sorries is deferred to a future ticket, not this release.
2. **D1 correspondence binding**: rewrite the `token_replay_counts_corr`
   theorem statement in `packs/lean-math-pack/fragments/verif.ttl` to
   quantify over `Wasm4pmVerify.Generated.ReplayCounts` via
   `Wasm4pmVerify.Abs.toSpec`, re-prove, re-render through `just render` /
   `verif-status`, and update `release/verif-receipt.json`'s `aeneasDecl`
   field away from `"TBD"`. This makes the correspondence claim actually
   machine-checked against the Aeneas extraction rather than merely
   adjacent to it.
3. **Release cut**: fix all BLOCKER items above, commit the fixes in
   coherent commits (ledger rebuild, regen, materialize re-run, negative
   controls run + receipted), run `just check` / `just release` to green,
   and re-cut `v26.7.7-procint-certified` as an explicit new certification
   cycle (never silently move the existing tag — either this is a new tag
   or the old one is retired and replaced, per AGENTS.md's core-identity
   rule).

These three decisions are the scope of the next execution ticket (not
opened yet — this ticket is the record of findings and decisions only).

## Action items (for the follow-up execution ticket)

- [ ] Demote countermodel theorem + dependencies to `STATED` in both TTL
      sources; fix `AxiomAudit.lean` guard strings.
- [ ] Implement `countermodel_not_promoted` guard +
      `WFNET_INFINITE_TRANSITION_COUNTERMODEL` status key +
      `COUNTERMODEL_PROMOTION_REFUSED` refusal, wired into `release/gates.json`
      or an equivalent builder check.
- [ ] Rebind `token_replay_counts_corr` to `Generated`/`Abs.toSpec`;
      re-prove; re-render; update `aeneasDecl`.
- [ ] Re-run `just verif-materialize`; commit `wasm4pm-compat/verify/`
      selectively with a proper `.gitignore` (exclude `.lake`, `llbc`
      build byproducts if desired, but the extraction/proof sources must
      be tracked).
- [ ] Run negative controls, capture a receipt of the three refusals.
- [ ] Rebuild `.mfact/artifacts.toml`; commit all ledgered artifacts
      currently dirty/untracked (`correspondence_status.tex`,
      `procint/AxiomAudit.lean`, `procint/ProcInt.lean`, manifest, etc.).
- [ ] Add `paper/correspondence_status.tex` to the `arxiv-package` tar
      list; fix the 145-vs-197 inconsistency in `evaluation.tex`'s
      wall-clock paragraph (via the builder, not by hand).
- [ ] Wire `regen-check`/`check` to invoke `build_verif.py` so its output
      artifact is covered by the drift check.
- [ ] Commit the untracked `workflow_countermodel.ttl` fragment before any
      further `regen-check` run.
- [ ] Prune or relocate the four stale prep docs out of `paper/`.
- [ ] Fix `pyproject.toml:156,168` residual `math_factory_pylab.api:app`
      references (ticket 010 completion); correct the 009/010 receipts'
      `## Standing` fields to match their actual `ALIVE` completion once
      genuinely verified.
- [ ] Add tag-ancestry verification to `just certify`/`release`; re-cut
      `v26.7.7-procint-certified` once the above is green.
- [ ] Add ticket 012 to `index.md`.
