# v26.7.12 Gap Ledger

Generated 2026-07-12 by the ten-lens gap-sweep workflow (lenses: rust-build, lean-procint,
research-papers, reachability, standing-claims, release-artifacts, paper, web-ui,
verifier-report, tickets-truth). Findings were adversarially verified; entries without a
`Verdict` line carried verdict `NOT_REQUIRED` (no adversarial pass ran on them). This ledger
is consumed by the v26.7.12 initiative cron loop, which updates gap statuses in place.

Findings from different lenses describing the same underlying defect are merged into one
entry listing every contributing lens. Severity reflects the post-verification rating;
where verifiers disagreed on severity, the disagreement is recorded inline. Refuted
findings are quarantined in the final appendix so they are not re-reported.

## Status legend

| Status      | Meaning                                                                   |
|-------------|---------------------------------------------------------------------------|
| OPEN        | Confirmed gap, no fix landed                                              |
| PARTIAL     | Part of the gap is addressed, or the finding is only partially applicable |
| IN_PROGRESS | A fix is actively being landed                                            |
| BLOCKED     | Fix depends on another gap (name it in the entry)                         |
| CLOSED      | Fixed. Requires an evidence line: the command and output proving closure  |

### Run log — gap-closing workflow, wave-based, 2026-07-12 workflow run

21 gaps were dispatched to isolated worktrees across 3 waves and their outcomes applied to
this ledger in a single pass.

- **Closed (7, merged and post-merge-verified):** G3, G9, G10, G33, G34, G47, G48.
- **Blocked (14, no ledger status change to CLOSED):** G2, G14, G27, G28, G29, G36, G38,
  G39, G40, G43, G45, G46 (worktree could not reach the target file/commit — mostly
  worktrees rooted at origin/main@945bfca predating the local commits c7413cb or 6cbc680
  that introduce the target artifacts, or targets that are untracked/uncommitted
  altogether); plus G15 and G35, whose isolated-worktree fixes were produced but failed to
  integrate (G15: `git merge` refused on an untracked, conflicting ROADMAP.md in the
  integration branch; G35: the fix branch itself no longer exists and the 13 target files
  remain present/tracked at HEAD, so nothing was ever actually merged).
- **Left OPEN, human-decision gaps (not touched):** G4, G5, G11, G13, G16, G17, G18, G19,
  G23, G24, G25, G31, G32, G41 — each names a genuine claim-strength or scope fork (revert
  vs. re-certify, ship vs. abandon, real proof vs. downgrade to CONJECTURAL/UNSTARTED)
  that this run declined to resolve unilaterally. Also flagged: **META-CAP** — the run's
  cap parameter arrived as a broken template ("undefined"), so no numeric ceiling could be
  honored; all frontier-closed, mechanically fixable OPEN gaps were attempted instead of
  an arbitrary truncation.
- **Left OPEN, blocked by an above dependency (not touched):** G1, G6, G7 (blocked by G4);
  G8 (blocked by G5); G12 (blocked by G11); G26 (blocked by G25); G30, G42 (blocked by
  G41); G44 (blocked by G24).

## Selection law

Severity ranks the initial triage; it is not by itself the pick rule for "what to work on
next." The general frontier-edge selection law is

```text
e* = argmax over e in {OPEN, frontier-closed}  of
     UnlockMass(e) · StandingCriticality(e) · ScenarioCoverage(e) / ClosureMass(e)
```

read as: prefer the OPEN gap whose closure (a) unblocks the most other BLOCKED gaps
(`UnlockMass`), (b) sits on the highest-severity claim surface (`StandingCriticality`), and
(c) is exercised by the broadest evidence/test surface (`ScenarioCoverage`), normalized by
its own effort to close (`ClosureMass`). "Frontier-closed" means every gap this one names as
a `BLOCKED` dependency is itself already CLOSED or is the gap under evaluation — do not pick
a gap whose prerequisite is still open elsewhere in the ledger; fix the prerequisite first
(e.g. G1 names G4 as its root cause: G4 is the frontier edge, not G1, until G4 closes).
Severity remains the tiebreak when `UnlockMass`/`ScenarioCoverage` are not decidable from the
ledger text alone.

## Quick reference

| Severity         | Count | IDs      |
|------------------|-------|----------|
| Release-blocking | 3     | G1-G3    |
| Major            | 30    | G4-G33   |
| Minor            | 18    | G34-G51  |
| Refuted          | 3     | appendix |

## Release-blocking

### G1 — Fresh certify FAILS on committed artifacts while standing asserts CERTIFIED PASS

- Lens: release-artifacts
- Status: OPEN
- Verdict: CONFIRMED — verifier re-ran the shipped gate command
  `mfact certify release/release-manifest.json release/gates.json` (justfile:93): EXIT=1,
  stderr `gate failure: sorryFree=true axiomsClean=true fixturesPass=true
  evidenceComplete=false`. The gates flip landed in ac647a9 (Jul 12); certify.log predates
  it, yet standing.env was regenerated AFTER the flip and still asserts PASS.
- Evidence: `git show HEAD:release/gates.json` => evidenceComplete:false,
  countermodel_not_promoted:false. mfact/Mfact/Cli.lean:36-37,65-67 and
  mfact/Mfact/CertifiedRelease.lean:16-18 make evidenceComplete a hard gate (exit 1).
  Yet release/certify.log:2364 says `certified: v26.7.7` and release/standing.env says
  CERTIFIED_RELEASE=PASS; final_status.json core.status=ALIVE.
- Fix: root-cause the empty auditMsg (scripts/build_manifest.py:116 computes
  evidenceComplete from auditMsg on proven non-example decls) — the decls promoted in G4
  lack audit evidence. Supply their auditMsg or revert the promotion, then `just certify`,
  confirm exit 0, and regenerate final_status/standing from that PASS.

### G2 — crates/mfact-core excluded from workspace; `cargo check --workspace` falsely green

- Lenses: rust-build, reachability (merged: no-workspace + no-CI-coverage findings)
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): the dispatched worktree
  (worktree-wf_24b4eb65-119-3) is rooted at origin/main@945bfca, which predates commit
  c7413cb — the commit that actually introduces the root Cargo.toml and crates/mfact-core
  this gap's own evidence describes. `find . -iname "Cargo.toml"` and `find . -iname
  "*.rs" -not -path "*/target/*"` both return empty in that worktree;
  `git merge-base --is-ancestor 945bfca c7413cb` succeeds, confirming the ordering.
  c7413cb was never pushed to origin, so no worktree branched from origin/main can reach
  it. No changes made. Recommend rebasing the worktree base onto local main (which
  contains c7413cb) or pushing it to origin before re-dispatching G2.
- Verdict: CONFIRMED — root Cargo.toml has no `[workspace]` and no path-dep on mfact-core;
  `cargo metadata --no-deps` lists only the root `mfact` package; mfact-core fails to
  compile deterministically (G10) while `cargo check --workspace` prints only "Finished";
  scripts/mfact-doctor.sh:42 uses that command as a gate. Severity upheld: a broken,
  production-referenced tracked crate escapes the workspace-wide gate.
- Evidence: `grep workspace Cargo.toml` = none; workspace_members =
  ['path+file:///Users/sac/mfact#0.1.0']. Neither .github/workflows/rust-ci.yml (root
  cargo test/certify) nor ci.yml builds crates/mfact-core; ci.yml test-e2e's
  `working-directory: mfact` points at a Lean dir (lakefile.toml, no Cargo.toml).
  mfact-core is referenced as the production BLAKE3 certification core in
  ROADMAP_GAP_AUTONOMIC.md:6,33.
- Fix: add `[workspace] members = [".", "crates/mfact-core"]` to root Cargo.toml (or a CI
  step `cargo test -p mfact-core`) so `--workspace` covers the crate. Expect red until
  G10/G11 land; that red is the point. Also fix ci.yml's `working-directory: mfact`.

### G3 — @rolldown/binding-darwin-arm64 is a hard dep; npm install EBADPLATFORM on ubuntu CI

- Lens: web-ui
- Status: CLOSED
- Closure evidence (2026-07-12, gap-closing workflow): the fix landed in the nested repo
  web/mfact-ui (github.com/seanchatmangpt/mfact-command-center, not this superproject's
  own history — that repo is only a gitlink here). `git show HEAD:package.json | grep -c
  rolldown` => `0` on the integrated main branch (merge commit 40dc87a, parent 77496df).
  Post-merge verification: `rm -rf node_modules && npm install --no-audit --no-fund` =>
  `added 655 packages in 30s`, no EBADPLATFORM/errors; `node_modules/@rolldown/` contains
  only `pluginutils` (unrelated indirect dep), `binding-darwin-arm64` absent.
- Verdict: CONFIRMED — npm arborist source check: build-ideal-tree.js:203 runs
  checkPlatform on every non-optional node with no try/catch, so os:darwin/cpu:arm64 vs a
  linux/x64 runner throws EBADPLATFORM and aborts install. Deterministic failure of the
  Pages deploy at its first step on every push, and of the ci.yml test-e2e job on every
  push/PR. Severity release-blocking upheld.
- Evidence: web/mfact-ui/package.json:16 lists `@rolldown/binding-darwin-arm64: ^1.1.5`
  under `dependencies` (no optionalDependencies block); package-lock.json:1933-1947 pins
  cpu:["arm64"], os:["darwin"]. Workflows run on ubuntu-latest (deploy-pages.yml:34,
  ci.yml:65). The package is dead: `grep -rn rolldown src` = empty; build is vite 5/rollup.
- Fix: remove the unused dep from package.json, regenerate package-lock.json, commit. If a
  rolldown experiment is intended, move it to `optionalDependencies` instead.

## Major

### G4 — Countermodel promoted STATED->PROVEN; countermodel_not_promoted guard is a dead path

- Lenses: release-artifacts, tickets-truth, paper (merged)
- Status: OPEN
- Evidence: release-manifest.json:2014 marks
  `ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded` proven=True
  (introduced by ac647a9 "chore: fix countermodel proofs mechanically").
  release/gates.json has `countermodel_not_promoted: false`, but Mfact/Cli.lean:29-33
  GatesJson has only 4 fields and never reads it, and scripts/build_manifest.py:110 only
  prints `COUNTERMODEL_PROMOTION_REFUSED` without sys.exit — guard computed, tripped,
  ignored. The standing.env STATED->PROVEN flip is an uncommitted working-tree edit.
  PROJECT.md:5,22 nonetheless declares the demotion remediation DONE with "zero blockers";
  jira ticket 013 still flags "a false PROVEN promotion on the countermodel theorem".
- Fix: revert the countermodel decl to STATED in the TTL catalog and regenerate the
  manifest (it exists to witness incompleteness), or — if promotion is intended — wire
  countermodel_not_promoted into GatesJson + GateResults.allPass and make build_manifest.py
  exit nonzero on promotion. Rewrite PROJECT.md to match the real gate state. Drives G1.

### G5 — Status surfaces diverge: three count/hash lineages, none annotated with drift

- Lenses: release-artifacts, paper, verifier-report, tickets-truth (merged)
- Status: OPEN
- Verdict: two CONFIRMED (both downgraded release-blocking -> major). The frozen tag
  v26.7.7-procint-certified is internally self-consistent (`git show 184e3a3:...` matches
  942facf3 in both manifest and final_status); the defect is a stale/false status surface
  at HEAD, not a broken frozen artifact. STANDING.md is narrative-only (no gate consumes
  it) and drifts in the under-claim direction.
- Evidence: live release-manifest.json:4288 foldHash=b1edfbeb, 401 artifacts / 203 proven /
  2 stated, runIdentifier 6cbc680 (NOT an ancestor of the tag). Pinned surfaces still cite
  942facf3 + 197/397/7: final_status.json:6-9, replay_plan.json:5, certify.log:11,
  FINAL_STATUS.md:12. paper/release_macros.tex says 203/401/2 (matches manifest, not
  final_status; stated=7 vs 2 cannot both hold). STANDING.md:57,69-78,124 is two
  generations stale (318/145/2, crown "stated", fold e25724e8) while README.md:48 calls it
  "the current, computed standing report". `scripts/report.py status` recomputes 401/203/2
  and ancestor-check FAIL. No surface records that HEAD (1faf0bc) is 7 commits past the
  tag with a dirty tree.
- Fix: single-source all counts/hashes from release-manifest.json. Either revert the
  manifest to the frozen 942facf3 state, or re-certify HEAD and re-project every surface
  via scripts/build_post_release.py (report.py does not write final_status.json) with a
  new tag. Regenerate STANDING.md from the current manifest or banner it as the frozen
  v26.7.7 tag view; add a HEAD-sha + dirty-flag drift line to standing.env/FINAL_STATUS.

### G6 — Release identity stale: no v26.7.12 anywhere; header v26.7.6; generator pins v26.7.7

- Lenses: release-artifacts, tickets-truth, standing-claims, research-papers (merged)
- Status: OPEN
- Verdict: CONFIRMED (downgraded release-blocking -> major) — v26.7.12 equals today's
  date and appears nowhere in the repo (roadmap self-identifies as v26.7.11); the release/
  surface is internally consistent at v26.7.7, so this is staleness, not a false gate.
- Evidence: `grep -r v26.7.12` = 0 hits; `git tag` tops out at v26.7.7-procint-certified.
  release/standing.env:1 header says "release v26.7.6" while the manifest, FINAL_STATUS.md,
  certify.log, quadrature.json, replay_plan.json all say v26.7.7.
  scripts/build_manifest.py:72 hardcodes RELEASE='v26.7.7' (line 73 seeds foldHash from
  it). standing.env's LEAN_BUILD=PASS / SORRY_COUNT=0 are computed over procint/ and
  mfact/ only, silently vouching for the 16 research-papers bridges they never cover.
- Fix: bump build_manifest.py:72 to the intended release id, template the standing.env
  header from the manifest's release field, add an explicit scope line ("does NOT include
  research-papers/ bridges"), re-run `just release`, and cut the matching tag. Blocked in
  practice by G1/G4 (certify will not pass until they land).

### G7 — standing_guard_receipt.json: 58 REFUSED/BLOCKER findings behind ALIVE/PASS standing

- Lens: release-artifacts
- Status: OPEN
- Evidence: release/standing_guard_receipt.json has 58 entries with
  standing_status=REFUSED: 1 ARTIFACT_DRIFT_REFUSED (standing.env expected 391ed0a vs
  actual 0d24176; working-tree shasum is a third value, 15db927), 1
  ORPHAN_ARTIFACT_REFUSED, 50 PROSE_LINT_VIOLATION, 6 REGEN_CHECK_COVERAGE_GAP. Meanwhile
  final_status.json core.status=ALIVE and standing.env CERTIFIED_RELEASE=PASS.
- Fix: re-run the standing guard after G4-G6 regenerate the surface; reconcile or
  explicitly waive the 50 prose-lint violations; register standing_guard_receipt.json in
  .mfact/artifacts.toml (it self-reports as ORPHAN). A surface must not read ALIVE/PASS
  while its own guard receipt is 58x REFUSED.

### G8 — Replay lane frozen at v26.7.7; REPLAY_PASS rests on a hash HEAD no longer reproduces

- Lens: release-artifacts
- Status: OPEN
- Evidence: release/replay_report.json status REPLAY_PASS is pinned to
  v26.7.7-procint-certified (written at ff44b04). replay_plan.json
  expectedCoreReleaseHash=942facf3 no longer reproduces from HEAD (G5), so the plan's own
  gate would refuse a fresh replay of the current tree. standing.env
  INDEPENDENT_REPLAY=REPLAY_PASS and final_status auxiliaryLanes.replay inherit the stale
  evidence.
- Fix: after G5/G6 re-tag, run `just independent-replay` (scripts/independent_replay.sh)
  against the new tag to write fresh replay_plan/replay_report with the new
  expectedCoreReleaseHash. Do not carry REPLAY_PASS forward from the v26.7.7 fixpoint.

### G9 — TYPE_INVENTORY_HASH is hand-injected; provenance file documents a different hash

- Lens: release-artifacts
- Status: CLOSED
- Closure evidence (2026-07-12, gap-closing workflow): added tracked, deterministic
  generator scripts/gen_type_inventory_hash.py (blake3 over path-sorted git-blob-sha1
  manifest of *.rs files under wasm4pm-compat@6aead3c/src, via `git ls-tree`), wired into
  scripts/build_manifest.py. Post-merge: `python3 scripts/gen_type_inventory_hash.py` =>
  `TYPE_INVENTORY_HASH=c50a40212454cbf8f698f18ad3458628e712affe8f7749a22fae5a899f2f1fa1
  SOURCE_FILE_COUNT=74 (src=/Users/sac/wasm4pm-compat@6aead3c)`; `grep -n
  '^TYPE_INVENTORY_HASH=' release/standing.env release/type_inventory_provenance.txt` =>
  both files show the identical hash `c50a40212454...f1a1`, resolving the mismatch. The
  old "26 files" claim is replaced by the real, git-ls-tree-derived count of 74.
- Evidence: release/standing.env:3 TYPE_INVENTORY_HASH=70b75e78... vs
  release/type_inventory_provenance.txt:1 TYPE_INVENTORY_HASH=dd43c348... (claims
  computation over /Users/sac/wasm4pm-compat @6aead3c, 26 files). No code in scripts/,
  crates/, or the justfile computes or writes the value — a field the header calls
  "computed not asserted" is asserted, and its provenance doc is contradictory.
- Fix: add a tracked generator (hash the 26 wasm4pm-compat blobs at the pinned commit)
  invoked from build_manifest.py/regen-check; rewrite type_inventory_provenance.txt to
  record the value actually shipped.

### G10 — crates/mfact-core does not compile: build.rs uses `cc` with no [build-dependencies]

- Lenses: rust-build, reachability (merged)
- Status: CLOSED
- Closure evidence (2026-07-12, gap-closing workflow): added `[build-dependencies]
  cc = "1"` to crates/mfact-core/Cargo.toml (commit 154b62f, merged via 3e4d0ec).
  Post-merge: `cd crates/mfact-core && cargo check --lib` => builds mfact-core and all
  deps (blake3, rayon, serde, serde_json, thiserror, cc, etc.) and finishes with
  `Finished \`dev\` profile [unoptimized + debuginfo] target(s) in 7.70s`; only a benign
  warning `Failed to execute lean --print-prefix, skipping Lean FFI linking` (build.rs
  degrades gracefully when `lean` isn't on PATH — not an error).
- Verdict: CONFIRMED by both lenses; severity disputed. The rust-build verifier downgraded
  release-blocking -> major: mfact-core is absent from every release/CI path (no
  workspace, no CI job, no justfile/scripts reference compiles it). The reachability
  verifier held release-blocking, citing release/publication_plan.json:11
  `cold_build_passed: met=false`. Ledger ranks it major; the gate blindness that lets the
  breakage escape is tracked release-blocking as G2.
- Evidence: `cd crates/mfact-core && cargo check --all-targets` aborts: `error[E0433]:
  cannot find module or crate cc --> build.rs:38:5` at `cc::Build::new()`; Cargo.toml has
  no [build-dependencies] (deps: blake3, rayon, serde, serde_json, thiserror). The failure
  is at build-script compile time, so lib, bins, and tests never compile. The `cc` in
  Cargo.lock is blake3's transitive build-dep, unusable by mfact-core's own build.rs.
- Fix: add `[build-dependencies]` with `cc = "1"` to crates/mfact-core/Cargo.toml, then
  re-run `cargo check --all-targets` to surface the downstream errors this hides (G11).

### G11 — mfact-core SSE/thermo/broker subsystem is dead: orphan modules, missing deps

- Lenses: rust-build, reachability (merged: 6 findings)
- Status: OPEN
- Verdict: three CONFIRMED verdicts downgraded release-blocking -> major (the crate is
  outside every build graph and no status surface claims /stream as a production marker);
  one verifier (orphan-modules finding) held release-blocking on "cargo build is broken".
  One evidence sub-claim was refuted in verification: no axum/tokio fingerprints are
  actually tracked in git (`git ls-files | grep fingerprint/axum` = 0 matches).
- Evidence: lib.rs:4-5 declares only `pub mod receipt; pub mod validate;` —
  broker.rs, thermo.rs, transport.rs, lean.rs are never mod-declared (dead islands
  contributing no code; roadmap section-10 tripwire "orphaned modules"). main.rs:1
  `use mfact_core::transport;` + `#[tokio::main]` with no tokio dep = guaranteed E0432.
  transport.rs:1-11 imports axum, futures_util, tower_http, tokio, tokio_stream — none in
  Cargo.toml. tests/thermo_integration_test.rs:1 and tests/sse_transport_test.rs:3 import
  the undeclared modules (plus missing dev-deps reqwest-eventsource/tokio), so the
  advertised "thermo integration" and "SSE under load" coverage never runs. The claimed
  consumer web/mfact-ui/src/wargames/useWargames.ts:89
  `new EventSource('http://localhost:8080/stream')` is itself dead — initStream is never
  called and the module is never imported.
- Fix: decide intent. (a) Ship it: declare `pub mod lean; pub mod broker; pub mod thermo;
  pub mod transport;` in lib.rs, add axum/tokio/tower-http/futures-util/tokio-stream (and
  dev reqwest-eventsource) to Cargo.toml, wire the crate into the workspace (G2), build,
  and hit /stream. (b) Abandon it: delete broker/thermo/transport/lean/main.rs, both
  integration tests, and the dead UI EventSource so no misleading scaffolding remains.

### G12 — Load-bearing files untracked: mfact-core production sources and all roadmap docs

- Lenses: rust-build, tickets-truth (merged)
- Status: OPEN
- Evidence: `git status --porcelain` marks as untracked (??): crates/mfact-core/build.rs,
  src/{broker,thermo,transport,lean,main}.rs, src/lean_ffi_wrapper.c — while Cargo.lock is
  tracked, so a fresh clone cannot reproduce the crate. Also untracked: CLAUDE_ROADMAP.md,
  ROADMAP_MATH_SPINE.md, ROADMAP.md, ROADMAP_GAP_{AUTONOMIC,SEMANTIC,THERMO}.md — yet
  tracked AGENTS.md:29 cites ROADMAP_MATH_SPINE.md as the corrections ledger. None appear
  in .mfact/artifacts.toml.
- Fix: `git add` the intended sources and roadmap docs in one commit (after G10/G11 decide
  what survives), or delete them; do not ship a tracked Cargo.lock over untracked sources.

### G13 — Core-Five "Constructed & Verified" claim has never been backed by a lake build

- Lens: research-papers
- Status: OPEN
- Verdict: CONFIRMED (downgraded release-blocking -> major) — the bridges live entirely
  outside the release build and gate (no research-papers reference in justfile, manifest,
  or ledger), so this is a false status surface, not a failing gate. The repo already
  labels these dirs SPOOFED_DOMAINS in scripts/mfact-doctor.sh, which no gate invokes.
- Evidence: ROADMAP.md:7-11 claims Phase 1 "successfully formally verified (0 sorrys)"
  incl. star-graph "exact Betti numbers (b_1=0)". justfile has zero research-papers lake
  recipes; `.lake/build` exists only for revops_turbulence and scalar_dissipation. At HEAD
  star_graphs' only lean file is `def hello := "world"` (21 bytes);
  scalar_dissipation/ScalarDissipation.lean and all revops_turbulence/*.lean were already
  0 bytes at HEAD.
- Fix: write the actual claimed theorems (star_graphs Betti/Euler, scalar_dissipation
  dissipation-rate map) plus per-bridge `lake build` recipes wired into the gate — or
  downgrade ROADMAP.md Phase 1 from "Constructed & Verified" to SCAFFOLDED.

### G14 — Rigor gate is blind: empty .lean passes; two roadmap tripwires unimplemented

- Lenses: research-papers, reachability (merged)
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): the dispatched worktree
  (worktree-wf_24b4eb65-119-7) is rooted at 945bfca, 13 commits behind main's tip;
  scripts/rigor_linter.py — the sole file this gap touches — was introduced by commit
  6cbc680, which is not an ancestor of that worktree's HEAD. `python3
  scripts/rigor_linter.py` in the worktree fails outright with
  `[Errno 2] No such file or directory`, exit=2, rather than reproducing the ledger's
  "exits 0" evidence. No files changed. Recommend re-cutting the worktree from a commit
  at/after 6cbc680 (or main HEAD).
- Verdict: CONFIRMED (downgraded release-blocking -> major) — research-papers is outside
  the certified release, and report.py's linter invocation is in fact blocking
  (check_call + sys.exit(1)), contrary to one fix-sketch claim. The blindness itself
  reproduces exactly: the live tree has all 1087 research-papers .lean files at 0 bytes
  and `python3 scripts/rigor_linter.py` exits 0.
- Evidence: rigor_linter.py only token-matches `def hello := "world"` (line 16) and
  `sorry` (line 21) — an empty file has neither token, so deleting a proof flips FAIL to
  PASS. It also lacks the two CLAUDE_ROADMAP.md section-10 tripwires (orphaned modules;
  pub fns referenced only by tests), silently ignores its CLI arg, and hardcodes
  mfact_dir='/Users/sac/mfact' (line 136). No `lake build` ever runs on research-papers
  despite ROADMAP's execution rules mandating it.
- Fix: flag any .lean that is empty (or hello-stub) while named as a lean_lib target in a
  sibling lakefile; add an orphan-module pass over `mod` graphs and a test-only-reference
  pass; honor argv[1]; add a release step running `lake build` per bridge dir.

### G15 — All seven "In Progress" Phase-2 bridge dirs are empty or hello-stubs

- Lens: research-papers
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): the isolated-worktree fix itself succeeded
  (5 of 7 dirs — hyperdimensional_cognitive, minimal_measures, ortac_plus,
  signal_criticality, bio_signals — confirmed pure 21-byte Lake-template stubs with only
  one commit each in history; quantum_hall/smfdcca already carry real content and were
  left unmarked; ROADMAP.md gained UNSTARTED annotations for the 5 confirmed stubs, commit
  e174fa3 on worktree-wf_24b4eb65-119-19), but it did not integrate: `git merge --no-ff
  worktree-wf_24b4eb65-119-19` into v26.7.12-close refused with "The following untracked
  working tree files would be overwritten by merge: ROADMAP.md" — the integration branch
  already carries an untracked, differently-annotated draft ROADMAP.md (3417 bytes,
  missing the item 12-16 UNSTARTED annotations). No merge commit was created; nothing was
  clobbered. The untracked ROADMAP.md must be reconciled (moved aside, diffed, or merged
  by hand) before this fix can land.
- Evidence: quantum_hall, smfdcca, hyperdimensional_cognitive, minimal_measures,
  ortac_plus, signal_criticality, bio_signals — every .lean is 0 bytes in the working
  tree. At HEAD, minimal_measures and signal_criticality had a single 1-line
  `def hello := "world"` stub; hyperdimensional_cognitive had 3 lines; bio_signals and
  ortac_plus main modules were 0 bytes. ROADMAP Phase 2 lists all as In Progress.
- Fix: restore real content from HEAD/_archive where it exists; mark stub-only bridges
  UNSTARTED in ROADMAP; land the G14 non-empty-target lint so stub dirs cannot report
  progress.

### G16 — Phase-2 domains 8-11 have no .lean at all while Rust ships sparse_chaos_diagnostic

- Lens: research-papers
- Status: OPEN
- Evidence: no research-papers dir exists for Sparse Chaos Diagnostics (#8), Terminal
  Breakdown (#9), Weighted Random Networks (#10), or Combinatorial Topology General (#11);
  concept greps over research-papers/*.lean return nothing. Yet
  crates/mfact-core/src/thermo.rs exports `scalar_dissipation` (line 58) and
  `sparse_chaos_diagnostic` (imported by tests/thermo_integration_test.rs:1) — runtime f64
  functions with no Lean counterpart. ROADMAP: "No claims permitted without a
  corresponding .lean proof."
- Fix: create the four formalizations, or mark #8-#11 UNSTARTED in ROADMAP.md and record
  sparse_chaos_diagnostic as CONJECTURAL runtime code with edge-to-bridge = MISSING.

### G17 — Vacuous "Core Theorem" proofs at HEAD (pair_correlation, smfdcca)

- Lens: research-papers
- Status: OPEN
- Evidence: HEAD pair_correlation/PairCorrelation.lean `mixing_orbits_asymptotic_iid`
  intros h1-h3 and never uses them; the conclusion
  `∃ stat, stat = AsymptoticIID` is discharged by `⟨AsymptoticIID, rfl⟩` regardless of
  hypotheses. HEAD smfdcca/Smfdcca.lean `smfdcca_bounded` "proves" `-1 ≤ v ∧ v ≤ 1` by
  projecting the assumed struct fields. Both cite arXiv papers (2606.17880, 2607.06324)
  with no correspondence morphism — AGENTS.md sections 3/4 violations.
- Fix: replace opaque-Prop / self-asserting-field structures with constructed quantities
  and prove the bound (e.g. SMFDCCA's [-1,1] via Cauchy-Schwarz over defined fluctuation
  functions). If unprovable now, record a theorem card at CONJECTURAL/STATED and delete
  the prose claim of verification.

### G18 — Claimed "Zero-Cost" Lean<->Rust typestate bonding does not exist

- Lens: research-papers
- Status: OPEN
- Evidence: ROADMAP.md mandates every verified Lean boundary appear in Rust as a
  compile-time constraint (PhantomData, `type Proof = ();`). Actual Rust:
  crates/mfact-core/src/thermo.rs:58 `scalar_dissipation` is a runtime numeric function
  with no typestate; grep finds no bridge-named typestates anywhere in crates/. The Lean
  scalar_dissipation proof is empty, so nothing exists to bond.
- Fix: implement the PhantomData witness parameterized by the discharged Lean obligation
  and consume it in scalar_dissipation — or delete the "Zero-Cost Mechanisms" claim from
  ROADMAP and record the Lean->Rust edge as MISSING.

### G19 — Four substantive procint Lean modules orphaned from every build target and the axiom audit

- Lenses: lean-procint, tickets-truth (merged: orphan modules + untracked Semantic.lean)
- Status: OPEN
- Evidence: procint/ProcInt.lean imports none of ProcInt.Workflow.Multifractal,
  ProcInt.Graph.Semantic, ProcInt.Planning.SemanticBridge, ProcInt.Thermo; no file imports
  them (grep = nothing). The full `lake build AxiomAudit Quadrature PostRelease Playground
  Tests` (8643 jobs, exit 0) leaves them unbuilt; they compile only when named explicitly.
  None appear in AxiomAudit.lean's guard list, yet they carry real theorems
  (`projection_path_independence`, `work_bounds`, boundary lemmas) mapped to roadmap
  geometry (ROADMAP_MATH_SPINE.md:91; CLAUDE_ROADMAP.md sec14 item 17). Additionally,
  procint/ProcInt/Graph/Semantic.lean is untracked in git and absent from the manifest —
  an off-ledger file inside the certified corpus dir. A future sorry/axiom/compile break
  in any of the four is caught by no gate.
- Fix: delete if dead, or wire in: import the modules from ProcInt.lean (or a dedicated
  root), add their theorems to AxiomAudit.lean `#guard_msgs in #print axioms` lines, move
  Thermo into the ProcInt.Thermo namespace, track Semantic.lean, and add a CI build step.

### G20 — NO_AMBIENT_THEOREM_AUTHORITY_ENFORCED=true, but the named enforcement does not exist

- Lens: standing-claims
- Status: CLOSED
- Closure evidence (2026-07-12, main session; downgrade path from the fix taken):
  `grep -n "NO_AMBIENT_THEOREM_AUTHORITY_ENFORCED" ROADMAP_MATH_SPINE.md` =>
  line 390 `NO_AMBIENT_THEOREM_AUTHORITY_ENFORCED=` (value blank, producer-gated comment);
  section 3 rephrased to targets: line 237 `enforced by a linter (target:
  scripts/predicate_namespace_lint.py, wired into`, line 246 `No such GGEN gate exists
  today; until it does, the taxonomy is applied by review.` Implementing the linter remains
  a target tracked by the blank marker itself.
- Evidence: ROADMAP_MATH_SPINE.md:365 sets the marker true; section 3 (lines 236, 242-243)
  claims a linter forbidding silent Math./Crypto./Runtime./Evidence. predicate translation
  and a GGEN claim-standing render gate. Greps over scripts/, src/, crates/, packs/ find
  neither; ggen.toml has no such gate; rigor_linter.py checks only sorry/fake-structs; the
  justfile prose-lint greps four literals in paper/main.tex. Only
  scripts/verif_negative_controls.sh CORRESPONDENCE_DANGLING_REFUSED covers a narrow slice.
- Fix: downgrade the marker to a target (blank it; rephrase section 3 in the subjunctive),
  or implement scripts/predicate_namespace_lint.py, wire it into `just check`, and set
  =true only once it runs green in the release path.

### G21 — CROWN_ABSTRACT_COMPOSITION=PROVEN_CONDITIONALLY has no artifact; body says TARGET_THEOREM

- Lens: standing-claims
- Status: CLOSED
- Closure evidence (2026-07-12, main session; blank-the-marker path from the fix taken):
  `grep -n "CROWN_ABSTRACT_COMPOSITION" ROADMAP_MATH_SPINE.md` => line 393
  `CROWN_ABSTRACT_COMPOSITION=` (blank, comment "target: PROVEN_CONDITIONALLY, once
  formalized"); ceiling now matches the body: line 383
  `CROWN_I_TO_V=TARGET_THEOREM # per section 1; no Lean artifact exists yet`, and
  `CROWN_RUNTIME=BLOCKED_ON_CORRESPONDENCE` is typed as a claim ceiling, not an achievement.
- Evidence: ROADMAP_MATH_SPINE.md:369 fills the marker as PROVEN_CONDITIONALLY (Theorem
  21.1, lines 108-115), but the Crown I-V spine (minimal residue -> DM descent -> free
  monad -> coalgebra -> unique replay -> autonomous resolution) is referenced nowhere else
  in the repo; no MFW dir exists under procint; the paper's crown is van der Aalst WfNet
  soundness (paper/main.tex:498), a different object. The doc's own body types Crown I-V
  as TARGET_THEOREM and leaves MFW_M0..M5 markers empty (lines 375-382).
- Fix: blank CROWN_ABSTRACT_COMPOSITION= (and CROWN_RUNTIME=) or replace with the body's
  actual standing TARGET_THEOREM; if a conditional proof exists, cite its file:line
  inline in Correction 1 — currently there is none to cite.

### G22 — Section-6 markers are asserted from prose, violating the doc's own closing law

- Lens: standing-claims
- Status: CLOSED
- Closure evidence (2026-07-12, main session): section 6 restructured into claim ceilings
  (assert absence of standing; may live in prose) vs. achievement markers (blank until a
  producer derives them into release/standing.env; target
  `scripts/build_spine_markers.py`). `grep -c "=true" ROADMAP_MATH_SPINE.md` => 0. The two
  true-in-fact environment markers (MATHLIB_DM_SUPPORT_VERIFIED,
  HESSENBERG_ROUTE_BLOCKED_AT_PIN) are also blank pending the producer; their grep evidence
  stays cited in section 4. RECEIPT_FOLD renamed: RECEIPT_FOLD_CEILING (in force) vs.
  RECEIPT_FOLD_IMPLEMENTED= (blank; fold exists nowhere yet). Producer implementation
  remains open work — tracked by the blank markers, not by this entry.
- Evidence: ROADMAP_MATH_SPINE.md:385 requires every marker be derived from the artifact
  it names, never asserted from prose. Yet every section-6 marker exists only in this doc
  (repo-wide greps = zero hits; release/standing.env contains none).
  RECEIPT_FOLD=COMPUTATIONALLY_BINDING (line 371) names a domain-separated fold
  h_{n+1}=H(tag||h_n||enc(r)) that is implemented nowhere. (Two markers are true-in-fact
  but still unwired: MATHLIB_DM_SUPPORT_VERIFIED, HESSENBERG_ROUTE_BLOCKED_AT_PIN.)
- Fix: add a producer (extend scripts/build_manifest.py or new build_spine_markers.py)
  that emits the markers into release/standing.env from real evidence, leaving unproduced
  markers empty; until then delete the filled values, keeping names as a target schema.

### G23 — Paper calls the D1 Aeneas correspondence "PROVEN"; its own table says DECLARED

- Lens: paper
- Status: OPEN
- Verdict: CONFIRMED (downgraded release-blocking -> major) — no machine surface claims
  PROVEN (release/verif-receipt.json says DECLARED/proven:false; the ttl agrees); the
  rendered Lean file is a dist snapshot in no lakefile, so nothing gated breaks. The
  prose-vs-table overclaim in shipped paper text is real (claim above standing).
- Evidence: paper/main.tex:711 "this honest, weaker, but PROVEN statement" vs the
  \input table (paper/correspondence_status.tex) classifying token_replay_counts_corr as
  DECLARED, "no verify/receipts/pipeline.json — charon/aeneas has not run".
  verify/receipts/pipeline.json is absent;
  dist/verif/lean/Wasm4pmVerify/Corr/token_replay_counts_corr.lean imports a
  Wasm4pmVerify.Generated namespace that exists nowhere, so the theorem cannot build.
- Fix: reword main.tex:711 to "...honest, weaker statement, currently DECLARED pending
  extraction (Table 1)" — or actually run the charon/aeneas pipeline, generate the
  namespaces, add the module to a lake build, and let build_verif.py compute PROVEN.

### G24 — Documented `just prose-lint` 8-rule gate is unimplemented; doc cites a ~/praxis path

- Lens: paper
- Status: OPEN
- Evidence: paper/PROSE_LINT_RULES_CORRESPONDENCE.md claims Rules 1-8 are "automated CI
  gates ... enforced" via `just prose-lint`, with a recipe grepping
  target/mfact/paper/main.tex (path does not exist). The real justfile:346-349 recipe
  greps only `145|318|e25724e8|CERTIFIED_RELEASE=PASS` in paper/main.tex. The doc's
  Maintenance footer names /Users/sac/praxis/mfact/... — a forbidden ~/praxis path
  (AGENTS.md section 3) and the wrong location.
- Fix: implement Rules 1-8 as real recipe steps against paper/main.tex and
  paper/PAPER_SECTIONS_DRAFT.md, or downgrade the doc's language to "manual review
  checklist"; fix the paths and the footer.

### G25 — web/mfact-ui is an unregistered gitlink: CI/Pages checkout gets an empty directory

- Lens: web-ui
- Status: OPEN
- Verdict: CONFIRMED (downgraded release-blocking -> major) — the mechanism is genuine
  (checkout@v4 defaults submodules:false; no .gitmodules means no URL to fetch even if
  enabled), but the Pages deploy is not a claimed release marker in any governing doc;
  the Lean release gates are unaffected.
- Evidence: `git ls-tree HEAD web/mfact-ui` = `160000 commit 1ba3a9b...` (gitlink); no
  .gitmodules on disk or in the index; no submodule.* in .git/config.
  deploy-pages.yml:25,33-38 and ci.yml:63-65 then run `npm install` / `npm run build` in
  the empty dir (no package.json) and fail. Local builds work only because the real UI
  lives on this machine.
- Fix: register a real submodule (`git submodule add <url> web/mfact-ui`, commit
  .gitmodules, add `submodules: recursive` to all three checkouts) — or vendor the UI as
  a tracked directory (remove the nested .git, `git add web/mfact-ui`).

### G26 — The UI code that builds is uncommitted: gitlink at 1ba3a9b, working tree 7c81bf2-dirty

- Lens: web-ui
- Status: OPEN
- Evidence: `git diff web/mfact-ui` shows the gitlink moving 1ba3a9b -> 7c81bf2-dirty.
  The embedded repo has 3 unpushed commits (React-not-defined fixes in MosaicLocal and
  TenFourApp; streetscape.gl crash fix in SemanticGraph) plus 14 modified tracked files
  (vite.config.ts, src/App.tsx, package.json, lockfile, ...) and 4 untracked files. Even
  a fixed CI (G25) would build code missing these fixes.
- Fix: commit and push the embedded working tree, then stage the updated gitlink in the
  parent (`git add web/mfact-ui`); if vendoring per G25(b), commit the files directly.

### G27 — Vite base '/mfact-command-center/' mismatches the Pages repo 'mfact': assets 404

- Lens: web-ui
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): web/mfact-ui/vite.config.ts is unreachable
  from the dispatched worktree (worktree-wf_24b4eb65-119-8). `git merge-base --is-ancestor
  6cbc680 HEAD` => NO (worktree HEAD=945bfca predates 6cbc680, the commit that first added
  web/mfact-ui as a bare gitlink); `git ls-tree -r --name-only HEAD | grep -c
  web/mfact-ui` => 0; `test -e web/mfact-ui` => DOES NOT EXIST. Even where the path
  exists (main /Users/sac/mfact checkout), it is a gitlink into a wholly separate repo
  (github.com/seanchatmangpt/mfact-command-center), so `git worktree add` on the outer
  repo can never populate it. No changes made. Recommend editing directly inside that
  nested repo's checkout, or vendoring web/mfact-ui as tracked files (G25 option (b))
  before re-dispatching G27.
- Verdict: CONFIRMED (downgraded release-blocking -> major) — the base-vs-repo-name
  mismatch is mechanical and unconditional in the tree; the live blank-page consequence
  depends on Pages being enabled as a project site (unverifiable from the tree). Build
  itself succeeds.
- Evidence: web/mfact-ui/vite.config.ts:9 `base: '/mfact-command-center/'`; remote is
  github.com/seanchatmangpt/mfact.git, so project Pages serves under /mfact/. Built
  dist/index.html references /mfact-command-center/assets/... — every JS/CSS request
  would 404. No CNAME/custom domain exists anywhere.
- Fix: set `base: '/mfact/'` (or add public/CNAME with a custom domain and use base '/'),
  rebuild so dist asset paths match the served prefix.

### G28 — vite.config.ts hardcodes absolute /Users/sac/... alias paths; build is machine-local

- Lens: web-ui
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): same unreachable-file blocker as G27, from
  a separately dispatched worktree (worktree-wf_24b4eb65-119-20). `git merge-base
  --is-ancestor 6cbc680 945bfca` => exit 1 (6cbc680 is not an ancestor of this worktree's
  base); `ls web` => No such file or directory; `find . -iname "vite.config*"` => no
  matches. web/mfact-ui is a gitlink added by 6cbc680, absent from this worktree's history
  entirely. No changes made. Recommend re-dispatching from a worktree based at/after
  6cbc680, or fixing directly in the nested repo's own checkout.
- Evidence: resolve.alias maps @unrdf/* to /Users/sac/unrdf/packages/... (7 entries) and
  the uncommitted diff adds /Users/sac/mfact/web/mfact-ui/node_modules polyfill-shim
  paths. None exist on a CI runner. The @unrdf aliases are currently outside the
  production graph (only test-chunk.mjs references them), but any future @unrdf import or
  shim-resolution hit breaks CI. The file is also uncommitted in the embedded repo.
- Fix: replace absolute paths with bare package specifiers (real deps) or
  `path.resolve(__dirname, ...)`; never reference /Users/sac in committed config; then
  commit vite.config.ts.

### G29 — e2e-sync.yml invokes ./run_e2e.sh, which does not exist: workflow fails every push

- Lens: web-ui
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): .github/workflows/e2e-sync.yml does not
  exist anywhere in the dispatched worktree's history (worktree-wf_24b4eb65-119-9).
  `test -f .github/workflows/e2e-sync.yml` => MISSING; `git ls-files | grep run_e2e` and
  `find . -iname "run_e2e*"` both empty; `git merge-base --is-ancestor 6cbc680 HEAD` =>
  not-ancestor. The file was introduced by 6cbc680, which sits on a divergent line from
  this worktree's origin/main@945bfca base. Re-running the ledger's own evidence command
  (`python3`/`test -f`) in this worktree does not reproduce closure — the file is simply
  absent, not fixed. No changes made. Recommend re-dispatching from a worktree branched
  past 6cbc680.
- Evidence: .github/workflows/e2e-sync.yml:25,28 chmod+run run_e2e.sh; `git ls-files |
  grep run_e2e` = empty; no such file anywhere outside node_modules. The chmod step errors
  immediately, so the job can never pass — a false CI surface. (A verifier for G25 noted
  the same independently.)
- Fix: add run_e2e.sh at repo root (boot backend + `npx playwright test` in web/mfact-ui),
  or delete e2e-sync.yml since ci.yml's test-e2e job already runs Playwright.

### G30 — No unified verifier-report artifact: the 13 Phase-15 fields live on partial surfaces

- Lens: verifier-report
- Status: PARTIAL
- Evidence: no single artifact enumerates the Phase-15 fields. Nearest surfaces cover
  subsets only: release/standing.env (orphan counts, LEAN_BUILD, replay proxy);
  scripts/build_verif.py (D1 correspondence ladder only); scripts/report.py (explicitly
  an ephemeral, gitignored cockpit). Nothing enumerates declared/manufactured/admitted
  artifacts, projection-digest consistency, AIR conformance, OTP/AtomVM differential,
  broker bypass, or OCEL equivalence as report fields.
- Fix: define a canonical schema for all 13 fields; one generator assembles them from
  existing receipts (quadrature.json, standing.env, replay_report.json) plus the new
  instrumentation (G41), writing a ledgered release/verif-report.json.

### G31 — receipt/validate are reachable only from tests; parse_manifest referenced by nothing

- Lens: reachability
- Status: OPEN
- Evidence: repo grep for GgenReceiptEngine / compute_receipt /
  validate_manifest_concurrently / compute_genesis_fold / `mfact_core::` returns only
  tests/*.rs and main.rs:1 (which targets the nonexistent transport module). No
  production caller reaches the receipt/validate engine. `parse_manifest`
  (crates/mfact-core/src/lib.rs:83) has zero references anywhere, even tests.
- Fix: build a real entrypoint consuming GgenReceiptEngine/validate_manifest_concurrently
  on live manifest input, or document the crate as a test-only library surface; delete
  parse_manifest or wire it into the manifest-loading path.

### G32 — broker.rs claims a POWL depth cap of 256 but passes 513 with no bound

- Lens: reachability
- Status: OPEN
- Evidence: crates/mfact-core/src/broker.rs:107 comment "Explicitly cap the POWL recursive
  expansion depth (<= 256)" sits directly above broker.rs:115
  `lp_procint_ProcInt_Powl_expansionDepth(lean_str, ext_lean_box(513))`. No if/clamp
  exists; the value contradicts the claimed bound. The rigor linter misses it because the
  text is a `//` comment and lacks its enforcement-keyword list.
- Fix: implement the cap (`value.min(256)`) or correct the comment and reconcile why 513
  is passed; broaden the linter regex to include "cap" and non-/// doc lines.

### G33 — Detached HEAD; STASH_RECONCILIATION.md names a branch that does not exist

- Lens: tickets-truth
- Status: CLOSED
- Closure evidence (2026-07-12, gap-closing workflow): replaced the "or similar" hedges in
  release/STASH_RECONCILIATION.md with the real detached-HEAD facts (commit 587d307,
  merged via c3d38a1). Post-merge: `grep -n "or similar"
  release/STASH_RECONCILIATION.md` => no match (exit 1); `git status | head -1` => `On
  branch v26.7.12-close`; `git merge-base --is-ancestor 184e3a3 1faf0bc` => succeeded,
  printed `184e3a3 IS ancestor of 1faf0bc`; `git rev-parse --verify
  feat/crown-jewel-wip` => `fatal: Needed a single revision` (branch does not exist),
  matching the corrected doc's claim exactly.
- Evidence: `git status` = HEAD detached from c0ffeed3c (HEAD=1faf0bc); `git branch -a`
  lists only main + origin/main; feat/crown-jewel-wip does not resolve. Yet
  release/STASH_RECONCILIATION.md:7,11 says the stash base is "likely
  `feat/crown-jewel-wip` or similar". No status doc records the detached-HEAD state.
- Fix: correct STASH_RECONCILIATION.md to the actual detached commit (1faf0bc, ancestor
  tag 184e3a3) or create/checkout the named branch; drop the "or similar" hedges.

## Minor

### G34 — PostRelease "self-audit" witnesses are rfl over same-file string literals

- Lens: lean-procint
- Status: CLOSED
- Closure evidence (2026-07-12, gap-closing workflow): edited the ggen source template
  packs/post-release-pack/templates/post_release_lean.tmpl (not the rendered
  PostRelease.lean directly, per the edit-surface rule) to tighten the
  packets_never_self_actuate/crown_status_promoted docstrings and add a `#print axioms
  ProcInt.WfNet.sound_iff_shortCircuit_live_bounded` guard, coupling this file's build to
  the real proof term (commit 61468b4, merged via 9af108c). Post-merge: `lake build
  PostRelease` => `✔ [8614/8615] Built ProcInt.Release.PostRelease (36s)` /
  `Build completed successfully (8615 jobs)`; `grep -n
  "sound_iff_shortCircuit_live_bounded' depends on axioms" ProcInt/Release/PostRelease.lean`
  => matched line 97, showing `[propext, Classical.choice, Quot.sound]`.
- Evidence: ProcInt/Release/PostRelease.lean `packets_never_self_actuate` and
  `crown_status_promoted` are rfl/decide over hardcoded lists and the literal
  `crownStatus := "PROVEN"` defined in the same file — certifying template
  self-consistency, not the runtime/proof property the docstrings narrate. Not coupled to
  the real proof term `ProcInt.WfNet.sound_iff_shortCircuit_live_bounded` (which does
  exist and is separately audited — a decoupling risk, not a current falsehood).
- Fix: reference the real proof terms (so sorrying the theorem breaks this file) and
  tighten docstrings to say exactly what the rfl checks.

### G35 — Broken, vacuous-True scratch lemmas and 13 stray files in the production module tree

- Lens: lean-procint
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): the dispatched worktree
  (worktree-wf_24b4eb65-119-12) found all 13 target files absent from its own tree
  (branched before commit ac647a9, which introduced them elsewhere) and reported the gap
  ALREADY_CLOSED on that basis — but that branch itself no longer exists anywhere
  (`git rev-parse --verify worktree-wf_24b4eb65-119-12` => `fatal: Needed a single
  revision`; absent from `git branch -a`, `git worktree list`, and `git fsck
  --unreachable`), so there was nothing to merge. Re-running the evidence command against
  the current integrated tree (v26.7.12-close) shows the gap is genuinely still open: all
  13 files (procint/scratch*.lean, procint/test_expand.lean,
  procint/ProcInt/Workflow/test_*.lean, TestTactics.lean) are PRESENT and tracked/clean;
  `git merge-base --is-ancestor ac647a9 HEAD` succeeds. The intended `git rm` was never
  applied to any branch. Needs its fix branch recreated in a future wave.
- Evidence: `lake build ProcInt.Workflow.test_ind` FAILS (unsolved goal `⊢ True` after
  bare trace_state); test_reach.lean:9 also concludes `: True`. 13 stray files: 8
  scratch*.lean/test_expand.lean at procint/ root, 5 test/tactic files under
  ProcInt/Workflow/. All belong to no lean_lib root, so nothing gates them. AGENTS.md
  section 3 mandates deleting vacuous tautologies and scaffolding.
- Fix: `git rm` the 13 files; keep any worthwhile tactic experiment in a non-shipped dir
  excluded from lean_lib globs, with a non-vacuous conclusion.

### G36 — Empty lakefile.lean shadows the real lakefile.toml in 7 bridge dirs

- Lens: research-papers
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): two independent blockers, both confirmed
  from worktree-wf_24b4eb65-119-13. (1) This worktree's base (945bfca) predates c7413cb,
  the commit that introduced the research-papers bridge dirs at all — none of the 7
  target dirs exist here. (2) Independent of worktree staleness: at main's own current
  HEAD (1faf0bc) the offending lakefile.lean files are themselves untracked —
  `git cat-file -e 1faf0bc:research-papers/bio_signals/lakefile.lean` =>
  `fatal: path ... exists on disk, but not in '1faf0bc'`; `git status --porcelain` shows
  `?? research-papers/bio_signals/lakefile.lean` (untracked, not gitignored). A `git rm`
  of an untracked file produces zero diff and nothing stageable, so the ledger's literal
  fix cannot be represented as a worktree commit at all — it is a live filesystem hygiene
  action in the main checkout, not a git change. No changes made.
- Evidence: 0-byte lakefile.lean alongside a populated lakefile.toml in revops_turbulence,
  scalar_dissipation, smfdcca, ortac_plus, hyperdimensional_cognitive, bio_signals,
  floquet_photonic. Lake prefers lakefile.lean when present; an empty one defines no
  lean_lib, so the toml-declared target is never built.
- Fix: `rm` the 0-byte lakefile.lean files so Lake falls back to the toml; verify with
  `lake build` in one dir.

### G37 — Stale .lake/build dirs overstate verification for now-empty sources

- Lens: research-papers
- Status: OPEN (evidence partially unverified — artifact contents not rebuilt/inspected)
- Evidence: 9 dirs (aeneas_rust_verification, bio_signals, floquet_photonic,
  hyperdimensional_cognitive, ortac_plus, revops_turbulence, scalar_dissipation, smfdcca,
  sound_borrow_checking) have .lake/build while their .lean sources are 0 bytes, so
  .lake/build presence cannot be read as "verified".
- Fix: treat .lake/build as non-evidence; after restoring sources run
  `lake clean && lake build` per dir and record results in the standing surface; remove
  stale build dirs meanwhile.

### G38 — random_walk pins Mathlib but has no lake-manifest.json: unreproducible build

- Lens: research-papers
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): research-papers/random_walk does not exist
  anywhere in the dispatched worktree's history (worktree-wf_24b4eb65-119-14, rooted at
  945bfca). `ls research-papers/random_walk/` => No such file or directory;
  `git merge-base --is-ancestor 945bfca c7413cb && echo yes` => `yes` (945bfca precedes
  c7413cb, the commit that added the directory); `git branch --contains c7413cb` => empty
  (no local branch, including this one, contains it). The gap ledger itself was generated
  against a later HEAD than this worktree's lineage. No changes made. Recommend
  re-dispatching from a worktree branched at/after c7413cb.
- Evidence: research-papers/random_walk/lakefile.toml requires mathlib at rev fabf563a...,
  but no lake-manifest.json and no .lake dir exist — the transitive graph is unpinned. It
  is the only Core-Five dir whose HEAD source (114 lines) genuinely imported Mathlib.
- Fix: run `lake update` once, commit lake-manifest.json (or vendor .lake/packages);
  restore the source; confirm `lake build` against the pinned rev.

### G39 — Eight bridge dirs lack a lean-toolchain pin: reproducibility drift risk

- Lens: research-papers
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): the two dirs assigned to this dispatch
  (worktree-wf_24b4eb65-119-15), aeneas_rust_verification and sound_borrow_checking, do
  not exist in any commit reachable from this worktree or its remotes — confirmed both
  against the worktree (`find research-papers -maxdepth 1 -type d` => only
  `research-papers` itself, no subdirectories at all) and against main's own current tip
  1faf0bc (`git cat-file -e 1faf0bc:research-papers/aeneas_rust_verification` =>
  "exists on disk, but not in 1faf0bc"). They exist only as large, uncommitted
  working-tree content (lakefile.lean, Thermo.lean/.c, tickets/, lake-manifest.json, and a
  full vendored .lake/ build cache) in the main /Users/sac/mfact checkout. Adding a
  lean-toolchain pin presupposes a committed bridge dir that does not yet exist; importing
  the whole uncommitted tree is far outside this gap's scoped diff. No changes made.
  Recommend committing the two bridge dirs first (their own gap), then re-dispatching G39.
- Evidence: lean-toolchain absent in random_walk, pair_correlation, quantum_hall,
  star_graphs, aeneas_rust_verification, sound_borrow_checking (and others); root pin is
  leanprover/lean4:v4.31.0 and currently matches the pinned dirs, but nothing enforces it
  for the unpinned ones.
- Fix: add lean-toolchain (v4.31.0) to each bridge dir lacking one so a root-pin change
  cannot silently desync bridges.

### G40 — crates/mfact-core/target/** build artifacts are committed to git

- Lens: rust-build
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): the dispatched worktree
  (worktree-wf_24b4eb65-119-21, HEAD=945bfca) predates the G10 merge (3e4d0ec) that
  creates crates/mfact-core at all; `git ls-files crates/mfact-core/` in that worktree
  returns nothing (crate absent). Confirmed read-only that the defect is real on the live
  integration branch v26.7.12-close (HEAD 7092cfe at check time): `git ls-files
  crates/mfact-core/target | wc -l` => 4233 tracked paths, and root .gitignore already
  has `/target` without a prior `git rm --cached` ever running. No changes made in this
  worktree. Recommend re-dispatching G40 from a worktree branched after G10 (3e4d0ec), or
  applying the fix directly against v26.7.12-close where the artifacts live.
- Evidence: `git ls-files crates/mfact-core/` lists hundreds of target/ paths
  (.fingerprint/*, .rustc_info.json, CACHEDIR.TAG). Committed artifacts bloat the tree
  and stale fingerprints mislead about the crate's dependency set.
- Fix: `git rm -r --cached crates/mfact-core/target` and gitignore `target/`.

### G41 — Phase-15 verifier report is prose: marker never emitted, 6/13 fields unbuilt

- Lens: verifier-report (merged: dead marker + zero-instrumentation findings)
- Status: OPEN
- Verdict: CONFIRMED twice (both downgraded release-blocking -> minor) — Phase 15 is an
  explicitly future phase; no status surface claims the marker; the roadmap itself labels
  the fields "currently unavailable". This restates a TODO the repo tracks honestly.
- Evidence: VERIFIER_REPORT_ALL_FIELDS_LIVE appears only in CLAUDE_ROADMAP.md (1379,
  1638); no script writes it; absent from standing.env — same for all 17 DoD markers. Six
  of the 13 fields (AIR conformance corpus, broker bypass, OTP/AtomVM differential, OCEL
  transformation, projection digest, measurement rail) have zero instrumentation anywhere.
- Fix: add scripts/build_verif_report.py computing the 13 fields from receipts, emitting
  the marker true only when every field is live (else false with per-field breakdown);
  wire into `just release`/`check`. Fields without instrumentation stay UNAVAILABLE with
  their blocking phase named. Feeds G30.

### G42 — standing.env regen hint is a dead scratchpad path; no runnable report target

- Lenses: release-artifacts, verifier-report (merged)
- Status: OPEN
- Evidence: release/standing.env:2 says "Regenerate via: python3
  <scratchpad>/build_manifest.py ..." — a literal placeholder; the real generator is
  scripts/build_manifest.py (`just manifest`) and certification is `just certify`.
  CLAUDE_ROADMAP.md:1645,1662-1663 reference a verifier report with no just target
  (only verif-status/report-write exist).
- Fix: correct the header hint to `just manifest && just certify`; add a
  `just verif-report` target invoking the G41 generator.

### G43 — Root receipt.json asserts CERTIFIED with no version binding

- Lens: release-artifacts
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): the target artifact (root receipt.json) and
  its producer (crates/mfact-core's GgenReceiptEngine) do not exist in the dispatched
  worktree (worktree-wf_24b4eb65-119-22). `find . -maxdepth 1 -iname receipt.json` =>
  empty; `git log --all --oneline -- receipt.json` => only c7413cb (the commit that
  introduced it, not reachable from this worktree's HEAD); `git merge-base --is-ancestor
  HEAD c7413cb` => prints "ancestor" (this worktree's HEAD 945bfca precedes c7413cb);
  `ls crates/` => No such file or directory. No changes made. Recommend re-dispatching
  from a worktree branched at/after c7413cb.
- Evidence: receipt.json is clean/committed (the "both modified" task premise applied only
  to the .ggen-v2 pair, whose dirtiness is a chain-hash rotation, andon Green). Its
  content is a version-free fact: `<http://mfact/release> <http://mfact/status>
  "CERTIFIED"` — it cannot distinguish which release is certified and will not change
  when a new release is cut.
- Fix: bind the receipt to the release id and coreReleaseHash (version + foldHash
  triples), regenerated in the same step that seals the release.

### G44 — The documented prose-lint rules would fail today's paper if ever wired

- Lens: paper
- Status: OPEN
- Evidence: running the doc's own grep rules: Rule 4 hits paper/main.tex:93,828
  ("automatically"); Rule 5 hits PAPER_SECTIONS_DRAFT.md:173,176 and main.tex:815; Rules
  2/7 produce ~10 matches each — mostly false positives from crude patterns, but real
  matches, so the documented gate would exit nonzero. The actual justfile prose-lint
  passes only because it checks four unrelated literals.
- Fix: tighten Rule 2/5/7 patterns (anchor to sentence context, whitelist terminology),
  fix or annotate the genuine Rule-4 hits, then wire the finalized rules into the
  justfile (with G24).

### G45 — Production bundle is a single 6.86 MB JS chunk; warning limit raised to hide it

- Lens: web-ui
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): web/mfact-ui/vite.config.ts is unreachable
  from the dispatched worktree (worktree-wf_24b4eb65-119-25, HEAD=945bfca).
  `git merge-base --is-ancestor 6cbc680 HEAD` => exit 1 (not an ancestor — this worktree
  predates the commit that first added web/mfact-ui as a gitlink); `git ls-tree HEAD --
  web` => empty; `find . -iname "vite.config*"` => no matches. No changes made. Recommend
  re-cutting this worktree from a base at/after 6cbc680 (ideally after G27/G28 land on
  vite.config.ts, per this gap's own wave-3 deferral rationale).
- Evidence: dist/assets/index-B5xxi65X.js = 6,862,945 bytes (gzip 1.30 MB) in one chunk;
  vite.config.ts chunkSizeWarningLimit=10000 suppresses the default >500 kB warning.
  three.js, deck.gl, streetscape.gl, react-force-graph-3d load eagerly.
- Fix: add rollupOptions.output.manualChunks (split heavy vendors) and/or React.lazy the
  wargames views; restore the default warning limit.

### G46 — No typecheck or lint gate before the Pages build

- Lens: web-ui
- Status: BLOCKED
- Blocked (2026-07-12, gap-closing workflow): web/mfact-ui and
  .github/workflows/deploy-pages.yml do not exist in the dispatched worktree
  (worktree-wf_24b4eb65-119-23, HEAD=945bfca). `ls web` => No such file or directory;
  `ls .github/workflows/deploy-pages.yml` => No such file or directory;
  `git merge-base --is-ancestor 6cbc680 HEAD` => "no (my HEAD predates it)" — 6cbc680 is
  the commit that introduced web/mfact-ui, deploy-pages.yml, and the ci.yml test-e2e job
  this gap targets. This worktree's own ci.yml is a pre-6cbc680, Lean-only generation
  (build-mfact/build-procint jobs only, no web-ui job) with nothing to add a gate to. No
  changes made. Recommend re-dispatching from a worktree branched at/after 6cbc680.
- Evidence: package.json build is bare `vite build` (no tsc); deploy-pages.yml runs only
  npm install + build, though typescript and oxlint are devDependencies and a lint script
  exists. With src/ heavily modified and uncommitted, type errors would deploy silently.
- Fix: `tsc -b && vite build` (or separate `tsc --noEmit` + `npm run lint` steps in
  deploy-pages.yml/ci.yml before build).

### G47 — STANDING.md cites generated/evaluation.tex, which does not exist

- Lens: tickets-truth
- Status: CLOSED
- Closure evidence (2026-07-12, gap-closing workflow): deleted the dangling
  `generated/evaluation.tex` citation from STANDING.md:152, leaving only the valid
  `release/certify.log` citation (commit 2f4f0b5, merged via c0750ee). Post-merge:
  `git grep -n "generated/evaluation.tex"` => no matches anywhere in the tracked repo
  (exit 1); `grep -n "certify.log\|generated/" STANDING.md` => only line 152, `release/
  certify.log`, never typed from memory.` — matches the corrected wording exactly.
- Evidence: STANDING.md:152-153 says fields are computed by commands recorded in
  release/certify.log and "generated/evaluation.tex's header comment"; no generated/ dir
  exists. certify.log exists; the second citation dangles.
- Fix: point the reference at the actual rendered fragment under paper/, or delete it.

### G48 — jira index drift: ticket 011 missing; ticket_012 companions unindexed

- Lens: tickets-truth
- Status: CLOSED
- Closure evidence (2026-07-12, gap-closing workflow): added a placeholder "011" row
  noting the numbering gap is intentional, and split the single ticket_012 row into three
  rows (crown_countermodel, receipt, workflow_state) matching the files actually on disk
  (commit a94ed53, merged via 7092cfe). Post-merge: `ls .../tickets/ | grep -c
  ticket_011` => 0; `ls .../tickets/ | grep -c ticket_012` => 3; `grep -c '^| 011'
  index.md` => 1; `grep -c 'ticket_012_' index.md` => 3 — all four counts match the
  corrected index exactly.
- Evidence: pylab/docs/jira/26.7.7/tickets/index.md has one row per number (no dupes),
  but ticket_011 is absent from disk and index; ticket_012 has three files on disk
  (crown_countermodel, workflow_state, receipt) while the index lists only
  workflow_state.
- Fix: note the 011 gap as intentional (or fill it) and list the ticket_012 companion
  files in index.md.

### G49 — mfact-core `turbulence` binary fails to build: undefined `simulate_workload`

- Lens: self-improvement-loop (fix loop, first successful firing under the v3
  delta-based collision guard)
- Status: CLOSED
- Closure evidence (2026-07-13, cron job f6a6cd52): `crates/mfact-core/src/bin/
  turbulence.rs:16` called `simulate_workload`, a function that was never defined —
  `cargo check --all-targets` failed with `error[E0425]: cannot find function
  'simulate_workload' in this scope`. The removed doc comment claimed the synthetic
  simulation was "removed in favor of empirical ingestion", but `grep -rn
  "empirical.ingestion|empirical_data"` across the crate found no such replacement
  anywhere — a stale, unfalsifiable claim, not a real migration. Implemented a real
  `simulate_workload` (a genuine scalar CPU loop using `std::hint::black_box` so the
  compiler cannot optimize it away, matching the function's stated purpose of
  measuring per-task cost in the density/throughput benchmark) rather than a stub.
  Re-verified: `cargo check --bin turbulence` → exit 0, and `cargo run --bin
  turbulence` (10s timeout) actually executes and prints real benchmark output rather
  than panicking immediately. `tests/sse_transport_test.rs`'s separate, pre-existing
  break (missing `tokio`/`reqwest_eventsource` deps) is untouched — out of scope for
  this item.

### G50 — `scripts/stuck_item_guard.py` implemented but not wired into `just` or the loop doc

- Lens: self-improvement-loop (fix loop, firing 4), cross-referencing
  `PRAXIS_SELF_AUDIT.md` findings PC6/PD4
- Status: CLOSED
- Closure evidence (2026-07-13, cron job f6a6cd52): `scripts/stuck_item_guard.py`
  existed and worked (`python3 scripts/stuck_item_guard.py` → real output against
  the 3 real receipts on disk) but `grep -n "stuck_item_guard"` against `justfile`
  and `MFACT_SELF_IMPROVEMENT_LOOP.md` returned nothing — legitimately in scope,
  simply unwired. Added a `just stuck-item-guard` recipe and a cross-reference in
  `MFACT_SELF_IMPROVEMENT_LOOP.md`'s "Stuck-item guard" section. Re-verification
  caught a real bug before commit: the recipe was first written passing the
  receipts directory as a positional argument, matching the neighboring
  `trajectory-annotate` recipe's convention, but `stuck_item_guard.py`'s own
  `argparse` definition requires `--receipts DIR` — `just stuck-item-guard` failed
  with `unrecognized arguments` on the first attempt. Corrected to `--receipts
  .mfact/receipts/`; re-ran and confirmed exit 0 with correct output ("3
  receipt(s) considered ... Nothing flagged").

### G51 — mfact-core has no `[lints]` gate despite live unwrap/todo/dbg risk

- Lens: self-improvement-loop (fix loop, firing 5), from
  `PRAXIS_DOGFOODING_EXPLORATION.md` CROSS_REPO_INCONSISTENCY #9
- Status: CLOSED
- Closure evidence (2026-07-13, cron job f6a6cd52): `grep -n "\[lints"
  crates/mfact-core/Cargo.toml` returned nothing. Added `[lints.clippy]`
  (todo/unimplemented/dbg_macro = deny; unwrap_used/expect_used = warn) plus a
  `just clippy-core` recipe scoped to the crate's two real compiled targets
  (`--lib --bin turbulence`); `src/main.rs` and `tests/sse_transport_test.rs`
  are untracked dead-pile files (G2/G11) that fail to compile independent of
  lints — recipe comment says to widen when G2/G11 closes. All 5 pre-existing
  `.unwrap()` occurrences are inside `#[cfg(test)]` code, exempt per house
  style, and surface only as warns. Verified with a negative control: an
  injected `dbg!("negative-control")` failed the gate with `-D
  clippy::dbg-macro`; after revert, `just clippy-core` → exit 0. Note: this
  firing was itself blocked once by `.claude/hooks/require-just.sh` when it
  tried a bare `cargo clippy` — the hook worked as designed and forced the
  recipe to exist.

## Refuted during verification

Findings below were disproven by the adversarial pass and must not be re-reported.

### R1 — "All 16 topological-bridge Lean files are empty; Phase 1 backed by zero content"

- Lens: research-papers | Claimed severity: release-blocking
- Refutation: the emptying is entirely UNSTAGED working-tree modification (nothing
  committed; `git diff --cached` empty). Committed HEAD retains real proofs with 0 sorry
  (RandomWalk.lean 4990 bytes, PairCorrelation.lean 892 B, QuantumHall.lean 1120 B,
  Smfdcca.lean 717 B), no release was cut from the dirty tree, and the finding's own
  remedy (`git checkout -- research-papers`) proves the content sits in the object store.
  A transient uncommitted diff, restorable in one command. The adjacent real concern —
  ROADMAP over-claim vs thin committed content (star_graphs/scalar_dissipation stubs,
  untracked revops_turbulence) — is tracked separately as G13.

### R2 — "Live verifier gates read FAIL while standing projects PASS (failing gates hidden)"

- Lens: verifier-report | Claimed severity: release-blocking
- Refutation: the finding's own cited command displays the FAILs in plain view —
  `scripts/report.py status` prints `evidenceComplete=FAIL countermodel_not_promoted=FAIL`
  on the gates line and cmd_next surfaces them with a remediation hint. The gates are
  exposed, not hidden, and the report reads the live gates.json. Also,
  `countermodel_not_promoted=false` and `WFNET_INFINITE_TRANSITION_COUNTERMODEL=PROVEN`
  are the same fact rendered twice (both derive from the manifest), so they agree rather
  than contradict. The real residuals are tracked as G1 (certify fails) and G4 (stale
  countermodel guard).

### R3 — "CERTIFIED_RELEASE=PASS is asserted over a stale certify.log; current gates fail"

- Lens: tickets-truth | Claimed severity: release-blocking
- Refutation: the finding conflates the frozen tagged release with the live working
  manifest — a flattening FINAL_STATUS.md:6 explicitly forbids. At the tag
  (`git show v26.7.7-procint-certified:release/gates.json`) ALL five gates are true and
  the foldHash chain (certify.log = final_status coreReleaseHash = 942facf3) is
  self-consistent: certification was legitimately earned for the artifact it names. The
  two-false-gates state is a working-tree regression honestly surfaced in standing.env.
  Its fix premise is also false: `mfact certify` (src/main.rs:168-216) never reads gate
  booleans. The genuine working-tree regression is tracked as G1/G4/G5.

## References

- `AGENTS.md` — Constructive Exploit discipline this ledger enforces
- `release/standing.env`, `release/gates.json`, `release/final_status.json` — status
  surfaces audited above
- `scripts/build_manifest.py`, `scripts/rigor_linter.py`, `justfile` — generators and
  gates named in fix sketches
- `ROADMAP_GAP_AUTONOMIC.md`, `ROADMAP_GAP_SEMANTIC.md`, `ROADMAP_GAP_THERMO.md` —
  sibling gap docs (untracked; see G12)
