# Ticket: Deterministic Sorry-Repair Harness + Lean-3-ism Linter

## Title
Reimplement APOLLO's mechanical repair stages without an LLM, plus a Lean-3-vs-Lean-4
confusion linter for candidate pre-filtering — `pylab/src/math_factory_pylab/repair.py`

## Description
**APOLLO** (arXiv:2505.05758) is a five-stage repair loop (Syntax Refiner → Sorrifier →
Auto Solver → recursive-repair-via-LLM → Proof Assembler). Its own ablation
(their Table 4) shows the Syntax Refiner and Auto Solver stages *alone* are marginal
(e.g. Kimina-Prover 63.1% → 63.5% from Auto Solver alone) — the large gains (Kimina
70.8%@1024 samples → 75.0%@~307 samples; o4-mini 7.0%@1 → 46.7%@15) come from
**decomposition**: extracting each unsolved `sorry` as a standalone sub-lemma and
recursing the *whole pipeline*, including a fresh LLM call, on it. The three mechanical
stages are LLM-free and directly buildable:

1. **Syntax Refiner** — a regex rule table fixing common Lean-3-isms
   (`[from by]` → `[:= by]`, `begin...end` → structured `by` blocks, stray Lean 3
   keywords).
2. **Sorrifier** — parse the tactic-block tree, use compiler diagnostics to locate the
   first failure, apply line-removal / block-removal / sorry-insertion until the file
   compiles with only `sorry` warnings. Sets a batch of `pp.*` options (documented in
   APOLLO Appendix A, p.14) when extracting sub-goals so extracted types are explicit,
   not elided.
3. **Auto Solver** — try `hint`, `nlinarith`, `norm_num`, `norm_cast`, `ring_nf`,
   `simp`, `simp_all` (wrapped in `try`) on each remaining sorry hole.

**Lean-3-ism detection**: the actual Lean 3-vs-4 confusion evidence lives in
TheoremLlama's Appendix A (arXiv:2407.03203) — GPT-4 emits `begin...end`,
`import data.*` (nonexistent Lean 4 paths), lowercase-namespace snake_case names like
`finset.range` — and in APOLLO's own Syntax Refiner rule inventory, not in
arXiv:2503.13620 ("Programming Language Confusion", Moumoula et al.), which is a
general multi-language study containing no Lean content at all. That paper's
*detection architecture* is still reusable — a three-stage detect → parse-validate →
compare-to-requested-language pipeline, and its most citable finding is that
**syntactic validity is a false quality signal**: confused-language code parses just as
cleanly as correct-language code (>95% parse rate in both cases in their data), so
"the candidate typechecks" cannot be trusted to mean "the candidate is Lean 4." The
concrete rule inventory for what to detect comes from the two Lean papers; the
detect-then-verify *shape* comes from the confusion paper.

## Design

- `lean3ism_lint(candidate: str) -> LintResult` — deterministic classifier returning
  `verdict ∈ {lean4, lean3, mixed}` plus matched evidence strings. Rule table sourced
  from APOLLO A.1 + TheoremLlama Appendix A: `begin`/`end` blocks, `import data.*` /
  `import tactic`, snake_case dotted names, `λ x, e` (comma-lambda) vs `fun x => e`,
  `admit` vs `sorry`. Run as a zero-cost gate before any kernel check — in
  `genetic_tactic_search.py`'s fitness function and any future MCP candidate-intake
  tool.
- `syntax_refine(candidate: str) -> tuple[str, list[str]]` — const regex rewrite table;
  returns rewritten text plus which rules fired (log as candidate metadata, per
  APOLLO's own honest ablation that this mostly matters for general-purpose-model
  output, not dedicated provers or this repo's own GP-generated candidates).
- `sorrify(file_text: str, env: ProofEnv) -> SorrifyResult` — uses `ProofEnv`
  (Ticket 001) diagnostics to locate failures; line/block removal and sorry-insertion
  loop until only `sorry` warnings remain. Returns the compiling skeleton plus a list of
  extracted sub-goals with local context.
- `auto_solve(sub_goal, env: ProofEnv) -> str | None` — tries the fixed tactic suite
  per sub-goal, returns the first that closes it or `None`.
- **No LLM regeneration stage in this ticket.** APOLLO's step 4 (extract sub-lemma,
  re-invoke the LLM, recurse) is explicitly out of scope here; Ticket 003's
  hypertree-GP search is the LLM-free substitute for what would otherwise recurse into
  a fresh model call — feed unsolved sub-goals from `sorrify`/`auto_solve` into it
  instead (see Dependencies).

## Acceptance Criteria
- `repair.py` exports the four functions above, each independently testable without a
  live Lean process for `lean3ism_lint` and `syntax_refine` (pure text functions).
- A fixture corpus of at least 10 known Lean-3-ism examples (drawn from the two source
  papers' documented examples, not invented) is correctly classified by
  `lean3ism_lint`.
- `sorrify` is tested against a deliberately broken variant of one existing
  `TacticSearchWarmup.lean` target, confirming it produces a compiling
  sorry-only skeleton.
- MCP tool `sorrify_and_autosolve` added to `mcp_procint/server.py`, read/analysis
  only — it does not write back into `procint/ProcInt/**`; it returns the repaired text
  and sub-goal list for the caller to act on.
- Docs note (in `repair.py`'s module docstring or `docs/`) explicitly states the
  correction: the confusion-detection *architecture* comes from arXiv:2503.13620, the
  concrete Lean-3-ism *rule inventory* comes from arXiv:2407.03203 and arXiv:2505.05758
  — do not conflate the three papers' contributions when this is written up.

## Dependencies
Ticket 001 (`ProofEnv`) for `sorrify`'s diagnostic-driven failure localization. Feeds
into Ticket 003 (hypertree-GP search) as an optional pre-processing stage for candidates
before they enter the search population.

## Verification Mechanism
1. `cd pylab && uv run pytest tests/test_repair.py` — lint fixture corpus, syntax-refine
   round-trip on known Lean-3-isms, sorrify on the deliberately-broken fixture.
2. MCP tool smoke test: `sorrify_and_autosolve` called against a hand-broken copy of
   `warmup_list_length_append`, confirms it returns a compiling skeleton with one
   sub-goal, and that `auto_solve` closes it via one of the fixed-suite tactics.
3. No modification to any file under `procint/ProcInt/**` outside `Playground/` —
   confirmed by `git diff --stat` showing zero touched paths there after running the
   test suite.
