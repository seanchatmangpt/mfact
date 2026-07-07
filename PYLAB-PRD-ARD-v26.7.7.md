# PYLAB — Product & Architecture Requirements Document

**Version:** v26.7.7 (matches the repo's core-release versioning convention; this document itself carries no release standing)
**Status:** Partially Applied — see §6 for what's live
**Date:** 2026-07-07

> **Status as of this revision:** `pylab/` exists (scaffolded via `superlinear-ai/substrate`), the §6 governance diffs are applied, all six tool dependencies plus `fastmcp` are wired into `pylab/pyproject.toml` via `uv add`, and a real MCP server (`math_factory_pylab.mcp_procint.server`) is implemented and verified — not the l2p-specific wrapper originally scoped in §10 of the first revision, but a general-purpose server exposing read-only Lean/Lake/`just` introspection plus one real tool per pylab library. See §6 and §10 for exact current state.

---

## 1. Purpose & Scope

`pylab/` is the Python-language counterpart to `procint/Playground/` (the existing hand-authored, unledgered Lean demonstration surface). It exists for the same reason Playground exists — worked, runnable instances of algorithms the repo cares about — but for tools that have no reasonable Lean formalization: AutoML pipeline search, the pm4py process-mining ecosystem, and LLM-to-PDDL generation. `procint/Playground/` proves ProcInt's own math is used, not just declared; `pylab/` does the analogous job for the surrounding Python tool ecosystem this session surveyed.

`pylab/` never feeds release standing, gates, or the manifest — same governance tier as Playground, different language.

## 2. Non-Goals

- **No correspondence/proof claims.** Nothing in `pylab/` is claimed to be semantically equivalent to, or a proof about, any Lean formalization in `procint/ProcInt/`. This mirrors the STATED-only discipline already established for `ProcInt.Planning.Pddl` (committed `1654a9b`): citation and analogy only, never an unearned equivalence claim.
- **Not an execution engine.** `~/bcinr/crates/bcinr-powl`'s branchless scheduler is already a live, steppable POWL v2 execution engine. `pylab/` does not replace it, compete with it, or attempt to reimplement POWL execution semantics in Python.
- **Not cross-repo wiring.** Fixing `~/powlv2lsp/src/validation/rust_bridge.ts`'s stale `POWL_RUST_WORKSPACE_PATH` and reconciling its op-code numbering against `~/bcinr/crates/bcinr-powl/src/tape.rs`'s `OpKind` enum are real, identified follow-ups — but they belong to those repos' own sessions, not this one.
- **Not part of the manufacturing pipeline.** Never added to `just build`, `just check`, `just release`, or `.mfact/artifacts.toml`. A failure in `pylab/` is an ordinary code-review issue, never `ARTIFACT_DRIFT_REFUSED` or a release-standing regression.

## 3. Tool Inventory

Every tool below was researched (PyPI + GitHub, live maintenance status confirmed) during this session, and each already has a corresponding Registry citation committed in `ProcInt` (`ontology/procint-schema.ttl` → `procint/ProcInt/Registry/{Breeds,Algorithms}.lean`, commit `1654a9b`).

| Tool | What | Why in scope | Registry citation |
|---|---|---|---|
| **TPOT2** (now merged into mainline `tpot`, v1.1.0, July 2025) | Genetic-programming AutoML: evolves scikit-learn pipelines as DAGs (not trees, unlike TPOT1), multi-objective selection over accuracy/complexity. Originally Cedars-Sinai A2I Lab, successor to Epistasis Lab's TPOT. | The user's own reference tool for AutoML/pipeline-search experimentation. | `breed_tpot2` |
| **pm4py** (`process-intelligence-solutions/pm4py`, very active, ~980★) | Core Python process-mining library. Confirmed as the actual reference implementation of both OCEL 2.0 and Improved Token-Based Replay (ITBR) — the paper for ITBR states this directly. | Foundation dependency for `powl` and `ocpa` below; general process-mining tooling. | `pi:Algo_ocel2`, `pi:Algo_itbr` |
| **powl** (PyPI; canonical repo `fit-process-mining/POWL`, Fraunhofer FIT) | POWL v2 discovery, conversion (Petri net ↔ BPMN ↔ POWL), and object-centric POWL discovery straight from OCEL. Hard-depends on pm4py. Very active (~monthly point releases). | Direct Python-side counterpart to the POWL v2 semantics `~/bcinr/crates/bcinr-powl` executes natively in Rust. | `pi:Algo_powl_v2` |
| **ocpa** (`ocpm/ocpa`) | Object-centric process analysis: OCEL 2.0 sqlite import, object-centric Petri net discovery, object-centric conformance/enhancement/predictive-monitoring. Maintained, slower cadence than pm4py/powl. | Concrete OCEL 2.0 data source for exercising object-centric process analysis in Python. | `pi:Algo_ocpa` |
| **pddl-plus-parser** (`argaman-aloni/pddl_plus_parser`) | Parses **PDDL+** — continuous processes/events/numeric hybrid semantics, a strict superset of the PDDL 3.1 STRIPS/ADL fragment. Also parses plan trajectories from external solvers (Metric-FF, ENHSP). Actively maintained (17+ releases). | The genuinely complementary PDDL package versus the Rust `pddl = "0.2"` crate already used by `~/bcinr/crates/bcinr-pddl` (which only covers PDDL 3.1, no continuous/hybrid dynamics). Useful for benchmark/domain sourcing and cross-validating parsed structures against an independent implementation. | (none yet — candidate `pi:Algo_pddl_plus`, not added this session) |
| **l2p** (`AI-Planning/l2p`, Queen's University, Tantakoun/Muise/Zhu) | LLM-to-PDDL: generates domain/problem PDDL from natural language via an LLM, validated against Fast Downward and the Unified Planning framework. Actively maintained (v0.4.1, June 2026). | Natural-language planning-model generation; candidate front end for STRIPS-style experimentation. **No MCP server exists for it yet** — building one (`generate_domain`/`generate_problem`/`validate_pddl`/`solve`) is a legitimate, distinct follow-up project, not core `pylab/` scope. Decided: built with **FastMCP** (see §10). | `breed_l2p` |
| **CoCoMoT** (`bytekid/cocomot`) — reference only, not a `pylab` dependency | SMT-based conformance checking with uncertainty (data Petri nets, Yices2/Z3 backends). | Cited for completeness; no plan to depend on it directly from `pylab/`. | `pi:Algo_smt_conformance` |

## 4. Rejected Alternative: SpiffWorkflow

SpiffWorkflow (`sartography/SpiffWorkflow`, active, ~1.9k★) was seriously considered as a live POWL v2 execution engine, then explicitly rejected. It is fundamentally BPMN-token-based: sequence flows and gateway types (exclusive/parallel/inclusive) compiled into a `TaskSpec` tree. Feeding it a POWL partial-order block would require a lossy graph transformation — arbitrary partial orders don't reduce cleanly to nested AND/XOR gateways without auxiliary dummy tasks. Since `~/bcinr/crates/bcinr-powl` already implements POWL v2 execution natively (branchless SWAR scheduler, `scheduler_tick()`, exact op-kind semantics), there was no reason to adopt a lossy BPMN intermediary. Recorded here so this decision isn't re-litigated in a future session.

## 5. Scaffold

`pylab/` is scaffolded via [`superlinear-ai/substrate`](https://github.com/superlinear-ai/substrate), a **Copier** template (not cookiecutter — explicitly deprecated in substrate's own v2.0.0):

```sh
uvx copier copy gh:superlinear-ai/substrate pylab
```

- **Package manager:** `uv` (`uv_build` backend)
- **Lint/format:** `ruff`
- **Type checker:** `ty` (Astral's newer checker, replaced mypy in substrate v2.0.0)
- **Tests:** pytest + coverage.py
- **CI:** GitHub Actions (this repo already uses GitHub)
- **Docs:** MkDocs (only if `pylab/` grows enough to warrant it — optional at scaffold time)
- **Python version:** 3.13 (as actually scaffolded; `pyproject.toml` pins `requires-python = ">=3.13,<4.0"`)
- **Mode:** app (as actually scaffolded, with `with_fastapi_api: true` and `with_typer_cli: true`) — not package mode as originally assumed in this document's first revision
- **Package name:** `math_factory_pylab` (project name "Math Factory PyLab", per `.copier-answers.yml`)

Later re-sync with template updates is supported via `uvx copier update --exclude src/ --exclude tests/` if desired; not required for initial scaffold.

**Environment note (unrelated to this repo):** the local `uv`-managed Python 3.13.9 interpreter binary was found with its execute bit missing (`rw-------` instead of `rwxr-xr-x`), causing `uv add`/`uv run` to fail with a permission error. Fixed via `chmod +x` on the interpreter binary — a local toolchain issue, not a project configuration problem.

## 6. Governance Additions — **Applied**

### `AGENTS.md` — edit-surfaces table (applied)

Row added directly after the existing Playground row:

```
| `pylab/**` | **Yes** | hand-authored Python research/experimentation surface (TPOT2, pm4py, powl, ocpa, pddl-plus-parser) — never ggen-rendered, never ledgered; ordinary code, edit freely |
```

### `AGENTS.md` — Ledger-law clause (applied)

Paragraph added directly after the existing Playground clause:

```
`pylab/**` is likewise intentionally unledgered: it carries no standing,
counts, or certification data, so its absence from `.mfact/artifacts.toml`
is correct, not an omission. Do not add it to the ledger.
```

### `justfile` — standalone recipe (applied)

Added directly after the existing `playground:` recipe, same `[group('demo')]` isolation:

```
# Hand-authored Python research surface — never feeds standing, gates, or the manifest.
[group('demo')]
pylab:
    cd pylab && uv run pytest
```

### `pylab/pyproject.toml` dependencies (applied, via `uv add`, not hand-edited)

All six tools plus `fastmcp` were added with `uv add <pkg>` (per instruction: never hand-edit `pyproject.toml` directly, let `uv` resolve current versions):

```
"fastmcp>=3.4.3",
"ocpa>=1.3.4",
"pddl-plus-parser>=3.17.0",
"pm4py>=2.2.32",
"powl>=2.3.7",
"tpot>=1.1.0",
```

**Two real dependency issues surfaced and were resolved/documented, not this session's own bugs:**
1. `tpot` transitively depends on `stopit`, which does `import pkg_resources` at load time. Modern `setuptools` (uv resolved `83.0.0` by default) no longer ships `pkg_resources` (PyPA is removing it). Fixed via `uv add "setuptools<81"`, which still bundles it (with a deprecation warning, but functional).
2. `powl==2.3.7` does not currently import cleanly against `pm4py==2.2.32` (`ModuleNotFoundError: pm4py.algo.discovery.inductive.variants.imf` — an internal pm4py module path `powl` expects but this pm4py release doesn't have). This is a real, current incompatibility between the two packages' released versions, not fixable by a `setuptools`-style pin. `powl_discover` (§10) handles this by importing `powl` lazily and returning a structured error instead of crashing.

## 7. Regen-Check Invisibility Guarantee

`just regen-check`'s `git diff --exit-code` only walks paths listed in `.mfact/artifacts.toml` (confirmed by reading the recipe directly this session). As long as nothing under `pylab/` is ever added to that ledger, it stays structurally invisible to `regen-check` — the exact same guarantee `procint/Playground/` already relies on. No change to `regen-check` itself is needed.

## 8. Relationship to Existing Committed Work

This session also committed (`1654a9b`) a new `ProcInt.Planning.Pddl` Lean module (`PddlAction`, `PddlAction.apply`, `PddlPlan.valid` — Fikes & Nilsson 1971 STRIPS semantics) plus the Registry citations listed in §3, exercised by `procint/ProcInt/Playground/PddlPlanningWalkthrough.lean`. `pylab/`'s eventual Python code (e.g. a `pddl-plus-parser`-based experiment) and this Lean module are **two independent things that happen to model similar concepts** — not a proven-equivalent pair, and no future `pylab/` work should imply otherwise without an actual correspondence proof (which nothing in this repo currently attempts or claims).

## 9. Relationship to `~/bcinr` and `~/powlv2lsp`

Restated from the prior session's plan (Part 4), for completeness:

1. **`~/powlv2lsp/src/validation/rust_bridge.ts`** — `POWL_RUST_WORKSPACE_PATH` defaults to a stale path (`/Users/sac/insa`); should point at `~/bcinr`. Its op-code numbering (`Act=1, Choice=2, Partial=3, Loop=5, Silent=7`) doesn't match either `OpKind` enum found in `bcinr-powl/src/tape.rs` — needs disambiguation in that repo's own session.
2. **`~/bcinr/crates/bcinr-powl`** — no changes planned from this side; it remains the one live POWL v2 execution engine.

Neither is touched by this document or by `pylab/`.

## 10. `math_factory_pylab.mcp_procint` — the MCP server (built, not a stub)

Superseded the originally-scoped l2p-specific MCP wrapper: instead, a general-purpose FastMCP server was built at `pylab/src/math_factory_pylab/mcp_procint/server.py`, giving an agent direct, correct access to both the Lean/Lake toolchain and the pylab research libraries. Run via `uv run python -m math_factory_pylab.mcp_procint.server`.

**Lean/Lake/`just` tools — read-only introspection only** (no writes to source, ontology, templates, or the ledger; consistent with AGENTS.md's "diagnostic commands are read-only" rule):
- `lake_build(target)` — `lake build [target]` in `procint/`.
- `lake_env_lean(file)` — fast single-file typecheck via `lake env lean <file>`.
- `just_status()`, `just_doctor()`, `just_next()`, `just_trace(target)`, `just_why(target)`, `just_theorem_status()` — thin wrappers over the corresponding read-only `just` recipes.
- `registry_lookup(entry_id)` — looks up a breed or algorithm by id directly from `ontology/procint-schema.ttl` (regex-parsed; no Lean/ggen invocation needed). Verified against `registry_lookup(entry_id="tpot2")`.

**Pylab tools — one real implementation per library** (not stubs; each imports its library lazily inside the function body so one broken dependency can't take down the others or the server):
- `tpot_fit(csv_path, target_column, max_time_mins)` — TPOT2 classification search via `TPOTClassifier`, returns fitted pipeline repr + test accuracy (`accuracy_score`, since TPOT2's public API has no `.score()`/`.fitted_pipeline_` the way TPOT1 did — confirmed by inspecting the installed package directly, not assumed).
- `pm4py_discover_dfg(xes_path)` — `pm4py.read_xes` + `pm4py.discover_dfg`, returns DFG edges with frequency plus start/end activities.
- `powl_discover(log_path)` — calls `powl.import_event_log`/`powl.discover`; currently returns a structured error due to the real `powl`/`pm4py` incompatibility noted in §6, rather than crashing.
- `ocpa_import_ocel2(sqlite_path)` — `ocpa`'s OCEL 2.0 sqlite importer, returns object types and process-execution count (fields confirmed by inspecting the installed `OCEL` class directly).

Verified end-to-end this session: server imports cleanly, `list_tools()` returns all 13 tools, `registry_lookup` and `just_status` both tested live against the real repo state.

## 11. Open Questions / Follow-Ups

- **`powl`/`pm4py` incompatibility** — no action taken this session beyond graceful error handling in `powl_discover`; resolving it (pinning a compatible `powl`/pm4py pair, or waiting for upstream fix) is future work.
- **PDDL+ hybrid domain sourcing** — `pddl-plus-parser` can parse continuous/hybrid domains and external solver trajectories (Metric-FF, ENHSP); no concrete domain has been chosen yet for `pylab/` experimentation, and no MCP tool wraps it yet.
- **CI wiring** — whether `pylab:` should eventually run in GitHub Actions alongside (but never gating) the Lean build, once `pylab/` has enough content to be worth continuously testing.
- **`tpot_fit`'s time bound** — defaults to `max_time_mins=1.0` to keep MCP calls responsive; real experiments will want this raised, ideally as an explicit caller-supplied argument (already exposed as a parameter).
- **Note:** an unrelated, already-in-progress effort (`scripts/genetic_tactic_search.py`, `procint/ProcInt/Playground/TacticSearchWarmup.lean`, referenced by a `justfile` comment "Genetic tactic search over a Playground warm-up target — exploratory, off-ledger") exists in the working tree. It was not created by this session's work; if it's related to the AutoML/TPOT2 line of thinking, reconcile the two efforts rather than duplicating work. **Reconciled in §12:** it is the same line of thinking (GP over tactic sequences = TPOT2's evolutionary search applied to proofs); §12's roadmap upgrades that script rather than duplicating it.

## 12. Paper-Derived Implementation Roadmap

The 11 arXiv papers in `~/mfact/papers/` were read in full on 2026-07-07 (four parallel
reading passes over the PDFs, not abstracts). This section converts their mechanisms
into scoped `pylab/` work items. Everything here stays at Playground/pylab governance
tier: off-ledger, never feeds standing, LLM/search output is always an untrusted
Candidate, and kernel acceptance is the only pass signal.

**One correction the reading surfaced:** `2503.13620` ("LangConfusion") is *not* a Lean
paper — it is Moumoula et al., *Programming Language Confusion*, a general study of
LLMs emitting the wrong programming language (no Lean, no MiniF2F anywhere in it).
The Lean 3-vs-Lean 4 confusion evidence actually lives in TheoremLlama's Appendix A
(GPT-4 emits `begin…end`, `import data.*`, snake_case Lean 3 names despite explicit
Lean 4 instructions) and APOLLO's Syntax Refiner appendix (the regex rule inventory
that fixes those artifacts). `paper/main.tex`'s AI-disclosure paragraph was corrected
accordingly the same day.

### 12.1 Tier 1 — Fitness oracle: persistent server instead of subprocess-per-candidate

The single highest-leverage change. `scripts/genetic_tactic_search.py` currently pays a
full `lake env lean` subprocess (fresh import elaboration) per candidate. Three papers
independently converge on the fix:

- **Lean Copilot** (2404.12534): never recompile — apply candidates to a live elaborator
  state and read back success/remaining-subgoals (its green/blue signal; 74.2% of proof
  steps automated with Aesop best-first over LLM-suggested rules).
- **HOList** (1904.03241): a *stateless* `apply(state, tactic) → subgoals | error` API is
  what makes arbitrary search strategies pluggable; fast startup (pay library loading
  once) was essential; subgoal sharing via a transposition table is called out as the
  thing that prevents rewrite oscillation.
- **LeanNavigator** (2503.04772): 0.12 s per tactic application through an interactive
  session (LeanDojo) vs seconds per cold subprocess — 1–2 orders of magnitude.

**Work item `proof_env.py`** (extends `lean_lsp.py`, the component this repo already
has working): one persistent `lake env lean --server`; `didOpen` a scratch file once
(frozen import + statement prefix, mutable tactic region at the end to maximize
snapshot reuse); per-generation, pack N candidates as N sibling `example … := by …`
blocks in one `didChange` and attribute diagnostics to candidates by line range; grade
each as **Error / Stagnation / Progress / Solved** using diagnostics plus
`$/lean/plainGoal` (goal-state text hash for the stagnation check). Expose as an MCP
tool. Final acceptance of any winner is still one cold `lake env lean` run on the
assembled file — the search harness never becomes trusted (HOList's checker discipline).

### 12.2 Tier 2 — Search quality: mined vocabulary, bigram prior, cost cascade

- **`tactic_mine.py`** — replace the hand-picked 9-tactic vocabulary with a data-derived
  one. LeanNavigator's template normalization (`rw [mul_comm a b]` →
  `rw [mul_comm {var0} {var1}]`) collapses variable-name sparsity; mine template
  frequencies **and the tactic-bigram (parent → child) transition matrix** from
  `procint/`'s own `.lean` sources (plus the Mathlib dependency cache if wanted).
  Instantiate `{var}`/`{hyp}` placeholders from the current goal's hypothesis names via
  `proof_env.py`.
- **Bigram prior, used the way the evidence supports** — the PGTS paper (2604.24354)
  mines *contiguous, parameter-normalized* tactic patterns (PrefixSpan, ≥1% support)
  from human proofs and re-ranks candidates whose (parent, child) transition matches a
  mined pattern: **+8.05% theorems proved on average across four Coq tools, +20.8%
  shorter proofs**. Its "correlation with success" claim is a conformance *ordering*
  (Progress > Stagnation > Error), not a coefficient — the GP's shaping term and any
  write-up must say so. Reordering mutation/expansion candidates by bigram frequency is
  the intervention that earned the +8.05%; a raw fitness bonus is the weaker cousin.
- **Cheap-first cascade** — Lean-auto's measured per-tactic costs (rfl 5.7 ms →
  simp_all ~44 ms → aesop ~92 ms → auto+duper ~1.1 s, Mathlib, 10 s budget) are a
  ready-made evaluation-order const table for the GP: try cheap closers before
  expensive genes. A const-table change, no new subsystem.
- **Two cheap ablation-backed tweaks from HTPS** (2205.11491): log only the *minimal*
  proof per solved target as the exemplar (training on minimal proofs beat
  training-on-all, 78.1% vs 40.6% cumulative in their Equations ablation), and
  randomize search hyperparameters per attempt (~+4% in theirs).
- **Deferred: HTPS-lite AND-hypergraph search** — per-goal nodes, W/N statistics,
  product-of-children backup, Solved/Invalid propagation, with the mined bigram table
  standing in for the learned policy. Only worth building if the upgraded flat GP
  stalls on real targets; the flat loop plus Tier 1/2 comes first (smallest diff).

### 12.3 Tier 3 — Deterministic repair harness (no LLM in the harness)

APOLLO (2505.05758) is mostly reimplementable without its LLM: its Syntax Refiner,
Sorrifier, and Auto Solver stages are deterministic, and its headline economics
(Kimina 70.8% @1024 samples → 75.0% @~307 with repair; o4-mini 7.0% → 46.7%) come from
*decomposition*, not model quality.

**Work item `repair.py`** (+ MCP tool `sorrify_and_autosolve`), pipeline order:

1. **Lean 3-ism lint** — deterministic classifier `(verdict ∈ {lean4, lean3, mixed},
   evidence)` over candidate text. Rule inventory from APOLLO A.1 + TheoremLlama
   App. A: `begin…end` blocks, `import data.*`/`import tactic`, snake_case dotted
   names (`finset.range`), `λ x, e` comma-lambdas, `admit`. Architecture (detect →
   parse → compare, plus the lesson that *parseability is a false quality signal*)
   from the PL-confusion paper — which is what that paper legitimately supports.
2. **Syntax refiner** — const regex table (Lean 3 → Lean 4 rewrites); log fired rules
   as candidate metadata. Per APOLLO's ablation this only matters for
   general-purpose-model candidates, near-zero for dedicated provers.
3. **Sorrifier** — parse the tactic-block tree (indentation + `by`/`·` is enough for
   v1), use `proof_env.py` diagnostics to locate failures, apply line-removal /
   block-removal / sorry-insertion until the file compiles with only `sorry`
   warnings. Set APOLLO's `pp.*` option block when extracting sub-goals so types are
   explicit.
4. **Auto solver** — try the fixed suite (`hint`, `nlinarith`, `norm_num`,
   `norm_cast`, `ring_nf`, `simp`, `simp_all`, `omega`) on each sorry hole.
5. **Residual sorries → the GP searcher** — each unsolved hole becomes a standalone
   sub-goal with local context; sub-lemmas needing 1–3 tactics are exactly the regime
   where tactic-recombination search is plausible. This is APOLLO's recursion with the
   GP in the LLM's seat.
6. **Verified-exemplar pool** — kernel-accepted results append to an exemplar file
   that seeds future runs (TheoremLlama's iterative loop; measured +2 pts per round).
   Pool records use TheoremLlama's OBT-style schema with a **pinned commit** field.

### 12.4 Tier 4 — Second-kernel check (the one receipt-relevant item)

Lean4Lean (2403.14064) is a complete, feature-parity Lean 4 typechecker written in
Lean, invokable as `lake env lean4lean --fresh <Module>` over built oleans — 20–50%
slower than the C++ kernel (~59 min for all of Mathlib single-threaded, so seconds-to-
minutes for a procint-sized closure). Its verification effort found a real soundness
bug in the reference kernel (`Expr.data` bit-packing panic falling back to `0`).

**Work item `second_check.py`** (+ MCP tool `lean4lean_check`): pin a lean4lean
checkout matching `procint/lean-toolchain`, run it over procint's build, emit a JSON
attestation `{toolchain, lean4lean_rev, module_list, exit, duration}`. Optionally run
`lean4checker` (C++ kernel path) on the same oleans and diff — divergence is itself a
reportable kernel bug (literally the paper's methodology). **Honest wording bound:** a
receipt may say "re-admitted by a second, independent *kernel implementation*", never
"independent verification" — lean4lean is compiled by the Lean compiler, so it is not
an independent *stack* (the paper itself points to trepplein/nanoda for that). Whether
this attestation ever graduates from pylab research surface into an actual
`release/gates.json` gate is a core-repo decision, out of pylab's scope.

### 12.5 Premise search (supports Tiers 2–3)

LeanExplore (2506.11085) ships as a pip package with a synchronous local `Service`
class and its own MCP server — a thin read-only `premise_search` wrapper in
`mcp_procint` is the same shape as the existing `registry_lookup`. Caveat: it indexes
Mathlib/Std/Batteries, **not** procint's own lemmas. If local search is wanted, its
hybrid recipe is fully specified and light: bge-base-en-v1.5 embeddings + FAISS,
BM25+, log-PageRank over the dependency graph, weights 1.0/1.0/0.2, similarity
threshold 0.525 — buildable over procint's declarations without any LLM if informal
translations are skipped. This is what parameterizes `aesop (add …)` / premise-taking
genes in the GP vocabulary.

### 12.6 Suggested order and what is explicitly not planned

Order: 12.1 → 12.2 (`tactic_mine.py` first, bigram prior second) → 12.3 → 12.5 → 12.4.
Each tier is independently useful; stop anywhere.

Not planned, with reasons: training any model (TheoremLlama/HTPS/HOList training
loops are cited for their *harness* lessons only — e.g. TheoremLlama's own manual
audit found ~17% of its LLM-informalized corpus mathematically wrong, which is this
repo's untrusted-Candidate stance measured); adopting LeanDojo as a dependency while
`lean_lsp.py` + the LSP suffices; any claim that a search-found proof changes ledger
standing (STATED→PROVEN stays a human-reviewed step through the full
`just render/build/audit/manifest/certify` chain).
