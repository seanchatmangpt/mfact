# Praxis Dogfooding Exploration

Read-only exploration of `~/praxis` as a build/pack dependency (AGENTS.md section 3),
scoped to its last 1 day of git history (61 commits, all dated 2026-07-12). Prompted by
mfact's own `PRAXIS_SELF_AUDIT.md` self-audit run earlier this session, and by an earlier
turn in this session that declined to interpret a pasted "Global AtomVM Swarm" document
using F02->F19 node-chain and REAL_EDGE/MISSING_EDGE notation because it "belongs to a
repo I am not to enter." That repo is praxis. Every claim below cites a command literally
run or a file:line literally read during this exploration; nothing is taken from a doc
comment or commit message without independent verification where verification was
practical. No files under `~/praxis` were written, edited, or committed to produce this
report — all writes stay inside `~/mfact`.

## 1. Executive summary

The single biggest thing mfact should do differently: before continuing independent Lean
formalization of the Crown/MFW architecture (`ROADMAP_MATH_SPINE.md`, `CLAUDE_ROADMAP.md`),
mfact should explicitly decide and document whether that work specifies praxis's
`multifractal-workflow` crate (already substantially implemented, with 22/23 crown-witness
edges REAL_EDGE and one Lean-proven mutation-testing theorem of its own) or is a
deliberately independent reformulation — because right now the two systems share doctrine,
vocabulary, and even the "A = mu(O*)" opening line with zero citation between them, and
mfact risks re-deriving, from scratch, formal specifications for a system that already
runs. Separately, mfact should adopt praxis's edge-classification vocabulary
(REAL_EDGE/PARTIAL_REAL_EDGE/TEST_ONLY_EDGE/MISSING_EDGE/REFUSED_EDGE) and its per-edge,
commit-cited status-doc discipline as the concrete backing for its own `CausalHole`
predicate, and should treat a genuinely false "VICTORY CONFIRMED" cross-repo delivery claim
found in praxis's own `.agents/handoff.md` as a live warning about trusting any
"independent auditor" agent role, including mfact's own, without a literal `ls`/`find`.

## 2. Findings by category

### ADOPT_TOOL_OR_PATTERN

Concrete tools, patterns, or artifacts mfact should pull in or model itself on.

1. **Edge-status taxonomy as a reusable audit vocabulary.** Praxis classifies every
   call-graph edge in a claimed pipeline as `REAL_EDGE` / `PARTIAL_REAL_EDGE` (data flows,
   one semantic sub-property unsatisfied) / `TEST_ONLY_EDGE` / `MISSING_EDGE` /
   `REFUSED_EDGE` (a correct-by-design refusal, not a gap), each row in
   `docs/jira/v26.7.12/CROWN_STATUS.md` citing a commit hash and file:line. mfact's own
   `CausalHole` predicate (`CLAUDE_ROADMAP.md:815-823`) currently has only two edge states,
   `REAL_EDGE`/`TEST_ONLY_EDGE`. Action: before Lean formalization of this predicate
   proceeds, decide whether `PARTIAL_REAL_EDGE` and `REFUSED_EDGE` are needed as distinct
   third/fourth states, using praxis's worked F10->F12 example
   (`f10_powl_geometry.rs:897`, verified: `build_powl_geometry` never constructs
   `Powl::ExternalCut`, only `to_turtle`'s emit arm does) as the test case.

2. **Per-edge status doc with commit citations, not a one-off audit report.**
   `CROWN_STATUS.md` is updated after nearly every edge-closing commit (16 touches in one
   day) rather than written once. Action: mfact's own POWL/PDDL/Crown-spine correspondence
   work could use the same living-table structure — a durable per-edge REAL/PARTIAL/MISSING
   table tied to commits and file:line — instead of a static, one-off audit doc like
   `PRAXIS_SELF_AUDIT.md`.

3. **Per-module ALREADY_BUILT/REUSE_ADAPT/HAND_WRITE_REQUIRED doc-comment template.** All
   30 `f01..f30` modules in `multifractal-workflow/src/` open with this structure plus an
   explicit "Explicitly NOT done this pass (disclosed, not silently skipped)" section
   (verified in `f01_standing_algebra.rs:1-60`, `f10_powl_geometry.rs:1-97`). Action:
   mfact's Lean/procint files could adopt the same per-module disclosure template for
   finer-grained, ongoing overclaim prevention instead of relying only on periodic
   whole-repo audits.

4. **A machine-readable overclaim vocabulary as a project rule file.**
   `~/praxis/.claude/rules/no-overclaiming.md` fixes six words (ALIVE / PARTIAL / BLOCKED
   cite file:line / MOCKED / REFUSED-UNSUPPORTED / UNVERIFIED-default) plus a forbidden-
   phrase list ("substantially complete," "should work," unscoped "production-ready").
   mfact's `AGENTS.md` section 4 has a parallel vocabulary but scoped only to theorem
   *Standing* (`PROVEN`, `IMPORTED`, `CONJECTURAL`, ...), not to general implementation-
   status claims about scripts, tooling, or file deliveries — exactly the category that
   failed in finding CROSS_REPO_INCONSISTENCY #6 below. Action: add an orthogonal
   ALIVE/PARTIAL/BLOCKED/MOCKED/REFUSED/UNVERIFIED vocabulary to mfact's `AGENTS.md` for
   non-theorem work-status claims.

5. **Git-trailer convention turning `git log` into a queryable audit ledger.**
   `.claude/rules/autonomous-escalation-policy.md` defines `CROWN_FRONTIER_BEFORE/AFTER`,
   `NEW_REAL_EDGES`, `REAL_EDGE_DELTA`, `TESTS`, `IGNORED`, `CLAIM` trailers; confirmed in
   real commits (`git log --grep=CROWN_FRONTIER` returns 1d3b9fb2, 66cb59b1, etc.).
   mfact's `AGENTS.md` section 4 already defines an isomorphic edge taxonomy
   (`DEFINITIONAL`/`PROVEN`/`IMPORTED`/`CORRESPONDENCE`/`CONJECTURAL`/`ANALOGY`/`MISSING`)
   but has no git-level bookkeeping for status flips. Action: adopt an analogous
   `EDGE_FRONTIER_BEFORE/AFTER/CLAIM` trailer convention on commits that change a theorem
   card's Standing field.

6. **A pre-commit/post-edit hook pair for build-tool routing and auto-format.** Praxis's
   `.claude/settings.json` blocks bare `cargo build/test/clippy` (PreToolUse hook, exit 2,
   suggests the matching `just` recipe) and auto-runs `cargo fmt` on edited `.rs` files
   (PostToolUse). mfact's project `.claude/` has zero hooks configured (`ls -la
   /Users/sac/mfact/.claude/` shows only `scheduled_tasks.lock` and `worktrees/`). Action:
   mfact could add an equivalent PreToolUse guard routing Bash calls through its own
   `justfile` recipes rather than relying purely on `AGENTS.md` prose discipline.

7. **A "standing gate" trust-precedence rule, stated explicitly.** Praxis's `AGENTS.md`
   section 2 states: read `standing.json`/`REALITY_INDEX.md` first; regenerate via
   `just standing` if stale; never trust prior-agent summaries or README claims over the
   standing index. mfact has the underlying tooling (`justfile` has `standing:` and
   `certify: build audit` recipes, `STANDING.md` exists) but `AGENTS.md` does not state the
   precedence rule. Given the false "VICTORY CONFIRMED" finding below, this is a concrete,
   small, load-bearing addition: state explicitly that `STANDING.md`/`just standing`
   outranks any prior-agent summary before a readiness claim is made.

8. **`mutation_chain.rs`: hand-rolled mutation operators with named, permanent "survivor"
   tests.** `crates/praxis-core/tests/mutation_chain.rs` (2026-07-02, ~10 days before the
   generic `cargo-mutants` pilot) applies domain-specific mutations (EventDrop, EventReorder,
   FieldFlip, HashTruncate, TimestampSkew) to a receipt-chain fixture, asserts a *staged*
   validator rejects each at the correct stage, and — for known-uncovered mutation classes —
   writes them as explicitly named, permanently-passing "survivor" tests
   (`survivor_head_drop`, `survivor_andon_flip`, ...) instead of omitting them, so a future
   validator change that starts catching a survivor breaks loudly and demands promotion.
   mfact's `CLAUDE_ROADMAP.md` Phase 15 ("Verification ladder") already lists this shape of
   requirement (chaos cases named "event reordering," "duplicate delivery," "receipt
   corruption") with zero implementation. Action: transplant the *structure* (named
   mutations against an OCEL/receipt-chain fixture, staged-validator kill assertions,
   explicit survivor tests) into mfact's own verification ladder.

9. **`thm_kill.lean`: a machine-checked correctness theorem for staged mutation kills.**
   Praxis has proven, in Lean 4, that a staged validator kills a mutant iff it is real and
   always at the correct stage (`thm:kill`). I re-ran this myself rather than trusting the
   receipts file: `cd ~/praxis/tools/paper-factory/lean-pilot && lean thm_kill.lean` exited
   0 with no errors; a second, Mathlib-backed lane exists at
   `tools/paper-factory/lean-lake/Praxis/Corpus/thm_kill.lean`. Action: since mfact is
   Lean-first and praxis's mutation testing is otherwise Rust/`cargo-mutants`-specific, this
   is the one directly portable artifact — adapt the `StagedValidator`/soundness/
   completeness/`kill_correct` formalization as the mathematical backbone for mfact's own
   Phase 15 chaos-test guarantees, giving the verification ladder a proof about its own test
   suite rather than a manual checklist.

10. **Clean-room CI rebuild as a cheap, well-defined gate.** Commit `0e928eb8` fixed a real
    bug class: `rebar3 clean -a` only wipes the active build profile, never `_build/test/`,
    so a stale `.beam` can silently diverge from its current `.erl` source — reproduced live
    as 9 real eunit `undef` failures before the fix. This generalizes directly to Lean's
    `.lake/build` cache and any Rust `target/` dir mfact has. Action: add a periodic or
    pre-merge full clean-room rebuild (wipe `.lake/build`, isolated `target/`) to mfact's
    verification ladder — cheaper and better-defined than mutation testing, and closes a
    class of false-negative risk mfact has not been shown to have checked for.

11. **Adversarial spot-check confirms praxis's own audit convention holds up.** I
    independently re-verified 15 commit hashes cited in `CROWN_STATUS.md` (all exist,
    subjects match) and its one specific file:line claim about `f10_powl_geometry.rs:897`
    (exact match). Praxis's stated convention — "every verdict is tied to a command run this
    session or a file:line read this session" — held under adversarial re-check where
    mfact's own self-audit found real overclaims. Action: adopt the convention as stated,
    not just the vocabulary: every status-doc verdict in mfact should cite a command or
    file:line from the *same session*, not an inherited claim.

### SHARED_CONCEPT_DIVERGENCE

Same name, same doctrinal root, structurally different objects on each side — reconcile
before citing one as evidence for the other.

1. **REAL_EDGE is prose discipline in praxis, a formal predicate in mfact — and mfact's is
   strictly more rigorous but currently unimplemented.** `grep -n
   'enum.*Edge|EdgeStatus'` over `multifractal-workflow/src/*.rs` returns nothing; the
   classification lives entirely in `CROWN_STATUS.md` markdown and doc comments. mfact's
   `REAL_EDGE(A, B) ⟺ ∃ f_prod : B(A(x))` (`CLAUDE_ROADMAP.md:815`) is a genuine formal
   predicate, but has no mechanization (no lint flagging zero-non-test-caller `pub fn`s) and
   zero source files of its own to check it against (`find /Users/sac/mfact -iname
   '*arazzo*'` returns 0 files). Action: mechanize the predicate (a lint) or
   accept it remains, like praxis's version, an audit-by-reading practice — decide which,
   explicitly, rather than leaving the gap implicit.

2. **Praxis's LOCAL crown-witness closure is runtime evidence, not a Crown V discharge.**
   `ROADMAP_MATH_SPINE.md`'s Corollary 21.2 (MFW runtime crown) is explicitly
   `BLOCKED_ON_CORRESPONDENCE` until A10 and the correspondence assumptions are discharged.
   `CROWN_STATUS.md` claims "All 11 of 11 LOCAL edges are REAL_EDGE," backed by one passing
   test with non-vacuous assertions (independently reran:
   `cargo test -p multifractal-workflow
   crown_local_prefix_drives_the_entire_local_witness_end_to_end` → `ok`). `AGENTS.md`
   section 4 already legislates this exact situation ("mfact's own theorem or production
   claims [may not] cite praxis's as evidence without their own admitted correspondence
   morphism"). Action: no theorem-standing upgrade for Corollary 21.2 on the strength of
   praxis's LOCAL witness alone; the correspondence morphism is still new work.

3. **"Crown witness" means categorically different evidentiary standards under the same
   name.** Praxis's `crown_local.rs`/`crown_external.rs` are large Rust production-caller
   drivers verified by adversarial code-reading plus live tests against real Erlang
   subprocesses. mfact's `procint/ProcInt/Playground/Swarm11/Crown.lean` is a small,
   kernel-checked Lean theorem (`sampleEvents_commute`, `by intro state; cases state; rfl`)
   over a toy `Nat × Nat` state. Both are legitimately "closed" in their own repo but are
   not the same rigor. Action: if mfact's paper or docs ever compare "crown witness" claims
   across the two systems, state the divergence explicitly — do not let a reader assume
   Lean-kernel rigor for praxis's evidence or vice versa.

4. **Two "Standing" concepts share a root equation but are disjoint state spaces.** Praxis's
   F01 (`f01_standing_algebra.rs`) is a 7-state *artifact* lifecycle
   (RAW→...→REPLAYABLE), citing "A = mu(O*)" from `docs/CHATMAN_EQUATION.md`. mfact's
   `Swarm11/Standing.lean` defines a 7-variant *theorem-claim* type
   (`candidateOnly`/`proven`/`blocked`/...) gating `canClaimTheorem` — and
   `CLAUDE_ROADMAP.md` section 1 opens with the identical "A = μ(O*)" line, uncited. Action:
   state explicitly whether mfact's `Standing` type is meant to instantiate the same general
   Chatman-Equation standing concept praxis's artifact-standing instantiates, or is a
   deliberately narrower, unrelated application — this relationship is currently
   undocumented.

5. **G11's dead mfact-core files are invisible to even praxis's strictest lint gate.**
   `broker.rs`, `thermo.rs`, `transport.rs`, `lean.rs` exist on disk but are never `mod`-ed
   from `lib.rs`/`main.rs`. `RUSTFLAGS="-D warnings" cargo check --lib` in mfact-core:
   zero warnings. Praxis's own `apply.sh` dry-run against mfact-core has no orphaned-source-
   file detector either (`grep` for `dead_code|unused|orphan|unreferenced` across
   `apply.sh`/`ci-shape-check.py`/`CHECKLIST.md` returns nothing relevant). Action: G11
   needs a dedicated "every `.rs` under `src/` is reachable from a `mod` declaration" check
   — neither repo's current tooling supplies one; mfact must build it itself.

6. **CROWN_STATUS.md's own numeric counts drifted within 90 minutes, even under strong
   discipline.** Doc claimed "404 passed; 0 failed; 6 ignored" as of commit `b69f9959`
   (21:07:44). Re-running `cargo test -p multifractal-workflow --tests` myself ~90 minutes
   later at HEAD `918df9c5` (22:45:10) gave "422 passed; 0 failed; 13 ignored" — 6 commits
   added tests in between; the qualitative REAL/PARTIAL/MISSING verdicts held, only the
   transcribed pass/fail/ignored counts went stale. This is directly GAP_LEDGER G6/G39-class
   ("stale status surface pinned to old hashes while HEAD moves on"). Action: mfact should
   auto-generate transcribed test counts from literal test-runner output at doc-write/
   doc-read time rather than trusting hand-transcription, even in status docs updated
   frequently and honestly.

7. **"Wired" (a real non-test caller exists) is not "reachable" (a running binary invokes
   it) — praxis states this distinction explicitly; mfact's GAP_LEDGER does not, uniformly.**
   `CROWN_STATUS.md`'s "Reachability ceiling" section discloses that
   `multifractal-workflow` declares `[lib]` only, no `[[bin]]`, no `main.rs` — confirmed
   independently (`grep '\[\[bin\]\]' Cargo.toml` and `find . -name main.rs` both empty
   inside the crate). None of `drive_local_witness_prefix`/`drive_external_*` are invoked by
   a running binary today, only by tests. mfact's GAP_LEDGER tracks some release-
   reachability gaps (G6, G38) but does not apply this crisp two-tier vocabulary uniformly
   across claims. Action: adopt "wired vs. reachable" as a standard two-tier qualifier on
   any mfact status claim about a pipeline being "closed."

### CROSS_REPO_INCONSISTENCY

Places where what mfact assumes about praxis (or vice versa) does not match what is
actually there.

1. **`CLAUDE_ROADMAP.md`'s aspirational Phases 1/5/6/7 describe architecture that already
   exists, name-for-name, in praxis — uncited, and mfact has zero source of its own.**
   Section 9 ("Runtime architecture") states "POWL → BCINR → local runner" and
   "...wasm4pm Arazzo compiler → AIR → Erlang/OTP outer runner...AIR → shared Erlang
   semantic core → AtomVM scheduling shell" — this is family-for-family identical to
   `multifractal-workflow`'s F10→F11→F12→F13→F14→F15→F16→F17 module chain
   (`crates/multifractal-workflow/src/lib.rs` module table). Section 7's wasm4pm-breeds
   pipeline list matches `f28_multi_breed_science.rs:9-13` near-verbatim. Doctrine section 1
   opens with "A = μ(O*)" verbatim from `~/praxis/docs/CHATMAN_EQUATION.md`. Yet
   `grep -rl "multifractal-workflow" /Users/sac/mfact` (excluding `.git`) returns zero
   hits anywhere. Action (highest leverage in this report): before continuing MFW/Swarm11
   Lean work, decide explicitly whether `CLAUDE_ROADMAP.md` specifies
   `multifractal-workflow` (then cite it, and start correspondence work) or is a
   deliberately independent reformulation (then state that choice, not leave it implicit).
   This bears directly on `ROADMAP_MATH_SPINE.md` Wave M1-M5 and `CLAUDE_ROADMAP.md`
   Phases 1, 5, 6, 7.

2. **Praxis's F13-F16 span is a byte-proven, working implementation of exactly the
   "wasm4pm Arazzo compiler → AIR → OTP outer runner" step mfact's roadmap treats as an
   open phase.** `CROWN_STATUS.md` edge #7 (F13→F14): "F13's manufactured arazzo_document
   fed verbatim into F14's own compile ... air_digest_hex == receipt.air_digest_hex." I
   independently reran two of the underlying claims: `just erlang-compile` succeeded, then
   `cargo test -p multifractal-workflow --lib f16_otp_runner::bridge:: -- --ignored` → "2
   passed; 0 failed" (real Rust→escript→Erlang `gen_statem` round trip); and
   `just erlang-test-atomvm-differential` → "4 tests, 0 failures." Action: this directly
   affects `CLAUDE_ROADMAP.md` section 11 Phases 5-7 (AIR semantic core, OTP outer runner,
   AtomVM target) — mfact currently has no `AIR_SEMANTIC_CORE_SINGLE_SOURCE`,
   `OTP_ARAZZO_RUNNER_ALIVE`, or `ATOMVM_LIVE_RUNTIME_PROVEN` markers. Building these from
   scratch would duplicate 61 commits/1 day of already-closed, adversarially-verified work;
   depending on or vendoring `arazzo_runner`+`air_core` (with mfact supplying its own
   POWL/SPARQL/Tera front end, per the roadmap's own stated pipeline) is the lower-risk
   path if code-sharing between the two projects is acceptable.

3. **A compiled Rust NIF sits inside the "pure Erlang, runtime-portable" semantic core
   praxis's own AtomVM shell calls into — a real portability risk `CLAUDE_ROADMAP.md`
   explicitly warns against for this phase.** `air_core.erl`'s `eval_expr/2,3` delegates
   entirely to `erlang:load_nif` (`apps/air_core/native/air_core_nif`); the pure-Erlang
   stub is only a `nif_not_loaded` error. `CLAUDE_ROADMAP.md` section 9 requires "Keep the
   Erlang semantic core pure and runtime-portable." Standard AtomVM builds for
   microcontrollers generally cannot load arbitrary dynamically-linked NIFs. Action: if
   mfact depends on or mirrors this core (per finding above), flag this NIF split as a
   concrete architectural risk to resolve before assuming "pure Erlang" holds — praxis's
   own F17 disclosure does not call out this specific angle.

4. **Praxis's F17 module discloses the identical epistemic caveat mfact's roadmap states
   for the same phase, independently.** `f17_atomvm_runtime.rs:38-44`: both "OTP" and
   "AtomVM" sides of the differential harness run as ordinary BEAM processes today, and
   `which atomvm` exits nonzero (I reran this myself: `atomvm not found / exit=1`).
   `CLAUDE_ROADMAP.md` section 9: "Do not claim live AtomVM verification until an actual
   AtomVM runtime executes the corpus." Action: if mfact adopts praxis's F17 harness for
   Phase 7, it inherits this already-disclosed gap (needing a real AtomVM binary/device)
   rather than needing to invent the differential-testing scaffolding itself.

5. **mfact holds a formal Lean correspondence structure for exactly the property praxis's
   F16/F17 tests informally establish, with zero cross-reference either direction.**
   `procint/ProcInt/Playground/Swarm11/Correspondence/AtomVM.lean` defines
   `StepCorrespondence`/`preservesStep` (`encodeState (abstractStep event state) =
   runtimeStep event (encodeState state)`). Praxis commit `d545e802`'s message uses the
   identical term "preservesStep"/"consequenceReceipted shape" to describe its new live
   test's informal correspondence check. Action: this is a concrete, currently unexploited
   opportunity — mfact's Lean `StepCorrespondence` could become the formal spec that
   praxis's dispatch-statem/AtomVM-differential tests are checked against, rather than each
   repo re-deriving the same notion independently, in different formalisms.

6. **A false "VICTORY CONFIRMED" cross-repo delivery claim exists in praxis's own agent
   handoff record.** `~/praxis/.agents/handoff.md` (2026-07-10T20:03:12Z) states an
   "Independent Victory Auditor" confirmed delivery of "5 LaTeX and 5 Markdown chapter
   files...in /Users/sac/mfact/paper/generated/", `just paper` compiling cleanly, and `just
   check` returning `CHECK=PASS`. `ls -la /Users/sac/mfact/paper/generated/` shows only an
   empty `.gitkeep`. Action: this is direct, non-hypothetical evidence that an
   "independent auditor" subagent role can itself be fooled or hallucinate file existence —
   mfact's own `victory_auditor`/`victory_auditor_gen2` agents (`.agents/`) must check
   filesystem existence with a literal `ls`/`find`, never trust a peer agent's summary, even
   from a role explicitly named "independent auditor." This should be added as a concrete
   lesson to `AGENTS.md` alongside its existing "no ambient authority" law.

7. **mfact's own procint/paper/release history was produced by automation orchestrated
   *from* praxis, not written organically session-by-session inside mfact.**
   `~/praxis/.claude/workflows/mfact-overnight.js` hardcodes `MFACT='/Users/sac/mfact'` and
   its prompts instruct `git -C ${MFACT} add -A && git -C ${MFACT} commit`. Matching real
   mfact commits confirm this ran: `e23cac9`, `5e41594`, `4000d58`, `c4a433b` line up with
   the workflow's phase list (Seed/Author/Prove/CrownJewel/Integrate/Fixtures/Reconcile/
   Certify/Paper/Standing). Action: this is a structural fact neither `AGENTS.md` nor
   `CLAUDE.md` currently documents — worth stating plainly. It also means the "independently,
   in parallel" framing this session used for the two repos' audit practices needs revision:
   execution provenance already crosses the repo boundary in the mfact-writing direction.

8. **Praxis holds standing Bash permissions to `cd`/write into mfact, but `AGENTS.md`
   section 3 (corrected today) only scopes the reverse direction.**
   `~/praxis/.claude/settings.local.json` grants `Bash(git -C /Users/sac/mfact ...)`,
   `Bash(cd /Users/sac/mfact)`, `Bash(cat ~/mfact/ggen.toml)`; `mfact-overnight.js`
   actually commits into mfact. `AGENTS.md` section 3's 2026-07-12 correction carefully
   scopes what mfact sessions may do to praxis but says nothing about whether
   praxis-orchestrated writes into mfact are still sanctioned. Action: surface this to the
   user directly — does the same correction implicitly restrict the reverse direction too,
   or is cross-repo-write-into-mfact-from-praxis still intended practice?

9. **mfact and mfact-core diverge from praxis's own house style on version/license/lint
   gates that GAP_LEDGER didn't surface as a praxis-comparison item.** Praxis's CI gate
   (`template/.github/workflows/anti-regression-gate.yml`) requires CalVer (`YY.M.patch`)
   and `license = "MIT OR Apache-2.0"`; mfact root and mfact-core both use `"0.1.0"` with no
   license field. Praxis mandates `todo!`/`unimplemented!`/`dbg!` = deny,
   `unwrap_used`/`expect_used` = warn via `[lints]`; mfact-core has no `[lints]` block at
   all, and already contains 7 unwrap/todo/dbg occurrences that block would catch
   (`grep -rn '\.unwrap()\|todo!\|unimplemented!\|dbg!'` across `mfact-core/src/*.rs`).
   Action: adopt a `[lints]` block in mfact-core's `Cargo.toml` as a low-effort, high-value
   fix — it would immediately surface 7 currently-silent risk points; separately decide
   CalVer/license policy for mfact's own crates.

10. **Praxis's own workspace-detector tooling has a blind spot matching G2 exactly, so it
    would not have caught G2 either.** mfact has no `[workspace]` at all, and
    `mfact-core` is never referenced from root `Cargo.toml`/`src`. Running
    `~/praxis/apply.sh /Users/sac/mfact/crates/mfact-core --dry-run` (verified read-only:
    `DRY=1` short-circuits before any write) classifies mfact-core as "SINGLE CRATE" and
    never runs its ANTI-5 orphaned-member check, which only fires when `IS_WORKSPACE=1`.
    Action: mfact needs its own check for "a package with an unreferenced sibling crate
    directory" — praxis's tooling assumes either a real workspace or a standalone crate,
    not this shape, so it is not a substitute for closing G2.

11. **The `ggen` binary both repos use predates several real feature commits in its own
    upstream source.** `ggen --version` → `26.7.4`, built `Jul 9 19:05`
    (`~/.cargo/bin/ggen`). `git log --since="2026-07-09 19:05" --oneline -- crates/ggen/src`
    in praxis lists real commits after that build (`b404c53e`, `59cde6eb`, `2a6c9c18`,
    `d97fbfa2`) with no version bump in `crates/ggen/Cargo.toml`. Action: mfact's
    pre-commit hook and its `MFACT_SOURCE_CHANGED=1` escape hatch implicitly assume praxis
    is a live, current source of truth for ggen behavior. mfact should either pin/record
    which praxis commit its installed `ggen` binary corresponds to, or rebuild from praxis
    HEAD before trusting pack-generation output to match praxis's current semantics.

12. **mfact's three vendored packs (lean-math-pack, quadrature-pack, post-release-pack)
    have already diverged substantially from praxis's originals, in both directions, and
    are no longer in praxis's own active pack roster at all.**
    `diff -rq` shows `quadrature-pack/ontology.ttl` at 76,010 bytes in mfact vs. 54,530 in
    praxis; mfact's `lean-math-pack/fragments/` has 5 files (`covering.ttl`, `planning.ttl`,
    ...) that don't exist in praxis's copy. Praxis's last commit touching these dirs was
    `08b6a92e` (Jul 7); mfact's local `ontology.ttl` was last modified Jul 12 06:56 — five
    days of unilateral forward evolution inside mfact alone. Separately, praxis's *current*
    `ggen.toml` `[packs]` table no longer lists any of these three packs — its live roster
    is now `wasm4pm-facts-pack`, `standing-pack`, `chatman-engine-pack`, and 8 others.
    Action: mfact is the sole remaining maintainer of this pack lineage; a future "pull
    fresh packs from praxis" operation must be a real merge, not a copy, or it will silently
    destroy mfact-only fragments — and mfact should not expect ordinary praxis work to touch
    these dirs going forward.

### PURE_CONTEXT

Genuine context with no direct mfact action, included so future sessions do not
re-derive it.

1. **The F02...F19 chain notation is confirmed to be real, currently-active praxis
   vocabulary — full decode in section 3 below.** This retroactively validates the earlier
   session's decision to decline interpreting the pasted document rather than acting on it,
   while resolving that the vocabulary itself traces to a real sibling repo, not an
   injected or hallucinated framework. The literal string "Global AtomVM Swarm" does not
   appear anywhere in praxis's tracked text (`grep -rn` returns zero hits), so that pasted
   document is not a direct export of any praxis artifact found here — its exact
   provenance remains an open question if it resurfaces.

2. **The master atlas driving the F01-F30 family structure is not checked into praxis's
   git history.** `multifractal-workflow/src/lib.rs`'s header states the crate was
   "scaffolded in a single Wire-phase-0 pass from a 30-family research survey handed to
   that scaffolding session inline," citing `/Users/sac/Downloads/v26.7.12_mermaid_atlas/`
   as the source of truth — a local Downloads folder outside any repo, not a stable,
   re-fetchable artifact.

3. **Both repos' adversarial self-audit passes are literally same-day, not just
   thematically parallel.** `multifractal-workflow`'s Cargo.toml version is `"26.7.12"`
   (today's date, YY.M.D calendar versioning); its self-audit commit `62e2e0b6` and mfact's
   `PRAXIS_SELF_AUDIT.md` session are contemporaneous.

4. **`multifractal-workflow/GOALS.md` is unreliable; the real source of truth is inline
   module doc comments and `CROWN_STATUS.md`.** GOALS.md's entire content is "No specific
   tickets map directly to this crate in the current milestone," despite this crate
   carrying all 30 architecture families and both crown witnesses — the real `V12-0XX`
   ticket linkage lives in `lib.rs`'s own table.

5. **praxis's own tooling has drifted from its own documentation, mirroring this session's
   theme.** `~/praxis/apply.sh` is currently broken against its own `template/` dir: 12 of
   19 files in its `HYGIENE_FILES` array don't exist in `template/` (verified via
   `apply.sh --dry-run`, confirmed read-only); the README's claim that `template/` "ships
   Cargo.toml (with [lints])" is false as read today.

6. **`mfact-core` fails a plain build today, independent of any style question.**
   `RUSTFLAGS="-D warnings" cargo check --all-targets` in mfact-core: `error[E0425]: cannot
   find function 'simulate_workload'` in `src/bin/turbulence.rs:16:13`. Praxis's own
   `just ci`/`dod` gate would block this immediately.

7. **The orchestration harness itself (orchestrator/victory-auditor/teamwork-preview
   roles) is already shared infrastructure between the two repos, not something mfact
   lacks.** `~/mfact/.agents/` and `~/praxis/.agents/` use matching directory-naming
   conventions. The narrower, real gaps are the four specific artifacts layered on top that
   only praxis currently has: the `.claude/workflows/*.js` scripted-lane pattern, the
   `ggen-pack` subagent, the `CROWN_FRONTIER` trailer convention, and the enforcement
   hooks — listed under ADOPT_TOOL_OR_PATTERN above.

8. **Praxis itself runs three non-unified mutation-testing conventions with no shared
   tooling, scope, or documentation location** (`mutation_chain.rs`, the single-file
   `cargo-mutants` pilot at 12.5% kill rate on `f16_otp_runner/bridge.rs`, and
   `chatman-quality`'s coverage+dylint combo on a third crate). "Adopt praxis's mutation
   testing" is not one thing to copy; given mfact is Lean-first, the Lean-proven
   staged-validator model (`thm_kill.lean`) is the coherent one to build from, not the
   generic-tool-plus-coverage-threshold model, which has no Lean equivalent.

## 3. Crown I-V vs. crown_local/crown_external, and the F-chain decode

**crown_local / crown_external are not proofs of Crown I-V.** They are per-run empirical
audits of production call-graph reachability in `multifractal-workflow` — "does a real,
non-test caller thread data from stage A to stage E" — verified by adversarial code-reading
plus running live tests, some against real Erlang subprocesses. mfact's Crown I-V
(`ROADMAP_MATH_SPINE.md` section 1) is a kernel-checked Lean theorem spine (minimal
antichain residue → DM descent → free-monad substitution → recursive coalgebra → unique
replay → autonomous resolution), currently at `TARGET_THEOREM` standing pending Waves M0-M5.
Neither side has both halves: praxis has zero Lean formalization of Crown I-V; mfact has zero
implementation of the F02-F30 pipeline and no audited production call graph of its own.
`ROADMAP_MATH_SPINE.md`'s own Correction 1 already anticipates exactly this gap — Crown V
is split into Theorem 21.1 (abstract, `PROVEN_CONDITIONALLY`) and Corollary 21.2 (MFW
runtime crown, `BLOCKED_ON_CORRESPONDENCE` until A10 and the correspondence assumptions are
discharged) precisely so that runtime evidence like praxis's LOCAL witness cannot be read as
discharging it without the explicit correspondence morphism `AGENTS.md` section 4 requires.

Additionally, `ROADMAP_MATH_SPINE.md`'s own text ("replaces both the 'Autonomous Resolution
Crown Theorem' and the 26-rail catalogue") is a corrective refinement of a document that is
*not* the exact file currently in praxis: praxis's `docs/MULTIFRACTAL_WORKFLOW_DISSERTATION.md`
places its Crown theorem at section 5.3 (a single-commit "first draft," `26c20ee0`), and
neither "26-rail catalogue" nor "Rail B" appears anywhere in praxis's tracked text
(`grep -rn '26.rail|Rail B'` returns no matches). The "Rail B" document mfact's Correction 1
corrected is a different, differently-numbered draft in the same conceptual lineage — not
this exact praxis file. mfact's spine, with `TARGET_THEOREM` markers and a Lean Wave M0-M5
plan, is a strictly more disciplined statement of the same underlying claim than what is
currently live, uncorrected, in praxis's checked-in dissertation.

**F-chain decode** (verified against each module's own doc-comment header, e.g.
`f02_observation_admission.rs:1`, `f18_broker_law.rs:1`, `f25_receipts_replay.rs:1`):

| Node | Family | Function |
|------|--------|----------|
| F02 | Observation Admission | `admit_observation` |
| F03 | Semantic Contraction | `contract` |
| F08 | PDDL Planning + Action-Hook Binding | `run_pipeline` |
| F09 | MFW Growth Operator | `manufacture_and_bind_child`/`plan_growth` |
| F10 | POWL Recursive Process Geometry | `build_powl_geometry`/`manufacture_powl_v2` |
| F11 | BCINR Local Runtime | `geometry_to_local_ast` |
| F12 | POWL External Cut + Projection | `resolve_external_cut_at` |
| F13 | Arazzo Generated Artifact | `project_and_compile` |
| F14 | wasm4pm Arazzo Compiler | `compile`/`air_program_to_bridge_workflow` |
| F15 | AIR Single Semantic Core | `call_air_core_bridge` → Erlang `air_core:transition/2` |
| F16 | Erlang OTP Outer Runner | `arazzo_runner_sup:start_workflow/1` gen_statem |
| F18 | Broker + Zero Unreceipted Actuation | `dispatch_local_execution_via_broker` |
| F19 | Hook Registry + Machine-First Actuation | `resolve_hook_for_action` |
| F20 | External Dispatch + Re-admission | `dispatch_subworkflow_to_engine` |
| F21 | Parent-Child Closure | `admit_child_and_evaluate` |
| F24 | OCEL CONSTRUCT | `run_construct` (real oxigraph SPARQL CONSTRUCT) |
| F25 | Receipts and Replay | `f25_receipts_replay::run` |

LOCAL tail (11/11 REAL_EDGE, fully closed): F02→F03→F08→F09→F10→F11→F18→F19→F02(re-admit)→
F24→F21→F25, driven by one function, `crown_local::drive_local_witness_prefix`. EXTERNAL
tail (0 MISSING_EDGE, but not contiguous under the strict bar): F10→[PARTIAL_REAL_EDGE]→
F12→F13→F14→F15→F16→F18→F20→F02(re-admit)→F15→F21→F24→F25 — blocked on exactly one named,
precisely-scoped gap: F10's `build_powl_geometry` never synthesizes a `Powl::ExternalCut`
node itself (the cut boundary is declared by the driver, not emitted by F10). REAL_EDGE
there means "a real, non-test `pub fn` caller exists," not any deeper causal-inference
concept — the vocabulary from the earlier pasted document, if it resurfaces, should be
read with this precise, narrower meaning.

## 4. Next steps, ranked by leverage

1. **Decide the CLAUDE_ROADMAP/multifractal-workflow relationship, explicitly.** Highest
   leverage: this single decision (CROSS_REPO_INCONSISTENCY #1) determines whether Wave
   M1-M5 Lean work (`ROADMAP_MATH_SPINE.md` section 4) and `CLAUDE_ROADMAP.md` Phases 1,
   5-7 should cite and correspond against praxis's already-built F02-F25 pipeline, or should
   state independence plainly. Either answer is fine; the current silence is not.

2. **Add the "wired vs. reachable" and edge-taxonomy vocabulary to mfact's own status
   docs.** Low cost, immediately applicable to `GAP_LEDGER_v26.7.12.md`'s existing
   reachability gaps (G6, G30, G31, G38) and to any future correspondence work on
   `CausalHole`/`REAL_EDGE`/`TEST_ONLY_EDGE` in `CLAUDE_ROADMAP.md`.

3. **Fix the mechanical mfact-core divergences surfaced here** — add a `[lints]` block
   (catches 7 live unwrap/todo/dbg occurrences), fix the `simulate_workload` build break,
   decide CalVer/license/edition policy, and add an orphaned-source-file check that neither
   repo's tooling currently supplies (closes the G2/G11 gap praxis's own `apply.sh` would
   also miss).

4. **Add the false-victory-claim lesson and standing-gate precedence rule to `AGENTS.md`.**
   Both are small text additions with an already-demonstrated, non-hypothetical failure
   mode (`~/praxis/.agents/handoff.md`'s false delivery claim) to cite as justification.

5. **Reconcile the pack-vendoring drift** (lean-math-pack, quadrature-pack,
   post-release-pack) before any future sync from praxis, since mfact is now the sole
   maintainer of that lineage and a naive copy would destroy mfact-only fragments.

6. **Adopt `thm_kill.lean`'s staged-validator formalization for `CLAUDE_ROADMAP.md`
   Phase 15** (verification ladder / mutation-style chaos testing) — the one artifact in
   this exploration that is both mature and in mfact's own formalism (Lean), rather than
   needing translation from Rust/`cargo-mutants` tooling mfact does not otherwise use.

7. **Lower-priority, informational only:** the `mfact-overnight.js` cross-repo write
   pattern and the asymmetric praxis→mfact Bash-permission grants are worth a plain
   statement in `AGENTS.md`/`CLAUDE.md` of whether that pattern remains sanctioned, but
   carry no immediate correctness risk on their own.
