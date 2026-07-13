# RELEASE_v26.7.13 — Product Requirements Document

This is the first PRD this repository has produced for a core release. No prior PRD precedent
exists at repo root (the only file matching that name pattern is `PYLAB-PRD-ARD-v26.7.7.md`,
scoped to `pylab/`). This document is modeled on `GAP_LEDGER_v26.7.12.md`'s and the
`ROADMAP_*.md` family's conventions: descriptive title, an `Updated <date>` line, inline
citations near point of use, and a numbered-section severity/status table for the open-gap
inventory (§3) matching `GAP_LEDGER_v26.7.12.md`'s own "Quick reference" table shape.

Updated 2026-07-13.

Companion document: `RELEASE_v26.7.13_ARD.md` covers architecture (cross-layer Lean bridges,
correspondence-table status, No-Ambient-Theorem-Authority enforcement). This document covers
what a consumer or maintainer actually gets: deployed surface, workstream inventory, open
gaps, and non-goals.

## 1. What this release delivers to a consumer — honestly scoped

- **A live demo web UI** at `https://seanchatmangpt.github.io/mfact/`
  (`gh api repos/seanchatmangpt/mfact/pages` confirms `"status":"built"`), mostly placeholder
  screens plus two working panels. `web/mfact-ui` is a React 19 + Vite SPA
  ("MFACT // Autonomic SAFe") with 10 tabs (overview, LPM, product-dev-flow,
  revops-turbulence, devops, math-topologies, unrdf-semantics, wargames-sim,
  peer-discovery, research-papers). Of these, `overview` is static hardcoded metrics,
  `unrdf-semantics` does real TTL ingestion plus a 3D semantic-graph viewer, and
  `wargames-sim` has real implementation; the rest are stubs (`peer-discovery` literally
  reads "NO ACTIVE PEERS FOUND"; unmatched routes render "WAITING FOR DATAFRAME
  RESOLUTION"; the paper viewer says "AWAITING IPFS RESOLUTION"). `web/mfact-ui`'s own
  `README.md` is still the unedited stock Vite template — there is no consumer-facing
  documentation for the UI at all.
- **The deployment path for that UI is not the one this branch built.** The live Pages site
  was hand-deployed (`gh api .../pages/builds/latest` shows `created_at
  2026-07-12T02:47:11Z`, pusher `seanchatmangpt`, not an Actions run — i.e. `npm run deploy`
  → `gh-pages -d dist`). `.github/workflows/deploy-pages.yml` exists on this branch but is
  **not on `origin/main`** (`git show origin/main:.github/workflows/deploy-pages.yml` fails;
  `origin/main` is still at `945bfca`, 2026-07-07, five days stale relative to this branch's
  merge-base). The automated CI deploy path is built but unmerged and unwired for this
  release. Freshness of the currently-live site relative to this branch's current `App.tsx`
  is unverified from the repo alone.
- **The `web/mfact-ui` gitlink is mid-edit, not a clean release commit.** Pinned commit
  `1ba3a9b`; working tree checked out at `40dc87a-dirty` (`git ls-files -s web/mfact-ui` /
  `git diff -- web/mfact-ui`, both re-verified live). Any consumer building from a clean
  checkout of this branch gets the submodule at `1ba3a9b`, not the dirty tree that produced
  the live Pages screenshots.
- **A `just` recipe surface for reproducing certification** — the certify leg is now green
  (re-verified 2026-07-13; `just check`/`just release` were not re-run). A consumer would
  run `just check` → `just certify` → `just release`. **Correction (2026-07-13):** an earlier
  draft of this bullet reported a live-reproduced certify failure
  (`gate failure: sorryFree=true axiomsClean=true fixturesPass=true evidenceComplete=false`,
  exit 1, with `release/gates.json` recording `evidenceComplete=false` and
  `countermodel_not_promoted=false`). That failure was root-caused and fixed after the
  passage was written: `0e99a2b` (triple-quoted `auditMsg` values silently read as empty by
  `scripts/build_manifest.py`) and `ca3cf5c` (literal `\n` escape stripped from axiom names),
  with the regenerated manifest/gates/certify.log committed in `b2f5b0e`. A fresh
  `just manifest && just certify` re-run for this correction (2026-07-13, HEAD `ee624be`)
  exits 0 and prints `certified: v26.7.7 (proven 203/401, objection type uninhabited)`
  (`release/certify.log:2394`); `release/gates.json` now records `evidenceComplete=true`.
  This is deliberately not overclaimed: `release/gates.json` still records
  `countermodel_not_promoted=false`, and the certify binary never checks that gate — G4
  remains OPEN (§3.1). The certified version string is still `v26.7.7`, not `v26.7.13`
  (G6). The other cockpit findings originally reported alongside the certify failure
  (tag-ancestor check failure, `rigor_linter.py` flags, uncommitted working-tree paths)
  were not re-checked for this correction and are neither reasserted nor withdrawn here.
- **Packaged release artifacts are stale relative to this branch's own content, by three
  different counts that disagree with each other.** `release/standing.env`'s header says
  "release v26.7.6" while `STANDING.md`'s prose says "Release `v26.7.7`" — two version
  strings in the same certification pair (both re-read live). Proven/total counts: the live
  `release/release-manifest.json` shows **401 artifacts, 203 proven**
  (`python3` count against the live JSON, re-run for this document); `STANDING.md`'s ladder
  table shows **318 declarations, 145 proven**; `dist/github-release/title.txt` shows
  **397 total, 197 proven** (`mfact v26.7.7 — procint certified (197/397 proven, quadrature
  closed)`, re-read live verbatim). None of the three match. None of the shippable release
  artifacts (`dist/`, `release/FINAL_STATUS.md`, `release/quadrature.*`) have been
  regenerated for this branch's actual content.
- **A freshly-vendored, not-yet-integrated documentation set.** `docs/testing-atlas/` (93
  files: 36 Mermaid diagrams, 37 LLM guides, a 133-test-type/30-family catalog, 12 Lean/Lake
  templates) landed in the final commit of this branch (`f735022`). Its own `README.md`
  self-labels `Status: BUILD_NOT_RUN` — "teaching and design artifacts... No Lean or Lake
  build was invoked while manufacturing this directory" (re-read live, confirmed verbatim).
  `docs/TESTING_ATLAS_INTEGRATION.md` — the doc that would connect this atlas to mfact's own
  gates/CI — does not exist anywhere in the tree; this is in-progress/not-yet-landed, not
  absent by omission.

**Bottom line:** the mathematical/formal-verification core genuinely grew this branch (401 vs
318 declarations — see `RELEASE_v26.7.13_ARD.md` §2 for what specifically), but the
consumer-visible packaging (standing report, release manifest, GitHub-release text, Pages CI
wiring) has not caught up. `just manifest && just certify` and `just regen-check` need to be
re-run and the drift resolved before a `v26.7.13` tag can honestly claim
`CERTIFIED_RELEASE=PASS`.

## 2. Workstream inventory

Nine workstreams span the 78 commits (`main..HEAD`, merge-base `c0ffeed3`, 399 raw diff
entries / 398 files changed, +76,622/-748 lines — `git diff --stat`, re-verified live).

1. **v26.7.12 gap-ledger tail closure** (`154b62f`, `118ec78`, `61468b4`, `587d307`,
   `a94ed53` plus paired `merge:-G*` commits `32a8189`..`c0750ee`, `7092cfe`, `9983df2`).
   Closes six pre-existing gaps: G9 (hand-injected type-inventory hash), G10 (mfact-core did
   not compile), G33, G34, G47, G48. Tooling fixes and doc corrections, not new theorems.
2. **ProcInt Lean Playground rail expansion + CI wiring** (`ff01033` .. `81484c6`, 11
   commits). Adds four new Lean "rail" subtrees (Experimental, MFW/POWL, Swarm11,
   Multifractal) and — critically — relocates 12 Lean CI workflow YAMLs from
   `research-papers/<pkg>/.github/workflows/` to the repo-root `.github/workflows/`, because
   GitHub Actions silently ignores non-root workflow YAML; none of the 12 research-paper Lean
   packages had ever actually run in CI before this fix (`e248101`'s commit message).
3. **arXiv:2607.09510 trajectory taxonomy + self-improvement loop infra** (interleaved,
   `4fabb1c` .. `d2e6d01`). A cron-driven fix loop with JSON receipts
   (`.mfact/receipts/<run_id>.json`, 13 files present), a parallel self-audit loop, 10 custom
   Claude Code sub-agents, and 4 hooks (`.claude/agents/*.md`, `.claude/hooks/*.sh`). Two
   small Lean files formalize the paper's *taxonomy shape* only — the paper itself is cited
   as empirical methodology, explicitly not lending theorem standing per `AGENTS.md` §4.
4. **`PRAXIS_SELF_AUDIT.md` recurring self-audit loop** (`02e7a5e`, `cd911f9`, `e0366b4`,
   `98263a9`, `804f39c`, `f81790a`, `16322a5`, `5ee8573`). 14 independent re-verification
   passes (Pass 2 through Pass 15) accumulated into a single audit ledger, several of which
   re-check and correct earlier passes' own claims.
5. **8-wave cross-layer Lean bridges + Fortune-5 cloud ontology vendoring**
   (`0956080`..`98263a9`). Vendors a 34,718-line cloud-architecture ontology TTL
   (`ontology/fortune5-cloud-architecture.ttl`, `wc -l` reconfirms 34718) and builds the
   9-file cross-layer bridge construction detailed in `RELEASE_v26.7.13_ARD.md` §2.
6. **SOC2 TSC correspondence + two-tenant audit-flow witness** (`852d343`, `8338516`,
   `bb25faf`, `84ab3de`). Builds `ROADMAP_SOC2_MATH.md` and `SOC2/AuditFlow.lean` (535 lines,
   0 `sorry`), independently rebuilt via `just _lake` per the commit message (OrientedSwapReplay
   544 jobs, ManufactureTenancyGap 726 jobs, full Playground umbrella 8713 jobs, all green;
   `#print axioms` on all 7 new top-level theorems shows dependence only on
   `[propext, Classical.choice, Quot.sound]`).
7. **`crates/mfact-core` Rust cleanup** (`0639081` G51 clippy gate, `eabe589` G49,
   `c636fd3` G50, `108bf5b`/`5608deb`/`05f64df` G11). Deletes the dead/fake Lean-FFI
   apparatus and leaves a 3-file `src/` (`lib.rs`, `receipt.rs`, `validate.rs`) plus
   `src/bin/turbulence.rs`. `build.rs` is now `fn main() {}` (verified live) and `Cargo.toml`
   carries no `cc` build-dependency (verified live) despite G10 having added one earlier in
   the same branch — G11 followed and reverted it as dead. A `[lints.clippy]` gate
   (`todo!`/`unimplemented!`/`dbg!` deny, `.unwrap()`/`.expect()` warn) was added under
   `0639081`.
8. **Lean Testing Atlas vendored** (`f735022`, final commit). 93 files, explicitly
   `BUILD_NOT_RUN` / teaching-and-design only — see §1.
9. **research-papers stub scaffolding + new roadmap docs.** 11 new stub Lean packages under
   `research-papers/` (bio_signals, hyperdimensional_cognitive, minimal_measures, ortac_plus,
   pair_correlation, quantum_hall, random_walk, scalar_dissipation, signal_criticality,
   smfdcca, star_graphs), each a 1-line `Basic.lean` stub with matching `lakefile.toml` and
   `ontology.ttl`. Seven new root `ROADMAP_*.md` docs plus `MFW_WORKFLOW_CATALOG.md`
   (2,587 lines).

**Caution carried into this inventory:** despite several individually `sorry`-free new files
(`AuditFlow.lean`, `ManufactureTenancyGap.lean`, `OrientedSwapReplay.lean` — all reconfirmed
`0` via live `grep -c '\bsorry\b'`), the `procint` tree as a whole still contains 566 `sorry`
occurrences across 15 touched-or-added files (live count). "Kernel-checked" claims in this
release are scoped file-by-file, never tree-wide.

### Addendum (2026-07-13, post-f735022)

The inventory above is pinned to HEAD `f735022` (the "78 commits" figure in this section's
opening line). Live HEAD has since moved 29 commits past `f735022` (`git log --oneline
f735022..HEAD | wc -l`, measured at HEAD `5e7c94b` while writing this addendum). The
substantive post-`f735022` clusters, none of which appear in workstreams 1-9 above:

- **Operation Dogfood Waves 0-5** (`46f81ee` Wave 0 coverage report, `b6dcfb3` Wave 1
  outcome algebra, `8f7c032` Wave 2 pre-actuation guard, `8a7ceca` Wave 3 lifecycle,
  `40a35df` Wave 4 POWL boundedness rescue, `81fbbad` Wave 5 axiom audit + verifier fold).
  `GAP_LEDGER_v26.7.12.md` entries G54-G57 are all `Status: CLOSED` (re-verified live);
  `swarm11-verify` now reports 5 crown + 24 SOC2 + 30 dogfood = 59 checks, 0 failures,
  `admitted: true`; all 49 new theorems are axiom-audited in
  `procint/ProcInt/Playground/Dogfood/AxiomAuditDogfood.lean` (49 `#guard_msgs` pairs,
  re-counted live).
- **SOC2 audit-flow crowns** (`e590d1b` two-tenant audit-flow axiom-audit crown, `c481ecd`
  `StandingPathSOC2.lean` witness + Swarm11Verifier SOC2 fold).
- **G53 closure** (`11b03d2` compose `ManufactureStep` with tenant residue, `050d067` wire
  `ManufactureTenancyGap.checks` into swarm11-verify).
- **The `evidenceComplete` certify-fix chain** (`0e99a2b`, `ca3cf5c`, regen committed in
  `b2f5b0e`) — already reflected in §1's and §4's dated corrections above.
- **`.gitmodules` fix** (`032abc3`) — registers the `web/mfact-ui` gitlink whose absence G25
  flagged (§3.1); G25's ledger entry still reads `Status: OPEN` and is not re-scoped here.

Claim-row deltas earned by the Dogfood waves (C11 MISSING-ABLE→PARTIAL, C5/FR-9
MISSING-ABLE→PARTIAL, FR-22's by-construction crutch lifted, and eight further strengthened
rows) are recorded once, in `OPERATION_DOGFOOD_LEAN_COVERAGE_v26.7.13.md`'s
"Post-construction verdicts" table — deliberately not duplicated here; that table is the
authoritative row-level record. The remaining post-`f735022` commits are self-audit passes
16-19 (`PRAXIS_SELF_AUDIT.md`), loop receipts, and doc corrections, including `5e7c94b`'s
correction of this document's own stale certify-failure claims.

## 3. Open gap list

Source: `GAP_LEDGER_v26.7.12.md`, freshly re-grepped against live HEAD (`f735022`).

### 3.1 Literal `Status: OPEN` — 22 of 51 entries (live count, re-verified)

- **G1** — Fresh `just certify` FAILS while `standing.env`/`final_status` assert CERTIFIED
  PASS — **corrected 2026-07-13: the failure no longer reproduces.** Fixed by
  `0e99a2b`/`ca3cf5c` (regen committed in `b2f5b0e`); a fresh `just manifest && just certify`
  now exits 0 with `certified: v26.7.7 (proven 203/401, objection type uninhabited)` (see
  §1). Residual: `countermodel_not_promoted=false` is still recorded in `release/gates.json`
  and never checked by the certify binary — that is G4, which remains OPEN.
- **G4** — Countermodel promoted STATED→PROVEN; `countermodel_not_promoted` guard is computed
  but never checked by `GateResults`.
- **G5** — Three drifted count/hash lineages (manifest 401/203, `final_status` 197/397,
  `STANDING.md` 318/145), none flagged as drift — **independently reconfirmed live for this
  document, all three counts** (see §1).
- **G6** — No v26.7.12 identity anywhere; `standing.env` header says v26.7.6, generator
  hardcodes v26.7.7 — **reconfirmed live**.
- **G7** — `standing_guard_receipt.json` has 58 REFUSED entries while standing reads
  ALIVE/PASS.
- **G8** — Replay lane frozen at v26.7.7; its expected core-release hash no longer
  reproduces from HEAD.
- **G12** — Ledger text claims mfact-core sources + 5 roadmap docs are untracked — **this is
  now stale**: a live `git ls-files` shows all six roadmap docs tracked and clean, and the
  mfact-core files G12 names (broker.rs, lean.rs, etc.) are fully deleted (not merely
  untracked) as of the G11 cleanup. Needs re-scoping or closing before v26.7.13, not carried
  forward as-is.
- **G13** — Core-Five "Constructed & Verified" claim has no `lake build` behind it
  (star_graphs/scalar_dissipation still near-empty).
- **G16** — Phase-2 domains 8-11 (Sparse Chaos, Terminal Breakdown, Weighted Random Networks,
  Combinatorial Topology) have zero `.lean` while Rust ships their runtime functions.
- **G17** — Vacuous "Core Theorem" proofs at HEAD in `pair_correlation` and `smfdcca`
  (hypotheses unused / trivial field-projection).
- **G18** — Claimed "Zero-Cost" Lean↔Rust typestate bonding does not exist anywhere in
  `crates/`.
- **G19** — Four substantive procint Lean modules (`Workflow.Multifractal`, `Graph.Semantic`,
  `Planning.SemanticBridge`, `Thermo`) are orphaned from every build target and the axiom
  audit.
- **G23** — `paper/main.tex:711` calls the D1 Aeneas correspondence "PROVEN" while its own
  table says DECLARED.
- **G24** — Documented `just prose-lint` 8-rule gate is unimplemented; doc cites a forbidden
  `~/praxis` path.
- **G25** — `web/mfact-ui` is an unregistered gitlink (no `.gitmodules`); CI/Pages checkout
  gets an empty dir.
- **G26** — The UI code that actually builds is uncommitted inside that gitlink —
  **reconfirmed live**: 40dc87a-dirty (see §1).
- **G31** — mfact-core's receipt/validate engine is reachable only from tests;
  `parse_manifest` has zero references anywhere.
- **G32** — `broker.rs` comments a POWL depth cap of 256 but passes 513 with no clamp.
- **G37** — 9 dirs have stale `.lake/build` outputs for now-0-byte sources (ledger's own
  status text hedges: "evidence partially unverified").
- **G41** — Phase-15 verifier report is prose only; marker never emitted, 6/13 fields have
  zero instrumentation.
- **G42** — `standing.env`'s regen hint points at a dead scratchpad path instead of
  `just manifest && just certify`.
- **G44** — The documented prose-lint rules, if actually wired, would fail today's paper
  text.

### 3.2 Non-OPEN but unresolved — 16 additional entries

- **BLOCKED (14, need re-dispatch, no fix landed):** G2, G14, G15, G27, G28, G29, G35, G36,
  G38, G39, G40, G43, G45, G46 — each blocked purely on a stale worktree base per the
  ledger's own run log; a re-dispatch or a direct fix in the main checkout is required.
- **PARTIAL (1):** G30 — no single Phase-15 verifier-report artifact exists; fields scattered
  across partial surfaces.
- **CLOSED with a disclosed residual (1):** G11 — closed Rust-side, but
  `web/mfact-ui/src/wargames/useWargames.ts:88-89`'s `initStream` still calls a dead
  `EventSource('http://localhost:8080/stream')`, uncalled anywhere
  (`PRAXIS_SELF_AUDIT.md` PO7).

### 3.3 Additional open items surfaced by `PRAXIS_SELF_AUDIT.md`, not yet in the gap ledger

- **PO1 (Pass 15, DRIFTED/major):** G11's earlier closure left `build.rs` referencing a
  just-deleted file — now fixed on disk (**reconfirmed live**: `build.rs` is `fn main() {}`,
  no `cc` build-dep), but no self-audit pass has confirmed the fix under a real `cargo build`
  with `lean`/`lake` on `PATH` (the sandboxed audit shell lacks both; a real login shell has
  `~/.elan/bin` wired).
- **No self-audit pass has ever run `lake build`/`lake env lean`** on this session's new Lean
  content (Pass 14 PN11: `UNVERIFIABLE`; Pass 12 PL10: grep-only proxy, weaker than a rank-1
  build re-run). This applies to all 9 bridge files in `RELEASE_v26.7.13_ARD.md` §2 as well —
  their completeness rests on source inspection and `.olean` timestamps, not an independently
  re-run build.
- **`.mfact/known-persistent-drift.txt` is stale** (flagged in Pass 12, 13, and 15; still
  stale on a fresh check — **reconfirmed live**: 76 lines, still listing 8 of the 9
  `crates/mfact-core` files G11 deleted).
- **`PRAXIS_SELF_AUDIT.md` itself is 7 commits stale** relative to live HEAD; two of those
  commits (`84ab3de` Wave 7 confluence proof, `f735022` Testing Atlas vendor-drop) have no
  corresponding self-audit pass yet.

### 3.4 Standing decision explicitly deferred (not a gap — a fork)

Whether `CLAUDE_ROADMAP.md` Phases 1/5-7 specify praxis's already-running
`multifractal-workflow` Rust crate, or are an independent reformulation, is repeatedly flagged
across `ROADMAP_CLOUD_MATH.md`, `MFW_WORKFLOW_CATALOG.md`, and
`PRAXIS_DOGFOODING_EXPLORATION.md` §4 item 1 as the single largest open architectural fork in
the whole survey — and every one of those documents declines to decide it. This PRD does not
resolve it either; see `RELEASE_v26.7.13_ARD.md` §5.

## 4. Non-goals for this release

- **Not a SOC2 compliance claim.** `ROADMAP_SOC2_MATH.md`'s own words: "No theorem in this
  repository is, or could ever be, SOC 2 compliance." The SOC2 correspondence-table work in
  this branch (§1 of the ARD) produces workflow-side theorems only; every production-side
  binding remains `ANALOGY` or `MISSING`.
  Compliance/audit teams — see `ROADMAP_SOC2_MATH.md` §3(a) and §5.
- **Not a certified v26.7.13 release.** Correction (2026-07-13): the certify failure this
  bullet previously cited (`evidenceComplete=false`) was fixed in `0e99a2b`/`ca3cf5c` (regen
  committed in `b2f5b0e`), and a fresh `just manifest && just certify` now passes — exit 0,
  `certified: v26.7.7 (proven 203/401, objection type uninhabited)` (see §1). That does not
  make this a certified v26.7.13 release: `release/gates.json` still records
  `countermodel_not_promoted=false`, a gate the certify binary never checks (G4 OPEN), and
  the certified version string is `v26.7.7`, not `v26.7.13` (G6). No `v26.7.13` tag should
  be cut, and no `CERTIFIED_RELEASE=PASS` claim should be made for v26.7.13, until G4 is
  resolved and `just regen-check` shows no drift.
- **Not a UI ship.** `web/mfact-ui` is a mostly-placeholder demo, deployed by hand, from a
  dirty gitlink checkout, with no consumer documentation. It is not being represented here as
  a production-ready product surface.
- **Not a resolution of the CLAUDE_ROADMAP/multifractal-workflow question** (§3.4) — carried
  forward unresolved, as it has been across every document in this branch that raised it.
- **Not a genuine multifractal proof.** The Wave 3 scaling-law result
  (`RELEASE_v26.7.13_ARD.md` §2) is monofractal (uniform Lebesgue measure) only; a
  two-weight/Bernoulli-cascade witness is explicitly out of scope, blocked on the current
  Mathlib pin.
- **Not a fix for the 14 BLOCKED gaps (§3.2)** or the 22 literal-OPEN gaps (§3.1) — this
  release's workstreams (§2) closed a different six gaps (G9, G10, G33, G34, G47, G48) in an
  earlier firing; the remainder are carried forward as this release's known-open inventory,
  not addressed by any commit inventoried in §2.

## See Also

- `RELEASE_v26.7.13_ARD.md` — architecture: the cross-layer bridges and correspondence-table
  status referenced throughout §1-§3 above.
- `GAP_LEDGER_v26.7.12.md` — full gap entries, status legend, and severity table for §3.
- `AGENTS.md` — the Combinatorial Maximalism Mandate and No Ambient Theorem Authority law
  this document's non-goals (§4) are written under.
- `STANDING.md` — the (currently stale) certified-release status document referenced in §1.
- `PRAXIS_SELF_AUDIT.md` — the 14-pass self-verification ledger referenced in §3.3.
- `justfile` — the `check`/`certify`/`release`/`regen-check` recipe chain referenced in §1.
