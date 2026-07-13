# Praxis Self-Audit Ledger

This is the continuity file for the recurring self-audit loop that fires every 30
minutes against `/Users/sac/mfact`. The loop applies the exact same adversarial
verification discipline this session used on four externally-authored Lean packages
(catching a false theorem count, a false "0 sorry" claim, a fabricated
STATIC_AUDIT.json, and a false kernel-checked receipt) back onto this session's own
commit messages, doc comments, and standing files. A commit message, a marker value,
or a prior tool-result summary is never evidence on its own; only a freshly re-run
command against the live tree, with its literal output, counts as evidence here. See
`AGENTS.md` for the construction discipline this enforces and
`GAP_LEDGER_v26.7.12.md` for the sibling ledger this file cross-references and does
not duplicate (gap-ledger-staleness findings below name specific G-numbers there).

## Status legend

| Status | Meaning |
|---|---|
| CONFIRMED | Claim reproduced verbatim against the live tree right now |
| REFUTED | Claim is false today; live reproduction contradicts it directly |
| DRIFTED | Claim was true at commit time but the tree has since moved past it, or |
| | the claim is technically true but misleading (e.g. built but unreachable) |
| UNVERIFIABLE | No independent evidence exists in-repo to confirm or refute |
| FIXED-since-last-pass | A prior REFUTED/DRIFTED finding that a later commit closed |

## Run log

- **2026-07-12 (pass 1, first run):** 45 findings across 6 lenses
  (lean-session-work, release-standing-drift, roadmap-marker-schema,
  agents-md-self-compliance, ci-workflow-reverify, gap-ledger-staleness) applying
  adversarial re-verification to this session's own commit claims. 15 REFUTED
  (7 critical), 14 DRIFTED, 14 CONFIRMED, 2 UNVERIFIABLE. Headline: the underlying
  Lean proofs added this session (NewmanCorrespondence, MFW/Residue Wave M0,
  countermodel promotion) are genuinely kernel-checked with clean axiom lists, but
  every layer *around* them -- release standing files, orphaned Rust FFI modules,
  roadmap achievement markers, the gap ledger itself -- carries claims that no
  longer match the live tree. This file created for the first time this pass.
- **2026-07-12 (pass 2):** 23 findings across 5 lenses (unexplained-modifications,
  dogfooding-report-spotcheck, agents-md-self-consistency, pass1-refuted-recheck,
  roadmap-and-loop-ledger-sanity), auditing what is new or unexplained since pass 1 (HEAD
  unchanged at fb23ef5; the parallel fix-loop, cron 8123599b, had not yet landed any commit). 9
  CONFIRMED, 7 REFUTED, 7 DRIFTED, 0 UNVERIFIABLE, 0 FIXED-since-last-pass. Headline:
  research-papers/ suffered a mass truncation of 16 tracked Lean files to 0 bytes, clustered at
  the same second as a ggen receipt regeneration and concurrent multi-worktree activity (PB1,
  critical); an uncommitted release/standing.env edit flips
  WFNET_INFINITE_TRANSITION_COUNTERMODEL from STATED to PROVEN, which is manifest-consistent yet
  is also the exact promotion scripts/countermodel_negative_controls.sh exists to refuse (PB2,
  critical); and pass 1's own critical REFUTED findings on release certification (PA11, PA12)
  reproduce unchanged. This pass found no evidence that any uncommitted change originated from
  this session rather than the externally-writing ~/praxis automation the task flagged.
- **2026-07-13 (pass 3):** 8 findings (distilled from a broader sweep across 5 lenses:
  workflow-status-and-collision, taxonomy-lean-reverify, stuck-item-guard-scope-check,
  case-study-honesty-check, unresolved-modifications-recheck), auditing the 10-agent
  w3xrg1r0m workflow ("implement arXiv:2607.09510's trajectory-failure taxonomy") that
  landed mid-pass. HEAD moved twice during this very pass: 4fabb1c (w3xrg1r0m's own
  commit, 00:17:20) then c741d46 (fix-loop cron 0e35feb8's first-ever firing, 00:18:52).
  6 CONFIRMED, 1 REFUTED, 1 DRIFTED, 0 UNVERIFIABLE, 0 FIXED-since-last-pass. Headline:
  w3xrg1r0m completed cleanly (all 10 staged files landed in one commit) and the fix
  loop's collision guard passed its first real test -- it detected the in-flight staged
  work, wrote a status:failed/collision:true receipt, and touched nothing else outside
  its own bookkeeping, independently confirmed via both the receipt file's content and
  4fabb1c's own corroborating commit-message account of the same event. The 6
  long-standing unattributed files from passes 1-2 remain byte-identical (frozen mtime
  2026-07-12 17:12:27) and still unattributed into a third pass; web/mfact-ui's drift is
  now confirmed to be a distinct, older (16:54:05), separate defect -- its submodule
  pointer has both moved to a different commit and gone dirty, not just a plain edit.
- **2026-07-13 (pass 4):** 8 findings across the same 4 lenses pass 3 left open
  (web-mfact-ui-submodule, stuck-item-guard-wiring, fix-loop-catch-and-catalog-check,
  general-drift-scan). HEAD moved again during this very pass: c741d46 -> `da4f21a`
  (fix-loop cron `0e35feb8`'s second firing, 00:45:22), committed live while this
  audit was running. 6 CONFIRMED, 1 UNVERIFIABLE, 1 REFUTED, 0 DRIFTED, 0
  FIXED-since-last-pass. Headline: firing 2 hit the collision guard again (8
  persistent modified files plus a large untracked pile) and, unlike firing 1, its
  own commit message now explicitly names the structural cause -- the guard checks
  absolute clean-tree state, not a delta since the last check, so it will collide
  identically on every future firing until the persistent pile is resolved or the
  guard is redesigned; the loop's authors flagged this to the user rather than
  deciding unilaterally. web/mfact-ui's gitlink drift (5 local commits ahead of the
  parent's recorded 1ba3a9b, 21 dirty files, no `.gitmodules`) and
  `scripts/stuck_item_guard.py`'s missing justfile/doc wiring both reproduce
  unchanged from pass 3. `MFW_WORKFLOW_CATALOG.md` (task `wjeyru8a7`) remains
  absent from the tree and untraceable from this session's task tracker or any of
  the 7 fix-loop worktrees on disk.
- **2026-07-13 (pass 5):** 15 findings across 3 lenses (idle-gap-confirmation,
  no-unexpected-drift-during-gap, mfw-catalog-top-claim-verify), auditing the fix
  loop's own briefing narrative of an ~8h idle gap between pass 4 (~00:48 PDT) and
  this pass (~08:49 PDT), during which cron job `6f81400b` allegedly never fired.
  6 CONFIRMED, 3 REFUTED, 3 DRIFTED, 3 UNVERIFIABLE, 0 FIXED-since-last-pass.
  Headline: the briefing's own core claim -- "HEAD stayed at a824ebc" for the
  entire idle gap -- is false at critical severity. `a824ebc` and its two parents
  `1e47b87`/`17b4c51` were all committed at 08:45:39-08:47:56 PDT, i.e. in the two
  minutes immediately before this pass ran, not eight hours ago; HEAD actually sat
  at `da4f21a` (pass 4's own last commit) throughout the real gap, per `git
  reflog`. The genuine idle window is also shorter than claimed and ends later:
  filesystem writes continued until 01:27:43 PDT (`MFW_WORKFLOW_CATALOG.md`,
  Lean/cargo build output), so true silence ran roughly 7h23m (01:28-08:44 PDT),
  not the ~8h02m implied by the stated 00:48 start. Despite these framing errors,
  the substantive negative claims hold up under fresh re-verification: zero new
  commits or receipts landed during the actual 01:28-08:44 PDT silence, `git
  status --porcelain` is still 76 lines and byte-identical in file-set to pass 4,
  `git fsck` is clean (no error/missing/corrupt/broken lines), and a fresh
  re-check of `MFW_WORKFLOW_CATALOG.md` section 1.1 (Mathlib's
  `wellFounded_isDershowitzMannaLT` at pinned rev `fabf563a` composed with Wave
  M0's proven residue lemmas) reconfirms Wave M0 is genuinely proven and Wave M1
  (`ProcInt/MFW/Termination/`) genuinely does not exist yet -- the catalog's own
  framing as a not-yet-started proposal is accurate.
- **2026-07-13 (pass 6):** 7 findings across 2 lenses (status-delta-investigation,
  fix-loop-firing-detection), auditing the git-status delta from the pass-4/5
  baseline (76 to 77 lines) and whether fix loop `f6a6cd52`'s ~09:12 PDT slot
  produced its first real (non-collision) v3 firing. HEAD unchanged at `a824ebc`
  across five fresh samples spanning 09:11-09:16 PDT; no new commit or receipt
  landed. 6 CONFIRMED, 0 REFUTED, 0 DRIFTED, 1 UNVERIFIABLE, 0
  FIXED-since-last-pass. Headline: the entire +1 delta is
  `PRAXIS_SELF_AUDIT.md` transitioning from clean to modified -- pass 5's own
  307-line uncommitted append -- not external drift; but that same fact exposes
  a live design gap in the v3 collision guard, whose own doc states it treats
  any path *not* in `known-persistent-drift.txt` as a real collision, and
  `PRAXIS_SELF_AUDIT.md` was clean (hence absent from that baseline) when it was
  snapshotted. The very next firing that reaches STEP 1 is therefore likely to
  collide on this file precisely because this recurring audit keeps appending
  to it -- unconfirmed since no firing occurred this pass, but mechanically
  implied by the guard's own documented logic (PF1).
- **2026-07-13 (pass 7):** 18 findings across 3 lenses (g49-closure-reverify,
  axiom-count-gap-investigation, general-status-and-next-firing-catch),
  re-verifying fix loop `f6a6cd52`'s first real (non-collision) firing --
  commit `eabe589` claims to restore `simulate_workload` in
  `crates/mfact-core/src/bin/turbulence.rs` and close ledger item G49. HEAD
  stayed at `6329c9d` throughout (09:39-09:46 PDT), porcelain count held at
  76, matching the pass-6 baseline exactly. 15 CONFIRMED, 2 DRIFTED, 1
  UNVERIFIABLE, 0 REFUTED, 0 FIXED-since-last-pass. Headline: the G49
  closure genuinely holds under live re-verification -- `simulate_workload`
  is a real scalar loop with a `black_box` guard, `cargo check --bin
  turbulence` and `cargo run --bin turbulence` both succeed from
  `crates/mfact-core`, the pre-fix blob really did reference an undefined
  function, and the ledger/metrics-history bookkeeping is internally
  consistent (PG14-PG16). A separate, higher-severity finding surfaced while
  chasing a reported "AxiomAudit binary missing" gap: `AxiomAudit.lean` in
  both `mfact/` and `procint/` has no `main` and is correctly declared
  `[[lean_lib]]`, not `[[lean_exe]]`, in both lakefiles -- there was never a
  binary to find, so a fix framed as a lakefile change would target the
  wrong file; the real fix belongs in whatever script computes
  `axiom_count`, which does not exist yet (PG1-PG2). Two DRIFTED findings:
  the ledger's own documented `grep` command for confirming no
  empirical-ingestion replacement exists is not reproducible as literally
  written (missing `-E`, so `|` is treated literally, not as alternation),
  though the underlying conclusion holds under a corrected re-run (PG11);
  and `sse_transport_test.rs`'s pre-existing break is broader than "missing
  tokio/reqwest_eventsource deps" -- `transport.rs` also exists unwired,
  never declared via `mod transport;` in `lib.rs` (PG12).
- **2026-07-13 (pass 8):** 18 findings across 3 lenses (g50-closure-reverify,
  metrics-integrity-check, general-status-and-next-firing-catch),
  re-verifying fix loop `f6a6cd52`'s second real firing -- commit `c636fd3`
  claims to wire `scripts/stuck_item_guard.py` into `just stuck-item-guard`
  and `MFACT_SELF_IMPROVEMENT_LOOP.md`, adding ledger entry G50 after
  catching and fixing a real CLI-argument bug (positional vs. `--receipts`
  flag) during its own re-verification step. HEAD held at `672fdeb`
  throughout (~10:09-10:13 PDT), porcelain count held at 76, matching the
  pass-7 baseline exactly. 16 CONFIRMED, 2 DRIFTED, 0 REFUTED,
  0 UNVERIFIABLE, 0 FIXED-since-last-pass. Headline: the G50 closure
  genuinely holds -- `just stuck-item-guard` runs clean (exit 0, "Nothing
  flagged"), the justfile recipe correctly uses `--receipts` not a
  positional arg, and the claimed first-attempt failure ("unrecognized
  arguments") reproduces verbatim, including confirmation that the claimed
  convention mismatch with the neighboring `trajectory-annotate` recipe
  (which does use a positional arg) is real. Two DRIFTED findings, both
  loose wording rather than substantive errors: the ledger/commit phrase
  "argparse requires `--receipts` DIR" overstates the cause -- `--receipts`
  is optional with a default, not required, and the true cause is that no
  positional argument exists at all; and the G50 receipt stores
  `commit_sha` as a 7-char short hash while the immediately preceding G49
  receipt stored the full 40-char SHA, a minor audit-trail schema
  inconsistency worth normalizing in a future firing.
- **2026-07-13 (pass 11):** 14 findings across 3 lenses
  (construction-workflow-progress, fix-loop-firing6-continuity,
  zip-and-ggen-findings-recheck). Pass 10 is reserved for the separately-running
  10-agent construction workflow's (task `wkw4npeny`) own Verify-phase writeup,
  which has not landed yet, so this pass is numbered 11 rather than 10 to avoid
  a future collision. HEAD held at `d2e6d01` throughout (fix loop `f6a6cd52`'s
  firing-6 collision-receipt commit, checked repeatedly 11:10-11:18 PDT); no new
  commit or receipt landed during this pass's window. 11 CONFIRMED, 1 REFUTED,
  2 DRIFTED, 0 UNVERIFIABLE, 0 FIXED-since-last-pass. Headline: all 9 named
  target files/dirs for the construction workflow's 4 in-scope waves (Glue/,
  Termination/, UniformWitness.lean, Tenancy.lean, LedgerBridge.lean) plus the
  actively-growing Swarm11/OrientedSwap.lean exist, are non-empty, contain zero
  `sorry`/`admit` placeholder tactics, and end in well-formed closing `end`
  statements rather than mid-write truncation -- the workflow is genuinely
  still mid-flight, not stalled or faking completion. Live `git status
  --porcelain` (79 lines) reconciles exactly to the 76-line
  `known-persistent-drift.txt` baseline minus 5 already-committed paths plus 8
  new paths, all 8 attributable to the concurrent construction workflow. The
  one REFUTED finding: firing 6's own collision receipt and commit message
  claim all 7 of its flagged new paths are "attributable to" `wkw4npeny`, but
  one of the 7, `PRAXIS_SELF_AUDIT.md`, is actually this self-audit loop's own
  uncommitted pass-9 append (mtime 10:51, before firing 6 ran at 10:57) -- the
  guard's decision to stop was still correct, but its stated diagnosis
  misattributes this session's own output, a pattern now compounding as this
  pass adds a second uncommitted append on top of pass 9's. HEAD is also no
  longer byte-identical to `origin/v26.7.12-close` (1 unpushed commit,
  `d2e6d01`), DRIFTED from pass 9's "pushed" finding. Independently re-run
  `ggen doctor run` (still refuses on `post-release-pack` lockfile drift plus
  `PostRelease.lean` receipt staleness) and the extracted-zip `sorry`/`axiom`
  checks (still zero hits, both narrow and broad patterns) reproduce unchanged.
- **2026-07-13 (pass 9):** 6 findings across 2 lenses (g51-closure-reverify,
  general-status-and-next-firing-catch), re-verifying fix loop `f6a6cd52`'s
  firing 5 -- commit `0639081` claims to add a `[lints.clippy]` gate to
  `crates/mfact-core/Cargo.toml` (todo/unimplemented/dbg_macro deny,
  unwrap_used/expect_used warn) plus a `just clippy-core` recipe, closing
  ledger item G51, with commit `321dd7c` recording the firing's success
  receipt and commit `5dc2f5c` (also HEAD) tracking `MFW_WORKFLOW_CATALOG.md`
  and four ROADMAP gap docs. 6 CONFIRMED, 0 REFUTED, 0 DRIFTED,
  0 UNVERIFIABLE, 0 FIXED-since-last-pass. Headline: the G51 closure
  genuinely holds -- the live `Cargo.toml` lint block matches the ledger's
  closure text exactly (verified via direct `grep`, not trusted from the
  commit message), `just clippy-core` runs clean (exit 0) against the
  crate's `--lib --bin turbulence` scope, and the claimed negative-control
  revert is intact: no `dbg!` occurrence remains in
  `crates/mfact-core/src/lib.rs`. HEAD (`5dc2f5c`) is byte-identical to
  `origin/v26.7.12-close` (`git log origin/v26.7.12-close..HEAD` empty,
  both resolve to the same 40-char SHA), so the branch is genuinely pushed,
  not just locally committed. `ROADMAP_CLOUD_MATH.md`'s five theorem-card
  citations (`replay_eq_of_traceEq` `Swarm11/Replay.lean:105`,
  `replay_preserved` `Correspondence/AtomVM.lean:54`,
  `zero_unreceipted_completion` `MFW/Runtime.lean:62`,
  `enabled_frontier_isAntichain` `MFW/Order.lean:48`, `work_bounds`
  `Thermo.lean:30`) all reproduce a matching `theorem <name>` line at the
  exact cited line number in `procint/ProcInt/Playground/` (and
  `procint/ProcInt/Thermo.lean` for the last). The collision-guard baseline
  check found no *unexplained* drift: `git status --porcelain` dropped from
  76 to 71 lines since pass 8, but all 5 removed paths
  (`MFW_WORKFLOW_CATALOG.md` and the four `ROADMAP_GAP_*.md`/`ROADMAP.md`
  docs) are exactly the files commit `5dc2f5c` newly tracked, and zero new
  paths appeared in git status that aren't already in
  `.mfact/known-persistent-drift.txt` -- the 76-entry baseline file itself
  is now stale by those same 5 entries and worth refreshing in a future
  firing, a bookkeeping note rather than a defect.
- **2026-07-13 (pass 12):** 13 findings across 2 lenses (fix-loop-postconstruction-firing,
  baseline-and-drift-check), continuing pass-10/11's independent re-verification into the
  post-construction-workflow window. HEAD held at `98263a9` throughout (pass 10's own
  append commit); no new commit landed during this pass's checking window, confirmed by
  repeated `git log`/`ls -la .mfact/receipts/` checks at 11:42:51, 11:43:56, 11:44:32, and
  11:45:39 PDT plus a ~9-minute background poll (task `bjopyb0kw`) watching for new
  receipt files. 10 CONFIRMED, 1 REFUTED, 1 DRIFTED, 1 UNVERIFIABLE,
  0 FIXED-since-last-pass. Headline: fix loop `f6a6cd52`'s firing-7 collision receipt
  (commit `aa203ec`) is a genuine, accurately attributed collision-guard stop, and the
  working tree now matches `known-persistent-drift.txt` byte-for-byte (`comm -23` empty,
  re-run twice) -- the 7 paths that triggered firing 7's collision are gone from `git
  status` because they are now committed as `d4ed2f3` and `ae5c2a5`, so the fix loop's
  next firing should genuinely be able to pick a real item. This pass also caught and
  fixed a citation error in its own pre-commit draft (PL13, REFUTED): the draft had
  mis-cited `20260713T165952Z.json` as firing 6's collision receipt when
  `git show --stat d2e6d01` proves the correct file is `20260713T175700Z.json` --
  `20260713T165952Z.json` is actually firing 4's unrelated G50 success receipt. The one
  DRIFTED finding: this pass's own task framing estimated the next firing at ~11:42 PDT,
  but the observed real cadence across all 7 receipts today is a consistent 27-31 minute
  gap, putting the next firing closer to ~11:54-11:58 PDT -- corrected here for the next
  pass's polling. `known-persistent-drift.txt` is flagged (again) as stale by the same 5
  already-committed paths pass 10/11 already named, not yet refreshed per this audit's
  own read-only discipline.
- **2026-07-13 (pass 13):** 13 findings across 3 lenses (soc2-scope-correction-audit,
  fix-loop-health-check, soc2-flow-test-workflow-catch). HEAD held at `852d343` throughout
  (the scope-corrected `ROADMAP_SOC2_MATH.md` commit); no new firing/commit landed during
  this pass's 12:09-12:15 PDT checking window. 8 CONFIRMED, 3 REFUTED (1 major), 1
  DRIFTED, 1 UNVERIFIABLE, 0 FIXED-since-last-pass. Headline: every scope-correction claim
  in `ROADMAP_SOC2_MATH.md` re-derives cleanly against the live file and Lean sources --
  the scope-boundary paragraph, CC8/PI1.1-PI1.5 category text, all four theorem-card line
  citations, the markdown conventions, and the PA23/PA24 cross-reference all reproduce
  verbatim, not merely restated from the commit message. On the fix loop: firings 6/7/8
  colliding three times running is REFUTED as a "malfunction" -- fresh reads of all three
  collision receipts show three distinct, correctly self-diagnosed concurrent-work causes
  (10-agent workflow `wkw4npeny` for 6 and 7, unrelated task `w3uu76xt9` for 8), not the
  same blocker repeating. Firing 9 (due ~12:12-12:15 PDT per cron `f6a6cd52`) had not
  landed as of this pass's 12:14:41 PDT check. The SOC2 flow-test construction workflow
  (task `wfigivqnl`) has produced zero files yet -- no `Playground/SOC2/` directory, no
  `AuditFlow` or `wfigivqnl` hits anywhere in the tree.
- **2026-07-13 (pass 14):** 12 findings across 2 lenses (soc2-flow-test-quality-check,
  general-drift-and-fixloop-check), auditing the SOC2 flow-test construction workflow
  (task `wfigivqnl`) now that both `procint/ProcInt/Playground/SOC2/{AuditFlow,
  AuditFlowViolation}.lean` exist (683 total lines, mtimes 12:16/12:36 PDT), superseding
  pass 13's "zero files yet" finding. HEAD held at `a50c5e9` throughout this pass's
  12:39-12:41 PDT window; `git log -5` shows only expected self-loop commits (firing-9
  collision, pass-13 doc, `ROADMAP_SOC2_MATH.md`, firing-8 collision, pass-12 doc). 7
  CONFIRMED, 2 DRIFTED, 2 UNVERIFIABLE, 1 FIXED-since-last-pass, 0 REFUTED. Headline: both
  files are genuine, substantive constructive artifacts, not stubs. `AuditFlow.lean` (535
  lines) is an 82-declaration near-complete positive witness whose docstring citations to
  `ROADMAP_SOC2_MATH.md` Cards 1-3 and to specific Lean line numbers in `Tenancy.lean`,
  `Runtime.lean`, and `Swarm11/Replay.lean` all resolve exactly on fresh re-grep.
  `AuditFlowViolation.lean` (148 lines) correctly reuses the pre-existing
  `TenancyCountermodel` section rather than reinventing a countermodel, and both files
  contain zero `sorry`/`admit`/`native_decide` as actual tactics. One drift-worthy defect:
  `AuditFlowViolation.lean`'s docstring still forward-references the (at-write-time
  nonexistent) positive companion as `ProcInt.Playground.Swarm11.AuditFlow`, but the file
  actually built lives at `ProcInt.Playground.SOC2.AuditFlow` -- a stale, cosmetic-only
  comment not yet corrected. `known-persistent-drift.txt` is again exactly one path behind
  live `git status` (`procint/ProcInt/Playground/SOC2/`), the same expected-but-unbaselined
  pattern noted for prior in-flight workflows. Per instructions, files were not built
  (`lake build`) this pass to avoid racing the still-running construction workflow, so full
  typecheck confirmation remains UNVERIFIABLE, as does whether fix loop `f6a6cd52`'s next
  firing (due ~12:42 PDT) had landed by the end of this pass's own check window.
- **2026-07-13 (pass 15):** 11 findings across 3 lenses (g11-deletion-reverify,
  status-count-drop-explained, lean-testing-workflow-catch), independently re-verifying
  firing-10's G11 closure commit (108bf5b: delete broker.rs/thermo.rs/transport.rs/
  lean.rs/lean_ffi_wrapper.c/main.rs plus two integration tests from crates/mfact-core)
  and the resulting `git status --porcelain` drop from 71 to 63 lines. HEAD held at
  `836fb53` throughout this pass's ~13:09-13:18 PDT window; `git log a50c5e9..836fb53`
  shows exactly 5 self-loop commits, no foreign intrusion. 8 CONFIRMED, 1 REFUTED, 1
  DRIFTED (major), 1 FIXED-since-last-pass, 0 UNVERIFIABLE. Headline: the deletion
  itself, its untracked-file git-history claim, and the 71->63 porcelain arithmetic all
  reproduce exactly on fresh commands -- but `build.rs` (untracked, unchecked by the
  closure's own verification) still does
  `cc::Build::new().file("src/lean_ffi_wrapper.c")`, a literal reference to one of the 8
  just-deleted files. `just clippy-core` currently passes only because this sandboxed
  shell's PATH lacks `lean`, so build.rs bails out before reaching that call; both
  `~/.bash_profile` and `~/.zprofile` add `$HOME/.elan/bin` to PATH, and `~/.elan/bin/
  lean --print-prefix` runs successfully when invoked directly -- so the user's actual
  login shell would hit a real build failure the closure never disclosed (PO1, major
  DRIFTED). Pass 14's PN1 docstring-drift finding was independently confirmed FIXED by
  commit bb25faf (diff read directly, not trusted from its message).
- **2026-07-13 (pass 16):** 17 findings across 4 lenses (verify-newman-confluence-commit,
  cslib-survey-gap-check, spotcheck-testing-landscape-claims, ledger-and-baseline-health),
  independently re-verifying commit 84ab3de (OrientedSwapReplay.lean/
  ManufactureTenancyGap.lean: build job counts, sorry/admit-cleanliness, axiom-cleanliness,
  citation resolution) and auditing the wup6bpemk workflow's
  `survey:cslib-test-conventions` failure. HEAD held at `84ab3de` through this pass's check
  window. 15 CONFIRMED, 1 DRIFTED, 1 REFUTED, 0 UNVERIFIABLE, 0 FIXED-since-last-pass (5
  major, 12 minor). Headline: the cslib-survey agent (a18efebc30633f5ff) crashed
  mid-tool-use with an unretried API connection error -- unlike two sibling crashes in the
  same wave that WERE retried to completion -- and the gap then dropped silently through
  the whole pipeline: the Synthesize phase's own input prompt falsely claimed "10-lens"
  coverage while actually supplying only 9 lenses with no disclosure of the gap, none of
  Synthesize/Build-spec/Build/Verify ever discussed cslib's testing conventions, and commit
  84ab3de's own detailed self-audit -- which does self-flag an unrelated citation error --
  never mentions the failure (PP1-PP4). Also flagged: ManufactureTenancyGap.lean's
  soundness gap had no GAP_LEDGER_v26.7.12.md entry at audit time (PP5); a #guard-count
  claim from the wup6bpemk survey DRIFTED (naive substring match double-counts a docstring
  mention, PP14); and the known-persistent-drift.txt "refresh" claim was REFUTED -- its
  mtime is the original write, not a later refresh (PP17).
- **2026-07-13 (pass 17):** 16 findings across 3 lenses (multi-workflow-concurrency-safety,
  sorry-axiom-trend, cron-loop-health), auditing two concurrently-declared background
  workflows (wsr99yw42, wnz6xi5ce) against this session's own delta-based fix-loop collision
  guard, re-verifying the procint/ProcInt sorry/lake-build metrics trend, and confirming
  firing-12's absence from the fix loop's Run log. HEAD held at `5ee8573` (pass 15) through
  this pass's check window. 13 CONFIRMED, 3 UNVERIFIABLE, 0 REFUTED, 0 DRIFTED, 0
  FIXED-since-last-pass (5 major, 11 minor). Headline: the collision guard's `comm`-based
  diff is structurally path-only, not content/hash-based, so it can never flag a genuine
  edit landing on a path already present in the (~5.5h-stale) known-persistent-drift.txt
  baseline -- demonstrated live on crates/mfact-core/src/validate.rs, which was actively
  dirty and invisible to both comm-23 checks run this pass (PQ1, major). A follow-up check
  after this finding was filed closed that specific instance out: validate.rs's dirtiness is
  pre-existing baseline drift already tracked since pass 15 (PO5, PO8), not a fresh rogue
  edit from an unattributed third writer -- the guard's blind spot is real and general, but
  this particular occurrence was not evidence of an active collision. Also flagged: a latent
  3-way write-path convergence on PRAXIS_SELF_AUDIT.md/GAP_LEDGER_v26.7.12.md between this
  audit loop, the fix loop, and wsr99yw42 (PQ2, major); firing 12 of the fix loop is absent
  from every source -- Run log, git history, and receipts directory alike -- consistent with
  an interruption before its receipt-writing step (PQ4, PQ5, major); and the procint/ProcInt
  `sorry_count` trend in metrics-history.jsonl (16->23) is a raw-grep artifact of new "No
  `sorry`" doc-comments, not new proof debt -- the real kernel-level sorry-tactic count
  stayed at 0 throughout (PQ12-PQ14).
- **2026-07-13 (pass 18):** 10 findings across 3 lenses (wave4-closure-reverify,
  soc2-standing-path-soundness, release-docs-and-drift-baseline), writing up findings
  already independently re-verified by a prior audit run rather than re-deriving them
  from scratch, per this firing's own briefing. Findings reference a check window
  spanning commits bd7ea3e (G52/G53 ledger entry) through c481ecd (StandingPathSOC2.lean
  T132/T133 witness); live HEAD had moved further still by write-up time. 7 CONFIRMED, 3
  REFUTED, 0 DRIFTED, 0 UNVERIFIABLE, 0 FIXED-since-last-pass (1 major, 9 minor). Headline:
  two REFUTED findings correct real errors rather than merely confirm health. This
  write-up itself corrects a wrong prior claim that a `sorry` remains at
  ExperimentalWalkthrough.lean:56 (`rawToPlan.seq`) -- that line is a `#guard_msgs(error)`
  negative test, not a sorry, and a repo-wide `grep -rnw sorry` over procint/ProcInt
  (excluding .lake) finds zero actual sorry tactic invocations, consistent with Pass 17's
  PQ12-PQ14 finding that the true kernel-level count is 0 (PR10). StandingPathSOC2.lean
  does not overclaim SOC2-crown completeness: its header states "admitted ⊂ required ...
  is what this file proves -- not admitted = required," `missing_eq_exact_rows` names
  exactly the four open rows (M_e, M_u, F, S), and no `StandingPathReceipt` with a
  fabricated `complete := true` field exists (PR4). The drift-baseline staleness concern
  (PR1, major) also came back REFUTED live: a fresh `comm -23` of git status against
  known-persistent-drift.txt was empty, and the baseline is currently a superset of live
  drift rather than a subset -- though release/certify.log.bak has since appeared as one
  new untracked path, a freshness caveat that does not overturn the verdict. Wave 4's
  three closure commits (GAP_LEDGER G52/G53, PRAXIS_SELF_AUDIT Pass 16, firing-12
  backfill) and AxiomAuditSOC2.lean's fresh-build re-check both hold clean (PR2, PR3,
  PR5, PR6, PR7, PR8, PR9).

## Quick reference

| Severity | Count | Verdicts (this pass) |
|---|---|---|
| Critical | 7 | 6 REFUTED, 1 DRIFTED |
| Major | 18 | 6 REFUTED, 8 DRIFTED, 3 CONFIRMED, 1 UNVERIFIABLE |
| Minor | 20 | 3 REFUTED, 5 DRIFTED, 11 CONFIRMED, 1 UNVERIFIABLE |
| **Total** | **45** | **15 REFUTED, 14 DRIFTED, 14 CONFIRMED, 2 UNVERIFIABLE** |

**Pass 2 (2026-07-12) totals -- alongside, not replacing, the pass-1 totals above:**

| Severity | Count (pass 2) | Verdicts (pass 2) |
|---|---|---|
| Critical | 4 | 2 CONFIRMED, 1 DRIFTED, 1 REFUTED |
| Major | 8 | 4 CONFIRMED, 2 REFUTED, 2 DRIFTED |
| Minor | 11 | 3 CONFIRMED, 4 REFUTED, 4 DRIFTED |
| **Total** | **23** | **9 CONFIRMED, 7 REFUTED, 7 DRIFTED** |

**Pass 3 (2026-07-13) totals -- alongside, not replacing, the pass-1/pass-2 totals above:**

| Severity | Count (pass 3) | Verdicts (pass 3) |
|---|---|---|
| Critical | 2 | 2 CONFIRMED |
| Major | 4 | 3 CONFIRMED, 1 REFUTED |
| Minor | 2 | 1 CONFIRMED, 1 DRIFTED |
| **Total** | **8** | **6 CONFIRMED, 1 REFUTED, 1 DRIFTED** |

**Pass 4 (2026-07-13) totals -- alongside, not replacing, the pass-1/2/3 totals above:**

| Severity | Count (pass 4) | Verdicts (pass 4) |
|---|---|---|
| Critical | 2 | 2 CONFIRMED |
| Major | 3 | 2 CONFIRMED, 1 UNVERIFIABLE |
| Minor | 3 | 2 CONFIRMED, 1 REFUTED |
| **Total** | **8** | **6 CONFIRMED, 1 UNVERIFIABLE, 1 REFUTED** |

**Pass 5 (2026-07-13) totals -- alongside, not replacing, the pass-1/2/3/4 totals above:**

| Severity | Count (pass 5) | Verdicts (pass 5) |
|---|---|---|
| Critical | 1 | 1 REFUTED |
| Major | 3 | 1 DRIFTED, 1 UNVERIFIABLE, 1 REFUTED |
| Minor | 11 | 2 DRIFTED, 6 CONFIRMED, 1 REFUTED, 2 UNVERIFIABLE |
| **Total** | **15** | **6 CONFIRMED, 3 REFUTED, 3 DRIFTED, 3 UNVERIFIABLE** |

**Pass 6 (2026-07-13) totals -- alongside, not replacing, the pass-1/2/3/4/5 totals above:**

| Severity | Count (pass 6) | Verdicts (pass 6) |
|---|---|---|
| Major | 1 | 1 UNVERIFIABLE |
| Minor | 6 | 6 CONFIRMED |
| **Total** | **7** | **6 CONFIRMED, 1 UNVERIFIABLE** |

**Pass 7 (2026-07-13) totals -- alongside, not replacing, the pass-1/2/3/4/5/6 totals above:**

| Severity | Count (pass 7) | Verdicts (pass 7) |
|---|---|---|
| Major | 2 | 2 CONFIRMED |
| Minor | 16 | 13 CONFIRMED, 2 DRIFTED, 1 UNVERIFIABLE |
| **Total** | **18** | **15 CONFIRMED, 2 DRIFTED, 1 UNVERIFIABLE** |

**Pass 8 (2026-07-13) totals -- alongside, not replacing, the pass-1..7 totals above:**

| Severity | Count (pass 8) | Verdicts (pass 8) |
|---|---|---|
| Minor | 18 | 16 CONFIRMED, 2 DRIFTED |
| **Total** | **18** | **16 CONFIRMED, 2 DRIFTED** |

**Pass 9 (2026-07-13) totals -- alongside, not replacing, the pass-1..8 totals above:**

| Severity | Count (pass 9) | Verdicts (pass 9) |
|---|---|---|
| Minor | 6 | 6 CONFIRMED |
| **Total** | **6** | **6 CONFIRMED** |

**Pass 11 (2026-07-13) totals -- alongside, not replacing, the pass-1..9 totals above
(pass 10 reserved for the construction workflow's own Verify-phase writeup):**

| Severity | Count (pass 11) | Verdicts (pass 11) |
|---|---|---|
| Minor | 14 | 11 CONFIRMED, 1 REFUTED, 2 DRIFTED |
| **Total** | **14** | **11 CONFIRMED, 1 REFUTED, 2 DRIFTED** |

**Pass 12 (2026-07-13) totals -- alongside, not replacing, the pass-1..9 and pass-11
totals above (pass 10's findings are PJ1-PJ10 in the Pass 10 findings section; no
quick-reference row was ever added for it, a pre-existing gap this pass does not fix):**

| Severity | Count (pass 12) | Verdicts (pass 12) |
|---|---|---|
| Minor | 13 | 10 CONFIRMED, 1 REFUTED, 1 DRIFTED, 1 UNVERIFIABLE |
| **Total** | **13** | **10 CONFIRMED, 1 REFUTED, 1 DRIFTED, 1 UNVERIFIABLE** |

**Pass 13 (2026-07-13) totals -- alongside, not replacing, the pass-1..9, 11, and 12
totals above:**

| Severity | Count (pass 13) | Verdicts (pass 13) |
|---|---|---|
| Major | 1 | 1 REFUTED |
| Minor | 12 | 8 CONFIRMED, 2 REFUTED, 1 DRIFTED, 1 UNVERIFIABLE |
| **Total** | **13** | **8 CONFIRMED, 3 REFUTED, 1 DRIFTED, 1 UNVERIFIABLE** |

**Pass 14 (2026-07-13) totals -- alongside, not replacing, the pass-1..9, 11, 12, and 13
totals above:**

| Severity | Count (pass 14) | Verdicts (pass 14) |
|---|---|---|
| Minor | 12 | 7 CONFIRMED, 2 DRIFTED, 2 UNVERIFIABLE, 1 FIXED-since-last-pass |
| **Total** | **12** | **7 CONFIRMED, 2 DRIFTED, 2 UNVERIFIABLE, 1 FIXED-since-last-pass** |

**Pass 15 (2026-07-13) totals -- alongside, not replacing, the pass-1..9, 11, 12, 13,
and 14 totals above:**

| Severity | Count (pass 15) | Verdicts (pass 15) |
|---|---|---|
| Major | 1 | 1 DRIFTED |
| Minor | 10 | 8 CONFIRMED, 1 REFUTED, 1 FIXED-since-last-pass |
| **Total** | **11** | **8 CONFIRMED, 1 REFUTED, 1 DRIFTED, 1 FIXED-since-last-pass** |

**Pass 16 (2026-07-13) totals -- alongside, not replacing, the pass-1..9, 11, 12, 13, 14, and
15 totals above:**

| Severity | Count (pass 16) | Verdicts (pass 16) |
|---|---|---|
| Major | 5 | 5 CONFIRMED |
| Minor | 12 | 10 CONFIRMED, 1 DRIFTED, 1 REFUTED |
| **Total** | **17** | **15 CONFIRMED, 1 DRIFTED, 1 REFUTED** |

**Pass 17 (2026-07-13) totals -- alongside, not replacing, the pass-1..9, 11, 12, 13, 14, 15,
and 16 totals above:**

| Severity | Count (pass 17) | Verdicts (pass 17) |
|---|---|---|
| Major | 5 | 5 CONFIRMED |
| Minor | 11 | 8 CONFIRMED, 3 UNVERIFIABLE |
| **Total** | **16** | **13 CONFIRMED, 3 UNVERIFIABLE** |

**Pass 18 (2026-07-13) totals -- alongside, not replacing, the pass-1..9, 11, 12, 13, 14,
15, 16, and 17 totals above:**

| Severity | Count (pass 18) | Verdicts (pass 18) |
|---|---|---|
| Major | 1 | 1 REFUTED |
| Minor | 9 | 7 CONFIRMED, 2 REFUTED |
| **Total** | **10** | **7 CONFIRMED, 3 REFUTED** |

## Critical

### PA11 -- release/standing.env: CERTIFIED_RELEASE=PASS (i.e. the release is currently...

- Lens: release-standing-drift
- Claim: release/standing.env: CERTIFIED_RELEASE=PASS (i.e. the release is currently
  certified)
- Source: release/standing.env:14
- Verdict: REFUTED
- Evidence: Rebuilt the pinned targets through the lock wrapper (`just _lake "cd mfact && lake
  build AxiomAudit mfact"` -> "Build completed successfully (22 jobs)"; `just _lake "cd
  procint && lake build"` -> "Build completed successfully (8614 jobs)"), then ran the exact
  G1 command: `cd /Users/sac/mfact/mfact && ./.lake/build/bin/mfact certify
  ../release/release-manifest.json ../release/gates.json`. Stderr: "gate failure:
  sorryFree=true axiomsClean=true fixturesPass=true evidenceComplete=false". Exit code
  captured via `echo EXIT_CODE=$?` = 1. G1 is NOT fixed; it is unchanged from the prior
  gap-sweep's finding, and per `git rev-list --count 184e3a3..HEAD` = 31, HEAD has drifted 31
  commits past the last certified tag (was 7 at the time the ledger recorded G1) with no fix
  landing in between.

### PA12 -- PROJECT.md milestone table: "Fix Ticket 013 Certification Gaps" = DONE,...

- Lens: release-standing-drift
- Claim: PROJECT.md milestone table: "Fix Ticket 013 Certification Gaps" = DONE, "Final Scan
  and Validation ... zero blockers" = DONE, "Release Tag & Certification" = DONE, and
  milestone 1's description of "implementing the countermodel_not_promoted guard"
- Source: PROJECT.md:5, PROJECT.md milestones table (M3/M4/M5)
- Verdict: REFUTED
- Evidence: The `countermodel_not_promoted` key is present in release/gates.json
  (`"countermodel_not_promoted": false`) but is structurally dead: Read of
  /Users/sac/mfact/mfact/Mfact/Cli.lean lines 29-37 shows `GatesJson` declares only
  `sorryFree`, `axiomsClean`, `fixturesPass`, `evidenceComplete` (deriving FromJson) -- the
  extra field is silently dropped on parse, never reaches `GateResults.allPass`.
  `scripts/build_manifest.py` lines 104-110 only does `print("COUNTERMODEL_PROMOTION_REFUSED:
  ...")` with no `sys.exit`, so the Python generator's own detection of the violation is
  non-blocking too. Combined with PA11 (live certify exit 1), none of these three milestones
  are actually DONE against the current tree.

### PA17 -- ROADMAP_SWARM_SUPPLY_CHAIN.md's own Standing Corrections Ledger asserts...

- Lens: roadmap-marker-schema
- Claim: ROADMAP_SWARM_SUPPLY_CHAIN.md's own Standing Corrections Ledger asserts
  'Terminates(j)' is `PROVEN` at Wave M1 (C9: "Corrected: keep `Terminates(j)` as its own
  `PROVEN` (Wave M1) statement"; C14: "`Terminates(j)` (deterministic, per-object, `PROVEN` at
  Wave M1)"), citing ROADMAP_MATH_SPINE.md's Wave M1 as the authority.
- Source: ROADMAP_SWARM_SUPPLY_CHAIN.md:239 (C9), :280 (C14)
- Verdict: REFUTED
- Evidence: ROADMAP_MATH_SPINE.md itself marks the identical claim `TARGET_THEOREM`, never
  PROVEN, in three places: line 55 ('Standing: `TARGET_THEOREM` (Wave M1)'), line 475 (Claim
  Status Table: 'Strict DM descent bars infinite refinement (Crown II) | Target theorem, Wave
  M1; DM route'), and its own achievement marker `MFW_M1_DM_DESCENT_FORMALIZED=` (line 399) is
  blank. `find /Users/sac/mfact/procint/ProcInt/MFW -maxdepth 2 -type d` returns only `MFW`
  and `MFW/Residue` (Wave M0) -- no `MFW/Termination` directory (Wave M1's own stated target
  path) exists. `grep -rn '^theorem crown_multiset_strictly_decreases|^theorem
  manufacture_children_strictly_descend|^theorem no_infinite_productive_mfw_chain'
  /Users/sac/mfact/procint` returns zero matches. So the swarm doc's own corrected prose
  asserts a stronger standing (PROVEN) than the very document it cites as authoritative for
  that claim (TARGET_THEOREM, zero Lean artifact) -- a direct violation of both documents'
  explicitly stated law that 'no entry below may be quoted at a stronger standing than its
  marker' (ROADMAP_SWARM_SUPPLY_CHAIN.md:11-13) and is precisely the 'imported-result
  authority bleed' failure mode ROADMAP_MATH_SPINE.md §3 itself defines, here committed by the
  swarm doc against the spine doc.

### PA22 -- thermo.rs/broker.rs/lean.rs/transport.rs (untracked, this-session files...

- Lens: agents-md-self-compliance
- Claim: thermo.rs/broker.rs/lean.rs/transport.rs (untracked, this-session files implementing
  the FFI thermodynamics + broker + SSE transport subsystem) are part of the compiled
  mfact-core crate.
- Source: crates/mfact-core/src/thermo.rs, broker.rs, lean.rs, transport.rs (all `?? `
  untracked in git status)
- Verdict: REFUTED
- Evidence: crates/mfact-core/src/lib.rs declares only `pub mod receipt;` and `pub mod
  validate;` -- no `mod thermo/broker/lean/transport`. Live repro: `cargo test --lib --
  --list` (run from crates/mfact-core) lists exactly 19 tests, all from receipt/validate/lib
  -- zero from thermo, broker, or lean. `cargo build` on the bin target fails: `error[E0432]:
  unresolved import mfact_core::transport --> src/main.rs:1:5 | no transport in the root`.
  `cargo test --test thermo_integration_test` fails: `error[E0432]: unresolved import
  mfact_core::thermo --> tests/thermo_integration_test.rs:1:17 | could not find thermo in
  mfact_core`. This whole subsystem is orphaned/dead code that has never successfully built as
  part of the library -- exactly the 'orphaned modules' tripwire CLAUDE_ROADMAP.md section 10
  names.

### PA23 -- thermo_helmholtz doc comment: "The Helmholtz free energy of a state at a...

- Lens: agents-md-self-compliance
- Claim: thermo_helmholtz doc comment: "The Helmholtz free energy of a state at a given
  temperature" (and thermo_f: "The true thermodynamic process-work functional F(S,G)...
  representing the maximum extractable work").
- Source: crates/mfact-core/src/thermo.rs:16-21 and 23-28
- Verdict: REFUTED
- Evidence: The real, proven formula exists at procint/ProcInt/Thermo.lean:12-13 (`helmholtz
  state T := state.U - T * state.S`, with a genuine `linarith`-proved theorem `work_bounds`)
  -- thermo.rs's doc comments are copied almost verbatim from it. But thermo.rs's body never
  calls that Lean definition; it calls `unsafe { lp_thermo_energy_bio_signals(0) }`, an FFI
  symbol from a *different*, unrelated package (research-papers/bio_signals). Its generated
  body (research-papers/bio_signals/.lake/build/ir/Thermo.c:177-191) is a hardcoded two-branch
  constant lookup: `if (s==0) return lean_unsigned_to_nat(10); else return
  lean_unsigned_to_nat(0);` -- completely independent of the real input State (`_state.u`,
  labeled "Internal energy", is never read by the FFI call; only `_state.s` is used, and only
  in a final subtraction against the constant). Additionally the C function returns
  `lean_object*` but the Rust extern declares `-> u64` (thermo.rs:11), an ABI type-punning
  bug: Lean's `lean_unsigned_to_nat(10)` for small nats returns a tagged pointer (`lean_box`,
  i.e. `(n<<1)|1`), so the u64 actually observed is 21, not 10.

### PA24 -- lean_ffi_wrapper.c provides Lean/Mathlib FFI bindings (symbols prefixed...

- Lens: agents-md-self-compliance
- Claim: lean_ffi_wrapper.c provides Lean/Mathlib FFI bindings (symbols prefixed
  `lp_mathlib_...` matching the naming convention of genuinely compiler-generated symbols
  elsewhere in the same file, e.g. lp_thermo_energy_bio_signals).
- Source: crates/mfact-core/src/lean_ffi_wrapper.c:19-33 (new, untracked file)
- Verdict: REFUTED
- Evidence: Read the file directly: `lp_mathlib_Finset_instDecidableRelSubset___redArg`
  unconditionally `return 1;` (always "subset holds") regardless of its 3 arguments;
  `lp_mathlib_Multiset_ndunion___redArg` and `lp_mathlib_Multiset_sub___redArg`
  unconditionally `return lean_box(0);` (always empty/nil) regardless of arguments;
  `lp_procint_ProcInt_Powl_expansionDepth` unconditionally `return lean_box(5);` regardless of
  its 2 arguments. These are hand-written fake stand-ins for real Mathlib lemmas, named
  identically to the compiler-generated symbol convention, that discard all input and return
  fixed constants -- the exact 'fake hash-map pass over tiny fixtures' AGENTS.md forbids.

### PA32 -- Implicit framing that the 8 build+leanchecker PASSes are harmless/trivial...

- Lens: ci-workflow-reverify
- Claim: Implicit framing that the 8 build+leanchecker PASSes are harmless/trivial because
  'every .lean file in research-papers/* is empty right now' (i.e. nothing real is being
  hidden by the pass results).
- Source: commit e248101 message, paragraph 5 ('Verified locally...')
- Verdict: REFUTED
- Evidence: Working-tree .lean files are 0 bytes, but `git show HEAD:<path> | wc -c` shows
  real non-empty committed content for 5 of the 12 packages' root modules:
  pair_correlation/PairCorrelation.lean=892B, quantum_hall/QuantumHall.lean=1120B,
  random_walk/RandomWalk.lean=4990B, smfdcca/Smfdcca.lean=717B,
  hyperdimensional_cognitive/HyperdimensionalCognitive.lean=185B (all currently truncated to 0
  bytes only in the uncommitted working tree). I built this real HEAD content in an isolated
  `git worktree add --no-checkout` + sparse-checkout at /private/tmp/.../scratchpad/qh-verify
  (never touching the live working tree), via the same `lake --file lakefile.toml build`
  command the new CI workflows run: quantum_hall -- `error: QuantumHall.lean:4:2: unexpected
  token 'namespace'; expected ... 'theorem' ...` (a `/-- doc comment -/` illegally precedes
  `namespace`, a real Lean4 syntax error) -> build fails. pair_correlation -- identical
  `unexpected token 'namespace'` syntax error -> build fails. smfdcca -- same syntax error,
  plus `error: Smfdcca.lean:8:22: Unknown identifier `Real`` -> build fails. random_walk
  (mathlib deps reused via symlink to the existing .lake/packages cache, no network fetch) --
  `error: RandomWalk.lean:83:13: Unknown identifier `abs_add`` plus an unsolved-goals error on
  a Lipschitz-bound lemma -> build fails on an actually-broken proof. Only
  hyperdimensional_cognitive's real HEAD content builds successfully ('Build completed
  successfully (4 jobs)'); bio_signals/ortac_plus/scalar_dissipation have genuinely-empty HEAD
  content for their root modules (no divergence). So 4 of the 8 packages the commit calls
  'PASS' contain real, currently-broken proof content one git-checkout away from being
  exercised -- the '0-byte, so nothing to see' framing is false for exactly the packages where
  it mattered most.

## Major

### PA1 -- Commit 4382bc7 message: "Verified independently, not just via the...

- Lens: lean-session-work
- Claim: Commit 4382bc7 message: "Verified independently, not just via the implementing
  agent's self-report: rebuilt from current state via `lake build
  ProcInt.Playground.Swarm11.NewmanCorrespondence` (clean)" -- presented as standing
  verification of the file's kernel-checked status.
- Source: commit 4382bc7 (feat(procint): attempt cslib Newman's-lemma correspondence for
  Swarm11 replay); procint/ProcInt/Playground/Swarm11/NewmanCorrespondence.lean;
  procint/ProcInt/Playground/Swarm11.lean; procint/ProcInt/Playground.lean
- Verdict: DRIFTED
- Evidence: The literal command reproduces successfully today: `lake build
  ProcInt.Playground.Swarm11.NewmanCorrespondence` -> "Build completed successfully (537
  jobs)". But `grep -n "import.*NewmanCorrespondence" ProcInt --include=*.lean -r` returns
  NOTHING -- no file imports it, including `ProcInt/Playground/Swarm11.lean` itself (its
  imports are Standing/Workflow/Supply/Swarm/Replay/Experiment/Correspondence.AtomVM/Crown
  only, verified by `cat`). Consequently a fresh `lake build Playground` (cleared .lake cache
  first, forced genuine "Built" not "Replayed" status, confirmed via
  /tmp/fresh_playground_build.log) never touches NewmanCorrespondence.lean, and
  `.github/workflows/ci.yml` only runs `lake build AxiomAudit` and `lake build
  ProcInt.Fixtures.Positive ProcInt.Fixtures.Negative` for procint (grep confirmed, no
  Playground/Swarm11/NewmanCorrespondence targets anywhere in ci.yml). So the file's PROVEN
  status is real today but has zero standing continuous-verification: nothing short of a human
  remembering to name this exact module would catch a future breaking edit to Replay.lean's
  Commute/replay.

### PA2 -- Commit 35be175 message: "Verified independently (not just the implementing...

- Lens: lean-session-work
- Claim: Commit 35be175 message: "Verified independently (not just the implementing agent's
  self-report): rebuilt all four files from a clean state via `lake build
  ProcInt.MFW.Residue.{Obligation,EntailmentOrder,MinimalSupport,Antichain}`" -- implying
  these four files carry the same kernel-checked standing as the rest of the ProcInt tree.
- Source: commit 35be175 (feat(procint): implement Wave M0 -- minimal-antichain residue
  formalization);
  procint/ProcInt/MFW/Residue/{Obligation,EntailmentOrder,MinimalSupport,Antichain}.lean;
  procint/ProcInt.lean; procint/ProcInt/Playground.lean
- Verdict: DRIFTED
- Evidence: `grep -rn "import ProcInt.MFW.Residue" ProcInt --include=*.lean` returns only the
  three internal cross-imports among the four Residue files themselves
  (Antichain->MinimalSupport->EntailmentOrder->Obligation) -- nothing outside the chain
  imports it. `cat ProcInt.lean` (the default `defaultTargets = ["ProcInt"]` root) has zero
  mention of MFW/Residue among its ~50 imports. `cat ProcInt/Playground.lean` (the Playground
  target root) also never imports it -- Residue lives at `ProcInt/MFW/Residue/*` (top-level
  namespace), an entirely different tree from `ProcInt/Playground/MFW/*` (the POWL
  formalization actually wired into Playground.lean). ci.yml has zero reference to Residue.
  This wave is reachable from precisely one place: a human typing the four fully-qualified
  module names by hand, exactly as the commit message itself did. Unlike NewmanCorrespondence
  (at least nested under an active Swarm11 subtree), this wave is not reachable from ANY
  aggregator file in the whole package.

### PA4 -- Across all four commits (69f1301 MFW, fa6518c Swarm11, 35be175 Residue,...

- Lens: lean-session-work
- Claim: Across all four commits (69f1301 MFW, fa6518c Swarm11, 35be175 Residue, 4382bc7
  NewmanCorrespondence): headline theorems are "kernel-checked", "PROVEN", depend only on the
  standard trusted axiom set, "no sorryAx". Task specifically asks to re-run `#print axioms`
  on headline theorems named in each commit message.
- Source: procint/ProcInt/Playground/Swarm11/NewmanCorrespondence.lean (swap_locallyConfluent,
  not_terminating_swap_constUnit doc comments); procint/ProcInt/MFW/Residue/Antichain.lean,
  MinimalSupport.lean; procint/ProcInt/Playground/MFW/{Order,Runtime}.lean;
  procint/ProcInt/Playground/Swarm11/{Supply,Swarm,Replay,Experiment}.lean,
  Swarm11/Correspondence/AtomVM.lean; procint/ProcInt/Playground/Experimental/Workflow.lean,
  Experiment.lean
- Verdict: CONFIRMED
- Evidence: Built a scratch probe file (`/private/tmp/.../scratchpad/AxiomCheck.lean`)
  importing all target modules and ran `lake env lean AxiomCheck.lean` via the lock wrapper.
  Literal output for 19 headline theorems, all clean (no sorryAx, no custom axioms, only the 3
  Mathlib-standard ones): not_terminating_of_cycle (none), not_terminating_swap_constUnit
  (none), swap_disjoint_confluent [propext], swap_site_cases [propext, Quot.sound],
  swap_overlap_confluent [propext], swap_locallyConfluent [propext, Quot.sound],
  swap_confluent_of_terminating [propext, Classical.choice, Quot.sound],
  swap_replay_eq_of_confluent [propext], residue_is_antichain / residue_purity /
  orFree_residue_subsingleton / residue_support_and_pointwise_load_bearing /
  eq_of_subset_of_sufficient_of_isMinimalSupport (all [propext, Classical.choice,
  Quot.sound]), total_applyActivity_of_conservative [propext, Classical.choice, Quot.sound],
  minimalCovers_incomparable [propext, Quot.sound], replay_eq_of_traceEq [propext],
  run_standing_ne_proven [propext], replay_preserved (none), enabled_frontier_isAntichain
  (none), zero_unreceipted_completion (none), bind_right_identity/bind_assoc/graft_open_same
  [propext], run_ne_proven (none).

### PA5 -- Commit fa6518c: "`just swarm11-verify` end-to-end (STANDING: ALIVE,...

- Lens: lean-session-work
- Claim: Commit fa6518c: "`just swarm11-verify` end-to-end (STANDING: ALIVE,
  artifacts/swarm11-verifier.json written, exit 0)" and that the verifier's
  `sorryDeclarationCount`/`partialCount` gate is computed from
  `Environment.constants`/`Expr.hasSorry` on the compiled environment, not a self-report.
- Source: commit fa6518c message; procint/ProcInt/Playground/Swarm11Verifier.lean;
  procint/justfile:125-127
- Verdict: CONFIRMED
- Evidence: Ran `just swarm11-verify` end to end. Literal output: "compiled declarations : 708
  / compiled theorems : 179 / ... project axioms : 0 / unsafe declarations : 0 / partial
  declarations : 0 / sorry-bearing decls : 0 / crown checks: ... all 5 PASS / receipt:
  artifacts/swarm11-verifier.json / STANDING: ALIVE". Confirmed actual process exit code
  separately: `echo "ACTUAL EXIT CODE: $?"` -> 0. Confirmed
  `procint/artifacts/swarm11-verifier.json` was written with matching JSON fields. Read
  Swarm11Verifier.lean source directly: `computeAudit` uses `Lean.withImportModules` +
  `environment.constants` + `ConstantInfo.isTheorem/isPartial` + a private `constantHasSorry`
  using `info.type.hasSorry`/`value?.hasSorry` -- a real compiled-environment audit, and the
  `_unsafe_rec` partial-exclusion filter (`isCompilerSynthesizedRec`) matches only the exact
  last-name-component string "_unsafe_rec", not a loose substring -- not a gameable loophole.

### PA8 -- The task's specifically-flagged surprising claim: "`swap_locallyConfluent`...

- Lens: lean-session-work
- Claim: The task's specifically-flagged surprising claim: "`swap_locallyConfluent` really
  closes with zero extra hypotheses across all 5 cases" (doc comment: "`Standing: PROVEN`,
  kernel-checked, no `sorry`, no extra hypothesis beyond the two `Commute` witnesses each
  `Swap` instance already carries").
- Source: procint/ProcInt/Playground/Swarm11/NewmanCorrespondence.lean:300-347 (theorem
  swap_locallyConfluent, and swap_site_cases/swap_disjoint_confluent/swap_overlap_confluent it
  depends on)
- Verdict: CONFIRMED
- Evidence: Direct read of the proof term: `theorem swap_locallyConfluent {Event State : Type}
  (step : Event -> State -> State) : Relation.LocallyConfluent (Swap step)` -- the signature
  takes only `step` as an explicit argument; no `Commute`/`StronglyCommutingTriple`-shaped
  hypothesis parameter is added. Inside, `hab hac : Swap step a b`/`Swap step a c`
  (LocallyConfluent's own universally-quantified obligation, not caller-supplied extras) are
  destructured via `Swap.inv` to recover the `Commute` witnesses already bundled in the
  `Swap.intro` constructor. `rcases swap_site_cases ... with <...> | <...> | <...> | <...> |
  <...>` produces exactly 5 branches (same-window / disjoint-forward / overlap-forward /
  overlap-backward / disjoint-backward), each closed with `Relation.ReflTransGen.refl`,
  `swap_disjoint_confluent`, or `swap_overlap_confluent` -- no `sorry`, no `admit`, no
  unclosed goal. `#print axioms` (finding PA4) confirms [propext, Quot.sound] only.

### PA9 -- The task's other specifically-flagged surprising claim:...

- Lens: lean-session-work
- Claim: The task's other specifically-flagged surprising claim:
  "`not_terminating_swap_constUnit` really proves non-termination" of the raw Swap relation.
- Source: procint/ProcInt/Playground/Swarm11/NewmanCorrespondence.lean:105-133
  (not_terminating_of_cycle, not_terminating_swap_constUnit)
- Verdict: CONFIRMED
- Evidence: Direct read: `not_terminating_swap_constUnit : ¬ Relation.Terminating (Swap (Event
  := Bool) (State := Unit) (fun _ _ => ()))` is proved by constructing the concrete witness
  `hab : Swap ... [true,false] [false,true] := Swap.intro [] [] true false hCommute` and
  applying `not_terminating_of_cycle hab hab.symm`, where `Swap.symm` (line 79-86) genuinely
  proves symmetry of the raw relation from `Commute.symm`. `not_terminating_of_cycle` unfolds
  `Relation.Terminating r := WellFounded (fun a b => r b a)` and derives a contradiction via
  `hterm.asymm.asymm b a hab hba`. `#print axioms not_terminating_swap_constUnit` -> "does not
  depend on any axioms" (fully constructive, no classical logic needed) -- the strongest
  possible confirmation.

### PA13 -- release/certify.log (tracked, committed content at HEAD): "certified: v26.7.7...

- Lens: release-standing-drift
- Claim: release/certify.log (tracked, committed content at HEAD): "certified: v26.7.7 (proven
  197/397, objection type uninhabited)"
- Source: release/certify.log (git show HEAD:release/certify.log, tail)
- Verdict: DRIFTED
- Evidence: `git log --oneline -3 -- release/certify.log` shows it was last regenerated at
  commit 404b4c9, before the regression. `git show ac647a9 -- release/gates.json` diff:
  `-"evidenceComplete": true,-"countermodel_not_promoted": true / +"evidenceComplete":
  false,+"countermodel_not_promoted": false`. Commit ac647a9 ("chore: fix countermodel proofs
  mechanically", 2026-07-12 01:55:49) flipped a previously-passing gates.json to failing by
  promoting the countermodel/crown theorems to proven, but release/certify.log,
  release/standing.env's CERTIFIED_RELEASE field, and release/final_status.json were never
  regenerated afterward to reflect the break. The committed certify.log is a stale success
  record for a state that no longer exists.

### PA14 -- release/final_status.json core.status=ALIVE,...

- Lens: release-standing-drift
- Claim: release/final_status.json core.status=ALIVE,
  coreProven=197/coreTotalDecls=397/stated=7 (tag v26.7.7-procint-certified, tagCommit
  184e3a3); release/replay_report.json status=REPLAY_PASS, detail="...certify exit 0"
- Source: release/final_status.json:4-13, release/replay_report.json:1-6
- Verdict: DRIFTED
- Evidence: These figures are internally self-consistent only for the frozen tag
  184e3a3/942facf3, which `git rev-list --count 184e3a3..HEAD` shows is 31 commits behind
  current HEAD (fb23ef5). The live release-manifest.json at HEAD reports different numbers
  entirely: `python3 -c "...json.load(open('release/release-manifest.json'))..."` ->
  "artifacts total: 401, proven: 203, statedNotProven len: 2, runIdentifier: 6cbc680...,
  release: v26.7.7". Neither file carries a staleness/frozen-tag banner, so a reader has no
  way to tell from release/ alone that these numbers (and the "certify exit 0" claim) describe
  a 31-commit-old snapshot rather than the current tree, where certify now fails (PA11).

### PA15 -- STANDING.md, "## Certification": "`mfact certify release-manifest.json...

- Lens: release-standing-drift
- Claim: STANDING.md, "## Certification": "`mfact certify release-manifest.json gates.json` --
  exit 0"; and "## Crown jewel": "...neither direction is proven in this release"
- Source: STANDING.md (Certification section; Crown jewel section)
- Verdict: REFUTED
- Evidence: Live rerun (PA11) gives exit 1, directly contradicting the "exit 0" line.
  Separately, STANDING.md's crown-jewel narrative is itself now stale in the other direction:
  the current release-manifest.json shows `ProcInt.WfNet.sound_iff_shortCircuit_live_bounded`
  -> `proven: true` and the countermodel triple
  (`infinite_transition_countermodel_sound_not_bounded`, `crownCounter_sound`,
  `crownCounter_not_bounded`) all `proven: true` (verified via direct JSON inspection), while
  STANDING.md still describes the crown jewel as merely "stated" and unproven. `git log
  --oneline -3 -- STANDING.md` shows it was last touched at 2f4f0b5, on a separate branch
  lineage (common ancestor 945bfca with ac647a9's lineage) that was never reconciled with the
  countermodel-promotion commit before merge into HEAD.

### PA18 -- Both documents cite Problem Ledger entries P1-P12 as a stable, checkable...

- Lens: roadmap-marker-schema
- Claim: Both documents cite Problem Ledger entries P1-P12 as a stable, checkable reference
  ('P1-P12 stand as written there' -- referring to an external 'Rail B review exchange'),
  implying the full P1-P22 ledger is internally consistent and auditable within this
  repository.
- Source: ROADMAP_MATH_SPINE.md:351 ("Carried from Rail B: P1-P12 stand as written there");
  ROADMAP_SWARM_SUPPLY_CHAIN.md:777 ("Carried from ROADMAP_MATH_SPINE.md: P1-P13 stand as
  written there")
- Verdict: UNVERIFIABLE
- Evidence: `grep -rl "Rail B" /Users/sac/mfact --include="*.md"` (excluding target/) returns
  only ROADMAP_MATH_SPINE.md itself -- the source 'Rail B review exchange' document is not
  committed to this repo. `grep -rnE '\*\*P(1[0-2]|[1-9]) --' /Users/sac/mfact
  --include="*.md"` (excluding target/) returns zero matches anywhere in the repo. `grep -rl
  "Problem Ledger" /Users/sac/mfact --include="*.md"` returns only the two roadmap files under
  audit. So P1 through P12 -- 12 of the 22 total P-numbers these two documents reference --
  have no defining text anywhere in this repository; a reader cannot verify what they actually
  claim. By contrast P13-P22 (10 entries) ARE each defined exactly once with a bold heading
  (`grep -noE 'P[0-9]+\b'` on both files, cross-checked against bulleted definitions), with no
  skips and no ambiguous duplicates -- that portion of the ledger is internally clean. The
  defect is specifically that roughly half the cited ledger is an unauditable external
  reference presented alongside a self-contained, verifiable half.

### PA25 -- broker.rs::generate_pddl_query performs a real PDDL plan validity check via...

- Lens: agents-md-self-compliance
- Claim: broker.rs::generate_pddl_query performs a real PDDL plan validity check via the
  Lean-compiled `lp_procint_ProcInt_PddlPlan_validCheck` before returning a query.
- Source: crates/mfact-core/src/broker.rs:74-101
- Verdict: REFUTED
- Evidence: Read the function body directly: `let valid = unsafe { ...
  lp_procint_ProcInt_PddlPlan_validCheck(...) };` is computed, then only interpolated into a
  debug string: `Ok(PddlQuery { problem_statement: format!("query_for_{}_valid_{:?}",
  state.shape_target, valid) })`. The function returns `Ok(...)` unconditionally regardless of
  the value of `valid` -- the validity result is never branched on, so an invalid plan and a
  valid plan produce the identical control-flow outcome (success).

### PA26 -- broker.rs::execute_powl_manufacture comment: "Explicitly cap the POWL...

- Lens: agents-md-self-compliance
- Claim: broker.rs::execute_powl_manufacture comment: "Explicitly cap the POWL recursive
  expansion depth (<= 256)".
- Source: crates/mfact-core/src/broker.rs:106-116
- Verdict: REFUTED
- Evidence: The line immediately below the comment calls
  `lp_procint_ProcInt_Powl_expansionDepth(lean_str, ext_lean_box(513))` -- 513 exceeds the
  stated 256 cap in the same function, and (per PA24) the callee ignores both arguments and
  always returns `lean_box(5)` anyway, so no cap is actually enforced by any mechanism.

### PA27 -- transport.rs (SSE server exposing broker + thermo state) and the accompanying...

- Lens: agents-md-self-compliance
- Claim: transport.rs (SSE server exposing broker + thermo state) and the accompanying
  tests/sse_transport_test.rs are functioning parts of the crate.
- Source: crates/mfact-core/src/transport.rs:1-11,
  crates/mfact-core/tests/sse_transport_test.rs:1-5
- Verdict: REFUTED
- Evidence: crates/mfact-core/Cargo.toml lists dependencies blake3, rayon, serde, serde_json,
  thiserror only -- no axum, tokio, tower-http, futures-util, tokio-stream, or
  reqwest_eventsource, all of which transport.rs/main.rs/sse_transport_test.rs import. Live
  repro: `cargo test --test sse_transport_test` (run alongside thermo_integration_test) fails
  to compile with the same class of unresolved-import errors as PA22; the crate cannot even
  resolve these crate names, let alone run the SSE load test.

### PA28 -- `just lint` / scripts/rigor_linter.py is the enforcement mechanism ("Rely...

- Lens: agents-md-self-compliance
- Claim: `just lint` / scripts/rigor_linter.py is the enforcement mechanism ("Rely exclusively
  on rigor_linter.py, lake build, and cargo check" per ROADMAP.md:32) that would have caught
  the above.
- Source: ROADMAP.md:32, justfile:379-382 (`lint: python3 scripts/rigor_linter.py`)
- Verdict: DRIFTED
- Evidence: The only git hook present, .git/hooks/pre-commit, checks only the
  generated-vs-source admission law and never invokes rigor_linter.py or `just lint`; grep of
  .github for `rigor_linter` and `just lint` returns nothing. Live run `python3
  scripts/rigor_linter.py` from repo root exits 1 (LINTER FAILED), but its only real
  (non-worktree) violation is a `sorry` inside
  procint/ProcInt/Playground/Swarm11Verifier.lean, which is explicitly
  hand-authored/exploratory per its own header comment (`-- Hand-authored. Not rendered by
  ggen.`) and outside this lens's scope. The linter cannot catch PA22-PA27 above because it
  has no orphaned-module or discarded-FFI-result-branching check (see PA29), and is not wired
  into any automated gate that would block a commit containing them.

### PA33 -- 8 of 12 packages (bio_signals, hyperdimensional_cognitive, ortac_plus,...

- Lens: ci-workflow-reverify
- Claim: 8 of 12 packages (bio_signals, hyperdimensional_cognitive, ortac_plus,
  pair_correlation, quantum_hall, random_walk, scalar_dissipation, smfdcca) pass both build
  and leanchecker cleanly today; the other 4 (floquet_photonic, signal_criticality,
  minimal_measures, star_graphs) fail with the named root causes.
- Source: commit e248101 message, paragraphs 5-6
- Verdict: CONFIRMED
- Evidence: Re-ran the exact commands from the new workflow YAMLs against the live (dirty,
  0-byte) working tree via `just _lake "cd research-papers/<pkg> && lake --file lakefile.toml
  build"` then `... env leanchecker <Module>`, right now: all 8 named packages returned
  BUILD_RC=0 and LEANCHECKER_RC=0 with 'Build completed successfully (3 jobs)' and empty
  (silent-pass) leanchecker output. The 4 named failures reproduced exactly as described:
  floquet_photonic build fails with `ld64.lld: error: undefined symbol: main` (empty
  Main.lean); minimal_measures/signal_criticality/star_graphs all fail build with `error:
  <Module>: some modules have bad imports` and leanchecker with `uncaught exception: Could not
  find any oleans for: <Module>` (missing root module file next to their Basic.lean).

### PA38 -- G40 ("crates/mfact-core/target/** build artifacts are committed to git") is...

- Lens: gap-ledger-staleness
- Claim: G40 ("crates/mfact-core/target/** build artifacts are committed to git") is listed
  Status: BLOCKED with 4233 tracked target/ paths still present and no fix applied.
- Source: GAP_LEDGER_v26.7.12.md:828-844
- Verdict: DRIFTED
- Evidence: `git ls-files crates/mfact-core/target | wc -l` => 0 (ledger claimed 4233). `git
  show --stat c0872bf` shows exactly this fix: ~4233 deletions under crates/mfact-core/target/
  plus .gitignore changed from anchored '/target' (repo-root only) to unanchored 'target/'
  (all workspace members), matching the ledger's own prescribed fix ('git rm -r --cached
  crates/mfact-core/target and gitignore target/'). Commit c0872bf ('chore: stop tracking
  crates/mfact-core/target/, fix root .gitignore scope') landed after the ledger-writing
  commit 9983df2 (9 commits later in git log). The ledger's Status field for G40 was never
  updated from BLOCKED to CLOSED despite the fix landing exactly where the ledger itself
  recommended ('applying the fix directly against v26.7.12-close where the artifacts live').

### PA39 -- G21's closure evidence states 'no MFW dir exists under procint' as the basis...

- Lens: gap-ledger-staleness
- Claim: G21's closure evidence states 'no MFW dir exists under procint' as the basis for
  blanking CROWN_ABSTRACT_COMPOSITION and leaving MFW_M0_RESIDUE_FORMALIZED as an unproduced
  target marker.
- Source: GAP_LEDGER_v26.7.12.md:477-495; ROADMAP_MATH_SPINE.md:398
- Verdict: DRIFTED
- Evidence: `ls procint/ProcInt/MFW/Residue/*.lean` now lists Obligation.lean,
  EntailmentOrder.lean, MinimalSupport.lean, Antichain.lean (added by commit 35be175
  'implement Wave M0 -- minimal-antichain residue formalization', post-dating the ledger).
  Reproduced live: `export PATH="$HOME/.elan/bin:$PATH"; just _lake "cd procint &&
  /Users/sac/.elan/bin/lake build ProcInt.MFW.Residue.Antichain"` => 'Build completed
  successfully (624 jobs)'. `grep -rn 'sorry\|admit'` over the 4 files returns only prose
  using 'admitted'/'admit' as this package's own kernel-standing vocabulary, never a Lean
  `sorry`/`admit` term. ROADMAP_MATH_SPINE.md:398 'MFW_M0_RESIDUE_FORMALIZED=' remains blank
  though the artifact it names now exists and builds clean; line 386
  'CROWN_I_TO_V=TARGET_THEOREM ... no Lean artifact exists yet' is also stale for the Crown I
  / Wave M0 slice specifically. This is exactly the ledger's own 'a producer must derive the
  marker from real evidence' rule (G22) being violated by the ledger's own G21 fix.

### PA40 -- G2 (crates/mfact-core excluded from workspace; cargo check --workspace...

- Lens: gap-ledger-staleness
- Claim: G2 (crates/mfact-core excluded from workspace; cargo check --workspace falsely green)
  -- check whether it is unaffected by any later-session work.
- Source: GAP_LEDGER_v26.7.12.md:99-125
- Verdict: CONFIRMED
- Evidence: `cat Cargo.toml` => still no [workspace] table. `cargo metadata --no-deps
  --format-version=1` => workspace_members: ['path+file:///Users/sac/mfact#0.1.0'], packages:
  ['mfact'] only. `cargo check --workspace` => 'Checking mfact v0.1.0 ... Finished `dev`
  profile' (falsely green exactly as ledger describes), unaffected by G10's cc
  build-dependency fix (3e4d0ec) or any of the ~15 later procint/roadmap/CI commits. Also
  reproduced G11's still-open blocker that G2's own fix note anticipates ('expect red until
  G10/G11 land'): `cd crates/mfact-core && cargo check --all-targets` => error[E0432]
  unresolved import `mfact_core::transport` at src/main.rs:1, error[E0433] unresolved crate
  `tokio` at src/main.rs:3, error[E0752] async main not allowed at src/main.rs:4 -- main.rs
  remains untracked/undeclared exactly as G11 describes. G2 status is unaffected and the
  ledger's BLOCKED status remains accurate.

## Minor

### PA3 -- Commit 35be175: "rebuilt all four files from a clean state via `lake build...

- Lens: lean-session-work
- Claim: Commit 35be175: "rebuilt all four files from a clean state via `lake build
  ProcInt.MFW.Residue.{Obligation,EntailmentOrder,MinimalSupport,Antichain}` (633 jobs, zero
  errors/warnings)".
- Source: commit 35be175 message, quantitative job-count claim
- Verdict: DRIFTED
- Evidence: Ran `rm -rf .lake/build/lib/lean/ProcInt/MFW .lake/build/ir/ProcInt/MFW` then the
  exact literal command `just _lake "cd procint && lake build ProcInt.MFW.Residue.Obligation
  ProcInt.MFW.Residue.EntailmentOrder ProcInt.MFW.Residue.MinimalSupport
  ProcInt.MFW.Residue.Antichain"` -> output ends "Build completed successfully (624 jobs)",
  not 633. Zero errors/warnings both times (that half of the claim holds), but the specific
  job count in the commit message does not reproduce on the current tree/cache state.

### PA6 -- Commit fa6518c: "Verified: every module individually, both umbrella imports,...

- Lens: lean-session-work
- Claim: Commit fa6518c: "Verified: every module individually, both umbrella imports, the full
  `lake build Playground` target (8686 jobs)... all succeed".
- Source: commit fa6518c message
- Verdict: CONFIRMED
- Evidence: Deleted .lake cache for MFW/Experimental/Swarm11* (`rm -rf
  .lake/build/{lib,ir}/...`) to force a genuine from-scratch rebuild, then ran `just _lake "cd
  procint && lake build Playground"` through the lock wrapper. Log
  (/tmp/fresh_playground_build.log) shows every target module transitioning through real
  "Built" (not "Replayed") status lines, e.g. "Built ProcInt.Playground.Swarm11.Supply (37s)",
  "Built ProcInt.Playground.Swarm11Tests (13s)", ending with the literal line "Build completed
  successfully (8686 jobs)." -- exact numeric match to the commit's claim, with zero errors.

### PA7 -- Recurring across all four commits: "grep for sorry/admit across the added...

- Lens: lean-session-work
- Claim: Recurring across all four commits: "grep for sorry/admit across the added tree ... is
  empty" (modulo doc-comment/identifier-prefix mentions).
- Source: commits 69f1301, fa6518c, 35be175, 4382bc7 messages
- Verdict: CONFIRMED
- Evidence: `xargs -0 grep -n "sorry" < filelist` and `grep -nE "\badmit\b"` across every
  .lean file under ProcInt/Playground/MFW, ProcInt/Playground/Experimental(+Walkthrough),
  ProcInt/Playground/Swarm11(+Tests, +Correspondence/AtomVM), and ProcInt/MFW/Residue returned
  zero tactic/term uses of `sorry` or `admit`. Every hit was prose ("No `sorry`.", "admit --
  concrete admission") or the verifier's own field name `sorryDeclarationCount`. This matches
  the `#print axioms` results above (no sorryAx anywhere) -- no phantom-sorry cascade of the
  kind this session caught in the three earlier external packages.

### PA10 -- Commit 69f1301: MFW "ships zero Mathlib dependency (only Lean's bundled...

- Lens: lean-session-work
- Claim: Commit 69f1301: MFW "ships zero Mathlib dependency (only Lean's bundled Std)", and
  EntailmentOrder.lean's doc comment: "The `AdmittedObligationOrder` class is declared but not
  used by any Wave M0 theorem".
- Source: commit 69f1301 message; procint/ProcInt/Playground/MFW/*.lean;
  procint/ProcInt/MFW/Residue/EntailmentOrder.lean
- Verdict: CONFIRMED
- Evidence: `grep -rn "^import Mathlib" ProcInt/Playground/MFW ProcInt/Playground/MFW.lean`
  returns nothing; the only imports present are `Std`/`Std.Tactic`. Direct read of
  EntailmentOrder.lean: `class AdmittedObligationOrder (Obligation : Type*) extends Preorder
  Obligation` is declared with no theorem in the same file referencing it, and a repo-wide
  grep for `AdmittedObligationOrder` shows only this declaration and its own doc-comment prose
  -- no theorem instantiates or uses it, exactly as claimed.

### PA16 -- The theorems newly marked proven in the countermodel promotion...

- Lens: release-standing-drift
- Claim: The theorems newly marked proven in the countermodel promotion
  (`ProcInt.WfNet.sound_iff_shortCircuit_live_bounded`,
  `ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded`,
  `ProcInt.crownCounter_sound`, `ProcInt.crownCounter_not_bounded`) are genuine kernel-checked
  Lean theorems, not stubs
- Source: procint/ProcInt/Workflow/Soundness.lean:270-273,
  procint/ProcInt/Workflow/Countermodel.lean:223,277-284
- Verdict: CONFIRMED
- Evidence: `just _lake "cd procint && lake build"` -> "Build completed successfully (8614
  jobs)" (0 errors, clean rebuild through the lock wrapper). Read of Countermodel.lean:223
  shows `theorem crownCounter_sound : WfNet.Sound crownCounterWfNet := by ...` and
  Soundness.lean:270-271 shows `theorem WfNet.sound_iff_shortCircuit_live_bounded {P T : Type}
  [DecidableEq P] [Finite T] (W : WfNet P T) : W.sound_iff_shortCircuit_live_bounded_statement
  := by ...` -- a real proof under an explicit `[Finite T]` hypothesis, distinct from the
  separate `_statement`-suffixed unproven predicate def. release-manifest.json axiom lists for
  these four names show `[]` or the standard `propext/Classical.choice/Quot.sound` trio,
  consistent with genuine kernel admission and no unauthorized axioms. This confirms the
  defect audited above is entirely in the release/self-report bookkeeping layer (unwired
  guard, stale committed logs, non-reconciled counts) -- not in the underlying Lean proofs,
  which do check out.

### PA19 -- Per the docs' own Marker Schema law, achievement markers must stay blank...

- Lens: roadmap-marker-schema
- Claim: Per the docs' own Marker Schema law, achievement markers must stay blank until a real
  producer script derives them; the task's hypothesis was that some `=true`/`=PROVEN`-style
  achievement marker would be found asserted without a hedge, and that no producer mechanism
  exists.
- Source: ROADMAP_MATH_SPINE.md §6 (lines 368-410); ROADMAP_SWARM_SUPPLY_CHAIN.md §5 (lines
  864-908)
- Verdict: CONFIRMED
- Evidence: `grep -n "=true" ROADMAP_MATH_SPINE.md ROADMAP_SWARM_SUPPLY_CHAIN.md` -> zero
  matches. `grep -nE "=PROVEN[^_A-Za-z]|=PROVEN$"` on both files -> zero matches. All 11
  achievement markers in the spine doc (lines 393-403) and all 10 in the swarm doc (lines
  892-901) are literally blank (`KEY=` with only a trailing comment, nothing else). `find
  /Users/sac/mfact -iname "build_spine_markers.py"` and `find /Users/sac/mfact -iname
  "predicate_namespace_lint.py"` (both excluding target/) return nothing -- neither cited
  producer script exists. `grep -n "predicate_namespace_lint\|build_spine_markers"
  /Users/sac/mfact/justfile` returns nothing, and reading the actual `check:` recipe in the
  justfile shows it runs `just build`, `just regen-check`, `just test`, `just paper-check`,
  `python3 scripts/report.py status --write` -- no marker-producer or lint step, exactly
  matching the docs' own admission that these are unwired targets. The mechanical KEY=VALUE
  achievement-marker schema is followed with zero exceptions in both files; the
  standing-overclaim in PA17 occurs in ordinary prose that this schema does not police.

### PA20 -- The specific falsifiable evidentiary claims underpinning both documents (Lean...

- Lens: roadmap-marker-schema
- Claim: The specific falsifiable evidentiary claims underpinning both documents (Lean file
  existence, sorry-counts, theorem names, and the P22 'kernel-checked'
  NewmanCorrespondence.lean result) are accurate.
- Source: ROADMAP_MATH_SPINE.md:270-273 (Wave M0 residue files);
  ROADMAP_SWARM_SUPPLY_CHAIN.md:74-78, 620-632 (D5/S1/S2 Playground ports), :839-844 (P22
  NewmanCorrespondence.lean)
- Verdict: CONFIRMED
- Evidence: All 4 MFW/Residue files (Antichain.lean, Obligation.lean, MinimalSupport.lean,
  EntailmentOrder.lean) contain zero actual `sorry` tactic tokens (the only 'sorry' grep hits
  are backtick-quoted prose reading 'No `sorry`'); built clean via the required lock wrapper:
  `export PATH="$HOME/.elan/bin:$PATH" && just _lake "cd procint && lake build
  ProcInt.MFW.Residue.Antichain ProcInt.MFW.Residue.MinimalSupport
  ProcInt.MFW.Residue.EntailmentOrder ProcInt.MFW.Residue.Obligation"` -> 'Build completed
  successfully (624 jobs).' Playground/Swarm11/Swarm.lean and Supply.lean contain `theorem
  minimalCovers_incomparable` and `theorem total_applyActivity_of_conservative` exactly as
  named, 0 sorry each, and `grep -n "Swarm11" /Users/sac/mfact/.mfact/artifacts.toml` returns
  nothing, confirming they are unledgered as the doc states. Playground/Multifractal's 10
  files each show 0 sorry. NewmanCorrespondence.lean's 2 'sorry' grep hits are both inside
  backtick-quoted prose ('no `sorry`'), not actual tactic invocations, and it built clean:
  `just _lake "cd procint && lake build ProcInt.Playground.Swarm11.NewmanCorrespondence"` ->
  'Built ProcInt.Playground.Swarm11.NewmanCorrespondence (1.6s) ... Build completed
  successfully (537 jobs).' All theorem names cited for P22 (Swap.symm,
  not_terminating_of_cycle, swap_locallyConfluent, etc.) are present via `grep -n
  "^theorem\|^lemma"`. No drift found on any of these specific, checkable claims.

### PA21 -- Both documents cite specific numbered sections of CLAUDE_ROADMAP.md as their...

- Lens: roadmap-marker-schema
- Claim: Both documents cite specific numbered sections of CLAUDE_ROADMAP.md as their source
  for definitions -- e.g. 'REAL_EDGE (`CLAUDE_ROADMAP.md` §10)', 'Same-object falsifiers only
  (`CLAUDE_ROADMAP.md` §12)', 'admitted observation (section 1 of `CLAUDE_ROADMAP.md`)'.
- Source: ROADMAP_MATH_SPINE.md:437-438 (§10), :489-491 (§12), :422-423 (section 1)
- Verdict: DRIFTED
- Evidence: `grep -n "§" /Users/sac/mfact/CLAUDE_ROADMAP.md` returns zero matches -- the
  target document uses unnumbered `##` markdown headers throughout (`grep -n "^## "
  CLAUDE_ROADMAP.md` shows headers like 'Production reachability is a standing surface', 'Zero
  unreceipted actuation', with no numeric or §-style labeling anywhere). The cited *content*
  does genuinely exist (REAL_EDGE/TEST_ONLY_EDGE definitions at CLAUDE_ROADMAP.md:815-823;
  'Challenge only with a same-object falsifier' at line 1399), so this is a citation-precision
  defect rather than a missing-content defect -- the two roadmap docs invent a §-numbering
  scheme for a file that does not use one, making the specific pinpoint citations unverifiable
  by section number even though the underlying claims are locatable by text search.

### PA29 -- CLAUDE_ROADMAP.md section 10 ("Rigor-linter lesson") lists 'orphaned modules...

- Lens: agents-md-self-compliance
- Claim: CLAUDE_ROADMAP.md section 10 ("Rigor-linter lesson") lists 'orphaned modules' and
  'public functions referenced only by tests' as tripwires the linter checks for.
- Source: CLAUDE_ROADMAP.md:860-872
- Verdict: REFUTED
- Evidence: Read scripts/rigor_linter.py in full: it implements exactly 9 checks (fake Lean
  syntax, unproved `sorry`, empty traits, zero-field structs, PhantomData-only structs, empty
  trait impls, unimplemented!()/todo!(), dead _v2/_alt functions, discarded-input
  constructors, sci-fi vocabulary, claim-without-mechanism doc comments, hedge-comment/mock
  strings). None of these detect a module file that exists on disk but is never declared with
  `mod`/`pub mod` in lib.rs (PA22) -- the roadmap's own stated tripwire list is aspirational
  relative to the actual script.

### PA30 -- ROADMAP_GAP_THERMO.md's finding that 'there is no structural implementation...

- Lens: agents-md-self-compliance
- Claim: ROADMAP_GAP_THERMO.md's finding that 'there is no structural implementation of the
  thermodynamic functional F(S,G)... severe implementation gap' has since been addressed by
  adding scalar_dissipation/sparse_chaos_diagnostic/thermo_f to thermo.rs.
- Source: ROADMAP_GAP_THERMO.md:11-14 (new, untracked doc) vs. crates/mfact-core/src/thermo.rs
  (new, untracked)
- Verdict: DRIFTED
- Evidence: thermo.rs does define functions with matching names (`scalar_dissipation`,
  `sparse_chaos_diagnostic`, `thermo_f`, `in_control`), but per PA22 and PA23 none of them are
  reachable from the compiled library and the FFI-backed ones are hardcoded constants -- so
  the gap the roadmap doc itself describes ('no structural implementation... in the execution
  stack') is still open in the live, buildable tree despite the appearance of closing source
  files.

### PA31 -- crates/mfact-core/src/main.rs implements the server entrypoint ("Starting...

- Lens: agents-md-self-compliance
- Claim: crates/mfact-core/src/main.rs implements the server entrypoint ("Starting server on
  127.0.0.1:8080" then `transport::run_server(...)`).
- Source: crates/mfact-core/src/main.rs:1-7 (new, untracked, 7 lines)
- Verdict: REFUTED
- Evidence: Live repro (`cargo build` from crates/mfact-core): `error[E0432]: unresolved
  import mfact_core::transport`, `error[E0433]: cannot find module or crate tokio in this
  scope`, `error[E0752]: main function is not allowed to be async` (the `#[tokio::main]`
  attribute macro can't exist without the tokio dependency, so plain `async fn main` is
  rejected by rustc). The binary target does not compile at all.

### PA34 -- Every .lean file in all 12 research-papers/* packages is 0 bytes right now.

- Lens: ci-workflow-reverify
- Claim: Every .lean file in all 12 research-papers/* packages is 0 bytes right now.
- Source: commit e248101 message, paragraph 5
- Verdict: CONFIRMED
- Evidence: `find research-papers/<pkg> -name '*.lean' -not -path '*/.lake/*' | xargs wc -c`
  across all 12 packages right now shows every single .lean file (lakefile.lean, root modules,
  Basic.lean, Thermo.lean, Main.lean, etc.) at 0 bytes, no exceptions.

### PA35 -- 12 new .github/workflows/lean-<pkg>.yml files exist at the repo root and the...

- Lens: ci-workflow-reverify
- Claim: 12 new .github/workflows/lean-<pkg>.yml files exist at the repo root and the 12 old
  misplaced research-papers/<pkg>/.github/workflows/lean_action_ci.yml files were deleted,
  leaving one source of truth per package.
- Source: commit e248101 message + diffstat
- Verdict: CONFIRMED
- Evidence: `ls .github/workflows/ | grep lean` lists exactly the 12 claimed files
  (lean-bio-signals.yml, lean-floquet-photonic.yml, lean-hyperdimensional-cognitive.yml,
  lean-minimal-measures.yml, lean-ortac-plus.yml, lean-pair-correlation.yml,
  lean-quantum-hall.yml, lean-random-walk.yml, lean-scalar-dissipation.yml,
  lean-signal-criticality.yml, lean-smfdcca.yml, lean-star-graphs.yml). `python3 -c "import
  yaml; yaml.safe_load(open(f))"` over all 12 returns 12/12 OK right now. `find
  research-papers -path '*/.github/workflows/lean_action_ci.yml'` returns zero hits at the
  package-root level (the only remaining hits are unrelated vendored files under each
  package's own
  `.lake/packages/{plausible,LeanSearchClient}/.github/workflows/lean_action_ci.yml`, which
  are third-party dependency copies never touched by this commit).

### PA36 -- floquet_photonic's default-target build fails (undefined symbol: main) but...

- Lens: ci-workflow-reverify
- Claim: floquet_photonic's default-target build fails (undefined symbol: main) but 'lake
  build FloquetPhotonic (the library target) succeeds and leanchecker passes on it' --
  implying this is a meaningful signal about the real CI job.
- Source: commit e248101 message + inline comment in
  .github/workflows/lean-floquet-photonic.yml
- Verdict: DRIFTED
- Evidence: The local claim itself reproduces: build via `lake --file lakefile.toml build`
  (default targets, which include the failing executable) exits 1 with `undefined symbol:
  main`, while a separate `lake --file lakefile.toml env leanchecker FloquetPhotonic` (run
  right after, reusing the partial build's oleans) exits 0 silently. But `grep -n
  'continue-on-error\|if:' .github/workflows/lean-*.yml` returns zero matches across all 12
  files -- none of them guard the leanchecker step to run after a failed build step. On GitHub
  Actions' default behavior, a failing prior step skips subsequent steps, so the real CI job
  for floquet_photonic will never reach the leanchecker step at all; the 'leanchecker passes
  on the library target' fact is real but is not something the configured workflow will ever
  actually exercise or report.

### PA37 -- The current 0-byte state of research-papers/*.lean 'match[es] pre-existing...

- Lens: ci-workflow-reverify
- Claim: The current 0-byte state of research-papers/*.lean 'match[es] pre-existing dirty
  state from before this session', i.e. this session did not itself cause the truncation.
- Source: commit e248101 message, paragraph 5
- Verdict: UNVERIFIABLE
- Evidence: `stat` on the truncated files (e.g. quantum_hall/QuantumHall.lean,
  pair_correlation/PairCorrelation.lean, random_walk/RandomWalk.lean, smfdcca/Smfdcca.lean,
  hyperdimensional_cognitive/HyperdimensionalCognitive.lean) shows a common mtime of
  2026-07-12 17:12:27, roughly 5h13m before commit e248101 (2026-07-12 22:30:33 -0700). The
  last commit to actually add real content to these files was c7413cb on 2026-07-11 14:46:42.
  This timing is consistent with the truncation predating the CI-relocation work, but there is
  no independent way to confirm what process performed the truncation or exactly when 'this
  session' began, so the claim is plausible but not independently provable from repo state
  alone.

### PA41 -- G14's subject file (scripts/rigor_linter.py, cited for being blind to empty...

- Lens: gap-ledger-staleness
- Claim: G14's subject file (scripts/rigor_linter.py, cited for being blind to empty .lean
  files) is functioning correctly / unaffected by later work.
- Source: GAP_LEDGER_v26.7.12.md:344-369; scripts/rigor_linter.py:21-22
- Verdict: REFUTED
- Evidence: `python3 scripts/rigor_linter.py` => exit 1, flags
  procint/ProcInt/Playground/Swarm11Verifier.lean: 'Unproved theorem detected (sorry)'. Direct
  inspection shows zero actual `sorry` tactics in that file; the match is rigor_linter.py:21's
  `\bsorry\b` regex hitting the string literal 'sorry-bearing decls' at
  Swarm11Verifier.lean:182 (`IO.println s!"sorry-bearing decls :
  {receipt.sorryDeclarationCount}"`) -- the hyphen after 'sorry' satisfies `\b` (non-word
  char), so the regex fires on a human-readable log label inside a tool that itself audits for
  real sorries. Confirmed via python3 re.finditer reproducing the exact match span.
  Swarm11Verifier.lean was added post-ledger by commit fa6518c. justfile:382 `lint` recipe and
  scripts/report.py:244-250 both invoke this exact script, so `just lint` / `python3
  scripts/report.py status` both fail today for a reason absent from the ledger and unrelated
  to G14's documented empty-file blindness -- the same broken gate now also produces false
  positives on legitimate new procint code.

### PA42 -- G19 ('Four substantive procint Lean modules orphaned from every build target...

- Lens: gap-ledger-staleness
- Claim: G19 ('Four substantive procint Lean modules orphaned from every build target and the
  axiom audit') names exactly four orphaned modules as the scope of the defect.
- Source: GAP_LEDGER_v26.7.12.md:438-454
- Verdict: DRIFTED
- Evidence: `find procint -iname '*.lean' -path '*Playground*'` now lists ~95 files, including
  ~40 added post-ledger: Swarm11 (9 files, fa6518c), MFW/POWL (6 files, 69f1301), Multifractal
  (9 files, 81484c6), Experimental (13 files, ff01033), Ticket012 (4 files). `grep -n
  'Swarm11\|MFW\|Multifractal\|Experimental\|Playground' procint/AxiomAudit.lean` => 0
  matches; AxiomAudit.lean's sole import is `import ProcInt`, and ProcInt.lean never imports
  the Playground tree, so none of the ~40 newly-added files are covered by the kernel-axiom
  guard list, replicating G19's exact defect pattern at roughly 10x the scope. Mitigating
  context: procint/ProcInt/Playground.lean's own doc-comment (checked directly) explicitly
  disclaims release-standing ('not part of `defaultTargets` or `testDriver` ... never
  `ARTIFACT_DRIFT_REFUSED` or a release-standing regression'), so this is self-disclosed
  scaffolding, not a hidden claim -- but the ledger has no updated entry reflecting the
  defect's growth.

### PA43 -- G36 ('Empty lakefile.lean shadows the real lakefile.toml in 7 bridge dirs')...

- Lens: gap-ledger-staleness
- Claim: G36 ('Empty lakefile.lean shadows the real lakefile.toml in 7 bridge dirs') remains
  Status: BLOCKED, unmodified, no fix applied anywhere.
- Source: GAP_LEDGER_v26.7.12.md:753-773
- Verdict: DRIFTED
- Evidence: All 7 named 0-byte lakefile.lean files (revops_turbulence, scalar_dissipation,
  smfdcca, ortac_plus, hyperdimensional_cognitive, bio_signals, floquet_photonic) are
  confirmed still present, still 0 bytes, still untracked (`git ls-files --error-unmatch`
  fails for each) -- the underlying defect is unchanged. However commit e248101 ('ci: relocate
  12 misplaced Lean CI workflows to repo root, wire leanchecker') added
  .github/workflows/lean-bio-signals.yml (and 11 siblings) with `build-args: "--file
  lakefile.toml"` and an inline comment citing this exact shadowing bug verbatim
  ('lakefile.lean is an empty stray file that Lake prefers over lakefile.toml ... --file
  forces the real lakefile.toml. Verified locally 2026-07-12'). This CI-scoped workaround is
  not recorded anywhere in the ledger and could be mistaken for a fix; a bare `lake build` in
  any of the 7 dirs (e.g. via the justfile's `_lake` lock wrapper without an explicit --file)
  is still silently shadowed exactly as G36 describes.

### PA44 -- G39 ('Eight bridge dirs lack a lean-toolchain pin') Evidence lists...

- Lens: gap-ledger-staleness
- Claim: G39 ('Eight bridge dirs lack a lean-toolchain pin') Evidence lists random_walk,
  pair_correlation, quantum_hall, star_graphs, aeneas_rust_verification, sound_borrow_checking
  as examples currently missing the pin.
- Source: GAP_LEDGER_v26.7.12.md:805-826 (evidence at 821-824)
- Verdict: REFUTED
- Evidence: `git cat-file -e 9983df2:research-papers/random_walk/lean-toolchain` (the
  ledger-writing commit itself) => object exists; identical result for pair_correlation,
  quantum_hall, star_graphs -- all four already carried `leanprover/lean4:v4.31.0` pins as of
  commit c7413cb, an ancestor of the ledger-write commit, so the ledger's own Evidence
  paragraph was already inaccurate for 4 of its 6 named directories at write time (not
  something later-session work changed). Only aeneas_rust_verification and
  sound_borrow_checking genuinely lack a lean-toolchain file today (`test -f` => MISSING for
  both) -- and both are called out separately in G39's own Blocked note as wholly uncommitted
  working-tree-only directories, so the gap's real footprint is roughly a third of what the
  Evidence text states.

### PA45 -- G13 Evidence states 'justfile has zero research-papers lake recipes' as proof...

- Lens: gap-ledger-staleness
- Claim: G13 Evidence states 'justfile has zero research-papers lake recipes' as proof that no
  build/verification gate touches the research-papers Core-Five bridges.
- Source: GAP_LEDGER_v26.7.12.md:326-342
- Verdict: DRIFTED
- Evidence: `grep -c research-papers justfile` => 0 (still literally true -- no just recipe
  references research-papers). But commit e248101 added .github/workflows/lean-<pkg>.yml for
  all 12 research-papers packages at repo root (previously they lived at
  research-papers/<pkg>/.github/workflows/lean_action_ci.yml, which GitHub Actions never
  discovers outside the repo root -- confirmed dead by the commit's own audit: 'none of them
  had ever actually run in CI'). Each new workflow runs `lake build --file lakefile.toml` +
  `lake env leanchecker <RealModule>`, gated by path-scoped triggers. This build+leanchecker
  signal is still disconnected from justfile, scripts/build_manifest.py, and
  release/gates.json (G13's release-gate half remains untouched), and runs against still-empty
  (0-byte) sources today per the commit's own admission -- so G13's core defect (no real
  theorems, no release-gate coverage) persists, but the ledger's literal sentence about a
  total absence of any research-papers lake-build wiring anywhere is no longer accurate.

## Pass 2 findings

### PB1 -- research-papers/ mass Lean-file truncation (16+ tracked files to 0 bytes),

- Lens: unexplained-modifications
- Claim: Beyond the '12+ modified Lean files' framing, research-papers/ suffered a mass
  content-truncation event: 16 tracked Lean files (Basic.lean + several top-level .lean files)
  were reduced to 0 bytes, and a much larger set of adjacent scaffold files (lakefile.lean,
  Thermo.lean, top-level .lean files newly created alongside the untracked
  research-papers/process.py) are also 0 bytes. This is not explained by any build process (lake
  build/clean never touch or empty .lean sources) and is not explained by process.py itself,
  which writes non-empty lakefile/Thermo content. The event correlates in wall-clock time with a
  ggen receipt regeneration and concurrent multi-worktree activity, not with any commit in this
  session's history.
- Source: research-papers/random_walk/RandomWalk.lean;
  research-papers/quantum_hall/QuantumHall.lean
- Verdict: CONFIRMED
- Evidence: `git diff --stat -- research-papers/` -> '16 files changed, 216 deletions(-)', e.g.
  RandomWalk.lean (114 lines removed, now empty, git index e69de29), QuantumHall.lean (34 lines
  removed, now empty). `find research-papers -name '*.lean' -o -name lakefile.lean | xargs stat
  -f "%Sm %z %N"` shows every file across virtually all subdirectories
  (aeneas_rust_verification, bio_signals, floquet_photonic, hyperdimensional_cognitive,
  minimal_measures, ortac_plus, pair_correlation, quantum_hall, random_walk, revops_turbulence,
  scalar_dissipation, signal_criticality, smfdcca, sound_borrow_checking, star_graphs) at size
  0, clustered at two mtimes: 2026-07-12 06:56:1x and 2026-07-12 17:12:27. `stat -f "%Sm"
  .ggen-v2/receipt.json .ggen-v2/receipt-log.jsonl` both = '2026-07-12 17:12:27' -- the exact
  same second as the Basic.lean truncations, and `find /Users/sac/mfact -newermt "2026-07-12
  17:10:00" ! -newermt "2026-07-12 17:15:00"` also lists .mfact/artifacts.toml,
  release/standing.env, crates/mfact-core/src/validate.rs, and
  .claude/worktrees/wf_24b4eb65-119-19/ROADMAP.md as touched in the same 5-minute window, with
  `git worktree list` confirming 7 concurrent worktrees (wf_24b4eb65-119-5/6/10/11/16/17/19)
  exist right now.
- Severity: critical

### PB2 -- release/standing.env may be the forbidden countermodel STATED->PROVEN promotion,

- Lens: pass1-refuted-recheck
- Claim: NEW since pass 1: uncommitted release/standing.env flips
  WFNET_INFINITE_TRANSITION_COUNTERMODEL from STATED to PROVEN (2-line diff, file mtime 17:12,
  predates this pass), which is exactly the promotion event the repo's own negative-control test
  says must never legitimately occur -- and PA12's finding that gates.json's
  countermodel_not_promoted key is structurally dead means nothing in the certify pipeline would
  catch or block this promotion even though gates.json (unchanged, committed) already shows
  countermodel_not_promoted=false.
- Source: release/standing.env:43; scripts/countermodel_negative_controls.sh:2,13,32,47-51
  ("Countermodel guard: Prevents PROVEN promotion without manifest evidence", asserts
  EXPECTED_STATUS="STATED"); release/gates.json:6
- Verdict: DRIFTED
- Evidence: `git diff release/standing.env` -> `-WFNET_INFINITE_TRANSITION_COUNTERMODEL=STATED`
  / `+WFNET_INFINITE_TRANSITION_COUNTERMODEL=PROVEN`. `stat -f "%Sm %N" release/standing.env` ->
  `Jul 12 17:12:27 2026` (predates this pass's start, ~23:15). `cat release/gates.json` ->
  `"countermodel_not_promoted": false` (unchanged, committed at HEAD). `python3 -c "import json;
  d=json.load(open('release/release-manifest.json')); [print(a['name'],a.get('proven')) for a in
  d['artifacts'] if a['name'] in
  ('ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded',
  'ProcInt.crownCounter_sound','ProcInt.crownCounter_not_bounded')]"` -> all three `True` (this
  manifest file itself shows no git diff, i.e. was already true at HEAD fb23ef5). The justfile
  recipe at line 177 legitimately derives this field from release-manifest.json's `proven`
  flags, so the PROVEN value is arguably manifest-consistent -- but
  scripts/countermodel_negative_controls.sh's entire purpose is to assert this specific field
  must derive back to STATED, meaning either the guard's premise ("no manifest evidence should
  exist") is itself already violated at HEAD, or the uncommitted standing.env write is the exact
  forbidden promotion the guard exists to catch. Cannot attribute who/what wrote it (~/praxis
  has standing write access per task framing); reporting the state as found.
- Severity: critical

### PB3 -- PA11 (CERTIFIED_RELEASE=PASS is REFUTED by a failing live certify) reproduces,

- Lens: pass1-refuted-recheck
- Claim: PA11: release/standing.env CERTIFIED_RELEASE=PASS is REFUTED because the live `mfact
  certify` gate check fails with evidenceComplete=false, and HEAD has drifted 31 commits past
  the last certified tag 184e3a3 with no fix landing.
- Source: PRAXIS_SELF_AUDIT.md:50-66 (PA11); release/standing.env:14
- Verdict: CONFIRMED
- Evidence: Re-ran verbatim: `just _lake "cd mfact && lake build AxiomAudit mfact"` -> "Build
  completed successfully (22 jobs)."; `just _lake "cd procint && lake build"` -> "Build
  completed successfully (8614 jobs)."; `cd /Users/sac/mfact/mfact && ./.lake/build/bin/mfact
  certify ../release/release-manifest.json ../release/gates.json` -> `gate failure:
  sorryFree=true axiomsClean=true fixturesPass=true evidenceComplete=false`; `echo EXIT_CODE=$?`
  -> `EXIT_CODE=1`. `git rev-list --count 184e3a3..HEAD` -> `31` (unchanged from pass 1's
  reported 31; HEAD is still fb23ef5, same commit as when pass 1 ran, so no new drift accrued).
  `release/standing.env:14` still reads `CERTIFIED_RELEASE=PASS`. Identical result to pass 1 --
  finding unchanged.
- Severity: critical

### PB4 -- ROADMAP.md's 'Core Five ... bonded to Rust typestates' claim is fabricated,

- Lens: roadmap-and-loop-ledger-sanity
- Claim: ROADMAP.md Phase 1 states the 'Core Five' domains (Random Walk, RevOps Turbulence, Star
  Graph Topologies, Stochastic Pair Correlation, Scalar Dissipation) 'have been successfully
  formally verified (0 `sorry`s) and bonded to the `safe-toolbox` / `mo-mae` typestates' in the
  execution engine, and mandates 'Every verified Lean boundary must be represented in Rust as a
  compile-time constraint (`PhantomData`, `type Proof = ();`).'
- Source: ROADMAP.md:8, ROADMAP.md:31 (untracked, new since pass 1's HEAD fb23ef5)
- Verdict: REFUTED
- Evidence: `grep -rIl "safe-toolbox|mo-mae" .` (excluding .lake/.git/node_modules/worktrees)
  returns only ROADMAP.md itself and scripts/rigor_linter.py:53, and the rigor_linter.py hit is
  a comment citing a defunct anti-pattern example ('pattern found in
  crates/safe-toolbox/src/safe.rs') used to justify a lint rule -- not a real crate. `ls
  crates/` shows the repo has exactly one crate, `mfact-core`; `crates/safe-toolbox` and any
  `mo-mae` crate do not exist (`find . -type d -iname safe-toolbox` outside .lake returns
  nothing). `grep -rn "PhantomData|type Proof" crates/mfact-core/src/*.rs` returns zero matches
  -- the exact zero-cost Rust bonding mechanism the same ROADMAP.md section mandates does not
  exist anywhere in the one real crate. The 'bonded to Rust typestates' half of the Phase 1
  claim is fabricated.
- Severity: critical

### PB5 -- .mfact/artifacts.toml's regenerated hash for standing.env is self-inconsistent,

- Lens: unexplained-modifications
- Claim: .mfact/artifacts.toml's regenerated content_hash entry for release/standing.env does
  not match the file's actual current on-disk content -- the ledger regeneration ran before the
  uncommitted WFNET_INFINITE_TRANSITION_COUNTERMODEL edit landed and was never rerun after, so
  the ledger (whose header this same diff adds the claim 'Authority comes from this ledger, not
  from paths or headers') is currently self-inconsistent with the very file it is supposed to
  authoritatively describe.
- Source: .mfact/artifacts.toml (release/standing.env entry); release/standing.env
- Verdict: CONFIRMED
- Evidence: `git show HEAD:release/standing.env | b3sum` =
  b2fb87d6511e73ef0f4ee59d8091e158021f7f5d44065896318c85489e903d31. Old committed ledger entry
  for release/standing.env =
  blake3:7b23eca57d536111b2b3adcd79eb6adaf4feb3d67f42896cd1ad57495eac3608 (already mismatched
  vs. HEAD's real content, i.e. stale before this session started). New uncommitted ledger entry
  = blake3:417168b6afe403a2a2068aa3cdea8abc7024fd7879c5203a621eb4b19cf31d69. `b3sum
  release/standing.env` on the current working tree (with the uncommitted STATED->PROVEN edit
  applied) = 013b9b51366b6a374592917dfc2688bc30a12b06bdfcf1306876d4474c03448e. All four values
  differ from each other.
- Severity: major

### PB6 -- 'multi-source arazzo find returns 2 files' does not reproduce (0 results now),

- Lens: dogfooding-report-spotcheck
- Claim: PRAXIS_DOGFOODING_EXPLORATION.md:157-158 claims `find /Users/sac/mfact -iname
  '*arazzo*'` returns only 2 .md files.
- Source: PRAXIS_DOGFOODING_EXPLORATION.md:157-158
- Verdict: REFUTED
- Evidence: `find /Users/sac/mfact -iname "*arazzo*"` (re-run 2026-07-12, live tree) -> empty
  output, 0 results. `git log --all --diff-filter=A --name-only | grep -i arazzo` -> no hits (no
  such file ever committed). `git status --short | grep -i arazzo` -> no hits (none untracked
  either). A content-grep `grep -rli arazzo . --exclude-dir=.git --include='*.md'` does return 3
  files (CLAUDE_ROADMAP.md, ROADMAP_GAP_AUTONOMIC.md, and PRAXIS_DOGFOODING_EXPLORATION.md
  itself), suggesting the author may have conflated a content-grep result with the cited
  filename-find command, but as literally stated the citation does not reproduce.
- Severity: major

### PB7 -- GAP_LEDGER 'reachability gaps' grouping (G6/G30/G31/G38) mostly mis-tagged,

- Lens: dogfooding-report-spotcheck
- Claim: PRAXIS_DOGFOODING_EXPLORATION.md:505 (and similar at :222) groups G6, G30, G31, G38
  together as GAP_LEDGER's 'reachability gaps'.
- Source: PRAXIS_DOGFOODING_EXPLORATION.md:222,505 vs
  GAP_LEDGER_v26.7.12.md:99,194,287,646,660,787,805
- Verdict: DRIFTED
- Evidence: All 7 cited G-numbers (G2, G6, G11, G30, G31, G38, G39) exist as real headers in
  GAP_LEDGER_v26.7.12.md (confirmed via grep). But checking each entry's own Lens field:
  G2='rust-build, reachability', G11='rust-build, reachability', G31='reachability' (genuinely
  reachability-tagged); G6='release-artifacts, tickets-truth, standing-claims, research-papers'
  (about stale v26.7.12 versioning, not reachability), G30='verifier-report' (about a missing
  unified report artifact, not reachability), G38='research-papers' (about random_walk missing
  lake-manifest.json, not reachability), G39='research-papers' (about missing lean-toolchain
  pins, not reachability). Only 1 of the 4 entries cited together as 'reachability gaps' at line
  505 is actually reachability-lens-tagged by GAP_LEDGER's own taxonomy.
- Severity: major

### PB8 -- mfact-core still fails to build (E0425 simulate_workload) as reported,

- Lens: dogfooding-report-spotcheck
- Claim: mfact-core currently fails a build with error E0425 for simulate_workload in
  src/bin/turbulence.rs:16.
- Source: PRAXIS_DOGFOODING_EXPLORATION.md:414-415
- Verdict: CONFIRMED
- Evidence: `cd crates/mfact-core && RUSTFLAGS="-D warnings" cargo check --all-targets` (re-run
  2026-07-12) -> `error[E0425]: cannot find function 'simulate_workload' in this scope -->
  src/bin/turbulence.rs:16:13`. File is already committed at 6cbc680 (git log --oneline -1 --
  crates/mfact-core/src/bin/turbulence.rs), not part of this session's uncommitted diff, so this
  is a standing build break, not new/stale.
- Severity: major

### PB9 -- AGENTS.md's pre-commit-hook citation for 'read-only' does not hold up,

- Lens: agents-md-self-consistency
- Claim: AGENTS.md section 3 (line 22-24): '~/praxis is a read-only dependency ... (see
  .git/hooks/pre-commit's MFACT_SOURCE_CHANGED handling, which already assumes this)'
- Source: AGENTS.md:22-24 citing .git/hooks/pre-commit
- Verdict: DRIFTED
- Evidence: Full literal read of /Users/sac/mfact/.git/hooks/pre-commit: the only praxis-related
  logic is the comment 'Pack sources live in the praxis repo; allow via env when a pack change
  drove this.' and 'if [ "${MFACT_SOURCE_CHANGED:-}" = "1" ]; then source_changed=true; fi'. The
  word 'read-only' appears nowhere in the hook; it is a self-reported trust-the-committer
  env-var escape hatch, not an access-control check. Also: `git ls-files .git/hooks/pre-commit`
  returns nothing (hooks are never version-controlled), and `git grep MFACT_SOURCE_CHANGED`
  across the tracked repo returns only AGENTS.md itself -- no other tracked file references it,
  so the citation points to an unshared, unversioned local file as if it embodied a checkable
  project convention about read-only access.
- Severity: major

### PB10 -- PA23/PA24 (thermo.rs, lean_ffi_wrapper.c untracked/unreachable) reproduces,

- Lens: agents-md-self-consistency
- Claim: PA23/PA24 (PRAXIS_SELF_AUDIT.md): thermo.rs and lean_ffi_wrapper.c are untracked and
  unreachable from the compiled crate
- Source: crates/mfact-core/src/thermo.rs, crates/mfact-core/src/lean_ffi_wrapper.c,
  crates/mfact-core/src/lib.rs
- Verdict: CONFIRMED
- Evidence: `git status --porcelain crates/mfact-core/src/thermo.rs
  crates/mfact-core/src/lean_ffi_wrapper.c` => both '?? ' (untracked). `grep -n "mod "
  crates/mfact-core/src/lib.rs` => only 'pub mod receipt;' (4), 'pub mod validate;' (5), 'mod
  tests' (89) -- no 'mod thermo;'. Widened check shows broker.rs, lean.rs, transport.rs,
  main.rs, build.rs are also untracked and none of broker/lean/thermo/transport is declared as
  mod anywhere tracked. Fresh `cargo check` run just now in crates/mfact-core produced:
  'error[E0432]: unresolved import `mfact_core::transport`: no `transport` in the root'
  (main.rs:1), 'error[E0433]: cannot find crate `tokio`' (main.rs:3), 'error[E0752]: `main`
  function is not allowed to be `async`' (main.rs:4), and 'error[E0425]: cannot find function
  `simulate_workload`' (src/bin/turbulence.rs:16) -- reproducing PA40's identical error set,
  confirming the crate still fails to build.
- Severity: major

### PB11 -- PA12 (countermodel_not_promoted gate key is structurally dead) reproduces,

- Lens: pass1-refuted-recheck
- Claim: PA12: PROJECT.md milestone table rows for "Fix Ticket 013 Certification Gaps" (M3),
  "Final Scan and Validation" (M4), and "Release Tag & Certification" (M5) marked DONE are
  REFUTED because the countermodel_not_promoted gate key is structurally dead (GatesJson in
  Cli.lean never declares/parses it) and build_manifest.py's own violation detection is
  non-blocking (print only, no sys.exit).
- Source: PRAXIS_SELF_AUDIT.md:68-84 (PA12); PROJECT.md:21-23; mfact/Mfact/Cli.lean:29-37;
  scripts/build_manifest.py:104-110
- Verdict: CONFIRMED
- Evidence: `cat release/gates.json` -> still contains `"countermodel_not_promoted": false`
  alongside the 4 real gate keys. `sed -n '28,37p' mfact/Mfact/Cli.lean` -> `structure GatesJson
  where\n  sorryFree : Bool\n  axiomsClean : Bool\n  fixturesPass : Bool\n  evidenceComplete :
  Bool\n  deriving ToJson, FromJson` -- still only 4 fields, `countermodel_not_promoted` still
  silently dropped on parse. `sed -n '95,115p' scripts/build_manifest.py` -> `if
  countermodel_promoted: print("COUNTERMODEL_PROMOTION_REFUSED: ...")` with no exit call, still
  non-blocking. `grep -n 'Fix Ticket 013\|Final Scan and Validation\|Release Tag' PROJECT.md` ->
  lines 21-23 all still show `DONE`. All three source files are absent from `git status --short`
  (no diff vs HEAD), so this is unchanged from pass 1.
- Severity: major

### PB12 -- ROADMAP.md's Star Graph Topologies 'Constructed & Verified' claim is false,

- Lens: roadmap-and-loop-ledger-sanity
- Claim: ROADMAP.md lists Star Graph Topologies as item 3 of the 'Core Five (Constructed &
  Verified)' -- '0 sorrys' and formally verified.
- Source: ROADMAP.md:11 (untracked, new since pass 1)
- Verdict: REFUTED
- Evidence: `grep -c sorry research-papers/star_graphs/StarGraphs/Basic.lean` = 0 (source-text
  claim is technically true), but `find research-papers/star_graphs/.lake -iname '*.olean'` and
  even `ls research-papers/star_graphs/.lake` return nothing -- there is no `.lake` build
  directory for star_graphs at all in the live tree, i.e. it has never been successfully
  compiled here, let alone 'Constructed & Verified'. This is consistent with and extends pass
  1's PA33 (CONFIRMED): re-running `lake --file lakefile.toml build` there found star_graphs
  fails with 'some modules have bad imports' / leanchecker 'Could not find any oleans'. Pass 1
  audited that claim against a CI-workflow/commit-message source; ROADMAP.md's own 'Core Five'
  framing of star_graphs as verified was not previously examined and is a new,
  separately-sourced instance of the same false claim.
- Severity: major

### PB13 -- artifacts.toml/ggen.lock hash churn is a ledger catch-up, not new edits,

- Lens: unexplained-modifications
- Claim: The changed content_hash values in .mfact/artifacts.toml and ggen.lock for
  procint/ProcInt/Workflow/Countermodel.lean, paper/quadrature.tex, paper/release_macros.tex,
  procint/AxiomAudit.lean, release/quadrature.json, release/quadrature.md,
  research/verif/obligations.toml, release/release-manifest.json, release/gates.json,
  paper/correspondence_status.tex, release/verif-receipt.json, paper/evaluation.tex, and
  procint/ProcInt/Release/Quadrature.lean (plus the lean-math-pack/quadrature-pack hash bumps in
  ggen.lock) represent unexplained or undocumented content churn in this session.
- Source: .mfact/artifacts.toml; commit ac647a9
- Verdict: REFUTED
- Evidence: `git diff --stat -- procint/ release/ paper/ research/` shows zero working-tree diff
  for any of these files (only release/standing.env changed). `b3sum
  procint/ProcInt/Workflow/Countermodel.lean` =
  a22d18485064c81f52b123f9be945212af0d90c65f8e51fd2fe16bdedfd57c65, exactly matching the
  artifacts.toml new hash. `git log --oneline -1 -- procint/ProcInt/Workflow/Countermodel.lean`
  = 'ac647a9 chore: fix countermodel proofs mechanically' (2026-07-12 01:55:49), and `git
  merge-base --is-ancestor ac647a9 HEAD && echo YES` = 'YES ancestor'. `b3sum
  paper/quadrature.tex` = 42af4acc77ceb9fcbcb4ae7af57534991800aaa369a7bff80346b46a06634dd2, also
  an exact match to the artifacts.toml new hash. These are ledger catch-ups to content already
  committed by an ancestor commit, produced by rerunning scripts/build_ledger.py against the
  current .ggen-v2/receipt.json, not new source edits.
- Severity: minor

### PB14 -- standing.env's countermodel STATED->PROVEN flag flip matches a real proof,

- Lens: unexplained-modifications
- Claim: release/standing.env's WFNET_INFINITE_TRANSITION_COUNTERMODEL=STATED -> PROVEN one-line
  edit is an unjustified or unverified status upgrade.
- Source: release/standing.env:43; procint/ProcInt/Workflow/Countermodel.lean:277
- Verdict: REFUTED
- Evidence: `grep -n 'sorry\|admit\|axiom' procint/ProcInt/Workflow/Countermodel.lean` returns
  only a comment ('-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean
  admits.'), no actual sorry/admit/axiom in the proof body; the file contains theorem
  `WfNet.infinite_transition_countermodel_sound_not_bounded` (line 277) with a complete proof
  term, last touched by ancestor commit ac647a9 'chore: fix countermodel proofs mechanically'.
  `git show HEAD:release/standing.env | grep WFNET` confirms HEAD still reads STATED, i.e. this
  uncommitted edit is catching the human-readable status flag up to reflect a proof already
  landed in an ancestor commit, not fabricating a claim. (Note: this refutes the edit's own
  internal justification, but per PB2 the same edit is also the exact promotion the repo's
  negative-control test says must never occur -- both findings are about the same line and are
  not in tension: the value is manifest-consistent yet still the forbidden promotion by the
  guard's own premise.)
- Severity: minor

### PB15 -- crates/mfact-core/src/validate.rs's 20 changed lines are a test-only rename,

- Lens: unexplained-modifications
- Claim: crates/mfact-core/src/validate.rs's 20 changed lines represent a behavioral or logic
  change to manifest validation.
- Source: crates/mfact-core/src/validate.rs:128
- Verdict: REFUTED
- Evidence: `git diff crates/mfact-core/src/validate.rs` shows every one of the 10 hunks is an
  identical rename of the test helper function `dummy_manifest()` to `fixture_manifest()` -- one
  definition plus 9 call sites, all within `mod tests`. No non-test line, assertion, or
  validation logic changed.
- Severity: minor

### PB16 -- test_artifact.txt still exists on disk; only its ledger entry was dropped,

- Lens: unexplained-modifications
- Claim: .mfact/artifacts.toml's removal of the test_artifact.txt entry indicates that file was
  deleted or is no longer part of the repo.
- Source: test_artifact.txt; .mfact/artifacts.toml
- Verdict: DRIFTED
- Evidence: `git ls-files test_artifact.txt` -> 'test_artifact.txt' (tracked). `git status
  --porcelain -- test_artifact.txt` -> empty output (clean, matches HEAD, exit 0). `cat
  test_artifact.txt` -> 'test data'. `b3sum test_artifact.txt` =
  887f4ff6011924442f53c3705de802ec994c64b5d2e4ca9f7b3e065f3e763aba, exactly matching the OLD
  (pre-edit) ledger entry that was just deleted from artifacts.toml. The file still exists on
  disk, committed and unchanged; scripts/build_ledger.py only emits ggen-receipt outputs plus a
  fixed declared list, of which test_artifact.txt (producer='my_producer', pack='my_pack' --
  placeholder-looking values) was never a member, so regenerating the ledger mechanically drops
  this apparently hand-inserted entry while leaving the orphaned file itself untouched.
- Severity: minor

### PB17 -- ROADMAP_MATH_SPINE.md's Corollary 21.2 / Theorem 21.1 markers reproduce,

- Lens: dogfooding-report-spotcheck
- Claim: ROADMAP_MATH_SPINE.md's Corollary 21.2 is BLOCKED_ON_CORRESPONDENCE and Theorem 21.1 is
  PROVEN_CONDITIONALLY.
- Source: PRAXIS_DOGFOODING_EXPLORATION.md:163-164,446 vs ROADMAP_MATH_SPINE.md:114-116,487
- Verdict: CONFIRMED
- Evidence: ROADMAP_MATH_SPINE.md:114-116: 'split into Theorem 21.1 (abstract crown composition,
  (A1 ... A10) => Crown, standing PROVEN_CONDITIONALLY) and Corollary 21.2 (MFW runtime crown,
  standing BLOCKED_ON_CORRESPONDENCE until A10 and the correspondence assumptions are
  discharged).' Corroborated at line 487: 'A10 blocks Corollary 21.2 (Crown Runtime).'
- Severity: minor

### PB18 -- 'multifractal-workflow' grep is now self-invalidated by the citing doc itself,

- Lens: dogfooding-report-spotcheck
- Claim: grep -rl "multifractal-workflow" /Users/sac/mfact (excluding .git) returns zero hits.
- Source: PRAXIS_DOGFOODING_EXPLORATION.md:240-241
- Verdict: DRIFTED
- Evidence: `grep -rl "multifractal-workflow" . --exclude-dir=.git` (re-run 2026-07-12, from
  /Users/sac/mfact) -> 1 hit: PRAXIS_DOGFOODING_EXPLORATION.md. The document is untracked (git
  status --short shows '?? PRAXIS_DOGFOODING_EXPLORATION.md') but present on disk, so it is now
  picked up by its own cited grep since it quotes the string 'multifractal-workflow' verbatim.
  Claim was almost certainly true for the rest of the tree when written; self-invalidated once
  the citing document itself existed on disk.
- Severity: minor

### PB19 -- AGENTS.md's 'never touch ~/praxis' phrase is quoted history, not live policy,

- Lens: agents-md-self-consistency
- Claim: AGENTS.md may still contain stale 'never touch ~/praxis' blanket-exclusion language
  inconsistent with the section 3/4 correction
- Source: AGENTS.md (full file, section 3 and 4)
- Verdict: REFUTED
- Evidence: `grep -ni "never touch" AGENTS.md` => exactly one hit at line 26, inside the
  explicit historical parenthetical '(Corrected 2026-07-12: this line previously read "never
  touch ~/praxis" in full, ...)', i.e. quoting the old text to explain the correction, not
  asserting it as current policy. `grep -ni "read-only" AGENTS.md` => one hit (line 22)
  consistent with the corrected framing. Section 3 ('Read, explore, and build against it
  freely... Never write to, edit, or commit inside ~/praxis') and section 4 ('not about whether
  the file may be read') are mutually consistent with no contradiction.
- Severity: minor

### PB20 -- Cron job 8123599b (parallel fix-loop) has not produced any commits yet,

- Lens: pass1-refuted-recheck
- Claim: Cron job 8123599b ("post-AGI self-improvement loop", created moments before this pass)
  has not yet produced any commits; HEAD is unchanged at fb23ef5.
- Source: task framing (cron job 8123599b creation); git log
- Verdict: CONFIRMED
- Evidence: `git log --oneline -5` -> `fb23ef5 docs: add LEAN_ECOSYSTEM_LEVEL11_SURVEY.md /
  6b7a6b1 ... / e248101 ... / 4382bc7 ... / 35be175 ...` -- identical top commit to the
  task-stated HEAD (fb23ef5). `git rev-parse HEAD` ->
  `fb23ef546455afdc6bccada31dc754b6ff3322a7`. `git log -1 --format='%H %cI' HEAD` -> `...
  2026-07-12T22:32:56-07:00`, i.e. authored well before this pass's re-verification commands ran
  (`date` -> `Sun Jul 12 23:15:06 PDT 2026`). No new commits have landed from the parallel
  fix-loop.
- Severity: minor

### PB21 -- MFACT_SELF_IMPROVEMENT_LOOP.md does not exist anywhere in the tree yet,

- Lens: roadmap-and-loop-ledger-sanity
- Claim: Lens setup: MFACT_SELF_IMPROVEMENT_LOOM.md may not exist yet since the fix-loop that
  creates it was only just scheduled.
- Source: task framing (no prior doc claim)
- Verdict: CONFIRMED
- Evidence: `find . -iname '*SELF_IMPROVEMENT_LOOP*'` and `ls MFACT_SELF_IMPROVEMENT_LOOP.md`
  both return nothing -- the file does not exist anywhere in the tree. `git log --oneline -5`
  shows HEAD is still fb23ef5 with no commits since pass 1's HEAD, consistent with the fix-loop
  not having fired yet. No fabricated commit hashes to verify.
- Severity: minor

### PB22 -- ROADMAP_GAP_THERMO.md's 'zero structural matches' finding is now stale,

- Lens: roadmap-and-loop-ledger-sanity
- Claim: ROADMAP_GAP_THERMO.md concludes 'Zero structural matches were found for operational
  implementations of ... thermodynamic ... execution integration' and 'the required operational
  mathematical objects are completely absent from the execution layer.'
- Source: ROADMAP_GAP_THERMO.md:11,14 (untracked, written 2026-07-12 00:02)
- Verdict: DRIFTED
- Evidence: `stat -f '%Sm' ROADMAP_GAP_THERMO.md` = Jul 12 00:02:xx; but
  `crates/mfact-core/src/thermo.rs` (114 lines, mtime Jul 12 06:56), `pylab/src/mpops/thermo.py`
  (131 lines, mtime Jul 12 00:39), plus `crates/mfact-core/tests/thermo_integration_test.rs` and
  `pylab/tests/test_thermo.py` now exist in the uncommitted tree, all created after the gap doc
  was written. The claim was accurate at write time but is now stale/contradicted by later
  same-session uncommitted work; the doc has not been updated to reflect it.
- Severity: minor

### PB23 -- ROADMAP_GAP_AUTONOMIC.md's 'no loops/actors' finding is partially stale,

- Lens: roadmap-and-loop-ledger-sanity
- Claim: ROADMAP_GAP_AUTONOMIC.md concludes 'Currently, mfact-core has no loops, actors, or
  state progression. A new crate or module (e.g., mfact-runtime or mfact-broker) is required to
  drive this recursive expansion loop.'
- Source: ROADMAP_GAP_AUTONOMIC.md:6,33 (untracked, written 2026-07-11 23:55)
- Verdict: DRIFTED
- Evidence: `stat -f '%Sm' ROADMAP_GAP_AUTONOMIC.md` = Jul 11 23:55:19;
  `crates/mfact-core/src/broker.rs` (mtime Jul 12 05:45:24, ~6h later) now exists with a
  `CrownLoopBroker` struct and `sequence_cycle`/`generate_pddl_query` functions calling into a
  new Lean FFI bridge (lean.rs, lean_ffi_wrapper.c). The claim was accurate when written but the
  codebase has since grown a minimal single-step broker skeleton -- though it still falls well
  short of the full closure/SHACL/POWL-manufacture/readmission loop the doc specifies as
  missing, so 'no loops, actors, or state progression' is now only partially true rather than
  fully refuted.
- Severity: minor

## Pass 3 findings

### PC1 -- Task w3xrg1r0m: is it complete, stalled, or still running,

- Lens: workflow-status-and-collision
- Claim: The 10-agent workflow (task w3xrg1r0m) had staged, not yet committed, 10 files
  as of pass 2. Check whether it is complete, stalled, or still running.
- Source: git log -5 --oneline; git show --stat 4fabb1c; git status --porcelain
- Verdict: CONFIRMED
- Evidence: Re-run `git log -5 --oneline` now shows `4fabb1c feat(procint): trajectory
  taxonomies + annotation tooling from arXiv:2607.09510` (author date
  2026-07-13T00:17:20-07:00). `git show --stat 4fabb1c` lists exactly the 10 files the
  briefing named (AGENTS.md, MFACT_SELF_IMPROVEMENT_LOOP.md,
  TRAJECTORY_CASE_STUDY_TRUNCATION.md, TRAJECTORY_MONITOR_FEASIBILITY.md, justfile,
  Playground.lean, RecoveryBehavior.lean, RootCause.lean, stuck_item_guard.py,
  trajectory_annotate.py). `git status --porcelain` now lists none of these 10 files --
  the working tree matches HEAD for all of them. The workflow is complete, not stalled.
- Severity: critical

### PC2 -- Did the fix loop (cron 0e35feb8) safely abort on the staged collision,

- Lens: workflow-status-and-collision
- Claim: The fix loop was about to fire within minutes of this pass starting and, per
  its own collision guard, should see the staged w3xrg1r0m state and abort safely; if it
  did not, that is a critical finding.
- Source: .mfact/receipts/20260713T071516Z.json; git show --stat c741d46; 4fabb1c commit
  body
- Verdict: CONFIRMED
- Evidence: `.mfact/receipts/20260713T071516Z.json` (timestamp 2026-07-13T07:15:16Z, i.e.
  00:15:16 PDT -- before w3xrg1r0m's own 00:17:20 commit) reads `"status": "failed"`,
  `"collision": true`, `"commit_sha": null`, and `"after": "not attempted -- collision
  guard stopped the firing before any action"`. `git show --stat c741d46` (the loop's own
  follow-up commit, 00:18:52, 1.5 min after 4fabb1c) touches only 4 paths --
  `.mfact/metrics-history.jsonl` (new, empty), the two receipt JSON files, and a 13-line
  Run-log append to `MFACT_SELF_IMPROVEMENT_LOOP.md` -- 43 insertions/2 deletions, no
  other file touched. Independently corroborated by 4fabb1c's own commit body (written by
  the concurrently-running w3xrg1r0m workflow, a separate witness): "The fix loop
  (0e35feb8) did fire mid-task ... wrote a status:failed/collision:true receipt ... and
  made no commit and no other change -- exactly the self-abort behavior the guard is
  designed for." Two independent sources agree; the guard worked correctly.
- Severity: critical

### PC3 -- AGENTS.md praxis-boundary rewrite bundled into the taxonomy commit,

- Lens: workflow-status-and-collision
- Claim: Commit 4fabb1c bundles an unrelated AGENTS.md policy change -- rewriting the
  "Strict Boundaries: Never touch ~/praxis" rule to permit read access -- justified only
  by a self-attested in-diff claim of prior user correction.
- Source: git show 4fabb1c -- AGENTS.md
- Verdict: CONFIRMED
- Evidence: `git show 4fabb1c -- AGENTS.md` shows 31 insertions/5 deletions consisting of
  (a) an on-topic arXiv:2607.09510 empirical-grounding paragraph and (b) rewriting
  "Never touch `~/praxis`." into a multi-line read-only-dependency rule, with the
  parenthetical "(Corrected 2026-07-12: this line previously read 'never touch
  `~/praxis`' in full, which was too broad ... clarified per explicit user correction,
  not silently reinterpreted.)" This audit's own standing rule treats a doc comment as
  never evidence of authorization; no independent confirmation of a user correction
  exists anywhere else in this repo.
- Severity: major

### PC4 -- Are the 6 long-standing unattributed files still unresolved since pass 2,

- Lens: unresolved-modifications-recheck
- Claim: `.ggen-v2/receipt-log.jsonl`, `.ggen-v2/receipt.json`, `.mfact/artifacts.toml`,
  `crates/mfact-core/src/validate.rs`, `ggen.lock`, `release/standing.env` are still
  modified with no attributed cause; check whether the diff has grown, shrunk, or stayed
  identical since pass 2.
- Source: git diff --stat; stat -f mtime on all 6 files
- Verdict: CONFIRMED
- Evidence: `git diff --stat` gives identical line counts to pass 2's reported figures:
  receipt-log.jsonl +4/-0, receipt.json 1+/1-, artifacts.toml 39 lines, validate.rs 20
  lines, ggen.lock 4 lines, standing.env 1+/1-. `stat -f "%Sm"` on all 6 files returns the
  identical mtime `2026-07-12 17:12:27` for every one, which predates both HEAD's last
  real commit before this pass (fb23ef5 @ 22:32:56) and every file this pass's workflow
  touched (23:56 onward) -- these files were not written to during this pass, so the
  diffs are byte-identical to pass 2's snapshot, not merely coincidentally equal.
  Content spot-check: validate.rs's 20-line diff is a pure test-helper rename
  (`dummy_manifest` -> `fixture_manifest`); standing.env flips one flag from `STATED` to
  `PROVEN`; ggen.lock swaps two blake3 content_hash values. None look malicious, but none
  are explained by any commit message -- unresolved for a third consecutive pass.
- Severity: major

### PC5 -- web/mfact-ui submodule: pointer moved AND working copy is dirty,

- Lens: unresolved-modifications-recheck
- Claim: web/mfact-ui's drift is a plain submodule-pointer edit like the other 6 files,
  and not previously called out as distinct.
- Source: git diff -- web/mfact-ui; stat mtime comparison
- Verdict: DRIFTED
- Evidence: `git diff -- web/mfact-ui` shows `-Subproject commit
  1ba3a9b7266130485f3fd919bb159e971a34c305` / `+Subproject commit
  40dc87a91e40641a664de8ff592fe92ad8e13108-dirty` -- the checked-out submodule HEAD has
  moved to a *different* commit than the index's staged 1ba3a9b, and that checkout itself
  has uncommitted changes (the `-dirty` suffix), which is a materially different failure
  mode than a simple pointer bump. Its mtime, `2026-07-12 16:54:05`, is ~18 minutes older
  than the other 6 files' shared `17:12:27` timestamp, meaning it was not touched by
  whatever single operation touched those 6 -- this is a separate, older, still-unresolved
  drift that the pass-1/pass-2 framing folded into the same bucket as the other 6 without
  distinguishing the pointer-move-plus-dirty-checkout shape.
- Severity: major

### PC6 -- Is scripts/stuck_item_guard.py unrequested scope creep,

- Lens: stuck-item-guard-scope-check
- Claim: scripts/stuck_item_guard.py, staged but not explicitly named in the workflow's
  brief ("implement arXiv:2607.09510's trajectory-failure taxonomy"), is unrequested
  scope creep.
- Source: scripts/stuck_item_guard.py:1-40; MFACT_SELF_IMPROVEMENT_LOOP.md:83-89;
  justfile (git show 4fabb1c --stat --summary)
- Verdict: REFUTED
- Evidence: The script's own header explicitly disclaims being the paper's real-time
  monitor and states it is "a direct implementation of the 'Stuck-item guard' already
  specified in prose in MFACT_SELF_IMPROVEMENT_LOOP.md" -- both files were staged
  together in the same commit, so this is a disclosed, spec-matched deliverable rather
  than invented functionality. Executed live: `python3 scripts/stuck_item_guard.py` exits
  0 and reports a real, non-fabricated count against `.mfact/receipts/` (1 receipt found
  after c741d46 landed mid-pass; the doc's quoted "0 receipts" transcript was accurate at
  the time it was written, before that receipt existed). Real gap found, though: `git show
  4fabb1c --stat --summary` shows `create mode 100644 scripts/stuck_item_guard.py` with no
  corresponding justfile recipe (only `trajectory-annotate` was added), and
  MFACT_SELF_IMPROVEMENT_LOOP.md's own "Stuck-item guard" section (lines 83-89) never
  names the script -- the guard it claims to implement is not yet operationally wired
  into the loop it is meant to protect.
- Severity: major

### PC7 -- Independent rebuild of the new trajectory-taxonomy Lean files,

- Lens: taxonomy-lean-reverify
- Claim: procint/ProcInt/Playground/Trajectory/RootCause.lean and RecoveryBehavior.lean
  are genuinely kernel-checked (no sorry), with a real total classifier proof, and wired
  into the default Playground build target.
- Source: procint/ProcInt/Playground/Trajectory/RootCause.lean;
  procint/ProcInt/Playground/Trajectory/RecoveryBehavior.lean;
  procint/ProcInt/Playground.lean:30-31
- Verdict: CONFIRMED
- Evidence: `grep -n sorry` on both files returns exactly one hit, inside a doc comment
  ("-- no `sorry`"), never an actual tactic. `category_total` is a 9-way conjunction
  (one per `RootCauseType` constructor) closed by `decide`; `category_mem` independently
  covers the same totality via `cases t <;> simp [category]` -- two independent proofs of
  the same fact, not one proof duplicated. `grep -n Trajectory
  procint/ProcInt/Playground.lean` confirms both files are imported at lines 30-31
  alongside the pre-existing 27 Playground imports -- not orphaned. Rebuilt from a forced-
  clean cache (deleted the gitignored .olean/.ilean artifacts for both modules first):
  `lake build ProcInt.Playground.Trajectory.RootCause
  ProcInt.Playground.Trajectory.RecoveryBehavior` -> "Build completed successfully (3
  jobs)" with fresh timestamps -- a genuine kernel-level recompile, not a cache-hit report.
- Severity: minor

### PC8 -- stuck_item_guard.py file mode inconsistent with its own usage docs,

- Lens: stuck-item-guard-scope-check
- Claim: scripts/stuck_item_guard.py's file mode is consistent with its documented usage
  and with its sibling script trajectory_annotate.py.
- Source: scripts/stuck_item_guard.py:1,34-39; git show 4fabb1c --stat --summary
- Verdict: DRIFTED
- Evidence: `git show 4fabb1c --stat --summary` records `create mode 100644
  scripts/stuck_item_guard.py` versus `create mode 100755 scripts/trajectory_annotate.py`
  -- confirmed on disk too (`ls -la` shows `-rw-r--r--` vs `-rwxr-xr-x`). The file has a
  `#!/usr/bin/env python3` shebang and a docstring Usage block showing bare
  `stuck_item_guard.py` invocations, which would fail with "Permission denied" without a
  `python3` prefix or a `chmod +x` -- the file's own documented usage doesn't match the
  mode it was actually committed with, unlike its sibling script.
- Severity: minor

## Pass 4 findings

### PD1 -- Fix loop firing 2 collided again, and this time committed live,

- Lens: fix-loop-catch-and-catalog-check
- Claim: The fix loop (cron `0e35feb8`) would fire again near :42 past the hour,
  possibly during this pass; if so that is new ground to audit, not noise.
- Source: git log --oneline -5; git show da4f21a; .mfact/receipts/20260713T074350Z.json
- Verdict: CONFIRMED
- Evidence: `git rev-parse HEAD` moved from `c741d46` (this pass's start) to
  `da4f21a` mid-pass. `git show --stat da4f21a` (author date 00:45:22) touches only
  `.mfact/receipts/20260713T074350Z.json` (new), `.mfact/receipts/latest.json`, and
  a 17-line append to `MFACT_SELF_IMPROVEMENT_LOOP.md` -- no other file. The receipt
  reads `"status": "failed"`, `"collision": true`, `"commit_sha": null`,
  `"timestamp": "2026-07-13T07:43:50Z"`. Unlike firing 1, this firing's own commit
  landed (firing 1's bookkeeping was also committed, but this is a second,
  independent collision on a second, later occasion) -- confirming the loop is
  alive and re-firing on schedule, and that it self-aborted correctly a second time.
- Severity: critical

### PD2 -- Collision guard has no delta/allowlist baseline; will collide forever,

- Lens: fix-loop-catch-and-catalog-check
- Claim: The guard compares against absolute clean-tree state, not a delta since
  the last check, so every future firing will collide identically as long as the
  persistent 8-file pile remains uncommitted, regardless of new activity.
- Source: git show da4f21a -- MFACT_SELF_IMPROVEMENT_LOOP.md; grep for allowlist
  terms in MFACT_SELF_IMPROVEMENT_LOOP.md
- Verdict: CONFIRMED
- Evidence: `grep -iE 'allowlist|baseline|delta|known.noise|pre-existing'
  MFACT_SELF_IMPROVEMENT_LOOP.md` returns zero matches for a baseline/allowlist
  mechanism. The firing-2 run-log append (committed in `da4f21a`) states this
  explicitly in its own words: "the guard as specified compares against 'any
  uncommitted state,' not a delta from the last check -- as long as this static
  pile exists uncommitted, every future firing will collide identically regardless
  of whether anything new actually happened." This is now a self-documented,
  committed design note from the loop itself, not an inference by this audit.
- Severity: critical

### PD3 -- web/mfact-ui gitlink drift is unchanged from pass 3, still unresolved,

- Lens: web-mfact-ui-submodule
- Claim: The parent repo's gitlink for `web/mfact-ui` is still pinned at `1ba3a9b`
  while the checked-out nested repo is 5 commits ahead at `40dc87a` with a dirty
  working tree, and no `.gitmodules` exists anywhere in history.
- Source: git ls-files -s web/mfact-ui; web/mfact-ui .git log; find .gitmodules
- Verdict: CONFIRMED
- Evidence: `git ls-files -s web/mfact-ui` still reads `160000 1ba3a9b... 0
  web/mfact-ui`. Inside the nested repo, `git rev-parse HEAD` = `40dc87a`, `git log
  --oneline 1ba3a9b..40dc87a` lists exactly the same 5 commits as pass 3
  (`c6a5b00, 382d2ea, 7c81bf2, 77496df, 40dc87a`), and `git status --porcelain |
  wc -l` = 21, unchanged. `find /Users/sac/mfact -maxdepth 1 -iname '*gitmodules*'`
  is empty. Nothing about this defect has moved since pass 3; it remains open.
- Severity: major

### PD4 -- stuck_item_guard.py still not wired into justfile or the loop doc,

- Lens: stuck-item-guard-wiring
- Claim: `scripts/stuck_item_guard.py` remains unreferenced by `justfile` and by
  `MFACT_SELF_IMPROVEMENT_LOOP.md`'s own "Stuck-item guard" section (lines 83-88)
  that it is claimed elsewhere to implement.
- Source: justfile; MFACT_SELF_IMPROVEMENT_LOOP.md:83-88
- Verdict: CONFIRMED
- Evidence: `grep -n stuck_item_guard justfile` -> no output, exit 1. `grep -n
  stuck_item_guard MFACT_SELF_IMPROVEMENT_LOOP.md` -> no output, exit 1. `python3
  scripts/stuck_item_guard.py` still runs standalone and correctly ("2 receipt(s)
  considered ... Nothing flagged" -- up from 1 pre-firing-2, confirming it reads
  live receipt state) but is invoked by nothing documented or automated. Identical
  gap to pass 3's PC6; not fixed this pass.
- Severity: major

### PD5 -- MFW_WORKFLOW_CATALOG.md / task wjeyru8a7 remains untraceable,

- Lens: general-drift-scan
- Claim: Workflow task `wjeyru8a7` ("MFW workflow catalog") has not produced
  `MFW_WORKFLOW_CATALOG.md`, and its progress cannot be checked from this session.
- Source: find -iname MFW_WORKFLOW_CATALOG.md; TaskList; .claude/worktrees/*
- Verdict: UNVERIFIABLE
- Evidence: `find /Users/sac/mfact -iname '*MFW_WORKFLOW_CATALOG*'` -> no results,
  and `git log --all --oneline -- '**MFW_WORKFLOW_CATALOG.md'` -> no results (never
  existed on any branch). `TaskList` (this session's own tracker) -> "No tasks
  found". `grep -rl wjeyru8a7 /Users/sac/mfact` (excl. target/node_modules) ->
  no matches, including across all 7 `.claude/worktrees/wf_24b4eb65-119-*` dirs,
  whose HEAD commits (`587d307e, 61468b4, 2f4f0b58, a94ed533, e174fa3a, 118ec78a,
  154b62f9`) are all unrelated fix-loop gap items (G33, G34, G47, G48, G15, G9,
  G10). Only the output's absence is confirmable; task existence/status is not.
- Severity: major

### PD6 -- Not all 8 "persistent unattributed" files are equally unexplained,

- Lens: general-drift-scan
- Claim: The 8 modified files firing-2's receipt calls "persistent, unattributed
  since before this session's active work" are uniformly unexplained.
- Source: .mfact/receipts/20260713T074350Z.json; git diff -- .gitignore
- Verdict: REFUTED
- Evidence: The receipt lists 8 files: `.ggen-v2/receipt-log.jsonl`,
  `.ggen-v2/receipt.json`, `.gitignore`, `.mfact/artifacts.toml`,
  `crates/mfact-core/src/validate.rs`, `ggen.lock`, `release/standing.env`,
  `web/mfact-ui`. Of these, `.gitignore`'s diff is self-explaining: it adds an
  unanchored `target/` rule with an inline comment stating exactly why
  ("crates/mfact-core/target/ was previously untracked-but-unignored and got
  committed by accident"), at its own distinct mtime (19:38:57) separate from both
  the six-file 17:12:27 cluster and web/mfact-ui's 16:54:05 cluster. Six of the
  eight remain genuinely unattributed (no commit, no comment, no explanation); one
  (web/mfact-ui) has a full local commit trail explaining it (see PD3); one
  (.gitignore) explains itself inline. Calling all 8 "unattributed" overstates the
  mystery by 2 files.
- Severity: minor

### PD7 -- web/mfact-ui's mtime cluster remains distinct from the frozen six,

- Lens: general-drift-scan
- Claim: web/mfact-ui's activity (16:51:41-16:54:33) is a separate, earlier event
  from the six frozen files' shared 17:12:27 mtime, not the same cause.
- Source: stat -f '%Sm' on all six frozen files and web/mfact-ui
- Verdict: CONFIRMED
- Evidence: Fresh `stat -f '%Sm %N'` on all six frozen files (`.ggen-v2/*`,
  `.mfact/artifacts.toml`, `crates/mfact-core/src/validate.rs`, `ggen.lock`,
  `release/standing.env`) again reads exactly `Jul 12 17:12:27 2026`, byte-for-byte
  unchanged across 4 passes. `web/mfact-ui`'s own directory mtime and its nested
  `.git` internals remain at their pass-3 values (16:51:41-16:54:33). No overlap;
  reproduces pass 3's PC5 exactly, confirming the two clusters are still disjoint.
- Severity: minor

### PD8 -- Working-tree noise did not grow net of the loop's own bookkeeping,

- Lens: fix-loop-catch-and-catalog-check
- Claim: Firing 2's own writes (a new receipt file, `latest.json`, and a
  `MFACT_SELF_IMPROVEMENT_LOOP.md` append) transiently raised `git status
  --porcelain` line count before being committed away in `da4f21a`.
- Source: git status --porcelain | wc -l, sampled 3x across this pass
- Verdict: CONFIRMED
- Evidence: Sampled at pass start (`80`), mid-pass after firing 2's receipt landed
  but before its commit (`82`, then `83` after the doc-append became visible to
  git), and again after `da4f21a` committed those exact 3 paths (`80`, net-zero).
  The persistent pile itself (8 modified, ~72 untracked) is unchanged in content
  across all three samples -- the loop's own bookkeeping does not leave residual
  mess once it commits.
- Severity: minor

## Pass 5 findings

### PE1 -- Briefing's core claim: HEAD sat at a824ebc the whole idle gap,

- Lens: no-unexpected-drift-during-gap
- Claim: HEAD stayed at `a824ebc` for the entire ~8-hour idle gap between pass 4
  (~00:48 PDT) and pass 5 (~08:49 PDT), i.e. the repo was untouched the whole
  time.
- Source: `git reflog show HEAD`; `git log -5 --format='%h %ci %s'`; independently
  re-run this pass at 08:54:27 PDT via `date` + `git log -3 --format='%h %ci %s'`
- Verdict: REFUTED
- Evidence: `a824ebc`'s own commit timestamp is 2026-07-13 08:47:56 -0700, against
  a system clock of 08:52:11 PDT at original check time and 08:54:27 PDT at this
  pass's independent re-check -- it was created minutes before this pass, not 8
  hours earlier. It is preceded by two more same-burst commits: `17b4c51`
  (08:45:39, 19 files/3587 insertions: new `.claude/agents/*`, hooks,
  `settings.json`, this file) and `1e47b87` (08:46:41). The commit actually
  contemporaneous with pass 4's stated time is `da4f21a` at 00:45:22 -0700 (`git
  reflog show HEAD` confirms `da4f21a HEAD@{3}`, three moves behind current HEAD).
  HEAD moved three commits in a two-minute window immediately before this pass
  ran; it did not sit still for eight hours.
- Severity: critical

### PE2 -- Same HEAD-frozen claim, the idle-gap lens's own framing also fails,

- Lens: idle-gap-confirmation
- Claim: `"HEAD stayed at a824ebc"` throughout the 8-hour idle gap between pass 4
  and pass 5.
- Source: `git log --pretty=fuller` on `a824ebc`/`1e47b87`/`17b4c51`; `git reflog`
- Verdict: DRIFTED
- Evidence: `a824ebc`, `1e47b87`, and `17b4c51` all have CommitDate 2026-07-13
  08:45:39-08:47:56 -0700 -- made in the current pass-5 turn seconds before this
  check (`date` showed 08:50:23 -0700 at original check time). During the actual
  gap, HEAD was at `da4f21a` (reflog: `HEAD@{2026-07-13 00:45:22 -0700}`), pass
  4's last commit. The briefing conflates "current HEAD right now" with "HEAD
  throughout the gap" -- a narrower framing error than PE1's outright falsity, so
  scored one severity step lower even though it names the identical underlying
  fact.
- Severity: major

### PE3 -- Cron non-fire attributed to session-idle mechanics is unverifiable,

- Lens: idle-gap-confirmation
- Claim: Cron job `6f81400b` never fired despite its 07:47:32 PDT deadline
  passing, "confirming cron jobs in this environment do not fire without an
  active/idle session."
- Source: filesystem/git scan (no cron execution log accessible)
- Verdict: UNVERIFIABLE
- Evidence: Neither this subagent nor the resumed session has access to any
  execution log for a cron job registered in a prior, now-closed session -- cron
  state is described as session-scoped/in-memory. The only available evidence is
  negative (no commits, no receipts, no file writes anywhere in the tree from
  01:27:43 to 08:45:39 PDT), which is consistent with non-firing but does not
  directly prove it; the strong causal conclusion about the mechanism is asserted
  with more certainty than the available evidence supports.
- Severity: major

### PE4 -- known-persistent-drift.txt baseline postdates pass 4, diff is circular,

- Lens: no-unexpected-drift-during-gap
- Claim: Diffing current `git status` against `.mfact/known-persistent-drift.txt`
  and finding zero delta is valid evidence that nothing changed since pass 4.
- Source: `git log -- .mfact/known-persistent-drift.txt`; `ls -la` on the file;
  `comm -23`/`comm -13` of a fresh porcelain-status file-list against the baseline
- Verdict: REFUTED
- Evidence: `.mfact/known-persistent-drift.txt` has exactly one commit in its
  history, `1e47b87` at 2026-07-13 08:46:41 -0700 ("baseline the
  known-persistent-drift pile for the collision guard"), matching its file mtime
  (this pass's own re-run of `git log --follow` on the path confirms the single
  commit and Jul 13 08:46 mtime). It did not exist during pass 4. The empty diff
  against it (0 lines added/removed via `comm`) is therefore circular: it proves
  the working tree matches a snapshot of itself taken six minutes before this
  audit ran, not that nothing changed since pass 4.
- Severity: major

### PE5 -- Stated idle-start time (00:48) undercounts real tail activity,

- Lens: idle-gap-confirmation
- Claim: The session went idle at "~00:48 PDT" (i.e., roughly when pass 4 ended).
- Source: `stat` mtimes across `/Users/sac/mfact` for the 00:50-08:44 window vs. a
  tighter 01:28-08:44 rescan
- Verdict: DRIFTED
- Evidence: Files continued to be written until 01:27:43 PDT:
  `PRAXIS_SELF_AUDIT.md` (00:50:25), `.lake/build` Lean artifacts for
  `random_walk`/`pair_correlation` (00:50:21-00:55:36), cargo/rustc incremental
  build output under `crates/mfact-core/target/debug/` (00:53:24-00:56:13), and
  `MFW_WORKFLOW_CATALOG.md` (01:27:43, last write). A rescan restricted to
  01:28:00-08:44:00 returned zero files anywhere in the tree, so genuine silence
  began at ~01:28, not ~00:48 -- about 40 minutes later than stated.
- Severity: minor

### PE6 -- Receipt count off by one: three files exist, not two,

- Lens: idle-gap-confirmation
- Claim: "The two existing receipt files" under `.mfact/receipts/` are both
  timestamped ~00:15-00:44, with no newer ones.
- Source: `ls -la` and `stat` on `/Users/sac/mfact/.mfact/receipts/`, re-run this
  pass
- Verdict: DRIFTED
- Evidence: Three files exist: `20260713T071516Z.json` (mtime 00:15:29),
  `20260713T074350Z.json` (00:44:04), and `latest.json` (00:44:13, 1113 bytes --
  identical size to `074350Z.json`, and a real regular file per `ls -la`, not a
  symlink, i.e. a written duplicate). This pass's own fresh `ls -la` reproduces
  the same three files and byte counts (998/1113/1113). The 00:15-00:44 range and
  "nothing newer" are correct, but "two files" undercounts what's on disk by one.
- Severity: minor

### PE7 -- Zero commits/receipts during the true 01:28-08:44 silence window,

- Lens: idle-gap-confirmation
- Claim: The core assertion that the environment was idle the entire gap -- zero
  new commits, zero new receipts -- between pass 4 and pass 5.
- Source: `git log --since="2026-07-13 00:50:00" --oneline`; full-tree `find
  -newermt` for 2026-07-13 01:28:00..08:44:00 excluding `.git`
- Verdict: CONFIRMED
- Evidence: `git log --since` matched only the 3 commits made by the current turn
  (PE1/PE2), none backdated into the gap. An unrestricted filesystem scan across
  the whole repo for the 01:28-08:44 window (the true post-tail-activity gap,
  per PE5) returned no files at all.
- Severity: minor

### PE8 -- Roughly-8-hours elapsed-time claim holds within stated tolerance,

- Lens: idle-gap-confirmation
- Claim: "Roughly 8 real-world hours passed between pass 4 (~00:48 PDT) and this
  pass (~08:49 PDT)."
- Source: `date`; `PRAXIS_SELF_AUDIT.md` pass 4's own "00:45:22" timestamp
- Verdict: CONFIRMED
- Evidence: `date` returned Mon Jul 13 08:50:23 PDT 2026 at original check time,
  and 08:54:27 PDT at this pass's own independent re-check. Against the stated
  ~00:48 mark: ~8h02m elapsed. Against pass 4's actual last commit (00:45:22):
  ~8h05m. Against the true end of filesystem activity (01:27:43, per PE5):
  ~7h23m of genuine idle silence. All are consistent with "roughly 8 hours," even
  though the sub-components are imprecise.
- Severity: minor

### PE9 -- Working-tree drift count (76) is unchanged from pass 4,

- Lens: no-unexpected-drift-during-gap
- Claim: Working-tree drift count is unchanged: `git status --porcelain` line
  count is still 76, matching pass 4's logged 76, and the file-path set is
  unchanged.
- Source: `git status --porcelain | wc -l`; `comm -23`/`comm -13` against
  `known-persistent-drift.txt`
- Verdict: CONFIRMED
- Evidence: Fresh `git status --porcelain | wc -l` = 76, both at original check
  time and re-confirmed by this pass's own re-run. Both `comm -23` (files newly
  dirty, not in baseline) and `comm -13` (files no longer dirty) returned empty
  output -- the 76-entry sets are identical. This holds independent of PE4's
  provenance caveat: the untracked/modified file set itself has not drifted, at
  least since the baseline was captured six minutes before the original check.
- Severity: minor

### PE10 -- git fsck shows a clean repo, no corruption after the idle span,

- Lens: no-unexpected-drift-during-gap
- Claim: `git fsck` integrity check reveals a repo integrity concern after the
  long idle span.
- Source: `git fsck --no-progress 2>&1 | grep -Ei 'error|missing|corrupt|broken'`;
  `git count-objects -v`, both re-run fresh this pass
- Verdict: REFUTED
- Evidence: Original check reported 4028 dangling objects (3998 blobs, 14
  commits, 10 tags, 6 trees) but zero lines matching
  `error|missing|corrupt|broken`; sampled dangling commits were pre-existing
  `git stash` "WIP on v26.7.12-close..." byproducts dated 2026-07-07 through
  2026-07-12, none from the claimed idle window. This pass's own fresh re-run of
  the same grep returned zero matches again, and `git count-objects -v` shows
  `garbage: 0`, `size-garbage: 0`, one clean pack (`count: 4493`,
  `in-pack: 5056`). No stray `.lock` files in `.git`. Repo is intact.
- Severity: minor

### PE11 -- .mfact/receipts/ gained zero files, loop stayed dormant,

- Lens: no-unexpected-drift-during-gap
- Claim: `.mfact/receipts/` gained zero new files since pass 4, confirming the
  cron-driven fix loop did not fire.
- Source: `ls -la .mfact/receipts/`, re-run fresh this pass
- Verdict: CONFIRMED
- Evidence: Directory contains only `20260713T071516Z.json` (00:15 PDT),
  `20260713T074350Z.json` and `latest.json` (both 00:44 PDT) -- nothing newer,
  reproduced identically by this pass's own `ls -la`. This specifically confirms
  the automated/cron fix-loop mechanism stayed dormant; it does not mean the repo
  was untouched overall, since PE1 shows separate interactive-session commits
  landed at 08:45-08:48 outside that mechanism.
- Severity: minor

### PE12 -- Cron scheduler internals are not directly introspectable,

- Lens: no-unexpected-drift-during-gap
- Claim: Cron job `6f81400b`'s 07:47:32 PDT deadline passed without firing, per
  the pass narrative.
- Source: no direct scheduler introspection tool available in this environment;
  inferred only from receipts absence (PE11)
- Verdict: UNVERIFIABLE
- Evidence: Cannot independently query cron-scheduler internal state from this
  sandbox -- only observable effects (receipts, commits) were checked. Receipt
  evidence is consistent with non-firing but is not direct confirmation of the
  deadline mechanics themselves.
- Severity: minor

### PE13 -- Catalog 1.1's Mathlib+Wave-M0 composition proposal re-verified,

- Lens: mfw-catalog-top-claim-verify
- Claim: Catalog section 1.1 ("wave-m1-crown-descent") composes Mathlib's
  `Multiset.wellFounded_isDershowitzMannaLT` (pinned rev `fabf563a`) with Wave
  M0's already-proven residue formalization (`residue`, `residue_isAntichain`,
  `residue_purity` in `Antichain.lean:64,75,113`; `AdmittedObligationOrder` in
  `EntailmentOrder.lean:46`) to formalize the Dershowitz-Manna crown-descent
  chain, and lists this as unstarted future work (blank marker
  `MFW_M1_DM_DESCENT_FORMALIZED=`, no `Termination/` files yet).
- Source: `MFW_WORKFLOW_CATALOG.md:85-109`; independently re-grepped this pass
- Verdict: CONFIRMED
- Evidence: Both halves independently re-verified. (1)
  `Mathlib.Data.Multiset.DershowitzManna.lean:165-171` in the vendored package at
  `procint/.lake/packages/mathlib/` declares
  `theorem wellFounded_isDershowitzMannaLT [WellFoundedLT α] : WellFounded
  (IsDershowitzMannaLT : Multiset α → Multiset α → Prop)`, fully proved (no
  sorry), and `procint/lake-manifest.json` pins mathlib at
  `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` -- confirmed again this pass via
  direct grep, exact match to the "fabf563a" short-rev claim. (2) A fresh grep of
  all four Wave M0 files this pass (`Obligation.lean`, `EntailmentOrder.lean`,
  `MinimalSupport.lean`, `Antichain.lean`) for `sorry|admit` returns only
  docstring prose ("admitted obligation", "No `sorry`.") never a Lean tactic;
  `.olean` build artifacts (Jul 12 22:47:17-22:47:22) are confirmed strictly
  newer than every corresponding `.lean` source file (21:46:54-21:52:44),
  reconfirming a real `lake build` succeeded after the current source was
  written. `residue`/`residue_isAntichain`/`residue_purity`
  (`Antichain.lean:64,75,113`) and `AdmittedObligationOrder`
  (`EntailmentOrder.lean:46,53`) exist at exactly the cited line numbers.
  `procint/ProcInt/MFW/Termination` still does not exist (`find` returns "No
  such file or directory", re-run fresh this pass) -- the catalog's own framing
  (proposal, not yet done) remains internally consistent.
- Severity: minor

### PE14 -- Wave M0 residue theorems remain genuinely proven, no gaps,

- Lens: mfw-catalog-top-claim-verify
- Claim: Wave M0's residue theorems are "already-proven" / kernel-checked as the
  catalog states, with no gaps in the load-bearing chain the proposal depends on.
- Source: `procint/ProcInt/MFW/Residue/Antichain.lean:40-45` docstring
- Verdict: CONFIRMED
- Evidence: Read-only inspection confirms the file's own standing claim matches
  reality: no `sorry`/`admit` tactics present, and build artifacts (`.olean`,
  Jul 12 22:47) postdate the source (Jul 12 21:52), consistent with a genuine
  successful `lake build` of these files. The file itself flags a separate,
  narrower caveat unrelated to the catalog's claim: `orFree_residue_subsingleton`
  only covers a semantic reading of OR-freeness, with the syntactic-to-semantic
  bridge marked MISSING in `AGENTS.md` taxonomy -- but the catalog's proposal
  only cites `residue`/`residue_isAntichain`/`residue_purity`, not
  `orFree_residue_subsingleton`, so this caveat does not touch the specific
  composition the catalog proposes.
- Severity: minor

### PE15 -- This pass could not literally re-run `lake build` (read-only mandate),

- Lens: mfw-catalog-top-claim-verify
- Claim: Task framing states the residue build must be verified by "re-running
  the actual build command" (i.e., `lake build`).
- Source: fix-loop task instructions for this pass
- Verdict: UNVERIFIABLE
- Evidence: This subagent operates under a hard read-only mandate (no file
  creation, no commands that change system state) and cannot invoke `lake build`
  or `lake env lean`, since both write `.lake` build-cache/`.olean`/`.trace`
  artifacts to disk. Verification was instead performed via static evidence:
  absence of `sorry`/`admit` in source, and `.olean`/`.trace` mtimes (22:47
  Jul 12) strictly newer than the corresponding `.lean` source mtimes
  (21:46-21:52 Jul 12), the strongest signal obtainable without executing a
  build. A parent agent/session with write permission would need to actually
  re-run `lake build ProcInt.MFW.Residue` (or the four individual targets) and
  paste `#print axioms` output to fully close this per the task's own
  falsifiability bar (catalog line 106-109 requires exactly that for the *new*
  Wave M1 work, not Wave M0, so this gap does not affect PE13's verdict, only the
  literal "re-run the build command" instruction).
- Severity: minor

## Pass 6 findings

### PF1 -- v3 collision guard is likely to flag PRAXIS_SELF_AUDIT.md next firing,

- Lens: status-delta-investigation
- Claim: The v3 delta-based collision guard, which treats any `git status
  --porcelain` path not listed in `.mfact/known-persistent-drift.txt` as a real
  collision, will trigger on `PRAXIS_SELF_AUDIT.md`'s now-uncommitted 307-line
  append at the fix loop's next STEP 1 check, because the file was clean (and
  thus absent from the baseline) at snapshot time.
- Source: `MFACT_SELF_IMPROVEMENT_LOOP.md` lines 90-103 ("Collision guard"
  section); `.mfact/known-persistent-drift.txt` (76 lines, no
  `PRAXIS_SELF_AUDIT.md` entry); `git diff --stat -- PRAXIS_SELF_AUDIT.md`
  (307 insertions, uncommitted)
- Verdict: UNVERIFIABLE
- Evidence: The design doc states verbatim: "v3 ... diffs live `git status
  --porcelain` against a baseline snapshot ... and only treats paths NOT in
  that baseline as a real collision." `known-persistent-drift.txt` was
  generated by commit `1e47b87` at 08:46:41 PDT, 62 seconds after
  `PRAXIS_SELF_AUDIT.md` was last committed clean by `17b4c51` (08:45:39 PDT),
  so the baseline correctly has no line for it. Pass 5 then appended 307
  uncommitted lines to that same file afterward, and this pass added more
  (see PF2-PF4). Mechanically, the next STEP 1 check that diffs current `git
  status --porcelain` against the baseline will find `PRAXIS_SELF_AUDIT.md`
  present only on the "current" side -- exactly the shape the guard defines
  as a collision. No firing has reached STEP 1 since the append landed, so
  this pass cannot confirm the abort with a live observation (verdict is
  UNVERIFIABLE, not CONFIRMED, for that reason), but the risk is actionable:
  every pass that appends findings to this file without committing recreates
  the condition v1/v2's absolute-clean-tree guard was redesigned to avoid.
- Severity: major

### PF2 -- Single new-since-baseline path is PRAXIS_SELF_AUDIT.md, fully explained,

- Lens: status-delta-investigation
- Claim: The lone path new since the pass-4/5 baseline is
  `PRAXIS_SELF_AUDIT.md`, fully accounted for by pass 5's own uncommitted
  307-line append to the tracked, previously-clean file.
- Source: `comm -23` of a freshly sorted `git status --porcelain` path list
  against a freshly sorted `.mfact/known-persistent-drift.txt`; `git diff
  --stat -- PRAXIS_SELF_AUDIT.md`; `git log --follow -3 --
  PRAXIS_SELF_AUDIT.md`; `git show HEAD:PRAXIS_SELF_AUDIT.md | grep 'Pass 5
  findings'`
- Verdict: CONFIRMED
- Evidence: `comm -23` (current-only paths) returned exactly one line:
  `PRAXIS_SELF_AUDIT.md`. `git diff --stat` shows `1 file changed, 307
  insertions(+)`, zero deletions. The file's only commit is `17b4c51`
  (2026-07-13 08:45:39 -0700); `git show HEAD:PRAXIS_SELF_AUDIT.md` has
  content only through `## Pass 4 findings`, no "Pass 5 findings" header,
  confirming the committed blob predates pass 5's append. File mtime (08:57)
  is ~11 minutes after the baseline-generating commit (08:46:41).
- Severity: minor

### PF3 -- 76-to-77 delta is arithmetically fully accounted for, no other drops,

- Lens: status-delta-investigation
- Claim: The 76->77 porcelain-line delta is exactly the one path in PF2 gaining
  a diff; no baseline path disappeared and no second new/untracked path
  appeared.
- Source: `comm -13`/`comm -23` between the freshly sorted baseline and
  current status lists; `wc -l` on both
- Verdict: CONFIRMED
- Evidence: `comm -13` (baseline-only, i.e. anything dropped) returned zero
  lines. `comm -23` (current-only) returned exactly the one line from PF2.
  77 - 76 = 1, matching exactly.
- Severity: minor

### PF4 -- The uncommitted append is well-formed and not a product of this pass,

- Lens: status-delta-investigation
- Claim: The uncommitted append to `PRAXIS_SELF_AUDIT.md` is not truncated or
  corrupted mid-write, and no "Pass 6" content existed in the file prior to
  this pass's own edits.
- Source: `git diff --numstat -- PRAXIS_SELF_AUDIT.md`; `tail -20
  PRAXIS_SELF_AUDIT.md`; `git diff -- PRAXIS_SELF_AUDIT.md | tail -30`; `grep
  -n 'Pass 6\|pass 6' PRAXIS_SELF_AUDIT.md`
- Verdict: CONFIRMED
- Evidence: The diff was purely additive (307/0). Its last hunk closed
  finding PE15 cleanly, immediately followed by the pre-existing `##
  References` section; the working file's tail matched the diff's tail
  exactly. The pre-edit `grep` for "Pass 6" returned nothing, ruling out this
  pass having already written to the file before this check ran.
- Severity: minor

### PF5 -- Fix loop f6a6cd52 produced no observable activity through 09:16 PDT,

- Lens: fix-loop-firing-detection
- Claim: Fix loop `f6a6cd52` has not fired under the v3 guard at any point
  during this pass, including through and past its ~09:12 PDT scheduled slot.
- Source: `date` + `git log -1 --format='%H %ci %s'` + `ls -la
  .mfact/receipts/`, freshly sampled at 09:11:11, 09:14:23, 09:14:48, and
  09:16:12 PDT
- Verdict: CONFIRMED
- Evidence: HEAD stayed at `a824ebc` across all samples. `.mfact/receipts/`
  held only the same two pre-existing files (`20260713T071516Z.json`,
  `20260713T074350Z.json`, plus `latest.json`) at every sample -- no new file
  appeared even ~4 minutes past the stated ~09:12 slot.
- Severity: minor

### PF6 -- Both existing receipts predate the v3 delta-based guard,

- Lens: fix-loop-firing-detection
- Claim: The two receipts on disk (07:15:16Z, 07:43:50Z) reflect the pre-v3
  (v1/v2, absolute-clean-tree) collision guard, not v3 -- consistent with "a
  real v3 firing hasn't happened yet."
- Source: `.mfact/receipts/20260713T071516Z.json`,
  `.../20260713T074350Z.json`; `MFACT_SELF_IMPROVEMENT_LOOP.md` run log and
  "Collision guard" section; commit timestamps for `1e47b87`/`a824ebc`
- Verdict: CONFIRMED
- Evidence: Both receipts are timestamped 00:15/00:44 PDT, while the v3
  baseline file was created by `1e47b87` at 08:46:41 PDT and the v3 design
  doc committed as `a824ebc` at 08:47:56 PDT -- roughly 8 hours after the
  receipts. The run log labels both as testing the pre-v3 behavior
  explicitly.
- Severity: minor

### PF7 -- ps sightings of an "unrelated process" are this shell's own find,

- Lens: fix-loop-firing-detection
- Claim: A process observed via `ps aux` running receipts/git-log/find-style
  checks against this repo, previously logged as an unattributable "unrelated
  process," is explained by this Claude Code shell's own `find` -> `bfs`
  wrapper, not necessarily by an external session.
- Source: `type find` and `which find` in this shell; `ps aux | grep -iE
  'receipts|f6a6cd52|mfact'` run immediately after issuing a `find` command
  this pass
- Verdict: CONFIRMED
- Evidence: `type find` shows `find` is a zsh function in this environment's
  shell snapshot that execs the Claude Code binary with `ARGV0=bfs`
  (`bfs -S dfs -regextype findutils-default ...`). A fresh `ps aux` sampled
  seconds after this pass's own `find -newermt ...` call caught PID 73925
  running that exact command line under the name `bfs`. Because any Claude
  Code shell (this session's or a concurrent one, including the fix loop's
  own subagent shell) uses the identical wrapper, a bare `bfs` sighting
  cannot by itself distinguish this session's own commands from a genuinely
  separate session's -- it only proves the mechanism, not which session
  produced any specific historical PID. The earlier-logged PIDs
  (71338/71341) were not independently re-observed this pass and remain
  formally unattributed.
- Severity: minor

## Pass 7 findings

### PG1 -- AxiomAudit.lean has no main/entry point, not meant to be an executable,

- Lens: axiom-count-gap-investigation
- Claim: `AxiomAudit.lean` is not meant to be a standalone executable -- it has no
  `main`/entry point and consists solely of `#guard_msgs in #print axioms ...`
  compile-time diagnostic directives.
- Source: read `mfact/AxiomAudit.lean` and `procint/AxiomAudit.lean` (both
  identical in structure) in full
- Verdict: CONFIRMED
- Evidence: `mfact/AxiomAudit.lean` is `import Mfact` followed by four `/-- info:
  ... -/ #guard_msgs in #print axioms Mfact.xxx` blocks, no `def main`.
  `procint/AxiomAudit.lean` is the ggen-rendered analog for `ProcInt.*`, same
  pattern (header states "ggen renders; Lean admits."). The axiom-set
  assertions are checked by the Lean elaborator at build time via
  `#guard_msgs`; the build fails if the printed axiom list drifts from the
  expected `info` comment. There is nothing to run afterward.
- Severity: major

### PG2 -- Both lakefiles correctly declare AxiomAudit as lean_lib, not lean_exe,

- Lens: axiom-count-gap-investigation
- Claim: Both `lakefile.toml` files declare `AxiomAudit` as a `[[lean_lib]]`, not
  a `[[lean_exe]]`, so Lake correctly never produces a binary for it -- this is
  the root cause of "no binary at the expected path", and it is by design, not
  a bug in the lakefile.
- Source: read `mfact/lakefile.toml` and `procint/lakefile.toml`
- Verdict: CONFIRMED
- Evidence: `mfact/lakefile.toml` has `[[lean_lib]] name = "AxiomAudit"`
  alongside `[[lean_lib]] name = "Mfact"`; its only `[[lean_exe]]` is `name =
  "mfact", root = "Mfact.Cli"`. `procint/lakefile.toml` matches --
  `[[lean_lib]] name = "AxiomAudit"`, with the only `[[lean_exe]]` being
  `swarm11Verifier` (explicitly commented "Hand-authored demo executable ...
  Not a default target"). Since AxiomAudit has no `main`, declaring it
  `lean_exe` would not even compile -- `lean_lib` is the structurally correct
  declaration.
- Severity: major

### PG3 -- .lake/build/bin/ never contained an AxiomAudit binary in either package,

- Lens: axiom-count-gap-investigation
- Claim: The actual `.lake/build/bin/` directories in both packages contain no
  AxiomAudit binary at all -- only the real `lean_exe` targets -- confirming
  the "missing binary" isn't a stale/broken build artifact but reflects that
  no such target has ever existed.
- Source: `ls mfact/.lake/build/bin/` and `ls procint/.lake/build/bin/`
- Verdict: CONFIRMED
- Evidence: `mfact/.lake/build/bin/` contains only `mfact` (98MB executable +
  hash/rsp/trace). `procint/.lake/build/bin/` contains only `swarm11Verifier`
  (137MB executable + hash/rsp/trace). Neither directory has ever contained an
  AxiomAudit entry.
- Severity: minor

### PG4 -- AxiomAudit does build successfully as a library in both packages,

- Lens: axiom-count-gap-investigation
- Claim: AxiomAudit *does* build successfully as a library -- `.olean`/`.ilean`
  artifacts exist for it in both packages -- consistent with the firing-3
  log's own claim that the build "succeeded per its own log".
- Source: `ls -la` on `.lake/build/lib/lean/AxiomAudit.*` in both `mfact/` and
  `procint/`
- Verdict: CONFIRMED
- Evidence: mfact: `AxiomAudit.olean` (2664 bytes), `.ilean`, `.trace` all
  present, mtime Jul 7 20:11. procint: same set present, mtime Jul 12 01:52.
  Both predate the firing-3 timestamp (Jul 13 16:31:30Z), meaning lake did not
  need to recompile them this firing (hashes already up to date) -- plausible
  as a true incremental no-op "success" rather than evidence the build was
  actually re-run and re-verified this firing.
- Severity: minor

### PG5 -- No checked-in script computes axiom_count; JSONL field is illustrative,

- Lens: axiom-count-gap-investigation
- Claim: No checked-in script in the repo computes/writes an `axiom_count` field
  into `metrics-history.jsonl`; the JSONL format is only illustrated as a
  documentation example, so the "expected path" the firing-3 process looked
  for a binary at was presumably an ad hoc assumption made in-session, not a
  bug in a fixed tool.
- Source: `grep -rn axiom_count` and `grep -rln gaps_closed_this_firing` across
  the repo (excluding `.lake` and worktrees)
- Verdict: CONFIRMED
- Evidence: Only hits for `axiom_count` are the
  `MFACT_SELF_IMPROVEMENT_LOOP.md` documentation example line (`{"timestamp":
  "...", ... "axiom_count": 3}`) and its own prose about the firing-3 null.
  `scripts/build_quadrature.py` and `scripts/independent_replay.sh` reference
  `AxiomAudit.lean`/`lake build AxiomAudit` but never a binary path, and no
  script writes `metrics-history.jsonl` at all -- that file is hand/agent-
  maintained per firing, not tool-generated.
- Severity: minor

### PG6 -- Candidate future fix: derive axiom_count from build stdout, not a binary,

- Lens: axiom-count-gap-investigation
- Claim: Candidate fix for a future firing: the axiom-count collection logic
  (not the lakefile) is what's broken. AxiomAudit is correctly a `lean_lib`
  and should stay one; the fix is to derive `axiom_count` by parsing `lake
  build AxiomAudit`'s stdout for the `#print axioms` info messages (or by
  scanning `AxiomAudit.lean` for `depends on axioms:` vs total `#print axioms`
  directive count) rather than expecting a compiled binary to execute.
- Source: synthesis of PG1-PG5 (`mfact/AxiomAudit.lean`, `mfact/lakefile.toml`,
  `procint/lakefile.toml`, bin/ directory listings)
- Verdict: UNVERIFIABLE
- Evidence: This is a recommendation, not a re-run verification -- `lake` is
  not installed/on PATH in this sandbox (`lake: command not found`), so the
  actual stdout format of `lake build AxiomAudit` could not be captured live
  this pass. Framing it as a "one-line lakefile change" would be wrong: the
  lakefile is already correct as-is; the real fix belongs in whatever
  script/prompt computes `axiom_count`, not in either `lakefile.toml`.
- Severity: minor

### PG7 -- simulate_workload is a real scalar-loop implementation, not a stub,

- Lens: g49-closure-reverify
- Claim: `simulate_workload` in `crates/mfact-core/src/bin/turbulence.rs` is a
  real implementation (scalar loop + `black_box`), not a stub.
- Source: `crates/mfact-core/src/bin/turbulence.rs` lines 16-22 (read in full)
- Verdict: CONFIRMED
- Evidence: `fn simulate_workload(iterations: usize)` loops `0..iterations`
  doing `wrapping_add`/`wrapping_mul` on an accumulator and calls
  `std::hint::black_box(acc)` at the end -- genuine CPU work with a dead-code-
  elimination guard, matching its doc comment's stated purpose.
- Severity: minor

### PG8 -- cargo check --bin turbulence exits 0 from the crate directory,

- Lens: g49-closure-reverify
- Claim: `cargo check --bin turbulence` exits 0.
- Source: live re-run of `cargo check --bin turbulence`
- Verdict: CONFIRMED
- Evidence: From `/Users/sac/mfact` (repo root) the command fails with "no bin
  target named turbulence in default-run packages" because the root
  `Cargo.toml` (package `mfact`) is not a workspace -- `crates/mfact-core` is
  a standalone crate. From `crates/mfact-core` the command genuinely finishes
  with "Finished dev profile ... in 0.02s", exit 0.
- Severity: minor

### PG9 -- cargo run --bin turbulence executes and prints real benchmark output,

- Lens: g49-closure-reverify
- Claim: `cargo run --bin turbulence` actually executes and prints real
  benchmark output rather than panicking.
- Source: live re-run of `timeout 60 cargo run --bin turbulence` from
  `crates/mfact-core`
- Verdict: CONFIRMED
- Evidence: Produced a full benchmark table across 11 work/task scales with
  genuinely varying density values (19,067 to 154,507,779 tasks/s) and
  correctly triggered the phase-transition detection branch at
  Work/Task=50000, alpha=-0.3508 -- dynamic data-dependent output, not a
  stub/panic.
- Severity: minor

### PG10 -- sse_transport_test.rs's separate pre-existing break is untouched,

- Lens: g49-closure-reverify
- Claim: `tests/sse_transport_test.rs`'s separate pre-existing break is
  untouched, out of scope for the G49 fix.
- Source: `git diff --stat eabe589^ 6329c9d -- crates/mfact-core/tests/
  sse_transport_test.rs`; `git status`; file mtime
- Verdict: CONFIRMED
- Evidence: Diff across the fix commits is empty. File is untracked (`git
  status` shows `??`) with mtime Jul 12 05:46:45 2026, predating the Jul 13
  09:31 fix commit. `mfact-core/Cargo.toml` still has no tokio/
  futures_util/reqwest_eventsource deps, so the break persists unchanged.
- Severity: minor

### PG11 -- G49 ledger's own documented grep command is not reproducible as written,

- Lens: g49-closure-reverify
- Claim: G49 ledger entry: `grep -rn "empirical.ingestion|empirical_data"`
  across the crate found no empirical-ingestion replacement code.
- Source: `GAP_LEDGER_v26.7.12.md` lines 984-987; re-ran the exact documented
  command
- Verdict: DRIFTED
- Evidence: The documented command omits `-E`, so grep's basic-regex mode
  treats `|` as a literal character, not alternation -- the command as
  written cannot match either search term and trivially returns nothing
  regardless of whether replacement code exists. Re-running with `-E` against
  the pre-fix tree (`eabe589^`) across every file in the crate independently
  confirms the underlying conclusion is true (only match is the doc comment
  itself), but the literal command quoted in the ledger is not reproducible
  as claimed.
- Severity: minor

### PG12 -- sse_transport_test.rs break is broader than "missing deps" alone,

- Lens: g49-closure-reverify
- Claim: `sse_transport_test.rs`'s pre-existing break is due to "missing
  tokio/reqwest_eventsource deps".
- Source: commit `eabe589` message and `GAP_LEDGER_v26.7.12.md` G49 entry; live
  `cargo check --test sse_transport_test`
- Verdict: DRIFTED
- Evidence: Live compile also fails with `error[E0432]: unresolved import
  mfact_core::transport` -- `crates/mfact-core/src/transport.rs` exists on
  disk but is never declared via `mod transport;`/`pub mod transport;` in
  `src/lib.rs` (`lib.rs` only declares `pub mod receipt;` and `pub mod
  validate;`). The break is broader than "missing deps" -- there's also an
  unwired module -- though this doesn't affect G49's own validity since the
  file remains correctly untouched and out of scope.
- Severity: minor

### PG13 -- No drift this pass: HEAD unchanged, porcelain count matches baseline,

- Lens: general-status-and-next-firing-catch
- Claim: Working tree porcelain count matches the pass-6 baseline (76) with
  zero new drift, and HEAD stayed at `6329c9d` through the pass window with no
  firing-4 landing.
- Source: `git status --porcelain | wc -l`; `.mfact/known-persistent-drift.txt`;
  `git log --oneline -5` sampled at 09:39 and 09:42:54 PDT, and again live at
  09:46:27 PDT during this write-up
- Verdict: CONFIRMED
- Evidence: Count was 76 at all three samples (09:39, 09:42:54, 09:46:27
  PDT). `comm -23` between sorted live `git status` paths and
  `known-persistent-drift.txt` was empty in both directions (exact 76=76
  1:1 match) at every sample. HEAD stayed at `6329c9d` "chore(loop): record
  firing-3 success receipt (G49 closure)" atop `eabe589` throughout; no new
  commit appeared during this pass.
- Severity: minor

### PG14 -- Pre-fix build was genuinely broken exactly as G49/the receipt describe,

- Lens: general-status-and-next-firing-catch
- Claim: Pre-fix build was genuinely broken exactly as described, and the
  "empirical ingestion" doc-comment claim was stale/unsupported.
- Source: `git show 02e7a5e:crates/mfact-core/src/bin/turbulence.rs`; live grep
  for `empirical.ingestion|empirical_data`
- Verdict: CONFIRMED
- Evidence: The parent commit's blob calls `simulate_workload(work_per_task)`
  at line 16 with no definition anywhere in the file -- matches the receipt's
  claimed `E0425` at `turbulence.rs:16:13` exactly. Live grep finds zero real
  "empirical ingestion" implementation anywhere in the crate, only the fix's
  own comment referencing the search.
- Severity: minor

### PG15 -- GAP_LEDGER's G49=CLOSED entry lands in the fix commit, totals check out,

- Lens: general-status-and-next-firing-catch
- Claim: `GAP_LEDGER_v26.7.12.md` was updated with G49=CLOSED in the same
  commit as the fix, and totals are internally consistent.
- Source: `GAP_LEDGER_v26.7.12.md` (commit `eabe589` diff and live file)
- Verdict: CONFIRMED
- Evidence: G49 was added with `Status: CLOSED` in the identical commit as the
  code fix (`eabe589`, not a follow-up). Live `grep -c '^### G'` = 49; totals
  row math 3+30+16=49 checks out; Minor row correctly bumped 15->16, range
  34-48->34-49.
- Severity: minor

### PG16 -- metrics-history's gaps_open:23 matches an independent live count,

- Lens: general-status-and-next-firing-catch
- Claim: `metrics-history.jsonl`'s `gaps_open:23` matches an independent live
  count of ledger OPEN items.
- Source: `.mfact/metrics-history.jsonl`; live grep of `Status: [A-Z]+` in
  `GAP_LEDGER_v26.7.12.md`
- Verdict: CONFIRMED
- Evidence: Live count: 23 OPEN / 14 BLOCKED / 11 CLOSED / 1 PARTIAL = 49
  total, matching `metrics-history.jsonl`'s `gaps_open:23` and the ledger's
  own G1-G49 total.
- Severity: minor

### PG17 -- cargo check --all-targets still fails, but for a separate reason,

- Lens: general-status-and-next-firing-catch
- Claim: `cargo check --all-targets` still fails for mfact-core, but for a
  separate pre-existing reason unrelated to G49, and the receipt never
  overclaims all-targets now passes.
- Source: live `cargo check --all-targets` in `crates/mfact-core/`; `git
  ls-files` on `src/main.rs` and `src/transport.rs`
- Verdict: CONFIRMED
- Evidence: Live `--all-targets` fails with E0432 (missing transport module
  wiring), E0433 (tokio), E0752 (async main) in `src/main.rs`, a different bin
  target untouched by `eabe589`. Both `main.rs` and `transport.rs` are
  untracked (`git ls-files` returns empty for both), part of the pre-existing
  untracked pile already in `known-persistent-drift.txt`. Receipt/ledger only
  ever claim `--bin turbulence` passes, never `--all-targets`, so scoping is
  honest -- flagged for future-pass awareness only.
- Severity: minor

### PG18 -- sorry_count:16 only reproduces via a loose, prose-matching grep,

- Lens: general-status-and-next-firing-catch
- Claim: `sorry_count:16` is reproducible only via a loose, non-word-bounded
  grep that also matches prose, making it a weak proxy despite the honest
  "not a kernel-level check" caveat.
- Source: `GAP_LEDGER_v26.7.12.md` G49 note; live grep over `procint/ProcInt/`
- Verdict: CONFIRMED
- Evidence: `grep -rn 'sorry' procint/ProcInt/` (substring) = 16, matching the
  claim exactly, but includes prose hits like "sorry-free", "sorry-backed",
  "sorry-bearing". Word-boundary grep (`\bsorry\b`) over the same scope
  yields 11, not 16.
- Severity: minor

## Pass 8 findings

### PH1 -- just stuck-item-guard runs successfully with exit 0 against live receipts,

- Lens: g50-closure-reverify
- Claim: `just stuck-item-guard` runs successfully with exit 0 against the
  live receipts directory.
- Source: live command: `just stuck-item-guard` at HEAD 672fdeb
- Verdict: CONFIRMED
- Evidence: Output: '4 receipt(s) considered (window=10, threshold=7). No
  gap_id exceeds the threshold with zero successes in the window. Nothing
  flagged.' Exit code 0. (Count is 4, not the 3 cited in the ledger's closure
  evidence, because the G50 firing's own receipt 20260713T165952Z.json was
  added after that evidence text was written -- expected, not a discrepancy.)
- Severity: minor

### PH2 -- justfile recipe uses --receipts flag, not positional, matching commit claim,

- Lens: g50-closure-reverify
- Claim: The justfile recipe uses `--receipts` flag, not a positional
  argument, matching the commit's claim.
- Source: justfile lines 236-238
- Verdict: CONFIRMED
- Evidence: `stuck-item-guard:\n    @python3 scripts/stuck_item_guard.py
  --receipts .mfact/receipts/`
- Severity: minor

### PH3 -- MFACT_SELF_IMPROVEMENT_LOOP.md cross-references the script and just recipe,

- Lens: g50-closure-reverify
- Claim: MFACT_SELF_IMPROVEMENT_LOOP.md's 'Stuck-item guard' section cross-
  references the script and the just recipe.
- Source: MFACT_SELF_IMPROVEMENT_LOOP.md lines 83-95
- Verdict: CONFIRMED
- Evidence: 'Implemented for real at `scripts/stuck_item_guard.py`, wired into
  `just stuck-item-guard` -- a deterministic cross-firing repetition check...
  A firing may run `just stuck-item-guard` as part of STEP 2 instead of re-
  deriving the check by hand from raw receipt files.'
- Severity: minor

### PH4 -- First recipe attempt failed: positional arg vs. script's --receipts-only flags,

- Lens: g50-closure-reverify
- Claim: First recipe attempt failed with 'unrecognized arguments' because it
  passed the receipts dir positionally while the script's argparse only
  defines --receipts as a flag (no positional param). The claimed convention
  mismatch with the neighboring trajectory-annotate recipe (which does pass
  its target positionally) is also real, not fabricated.
- Source: scripts/stuck_item_guard.py argparse block; reproduced live via
  `python3 scripts/stuck_item_guard.py .mfact/receipts/`; justfile:228-229
  (trajectory-annotate); scripts/trajectory_annotate.py:522
- Verdict: CONFIRMED
- Evidence: Script defines only --receipts/--window/--threshold/--json (all
  optional flags, no positional arg). Reproducing the claimed first attempt:
  `python3 scripts/stuck_item_guard.py .mfact/receipts/` ->
  'stuck_item_guard.py: error: unrecognized arguments: .mfact/receipts/', exit
  2 -- verbatim match to the error text quoted in the G50 ledger entry and
  receipt 20260713T165952Z.json's verify_delta.after field. Separately
  confirmed the neighboring `trajectory-annotate` recipe (justfile:228-229)
  does call `scripts/trajectory_annotate.py .mfact/receipts/` positionally,
  and trajectory_annotate.py's argparse (line 522) does define a positional
  `target` arg -- so the two scripts genuinely use different calling
  conventions, which is the source of the confusion the commit describes.
- Severity: minor

### PH5 -- 'argparse requires --receipts DIR' overstates the cause; it is optional,

- Lens: g50-closure-reverify
- Claim: 'stuck_item_guard.py's argparse requires --receipts DIR' (commit
  message and ledger wording).
- Source: commit c636fd3 message; GAP_LEDGER_v26.7.12.md G50 entry
- Verdict: DRIFTED
- Evidence: Technically imprecise: --receipts has default=None and is not
  required=True; `python3 scripts/stuck_item_guard.py` with zero args works
  fine (falls back to repo-relative .mfact/receipts/, verified live, exit 0).
  The actual cause of the first-attempt failure is that the parser defines no
  positional argument at all, not that --receipts is mandatory. The reproduced
  failure/fix behavior itself is accurate; only the causal description
  ('requires') is loosely worded.
- Severity: minor

### PH6 -- c636fd3 touched exactly 3 doc/config files; the script pre-existed untouched,

- Lens: g50-closure-reverify
- Claim: Commit c636fd3 touched exactly justfile,
  MFACT_SELF_IMPROVEMENT_LOOP.md, and GAP_LEDGER_v26.7.12.md;
  scripts/stuck_item_guard.py already existed standalone and was not modified
  by this commit.
- Source: git show c636fd3 --stat; git log -1 -- scripts/stuck_item_guard.py
- Verdict: CONFIRMED
- Evidence: `git show c636fd3 --stat` lists only the 3 doc/config files (36
  insertions, 1 deletion). `git log --oneline -1 --
  scripts/stuck_item_guard.py` shows the script's last change was commit
  4fabb1c (trajectory tooling), not c636fd3 -- consistent with the claim that
  the script pre-existed and worked before being wired in. All four files are
  clean (no uncommitted diffs) at HEAD 672fdeb.
- Severity: minor

### PH7 -- metrics-history.jsonl line 1 (firing 3, git_head eabe589): sorry_count=16,

- Lens: metrics-integrity-check
- Claim: metrics-history.jsonl line 1 (firing 3, git_head eabe589):
  sorry_count=16
- Source: .mfact/metrics-history.jsonl:1
- Verdict: CONFIRMED
- Evidence: Live re-run of `grep -rn "sorry" procint/ProcInt
  --include="*.lean" | grep -v "^\s*--\|/-" | wc -l` on the current tree
  returns 16, matching the logged value exactly.
- Severity: minor

### PH8 -- metrics-history.jsonl line 2 (firing 4, git_head c636fd3): sorry_count=16,

- Lens: metrics-integrity-check
- Claim: metrics-history.jsonl line 2 (firing 4, git_head c636fd3):
  sorry_count=16
- Source: .mfact/metrics-history.jsonl:2
- Verdict: CONFIRMED
- Evidence: Same live re-run of the sorry-count command returns 16 against
  current HEAD (672fdeb), which is a strict descendant of c636fd3 and touched
  no .lean files in between (only justfile, MFACT_SELF_IMPROVEMENT_LOOP.md,
  GAP_LEDGER, and receipt files) -- so 16 is correct for that commit too.
- Severity: minor

### PH9 -- Both metrics-history.jsonl lines log gaps_open=23,

- Lens: metrics-integrity-check
- Claim: Both metrics-history.jsonl lines log gaps_open=23
- Source: .mfact/metrics-history.jsonl:1-2
- Verdict: CONFIRMED
- Evidence: Live `grep -c "^- Status: OPEN" GAP_LEDGER_v26.7.12.md` on the
  current tree returns 23. Additionally re-derived historically via `git show
  <rev>:GAP_LEDGER_v26.7.12.md | grep -c "^- Status: OPEN"` at eabe589,
  c636fd3, and 672fdeb -- all three return 23, matching both logged snapshots
  and the current tree.
- Severity: minor

### PH10 -- Flat gaps_open=23 across both firings is correct, not a miscount -- caveat noted,

- Lens: metrics-integrity-check
- Claim: gaps_open staying flat at 23 across both firings is expected/correct
  given G49 and G50 were each added-then-closed within the same commit
- Source: .mfact/metrics-history.jsonl (both lines) + GAP_LEDGER_v26.7.12.md
  G49/G50 entries
- Verdict: CONFIRMED
- Evidence: Checked the actual diffs: `git show eabe589 --
  GAP_LEDGER_v26.7.12.md | grep '^+.*Status'` shows exactly one added line,
  `+- Status: CLOSED` (no prior `+- Status: OPEN` line for G49 ever existed in
  git history). Same for `git show c636fd3 -- GAP_LEDGER_v26.7.12.md`: one
  added line, `+- Status: CLOSED`, for G50. Confirmed neither gap section
  existed at all in the parent commit (`git show 02e7a5e:GAP_LEDGER... | grep
  -c '### G49\|### G50'` = 0), and the OPEN count at that pre-G49 parent
  commit was already 23. Because the grep counts only lines literally reading
  `- Status: OPEN` at a given snapshot, and G49/G50 were each introduced
  directly with `Status: CLOSED` (never committed in an OPEN state), they were
  mathematically incapable of ever incrementing the OPEN count -- at creation
  or after. A gap opened-and-closed within the same commit is invisible to a
  point-in-time OPEN-status grep by construction, so flat-at-23 across both
  firings is exactly the correct behavior here, not evidence of miscounting or
  gaming. Caveat (not a defect): gaps_open as currently computed can never
  reflect newly-discovered-and-immediately-fixed items -- it only moves if a
  firing leaves a new gap OPEN, or resolves/reopens a pre-existing OPEN entry.
- Severity: minor

### PH11 -- c636fd3 wires the script into just and cross-references it in the loop doc,

- Lens: metrics-integrity-check
- Claim: c636fd3 wires scripts/stuck_item_guard.py into `just stuck-item-
  guard` and cross-references it in MFACT_SELF_IMPROVEMENT_LOOP.md
- Source: justfile:236-238, MFACT_SELF_IMPROVEMENT_LOOP.md:90-96
- Verdict: CONFIRMED
- Evidence: Live justfile has a `stuck-item-guard:` recipe at line 236 running
  `python3 scripts/stuck_item_guard.py --receipts .mfact/receipts/`. Live-
  executed `just stuck-item-guard` from the repo root succeeded: "4 receipt(s)
  considered (window=10, threshold=7). No gap_id exceeds the threshold...
  Nothing flagged." (4 matches the current receipt count on disk, one more
  than the 3 present when G50 was closed, since firing 4's own receipt was
  written afterward). MFACT_SELF_IMPROVEMENT_LOOP.md's "Stuck-item guard"
  section (line 83) now cross-references `just stuck-item-guard` at lines
  90-96.
- Severity: minor

### PH12 -- G50/G49 closure narratives both hold: real bug caught, real fix landed,

- Lens: metrics-integrity-check
- Claim: G50 closure text: re-verification caught a real positional-
  vs-`--receipts`-flag bug in the just recipe before commit; G49 closure text:
  simulate_workload was truly undefined and is now genuinely implemented
- Source: GAP_LEDGER_v26.7.12.md:1006-1014,
  scripts/stuck_item_guard.py:118-134, crates/mfact-core/src/bin/turbulence.rs
- Verdict: CONFIRMED
- Evidence: scripts/stuck_item_guard.py's argparse only defines `--receipts`
  (plus --window/--threshold/--json) with no positional argument at all --
  passing the path positionally would indeed raise argparse's "unrecognized
  arguments" error, exactly as claimed. The live justfile recipe correctly
  uses `--receipts .mfact/receipts/`. Independently reproduced G49's build fix
  too: crates/mfact-core is a standalone crate (not part of the root
  Cargo.toml's workspace -- root Cargo.toml has no [workspace] section), and
  running `cargo check --bin turbulence` from inside crates/mfact-core
  succeeds with exit 0, and `cargo run --bin turbulence` (12s) prints real
  benchmark table output rather than panicking, matching both receipt files'
  verify_delta text.
- Severity: minor

### PH13 -- GAP_LEDGER summary table (Minor 17, G34-G50) is internally consistent,

- Lens: general-status-and-next-firing-catch
- Claim: GAP_LEDGER_v26.7.12.md summary table (Minor 17, G34-G50) and G50
  entry are internally consistent with the rest of the ledger
- Source: GAP_LEDGER_v26.7.12.md:73-76, G50 section
- Verdict: CONFIRMED
- Evidence: grep -oE '^### G[0-9]+' returns exactly 50 headers (G1-G50),
  matching the table's 3+30+17=50. Status-line tally: 22 'OPEN' + 1 'OPEN
  (evidence partially unverified...)' = 23 open, exactly matching metrics-
  history.jsonl's new line `gaps_open: 23` for git_head c636fd3.
- Severity: minor

### PH14 -- G50 closure correctly cites prior audit findings PC6 and PD4 as its basis,

- Lens: general-status-and-next-firing-catch
- Claim: G50 closure cites PRAXIS_SELF_AUDIT.md findings PC6 (REFUTED, scope-
  creep question) and PD4 (CONFIRMED, still-unwired) as the basis for the gap
- Source: PRAXIS_SELF_AUDIT.md:1633-1650, 1751-1764
- Verdict: CONFIRMED
- Evidence: Both sections exist verbatim as described: PC6 refutes 'scope
  creep' but flags the real unwired-recipe gap; PD4 reconfirms the same gap is
  still open as of pass 4, citing identical grep-based evidence. G50's framing
  ('legitimately in scope, simply unwired') accurately reflects both.
- Severity: minor

### PH15 -- G50 receipt stores a short 7-char commit_sha, unlike G49's full 40-char sha,

- Lens: general-status-and-next-firing-catch
- Claim: G50 receipt (.mfact/receipts/20260713T165952Z.json) commit_sha uses
  the same format convention as prior receipts
- Source: .mfact/receipts/20260713T165952Z.json vs
  .mfact/receipts/20260713T163130Z.json (G49)
- Verdict: DRIFTED
- Evidence: G50's receipt stores commit_sha as a short 7-char abbreviation
  ('c636fd3'), while the immediately preceding G49 receipt stored the full
  40-char SHA ('eabe589af9a5868dcc2b33cc281490af94b16e41'). Minor internal
  schema inconsistency in the audit-trail receipts, not a functional bug --
  worth a future firing normalizing to full SHAs for reliable git lookups.
- Severity: minor

### PH16 -- 672fdeb addendum: AxiomAudit is lean_lib not lean_exe, reconfirmed directly,

- Lens: general-status-and-next-firing-catch
- Claim: 672fdeb's addendum: AxiomAudit.lean has no main/entry point and is
  correctly declared [[lean_lib]] not [[lean_exe]] in both mfact/ and procint/
  lakefiles, explaining why no binary appears at the expected path
- Source: MFACT_SELF_IMPROVEMENT_LOOP.md (672fdeb addition);
  mfact/lakefile.toml; procint/lakefile.toml
- Verdict: CONFIRMED
- Evidence: grep against both lakefile.toml files shows `[[lean_lib]]`
  immediately followed by `name = "AxiomAudit"` in both mfact/lakefile.toml
  and procint/lakefile.toml, with no corresponding `[[lean_exe]]` entry for
  AxiomAudit in either file. Claim verified directly this pass, not just
  inherited from pass 7's PG1/PG2 assertion.
- Severity: minor

### PH17 -- Collision-guard baseline (76 entries) still matches live git status exactly,

- Lens: general-status-and-next-firing-catch
- Claim: Collision-guard baseline .mfact/known-persistent-drift.txt (76
  entries) still matches the live git status --porcelain path set exactly
- Source: .mfact/known-persistent-drift.txt; live `git status --porcelain`
- Verdict: CONFIRMED
- Evidence: Beyond the requested 2-3 spot checks (5 entries individually
  verified: crates/mfact-core/src/broker.rs, research-
  papers/floquet_photonic/, release/standing.env, pylab/src/mpops/thermo.py,
  .mfact/artifacts.toml -- all present in git status with matching status
  codes), a full `comm -23`/`comm -13` diff between the sorted baseline file
  and the sorted git-status path list returned empty in both directions: zero
  entries in git status missing from the baseline, zero stale baseline entries
  no longer in git status.
- Severity: minor

### PH18 -- No drift this pass: porcelain count 76, HEAD held at 672fdeb throughout,

- Lens: general-status-and-next-firing-catch
- Claim: git status --porcelain count is 76 (matches baseline) and HEAD is
  672fdeb with no new fix-loop firing (~10:12 or 10:42) landing during this
  pass
- Source: live `git status --porcelain | wc -l` and `git log --oneline -5`,
  checked at pass start (10:09:53), mid-pass, and end (10:12:51)
- Verdict: CONFIRMED
- Evidence: All three checks across the pass returned status count 76 and HEAD
  672fdeb unchanged. A live background monitor watching `git rev-parse HEAD`
  for 3 minutes past the last manual check also did not observe a new commit
  before this report was filed. Only commits c636fd3 and 672fdeb (both already
  audited above) are new since pass 7's cd911f9.
- Severity: minor

## Pass 9 findings

### PI1 -- Cargo.toml [lints.clippy] block matches G51 closure text exactly,

- Lens: g51-closure-reverify
- Claim: `crates/mfact-core/Cargo.toml` has a `[lints.clippy]` block with
  `todo`/`unimplemented`/`dbg_macro` set to `"deny"` and
  `unwrap_used`/`expect_used` set to `"warn"`, matching G51's closure
  evidence verbatim.
- Source: crates/mfact-core/Cargo.toml lines 23-28
- Verdict: CONFIRMED
- Evidence: Live `grep`/`sed` of the file shows `[lints.clippy]` at line 23
  immediately followed by `todo = "deny"`, `unimplemented = "deny"`,
  `dbg_macro = "deny"`, `unwrap_used = "warn"`, `expect_used = "warn"` --
  an exact match to both the ledger's G51 closure text and this pass's own
  independent re-verification (not taken on the ledger's word alone).
- Severity: minor

### PI2 -- just clippy-core runs clean, exit 0, against --lib --bin turbulence,

- Lens: g51-closure-reverify
- Claim: `just clippy-core` runs successfully with exit 0, scoped to the
  crate's two real compiled targets (`--lib --bin turbulence`).
- Source: justfile `clippy-core` recipe; live command `just clippy-core`
- Verdict: CONFIRMED
- Evidence: Output: `cd crates/mfact-core && cargo clippy --lib --bin
  turbulence` -> `Finished \`dev\` profile [unoptimized + debuginfo]
  target(s) in 0.21s` (cached build, no clippy warnings/errors printed).
  Exit code 0.
- Severity: minor

### PI3 -- No dbg! remains in lib.rs; the claimed negative-control revert is intact,

- Lens: g51-closure-reverify
- Claim: The `dbg!("negative-control")` macro call injected during G51's
  negative-control test was reverted, and no `dbg!` occurrence remains in
  `crates/mfact-core/src/lib.rs`.
- Source: live `grep -n "dbg!" crates/mfact-core/src/lib.rs`
- Verdict: CONFIRMED
- Evidence: `grep -n "dbg!" crates/mfact-core/src/lib.rs` returns no matches
  (exit 1, empty output) -- combined with PI2's clean `just clippy-core`
  exit 0, this independently confirms the negative-control macro was fully
  reverted rather than merely hidden behind an allow.
- Severity: minor

### PI4 -- HEAD (5dc2f5c) is byte-identical to origin/v26.7.12-close; branch is pushed,

- Lens: general-status-and-next-firing-catch
- Claim: The local branch, currently at commit `5dc2f5c`, is pushed and in
  sync with `origin/v26.7.12-close` -- no local-only commits.
- Source: live `git rev-parse HEAD`, `git rev-parse origin/v26.7.12-close`,
  `git log origin/v26.7.12-close..HEAD`
- Verdict: CONFIRMED
- Evidence: `git rev-parse HEAD` and `git rev-parse origin/v26.7.12-close`
  both resolve to the identical 40-char SHA
  `5dc2f5c7326f89f95792ec53b42d4e7abde47faa` after a fresh `git fetch
  origin`. `git log origin/v26.7.12-close..HEAD --oneline` returns empty
  (exit 0, zero lines) -- no commit exists on HEAD that isn't already on
  the remote.
- Severity: minor

### PI5 -- ROADMAP_CLOUD_MATH.md's 5 theorem-card citations all resolve at their exact cited lines,

- Lens: general-status-and-next-firing-catch
- Claim: `ROADMAP_CLOUD_MATH.md`'s five theorem-card citations
  (`replay_eq_of_traceEq` `Swarm11/Replay.lean:105`, `replay_preserved`
  `Correspondence/AtomVM.lean:54`, `zero_unreceipted_completion`
  `MFW/Runtime.lean:62`, `enabled_frontier_isAntichain`
  `MFW/Order.lean:48`, `work_bounds` `Thermo.lean:30`) are all real and
  present at exactly the cited line.
- Source: ROADMAP_CLOUD_MATH.md lines 24-31, 48, 64, 78, 91, 104;
  procint/ProcInt/Playground/Swarm11/Replay.lean;
  procint/ProcInt/Playground/Swarm11/Correspondence/AtomVM.lean;
  procint/ProcInt/Playground/MFW/Runtime.lean;
  procint/ProcInt/Playground/MFW/Order.lean; procint/ProcInt/Thermo.lean
- Verdict: CONFIRMED
- Evidence: `sed -n '<line>p'` against each live file at exactly the cited
  line number returns: `theorem replay_eq_of_traceEq` (105),
  `theorem replay_preserved` (54), `theorem zero_unreceipted_completion (s
  : ExecutionState n) :` (62), `theorem enabled_frontier_isAntichain` (48),
  `theorem work_bounds {S G : State} (p : Process S G) :` (30) -- all 5
  match a genuine `theorem` declaration for the exact cited name at the
  exact cited line, in the crate's real (non-worktree,
  non-research-papers-namesake) source tree.
- Severity: minor

### PI6 -- No unexplained collision-guard baseline drift; the 76->71 delta is fully accounted for,

- Lens: general-status-and-next-firing-catch
- Claim: `git status --porcelain` (71 lines) shows no path absent from the
  76-entry `.mfact/known-persistent-drift.txt` baseline; the count drop is
  explained, not unexplained drift.
- Source: live `git status --porcelain`;
  .mfact/known-persistent-drift.txt; commit 5dc2f5c
- Verdict: CONFIRMED
- Evidence: `comm -23` of sorted live-status paths against the sorted
  baseline returns empty -- zero paths in git status are missing from the
  baseline (no new, unexplained drift). `comm -13` (the reverse direction)
  returns exactly 5 paths: `MFW_WORKFLOW_CATALOG.md`,
  `ROADMAP_GAP_AUTONOMIC.md`, `ROADMAP_GAP_SEMANTIC.md`,
  `ROADMAP_GAP_THERMO.md`, `ROADMAP.md` -- all 5 are precisely the files
  commit `5dc2f5c` ("docs: track MFW_WORKFLOW_CATALOG.md and the four
  ROADMAP gap docs") newly added to git, so they correctly dropped out of
  `git status --porcelain`'s untracked listing. Caveat (not a defect): the
  76-entry baseline file itself is now stale by these same 5 entries and
  should be refreshed in a future firing so the guard's own diff stays
  minimal.
- Severity: minor

## Pass 11 findings

### PK1 -- All 9 named construction-workflow target files/dirs exist and are non-empty,

- Lens: construction-workflow-progress
- Claim: The 4 in-scope waves' target files/dirs (Playground/Glue/,
  MFW/Termination/, Playground/Multifractal/UniformWitness.lean,
  MFW/Residue/Tenancy.lean, Playground/Swarm11/Correspondence/LedgerBridge.lean)
  all exist, non-empty, current.
- Source: live `ls -la` on each target path
- Verdict: CONFIRMED
- Evidence: Glue/RankOrder.lean (4031B, 10:55), Glue/RuntimeReplay.lean
  (5970B, 10:55); Termination/CrownWellFounded.lean (3777B, 10:59),
  ManufactureDecrease.lean (4020B, 10:57), MultisetDescent.lean (3000B,
  10:55), ObligationRank.lean (4825B, 10:55); UniformWitness.lean (9280B,
  10:59); Tenancy.lean (12185B, 11:05); LedgerBridge.lean (8723B, 10:56).
  All world-readable (0644), all mtimes within the pass window.
- Severity: minor

### PK2 -- No sorry/admit placeholder tactics in any of the 10 in-scope files,

- Lens: construction-workflow-progress
- Claim: None of the 9 target files, plus the actively-growing
  OrientedSwap.lean, contain an actual `sorry`/`admit` placeholder tactic.
- Source: live `grep -n 'sorry'` and `grep -n '\badmit\b'` on each file
- Verdict: CONFIRMED
- Evidence: All hits are prose inside doc comments asserting absence of
  `sorry` (e.g. CrownWellFounded.lean:38 "No `sorry`.", Tenancy.lean:47
  "No `sorry`.", OrientedSwap.lean:478 inside a closing-summary doc block)
  or unrelated English ("this file exists to admit."). No bare `sorry` or
  `admit` tactic keyword found. No build was attempted, so this confirms
  absence of admitted-gap placeholders in text only, not that files
  typecheck.
- Severity: minor

### PK3 -- Termination/'s two small files are complete def-only infra, not stubs,

- Lens: construction-workflow-progress
- Claim: ManufactureDecrease.lean and ObligationRank.lean contain zero
  theorem/lemma declarations (`def`-only) and are not truncated mid-write.
- Source: live `grep -cE '^\s*(theorem|lemma)\s'` and `tail -8` on each file
- Verdict: CONFIRMED
- Evidence: Both files return 0 theorem/lemma matches. Both end in a
  complete, well-formed `def` (`ManufactureStep`, `rank` resp.) followed by
  `end ProcInt.MFW.Termination`, not a dangling partial statement --
  finished infrastructure by design, not incomplete proofs.
- Severity: minor

### PK4 -- OrientedSwap.lean is the largest, most recent, self-scoped file,

- Lens: construction-workflow-progress
- Claim: Swarm11/OrientedSwap.lean (517 lines, 10 theorems) is the
  freshest and largest in-scope file, closing with a self-documented
  "Closing summary" that names what remains unproven rather than
  overclaiming.
- Source: live `wc -l`, `grep -cE` theorem count, `tail -60` on the file
- Verdict: CONFIRMED
- Evidence: `wc -l` = 517, theorem/lemma count = 10. File ends with a
  "## 7. Closing summary" doc block: "Proven, unconditionally,
  kernel-checked ... no sorry:" followed by "Not proven, and not falsely
  claimed:" naming `Relation.LocallyConfluent (OrientedSwap step
  priority)` unconditionally as the open item, then closes cleanly with
  `end Replay` / `end ProcInt.Playground.Swarm11`.
- Severity: minor

### PK5 -- Tenancy.lean includes a genuine negative-result countermodel,

- Lens: construction-workflow-progress
- Claim: Residue/Tenancy.lean (245 lines, 16 theorem/lemma declarations)
  includes a `TenancyCountermodel` section proving
  `tenant_purity_conclusion_fails`, demonstrating a hypothesis is
  load-bearing rather than decorative.
- Source: live `wc -l`, `grep -cE` theorem count, `tail -16` on the file
- Verdict: CONFIRMED
- Evidence: `wc -l` = 245, theorem/lemma count = 16. File ends with
  `theorem tenant_purity_conclusion_fails : ¬ (∀ a ∈ ({0} : Finset Obl),
  tag a = tag (1 : Obl))` proved by `intro/have/rw/exact
  Bool.false_ne_true`, followed by `end TenancyCountermodel` /
  `end ProcInt.MFW.Residue` -- a complete, closed module.
- Severity: minor

### PK6 -- git status count (79) reconciles exactly to baseline plus deltas,

- Lens: construction-workflow-progress
- Claim: Live `git status --porcelain` (79 lines) equals the 76-line
  `known-persistent-drift.txt` baseline minus 5 already-committed paths
  plus 8 new unexplained-but-attributable paths.
- Source: live `git status --porcelain | wc -l`;
  `.mfact/known-persistent-drift.txt`; `comm -23`/`comm -13`
- Verdict: CONFIRMED
- Evidence: Live count = 79 (76 - 5 + 8 = 79). `comm -23` (new, not in
  baseline) returns exactly 8 paths: `ontology/fortune5-cloud-architecture.ttl`,
  `PRAXIS_SELF_AUDIT.md`, `procint/ProcInt/MFW/Residue/Tenancy.lean`,
  `procint/ProcInt/MFW/Termination/`, `procint/ProcInt/Playground/Glue/`,
  `procint/ProcInt/Playground/Multifractal/UniformWitness.lean`,
  `procint/ProcInt/Playground/Swarm11/Correspondence/LedgerBridge.lean`,
  `procint/ProcInt/Playground/Swarm11/OrientedSwap.lean`. `comm -13`
  (stale baseline entries) returns the same 5 paths pass 9 flagged. The
  count fluctuates minute-to-minute as the construction workflow writes
  files; this is a single fresh snapshot, not a claim of stability.
- Severity: minor

### PK7 -- Firing 6's collision receipt correctly stopped, made no other change,

- Lens: fix-loop-firing6-continuity
- Claim: `.mfact/receipts/20260713T175700Z.json` (commit `d2e6d01`)
  correctly identified concurrent construction-workflow activity, took no
  action, and left history clean.
- Source: live `cat .mfact/receipts/20260713T175700Z.json`;
  `git log --all --oneline`, `git reflog`
- Verdict: CONFIRMED
- Evidence: Receipt has `"status": "failed"`, `"commit_sha": null`,
  `"collision": true`, `"duration_ms": 0`,
  `"after": "not attempted -- collision guard stopped the firing before
  any action"`. `git log -1` and repeated re-checks across the pass window
  (11:10-11:18 PDT) all show HEAD unchanged at `d2e6d01`; no foreign
  commits landed in between.
- Severity: minor

### PK8 -- Construction workflow still mid-flight; 1 new path since firing 6,

- Lens: fix-loop-firing6-continuity
- Claim: Task `wkw4npeny` has not committed anything yet and is still
  actively writing files; `OrientedSwap.lean` is a path that appeared
  after firing 6's receipt was written.
- Source: live `git status --porcelain` vs
  `.mfact/known-persistent-drift.txt` via `comm -23`; `ls -la` mtimes
- Verdict: CONFIRMED
- Evidence: `comm -23` returns 8 paths (PK6), one more than firing 6's
  receipt-listed 7: `procint/ProcInt/Playground/Swarm11/OrientedSwap.lean`.
  That file's mtime is 10:59 (its `.ttl`/companion writes) through 11:09,
  i.e. after firing 6's 10:57 receipt timestamp. `git log`/`git reflog`
  show zero new commits, confirming `wkw4npeny` remains uncommitted.
- Severity: minor

### PK9 -- Firing 6's blanket misattribution of PRAXIS_SELF_AUDIT.md's diff,

- Lens: fix-loop-firing6-continuity
- Claim: Firing 6's receipt and commit message state all 7 flagged new
  paths are "attributable to" the construction workflow (`wkw4npeny`).
  This is false for `PRAXIS_SELF_AUDIT.md`.
- Source: live `git diff --stat PRAXIS_SELF_AUDIT.md`; `git diff` content;
  `stat` mtime; receipt `.mfact/receipts/20260713T175700Z.json`
- Verdict: REFUTED
- Evidence: `git diff --stat` shows a single 149-line insertion; the diff
  content is entirely pass 9's own self-audit findings text ("pass 9",
  PI1-PI6, the pass-9 run-log paragraph). `stat` shows mtime `10:51:17`,
  before firing 6 ran (`10:57:00` per the receipt timestamp) -- a
  Lean-construction workflow whose other 6 flagged paths are all
  `.lean`/`.ttl` artifacts would not write this content. The guard's
  decision to stop was still correct (any unexplained diff should halt
  the firing), but its stated diagnosis misattributes this session's own
  uncommitted output.
- Severity: minor

### PK10 -- HEAD no longer byte-identical to origin/v26.7.12-close,

- Lens: fix-loop-firing6-continuity
- Claim: HEAD is pushed and in sync with `origin/v26.7.12-close`, per
  pass 9's PI4.
- Source: live `git fetch origin`, `git rev-parse HEAD`,
  `git rev-parse origin/v26.7.12-close`,
  `git log origin/v26.7.12-close..HEAD --oneline`
- Verdict: DRIFTED
- Evidence: `git rev-parse HEAD` = `d2e6d01b06d92feca14aec38f1fdab8335849714`;
  `git rev-parse origin/v26.7.12-close` still = `5dc2f5c7326f89f95792ec53b42d4e7abde47faa`.
  `git log origin/v26.7.12-close..HEAD --oneline` returns exactly 1 commit,
  `d2e6d01` (firing 6's own collision-receipt commit). Not a defect on its
  own, but pass 9's specific "byte-identical, pushed" claim no longer
  holds for current HEAD.
- Severity: minor

### PK11 -- known-persistent-drift.txt baseline still stale by same 5 entries,

- Lens: fix-loop-firing6-continuity
- Claim: The 76-entry baseline file is stale by the same 5
  already-committed entries pass 9 flagged, unaddressed across two more
  firings and two more passes.
- Source: live `comm -13` of sorted `git status --porcelain` paths against
  sorted `.mfact/known-persistent-drift.txt`
- Verdict: CONFIRMED
- Evidence: `comm -13` returns the identical 5 paths pass 9 reported
  (`MFW_WORKFLOW_CATALOG.md`, `ROADMAP_GAP_AUTONOMIC.md`,
  `ROADMAP_GAP_SEMANTIC.md`, `ROADMAP_GAP_THERMO.md`, `ROADMAP.md`) --
  all committed in `5dc2f5c` and no longer in `git status --porcelain`,
  but still listed in the baseline untouched since before pass 9. Harmless
  for the collision guard's `comm -23` direction, but a second consecutive
  pass confirming the suggested refresh has not happened.
- Severity: minor

### PK12 -- Pass 9's audit append still uncommitted, now spanning 3+ passes,

- Lens: fix-loop-firing6-continuity
- Claim: Pass 9's 149-line self-audit findings addition has sat
  uncommitted through firing 6 and into this pass, unlike passes 5-8
  which were each committed promptly.
- Source: live `git log --oneline -- PRAXIS_SELF_AUDIT.md`;
  `git diff --stat PRAXIS_SELF_AUDIT.md`; `stat` mtime
- Verdict: CONFIRMED
- Evidence: `git log --oneline -- PRAXIS_SELF_AUDIT.md` shows the most
  recent commit touching this file is `e0366b4` ("append pass 8"); pass
  9's findings were never committed (mtime `10:51`, no later commit
  touches the file). This directly caused PK9's misattribution and will
  recur at the next firing unless committed -- this pass's own append
  compounds the same uncommitted-file risk.
- Severity: minor

### PK13 -- ggen doctor run still refuses on identical lockfile/receipt drift,

- Lens: zip-and-ggen-findings-recheck
- Claim: `ggen doctor run` refuses due to post-release-pack/ggen.lock
  content-hash drift plus a stale `PostRelease.lean` receipt.
- Source: live command `ggen doctor run` executed at HEAD `d2e6d01`
- Verdict: CONFIRMED
- Evidence: Fresh run returns: "doctor found 2 failing check(s):
  lockfile_drift: ... pack `post-release-pack` ... content hash mismatch:
  ggen.lock has `blake3:7189211c...` but the pack on disk hashes to
  `blake3:e421e0e4...`. ...; receipt_staleness: 1 receipt output(s)
  missing or hash-mismatched on disk: procint/ProcInt/Release/PostRelease.lean".
  Matches the claimed refusal mode and root cause exactly.
- Severity: minor

### PK14 -- 0 sorry/axiom reconfirmed in the extracted f5-core zip package,

- Lens: zip-and-ggen-findings-recheck
- Claim: The extracted `procint-multifractal-workflow-f5-core` package has
  0 `sorry`/`axiom` occurrences.
- Source: live `grep -rn 'sorry\|axiom '` and a broader
  `grep -rniE 'sorry|axiom'` against the extracted `ProcInt/` directory in
  the scratchpad
- Verdict: CONFIRMED
- Evidence: The extracted directory still exists, 51 `.lean` files. Both
  the narrow and the case-insensitive broad grep return zero matches
  (exit 1, empty output), independently reconfirming the "0 sorry/0
  axiom" finding for this package.
- Severity: minor

## Pass 10 findings

Independent final-verification pass over the completed 8-wave construction workflow
(waves 0-7, commits `d2e6d01`..`ae5c2a5`, `5dc2f5c..ae5c2a5` in `git log` range notation).
Re-derived from a fresh rebuild and live `git`/`grep` inspection, not from the workflow's own
wave reports or the (separately-numbered) Pass 11 section above, which audited the same
workflow mid-flight before it finished committing.

### PJ1 -- All 10 new .lean files across waves 1-7 exist, rebuild clean, zero sorry/admit,

- Lens: fresh-rebuild-reverify
- Claim: `Glue/RankOrder.lean`, `Glue/RuntimeReplay.lean`, `Multifractal/UniformWitness.lean`,
  `Residue/Tenancy.lean`, `Swarm11/Correspondence/LedgerBridge.lean`, `MFW/Termination/
  {ObligationRank,ManufactureDecrease,MultisetDescent,CrownWellFounded}.lean`, and
  `Swarm11/OrientedSwap.lean` all exist, each rebuilds to exit 0 via `just _lake "cd procint
  && lake build <module>"`, and none contains an actual `sorry`/`admit` tactic use.
- Source: live `just _lake` build of all 10 modules individually; live
  `grep -rn '\bsorry\b\|\badmit\b'` across all 10 files
- Verdict: CONFIRMED
- Evidence: All 10 builds returned "Build completed successfully" (job counts: 587, 7, 8562,
  628, 8566, 628 combined for the 4 Termination files, 538) -- matching the individual wave
  commits' own claimed job counts exactly. `RuntimeReplay.lean` reproduces the two documented
  benign unused-variable warnings (`p` at :58, `h` at :96), not errors. The combined
  `sorry`/`admit` grep across all 10 files returns exactly 6 hits, every one inside a doc
  comment or closing-summary prose block ("no `sorry`/`admit`", "No `sorry`.", "this file
  exists to admit." -- English "admit" as "grant", not the tactic, confirmed by reading the
  surrounding sentence at `RuntimeReplay.lean:107-113`), zero bare tactic-position matches.
- Severity: minor

### PJ2 -- Full umbrella `ProcInt.Playground` build still succeeds fresh, 8709 jobs,

- Lens: fresh-rebuild-reverify
- Claim: `lake build ProcInt.Playground` exits 0 with all 7 new waves' modules transitively
  imported.
- Source: live `just _lake "cd procint && lake build Playground"`
- Verdict: CONFIRMED
- Evidence: `Build completed successfully (8709 jobs)` -- one job higher than wave7's own
  claimed 8708, consistent with ordinary build-graph/cache count drift between two runs
  minutes apart, not a defect (no error/warning lines, exit 0).
- Severity: minor

### PJ3 -- 5 theorems across 4 different waves independently `#print axioms`-checked clean,

- Lens: axiom-reverify
- Claim: `dag_rank_enabledFrontier_isAntichain` (wave1), `crossTenant_residue_disjoint`
  (wave4), `no_infinite_productive_mfw_chain` (wave6), `orientedSwap_terminating` and
  `not_orientedSwap_locallyConfluent` (wave7) all kernel-check within
  `[propext, Classical.choice, Quot.sound]`.
- Source: throwaway `procint/ProcInt/Playground/_ScratchAxiomCheck10.lean` (written, run via
  `lake env lean`, then deleted this pass -- not left in the tree)
- Verdict: CONFIRMED
- Evidence: literal output --
  `'ProcInt.Playground.Glue.RankOrder.dag_rank_enabledFrontier_isAntichain' does not depend on
  any axioms`; `'ProcInt.MFW.Residue.crossTenant_residue_disjoint' depends on axioms:
  [propext, Classical.choice, Quot.sound]`; `'ProcInt.MFW.Termination.
  no_infinite_productive_mfw_chain' depends on axioms: [propext, Classical.choice,
  Quot.sound]`; `'ProcInt.Playground.Swarm11.Replay.orientedSwap_terminating' depends on
  axioms: [propext, Quot.sound]`; `'ProcInt.Playground.Swarm11.Replay.
  not_orientedSwap_locallyConfluent' depends on axioms: [propext, Classical.choice,
  Quot.sound]`. All 5 are subsets of the allowed set; none depends on `sorryAx` or any
  workflow-introduced axiom.
- Severity: minor

### PJ4 -- Zero unexplained new drift; git status delta reconciles exactly to a 3rd-pass-stale baseline,

- Lens: collision-guard-delta-reverify
- Claim: live `git status --porcelain` (71 lines) contains no path absent from the 76-entry
  `.mfact/known-persistent-drift.txt` baseline, and the entire workflow's own output
  (ontology file, `Tenancy.lean`, `Termination/`, `Glue/`, `UniformWitness.lean`,
  `LedgerBridge.lean`, `OrientedSwap.lean`, `PRAXIS_SELF_AUDIT.md`) has been fully committed
  and no longer appears in the untracked/modified listing.
- Source: live `git status --porcelain` vs `.mfact/known-persistent-drift.txt`, `comm -23`/
  `comm -13`
- Verdict: CONFIRMED
- Evidence: `comm -23` (paths in live status but not baseline) returns empty -- zero
  unexplained new drift. `comm -13` (stale baseline entries) returns the identical 5 paths
  pass 9's PI6 and pass 11's PK11 already flagged (`MFW_WORKFLOW_CATALOG.md`,
  `ROADMAP_GAP_AUTONOMIC.md`, `ROADMAP_GAP_SEMANTIC.md`, `ROADMAP_GAP_THERMO.md`,
  `ROADMAP.md`, all committed in `5dc2f5c`) -- a 3rd consecutive pass confirming the
  baseline refresh still has not happened. 76 - 5 = 71 matches the live count exactly.
- Severity: minor

### PJ5 -- ROADMAP_CLOUD_MATH.md's wave0/CM2/CM3/CL1 additions hold up against the rebuilt code,

- Lens: roadmap-overclaim-check
- Claim: the document's new text for the ontology carrier note, Wave CM2 (tenancy), §3
  (multifractal gap), and CL1 (StepCorrespondence) states exactly what PJ1-PJ3 independently
  reconfirm, no more.
- Source: `git log -p 5dc2f5c..ae5c2a5 -- ROADMAP_CLOUD_MATH.md`; live file citations
  cross-checked against `Residue/Tenancy.lean:111`, `Multifractal/UniformWitness.lean`,
  `Swarm11/Correspondence/LedgerBridge.lean`
- Verdict: CONFIRMED
- Evidence: the ontology note is marked `CARRIER-ONLY` with an explicit "no correspondence
  morphism ... admitted" disclaimer, matching AGENTS.md §4 -- no theorem card's standing was
  raised by it. Wave CM2's "Tenancy isolation" table row is marked `PROVEN
  (residue-independence core)` with "boundary-cut composition MISSING" stated in the same
  cell, matching that only `minimalSupport_tenant_pure`/`crossTenant_residue_disjoint` were
  built and the boundary-cut composition genuinely was not attempted. §3's multifractal
  gap text says "deliberately the unweighted (monofractal) case, not yet a genuine
  multifractal" -- matches PJ1's confirmation that `UniformWitness.lean` computes `D_q = 1`
  (monofractal) and does not compute any non-degenerate `f(α)`. CL1's text says "narrowed,
  not closed" and explicitly denies licensing a "substrate correspondence to any concrete
  external runtime" -- matches `LedgerBridge.lean`'s own docstring, which bridges two Lean
  models (Crown, Ledger), not an external runtime.
- Severity: minor

### PJ6 -- ROADMAP_MATH_SPINE.md's Wave M1 status and Glue subsection hold up,

- Lens: roadmap-overclaim-check
- Claim: the Wave M1 status block and Claim Status Table row state `PROVEN` only for "the
  abstract `CrownState`/`ManufactureStep` carrier", explicitly note "no concrete workflow
  engine's transitions yet correspond to `ManufactureStep`", and the new Glue subsection
  marks both bridge files `PROVEN` with their axiom sets stated per-theorem.
- Source: `git log -p 5dc2f5c..ae5c2a5 -- ROADMAP_MATH_SPINE.md`; live
  `Residue/EntailmentOrder.lean:53`, `Playground/Swarm11/Replay.lean:105`
- Verdict: CONFIRMED
- Evidence: line-53 of `EntailmentOrder.lean` is exactly `class AdmittedObligationOrder
  (Obligation : Type*) extends Preorder Obligation`, matching the corrected citation (the
  pre-correction text had cited line 46). `Replay.lean:105` is exactly `theorem
  replay_eq_of_traceEq`, matching the Glue subsection's citation. The claim ceiling language
  ("does not yet discharge Crown II for any real MFW instantiation") is no stronger than
  what PJ3 independently reconfirms (the theorem is proven for the abstract carrier only).
- Severity: minor

### PJ7 -- MFW_WORKFLOW_CATALOG.md's S1.1 self-correction is independently reproducible by grep,

- Lens: roadmap-overclaim-check
- Claim: the corrected §1.1 bullet states `procint/ProcInt/MFW/Termination/*.lean` "neither
  imports nor references `Residue.residue`, `residue_isAntichain`, or `residue_purity`".
- Source: live `grep -rn "Residue\.residue\|residue_isAntichain\|residue_purity"
  procint/ProcInt/MFW/Termination/*.lean`
- Verdict: CONFIRMED
- Evidence: the only 2 hits are inside `ObligationRank.lean`'s own doc comment explaining the
  correction itself ("are *not* imported"); zero hits are an actual `import` line or a live
  reference to those three names. The correction is accurate, not merely asserted.
- Severity: minor

### PJ8 -- ROADMAP_SWARM_SUPPLY_CHAIN.md's P22 correction is precisely scoped, not oversold,

- Lens: roadmap-overclaim-check
- Claim: the P22 correction states `orientedSwap_terminating` and
  `orientedSwap_disjoint_confluent` `PROVEN` unconditionally, `not_orientedSwap_
  locallyConfluent` `REFUTED` unconditionally, `orientedSwap_overlap_confluent_of_commute13`
  proven as a named conditional repair, and `Confluent`/replay-equality explicitly "not
  proven -- correctly not attempted"; net verdict `PARTIAL, not closed`.
- Source: `git log -p 5dc2f5c..ae5c2a5 -- ROADMAP_SWARM_SUPPLY_CHAIN.md`; live
  `OrientedSwap.lean` declaration list (PJ1)
- Verdict: CONFIRMED
- Evidence: all 4 named theorems are present in the live file as PJ1's build confirms; a
  `grep` for `Confluent (OrientedSwap` (the unconditional close this entry says was
  correctly not attempted) returns no `theorem`/`lemma` declaration of that shape in the
  file -- the absence is real, not a hidden `sorry`. `PJ3` independently confirmed
  `orientedSwap_terminating` and `not_orientedSwap_locallyConfluent` are both axiom-clean.
  `PARTIAL, not closed` is the accurate summary of a genuine refutation plus a conditional
  repair, matching AGENTS.md §2's "never attach marketing scale to unbenchmarked code" spirit
  by not calling this a close.
- Severity: minor

### PJ9 -- MFACT_SELF_IMPROVEMENT_LOOP.md's firing-6/firing-7 collision entries match their receipts exactly,

- Lens: loop-honesty-reverify
- Claim: both new log entries describe a collision, no action taken, and match the literal
  content of `.mfact/receipts/20260713T175700Z.json` and `.mfact/receipts/20260713T182657Z.json`.
- Source: live `cat` of both receipt files; `MFACT_SELF_IMPROVEMENT_LOOP.md` diff (`git log -p`)
- Verdict: CONFIRMED
- Evidence: both receipts have `"status": "failed"`, `"commit_sha": null`, `"collision":
  true`, `"duration_ms": 0` -- no state-changing action was taken by either firing, matching
  the log's own "no action taken" language. Firing 7's receipt's `verify_delta.before` text
  names the exact same 7 remaining paths and the exact same 5 already-landed wave commit
  hashes (`69df262`, `250fcc7`, `d6fc2a3`, `782bf6c`, `6270a44`) the log entry quotes.
- Severity: minor

### PJ10 -- Wave 4's commit message undercounts Tenancy.lean's declarations (10 claimed, 16 actual),

- Lens: commit-message-accuracy-reverify
- Claim: commit `782bf6c`'s message states "Scratch `#print axioms` on all 10 declarations (2
  core theorems + 8 countermodel lemmas)" for `Residue/Tenancy.lean`.
- Source: live `grep -cE '^\s*(theorem|lemma)\s' procint/ProcInt/MFW/Residue/Tenancy.lean`
  and `grep -n` listing every match
- Verdict: REFUTED (as a count; the underlying math is unaffected)
- Evidence: the file has exactly 16 `theorem`/`lemma` declarations, not 10 -- 2 in the
  `TenancyCore` section (`minimalSupport_tenant_pure`, `crossTenant_residue_disjoint`,
  matching the "2 core theorems" half) plus 14 in `TenancyCountermodel`
  (`tag_zero`, `tag_one`, `f_apply_pos`, `f_apply_neg`, `f_monotone`, `f_extensive`,
  `f_idempotent`, `C_apply`, `C_zero`, `C_empty`, `not_separated`, `singleton_mem_residue`,
  `empty_context_tenant_pure`, `tenant_purity_conclusion_fails`), not 8. This is a
  documentation-accuracy defect in the commit message only, not in the ledger docs (neither
  `ROADMAP_CLOUD_MATH.md` nor this file's own PJ5 above repeats the "10" figure) and not in
  the math: PJ1 and PJ3 independently confirm the file builds clean and its two core
  theorems are axiom-clean regardless of how many countermodel lemmas were tallied. Whether
  the commit's own `#print axioms` scratch check actually covered all 16 (vs. only 10) could
  not be re-derived after the fact -- the scratch file was deleted per the wave's own
  discipline -- so this pass independently re-checked only the 2 core theorems (PJ3), not
  the 14 countermodel lemmas.
- Severity: minor

## Pass 12 findings

### PL1 -- Task's ~11:42 PDT next-firing estimate drifted from the loop's real ~30min cadence,

- Lens: fix-loop-postconstruction-firing
- Claim: this pass's task framing estimated fix loop `f6a6cd52`'s next firing at ~11:42 PDT.
- Source: `python3`-parsed `run_id` timestamps from all 7 receipt files in
  `.mfact/receipts/`, converted to PDT: firings 3-7 at 09:31:30, 09:59:52, 10:30:45,
  10:57:00, 11:26:57.
- Verdict: DRIFTED
- Evidence: consecutive real-firing gaps are 28, 31, 27, 30 minutes -- consistently ~30
  min, not tied to firing-6/7's collision timing. Extrapolating from the last firing
  (11:26:57 PDT) puts the next firing around 11:54-11:58 PDT, roughly 12-16 minutes later
  than the ~11:42 PDT figure this pass's task framing supplied. Not a repo defect, just a
  timing estimate corrected here for the next pass's polling.
- Severity: minor

### PL2 -- Whether the post-collision firing already landed was not yet confirmable,

- Lens: fix-loop-postconstruction-firing
- Claim: fix loop `f6a6cd52`'s next firing after the firing-7 collision (task-estimated
  ~11:42 PDT) had already run and picked a real item.
- Source: `ls -la /Users/sac/mfact/.mfact/receipts/` (`latest.json` mtime/content) plus
  `git log -15` on the live tree, checked at 11:43 PDT.
- Verdict: UNVERIFIABLE
- Evidence: as of 11:43 PDT, `latest.json` still pointed at `20260713T182657Z` (firing 7,
  11:26:57 PDT, `collision: true`) -- no newer receipt existed yet, and HEAD was still
  `98263a9` with no new commits. The observed cadence across all 7 receipts today
  (27-31 minutes apart) puts a firing from 18:26:57Z closer to ~18:53-18:57Z
  (11:53-11:57 PDT) than the ~11:42 PDT this pass's setup estimated. Not confirmable
  either way at this single check time; PL3 below extends the watch further.
- Severity: minor

### PL3 -- Confirmed over a ~9-minute poll: the next firing genuinely had not landed,

- Lens: fix-loop-postconstruction-firing
- Claim: fix loop `f6a6cd52`'s next firing had not landed by the end of this pass's
  active checking window (extends PL2's single 11:43 PDT snapshot with a sustained watch).
- Source: `git -C /Users/sac/mfact log --oneline -5` checked at 11:42:51, 11:43:56,
  11:44:32, and 11:45:39 PDT, plus `ls -la .mfact/receipts/*.json` and a ~9-minute
  background poll loop (task `bjopyb0kw`) watching for new receipt files.
- Verdict: CONFIRMED
- Evidence: HEAD stayed at `98263a9` throughout; the receipts dir stayed at 7 files with
  `latest.json` still pointing at `20260713T182657Z.json` (mtime 11:27 PDT, i.e. firing
  7). No new file appeared in any of the checks. Reporting plainly per the lens
  instructions -- nothing new to audit yet this pass.
- Severity: minor

### PL4 -- Both firing-6 and firing-7 collisions are genuine, receipt-backed stops,

- Lens: fix-loop-postconstruction-firing
- Claim: fix loop (cron `f6a6cd52`) collided twice against the construction workflow's
  in-progress files, at firings 6 and 7.
- Source: `ls -t /Users/sac/mfact/.mfact/receipts/*.json` plus per-file JSON contents
  (`run_id`, `status`, `collision` fields), cross-checked against `git show --stat` on
  both collision commits.
- Verdict: CONFIRMED
- Evidence: receipt `20260713T175700Z.json` (firing 6, commit `d2e6d01` "record firing-6
  collision receipt", 10:58 PDT) and receipt `20260713T182657Z.json` (firing 7, commit
  `aa203ec` "record firing-7 collision receipt", 11:27 PDT) both show `status: failed`,
  `collision: true`, `gap_id: null`. Firing 7's `verify_delta.before` explicitly names
  Waves 6/7 (`Termination/*.lean`, `OrientedSwap.lean`, `ROADMAP_MATH_SPINE.md`) as the
  still-mid-integration cause, matching prior passes' description exactly. (This pass's
  own initial draft mis-cited `20260713T165952Z.json` for firing 6 -- that file is
  actually the G50 success receipt; caught and fixed here, see PL13 below.)
- Severity: minor

### PL5 -- Firing 7's receipt content is accurate down to the byte, not just its status,

- Lens: fix-loop-postconstruction-firing
- Claim: firing 7's collision receipt (commit `aa203ec`) is a genuine collision-guard
  stop, not a real fix, and its attribution is accurate.
- Source: `git show --stat aa203ec`; `git log -1 --format=%B aa203ec`; `python3`-parsed
  `.mfact/receipts/20260713T182657Z.json`.
- Verdict: CONFIRMED
- Evidence: the commit touches only `.mfact/receipts/20260713T182657Z.json` (16 lines),
  `.mfact/receipts/latest.json` (6 lines), and `MFACT_SELF_IMPROVEMENT_LOOP.md` (14
  lines) -- no fix files. The receipt has `status: failed`, `collision: true`,
  `commit_sha: null`, `oracle_rank: 1`, and its `verify_delta.before` cites `git log`
  precisely for Waves 1-5 (`69df262`, `250fcc7`, `d6fc2a3`, `782bf6c`, `6270a44`) versus
  the still-pending Wave 6/7 paths, and explicitly states it is correcting pass 11's PK9
  imprecision from firing 6 -- matching pass 10/11's account exactly.
- Severity: minor

### PL6 -- known-persistent-drift.txt is stale again by the same 5 already-closed paths,

- Lens: baseline-and-drift-check
- Claim: `known-persistent-drift.txt` still lists 5 now-committed paths
  (`MFW_WORKFLOW_CATALOG.md` and the four `ROADMAP_GAP*`/`ROADMAP.md` files) as
  expected drift, even though they no longer show as modified/untracked.
- Source: `cat /Users/sac/mfact/.mfact/known-persistent-drift.txt`, cross-referenced
  against PL7's clean `git status` for the same 5 paths.
- Verdict: CONFIRMED
- Evidence: the baseline file (mtime Jul 13 08:46, predating the 10:32:39 and 11:26:55
  commits) still contains `MFW_WORKFLOW_CATALOG.md`, `ROADMAP.md`,
  `ROADMAP_GAP_AUTONOMIC.md`, `ROADMAP_GAP_SEMANTIC.md`, `ROADMAP_GAP_THERMO.md` at
  lines 15, 70-73. Since these paths are confirmed clean/committed, they no longer need
  the tolerated-drift allowlist. This is the same staleness pass 11's PK11 already
  named, recurring; flagged only as a refresh candidate, not refreshed by this
  read-only pass.
- Severity: minor

### PL7 -- The 5 baseline-stale paths flagged in passes 9/11 are now clean and tracked,

- Lens: baseline-and-drift-check
- Claim: the 5 baseline entries flagged stale in passes 9/11
  (`MFW_WORKFLOW_CATALOG.md`, `ROADMAP_GAP_AUTONOMIC.md`, `ROADMAP_GAP_SEMANTIC.md`,
  `ROADMAP_GAP_THERMO.md`, `ROADMAP.md`) are now all committed/clean, confirming pass
  10's PJ4 resolution.
- Source: `git status --porcelain -- <5 files>` (empty), `git ls-files -- <5 files>`
  (all 5 returned), `git log -1 -- <each file>`.
- Verdict: CONFIRMED
- Evidence: `git status --porcelain` for all 5 paths returns nothing. `git ls-files`
  confirms all 5 are tracked. `ROADMAP.md`/`ROADMAP_GAP_AUTONOMIC.md`/
  `ROADMAP_GAP_SEMANTIC.md`/`ROADMAP_GAP_THERMO.md` all landed in `5dc2f5c` (10:32:39
  PDT); `MFW_WORKFLOW_CATALOG.md` was further updated in `d4ed2f3` (11:26:55 PDT,
  wave6/M1 commit) and remains clean.
- Severity: minor

### PL8 -- Working tree now matches the drift baseline exactly; Waves 6/7 fully landed,

- Lens: baseline-and-drift-check
- Claim: the working tree matches `known-persistent-drift.txt` exactly (Waves 6/7 fully
  landed, no residual drift), so the fix loop's next firing should be able to pick a
  real item.
- Source: fresh `git status --porcelain` diffed against
  `.mfact/known-persistent-drift.txt` via `comm -23` (re-run twice this pass).
- Verdict: CONFIRMED
- Evidence: `comm -23` between the sorted current dirty/untracked paths and the sorted
  baseline returned zero lines both times -- every dirty/untracked path is already
  tolerated. The 7 paths that triggered firing 7's collision (`Termination/*.lean` x4,
  `Playground.lean` edit, `OrientedSwap.lean`, `ROADMAP_MATH_SPINE.md`) are gone from
  `git status` because they are now committed as `d4ed2f3` and `ae5c2a5`. This is fresh
  evidence gathered this pass, not a restatement of pass 10/11.
- Severity: minor

### PL9 -- No new unexplained drift since the 10-agent construction workflow finished,

- Lens: baseline-and-drift-check
- Claim: no new unexplained drift has appeared since the 10-agent construction workflow
  finished.
- Source: `git -C /Users/sac/mfact status --porcelain | sed -E 's/^.{3}//' | sort |
  comm -23 - .mfact/known-persistent-drift.txt`.
- Verdict: CONFIRMED
- Evidence: `comm -23` (paths in current status but not in baseline) returned 0 lines.
  Live porcelain count was 71 lines at re-check time (7 modified tracked files + ~64
  untracked paths, e.g. `crates/mfact-core/src/{broker,lean,main,thermo,transport}.rs`,
  `research-papers/*`, `procint/artifacts/`, `procint/ProcInt/Graph/`); every one
  matches an entry already present in `.mfact/known-persistent-drift.txt`. Note: this
  differs from the "65 lines" figure in this pass's task framing -- the untracked-file
  count fluctuates slightly while the construction workflow's scratch/build artifacts
  are mid-flight, but the substantive conclusion (zero unexplained lines) reproduces
  identically regardless of exact count.
- Severity: minor

### PL10 -- No sorry/admit tactics in Wave 6/7's new files, but only a grep-level check,

- Lens: fix-loop-postconstruction-firing
- Claim: Wave 6/7's new Lean files contain no `sorry`/`admit`-tactic shortcuts, a proxy
  re-check of the construction workflow's build/no-sorry claim.
- Source: `grep -no 'admit[a-zA-Z]*|sorry'` across
  `procint/ProcInt/MFW/Termination/{CrownWellFounded,ManufactureDecrease,
  MultisetDescent,ObligationRank}.lean` and
  `procint/ProcInt/Playground/Swarm11/OrientedSwap.lean`; attempted `which lake lean`
  in `procint/`.
- Verdict: CONFIRMED
- Evidence: the only match was the substring "admitted" inside comment prose
  referencing `AdmittedObligationOrder` (not an admit/sorry tactic). No `lake`/`lean`
  toolchain exists in this environment (`lake` not found, `lean` not found), so full
  compilation could not be independently re-run here -- this is a rank-3 (grep-only)
  proxy check, weaker than a rank-1 build re-run prior passes may have used for other
  waves.
- Severity: minor

### PL11 -- Ledger same-commit discipline holds for the last two real fix-loop firings,

- Lens: fix-loop-postconstruction-firing
- Claim: ledger same-commit discipline holds for the last two real (non-collision)
  fix-loop firings, G51 and G50.
- Source: `git show --stat 0639081` and `c636fd3` (the fix commits for G51 and G50);
  `grep -n "G50\|G51" GAP_LEDGER_v26.7.12.md`; `python3`-parsed
  `20260713T173045Z.json` (`gap_id: G51`) and `20260713T165952Z.json` (`gap_id: G50`).
- Verdict: CONFIRMED
- Evidence: `0639081` ("feat(mfact-core): add [lints] clippy gate ... closing G51")
  touches `GAP_LEDGER_v26.7.12.md` + `Cargo.toml` + `justfile` together, body stating
  "GAP_LEDGER_v26.7.12.md: G51 added CLOSED in this same commit." `c636fd3` similarly
  wires `stuck_item_guard.py` and closes G50 in one commit, body describing a genuine
  bug caught and fixed before commit (`--receipts DIR` argparse mismatch). Both G50 and
  G51 are present in `GAP_LEDGER_v26.7.12.md` (lines 997, 1016) with closure text
  matching the commit bodies. The separate "chore(loop): record firing-N success
  receipt" commits are receipt/metrics bookkeeping only -- a distinct, expected
  artifact per the loop's own two-commit-per-firing design, not a ledger-discipline gap.
- Severity: minor

### PL12 -- HEAD is unchanged at 98263a9, consistent with the pass-10/11 handoff state,

- Lens: baseline-and-drift-check
- Claim: HEAD is unchanged at `98263a9` as this pass begins, consistent with the
  pass-11/pass-10 handoff state.
- Source: `git -C /Users/sac/mfact rev-parse HEAD`; `git log -1 --format='%h %ci %s'`.
- Verdict: CONFIRMED
- Evidence: `git rev-parse HEAD` returns
  `98263a93a84293e1225edc656d9c96c6f7c3ec63`; `git log -1` shows "98263a9 2026-07-13
  11:37:40 -0700 docs(audit): append pass 10 -- final independent verification of
  waves 0-7", matching the stated starting point exactly.
- Severity: minor

### PL13 -- This pass's own draft misattributed firing 6's collision receipt filename,

- Lens: fix-loop-postconstruction-firing
- Claim: this pass's task-supplied finding text cited `20260713T165952Z.json` as
  firing 6's collision receipt (paired with commit `d2e6d01`).
- Source: `git show --stat d2e6d01` (lists the files it actually touches) and
  `python3`-parsed JSON contents of `20260713T165952Z.json` vs `20260713T175700Z.json`.
- Verdict: REFUTED (as drafted; corrected in-line before commit, see PL4)
- Evidence: `git show --stat d2e6d01` touches only `.mfact/receipts/20260713T175700Z.json`,
  `.mfact/receipts/latest.json`, and `MFACT_SELF_IMPROVEMENT_LOOP.md` -- never
  `20260713T165952Z.json`. The latter independently parses as `status: success`,
  `collision: false`, `gap_id: G50`, `commit_sha: c636fd3` -- it is firing 4's G50
  closure receipt, not a collision receipt at all. The correct firing-6 collision file
  is `20260713T175700Z.json` (`status: failed`, `collision: true`, `gap_id: null`),
  used in PL4 above. Caught and fixed before this section was written to the ledger, in
  the same spirit as pass 10's PJ10 and pass 11's PK9 catches of prior passes' own
  citation errors -- this time the citation being corrected belongs to this pass's own
  pre-commit draft, not a prior published pass.
- Severity: minor

## Pass 13 findings

### PM1 -- Firings 6/7/8 colliding is three distinct legitimate causes, not a malfunction,

- Lens: fix-loop-health-check
- Claim: fix loop `f6a6cd52` colliding three times in a row at firings 6, 7, 8 reflects a
  loop malfunction or a design flaw in the collision guard, rather than expected behavior.
- Source: fresh `git log --format='%h %ad %s' --date=iso-local d2e6d01..ec9001e`, plus
  `python3`-parsed contents of `.mfact/receipts/{20260713T175700Z,20260713T182657Z,
  20260713T185704Z}.json` (the three collision receipts themselves), all re-read this pass.
- Verdict: REFUTED
- Evidence: firing 6's receipt (`17:57:00Z` = 10:57 PDT) names 7 uncommitted paths from
  10-agent workflow `wkw4npeny`, "still mid-flight (has not committed anything yet)".
  Firing 7's receipt (`18:26:57Z` = 11:26:57 PDT) re-checks and precisely attributes the
  remaining 7 paths to that same workflow's Wave 6/Wave 7, explicitly correcting a prior
  pass's overgeneralized attribution. Firing 8's receipt (`18:57:04Z` = 11:57:04 PDT) names
  a single, unrelated path, `ROADMAP_SOC2_MATH.md`, from task `w3uu76xt9`, checked after
  `wkw4npeny` had fully landed (`ae5c2a5`, 11:28:40 PDT). Three collisions, three distinct,
  correctly self-diagnosed concurrent-work causes -- not the same blocker repeating; this
  is the guard behaving exactly as designed.
- Severity: major

### PM2 -- known-persistent-drift.txt is stale but causes zero live drift-detection error,

- Lens: fix-loop-health-check
- Claim: `.mfact/known-persistent-drift.txt` is stale and needs regenerating because 5
  listed files (`MFW_WORKFLOW_CATALOG.md`, `ROADMAP.md`, `ROADMAP_GAP_AUTONOMIC.md`,
  `ROADMAP_GAP_SEMANTIC.md`, `ROADMAP_GAP_THERMO.md`) have since been committed.
- Source: fresh `git status --porcelain -- <5 files>` (all empty) and `comm -23` between a
  freshly sorted live `git status --porcelain` and the sorted baseline file, run now.
- Verdict: REFUTED
- Evidence: `comm -23` of the live git-status paths against the baseline is currently empty
  -- every dirty/untracked path right now already appears in the baseline. The 5
  now-committed files simply no longer appear in `git status` at all, so their stale
  baseline entries cause no false positive or negative in the delta check right now; no
  regeneration is required for correctness this instant, even though the entries are
  literally outdated bookkeeping (confirmed present at baseline lines 15, 70-73).
- Severity: minor

### PM3 -- Firing 9 had not landed as of this pass's check window,

- Lens: fix-loop-health-check
- Claim: firing 9 of cron `f6a6cd52` has landed and should be audited this pass.
- Source: `ls -la .mfact/receipts/`, `cat .mfact/receipts/latest.json`, `git log --oneline
  -10`, `date`, `CronList`, all re-run at 12:14:41 PDT.
- Verdict: REFUTED
- Evidence: `latest.json` still points at `run_id: "20260713T185704Z"` (firing 8, 11:57:04
  PDT); no receipt file with a later timestamp exists; HEAD is unchanged at `852d343`. Cron
  `f6a6cd52`'s live schedule is `12,42 * * * *`, so firing 9 is due right around this
  pass's own 12:12-12:15 PDT check window but had not fired as of 12:14:41 PDT.
- Severity: minor

### PM4 -- Firing 7's "Wave 6 still mid-integration" framing is off by about 2 seconds,

- Lens: fix-loop-health-check
- Claim: firing 7's collision was caused by Wave 6 (`Termination/*.lean`, commit `d4ed2f3`)
  and Wave 7 files still being uncommitted at check time.
- Source: `git log --format='%h %ad %s' --date=iso-local -1 d4ed2f3` compared against
  firing 7's receipt `timestamp` field (`.mfact/receipts/20260713T182657Z.json`).
- Verdict: DRIFTED
- Evidence: `d4ed2f3` (wave6/M1, Dershowitz-Manna crown descent) has commit timestamp
  `11:26:55 -0700`, two seconds before firing 7's `18:26:57Z` (11:26:57 PDT) check. The
  receipt's own text is already precise on this point -- it names the still-open paths as
  the 4 `Termination/*.lean` files, `Playground.lean`, `OrientedSwap.lean`, and
  `ROADMAP_MATH_SPINE.md`, not `d4ed2f3`'s own commit content -- so the shorthand is close
  enough at 2-second granularity to be substantively correct, but should not be read as
  meaning `d4ed2f3` itself was uncommitted at that instant; it landed fractionally earlier.
- Severity: minor

### PM5 -- Firing 9 is predicted, not yet confirmed, to pass the collision guard cleanly,

- Lens: fix-loop-health-check
- Claim: given the live tree's delta against the baseline is currently empty, firing 9
  should pass the collision guard and pick a real gap, unlike firings 6/7/8.
- Source: same `comm -23` re-check as PM2, plus `MFACT_SELF_IMPROVEMENT_LOOP.md`'s stated
  v3 guard logic (only paths outside the baseline count as a collision).
- Verdict: UNVERIFIABLE
- Evidence: the live delta is empty right now (12:14:41 PDT), which predicts a
  non-collision outcome per the guard's documented logic -- but firing 9 had not executed
  as of this pass, and the prediction is contingent on no new uncommitted work landing in
  the intervening minutes. Cannot be confirmed until firing 9's own receipt appears;
  deferred to the next pass.
- Severity: minor

### PM6 -- 852d343's "scope-corrected" claim is substantively present in the file body,

- Lens: soc2-scope-correction-audit
- Claim: `852d343`'s commit message claims `ROADMAP_SOC2_MATH.md` was scope-corrected per
  two post-dispatch user clarifications; this is checked against the file body directly,
  not trusted from the commit message alone.
- Source: `grep -n` for scope-boundary language directly in the committed file content
  (`ROADMAP_SOC2_MATH.md` lines 20, 29, 209, 221, 224), independent of `git log`.
- Verdict: CONFIRMED
- Evidence: the scope-boundary framing is verbatim in the file's own prose, not just
  asserted in the commit message: L20 "Scope boundary, stated once here..."; L29 "...is
  the consumer's responsibility to get right, not a roadmap item for mfact"; L209
  "...whether a consumer didn't is the consumer's job, not mfact's"; L221 "This is not a
  gap mfact's proofs need to close, and mfact does not build FFI shims"; L224 "(Lake, Lean
  4, the TTL ontology, ggen) is validated once by an auditor". A real artifact property,
  not prose dressing on top of an unchanged file.
- Severity: minor

### PM7 -- Scope-boundary paragraph is internally consistent with all 4 theorem cards,

- Lens: soc2-scope-correction-audit
- Claim: the "Scope boundary" paragraph (L20-31) is internally consistent with section 2's
  four theorem cards and section 3(c): no remaining sentence implies mfact itself should
  build a correspondence carrier, wire an FFI shim, or "close the gap".
- Source: `sed -n` reads of `ROADMAP_SOC2_MATH.md` L20-31, L99-102, L122-131, L151-156,
  L174-180, L205-233, re-run fresh this pass, not reused from a prior pass's read.
- Verdict: CONFIRMED
- Evidence: L26-31 states building carriers/wiring runtimes/auditing routing is "the
  consumer's responsibility... not a roadmap item for mfact", and every "correspondence
  map (undischarged)" note describes what a *consumer* would need to build, not an
  imperative directed at mfact (re-confirmed for Card 1 L99-102 and Card 2's PI1.1-PI1.5
  text at L122-131). L205-207 states plainly "This document does not close that gap; it
  inherits it." L221-223 disclaims: "mfact does not build FFI shims, wire runtimes to
  invariant-carrying types, or continuously re-verify...". No contradicting sentence found.
- Severity: minor

### PM8 -- CC8 is correctly labeled Change Management, distinct from Processing Integrity,

- Lens: soc2-scope-correction-audit
- Claim: CC8 is described as Change Management (not Processing Integrity) in the
  correspondence table.
- Source: `sed -n '55,65p' ROADMAP_SOC2_MATH.md`, re-read fresh this pass.
- Verdict: CONFIRMED
- Evidence: line 59 reads "| CC8 -- Change Management | none | -- | MISSING |", matching
  the AICPA 2017 TSC Common Criteria structure where CC8 is Change Management, distinct
  from the separate Processing Integrity (PI) category on line 62 of the same table.
- Severity: minor

### PM9 -- PI1.1-PI1.5 wording is accurately described as ordinary business-data controls,

- Lens: soc2-scope-correction-audit
- Claim: PI1.1-PI1.5 is described as being about business-data completeness/accuracy/
  authorization/timeliness, not receipts or audit trails.
- Source: `sed -n '118,132p' ROADMAP_SOC2_MATH.md`, re-read fresh this pass.
- Verdict: CONFIRMED
- Evidence: lines 122-131 state the wording is about "completeness, accuracy,
  authorization, and timeliness of ordinary business data processing... PI is explicitly
  not about receipts, cryptographic logging, or audit trails in the sense this theorem
  uses receipt." This matches the actual AICPA PI1.1-PI1.5 sub-criteria structure
  (objectives, input, processing, output, storage controls).
- Severity: minor

### PM10 -- All 4 theorem-card citations resolve to the exact stated Lean line numbers,

- Lens: soc2-scope-correction-audit
- Claim: all four theorem-card citations resolve to the exact stated line numbers in the
  live Lean files at HEAD `852d343`.
- Source: fresh `grep -n` against `procint/ProcInt/MFW/Residue/Tenancy.lean`,
  `procint/ProcInt/Playground/MFW/Runtime.lean`,
  `procint/ProcInt/Playground/Swarm11/Replay.lean`,
  `procint/ProcInt/MFW/Residue/Antichain.lean`,
  `procint/ProcInt/MFW/Residue/MinimalSupport.lean`, run this pass, not reused output.
- Verdict: CONFIRMED
- Evidence: `Tenancy.lean:72` = `def Separated`, `:86` = `theorem
  minimalSupport_tenant_pure`, `:111` = `theorem crossTenant_residue_disjoint`.
  `Runtime.lean:52-56` = `structure ExecutionState` with `completionReceipted` on `:56`,
  `:62` = `theorem zero_unreceipted_completion`. `Swarm11/Replay.lean:27` = `def replay`,
  `:105` = `theorem replay_eq_of_traceEq`. `Antichain.lean:75` = `theorem
  residue_isAntichain`, `:113` = `theorem residue_purity`. `MinimalSupport.lean:97` =
  `theorem eq_of_subset_of_sufficient_of_isMinimalSupport`. No line has shifted.
- Severity: minor

### PM11 -- Markdown conventions hold: single H1, only table rows exceed 100 chars,

- Lens: soc2-scope-correction-audit
- Claim: markdown conventions hold after the scope-correction edit: single H1, no prose
  line over 100 chars.
- Source: `grep -n '^# [^#]'` and an `awk` length-check over all 254 lines of
  `ROADMAP_SOC2_MATH.md`, re-run fresh this pass.
- Verdict: CONFIRMED
- Evidence: `grep` finds exactly one H1 match (line 1, the title). The length check finds
  only 4 lines over 100 chars (57, 61, 62, 63), all markdown-table rows in section 1's
  correspondence table, not prose paragraphs -- matching the same table-row-length
  precedent already established in `ROADMAP_CLOUD_MATH.md`, so the convention's table
  exemption is applied consistently.
- Severity: minor

### PM12 -- Section 3(c)'s PA23/PA24 citation accurately reflects that file's content,

- Lens: soc2-scope-correction-audit
- Claim: section 3(c)'s citation of `PRAXIS_SELF_AUDIT.md` PA23/PA24 accurately reflects
  that file's content (thermo.rs FFI shim + `lean_ffi_wrapper.c` hardcoded-constant
  findings).
- Source: `sed -n '435p;457p' PRAXIS_SELF_AUDIT.md` (heading text) cross-checked against
  `sed -n '205,225p;250,254p' ROADMAP_SOC2_MATH.md`.
- Verdict: CONFIRMED
- Evidence: `PRAXIS_SELF_AUDIT.md:435` heading is "### PA23 -- thermo_helmholtz doc
  comment..." and `:457` is "### PA24 -- lean_ffi_wrapper.c provides Lean/Mathlib FFI
  bindings...", matching the roadmap's L210-219 description (doc comment quotes real
  theorem but FFI symbol ignores input; hand-written Mathlib stand-ins return fixed
  constants) and the L253-255 References-section citation of both PA numbers.
- Severity: minor

### PM13 -- SOC2 flow-test construction workflow has produced no files yet,

- Lens: soc2-flow-test-workflow-catch
- Claim: the SOC2 flow-test construction workflow (task `wfigivqnl`) has not produced any
  files yet -- `procint/ProcInt/Playground/SOC2/{AuditFlow,AuditFlowViolation}.lean` do
  not exist.
- Source: `find .../Playground/SOC2 -type f`, `ls -la .../Playground/SOC2`, `git status
  --porcelain`, `grep -rl "AuditFlow" --include='*.lean' .`, `grep -rl wfigivqnl .`, all
  re-run fresh this pass.
- Verdict: CONFIRMED
- Evidence: `find`/`ls` both report the `SOC2` directory does not exist; `git status
  --porcelain` (71 lines) contains no SOC2/AuditFlow paths; `grep` for `AuditFlow` across
  all `.lean` files in the repo returns zero matches; `grep` for the task id `wfigivqnl`
  anywhere in the tree returns zero matches. `Playground/` itself has other active
  subdirs (`Swarm11`, `Multifractal`, `MFW`, `Glue`, `Experimental`, `Trajectory`), but
  nothing under `SOC2` has been created.
- Severity: minor

## Pass 14 findings

### PN1 -- AuditFlowViolation.lean's docstring still forward-references Swarm11.AuditFlow,

- Lens: soc2-flow-test-quality-check
- Claim: AuditFlowViolation.lean's docstring still describes the (at-the-time-nonexistent)
  positive companion as living at `ProcInt.Playground.Swarm11.AuditFlow`, but the file
  actually built now lives at `ProcInt.Playground.SOC2.AuditFlow` -- a stale forward-
  reference never corrected after AuditFlow.lean was written.
- Source: procint/ProcInt/Playground/SOC2/AuditFlowViolation.lean:19-22 vs
  procint/ProcInt/Playground/SOC2/AuditFlow.lean:69-71
- Verdict: DRIFTED
- Evidence: AuditFlowViolation.lean line 20-21 reads: "the design for this witness pairs
  this negative file with a positive companion at `ProcInt.Playground.Swarm11.AuditFlow`...
  That positive file does not exist in this build yet." But AuditFlow.lean (written later,
  mtime 12:36 vs AuditFlowViolation.lean's 12:16) declares `namespace
  ProcInt.Playground.SOC2` (line 69) then `namespace AuditFlow` (line 71), i.e. its fully-
  qualified name is `ProcInt.Playground.SOC2.AuditFlow`, not `Swarm11.AuditFlow`.
  AuditFlow.lean's own docstring (line 12) correctly names the sibling as
  `ProcInt.Playground.SOC2.AuditFlowViolation`, so only the older file's forward-looking
  guess is wrong/unupdated. Cosmetic (comment-only, doesn't affect compilation) but is a
  genuine documentation-drift artifact worth a follow-up edit.
- Severity: minor

### PN2 -- known-persistent-drift.txt has not yet been extended to cover Playground/SOC2/,

- Lens: general-drift-and-fixloop-check
- Claim: the only path in `git status --porcelain` not already covered by
  `.mfact/known-persistent-drift.txt` is `procint/ProcInt/Playground/SOC2/`, and it is not
  yet in the baseline file.
- Source: `git -C /Users/sac/mfact status --porcelain | sed -E 's/^.{3}//' | sort | comm
  -23 - /Users/sac/mfact/.mfact/known-persistent-drift.txt` (fresh run this pass)
- Verdict: DRIFTED
- Evidence: `comm -23` output is exactly one line: `procint/ProcInt/Playground/SOC2/`.
  Full `git status --porcelain` otherwise matches the known-drift set 1:1
  (.ggen-v2/receipt-log.jsonl, .mfact/artifacts.toml, crates/mfact-core/{build.rs,src/*.rs,
  tests/*.rs}, ggen.lock, procint/ProcInt/Graph/, procint/artifacts/, pylab/*,
  research-papers/*, release/standing.env, scripts/*, web/mfact-ui). This new path is
  expected (SOC2 flow-test construction workflow, task wfigivqnl) but has not yet been
  added to the baseline file, so it correctly still surfaces as delta -- consistent with
  pass 13's finding of the same pattern for prior in-progress workflow outputs before they
  get baselined.
- Severity: minor

### PN3 -- Pass 13's "SOC2 flow-test workflow produced zero files" finding now supersedes,

- Lens: general-drift-and-fixloop-check
- Claim: pass 13's finding that the SOC2 flow-test workflow (task wfigivqnl) had produced
  zero files as of ~12:14 PDT is now superseded -- the files exist as of this pass,
  confirming genuine construction progress rather than a stalled workflow.
- Source: cross-reference of PRAXIS_SELF_AUDIT.md pass-13 entry (lines 271-274, 3971-3984)
  against fresh ls/wc of procint/ProcInt/Playground/SOC2/ this pass
- Verdict: FIXED-since-last-pass
- Evidence: pass 13 (PRAXIS_SELF_AUDIT.md:3971-3984) confirmed via find/ls/grep that
  Playground/SOC2/ did not exist and wfigivqnl had zero hits in the tree as of ~12:14 PDT.
  This pass's fresh ls/wc shows the directory now exists with two substantive files (683
  total lines) with mtimes 12:16 and 12:36 -- the workflow advanced between the two passes,
  matching the task description that it is "now past Build into Verify/Integrate".
- Severity: minor

### PN4 -- AuditFlow.lean is a genuine, near-complete concrete witness, not a stub,

- Lens: soc2-flow-test-quality-check
- Claim: AuditFlow.lean (535 lines, 26705 bytes) is a genuine, near-complete concrete
  witness mirroring Swarm11/Crown.lean's `checks : List (String x Bool)` aggregator
  pattern, with a module docstring citing specific ROADMAP_SOC2_MATH.md Cards per check.
- Source: procint/ProcInt/Playground/SOC2/AuditFlow.lean (full read, lines 1-535)
- Verdict: CONFIRMED
- Evidence: docstring (lines 8-67) explicitly cites Card 1 (CC6, lines 24-31), Card 2
  (PI1.1-PI1.5, lines 32-40), Card 3 (Availability A1.1-A1.3, lines 41-56) from
  ROADMAP_SOC2_MATH.md, cross-checked against ROADMAP_SOC2_MATH.md lines 57/61/62/81-160
  and matching. Line citations verified against source: `minimalSupport_tenant_pure`/
  `crossTenant_residue_disjoint` at Residue/Tenancy.lean:86/111 (grep-confirmed),
  `zero_unreceipted_completion` at MFW/Runtime.lean:62 (matches), `replay_eq_of_traceEq`/
  `manufacturedReceipt_valid` at Swarm11/Replay.lean:105/149 (both confirmed exact).
  `checks` (lines 505-531) is a 12-entry `List (String x Bool)` using `decide (...)` on
  real predicates over concrete data (C2, s1/s2/s3, auditReceipt), identical shape to
  Crown.lean:82 `def checks : List (String x Bool)`. Body contains 82 top-level
  theorem/def/instance/abbrev declarations, 35 uses of `decide`, 14 of `rfl`, zero
  occurrences of `sorry`/`admit`/`native_decide` as tactics (only in docstring prose
  disclaiming their absence). Proofs (e.g. f2_monotone, f2_idempotent, separated_C2,
  hS1/hS2, s3_eq_s2alt) are substantive, non-trivial tactic proofs, not placeholders.
- Severity: minor

### PN5 -- AuditFlowViolation.lean genuinely reuses TenancyCountermodel, no reinvention,

- Lens: soc2-flow-test-quality-check
- Claim: AuditFlowViolation.lean (148 lines, 9165 bytes) genuinely reuses Tenancy.lean's
  existing `TenancyCountermodel` section rather than reinventing a new countermodel.
- Source: procint/ProcInt/Playground/SOC2/AuditFlowViolation.lean (full read)
  cross-checked against procint/ProcInt/MFW/Residue/Tenancy.lean
- Verdict: CONFIRMED
- Evidence: file imports only `ProcInt.MFW.Residue.Tenancy` (line 3) and references
  `TenancyCountermodel.Obl`, `.tag`, `.tag_zero`, `.tag_one`, `.C`, `.C_zero`, `.C_empty`,
  `.not_separated`, `.singleton_mem_residue` throughout (lines 62-143) with zero local
  re-definitions of `Obl`/`tag`/`C`. Grep of Tenancy.lean confirms `namespace
  TenancyCountermodel` (line 131) through `end TenancyCountermodel` (line 243) genuinely
  defines all of these: `tag_zero`/`tag_one` (140-141), `C_zero`/`C_empty` (187/191),
  `not_separated` (197), `singleton_mem_residue` (214).
  `AuditFlowViolation.violation_shared_support` (lines 86-93) directly composes
  `zero_mem_residue_for_zero_goal` (new, proved locally) with
  `TenancyCountermodel.singleton_mem_residue` (reused verbatim) -- exactly the claimed
  non-reinvention pattern.
- Severity: minor

### PN6 -- Both SOC2 flow-test files are free of sorry/admit/native_decide proof gaps,

- Lens: soc2-flow-test-quality-check
- Claim: both files are free of `sorry`/`admit`/`native_decide` proof gaps.
- Source: grep across both SOC2/AuditFlow.lean and SOC2/AuditFlowViolation.lean
- Verdict: CONFIRMED
- Evidence: all matches of the strings "sorry", "admit", "native_decide" in both files
  occur only inside docstring prose disclaiming their use (e.g.
  AuditFlowViolation.lean:40,44-45: "no `sorry`/fake ... no `sorry`, no `admit`, no
  `native_decide` standing in for a gap"), never as actual tactics in a proof body.
- Severity: minor

### PN7 -- Both SOC2 files are untracked, consistent with in-progress construction,

- Lens: soc2-flow-test-quality-check
- Claim: both files are untracked (uncommitted) new files at the current HEAD, consistent
  with an in-progress construction workflow rather than a completed/merged deliverable.
- Source: `git status --short procint/ProcInt/Playground/SOC2/` ; `git log -1
  --format='%H %cd'`
- Verdict: CONFIRMED
- Evidence: `git status --short` reports `?? procint/ProcInt/Playground/SOC2/` (untracked
  directory); HEAD is a50c5e9b9b007e7c2f0df8b143829fb1add7654f at 2026-07-13 12:27:48
  -0700, matching the stated starting HEAD for this pass.
- Severity: minor

### PN8 -- HEAD is a50c5e9 as stated; git log -5 shows only expected self-loop commits,

- Lens: general-drift-and-fixloop-check
- Claim: HEAD is a50c5e9 as the pass description states, and `git log -5` shows only
  expected loop/audit commits (firing-9 collision receipt, pass-13 audit doc,
  ROADMAP_SOC2_MATH.md, firing-8 collision receipt, pass-12 audit doc) -- no foreign or
  unexpected commits landed.
- Source: `git -C /Users/sac/mfact rev-parse HEAD; git -C /Users/sac/mfact log --oneline
  -5` (re-run fresh this pass at 12:39-12:41 PDT)
- Verdict: CONFIRMED
- Evidence: `rev-parse` returns a50c5e9b9b007e7c2f0df8b143829fb1add7654f exactly. `log -5`:
  a50c5e9 (firing-9 collision), f81790a (pass 13 audit doc), 852d343
  (ROADMAP_SOC2_MATH.md), ec9001e (firing-8 collision), 804f39c (pass 12 audit doc) -- all
  previously-known self-loop commits, no drive-by/foreign commit.
- Severity: minor

### PN9 -- Both SOC2 flow-test files exist with substantive content, not stubs,

- Lens: general-drift-and-fixloop-check
- Claim: both SOC2 flow-test files (AuditFlow.lean, AuditFlowViolation.lean) now exist
  under procint/ProcInt/Playground/SOC2/ with substantive real content, not stubs, and
  contain no `sorry`/`admit` placeholders.
- Source: `ls -la`, `wc -l`, `head -20`, and `grep -nw 'sorry'` on both files (fresh reads
  this pass)
- Verdict: CONFIRMED
- Evidence: AuditFlow.lean = 535 lines (mtime 12:36), AuditFlowViolation.lean = 148 lines
  (mtime 12:16). Headers describe real mathematical content: AuditFlow.lean composes
  Waves 1-7 theorems into a positive two-tenant compliant-closure witness;
  AuditFlowViolation.lean is the negative/violation companion reusing
  TenancyCountermodel. `grep -nw sorry` on both files returns zero matches on the literal
  `sorry` tactic token (only prose text mentioning "no sorry" inside comments/docstrings).
- Severity: minor

### PN10 -- Cron f6a6cd52's firing history is documented consistently across 3 files,

- Lens: general-drift-and-fixloop-check
- Claim: the cron identifier f6a6cd52 referenced in this pass's instructions is the same
  fix-loop job tracked continuously since pass 6, and its firing history (firing-1 through
  firing-9) is documented consistently across MFACT_SELF_IMPROVEMENT_LOOP.md,
  PRAXIS_SELF_AUDIT.md, and GAP_LEDGER_v26.7.12.md.
- Source: `grep -rn 'f6a6cd52'` across *.md (fresh run this pass)
- Verdict: CONFIRMED
- Evidence: cron job f6a6cd52 is referenced consistently: PRAXIS_SELF_AUDIT.md pass 6
  (~09:12 PDT slot) through pass 13, GAP_LEDGER_v26.7.12.md closure evidence entries
  (G49/G50/G51 fixes), and MFACT_SELF_IMPROVEMENT_LOOP.md's firing-9 collision-receipt
  entry -- same identifier, continuous timeline, no discrepancy.
- Severity: minor

### PN11 -- Files were not built/compiled this pass; check is source-inspection only,

- Lens: soc2-flow-test-quality-check
- Claim: files were not built/compiled as part of this check (read-only lens, per
  instructions) -- completeness assessment is based on source inspection only, not a
  passing `lake build`.
- Source: task instructions; no build command was run
- Verdict: UNVERIFIABLE
- Evidence: per explicit instruction to avoid racing a concurrent mid-edit agent, no `lake
  build`/`lake env lean` was invoked. All claims above are structural/textual verification
  (imports, namespaces, docstring cross-references, decide/rfl/sorry occurrence counts)
  rather than confirmation that the files actually typecheck.
- Severity: minor

### PN12 -- Fix loop f6a6cd52's next firing had not landed by this pass's check window,

- Lens: general-drift-and-fixloop-check
- Claim: fix loop f6a6cd52's next firing (~12:42 PDT) had not landed as of this pass's
  check window (12:39-12:41 PDT); latest receipt remains firing-9 (20260713T192656Z,
  12:26:56 PDT) and HEAD is unchanged at a50c5e9.
- Source: `ls -la /Users/sac/mfact/.mfact/receipts/` and `git log -3`, sampled twice this
  pass (12:39:53 and 12:40:58 PDT)
- Verdict: UNVERIFIABLE
- Evidence: both samples show latest.json / 20260713T192656Z.json unchanged (876 bytes,
  mtime 12:27) and HEAD unchanged at a50c5e9 across the ~65-second window checked. The
  ~12:42 PDT estimate for the next firing had not yet arrived within this pass's
  observation window, so no new firing to audit could be captured this pass -- consistent
  with prior passes occasionally landing just outside the sampled window.
- Severity: minor

## Pass 15 findings

### PO1 -- build.rs still references the deleted lean_ffi_wrapper.c, a login-shell landmine,

- Lens: g11-deletion-reverify
- Claim: firing-10's G11 closure (commit 108bf5b) deleted `lean_ffi_wrapper.c` and
  reported the deletion has zero effect on the reachable build, verified via `just
  clippy-core` passing before and after. That verification never checked `build.rs`.
- Source: crates/mfact-core/build.rs (untracked); direct `~/.elan/bin/lean
  --print-prefix`; `~/.bash_profile`; `~/.zprofile`
- Verdict: DRIFTED
- Evidence: live `cat build.rs` shows `cc::Build::new()....file("src/
  lean_ffi_wrapper.c")....compile("thermo_lean")` -- a literal reference to one of the 8
  just-deleted files. `just clippy-core` currently passes only because
  `Command::new("lean").arg("--print-prefix")` fails to resolve on this sandboxed
  shell's PATH (`which lean` -> not found), so build.rs prints a warning and returns
  before reaching `cc::Build`. But `~/.bash_profile:14` and `~/.zprofile:8` both
  `export PATH="$HOME/.elan/bin:$PATH"`, and `~/.elan/bin/lean --print-prefix` resolves
  and exits 0 with a real toolchain prefix when invoked directly. In the user's actual
  login shell, `cargo build`/`check`/`clippy` on mfact-core would reach the `cc::Build`
  call and fail on the missing file -- an undisclosed build-breakage landmine in the
  exact FFI domain this firing was working in.
- Severity: major

### PO2 -- 10-agent workflow wup6bpemk has produced no artifacts yet as of this pass,

- Lens: lean-testing-workflow-catch
- Claim: the "Lean-testing-landscape-and-gaps" workflow (task wup6bpemk) has produced
  new files under procint/ProcInt/Playground since GAP_LEDGER_v26.7.12.md was written.
- Source: `find procint/ProcInt/Playground -newer GAP_LEDGER_v26.7.12.md -type f`;
  `grep -rn wup6bpemk /Users/sac/mfact`
- Verdict: REFUTED
- Evidence: both commands returned empty. No file under Playground is newer than
  GAP_LEDGER_v26.7.12.md (mtime 13:04 PDT), and no reference to wup6bpemk exists
  anywhere in the tree. Reported plainly, not as a problem -- the workflow may simply
  still be in an early/dispatch stage as of this pass's ~13:15 PDT check.
- Severity: minor

### PO3 -- pass 14's PN1 (stale Swarm11.AuditFlow docstring reference) is fixed,

- Lens: status-count-drop-explained
- Claim: pass 14's PN1 finding (AuditFlowViolation.lean's docstring forward-referencing
  the nonexistent `ProcInt.Playground.Swarm11.AuditFlow`) was fixed by a commit landing
  inside this pass's review window.
- Source: `git show bb25faf --stat` and full diff, read directly rather than trusted
  from the commit message
- Verdict: FIXED-since-last-pass
- Evidence: commit bb25faf (12:46:42 PDT, between pass-14 HEAD a50c5e9 and this pass's
  HEAD 836fb53) rewrites the docstring, replacing the stale `Swarm11.AuditFlow`
  reference with the actual committed location `ProcInt.Playground.SOC2.AuditFlow`.
  Confirmed by reading the diff body, not the commit message. Does not affect the
  porcelain-count delta (touches an already-tracked file).
- Severity: minor

### PO4 -- all 8 named files are genuinely deleted and were never tracked history,

- Lens: g11-deletion-reverify, lean-testing-workflow-catch
- Claim: broker.rs, thermo.rs, transport.rs, lean.rs, lean_ffi_wrapper.c, main.rs,
  tests/thermo_integration_test.rs, tests/sse_transport_test.rs are all genuinely
  deleted, and commit 108bf5b's claim they were "all untracked, never committed" is
  accurate.
- Source: `[ -e ]` existence check on all 8 paths; `git log --all --oneline -- <path>`
  per path (fresh re-run this pass)
- Verdict: CONFIRMED
- Evidence: all 8 paths report "gone" on live existence check; `git log --all` returns
  zero commits for every one of the 8 paths, confirming none was ever a git object in
  this repo's history -- matching commit 108bf5b's own message verbatim.
- Severity: minor

### PO5 -- porcelain drop from 71 to 63 is fully and exactly explained by the deletion,

- Lens: g11-deletion-reverify, status-count-drop-explained, lean-testing-workflow-catch
- Claim: `git status --porcelain`'s line-count drop from 71 (prior baseline) to 63 is
  fully explained by the 8-file deletion, with no other unaccounted drift.
- Source: fresh `git status --porcelain | wc -l`; `grep -c '^ M'`; `grep -c '^ D'`
- Verdict: CONFIRMED
- Evidence: live count = 63 = 71 - 8 exactly. Tracked `M` set is unchanged at 7 files
  (.ggen-v2/receipt-log.jsonl, .ggen-v2/receipt.json, .mfact/artifacts.toml,
  crates/mfact-core/src/validate.rs, ggen.lock, release/standing.env, web/mfact-ui);
  `^ D` count is 0, confirming these were untracked-file removals, not tracked
  deletions.
- Severity: minor

### PO6 -- remaining crate builds clean; no dead references in the surviving tests,

- Lens: g11-deletion-reverify
- Claim: `just clippy-core` still passes on a genuine fresh recompile, and the two
  remaining test files (proptest_invariants.rs, concurrent_validation_tests.rs)
  reference nothing that was deleted.
- Source: live `touch validate.rs` then `just clippy-core`; `grep -rnE
  'broker|thermo|transport|lean_ffi|\blean\b' src/ tests/`
- Verdict: CONFIRMED
- Evidence: rerun this pass: "Checking mfact-core v0.1.0 ... Finished `dev` profile
  ... target(s) in 0.16s", exit 0 -- a real recompile triggered by the touch, not a
  stale cache hit. The grep across src/ and tests/ returns zero matches in either
  remaining test file (only build.rs itself matches -- see PO1).
- Severity: minor

### PO7 -- GAP_LEDGER_v26.7.12.md's G11 entry is genuinely closed with matching evidence,

- Lens: g11-deletion-reverify, status-count-drop-explained, lean-testing-workflow-catch
- Claim: G11's ledger entry is marked CLOSED (Rust side) with closure evidence matching
  the PA23/PA24 findings it cites, and honestly discloses the one item it did not fix
  (the dead EventSource reference in web/mfact-ui) rather than silently dropping it.
- Source: `grep -n '^### G11' -A 16 GAP_LEDGER_v26.7.12.md`; PRAXIS_SELF_AUDIT.md:492-529
  (PA23/PA24); web/mfact-ui/src/wargames/useWargames.ts
- Verdict: CONFIRMED
- Evidence: line 290 reads "Status: CLOSED (Rust side); one residual item noted below,
  not addressed this firing." Closure evidence cites the same PA23 (fake FFI stub
  calling an unrelated package's symbol) and PA24 (hand-written fake Mathlib
  stand-ins) findings verbatim. The disclosed residual is still present:
  useWargames.ts:89 still does `new EventSource('http://localhost:8080/stream')`
  against a server that no longer exists.
- Severity: minor

### PO8 -- known-persistent-drift.txt diff shows zero unexplained new drift this pass,

- Lens: status-count-drop-explained
- Claim: a comm-based diff of the live 63-path `git status` against the 76-line
  `.mfact/known-persistent-drift.txt` baseline shows zero unexplained new drift.
- Source: fresh `sort` + `comm -23`/`comm -13` between live git status paths and the
  sorted baseline file
- Verdict: CONFIRMED
- Evidence: `comm -23` (live paths absent from baseline) is empty -- every live path is
  already tolerated. `comm -13` (stale baseline entries) is exactly 13 lines: the 8
  G11-deleted files plus 5 previously-flagged-stale roadmap docs
  (MFW_WORKFLOW_CATALOG.md, ROADMAP.md, ROADMAP_GAP_AUTONOMIC.md,
  ROADMAP_GAP_SEMANTIC.md, ROADMAP_GAP_THERMO.md, first noted at pass 9 and
  reconfirmed every pass since). Arithmetic closes exactly: 76 - 13 = 63.
- Severity: minor

### PO9 -- G2 and every other gap entry are untouched by commit 108bf5b,

- Lens: g11-deletion-reverify
- Claim: no gap entry other than G11 was touched or incorrectly claimed-closed by
  commit 108bf5b.
- Source: `git show 108bf5b -- GAP_LEDGER_v26.7.12.md` full diff; live re-read of G2
- Verdict: CONFIRMED
- Evidence: the commit's diff to GAP_LEDGER_v26.7.12.md is confined entirely to the G11
  section (29 insertions, 1 deletion). G2 ("crates/mfact-core excluded from
  workspace") still reads "Status: BLOCKED" with its own unrelated 2026-07-12 blocker,
  untouched.
- Severity: minor

### PO10 -- no foreign commits landed in this pass's 5-commit review window,

- Lens: status-count-drop-explained, lean-testing-workflow-catch
- Claim: HEAD is 836fb53 as this pass starts, and the 5-commit range since pass 14's
  a50c5e9 is fully self-consistent loop/audit activity with no foreign commit.
- Source: `git log -1 --format='%H %ci'`; `git log --oneline a50c5e9..836fb53`
- Verdict: CONFIRMED
- Evidence: HEAD = 836fb53193b327fce9580e81298139a6fd773839, 2026-07-13 13:06:22
  -0700. Exactly 5 commits separate a50c5e9 from 836fb53: 8338516 (SOC2 witness
  composition), 16322a5 (pass-14 audit doc), bb25faf (docstring fix, see PO3), 108bf5b
  (G11 deletion), 836fb53 (loop receipt). Same author throughout; all attributable to
  the documented self-improvement loop.
- Severity: minor

### PO11 -- known-persistent-drift.txt still lists the 8 now-deleted G11 paths,

- Lens: status-count-drop-explained
- Claim: `.mfact/known-persistent-drift.txt` still lists all 8 now-deleted G11 paths,
  making it stale, though this causes zero functional error in the collision guard.
- Source: `grep -nE` for the 8 filenames against the baseline file; `git log -1
  --format='%ad' -- .mfact/known-persistent-drift.txt`
- Verdict: CONFIRMED
- Evidence: the baseline file was last written 2026-07-13 08:46:41 -0700 and never
  refreshed since; it still carries the 8 dead-path entries (matched at lines 5-13 by
  grep). Per PO8's comm semantics, an unmatched baseline entry for a nonexistent path
  simply never surfaces in a `comm -23` diff, so the collision guard is unaffected --
  real staleness worth a future refresh, not a live defect.
- Severity: minor

## References

- `AGENTS.md` -- the construction discipline (explore vs. exploit, no vacuous
  tautologies, no unfalsifiable claims) this ledger enforces against
  this session's own output.
- `GAP_LEDGER_v26.7.12.md` -- the sibling gap ledger for externally-scoped defects;
  the gap-ledger-staleness findings above (PA38-PA45) name specific G-numbers
  there whose Status field has drifted since that ledger was written.
- `CLAUDE_ROADMAP.md`, `ROADMAP_MATH_SPINE.md`, `ROADMAP_SWARM_SUPPLY_CHAIN.md`,
  `ROADMAP_GAP_THERMO.md` -- roadmap docs whose marker schema and standing claims
  are audited by the roadmap-marker-schema and agents-md-self-compliance
  findings above.

## Pass 16 findings

### PP1 -- the cslib-survey-agent crashed mid-tool-use and was never retried, unlike two sibling crashes,

- Lens: cslib-survey-gap-check
- Claim: The 'survey:cslib-test-conventions' agent (a18efebc30633f5ff) crashed
  mid-tool-use with an unretried API connection error and never produced a
  result/StructuredOutput; unlike two other agents in the same wave that hit the same kind
  of failure and WERE retried to completion.
- Source: wf_868df87a-eaa/journal.jsonl (line 2, "started" key e486712d..., no matching
  result line anywhere in the 27-line file); wf_868df87a-eaa/agent-a18efebc30633f5ff.jsonl
  line 48 (isApiErrorMessage:true, "API Error: Connection closed mid-response...")
- Verdict: CONFIRMED
- Evidence: grep of journal.jsonl for started-vs-result agentId pairs shows exactly 3
  'started' entries with no result: keys e486712d... (line2, a18efebc30633f5ff),
  acf268fd...(line4, retried at line13), eef898bf...(line8, retried at line12). Only
  e486712d... (the cslib survey) was never retried anywhere in the 27-line journal.
- Severity: major

### PP2 -- the Synthesize phase's input falsely claims "10-lens" coverage while only 9 lenses arrived,

- Lens: cslib-survey-gap-check
- Claim: The Synthesize-phase agent's input prompt asserts 'All survey findings from a
  10-lens parallel exploration' but the actual concatenated findings blob contains exactly
  9 distinct lens tags -- no 'cslib-test-conventions' lens is present, and there is no
  text anywhere in the ~108KB input disclosing that a lens failed or is missing.
- Source: wf_868df87a-eaa/agent-a0cc32b12d7c5d914.jsonl (first user message)
- Verdict: CONFIRMED
- Evidence: Regex extraction of all `"lens": "..."` values from the Synthesize agent's
  input yields exactly 9 distinct lenses (lean4-core-testing-mechanisms,
  plausible-property-testing, existing-mfact-test-inventory,
  witness-pattern-methodology-gaps, gap-residue-tenancy-descent,
  gap-replay-orientedswap-runtime, gap-multifractal-thermo-cost,
  gap-powl-correspondence-composition, gap-thermo-py-and-external-fake-ffi-parallel)
  across 84 tagged findings. Searches for 'failed', 'connection', '9-lens', 'did not
  complete', 'could not be surveyed' inside that input all return no match; the only
  'cslib' hit (offset 17971) is an unrelated require-list observation from the plausible
  lens, not a disclosure of the cslib survey's absence. The prompt's own claimed count
  ('10-lens') does not match the 9 lenses actually supplied, and this mismatch is never
  called out anywhere in the input.
- Severity: major

### PP3 -- Synthesize/Build-spec/Build/Verify never discuss cslib's own testing conventions, dropped entirely,

- Lens: cslib-survey-gap-check
- Claim: None of the downstream Synthesize output, Build-spec, Build, or Verify-phase
  results (the four post-survey stages of the workflow) ever discuss cslib's own testing
  conventions or CslibTests methodology; the topic is dropped entirely rather than being
  either falsely claimed as covered or honestly flagged as an open gap.
- Source: journal.jsonl lines 20 (Synthesize, 25 findings), 23 (Build-spec), 25 (Build),
  27 (Verify) in the same wf_868df87a-eaa journal
- Verdict: CONFIRMED
- Evidence: Case-insensitive grep for 'cslib' across dumps of all four result payloads
  returns only 2 hits total, both in the Build-spec (line23) and Verify (line27) outputs,
  and both are incidental citations of `Cslib/Foundations/Relation/Confluence.lean:269`
  (the `Terminating_toConfluent` lemma) used as a proof dependency for the OrientedSwap
  confluence theorem -- not any statement about surveying, reusing, or being unable to
  check cslib's test-authoring conventions. The Synthesize output (line20, 25 findings)
  has zero 'cslib' hits at all.
- Severity: major

### PP4 -- commit 84ab3de's self-audit self-flags one citation error but never discloses the cslib survey failure,

- Lens: cslib-survey-gap-check
- Claim: Commit 84ab3de and its ROADMAP_MATH_SPINE.md diff contain a detailed self-audit
  ('Verification performed this session') that lists exact files re-checked and even
  self-flags one citation line-range error, but nowhere discloses that the planned
  cslib-test-conventions survey failed or that the underlying question ('does cslib have a
  reusable rewriting-system witness/confluence-counterexample pattern analogous to what
  mfact needs') was never actually answered.
- Source: git show 84ab3de (commit message + ROADMAP_MATH_SPINE.md diff) in
  /Users/sac/mfact
- Verdict: CONFIRMED
- Evidence: Commit message's 'Verification performed this session' section enumerates
  re-checked files (RuntimeReplay.lean, NewmanCorrespondence.lean, OrientedSwap.lean,
  cslib's Confluence.lean, ManufactureDecrease.lean, ObligationRank.lean, AuditFlow.lean,
  ROADMAP_MATH_SPINE.md) and self-flags a citation off-by-range error, demonstrating the
  session does disclose known gaps elsewhere -- yet contains no mention of the failed
  cslib survey or the unanswered question about cslib's own test conventions. The new
  ROADMAP_MATH_SPINE.md prose (Tenancy-crossing gap note, Glue section update) likewise
  makes no mention of it.
- Severity: major

### PP5 -- ManufactureTenancyGap.lean's soundness gap has no GAP_LEDGER_v26.7.12.md entry, only commit-message prose,

- Lens: ledger-and-baseline-health
- Claim: wup6bpemk's commit 84ab3de "exhibit ManufactureStep tenancy-crossing gap" has no
  corresponding entry in GAP_LEDGER_v26.7.12.md -- the finding exists only in the commit
  message (and a ROADMAP_MATH_SPINE.md prose note), with no tracked G-number disposition.
- Source: git show --stat 84ab3de (files touched: ROADMAP_MATH_SPINE.md,
  procint/ProcInt/Playground.lean, Playground/Glue/OrientedSwapReplay.lean,
  Playground/SOC2/ManufactureTenancyGap.lean -- GAP_LEDGER_v26.7.12.md absent); git log
  --oneline -10 -- GAP_LEDGER_v26.7.12.md (most recent touch is 5608deb, 4 commits before
  84ab3de/HEAD); grep -ni "manufacture\|tenancy" GAP_LEDGER_v26.7.12.md; git grep -n
  "ManufactureTenancyGap|tenancy-crossing" across the whole tracked tree; grep -n "^### G"
  GAP_LEDGER_v26.7.12.md (highest entry is G51, no G52)
- Verdict: CONFIRMED
- Evidence: 84ab3de's diff never touches GAP_LEDGER_v26.7.12.md, and no commit after it
  does either -- the ledger's last modification (5608deb, a G11 follow-up) predates
  84ab3de entirely. Grepping the ledger for "manufacture" or "tenancy" returns only one
  unrelated substring hit (line 702, "manufactured/admitted", part of an unrelated
  sentence). A repo-wide git grep for "ManufactureTenancyGap" or "tenancy-crossing" finds
  only the Lean import line in Playground.lean and the prose note in ROADMAP_MATH_SPINE.md
  (added by 84ab3de itself, stating "Standing: PROVEN (as a refutation)" but using no
  G-number or Status field from the ledger's OPEN/PARTIAL/IN_PROGRESS/BLOCKED/CLOSED
  vocabulary). The ledger's own highest-numbered entry remains G51 -- no new gap entry
  (e.g. a would-be G52) was created. This is exactly the "exhibited problem with no
  tracked disposition" scenario the task flagged: a real, exhibited soundness gap in
  ManufactureStep (concrete Lean witness, verified, non-trivial) that lives entirely in
  commit-message/roadmap prose and is invisible to anything that consumes
  GAP_LEDGER_v26.7.12.md (e.g. the v26.7.12 gap-closing cron loop described in that
  ledger's own header).
- Severity: major

### PP6 -- OrientedSwapReplay.lean/ManufactureTenancyGap.lean re-build clean at the exact job counts 84ab3de reports,

- Lens: verify-newman-confluence-commit
- Claim: OrientedSwapReplay.lean and ManufactureTenancyGap.lean build clean with exactly
  the job counts the commit message reports (544 and 726).
- Source: commit 84ab3de message vs fresh `just _lake "cd procint && lake build
  ProcInt.Playground.Glue.OrientedSwapReplay"` / `...ManufactureTenancyGap`
- Verdict: CONFIRMED
- Evidence: Re-ran both builds independently this pass: `Build completed successfully (544
  jobs)` for OrientedSwapReplay and `(726 jobs)` for ManufactureTenancyGap, exit 0 both
  times, exact match to the commit message's claimed counts.
- Severity: minor

### PP7 -- both new files are sorry/admit-clean; the only "admit" hits are prose false positives,

- Lens: verify-newman-confluence-commit
- Claim: grep for sorry/admit (tactic position) across both new files is empty; the only
  'admit' hits are prose false positives inside the word 'admit'.
- Source: commit 84ab3de message
- Verdict: CONFIRMED
- Evidence: Fresh `grep -n "sorry\|admit"` on both files: zero hits in
  OrientedSwapReplay.lean; in ManufactureTenancyGap.lean the only hits are lines 30/62 ('a
  carrier can admit more than one such order') -- prose, not tactic-position `admit`.
- Severity: minor

### PP8 -- all 7 new top-level theorems are axiom-clean, each a subset of [propext, Classical.choice, Quot.sound],

- Lens: verify-newman-confluence-commit
- Claim: All 7 new top-level theorems (4 in OrientedSwapReplay, 3 in
  ManufactureTenancyGap) are axiom-clean: subset of [propext, Classical.choice,
  Quot.sound], no sorryAx.
- Source: commit 84ab3de message ('Scratch #print axioms ... file created, checked, then
  deleted before commit')
- Verdict: CONFIRMED
- Evidence: The commit's own scratch check was deleted, so this pass re-created the
  evidence independently: `lake env lean --stdin` with `#print axioms` on all 7 named
  theorems (completeStep_commute_all, orientedSwap_locallyConfluent_completeStep,
  orientedSwap_confluent_completeStep, orientedSwap_replay_eq_completeStep,
  gap_manufactureStep, gap_tenant_crossing, manufactureStep_not_tenant_pure) returned
  axiom sets that are each a subset of {propext, Classical.choice, Quot.sound}; no sorryAx
  anywhere.
- Severity: minor

### PP9 -- concurrent_commute's proof body never consumes its own Concurrent hypothesis, compiler-corroborated,

- Lens: verify-newman-confluence-commit
- Claim: concurrent_commute's proof body (RuntimeReplay.lean:96-105) never consumes its
  own Concurrent p i j hypothesis -- the mechanism the 'unconditional' claim rests on.
- Source: OrientedSwapReplay.lean module docstring and commit message, citing
  RuntimeReplay.lean:96-105
- Verdict: CONFIRMED
- Evidence: Read the proof directly: the tactic block only destructs `s`/`k`, never
  touches `h : Concurrent p i j`. Independently corroborated by the compiler itself in
  this pass's fresh build output: `warning: RuntimeReplay.lean:96:62: Variable name 'h' is
  not explicitly referenced` -- an automated, non-narrative confirmation of the exact
  claim.
- Severity: minor

### PP10 -- every file:line citation in both new files resolves exactly, including the commit's self-flagged error,

- Lens: verify-newman-confluence-commit
- Claim: Every file:line citation in both new files resolves exactly
  (RuntimeReplay.lean:96-105, OrientedSwap.lean:226-232/250-269/390-414/436-472,
  ManufactureDecrease.lean:68-70, cslib Confluence.lean:269, AuditFlow.lean's
  Obl2/tag2/g2/S1/separated_C2), and the commit's own self-flagged citation error
  (ObligationRank.lean:34-38 cited as 'Excludes' when the real Excludes section is 46-54)
  is itself accurate.
- Source: commit 84ab3de message's verification section
- Verdict: CONFIRMED
- Evidence: Read each cited range directly: all match exactly except the one the commit
  itself flags. Independently confirmed ObligationRank.lean lines 34-38 are the tail of
  the 'Preserves' paragraph, and 'Excludes:' actually starts at line 46 and runs to line
  54 (before 'Standing:' at line 56) -- byte-for-byte matching the commit's
  self-correction.
- Severity: minor

### PP11 -- the "unconditional" confluence sidestep is real but explicitly and prominently disclosed, not implicit,

- Lens: verify-newman-confluence-commit
- Claim: The 'unconditional' Newman confluence for OrientedSwap(completeStep) is real but
  is obtained because completeStep's concrete structure makes it commute at *every* pair
  (not just concurrent ones) -- i.e. it discharges Wave 7's hard 'third Commute witness'
  case by making it vacuous for this step function, rather than solving the general
  problem OrientedSwap.lean §6 left open. The audit asks whether this is stated or left
  implicit.
- Source: OrientedSwapReplay.lean module docstring + §1 comment; RuntimeReplay.lean
  (predates this commit by ~2h, commit 250fcc7, unrelated wave)
- Verdict: CONFIRMED
- Evidence: The sidestep mechanism is real (verified above) but it is explicitly and
  prominently disclosed, not implicit: the file's opening docstring states it directly
  ('completeStep p commutes at every pair, unconditionally... exactly the third witness...
  available here for every triple rather than assumed'), and §1 repeats it ('Reported
  honestly as what it is -- a strictly stronger fact about this concrete representation,
  not a new proof technique'). Additionally, completeStep/concurrent_commute were authored
  in an earlier, unrelated commit (250fcc7, 11:21) for a different purpose (BRCE runtime
  bridge), so the triviality was discovered via composition, not manufactured post hoc to
  dodge the hard case. This does not match pass 10's earlier pattern of a
  silent/undisclosed gap.
- Severity: minor

### PP12 -- independent ground truth: CslibTests does not test cslib's own confluence/termination machinery,

- Lens: cslib-survey-gap-check
- Claim: Independent ground truth: cslib's own CslibTests suite does not actually test its
  confluence/termination machinery (Terminating_toConfluent/LocallyConfluent) at all --
  confluence proofs live in the main Cslib/ library as substantive theorems about real
  calculi (untyped lambda calculus, combinatory logic), not as toy witness/counterexample
  tests in CslibTests. The failed survey's premise (that CslibTests would contain a
  reusable rewriting-system witness or confluence-counterexample pattern) is not
  straightforwardly supported by the actual repo layout, independent of the agent's crash.
- Source: /Users/sac/mfact/procint/.lake/packages/cslib/CslibTests/*.lean and
  /Users/sac/mfact/procint/.lake/packages/cslib/Cslib/Languages/**/*Confluence*.lean
- Verdict: CONFIRMED
- Evidence: grep -rin 'confluen|rewrit|newman|terminat|diamond' across CslibTests/*.lean
  returns exactly one hit, an unrelated `#grind_lint skip
  Cslib.Logic.HML.Satisfies.diamond` annotation in GrindLint.lean:73 -- nothing about
  confluence/termination testing. The real confluence content lives in
  Cslib/Languages/LambdaCalculus/LocallyNameless/Untyped/{FullBetaConfluence,FullEtaConfluence,FullBetaEtaConfluence}.lean
  and Cslib/Languages/CombinatoryLogic/Confluence.lean, i.e. production theorems on real
  calculi, not CslibTests-style example/witness files. CslibTests' actual convention (seen
  in LTS.lean, Bisimulation.lean) is: define a small concrete inductive relation, then
  prove an `example : <property>` directly by tactic construction -- unrelated to
  confluence and not property-based (Plausible) testing.
- Severity: minor

### PP13 -- the missing cslib survey's impact on this round's Lean work was low; no cslib test-pattern was used,

- Lens: cslib-survey-gap-check
- Claim: The impact of the missing cslib survey on the shipped Lean work was low in this
  round: the two new files built and committed (OrientedSwapReplay.lean,
  ManufactureTenancyGap.lean) use cslib only as the source of the Terminating_toConfluent
  lemma (a proof dependency already known from earlier waves), not for any cslib-derived
  test-methodology pattern -- so the gap, while undisclosed, did not silently corrupt the
  build/verify results this round.
- Source: /Users/sac/mfact/procint/ProcInt/Playground/Glue/OrientedSwapReplay.lean and
  /Users/sac/mfact/procint/ProcInt/Playground/SOC2/ManufactureTenancyGap.lean
- Verdict: CONFIRMED
- Evidence: grep -n 'cslib|Cslib' on both new files shows only references to
  `Cslib.Foundations.Relation.Confluence` /
  `Cslib/Foundations/Relation/Confluence.lean:269` (the Terminating_toConfluent lemma),
  matching the same pre-existing dependency already used by
  OrientedSwap.lean/NewmanCorrespondence.lean in earlier waves; there is no use of any
  cslib test-witness pattern in either new file.
- Severity: minor

### PP14 -- the survey's #guard count of 12 in ProcInt/Tests double-counts a docstring mention; true count is 11,

- Lens: spotcheck-testing-landscape-claims
- Claim: #guard is used 12 times across ProcInt/Tests/{Conformance,Logs,Models,Ocel}.lean,
  none in Petri.lean because markings are noncomputable Finsupp
- Source: wup6bpemk survey phase (Lean-testing-landscape survey)
- Verdict: DRIFTED
- Evidence: Fresh `grep -c '#guard'` on the live tree gives Conformance.lean=6,
  Logs.lean=1, Models.lean=2, Ocel.lean=3, Petri.lean=0 (sum=12), matching the claimed
  count on its face. But reading Conformance.lean line-by-line (cat -n) shows line 11 --
  'all checked by #guard at elaboration time. -/' -- is prose inside the file's `/-! ...
  -/` module doc comment (lines 9-11), not an executed `#guard` command. The 5 actual
  `#guard` commands in Conformance.lean are on lines 17, 19, 21, 25, 27. So the true
  number of executed #guard oracle-checks across the 4 files is 11 (5+1+2+3), not 12; the
  claimed '12' is a naive substring-match count that double-counts a docstring's
  self-referential mention of the word '#guard'. The Petri.lean=0 / noncomputable-Finsupp
  part of the claim is independently confirmed: `noncomputable def seqNet : PetriNet (Fin
  2) (Fin 1) := { pre := fun _ => Finsupp.single 0 1, post := ... }` at
  ProcInt/Tests/Petri.lean:17-18, with the file's docstring at line 10 explicitly citing
  'markings are Finsupp and hence noncomputable'.
- Severity: minor

### PP15 -- AxiomAudit.lean contains exactly 203 matched #guard_msgs in #print axioms pairs,

- Lens: spotcheck-testing-landscape-claims
- Claim: AxiomAudit.lean contains 203 `#guard_msgs in #print axioms` pairs
- Source: wup6bpemk survey phase (Lean-testing-landscape survey)
- Verdict: CONFIRMED
- Evidence: File is at /Users/sac/mfact/procint/AxiomAudit.lean (top-level of procint/,
  not under ProcInt/Tests/), 623 lines. `grep -c '#guard_msgs in #print axioms'
  procint/AxiomAudit.lean` returns exactly 203, and `grep -c '#print axioms'` / `grep -c
  '#guard_msgs'` both also return exactly 203, confirming they occur strictly in matched
  pairs with no orphans. Sample lines 13-70 show the expected pattern, e.g. line 13:
  '#guard_msgs in #print axioms ProcInt.CardBound.admits_max'.
- Severity: minor

### PP16 -- native_decide appears zero times as an actual tactic in ProcInt, only in a docstring disclaimer,

- Lens: spotcheck-testing-landscape-claims
- Claim: native_decide appears zero times as an actual tactic anywhere in ProcInt, only
  once in a docstring disclaimer
- Source: wup6bpemk survey phase (Lean-testing-landscape survey)
- Verdict: CONFIRMED
- Evidence: `grep -rn 'native_decide' procint/ --include='*.lean'` excluding .lake/
  dependency packages returns exactly one hit outside .lake:
  ProcInt/Playground/SOC2/AuditFlowViolation.lean:45, reading '`admit`, no `native_decide`
  standing in for a gap.' Confirmed via cat -n that this line sits inside the file's
  module doc comment block (`/-!` opens at line 5, `-/` closes at line 49), i.e. it is
  prose disclaiming the tactic's use, not an invocation. No other occurrence of the token
  `native_decide` exists anywhere in the ProcInt source tree (all remaining matches are in
  .lake/packages/{vcv,mathlib}, which are external dependencies, not ProcInt code).
- Severity: minor

### PP17 -- known-persistent-drift.txt's mtime is its original write, not a refresh; "never refreshed" still holds,

- Lens: ledger-and-baseline-health
- Claim: known-persistent-drift.txt's mtime (2026-07-13 08:46:30) reflects a genuine
  refresh of the baseline, making prior passes' repeated "never refreshed"
  characterization now stale/wrong and in need of correction.
- Source: stat -f "%Sm %N" .mfact/known-persistent-drift.txt (mtime: Jul 13 08:46:30
  2026); git log --follow -p --all -- .mfact/known-persistent-drift.txt (exactly one
  commit, 1e47b878, author date Mon Jul 13 08:46:41 2026 -0700, "new file mode 100644");
  git merge-base --is-ancestor 1e47b878 HEAD (ancestor); git diff HEAD --
  .mfact/known-persistent-drift.txt (empty, working tree byte-identical to that commit's
  blob)
- Verdict: REFUTED
- Evidence: The 08:46:30 mtime is not a second, later refresh event distinct from creation
  -- it IS the original (and only) write, 11s before the commit's author timestamp
  (08:46:41), which is the normal git write-then-commit sequencing gap, not a new edit.
  git log shows exactly one commit ever touching this path, and the working tree currently
  matches that commit's content exactly (zero diff). Pass 15's PO11 finding already
  recorded this same fact ("last written 2026-07-13 08:46:41 -0700 and never refreshed
  since") using the identical timestamp. Re-running the same checks this pass reproduces
  the identical result: still one commit, still zero diff, still the same 8+ stale
  mfact-core/build-artifact paths and 5 stale roadmap-doc paths present in the 76-line
  baseline (re-verified live: comm -23 between current git status and the baseline is
  empty -- no unexplained new drift; comm -13 now shows 14 stale baseline entries, one
  more than PO8/PO11's 13, since validate.rs is the only mfact-core path from the original
  10-file G11 group still live). The "never refreshed" claim remains accurate as of this
  pass; no correction to the record is warranted.
- Severity: minor

## Pass 17 findings

### PQ1 -- collision guard is path-only; the live validate.rs case is pre-existing drift,

- Lens: multi-workflow-concurrency-safety
- Claim: The delta-based collision guard is structurally blind to new edits landing on any
  path already present in the (~5.5h-stale) known-persistent-drift.txt baseline, because it
  diffs path lists via `comm`, never content or hashes -- demonstrated live on
  crates/mfact-core/src/validate.rs, which was mid-edit and unattributed to either declared
  workflow at check time.
- Source: `git diff --stat HEAD -- crates/mfact-core/src/validate.rs`; `stat -f "%Sm %N"` on
  both validate.rs and .mfact/known-persistent-drift.txt; `grep -n validate.rs` against a
  sorted copy of the baseline
- Verdict: CONFIRMED
- Evidence: `git diff --stat HEAD -- crates/mfact-core/src/validate.rs` showed a live, real
  diff (10 insertions, 10 deletions), mtime 13:17:12 PDT (53 min before this check).
  validate.rs sits on line 11 of the sorted known-persistent-drift.txt baseline (baseline
  mtime 08:46:30, ~5.5h stale at check time). Because `comm -23` only reports paths present
  in `git status` but absent from the baseline, this path can never surface as a collision
  no matter what content lands there -- confirmed directly: it did not appear in either
  comm-23 run in PQ6 despite being actively dirty. Correction, established immediately after
  this finding was filed: validate.rs's dirtiness traces to pre-existing drift already
  tracked at pass 15 (PO5's stable tracked-`M` set, PO8's baseline diff), not a fresh rogue
  edit from a live third writer -- this specific instance is not an unresolved alarm. The
  structural gap itself (path-only diffing cannot see content changes on an already-known
  path) is real and general, and stands independent of that correction.
- Severity: major

### PQ2 -- a latent 3-way write convergence on PRAXIS_SELF_AUDIT.md/GAP_LEDGER exists,

- Lens: multi-workflow-concurrency-safety
- Claim: wsr99yw42's and wnz6xi5ce's declared write-sets do not overlap on any single file,
  but a real three-way convergence risk exists one level up: wsr99yw42's declared set
  includes PRAXIS_SELF_AUDIT.md and GAP_LEDGER_v26.7.12.md, the same two files this
  recurring audit loop and the recurring fix loop both also write, with no lock between any
  of the three beyond git commit ordering.
- Source: direct comparison of the two declared write-sets from this pass's own briefing
  (TaskList returned no tasks, so no independent task-inspection was available); `git diff
  HEAD -- PRAXIS_SELF_AUDIT.md GAP_LEDGER_v26.7.12.md AGENTS.md`; `git log -1 --format="%H
  %ci" 5ee8573`; MFACT_SELF_IMPROVEMENT_LOOP.md's own STEP 1 description
- Verdict: CONFIRMED
- Evidence: the two declared sets (wsr99yw42: docs/TESTING_ATLAS_INTEGRATION.md, AGENTS.md,
  .claude/agents/*.md, procint/ProcInt/Playground/SOC2/*.lean, GAP_LEDGER_v26.7.12.md,
  PRAXIS_SELF_AUDIT.md; wnz6xi5ce: RELEASE_v26.7.13_ARD.md, RELEASE_v26.7.13_PRD.md) are
  disjoint -- no direct overlap between the two named workflows. But PRAXIS_SELF_AUDIT.md
  was byte-identical to HEAD (commit 5ee8573, 2026-07-13 13:21:37 -0700, "pass 15" --
  confirmed via empty `git diff HEAD` output and matching line counts, 4439 both sides) at
  check time, i.e. this audit session had to append pass 17 to the exact file wsr99yw42 was
  mid-appending pass 16 to, in the same ~30-45 min window, and MFACT_SELF_IMPROVEMENT_LOOP.md
  itself states the fix loop "picks one open item from GAP_LEDGER_v26.7.12.md /
  PRAXIS_SELF_AUDIT.md ... per firing" -- a third potential writer of the same two files. No
  corruption had occurred as of check time (both files clean), but this is a latent 3-way
  race the 2-workflow framing does not capture.
- Severity: major

### PQ3 -- firings 7-11: 4 COLLISION, 1 SUCCESS, every firing reached a terminal state,

- Lens: cron-loop-health
- Claim: Of the last 5 fix-loop firings recorded in MFACT_SELF_IMPROVEMENT_LOOP.md's Run
  log (firings 7-11), 4 were COLLISION (7, 8, 9, 11) and 1 was SUCCESS (firing 10, G11
  closure). No firing in this window was a deferred/incomplete firing -- every one reached a
  terminal COLLISION-or-SUCCESS state with a written receipt.
- Source: MFACT_SELF_IMPROVEMENT_LOOP.md lines 217-297 (Run log entries for firings 7-11),
  freshly read in full this pass (file is 297 lines total, ends immediately after firing
  11's entry)
- Verdict: CONFIRMED
- Evidence: firing 7 (20260713T182657Z): COLLISION, Waves 6/7 mid-integration. Firing 8
  (20260713T185704Z): COLLISION, ROADMAP_SOC2_MATH.md pending scope-correction. Firing 9
  (20260713T192656Z): COLLISION, SOC2 flow-test workflow wfigivqnl in progress. Firing 10
  (20260713T200505Z): SUCCESS, G11 closure, commit 108bf5b. Firing 11 (20260713T202733Z):
  COLLISION, wup6bpemk (Lean-testing workflow) mid-flight. Cross-checked against git log:
  `chore(loop)` commits stop cleanly at firing-11 (9f84501), one commit per firing, no gaps
  or reordering.
- Severity: major

### PQ4 -- firing 12 of the fix loop does not exist anywhere in the live repository,

- Lens: cron-loop-health
- Claim: Firing 12 of the fix loop does not exist anywhere in the live repository -- not in
  the Run log, not as a git commit, not as a receipt file.
- Source: fresh reads of MFACT_SELF_IMPROVEMENT_LOOP.md (297 lines, ends at firing 11);
  `git log --all --oneline -i --grep="firing.12|firing-12|firing12"` (empty); `git log
  --oneline -i --grep="chore(loop)"` (13 commits, latest is firing-11's 9f84501); `ls
  /Users/sac/mfact/.mfact/receipts/`
- Verdict: CONFIRMED
- Evidence: the Run log's last entry is firing 11 (run 20260713T202733Z, COLLISION). `git
  log --all` finds zero commits mentioning firing-12 in any form. The full chronological
  list of `chore(loop)` commits runs firing-1 through firing-11 with no gap and no entry
  beyond. This directly corroborates the premise that firing 12 was interrupted before
  completing.
- Severity: major

### PQ5 -- no receipt with run_id 20260713T205640Z exists; firing 12 remains open,

- Lens: cron-loop-health
- Claim: No receipt with run_id 20260713T205640Z exists in .mfact/receipts/ or anywhere in
  the repository -- firing 12 remains an open loose end, not closed out.
- Source: `ls -la /Users/sac/mfact/.mfact/receipts/` (13 dated receipts + latest.json, none
  matching) and `grep -rl "20260713T205640Z" /Users/sac/mfact` run repo-wide, re-run fresh
  immediately before filing this finding
- Verdict: CONFIRMED
- Evidence: the receipts directory's 13 dated files run 20260713T071516Z through
  20260713T211642Z with no 20260713T205640Z entry; a full-repository grep for that exact
  string returns zero matches (exit code 1) on both an initial check and a fresh re-check.
  This is consistent with the interruption happening at STEP 1 (collision-guard check)
  before STEP 2-7's receipt-writing step ever ran -- if the loop's own design writes the
  receipt late in its STEP sequence, an interruption before that step leaves no artifact by
  design, not by data loss.
- Severity: major

### PQ6 -- a live comm-23 diff caught a new path materializing mid-pass,

- Lens: multi-workflow-concurrency-safety
- Claim: Live `git status --porcelain`, diffed via `comm -23` against
  .mfact/known-persistent-drift.txt, contains real new-since-baseline paths -- including one
  that materialized mid-pass, proving wsr99yw42 was actively writing during this audit
  window, not merely claimed to be.
- Source: `git status --porcelain | sort` vs `sort -u .mfact/known-persistent-drift.txt`,
  diffed with `comm -23`, run twice ~4 minutes apart; plus `find . -iname
  TESTING_ATLAS_INTEGRATION*` and `stat -f %Sm` on the result
- Verdict: CONFIRMED
- Evidence: the first comm-23 (14:10:47 PDT) returned exactly 2 lines: release/certify.log,
  release/certify.stderr (mtime 14:10:41-42, written 5-6s before that check). The second
  comm-23 (14:15:xx PDT) returned 3 lines: the same two plus
  docs/TESTING_ATLAS_INTEGRATION.md (mtime 14:15:08 -- this file did not exist at 14:10:47,
  when `ls -la` on it returned "No such file or directory").
  docs/TESTING_ATLAS_INTEGRATION.md is literally named in wsr99yw42's declared write-set, so
  the comm-23 guard correctly flagged it as new -- the mechanism is not blind to this case.
  release/certify.log's content and path suggest release-certification tooling plausibly
  invoked by wnz6xi5ce's RELEASE_v26.7.13 work, but neither certify.log nor certify.stderr is
  in wnz6xi5ce's literally-declared write-set -- a genuine ambiguous-ownership path, owned by
  inference, not declaration.
- Severity: minor

### PQ7 -- the guard fired for real and correctly attributed a third, unnamed workflow,

- Lens: multi-workflow-concurrency-safety
- Claim: The delta-based collision guard was actually fired this session (not merely
  designed) and correctly caught a real concurrent-workflow collision -- for a third,
  unnamed-in-this-brief workflow (task wup6bpemk), whose output has since committed cleanly.
- Source: `cat /Users/sac/mfact/.mfact/receipts/latest.json` (run_id 20260713T202733Z);
  `git status --porcelain -- procint/ProcInt/Playground.lean
  procint/ProcInt/Playground/Glue/OrientedSwapReplay.lean`; `git log -2 --oneline --
  procint/ProcInt/Playground/Glue/OrientedSwapReplay.lean`
- Verdict: CONFIRMED
- Evidence: latest.json: status="failed", collision=true, collision_paths=
  ["procint/ProcInt/Playground.lean",
  "procint/ProcInt/Playground/Glue/OrientedSwapReplay.lean"], collision_note explicitly
  attributes them to task wup6bpemk's "still-running 10-agent Lean-testing-landscape
  workflow" and correctly self-resolves a false positive on Cargo.lock by checking it
  against an already-committed change. Both flagged paths were clean (empty `git status
  --porcelain`) and committed at 84ab3de. This firing's timestamp (20:27:33Z, ~46-50 min
  before this check) means at least 3 concurrent uncommitted workflows coexisted this
  session at various points, not merely the 2 named in this pass's brief -- the guard
  handled that instance correctly when the touched paths were outside the baseline.
- Severity: minor

### PQ8 -- the next firing time cannot be pinned to a precise minute from evidence,

- Lens: multi-workflow-concurrency-safety
- Claim: Whether the CRON-driven fix loop's next firing lands while wsr99yw42/wnz6xi5ce are
  still mid-flight cannot be pinned to a precise minute -- firing intervals observed this
  session vary 22-49 minutes around the nominal 30-min cadence, and there is no live OS
  process for the loop to inspect directly.
- Source: `ls -la /Users/sac/mfact/.mfact/receipts/*.json` (run_id timestamps); `date`
  (re-run twice, 14:10:47 and 14:14:59/14:15 PDT); `ps aux | grep -i
  "mfact\|fix.loop\|stuck_item_guard"`
- Verdict: UNVERIFIABLE
- Evidence: recent real run_ids (UTC) show gaps of 38m09s and 22m28s around the 19:26:56,
  20:05:05, 20:27:33 firings -- materially off a fixed 30-min cadence. The latest real
  receipt (run_id 20260713T202733Z) was ~48-50 min old at this check with no newer receipt
  file present, and `ps aux` showed no fix-loop/stuck_item_guard process (only unrelated
  vite/esbuild processes) -- consistent with the loop being externally/session-triggered
  rather than a standing local daemon, so its next firing time cannot be read off any live
  process table. A firing landing mid-flight of the two active workflows this pass is
  plausible but not confirmable at a specific minute from static evidence alone.
- Severity: minor

### PQ9 -- whether wsr99yw42/wnz6xi5ce are still running cannot be confirmed by any tool,

- Lens: multi-workflow-concurrency-safety
- Claim: This agent has no independent tool-level way to confirm wsr99yw42/wnz6xi5ce are
  still actually running at check time (as opposed to already finished writing everything
  they will write) -- their existence and write-sets are known only from this pass's own
  briefing text, not from a live task-inspection call.
- Source: TaskList tool call
- Verdict: UNVERIFIABLE
- Evidence: TaskList returned "No tasks found", so neither wsr99yw42 nor wnz6xi5ce was
  visible through the Task tool available to this agent. Circumstantial, freshly-gathered
  evidence partially corroborates continued activity for wsr99yw42 specifically
  (docs/TESTING_ATLAS_INTEGRATION.md appeared on disk between two git-status checks 14:10:47
  and 14:15:08 PDT during this very pass, matching its declared deliverable), but AGENTS.md,
  .claude/agents/*.md, and the three procint/ProcInt/Playground/SOC2/*.lean files also in
  its declared set were already clean/committed (via commits 4fabb1c and 84ab3de
  respectively), so parts of wsr99yw42's declared scope had already landed while other parts
  were still being produced live. No comparable direct evidence was found for wnz6xi5ce
  (neither RELEASE_v26.7.13_ARD.md nor RELEASE_v26.7.13_PRD.md exists anywhere in the
  working tree or git history yet, per `find . -iname RELEASE_v26.7.13*`).
- Severity: minor

### PQ10 -- the 80% collision rate is expected steady-state, not the old v1/v2 flaw,

- Lens: cron-loop-health
- Claim: The 80% collision rate in the last 5 firings is not evidence of a
  broken/miscalibrated collision guard -- it is the expected steady-state behavior of the v3
  delta-based guard while this session runs many concurrent construction workflows, not a
  repeat of the v1/v2 false-positive design flaw the guard was already redesigned to fix.
- Source: MFACT_SELF_IMPROVEMENT_LOOP.md, Collision guard section (lines 98-111) plus Run
  log firings 3 and 6-11
- Verdict: CONFIRMED
- Evidence: each of the 5 collisions in the full log (firings 1, 2, 6, 7, 8, 9, 11) is
  attributed to a distinct, named, concurrently-launched workflow (task IDs w3xrg1r0m,
  wkw4npeny, w3uu76xt9, wfigivqnl, wup6bpemk) rather than to the same static uncommitted
  pile repeatedly -- the latter was the actual v1/v2 flaw, explicitly fixed by the v3
  delta-against-baseline redesign (firing 3 is documented as "the first clean pass" after
  that fix). Firings 3, 4, 5, and 10 all demonstrate the guard passing cleanly when no
  concurrent work happens to be mid-flight at check time, so the guard is discriminating,
  not stuck. This session has at least 2 more background workflows active (wsr99yw42,
  wnz6xi5ce per this pass's own briefing) beyond everything already named in the log, so
  continued high collision rates are the expected consequence of workflow density, not a
  guard defect. This verdict rests on the log's own internally-consistent, per-firing
  attribution reasoning; historical git/task states were not independently reconstructed to
  re-verify each attribution, since those are past states not re-checkable live.
- Severity: minor

### PQ11 -- the newest-timestamped receipt is a backfill, not firing 12; its clock lies,

- Lens: cron-loop-health
- Claim: The most-recent-by-content-timestamp receipt, 20260713T211642Z.json, is not firing
  12 and not a numbered loop firing at all -- it is a same-session backfill receipt for
  out-of-band audit-driven work (the G11 follow-up fix), and its embedded run_id/timestamp
  field is internally inconsistent with when the file was actually created.
- Source: /Users/sac/mfact/.mfact/receipts/20260713T211642Z.json, git commit 208b9dc, and
  `stat` on the file, all checked fresh this pass
- Verdict: CONFIRMED
- Evidence: git commit 208b9dc that created this file is titled "chore(loop): backfill
  commit_sha for G11 follow-up receipt (5608deb)" at 2026-07-13T13:25:09-0700 (=20:25:09Z);
  `stat` on the file independently shows mtime 2026-07-13T13:25:05-0700 (=20:25:05Z). Both
  agree the file was actually written around 20:25Z. But the JSON's own run_id/timestamp
  fields say "20260713T211642Z" / "2026-07-13T21:16:42Z" -- about 51 minutes later than its
  real creation time, and this receipt's real write-time (20:25Z) is even earlier than
  firing 11's own receipt (20260713T202733Z.json, written 20:27:43Z), matching the Run log's
  firing-11 narration that this G11 follow-up fix happened "outside this firing" beforehand.
  The receipt-writer's timestamp source for backfilled receipts appears decoupled from
  actual write time -- a minor data-hygiene gap worth a future firing's attention, separate
  from the firing-12 question.
- Severity: minor

### PQ12 -- real kernel-level sorry count is 0 and flat; raw metric is mostly doc prose,

- Lens: sorry-axiom-trend
- Claim: Real, kernel-level sorry count in procint/ProcInt is 0 and flat for the entire
  session (not trending up or down) -- the metrics-history.jsonl sorry_count field
  (16,16,16,23,23) is a raw-substring-grep proxy that is almost entirely doc-comment
  mentions of the word "sorry" (e.g. "No `sorry`."), not actual unproved tactic blocks.
- Source: fresh grep plus a comment/string-aware parse of /Users/sac/mfact/procint/ProcInt
  at HEAD f735022, vs /Users/sac/mfact/.mfact/metrics-history.jsonl
- Verdict: CONFIRMED
- Evidence: a naive `grep -rn sorry procint/ProcInt --include=*.lean` (excluding lines
  starting with `-- ` or `/-`) returns 22 hits; manually inspecting all 22 shows every one
  is prose inside a `/-- -/` doc block (continuation lines that don't carry a comment-marker
  prefix themselves), e.g. "No `sorry`. The `TenancyCountermodel`...". A pass that strips
  `/- -/` and `--` comments properly (tracking nesting, preserving line numbers) while
  keeping string literals finds exactly 1 remaining hit:
  procint/ProcInt/Playground/Swarm11Verifier.lean:182, `IO.println s!"sorry-bearing decls :
  {receipt.sorryDeclarationCount}"` -- a string label, not a tactic. Real sorry-tactic count
  = 0.
- Severity: minor

### PQ13 -- recorded sorry_count values are correct per their own raw-grep methodology,

- Lens: sorry-axiom-trend
- Claim: The recorded sorry_count values in metrics-history.jsonl are internally correct per
  their own documented methodology (raw grep, no kernel check) -- reproducible exactly at
  each historical commit.
- Source: /Users/sac/mfact/.mfact/metrics-history.jsonl cross-checked against
  MFACT_SELF_IMPROVEMENT_LOOP.md:159 and git history
- Verdict: CONFIRMED
- Evidence: `git grep -c sorry <rev> -- procint/ProcInt` summed per-file at
  eabe589/c636fd3/0639081 = 16, 16, 16; at 108bf5b/5608deb = 23, 23. Matches
  metrics-history.jsonl's sorry_count field exactly at each corresponding git_head. The doc
  itself discloses this is "raw grep across procint/ProcInt, not a kernel-level check"
  (MFACT_SELF_IMPROVEMENT_LOOP.md:159), so the metric is not mislabeled -- but see PQ14 for
  the interpretation risk.
- Severity: minor

### PQ14 -- the 16-to-23 sorry_count jump is new "No sorry" prose, not new proof debt,

- Lens: sorry-axiom-trend
- Claim: The apparent sorry_count regression from 16 to 23 between commits 0639081 and
  108bf5b is entirely an artifact of new "No sorry" documentation being added for
  newly-proven theorems, not new proof debt -- a reader trusting the raw trend number alone
  (without the loop's prose disclaimer) would misread this as things getting worse.
- Source: `git diff 0639081 108bf5b -- procint/ProcInt`
- Verdict: CONFIRMED
- Evidence: all 7 added "sorry"-matching lines in that diff are prose: "No `sorry`. The
  `TenancyCountermodel`..." (Tenancy.lean:53), "No `sorry`. This is..."
  (CrownWellFounded.lean:295), "No `sorry`." (MultisetDescent.lean:447), "no
  `sorry`/`admit`." (RankOrder.lean:619), "no `sorry`/fake" and "no `sorry`, no"
  (AuditFlowViolation.lean:1583,1587), "`sorry`):**" (OrientedSwap.lean:2377). None are
  actual sorry tactics; the independently-verified real count stayed at 0 across this range.
- Severity: minor

### PQ15 -- lake_build_pass:true for 5608deb is backed by a real full-workspace build,

- Lens: sorry-axiom-trend
- Claim: lake_build_pass:true for the metrics-history line at git_head 5608deb (receipt
  20260713T211642Z) is substantiated by a fresh, explicit full-workspace Lean build in that
  firing's own record.
- Source: /Users/sac/mfact/.mfact/receipts/20260713T211642Z.json
- Verdict: CONFIRMED
- Evidence: verify_delta.after states: "Full just build (Lean workspace, unaffected by this
  Rust-only change): 8614+8577+22 jobs, all clean." This directly backs the
  lake_build_pass:true claim recorded for this timestamp/commit in metrics-history.jsonl.
- Severity: minor

### PQ16 -- lake_build_pass:true for two earlier git_heads is not substantiated in-receipt,

- Lens: sorry-axiom-trend
- Claim: lake_build_pass:true for the metrics-history lines at git_head eabe589 (receipt
  20260713T163130Z, G49) and git_head 0639081 (receipt 20260713T173045Z, G51) is not
  independently substantiated by those firings' own receipts -- neither verify_delta
  contains any Lean/lake build evidence, only Rust-side cargo/clippy checks.
- Source: /Users/sac/mfact/.mfact/receipts/20260713T163130Z.json and
  /Users/sac/mfact/.mfact/receipts/20260713T173045Z.json
- Verdict: UNVERIFIABLE
- Evidence: 20260713T163130Z verify_delta: "cargo check --bin turbulence... cargo run --bin
  turbulence..." (no lake/lean mention). 20260713T173045Z verify_delta: "just clippy-core:
  exit 0 clean... injected dbg!..." (no lake/lean mention). No script in the repo (scripts/,
  .claude/) was found that programmatically computes and appends lake_build_pass to
  metrics-history.jsonl, so for these two firings the true/false value appears to be
  self-reported rather than freshly re-derived; plausible given neither firing touched Lean
  files, but not evidenced in the record itself.
- Severity: minor

## Pass 18 findings

### PR1 -- known-persistent-drift.txt causes no new drift right now, but stays stale,

- Lens: wave4-closure-reverify
- Claim: `.mfact/known-persistent-drift.txt` is many hours stale (single original write,
  never refreshed) and running the fix loop's exact delta check against current git
  status will reveal "new" paths that are actually old/legitimate/already-committed
  session output being miscategorized.
- Source: orchestrator-provided task context / user check (2); `git status --porcelain |
  sed -E "s/^.{3}//" | sort | comm -23 - .mfact/known-persistent-drift.txt`, re-run live
  this pass
- Verdict: REFUTED
- Evidence: the exact specified `comm -23` command returned empty output -- zero "new"
  paths. The drift file is confirmed genuinely stale (single commit 1e47b87 at
  2026-07-13 08:46:41, ~6h16m old at check time 15:02:21) but is currently a SUPERSET of
  live git status (76 lines vs 62), not a subset: 14 paths listed in the drift file
  (crates/mfact-core/*.rs, MFW_WORKFLOW_CATALOG.md, ROADMAP*.md) have since been
  committed and are now clean, so the tree got cleaner than baseline rather than
  drifting further. The premise that the gap has "grown" and produced newly
  miscategorized paths does not hold up under direct re-execution. Freshness caveat:
  release/certify.log.bak (a harmless build-artifact backup from a certify rerun, not
  gitignored) has since appeared as one new untracked path -- it does not overturn this
  REFUTED verdict, since it postdates the check and the check itself already came back
  empty.
- Severity: major

### PR2 -- Wave 4a/4b/4c's three closure commits landed exactly as expected, stable,

- Lens: wave4-closure-reverify
- Claim: Wave 4a/4b/4c (GAP_LEDGER_v26.7.12.md G52/G53 entry, PRAXIS_SELF_AUDIT.md Pass
  16 append, MFACT_SELF_IMPROVEMENT_LOOP.md firing-12 backfill) will land as 1-3 more
  commits shortly and should not be treated as stable until confirmed.
- Source: orchestrator-provided task context; `git log`
- Verdict: CONFIRMED
- Evidence: `git log` shows all three landed as real commits before HEAD: bd7ea3e
  (2026-07-13 14:45:59, GAP_LEDGER_v26.7.12.md), d111cb2 (2026-07-13 14:52:24,
  PRAXIS_SELF_AUDIT.md), a334ff5 (2026-07-13 14:56:08, MFACT_SELF_IMPROVEMENT_LOOP.md);
  HEAD at check time (b2f5b0e) sat several commits past all three, so they were safe to
  treat as stable/landed.
- Severity: minor

### PR3 -- RELEASE_v26.7.13 docs predate the SOC2 standing-path witness, not a defect,

- Lens: wave4-closure-reverify
- Claim: RELEASE_v26.7.13_ARD.md and RELEASE_v26.7.13_PRD.md (0a11ad0, corrected
  4f654d5) are stale/incomplete re: the SOC2 standing-path witness and axiom-audit
  work, since that work landed after these docs were written.
- Source: orchestrator-provided task context / user check (1); commit timestamps and a
  grep of both files for SOC2 standing-path terms
- Verdict: CONFIRMED
- Evidence: commit timestamps show 0a11ad0=14:20:02 and 4f654d5=14:24:49 (ARD-only
  correction), both before e590d1b=14:25:39 (axiom-audit SOC2 crown) and
  c481ecd=14:38:42 (StandingPathSOC2.lean T132/T133 witness). Grepping both files finds
  zero mentions of StandingPathSOC2/Eleven-Witness Standing Path/T132/T133 in either.
  The ARD does mention AxiomAuditSOC2.lean (~lines 248-256) but only as an untracked,
  growing artifact it explicitly declines to characterize further ("exists, untracked,
  growing"), predating e590d1b's actual commit. Not a defect -- the ARD is self-aware of
  its own staleness on this point, and neither doc could have known about
  StandingPathSOC2 since it did not exist yet.
- Severity: minor

### PR4 -- StandingPathSOC2.lean proves the SOC2 crown is partial, never claims complete,

- Lens: soc2-standing-path-soundness
- Claim: StandingPathSOC2.lean's `complete` field/theorem claims full completeness
  (`admitted = required`) for the SOC2 crown, despite M_e/M_u/F/S rows being only
  PARTIAL per the earlier dry-run.
- Source: /Users/sac/mfact/procint/ProcInt/Playground/SOC2/StandingPathSOC2.lean (lines
  32-39, 260-272, 284-296, 340-349)
- Verdict: REFUTED
- Evidence: the file explicitly does not claim `admitted = required`. Its header states
  "admitted ⊂ required ... is what this file proves -- not admitted = required."
  `theorem admitted_ssubset_required` (line 263) proves a proper subset. `theorem
  missing_eq_exact_rows : missing = {rowMe, rowMu, rowF, rowS} := by decide` (line 270)
  names exactly the four open rows matching the dry-run finding. The template's
  `StandingPathReceipt` structure with its `complete : admitted = required` field is
  reproduced (lines 292-296) but deliberately never instantiated -- the docstring at
  lines 284-291 says explicitly that no honest value of `StandingPathReceipt` for the
  SOC2 crown exists yet, and none is fabricated with a sorry/decide-forced `complete`
  field. Instead a `StandingPathStatus` struct with `notComplete := admitted_ne_required`
  is instantiated as `soc2Status` (lines 301-319), and
  `soc2CrownAliveClaim.authorized = false` is also proved (line 349). No overclaim
  exists; the file's claims match the true partial crown state.
- Severity: minor

### PR5 -- AxiomAuditSOC2.lean's twenty guard/print-axioms pairs still hold fresh,

- Lens: soc2-standing-path-soundness
- Claim: AxiomAuditSOC2.lean's twenty `#guard_msgs in #print axioms` pairs (Wave 3a,
  commit e590d1b) still match on a fresh build, i.e. the axiom pins are not stale.
- Source: `just _lake "cd procint && /Users/sac/.elan/bin/lake build
  ProcInt.Playground.SOC2.AxiomAuditSOC2"`, freshly re-run this pass
- Verdict: CONFIRMED
- Evidence: the fresh `lake build` completed successfully ("Build completed
  successfully (738 jobs)") with only two pre-existing unused-variable linter warnings
  in an unrelated file (RuntimeReplay.lean:58,96), no errors. Per the file's own
  docstring (lines 22-28), any mismatched axiom set or sorry-tainted theorem among the
  twenty audited targets would fail the build rather than silently pass, so build
  success is direct evidence all twenty pairs still hold. StandingPathSOC2 itself was
  also independently rebuilt fresh (740 jobs, success), confirming its `#check`
  references and decide-closed theorems still type-check.
- Severity: minor

### PR6 -- Wave 4a/4b/4c's three files are committed and clean, not still in flight,

- Lens: soc2-standing-path-soundness
- Claim: Wave 4a/4b/4c edits to GAP_LEDGER_v26.7.12.md, PRAXIS_SELF_AUDIT.md, and
  MFACT_SELF_IMPROVEMENT_LOOP.md have landed as committed, stable content, not to be
  treated as stable until personally confirmed.
- Source: `git log --oneline` and `git status --short` for this repo
- Verdict: CONFIRMED
- Evidence: `git status --short` shows no uncommitted changes to any of the three files.
  `git log` confirms: PRAXIS_SELF_AUDIT.md Pass 16 landed in d111cb2 ("docs(audit):
  append Pass 16 self-audit (PP1-PP17)..."); GAP_LEDGER_v26.7.12.md G52/G53 landed in
  bd7ea3e ("docs(ledger): add G52 ... and G53 ..."); firing-12 backfill landed in
  a334ff5 ("chore(loop): backfill firing-12 deferred receipt (plan-mode block)"). All
  three are safe to treat as stable.
- Severity: minor

### PR7 -- GAP_LEDGER G53 documents the soundness gap as honestly OPEN, no overclaim,

- Lens: release-docs-and-drift-baseline
- Claim: GAP_LEDGER_v26.7.12.md's highest entry (G53) documents the
  ManufactureTenancyGap soundness gap honestly as OPEN, and G52 documents the
  testing-atlas integration as CLOSED without overclaiming the SOC2 crown's standing
  path as complete.
- Source: /Users/sac/mfact/GAP_LEDGER_v26.7.12.md lines 1085-1230 (G52, G53); `git show
  bd7ea3e`
- Verdict: CONFIRMED
- Evidence: G52 (line 1085) explicitly states "Honest result, stated without rounding
  up: complete came out FALSE" with required=10, admitted=6, four rows (M_e, M_u, F, S)
  left open, and explicitly defers closing G53 to future work. G53 (line 1170) is
  Status: OPEN, cites concrete Lean evidence (ManufactureTenancyGap.lean, commit
  84ab3de), scopes the gap correctly as not a ManufactureStep contract defect, and
  offers two candidate fixes without claiming either is applied. No G-number beyond G53
  exists in the file. Commit bd7ea3e (2026-07-13 14:45:59 -0700) was already on HEAD at
  check time, not still pending.
- Severity: minor

### PR8 -- firing-12's deferred receipt exists with a genuinely new status value,

- Lens: release-docs-and-drift-baseline
- Claim: Firing-12's deferred receipt exists at
  `.mfact/receipts/20260713T205640Z.json` with a status other than
  success/failed/partial/no_op, since the firing never reached STEP 2.
- Source: /Users/sac/mfact/.mfact/receipts/20260713T205640Z.json
- Verdict: CONFIRMED
- Evidence: the file exists with `status: "deferred"`, `gap_id: null`, `commit_sha:
  null`, `collision: false`, and a note explaining STEP 0/1 ran clean but the
  coordinating session was in plan mode so STEPS 2-7 never ran. This is a genuinely new
  status value, distinct from the loop's other terminal statuses.
- Severity: minor

### PR9 -- both Wave 4 doc appends are committed, not working-tree drafts,

- Lens: release-docs-and-drift-baseline
- Claim: MFACT_SELF_IMPROVEMENT_LOOP.md and PRAXIS_SELF_AUDIT.md both received their
  Wave 4 appends (firing-12 run-log bullet; Pass 16 PP1-PP17 findings) and both are
  already committed, not still in flight.
- Source: /Users/sac/mfact/MFACT_SELF_IMPROVEMENT_LOOP.md lines 323-343 (commit
  a334ff5); /Users/sac/mfact/PRAXIS_SELF_AUDIT.md lines 4499-4828 (commit d111cb2)
- Verdict: CONFIRMED
- Evidence: `git log` shows both commits on HEAD (a334ff5 at 14:56:08, d111cb2 at
  14:52:24, both 2026-07-13 -0700), and neither file appears in `git status
  --porcelain` as modified/dirty, meaning these are the stable committed versions, not
  working-tree drafts. Pass 16's PP5 finding (line 4582) accurately describes the
  pre-G53 state as historical fact rather than being silently edited after G53 landed.
- Severity: minor

### PR10 -- ExperimentalWalkthrough.lean:56 is a negative test, not a sorry; count is 0,

- Lens: release-docs-and-drift-baseline
- Claim: One pre-existing `sorry` remains at ExperimentalWalkthrough.lean:56
  (`rawToPlan.seq`), surfaced as unrelated pre-existing debt during a fresh full
  testing-atlas / SOC2 Playground build (`just _lake "cd procint &&
  /Users/sac/.elan/bin/lake build ProcInt.Playground"`), consistent with the loop's
  tracked sorry-count baseline (22/23) cited in commit a334ff5's message.
- Source: `just _lake "cd procint && /Users/sac/.elan/bin/lake build
  ProcInt.Playground"` (freshly re-run this pass); ExperimentalWalkthrough.lean:56;
  repo-wide `grep -rnw sorry procint/ProcInt` (excluding `.lake`), re-run for this
  correction
- Verdict: REFUTED
- Evidence: the build itself does succeed cleanly -- "Build completed successfully
  (8714 jobs)," exit 0 -- so that half of the original claim is not in question. But
  ExperimentalWalkthrough.lean:56 is not a `sorry`: it is a `#guard_msgs(error) in ...`
  negative test, i.e. deliberately-asserted expected-error test scaffolding, not an
  unproved tactic obligation. A repo-wide `grep -rnw sorry` over `procint/ProcInt`
  (excluding `.lake`) finds zero actual `sorry` tactic invocations. The originally
  cited "22/23 tracked sorry baseline" figure is itself a raw-substring-grep proxy
  dominated by doc-comment prose (see Pass 17's PQ12-PQ14, which already established
  the true kernel-level sorry count is 0 and flat); this specific line-56 attribution
  compounds that known proxy error with a wrong line reference, and is corrected here
  rather than transcribed.
- Severity: minor

## Pass 19 findings

Pass 19 ran as a 7-agent read-only workflow (wf_e538e8d0-420) targeting the load-bearing
claims of the six-lens Operation Dogfood coverage audit — the premises the newly approved
construction plan builds on — plus the standard sweep of commits since Pass 18. Totals:
31 findings, 20 VERIFIED, 0 REFUTED, 11 PARTIAL. Full per-claim evidence is the workflow
journal (`~/.claude/projects/-Users-sac-mfact/.../workflows/wf_e538e8d0-420/journal.jsonl`);
material findings are transcribed below, batch confirmations compressed into PS1.

### PS1 -- Twenty coverage-audit premises confirmed against the live tree,

- Lens: dogfood-coverage-premise-verify (bundles A-E + inventory)
- Claim: batch confirmation of the plan's premises.
- Source: Pass 19 workflow journal; each verified by adversarial re-derivation
- Verdict: CONFIRMED
- Evidence: verified verbatim against the tree: `validCheck` bare Bool (Pddl.lean:50); no
  five-constructor outcome inductive anywhere in procint (zero `inconsistent` matches
  repo-wide); two near-duplicate Standing inductives (Swarm11 + Experimental); `MayStart`
  defined and never consumed by any theorem; `completeStep` docstring excludes
  MayStart enforcement (RuntimeReplay.lean:33-37); `s0.authorized := fun _ => True` is the
  sole `authorized` instantiation site in the repo; no `completed ∧ ¬authorized` theorem
  anywhere; `zero_unreceipted_completion` is field-unpacking by construction;
  test_expand.lean orphan (tracked, unbuilt, `expandLayer_bounds_strictly` at :38);
  Pddl.lean exactly 1 theorem / Powl.lean exactly 4; zero import edges Termination↔
  Planning/Powl; SemanticBridge + Graph/Semantic imported nowhere (latter untracked);
  ggen chain zero public vocab (12 prefixes, 0 hits incl. full-IRI check); no namespace
  report; no Lean `Injective` dressing of the blake3 fold; verifier JSON 5+24 checks 0
  failures admitted:true; certify.log:2394 + standing.env CERTIFIED_RELEASE=PASS; all 5
  firing receipts present with cited SHAs resolving; zero drift delta vs baseline; only
  2 commits since Pass 18, both session-attributable, no foreign actor.
- Severity: minor

### PS2 -- fortune5-cloud-architecture.ttl is git-tracked, not uncommitted,

- Lens: rdf-ontology-bundle-D
- Claim: the RDF lens report stated the fortune5 ontology was git-untracked/uncommitted.
- Source: `git ls-files ontology/fortune5-cloud-architecture.ttl`; `git log`
- Verdict: REFUTED (stale claim; counts and unwired status confirmed)
- Evidence: the file is tracked and clean, committed in 0956080 ("chore(wave0): vendor
  Fortune-5 cloud ontology, pass-9 self-audit"). The load-bearing parts of the lens claim
  survive exactly: 16 `sh:NodeShape`, 64 `odrl:Permission`, absent from both
  `.mfact/artifacts.toml` and `ggen.lock` (unwired from the provable chain). Consequence
  applied fix-forward: OPERATION_DOGFOOD_LEAN_COVERAGE_v26.7.13.md corrected in the same
  pass window rather than left citing the stale conjunct.
- Severity: minor

### PS3 -- reachable_is_one_of is not part of the finite-exhaustion machinery,

- Lens: outcome-algebra-bundle-A + completeness critic
- Claim: `FiniteExperiment.run`, `run_ne_proven`, and `reachable_is_one_of` together
  constitute genuine finite-model exhaustion machinery.
- Source: Workflow/Countermodel.lean:133-191; Experimental/Experiment.lean:74-119
- Verdict: REFUTED (composition claim; the critic's FLAG-A4 is accepted over the
  verifier's own PARTIAL, which laundered a false conjunct)
- Evidence: `FiniteExperiment.run` is genuinely exhaustive over its declared `worlds`
  list with no fuel parameter, and `run_ne_proven` is real. But `reachable_is_one_of`
  lives in `ProcInt.Workflow.Countermodel`, has no import or dependency relation to
  FiniteExperiment, and is structural induction over an unbounded family
  (`∃ n, M = intermediateMarking n`, n : ℕ) — neither exhaustive enumeration nor a fuel
  bound. Consequence applied fix-forward: Wave 1's exhausted-only-from-finite-closure
  wire targets FiniteExperiment alone; the coverage report was corrected accordingly.
- Severity: major

### PS4 -- CERTIFIED_RELEASE=PASS describes a recorded log, standing caveat kept explicit,

- Lens: recent-commit-bundle-E + completeness critic (FLAG-E3)
- Claim: certify.log's `certified: v26.7.7 (proven 203/401, objection type uninhabited)`
  and standing.env's `CERTIFIED_RELEASE=PASS` witness a currently-reproducing green gate.
- Source: release/certify.log:2394; release/standing.env:14; RELEASE_v26.7.13_PRD.md §1
- Verdict: PARTIAL
- Evidence: the literal file contents are exact matches, but both files are
  modified-uncommitted in the working tree, standing.env's header still says v26.7.6
  (tracked as G6), and RELEASE_v26.7.13_PRD.md §1 contains a stale statement that fresh
  certify fails — written before the 0e99a2b/ca3cf5c manifest fixes landed. Per the
  AGENTS.md "Failure as a Process" scoping, a PASS recorded at observation time is not a
  reproduction claim; re-running `just certify` post-fix is the cheap discharge and is
  left to the release loop rather than claimed here.
- Severity: minor

### PS5 -- Lens-report path and wording caveats, corrected in place,

- Lens: bundles A/C/E precision sweep
- Claim: three lens citations were imprecise.
- Source: Playground/Experimental/Closure.lean; ManufactureTenancy.lean; GAP_LEDGER
- Verdict: CONFIRMED (caveats real, substance intact)
- Evidence: (a) `ClosureRefusal.fuelExhausted` exists exactly as described but at
  `Playground/Experimental/Closure.lean`, not the lens-cited `Experimental/Closure.lean`;
  (b) G53 ledger/commit/theorem cross-check is substantively confirmed (11b03d2, 050d067,
  `TenantPureManufactureStep` :81, `manufactureStep_tenant_pure_of_residue` :103) with a
  wording-level caveat only; (c) ARD bridge-file spot-checks verified "with unusual
  precision" (line-exact theorem locations), PRD spot-checks PARTIAL on the same stale
  certify sentence covered by PS4.
- Severity: minor

### PS6 -- Three unaudited surfaces named for the next pass,

- Lens: completeness critic (CR-1..CR-3)
- Claim: Pass 19's coverage left three risky surfaces unexamined.
- Source: git status --porcelain, re-run at critic time
- Verdict: CONFIRMED (queued, not discharged)
- Evidence: (1) the uncommitted `.ggen-v2/receipt.json` + `receipt-log.jsonl` + dirty
  `ggen.lock` chain has not been fold-replayed against artifacts.toml — a dirty receipt
  chain is exactly where a decisive error precedes observability; (2) ~15 modified
  `research-papers/**/*.lean` files (bio_signals, quantum_hall, random_walk, smfdcca,
  etc.) have had no sorry/axiom/vacuous-tautology sweep since the "mechanically" applied
  countermodel-proof fix commit; (3) the uncommitted `crates/mfact-core/src/validate.rs`
  diff is unexamined and sits in the receipt-verification crate other findings rely on
  transitively. All three are queued for Pass 20.
- Severity: major
