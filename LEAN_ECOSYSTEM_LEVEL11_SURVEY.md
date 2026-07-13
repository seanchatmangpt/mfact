# Lean Ecosystem Survey: What Would "11" Look Like

Ten independent scouts searched the real Lean 4 / Lake / Mathlib ecosystem (plus adjacent
Coq/Rocq/Isabelle formal-methods work) for existing projects, papers, and tools that would
concretely move mfact's own tooling toward a state that structurally cannot present
unverified work as verified — not toward anything merely impressive. The question was never
"what would look good in a slide," it was: this session integrated four externally-authored
Lean packages, and every one of them shipped a self-report (JSON audit, "kernel receipt",
claim matrix) that was wrong or unverifiable until independently rebuilt against Lean
4.31.0 / Mathlib `fabf563a`. The newest package derived its audit from the compiled
environment itself (`Environment.constants`, `ConstantInfo.isTheorem`, `Expr.hasSorry`)
rather than regexing source text — real progress — but it is still the same process
marking its own homework. What existing, citable ecosystem work closes that gap for real?

70 raw findings came back across the 10 scouts, with heavy convergence on a handful of
tools (`leanchecker` alone was found independently by 7 of the 10 scouts — itself a weak
corroborating signal that this is a load-bearing, well-known tool rather than an obscure
one). This report deduplicates those into distinct findings, ranks them by leverage against
mfact's actual named gaps, and keeps scout attribution on every claim in the
confidence-labeled sections below so scout uncertainty is never laundered into false
confidence.

## How findings are ranked

Leverage, not novelty. A finding ranks high only if it closes one of these named,
concrete mfact gaps:

1. **Phantom-sorry cascades** — a self-audit script reading `sorry`/`Expr.hasSorry` off a
   compiled environment that a parse error elsewhere already silently corrupted.
2. **`native_decide` trust gaps** — `native_decide` used where a `Decidable` instance was
   the real, undone work, masked because `#print axioms` can look clean.
3. **No CI wired up yet** — mfact currently has zero automated, independent re-check of any
   claim; everything is self-reported by the same pipeline that produced it.
4. **Open correspondence proofs** — `kappa_graft` (Rust ↔ Lean) and `kappa_runtime`
   (abstract Lean transition system ↔ real runtime, `StepCorrespondence.AtomVM`) are named,
   unadmitted proof obligations, not toy-example scaffolding yet.
5. **Mathlib gaps at the pinned rev** (`fabf563a`) — material the roadmap assumes exists,
   removed, or in flight but unmerged.

Findings that are merely adjacent-and-interesting (published RL theorem-proving results,
general distributed-systems formalizations for the swarm roadmap, philosophical framing
papers) are real and cited, but ranked below anything that closes a named gap directly.

---

## Tier 1 — Immediately actionable: kernel-independent verification

All VERIFIED_EXISTS. These are the tools that turn "our own audit says 0 sorry" into "an
independent process, not sharing the audit's code path, agrees."

### 1. `leanchecker` (formerly `lean4checker`) — built into Lean core since v4.28.0

Replays a compiled module's `.olean` declarations through the actual Lean kernel,
independent of whatever elaborator/build pipeline produced them, via `lake env leanchecker`
(all modules) or `lake env leanchecker --fresh <Module>` (fresh-environment replay). Its own
README is explicit about scope: it reuses the *same* kernel (so it cannot catch
kernel-soundness bugs), but it does catch "environment hacking" — declarations that entered
the compiled environment via a metaprogramming/build path without passing back through
elaboration and kernel acceptance. mathlib4 runs it as a scheduled cron job
(`check-leanchecker` in `.github/workflows/daily.yml`), not per-PR, because "it is quite
expensive for little benefit" run on every change — mathlib itself treats it as the slow,
authoritative check paired with cheap per-PR linters, not a replacement for them.

- Citation: <https://github.com/leanprover/lean4checker> (README); merged into toolchain at
  v4.28.0, <https://lean-lang.org/doc/reference/latest/releases/v4.28.0/>; mathlib CI usage
  in `.github/workflows/daily.yml` and `build_template.yml`.
- Scouts: certified-compilers, proof-automation-verification, ci-verification-gates,
  multi-agent-formal-verification, lake-tooling-maturity, formal-methods-receipts-provenance,
  ambient-authority-formal-epistemics (independently found by 7 of 10 scouts).
- Gap closed: phantom-sorry cascades (directly — a parse-corrupted environment cannot fake
  its way past a kernel replay the way it can fake past a regex or an in-process
  introspection pass) and no-CI-wired-up (it is zero-install on mfact's pinned toolchain,
  since 4.31.0 postdates 4.28.0).

### 2. `axiom-audit` (leanprover-community/axiom-audit)

Builds the project's compiled `Environment` from its `.olean`s, then in one memoized pass
computes each declaration's full transitive axiom closure and fails CI (exit 1) if any
declaration depends on an axiom outside an allowlist (default: `propext`,
`Classical.choice`, `Quot.sound`). Its README states the exact mechanism mfact needs:
"Because it inspects the kernel environment rather than source text, it catches what a grep
cannot: sorry/admit (which surface as `sorryAx`), `native_decide` (which adds
`Lean.ofReduceBool`), any home-rolled axiom, including ones reaching in through imports."
Ships a `--json` mode and clean exit codes for direct CI wiring.

- Citation: <https://github.com/leanprover-community/axiom-audit> — verified live via
  GitHub API (org repo id 41703605, Apache-2.0, real file tree, commits by Mathlib
  maintainer Kim Morrison).
- Scouts: proof-automation-verification, ci-verification-gates.
- Gap closed: both `sorry`/phantom-sorry and `native_decide` in one tool, with a hard CI
  exit code. **Caveat carried forward honestly**: repo was created 2026-06-23, roughly
  three weeks before this survey, 0 stars/forks/watchers. Real and functional (verified
  file-by-file by the scout), but not yet an established community standard — evaluate and
  pin, don't treat as proven-at-scale.

### 3. `lean4export` + `nanoda_lib` (`ammkrn/nanoda_lib`) + `leanprover/comparator`

`lean4export` serializes a compiled environment's kernel-level terms to a portable NDJSON
format, independent of Lean's internal `Environment` representation. `nanoda_lib` is a
from-scratch Lean 4 kernel/typechecker written in Rust by a third party with no shared code
with either the C++ reference kernel or Lean4Lean — genuine implementation diversity, not
just a second invocation of the same checker. `comparator` is the Lean FRO's own tool that
wires these together: compiles a challenge/solution pair in a sandbox, exports both,
verifies the solution's statement matches the challenge's, and re-checks the proof term
against both the official kernel and (with `enable_nanoda`) nanoda, reporting the full
axiom set (including `trustCompiler`) as a first-class field.

- Citations: <https://github.com/leanprover/lean4export>,
  <https://github.com/ammkrn/nanoda_lib>, <https://github.com/leanprover/comparator> (all
  fetched directly).
- Scouts: certified-compilers, ci-verification-gates, formal-methods-receipts-provenance,
  ambient-authority-formal-epistemics (4 independent hits).
- Gap closed: this is the strongest available answer to "no ambient theorem authority" as
  literally stated — a genuinely independent second kernel, in a different language, must
  agree before a claim counts. mathlib4's own `check-nanoda` daily job runs this exact
  pipeline today (currently informational: `unpermitted_axiom_hard_error: false`, not yet a
  hard gate even in mathlib itself — worth noting as the honest current maturity level).
  Because `nanoda_lib` is Rust, and `crates/mfact-core` is already a Rust workspace with a
  live Lean FFI surface (`lean.rs`, `lean_ffi_wrapper.c`, `broker.rs`), this is a
  library mfact could link directly rather than merely shell out to.

### 4. Lean4Lean (`digama0/lean4lean`) — independent Lean-in-Lean kernel

A second Lean 4 kernel implementation, itself written in Lean 4, competitive in speed
(20–50% slower than the C++ reference) and reported able to check all of Mathlib.
Because it is written in a formally analyzable language, the project is progressively
proving metatheoretic properties of Lean's own type theory against it, and has already
found a real soundness bug in the C++ kernel this way. Its own README is honest about
limits: it is derived from the C++ kernel's structure, not designed independently from
scratch, and "likely shares some implementation bugs with it" — pair with nanoda (genuinely
independent codebase) rather than relying on Lean4Lean alone for implementation diversity.

- Citation: <https://github.com/digama0/lean4lean>; paper arXiv:2403.14064 (Carneiro &
  Ullrich, "Lean4Lean: Verifying a Typechecker for Lean, in Lean").
- Scouts: certified-compilers, multi-agent-formal-verification,
  formal-methods-receipts-provenance, ambient-authority-formal-epistemics.
- Gap closed: the deepest existing answer in the Lean ecosystem to "prove the checker
  itself, don't just run it twice" — the actual research frontier mfact's AGENTS.md
  construction doctrine (§1) is reaching toward, already built and consuming
  `lean4export` output.

### 5. The `native_decide` / `Lean.reduceBool` axiom-leakage incident and its live RFC

A real, dated, documented soundness bug (Mario Carneiro, 2023): `Lean.reduceBool` (backing
`native_decide`) could reduce through compiled code, including nondeterministic IO via
`IO.getRandomBytes`, letting a proof of `False` report a *clean* `#print axioms` with 25%
success probability. Fixed by introducing an explicit `trustCompiler` axiom that any
`native_decide` use now visibly depends on, and by making `IO.RealWorld` opaque — landed
v4.2.0-rc2, reworked further in 4.29+. A maintainer confirmed in-thread that `lean4checker`
does **not** catch this class of bug, because it lacks support for compiled-code reduction
at all — `leanchecker` and axiom-tracking are complementary, not substitutes. An open,
still-live RFC (`leanprover/lean4#12216`, "One axiom per native computation") proposes
giving every native-computation call site its own distinct, named axiom specifically so
`native_decide`-based proofs become individually enumerable and externally checkable —
today, external checkers including `comparator`/`nanoda` cannot verify proofs that go
through `native_decide` at all.

- Citations:
  <https://leanprover-community.github.io/archive/stream/270676-lean4/topic/soundness.20bug.3A.20native_decide.20leakage.html>;
  <https://github.com/leanprover/lean4/issues/12216>.
- Scouts: certified-compilers, formal-methods-receipts-provenance,
  ambient-authority-formal-epistemics.
- Gap closed: directly answers the named `native_decide`-masking-a-Decidable-gap concern —
  it is a known, tracked, ecosystem-wide trust hole (not an mfact-specific mistake), with a
  concrete remediation pattern (require `#print axioms` output as a mandatory receipt
  field; flag `trustCompiler`/`Lean.ofReduceBool` the same way a `sorry` would be flagged;
  treat `native_decide` as a fallback only after confirming no tractable `Decidable`
  instance exists).

### 6. mathlib4's explicit two-tier linter/checker split

`Mathlib/Tactic/Linter/DeprecatedSyntaxLinter.lean` ships `linter.style.nativeDecide` and
`linter.style.admit`, cheap syntactic linters that fire on every PR. Their own source
comment states plainly they are *not* the real safety mechanism: "this linter is purely for
user information. Running `lean4checker` in CI catches *any* additional axioms that are
introduced (not just `ofReduceBool`): the point of this check is to alert the user quickly,
not to be airtight." Paired with mathlib's weekly, non-blocking "Technical Debt Counters"
(`technical_debt_metrics.yml`) — a scheduled scoreboard of debt trends (disabled lints,
`erw [`, unjustified `maxHeartbeats` overrides) reported to Zulip, explicitly never used as
a release gate.

- Citations:
  <https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Tactic/Linter/DeprecatedSyntaxLinter.lean>
  (lines ~77–93); `.github/workflows/technical_debt_metrics.yml`; both fetched directly.
- Scout: ci-verification-gates.
- Gap closed: gives mfact a real-world precedent for a structural choice it should make
  deliberately: `GAP_LEDGER_v26.7.12.md`'s 48 tracked defects should stay a soft,
  trend-tracked scoreboard, never a substitute for a hard pass/fail kernel-truth gate
  (`leanchecker`/`axiom-audit`). Mathlib does not treat its own debt ledger as proof a gap
  is "handled" — mfact's ledger entries shouldn't be treated that way either.

---

## Tier 2 — Repo-structural findings: mfact's own Lake/CI plumbing

VERIFIED_EXISTS, and one of these is not "ecosystem prior art" at all — it is a live,
present-tense bug in mfact's own tree, discovered while researching the ecosystem's CI
conventions.

### 7. GitHub Actions silently ignores workflow files outside repo-root `.github/workflows/`

GitHub Actions only discovers workflow YAML at the repository root's `.github/workflows/`
— never in a subdirectory. mfact has committed `leanprover/lean-action` CI configs at
`research-papers/<pkg>/.github/workflows/lean_action_ci.yml` for 11 of its 12
research-papers Lean packages (`bio_signals`, `floquet_photonic`, `hyperdimensional_cognitive`,
`minimal_measures`, `ortac_plus`, `pair_correlation`, `quantum_hall`, `random_walk`,
`scalar_dissipation`, `signal_criticality`, `smfdcca`, `star_graphs`). None of these paths
are under the repo-root `.github/workflows/`, so GitHub Actions never runs them — they are
inert, git-tracked, and look exactly like "CI is wired up" on inspection. The scout
confirmed against mfact's actual tree: `git ls-files | grep -c
'research-papers/.*/.github/workflows/'` = 11; the only live workflow is the repo-root
`ci.yml`, which builds only `mfact/` and `procint/`.

- Citations: GitHub community confirmation of the restriction —
  <https://github.com/orgs/community/discussions/15935>,
  <https://github.com/orgs/community/discussions/18055>; verified against mfact's own
  `git ls-files` output.
- Scout: lake-tooling-maturity.
- Gap closed: this *is* "no CI wired up yet," made concrete and quantified — 11 of mfact's
  Lean packages currently get zero build/lint/test signal despite the appearance of
  coverage. Fix is mechanical: move each nested workflow into repo-root
  `.github/workflows/` with a distinct name and a `lake-package-directory:` input, mirroring
  the pattern mfact's own root `ci.yml` already uses correctly for `mfact/` and `procint/`.
  Ranked this high because it is the single most direct, present-tense instance of the
  exact failure mode the whole session is about: an artifact (a committed workflow file)
  that looks like verified infrastructure but structurally cannot execute.

### 8. Lake's Workspace model — one manifest per workspace via local `path` requires

Lake's own architecture distinguishes a "package" from a "workspace" (root package + all
transitive deps + one shared manifest), with the documented, supported way to compose a
monorepo being a root package that `require`s siblings via relative `path =` entries. mfact
does this in exactly one place (`procint/lakefile.toml` requiring `mfact` via
`path = "../mfact"`); everywhere else is a disconnected workspace. The scout counted 15
distinct `lake-manifest.json` files under `mfact/`, `procint/`, `procint/docbuild/`, and 11
`research-papers/*` directories, each resolving its own dependency graph from scratch — and
confirmed that only `procint`'s manifest actually pins Mathlib (at `fabf563a...`); the other
10 research-papers manifests checked have zero dependencies listed at all.

- Citation: <https://lean-lang.org/doc/reference/latest/Build-Tools-and-Distribution/Lake/>.
- Scout: lake-tooling-maturity.
- Gap closed: mfact's stated pin ("Lean 4.31.0, Mathlib rev `fabf563a`") is only actually
  recorded in one manifest, not enforced anywhere else in the repo — there is no structural
  guarantee two packages that both claim to depend on Mathlib are looking at the same
  revision.

### 9. `leanprover/lean-action` — already correctly adopted for 2 of mfact's packages

The Lean core team's own CI action: `auto-config` mode, `lake-package-directory` input for
pointing at one package inside a monorepo, and built-in `.lake` caching. mfact's own root
`ci.yml` already uses it correctly with `lake-package-directory: mfact` and
`lake-package-directory: procint`, including a `needs:` dependency reflecting procint's
local-path require on mfact.

- Citation: <https://github.com/leanprover/lean-action> (README).
- Scout: lake-tooling-maturity.
- Gap closed: the fix for finding #7 is not "adopt a new tool," it is "apply the recipe
  mfact already got right for 2 packages to the other 11." The scout also flagged an
  unresolved TODO in mfact's own `ci.yml`: `lean-action`'s `test`/`lint` inputs are
  disabled, and no build-artifact caching is shared between the `build-mfact` and
  `build-procint` jobs despite `procint` depending on `mfact`'s source.

### 10. mathlib4 wiki: globally shared Mathlib installation, and Lake's native artifact cache

Two related fixes for a real, measured problem: the scout found `procint/.lake` = 8.7 GB,
`floquet_photonic/.lake` = 7.1 GB, `revops_turbulence/.lake` = 7.1 GB, `sound_borrow_checking/.lake`
= 1.0 GB, `aeneas_rust_verification/.lake` = 926 MB — well over 20 GB of duplicated,
overlapping dependency closures on one machine, none of it deduplicated. mathlib's own wiki
documents a supported-but-labeled-"non-standard" workaround (clone Mathlib once, point every
downstream `lakefile` at it via `path =`). Lake itself gained a native, non-mathlib-specific
remote/local artifact cache in v4.30.0 (PRs #12634, #12927, #12974) — one release *before*
mfact's pinned v4.31.0 toolchain, meaning the feature should already be present but nothing
in mfact's repo currently enables it (grepped for `LAKE_ARTIFACT_CACHE`,
`enableArtifactCache`, `cache-dir` — no matches anywhere).

- Citations:
  <https://github.com/leanprover-community/mathlib4/wiki/Project-setup:-globally-shared-mathlib-installation>;
  <https://lean-lang.org/doc/reference/latest/releases/v4.30.0/>.
- Scout: lake-tooling-maturity.
- Confidence split: the wiki-workaround is VERIFIED_EXISTS. The exact v4.30.0 cache config
  surface (env var name, `Lake.Config` field) is **LIKELY_EXISTS_UNCONFIRMED_DETAILS** — the
  scout could not independently re-verify the flag name against a primary Lake doc page and
  recommends running `lake --help` on the actual pinned 4.31.0 toolchain before committing
  to either approach.
- Gap closed: disk/build hygiene rather than verification truth, but directly relevant to
  "no CI wired up yet" — 11 independent multi-GB Lake builds per CI run is itself a reason
  CI has not been wired up.

### 11. Two open, maintainer-acknowledged Lake manifest reproducibility bugs

`leanprover/lean4#2594` — `lake update` permutes package order in `lake-manifest.json` even
when only a `rev` field logically changed, making diffs hard to review (marked fixed).
`leanprover/lean4#13084` — `lake update` on a package refreshes its direct dependencies but
can leave a *transitive* dependency pinned to a stale commit even after the intermediate
package's own manifest moved on; reproduced with a real 3-project chain and cited as the
actual cause of a build failure during Lean 4.29.0-rc7 development.

- Citations: <https://github.com/leanprover/lean4/issues/2594>,
  <https://github.com/leanprover/lean4/issues/13084> (both fetched and quoted directly).
- Scout: lake-tooling-maturity.
- Gap closed: if mfact adopts the shared-workspace pattern (finding #10), it should verify
  manifest agreement by direct comparison of recorded revs/hashes across manifests (a
  five-line script) rather than trusting `lake update` to keep them consistent — these two
  issues are documented, real cases where it does not.

---

## Tier 3 — Correspondence-proof prior art (`kappa_graft` / `kappa_runtime`)

VERIFIED_EXISTS. mfact's `kappa_graft` (Rust ↔ Lean) and `kappa_runtime`
(`StepCorrespondence.AtomVM`, abstract Lean transition system ↔ real runtime) are named,
currently-unadmitted correspondence proofs. These findings are worked, checkable prior art
for that specific proof shape — not brainstormed analogies.

### 12. Aeneas + Charon (AeneasVerif org) — Rust ↔ Lean 4 verification pipeline

Charon lifts a Rust crate's MIR into LLBC (a typed IR) without touching `rustc` internals.
Aeneas translates LLBC into pure/monadic Lean 4 code that faithfully mirrors the Rust
program's control/data flow, which then becomes the subject of ordinary Lean proofs of
functional correctness. Used in production-adjacent efforts including Microsoft SymCrypt
and AWS-LC; officially listed as a Lean use case on lean-lang.org.

- Citations: <https://github.com/AeneasVerif/aeneas>,
  <https://github.com/AeneasVerif/charon>, <https://lean-lang.org/use-cases/aeneas/> (all
  confirmed live).
- Scout: certified-compilers.
- Gap closed: `kappa_graft` directly. Write/generate the Rust independently, pull its
  compiled MIR back into Lean via Charon+Aeneas, then state and discharge the graft
  correspondence as an ordinary Lean proof obligation, checked by the same trusted kernel
  mfact already trusts for everything else. The trust shape matches
  `lean4export`/`leanchecker`: Aeneas is an untrusted translator, and the correctness claim
  is real only once the Lean kernel accepts the resulting equivalence proof.

### 13–16. WASM/BEAM target semantics for `kappa_runtime`

Four findings, in decreasing maturity, all targeting the missing piece for
`StepCorrespondence.AtomVM`: an independently-authored, machine-checked *target-side*
reference semantics to prove the correspondence against, rather than a hand-rolled one.

- **CertiCoq-Wasm** — a verified WebAssembly backend for CertiCoq, compiling CertiCoq's L6
  ANF IR to WebAssembly with the compiler and its correctness proof mechanized in Coq
  against WasmCert-Coq's Wasm 2.0 formalization. Published CPP 2025. The verification effort
  found a real soundness bug in Coq's primitive-integer-to-Wasm lowering — the "obviously
  equivalent" encoding was not equivalent until checked, a direct precedent for why
  `kappa_runtime` needs an actual proof and not an "obviously correct" assertion.
  Citation: <https://dl.acm.org/doi/10.1145/3703595.3705879>;
  <https://github.com/womeier/certicoqwasm>. Scout: lean-wasm-atomvm-runtime-correspondence.
- **WasmCert-Coq / WasmCert-Isabelle** — two independent, W3C-spec-derived mechanizations of
  full WebAssembly, one in Coq (with a mechanized type-safety + memory-safety soundness
  proof and an extracted executable interpreter) and one in Isabelle/HOL. This is the
  "ground truth" target semantics mfact currently has none of.
  Citations: <https://github.com/WasmCert/WasmCert-Coq>,
  <https://github.com/WasmCert/WasmCert-Isabelle>. Scout: same.
- **LeanWasm** (Alex Ionescu, MSc thesis, Utrecht 2024) — an intrinsically-typed WebAssembly
  interpreter written natively in **Lean 4**, not Coq/Isabelle, directly reusable inside
  mfact's own toolchain with no cross-prover translation step. Encodes Wasm's type system
  in the AST so ill-typed terms are unrepresentable.
  Citation: <https://studenttheses.uu.nl/bitstream/handle/20.500.12932/46861/LeanWasm.pdf>.
  Scout: same.
- **lean-wasm / c0deine** (T-Brick / Aidan Frawley) — a live, in-progress Lean 4
  formalization of WebAssembly (syntax/validation largely complete, dynamics WIP) paired
  with a C0-subset compiler that already targets it; the authors state plainly no compiler
  phase is proved correct yet. Useful as calibration for how mfact should honestly label its
  own "currently only instantiated on toy examples" status, not as a finished shortcut.
  Citations: <https://github.com/T-Brick/lean-wasm>, <https://github.com/T-Brick/c0deine>.
  Scout: same.

### 17. Core-Erlang-Formalization (harp-project) — for the AtomVM/Erlang half

A Rocq formalization of a subset of sequential and concurrent Core Erlang — the actual IR
the real Erlang/OTP compiler lowers to before BEAM bytecode. Provides big-step, functional
big-step (extractable to an executable OCaml/Haskell interpreter), and small-step
semantics; proves determinism and multiple program-equivalence frameworks. Critically, it
is cross-validated against a second, independently-written K-framework semantics for full
surface Erlang via property-based testing against real Erlang/OTP execution — i.e. it has
already been through the "is this semantics actually right, checked against ground truth"
step mfact's own self-reported audits have repeatedly skipped.

- Citations: <https://github.com/harp-project/Core-Erlang-Formalization>;
  <https://github.com/harp-project/erlang-semantics-testing>;
  <https://kar.kent.ac.uk/82503/1/core_erlang_paper.pdf>.
- Scout: lean-wasm-atomvm-runtime-correspondence.
- Gap closed: closest existing artifact to a checked BEAM-side semantics for the AtomVM
  half of `kappa_runtime` — one real compiler pass above raw bytecode, closer to what an
  abstract Lean transition system would actually correspond to.

### 18. Peregrine — verified middle-end for code extraction (honest negative-adjacent finding)

A code-generation middle-end (Agda/Lean/Rocq frontends → CakeML/C/Rust/OCaml/Wasm/Elm
backends via an IR called λ□), presented at Types '26. **Only the Rocq frontend (via
MetaRocq's verified erasure) currently has a machine-checked correctness proof; the Lean
frontend and the Rust backend are stated by the authors themselves as trusted/unverified
today** — their own words are aspirational ("in the long run, we hope to verify all
Peregrine frontends and backends").

- Citations: <https://peregrine-project.github.io/>,
  <https://github.com/peregrine-project/peregrine-tool>.
- Scout: certified-compilers.
- Gap closed: the honest framing matters more than the tool here. If mfact adopted
  Peregrine's Lean frontend today and treated its Rust output as machine-checked, that would
  repeat the exact failure mode this survey is about. What it actually gives mfact is a
  concrete real IR/architecture to either contribute Lean-frontend verification to
  upstream, or use as an admittedly-unverified extraction step that must still be
  independently checked post-hoc (e.g. via the Aeneas-style round-trip in finding #12).

---

## Tier 4 — Mathlib gaps at the pinned revision (`fabf563a`)

VERIFIED_EXISTS, including two honest negative findings.

### 19. `vihdzp/combinatorial-games` closes `HESSENBERG_ROUTE_BLOCKED_AT_PIN`

A standalone, actively maintained Lean 4 library (71 stars, last push 2026-06-10) that is
the official downstream successor to Mathlib's deleted combinatorial-game-theory material,
including `Ordinal` natural addition/multiplication (Hessenberg sum/product) with the same
API Mathlib used to ship. Its own `lake-manifest.json` pins Mathlib and tracks master, so it
adds as a normal Lake dependency.

- Citation: <https://github.com/vihdzp/combinatorial-games>, file verified directly at
  `CombinatorialGames/NatOrdinal/Basic.lean`.
- Scout: mathlib-gaps-for-mfact.
- Gap closed: `ROADMAP_MATH_SPINE.md`'s `HESSENBERG_ROUTE_BLOCKED_AT_PIN` item, and corrects
  its framing — Mathlib will not re-add this material (see next finding), so "postpone
  until the pin moves" is a dead end; the fix is adding this library as a dependency now.

### 20. Mathlib PR #28063 / commit `08657ed7f8` — permanent, not pending, removal

PR #28063 deprecated combinatorial-games/surreals/nimbers/`Ordinal.NaturalOps` material,
downstreaming it to `vihdzp/combinatorial-games`; six months later commit `08657ed7f8`
(2026-02-20) physically deleted 15 files including
`Mathlib/SetTheory/Ordinal/NaturalOps.lean` from mathlib4 master. mfact's pin `fabf563a`
(2026-06-15) postdates the removal.

- Citations: <https://github.com/leanprover-community/mathlib4/pull/28063>,
  <https://github.com/leanprover-community/mathlib4/commit/08657ed7f8> (both fetched via
  GitHub REST API, file-list confirmed).
- Scout: mathlib-gaps-for-mfact.
- Gap closed: corrects the epistemic status of the roadmap's own claim that "any doc
  claiming Mathlib ships `Ordinal.nadd` is stale" — it undersells how stale: this was
  deliberate, permanent architectural policy, not staleness pending a pin bump.

### 21. Mathlib PR series #39912–#39941 (base #28728) — Perron-Frobenius, in flight

A coordinated, 15+-PR, in-progress formalization of Perron-Frobenius theory for nonnegative
matrices (Collatz-Wielandt bounds, Perron eigenpair existence/uniqueness for irreducible and
primitive matrices, spectral dominance, simplicity of the Perron root), opened 2026-05-27
and **still open, unmerged**, building on the already-merged #28728.

- Citations: <https://github.com/leanprover-community/mathlib4/pull/39922>, `/39920`,
  `/39923`, `/39919`, base `/28728` (all fetched directly via GitHub REST API).
- Scout: mathlib-gaps-for-mfact.
- Gap closed: `ROADMAP_MATH_SPINE.md`'s flagged "Perron-Frobenius and CKA remain Mathlib
  gaps to scope before any promise" for the P13 planner-frozen-phase conjecture. Not
  mergeable into mfact's pin today — P13 cannot claim it as available — but this is the
  concrete, trackable upstream work item to cite instead of leaving the gap unscoped; mfact
  could also review/comment, since the exact lemmas needed match what a planner-frozen-phase
  spectral argument would require.

### 22. Concurrent Kleene Algebra — confirmed absent from the Lean ecosystem (negative)

GitHub code search for "concurrent Kleene" across mathlib4 returns 0 hits. Mathlib's only
Kleene-algebra file (`Mathlib/Algebra/Order/Kleene.lean`) formalizes only sequential
(single-operator) Kleene algebra with no exchange/interchange law — the defining feature of
CKA is absent. General web search found no Lean 4 CKA formalization anywhere, only
Isabelle/HOL work and pure-math papers.

- Citation: GitHub code search
  `repo:leanprover-community/mathlib4 "concurrent Kleene"` (0 hits, confirmed via API,
  `total_count=0`); `Mathlib/Algebra/Order/Kleene.lean` fetched directly.
- Scout: mathlib-gaps-for-mfact.
- Confidence: COULD_NOT_VERIFY (this is a negative/absence finding — reported honestly per
  the session's own discipline, not treated as a discovered tool).
- Gap closed / validated: confirms mfact's own "Correction 5 — CKA is scoped to the
  series-parallel POWL fragment" is not a workaround for existing-but-unintegrated tooling;
  it is the actual state of the art. If mfact wants full CKA, it originates the work itself.

---

## Tier 5 — Generation-as-verification prior art (the literal "11" pattern)

VERIFIED_EXISTS. These are the closest real answers to "what does generation and
verification as one motion actually look like, at scale, today." Read the honest caveats —
scouts were careful to distinguish "same process" from "separate but synchronous and
unbypassable process."

### 23. LeanCopilot (`lean-dojo/LeanCopilot`)

Runs LLM inference natively inside the Lean process via FFI (CTranslate2 linked directly
into the Lean binary). Its `search_proof` tactic combines LLM-generated tactics with
`aesop` to search for multi-tactic proofs, executed as an ordinary Lean tactic in the same
elaboration as the surrounding proof.

- Citation: <https://github.com/lean-dojo/LeanCopilot>; paper arXiv:2404.12534 (NeurIPS
  2025).
- Scout: proof-automation-verification.
- Why it matters: `search_proof` is structurally incapable of reporting "found a proof"
  without that proof already having been executed and kernel-checked in the same process —
  there is no separate grading step to skip or get wrong, and no second artifact that can
  disagree with reality.

### 24. `llmstep` (`wellecks/llmstep`)

A smaller, more auditable version of the same principle: sends the current proof state to
an LLM, gets candidate next steps, and — per its own description — "uses Lean to check
whether each suggestion is valid and/or completes the proof" before ever surfacing it.

- Citation: arXiv:2310.18457; <https://github.com/wellecks/llmstep>.
- Scout: proof-automation-verification.
- Why it matters: the minimal reference design if mfact wants a tactic-level
  "suggest-and-immediately-kernel-check" loop for its own proof repair, e.g. auto-patching
  entries in `GAP_LEDGER_v26.7.12.md`, rather than continuing to bolt a post-hoc audit
  script onto whatever an LLM or external package produced.

### 25. LeanDojo / ReProver, superseded by LeanDojo-v2

Extracts proof states/tactics/premises from real, kernel-checked Lean repos (not from any
package's self-description of its own theorems) and provides a programmatic interaction
environment with a running Lean process. NeurIPS 2023 oral.

- Citations: arXiv:2306.15626; <https://github.com/lean-dojo/LeanDojo> (now deprecated in
  favor of <https://github.com/lean-dojo/LeanDojo-v2>); <https://github.com/lean-dojo/ReProver>.
- Scout: proof-automation-verification.
- Caveat carried forward: LeanDojo's proof search calls a real Lean process per tactic step
  — a separate-process boundary (unlike LeanCopilot's in-process FFI) — but synchronous and
  unbypassable, with no human or CI step interposed.

### 26. DeepSeek-Prover-V2 / V1.5, and AlphaProof (Google DeepMind)

Two published, large-scale existence proofs that a training/inference loop can make the
formal verifier the *only* source of truth for "did this work," with zero human or CI
review interposed between a candidate proof and its verdict. DeepSeek-Prover trains via RL
with the Lean checker as the reward signal ("the verifier is the oracle — no human
annotation of correctness needed"). AlphaProof is an AlphaZero-style agent operating
entirely inside the Lean environment: only kernel-accepted moves count as moves the search
can take credit for. AlphaProof + AlphaGeometry 2 reached IMO 2024 silver-medal-equivalent
performance, later published in Nature (peer-reviewed).

- Citations: arXiv:2504.21801, arXiv:2408.08152 (DeepSeek-Prover);
  <https://deepmind.google/blog/ai-solves-imo-problems-at-silver-medal-level/> and
  <https://www.nature.com/articles/s41586-025-09833-y> (AlphaProof).
- Scout: proof-automation-verification.
- Why it matters most for the "11" framing: AlphaProof's search process has no
  representation of "plausible but unchecked" — a move that isn't kernel-accepted simply
  isn't a move the search can take credit for. mfact's tooling currently *can* represent
  "plausible but unchecked" (a wrong or stale JSON audit file is exactly that
  representation). Closing that gap means removing the ability to write such a claim at all
  except as a direct, same-step consequence of a real kernel check.

---

## Tier 6 — Theoretical grounding for the doctrine

VERIFIED_EXISTS. Less directly actionable as code, but gives mfact citable, named academic
categories for failure modes it has been reinventing ad hoc.

### 27. Pollack-inconsistency (Freek Wiedijk) and HOL Zero's fix (Mark Adams)

Wiedijk names and formalizes the exact failure this session hit repeatedly: a system can be
logically consistent (never proves `False`) yet still be "Pollack-inconsistent" — the
human-readable rendering of a theorem (what a claim matrix reports) does not correspond to
the formal content the kernel actually checked, e.g. it doesn't round-trip through
parse/print. Adams documents a shipped, production fix in HOL Zero: the pretty-printer and
parser are designed so print-then-reparse is provably an identity.

- Citations: Wiedijk, ENTCS 285 (2012), pp. 85–100,
  <https://www.sciencedirect.com/science/article/pii/S157106611200028X>; Adams, ITP 2016,
  <https://link.springer.com/chapter/10.1007/978-3-319-43144-4_2>.
- Scout: ambient-authority-formal-epistemics.
- Gap closed: gives mfact's own claim-matrix/GAP_LEDGER report generation a formal category
  to audit against, and a template — never let a human-readable ledger description drift
  from what Lean actually elaborated, by making report generation itself round-trip-checked
  rather than hand-written.

### 28. Proof-Carrying Code (George Necula, POPL 1997)

The foundational architecture where a code producer must ship a machine-checkable proof
alongside untrusted code; the consumer's trusted computing base shrinks to a small, fixed
checking algorithm, never the process that generated the proof.

- Citation: <https://courses.grainger.illinois.edu/cs421/fa2010/papers/necula-pcc.pdf>.
- Scout: ambient-authority-formal-epistemics.
- Gap closed: gives mfact's "No Ambient Theorem Authority" doctrine its most-cited
  formal-methods ancestor outside Lean-specific tooling — a hand-rolled verifier, an
  LLM-authored audit JSON, and a "kernel receipt" are all "producers" in Necula's sense, and
  none are entitled to standing on their own say-so.

### 29. De Bruijn criterion vs. LCF architecture (Paulson; Barendregt & Wiedijk)

Names two rival trust-minimization architectures. De Bruijn criterion: store the full
low-level proof term so it can be independently re-checked by multiple checkers (what
`leanchecker`/`comparator`/`nanoda` give Lean today). LCF architecture: expose theorems only
as an abstract type whose sole constructors are the primitive inference rules, so nothing
can *become* a `theorem` except by successfully calling through the trusted kernel's API —
proof objects are never even materialized as a separate, forgeable artifact.

- Citations: Paulson, <https://lawrencecpaulson.github.io/2022/01/05/LCF.html>; Barendregt &
  Wiedijk, Phil. Trans. R. Soc. A 363(1835), 2005, <https://doi.org/10.1098/rsta.2005.1650>.
- Scout: ambient-authority-formal-epistemics.
- Gap closed: mfact's Lean side already gets LCF architecture for free from Lean's own
  kernel. The open question this surfaces is the *Rust* side — `.ggen-v2/receipt.json` and
  `mfact-core`'s broker currently populate a "verified" status by convention (a script
  writes a JSON field), not via an LCF-style abstract type that can only be constructed by
  successfully invoking the kernel or `leanchecker`. Concrete, citable target for
  redesigning `mfact-core`'s own receipt/broker types.

### 30. Metamath's multi-verifier culture, and GDV/CASC/TPTP independent proof verification

Metamath's `set.mm` is routinely re-checked by 19+ independently-authored verifiers in
different languages by different authors (C, Java, Rust, C++, Python) — a proof is trusted
because it has been independently re-derived by implementations sharing no code, not
because any single verifier says so. Separately, in the CADE/IJCAR ATP System Competition
(CASC), first-order prover output is never trusted from the system that found it — GDV
independently checks both semantic validity (each inference step's conclusion is a genuine
logical consequence) and structural well-formedness before a proof is credited, and has run
as production competition infrastructure for two decades.

- Citations: <https://us.metamath.org/mpeuni/mmset.html>; G. Sutcliffe, "Semantic
  Derivation Verification," IJAIT 15(6), 2006,
  <https://www.cs.miami.edu/home/geoff/Papers/Journal/2006_Sut06_IJAIT-TBA.pdf>;
  <https://tptp.org/CASC/>.
- Scout: multi-agent-formal-verification.
- Gap closed: not Lean-specific, so adjacent rather than directly adoptable, but the
  clearest citable standard for "a claim shouldn't count as verified until checked by at
  least two independently-authored code paths" — exactly the standard mfact's four prior
  external-package integrations failed to meet.

---

## Lower-confidence findings

Reported here, clearly separated, per the session's own discipline: scout uncertainty does
not get upgraded to confidence in this report.

### LIKELY_EXISTS_UNCONFIRMED_DETAILS

- **Lake's v4.30.0 native artifact cache — exact config surface.** Existence of the
  feature (PRs #12634/#12927/#12974) is confirmed directly against Lean release notes; the
  specific env var/config field name reported by the scout's search summary was not
  independently re-verified against a primary doc page. Action: run `lake --help` /
  inspect `Lake.Config` on the pinned 4.31.0 toolchain before relying on it. Scout:
  lake-tooling-maturity.
- **"Hypothesis-Disciplined Multi-Agent Automated Formalization of Asymptotic Statistical
  Theory"** (arXiv:2606.20642, Wei, Zheng, Fang, Lu). Title, authors, and abstract confirmed
  directly on arXiv — a multi-agent Lean formalization pipeline whose audit process requires
  every hypothesis/definition to trace back to source math before admission, self-described
  as "axiom-clean and source-faithful." Architecture specifics beyond the abstract (the
  exact 7 specialist roles, whether any role adversarially rejects another's work rather
  than just reviewing it) came from a single automated summary the scout did not
  independently read line-by-line. Treat existence as solid, architecture claims as
  unconfirmed. Scout: multi-agent-formal-verification.

### COULD_NOT_VERIFY

- **Metatheory — confluence/Newman's-lemma Lean library** (arXiv:2512.09280). The paper's
  existence and content (10,367 LOC, 497 theorems, diamond property, Newman's lemma proper,
  Hindley-Rosen, instantiated on 6 rewriting systems including STLC) are confirmed directly.
  Its own claimed code repository, `github.com/arthuraa/metatheory`, **404s** — that GitHub
  account belongs to a different, unrelated researcher. The scout could not locate the
  actual repository via GitHub search, code search, or web search. **Do not cite that URL.**
  This is itself a live instance of the self-report-vs-reality gap this whole session has
  been chasing, caught in the research process. If mfact wants Newman's-lemma machinery for
  `ROADMAP_SWARM_SUPPLY_CHAIN.md`'s T1 causal-DAG replay theorem, the paper is real
  motivation but the code has not been located. Scout: formal-supply-chain-distributed.
- **Petri-net place-invariant / chemical-reaction-network conservation formalization.**
  Negative finding: targeted search of arXiv, the Isabelle AFP, and general web search found
  no Coq/Isabelle/Lean formalization of stoichiometric conservation as a machine-checked
  invariant (the adjacent-but-distinct Karp-Miller coverability result was found instead,
  ACM CPP 2017, <https://dl.acm.org/doi/10.1145/3018610.3018626>). Relevant to
  `ROADMAP_SWARM_SUPPLY_CHAIN.md`'s D3: if mfact wants D3 promoted from accounting-identity
  to admitted invariant, it likely has to build that proof itself over Mathlib's
  linear-algebra machinery (kernel of the stoichiometry matrix) rather than reuse an
  existing library. Scout: formal-supply-chain-distributed.
- **CKA absence** — see Tier 4, finding #22 (negative finding, listed there for topical
  proximity to the other Mathlib-gap findings).

---

## Distributed-systems formal-verification prior art (swarm roadmap, adjacent)

VERIFIED_EXISTS but a more distant match to the session's core ask (Lean-audit discipline)
than to `ROADMAP_SWARM_SUPPLY_CHAIN.md` specifically. Listed for completeness, ranked below
the tiers above.

- **Isabelle/HOL CRDT framework** (Gomes, Kleppmann, Mulligan, Beresford; OOPSLA 2017,
  arXiv:1707.01747; AFP entry, <https://www.isa-afp.org/entries/CRDT.html>) — machine-checked
  abstract convergence theorem instantiated on three real CRDTs, with an explicit axiomatic
  causal-broadcast network model. Closest machine-checked analogue to the swarm roadmap's
  D5/T1 coalition-antichain and causal-DAG replay claims, currently marked CONJECTURAL.
- **Verdi / Verdi-Raft** (Wilcox et al., PLDI 2015; <https://github.com/uwplse/verdi>,
  <https://github.com/uwplse/verdi-raft>) — Coq framework with verified fault-model
  transformers, including the first mechanically checked linearizability proof of Raft,
  extracted to a working OCaml key-value store. Concrete existence proof of "proof →
  extraction → running system" for a distributed protocol.
- **Chapar** (Lesani, Bell, Chlipala; POPL 2016;
  <https://github.com/rocq-community/chapar>) — Coq operational semantics for causal
  consistency in KV stores, extracted to running OCaml. Direct template for the causal-order
  base case the swarm roadmap's D6 causal-DAG needs before layering confluence on top.
- **IronFleet** (Hawblitzel et al., SOSP 2015;
  <https://github.com/microsoft/Ironclad>) — TLA-style refinement (spec → protocol →
  implementation) embedded inside Dafny, proving both safety and liveness of a Paxos-based
  RSM and a sharded KV store. Worked example of exactly the realization-map proof
  obligation the swarm roadmap's `kappa_runtime` (AbstractActorTransition →
  AtomVMTransition) currently has open and untyped, including liveness.
  Scout: formal-supply-chain-distributed.
- **Consensus Refined** (Marić & Sprenger, AFP 2015,
  <https://www.isa-afp.org/entries/Consensus_Refined.html>) — reusable, parametric
  stepwise-refinement framework covering Paxos/Ben-Or/One-Third-Rule under one abstraction.
  Relevant if mfact's swarm layer ends up needing more than one coordination protocol
  variant.
- **A Sheaf-Theoretic Characterization of Tasks in Distributed Systems** (Felber, Hummes
  Flores, Rincon Galeana; arXiv:2503.02556; SIROCCO 2025) — real sheaf-theoretic
  mathematics (not metaphorical) proving task solvability iff a global section exists.
  Honestly flagged: no Coq/Lean/Isabelle mechanization of this or the broader
  sheaf-for-distributed-computing program was found — paper-only math. Confirms the swarm
  roadmap's T3 CONJECTURAL marker is appropriate, not conservative-to-a-fault.
  All five: scout formal-supply-chain-distributed.

---

## Top 5: how mfact would actually use these

**1. `leanchecker` in CI, plus fixing the 11 dead workflows, this week.** These two findings
compound. First, fix finding #7 mechanically: move the 11 `research-papers/*/.github/
workflows/lean_action_ci.yml` files to repo-root `.github/workflows/`, each named
distinctly, each pointed at its package via `lake-package-directory:`, following the pattern
already correct for `mfact` and `procint`. Second, add one job to each of those workflows
(and to the existing `ci.yml`) that runs `lake env leanchecker` (or `--fresh <Module>` for a
clean-environment replay) as a separate step after the normal build. Zero new dependencies —
leanchecker ships in the pinned 4.31.0 toolchain. This single change converts every one of
mfact's Lean packages from "nothing checks these on push" to "an independent kernel replay,
architecturally decoupled from the elaborator that built the `.olean`s, checks these on
every push" — the exact upgrade the session's four failed self-reports needed and didn't
have.

**2. `axiom-audit` as the hard gate for `native_decide` and `sorry`, wired right after
`leanchecker`.** Pin `leanprover-community/axiom-audit` as a Lake dependency (or vendor its
~200 lines given its newness) and run it with `--json` in the same CI job, failing the build
on any axiom outside `{propext, Classical.choice, Quot.sound}`. Concretely: any proof in
`research-papers/*` or `procint/` currently using `native_decide` will show up as depending
on `Lean.ofReduceBool`, and will fail CI until either re-proved with an actual `Decidable`
instance or explicitly added to the allowlist with a comment justifying it — turning "we
used native_decide because deciding this was hard" from an invisible shortcut into a
reviewed, named exception, which is exactly the discipline gap the task brief names.

**3. `nanoda_lib` linked into `crates/mfact-core` for a genuinely independent second kernel.**
mfact-core is already a Rust workspace with a live Lean FFI surface (`lean.rs`,
`lean_ffi_wrapper.c`, `broker.rs`). Add `lean4export` as a build step producing NDJSON for
each package's compiled environment, then link `nanoda_lib` (Rust, zero shared code with the
Lean toolchain) directly into `mfact-core`'s existing receipt-generation path so
`.ggen-v2/receipt.json` carries a cross-kernel-agreement field as part of the receipt
itself — "the Lean kernel accepted this" and "an independently-authored Rust kernel,
consuming a portable export, also accepted this" become two separate, both-required facts
in the same receipt, rather than mfact trusting one kernel's verdict (and one process's
report of that verdict) as the sole source of truth.

**4. Aeneas + Charon as the concrete mechanism for discharging `kappa_graft`.** For the
specific Rust components mfact needs a checked correspondence for, run Charon over the
already-written/generated Rust crate to lift its MIR to LLBC, then Aeneas to produce the
corresponding pure/monadic Lean 4 code. State the graft correspondence as an equality or
simulation theorem between mfact's existing abstract Lean model and the Aeneas-generated
Lean mirror of the real Rust, and discharge it as an ordinary Lean proof. This is a
different, more mature direction than waiting on Peregrine's still-unverified Lean-frontend
extraction (finding #18) — Aeneas is the currently-working half of the round trip (Rust →
Lean, checked), not the currently-research-stage half (Lean → Rust, unverified).

**5. `axiom-audit`'s and `leanchecker`'s output format as the schema for `GAP_LEDGER`
verification fields.** Right now GAP_LEDGER entries carry hand-written `Verdict` and
`Evidence` lines produced by whatever agent worked the gap. Adopt `axiom-audit --json`'s
per-declaration axiom-closure output and `leanchecker`'s pass/fail-per-module output as the
*only* legitimate source for any GAP_LEDGER line that claims "sorry-free" or "kernel
verified" — i.e. such a claim in the ledger should be mechanically generated from these
tools' JSON output, not typed by an agent summarizing what it believes to be true. This
directly targets the Pollack-inconsistency risk (finding #27): a ledger entry's prose
description must never be allowed to drift from what the kernel-truth tools actually
reported.

---

## Honest accounting: what fraction of "11" is real today

The kernel-independence layer — the part of "11" that means "an artifact, once built,
cannot lie about whether the kernel actually accepted it" — is **substantially solved and
available today**, for free, in mfact's own pinned toolchain. `leanchecker`,
`axiom-audit`, `lean4export` + `nanoda_lib`/`comparator`, and Lean4Lean together give mfact
everything from "replay the same kernel a second time" through "check with a genuinely
independent second kernel implementation" through "prove properties of the kernel itself" —
the last of these being an active research frontier, but the first two are boring, shipped,
zero-install, and simply not wired into mfact's CI yet. This is the fraction of "11" that
is pure execution debt, not research debt.

The correspondence-proof layer (`kappa_graft`, `kappa_runtime`) is **partially closeable**
with real, working prior art (Aeneas/Charon for the Rust direction; WasmCert/LeanWasm/
Core-Erlang-Formalization for target-side semantics), but every scout who looked here was
careful to distinguish mature, production-tested tooling (Aeneas) from research-stage,
self-admittedly-unverified tooling (Peregrine's Lean frontend) — and none of it is a
drop-in proof of mfact's specific correspondences. Someone still has to write and discharge
the actual theorems; the ecosystem supplies the target semantics and translation machinery,
not the proof.

The generation-as-verification layer — the literal "11" framing of "cannot present
unverified work as verified because there is no separate step where that could happen" —
is where the honest answer is weakest. LeanCopilot and llmstep are real, working,
same-process examples, but they operate at the tactic-suggestion grain (does this next
tactic close this goal), not at the grain mfact needs (does this entire package/paper
correspond to what it claims to formalize). DeepSeek-Prover and AlphaProof are the
strongest existence proofs that "the verifier is the only oracle, full stop" scales to
real research problems — but they are theorem-proving-competition systems generating and
checking short, well-specified Lean goals, not a general answer to "generate an entire
research-paper formalization and its own correctness claim as one inseparable motion."
**Self-verifying generation-as-one-motion, at the grain and scope mfact actually operates
at (whole formalized papers with accompanying claim matrices), does not appear to exist as
off-the-shelf tooling in this ecosystem today.** The nearest real approximation — mfact
generating a ledger entry only as a mechanical readout of `axiom-audit`/`leanchecker`
output rather than as agent prose (Top-5 item #5) — is itself something mfact would have to
build, using the verified primitives this survey found, not something it can adopt whole.
