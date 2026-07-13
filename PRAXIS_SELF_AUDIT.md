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

