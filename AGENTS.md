# MFact Repository Agent Law

## Scope

This file governs the mfact repository and every path beneath it. A nested
`AGENTS.md` may impose tighter domain rules but may not weaken the admission,
receipt, replay, or standing boundaries declared here.

This document unifies two independently-evolved lineages merged on
2026-07-16: the ggen-rendered `procint/ProcInt/**` corpus (Petri nets,
workflow soundness, conformance, OCEL, PDDL planning — governed by the
`packs/`/`.mfact/artifacts.toml`/`just` ledger discipline) and the
hand-authored `procint/ProcInt/MFW/` Lean formalization (Multi-Fractal
Workflow — governed by its own Standing Law and `lake exe lint-style
--procint`). Both are instances of one law; see "Foundational Law" below.

Agents may start at the repository root or inside a subproject. Before changing a
file, read this file and every applicable `AGENTS.md` between the root and that
file.

## Foundational Law

Every rule in this file is an operational instance of the **Chatman
Equation**: (A = \mu(O^*)), receipted as (R \vdash A = \mu(O^*)). Raw
observation ((O)) — an LLM response, a file, a compiler message, a passing
exit code — has no standing until admitted into (O^*). Manufacture ((\mu))
transforms only admitted state, under declared, bounded, receiptable law.
An artifact ((A)) does not acquire authority merely by existing. Actuation
is permitted only from a receipted, standing-bearing artifact.

The full doctrine — Rice containment, typed verifier jurisdictions, the
LLM-proposes/executors-dispose maxim, Gall checkpoints, the intent gap, and
the research-thesis boundary this repository does not overclaim past — is
preserved verbatim in `docs/CHATMAN_EQUATION.md`. Read it before touching
either subsystem's law below; this file states the mechanically enforced
subset, not the full theory.

**What is mechanically enforced today** (do not describe more than this as
"enforced" — the rest of the doctrine is design intent, per the Equation's
own "Research Standing" section):

* `scripts/lint-style.lean --procint`: the 8-word MFW Standing vocabulary,
  theorem-shaped-def detection, vacuous-`True` detection, unmarked-axiom
  detection, scratch-file detection, stale-CONJECTURAL detection.
* `.git/hooks/pre-commit`: `HAND_CODED_GENERATED_OUTPUT` refusal on
  generated-output paths changing without an accompanying source/template
  change (see "Ledger Law" below).
* `.claude/hookify.*.local.md` rules: blocking `sorry`/`admit`/`axiom`/
  `opaque` additions in MFW files; warning on uncited ALIVE/PROVEN claims;
  warning on vendored-tree edits.
* `.mfact/artifacts.toml` plus `release/gates.json`: the ggen-rendered
  corpus's ledger and status-promotion guards (see "Ledger Law" below).

Everything else — the coordination-as-intelligence thesis, the multifractal
process-measure program, semantic capitalization, recursive process
manufacture — is CONJECTURAL/design-intent per the Equation's own vocabulary
until it has a receipt of its own.

## Mission

MFact manufactures correct formal specifications and implementations by integrating
constructive mathematics (Lean), process science (Petri nets, POWL, OCEL, conformance
checking), deterministic ontology-to-artifact projection (ggen), and production Rust.
The repository enforces strict standing distinctions between compilation success
and mathematical proof, between generated output and hand-authored source, and
between valid execution and authorized consequence.

The fundamental unit is a mathematically consequential distinction, not a task or
file.

## Repository Authorities

Keep these authorities separate:

| Surface                                  | Authority                                                                                    |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `packs/*/fragments/*.ttl`                 | Source declaration catalog for the ggen-rendered `procint/ProcInt/**` corpus                  |
| `packs/*/templates/*.tmpl`                | Projection templates for that corpus                                                          |
| `procint/ProcInt/**` (except `MFW/`)      | **Not** hand-editable — rendered by ggen from `packs/`; see "Ledger Law"                       |
| `procint/AxiomAudit.lean`, `procint/ProcInt.lean` | **Not** hand-editable — rendered by ggen. **Known residual**: the MFW import lines in `procint/ProcInt.lean` were hand-appended during the 2026-07-16 unification merge because no ggen source/template for MFW exists yet; this is a standing `ARTIFACT_DRIFT` obligation until MFW gets its own fragment/template or its own root import file, not a precedent for future hand-edits |
| `procint/ProcInt/MFW/`                    | Nested MFW subproject; **hand-authored** production Lean; see `procint/AGENTS.md` for its tighter rules — never ggen-rendered, has no `packs/` source |
| `procint/ProcInt/Playground/`             | Hand-authored demo/examples surface — never ggen-rendered, never ledgered; ordinary code       |
| `pylab/**`                                | Hand-authored Python research surface (TPOT2, pm4py, powl, ocpa, pddl-plus-parser) — never ggen-rendered, never ledgered |
| `Mathlib/`, `batteries/`                  | Vendored; read-only except where locally patched per standing law                             |
| `crates/`                                 | Rust execution, tests, verification tooling (see `docs/MFACT_CORE_DESIGN.md` — currently BLOCKED, no source exists) |
| `scripts/`                                | Build, lint, test, and verification scripts (both `just` recipes and standalone `lake`/`python3` scripts) |
| `release/*`                               | **Not** hand-editable — emitted by builders/certification                                     |
| `.mfact/artifacts.toml`                   | The ggen-corpus artifact ledger — authority for what is generated vs. canonical                |
| `paper/main.tex`                          | Limited edit — stable prose spine only, no volatile numbers                                    |
| `paper/refs.bib`, `README*`, `STANDING.md` prose | Hand-editable narrative — no standing values by hand                                      |
| ledgered `paper/*.tex` fragments          | **Not** hand-editable — rendered by ggen                                                       |
| `docs/`                                   | Explanations and projections; never standing authority                                         |

Resolve the actual tree before assuming a listed path exists. Do not manufacture
empty directories or speculative subsystems merely to match this table.

## Standing Law

Two Standing vocabularies exist, scoped to two different enforcement mechanisms.
Neither may be silently swapped for the other; a declaration's file location
determines which applies. Unifying them into one vocabulary is a named open
obligation (see "Known Residual Obligations"), not something this merge did.

**MFW-scoped (`procint/ProcInt/MFW/**`), mechanically enforced by
`lake exe lint-style --procint`:**

```text
ALIVE, PARTIAL_ALIVE, BLOCKED, BUILD_BROKEN, UNKNOWN, UNSUPPORTED, CONJECTURAL, PROVEN
```

Use these statuses precisely:

* `ALIVE`: the declared consequence works and the required evidence is present;
* `PARTIAL_ALIVE`: a bounded working checkpoint exists but the larger crown does
  not;
* `BLOCKED`: a named external prerequisite prevents lawful progress;
* `BUILD_BROKEN`: the relevant build or projection fails;
* `UNKNOWN`: observation is insufficient to classify standing;
* `UNSUPPORTED`: the required capability or semantic coordinate is absent;
* `CONJECTURAL`: a meaningful, named-blocker proposition, not yet proved;
* `PROVEN`: formal proof of the specified proposition under declared assumptions.

`UNKNOWN` is not `UNSUPPORTED`. `BOUNDED` is not exhaustion. A candidate is not
standing. A `def : Prop` with a "Theorem" docstring is theorem-shaped, not a
theorem — `theoremShapedDef` catches this mechanically; the fix is honest
reframing as `CONJECTURAL`, never a fabricated proof.

**ggen-corpus-scoped (`procint/ProcInt/**` except `MFW/`, `release/`,
`paper/` ledgered fragments), enforced by `.mfact/artifacts.toml` +
`release/gates.json` + `just` recipes:**

```text
ALIVE, PARTIAL_ALIVE, BLOCKED, BLOCKED_EXTERNAL, BUILD_BROKEN, REFUSED,
PENDING_EXTERNAL_ACTUATION, VALID, UNSUPPORTED, PLANNED, STATED,
REPLAY_NOT_RUN, IN_PROGRESS
```

`STATED` (formalized, not proven) is this vocabulary's near-equivalent of
MFW's `CONJECTURAL` — both name a real statement with no completed proof;
they arose independently in the two lineages and are not yet merged into one
word. **Never upgrade `STATED` to `PROVEN` anywhere** without a Lean-admitted
theorem and a `release/release-manifest.json` entry — the crown-jewel WF-net
soundness equivalence remains `STATED` unless both exist. A `STATED` claim
promoted to `PROVEN` in prose without a checked guard in `release/gates.json`
is the specific failure the 2026-07-07 five-rail audit found (see
"Guardrails" below) and is refused as `STATED_PROMOTED_TO_PROVEN`.

Constructive Lean Boundary and the ggen Ledger Law below each state the
zero-sorry / zero-fabrication discipline for their respective corpus.

## Constructive Lean Boundary (MFW)

All Lean work under `procint/ProcInt/MFW/` must be compiled and logically sound.
Production theory may not use `opaque`, `noncomputable`, `axiom`, `sorry`,
`admit`, `native_decide`, semantic constants, `True` stubs, or hidden choice as
substitutes for constructions.

**Current standing**: PARTIAL_ALIVE — `lake build ProcInt` and
`lake exe lint-style --procint` are green, and the labeling, vacuous-predicate,
and hidden-choice defects cataloged in `procint/ProcInt/MFW/AUDIT_FOLLOWUP.md`
are repaired (see that file and the receipts it cites). The Crown conjecture
(`KernelCharacterization`) and its supporting conjectures remain CONJECTURAL —
stated obligations, not proved theorems. A green build plus honest labels is
not proof closure.

Do not weaken this law from the repository root. If a requested theorem cannot be
constructed, preserve it as an exact obligation and return a typed partial outcome.
When procint/MFW reaches proof closure of the Crown, update this section again:
cite the closing theorem and its receipt, and raise the standing accordingly.

**Sibling incident, other subsystem**: the ggen corpus's own 2026-07-07
five-rail audit found a `sorry`-backed theorem shipped as `status "proven"`
with no guard catching it — the same failure class (theorem-shaped claim
promoted past its actual proof state) that this session's MFW audit found
independently in `KernelCharacterization` and friends. See "Guardrails"
below for the structural fix applied on that side. Both incidents are
recorded honestly rather than treated as isolated.

## Ledger Law (ggen corpus)

**Prime Directive**: this repository is a mathematical manufacturing system for
the `procint/ProcInt/**` (non-MFW) corpus. Do not hand-code manufactured
outputs. An LLM is an untrusted candidate producer: it may propose changes to
source declarations, templates, fixtures, tests, and hand-authored prose. It
may not confer standing by directly editing generated artifacts. The standing
law for this corpus is `R_B ⊢ A = μ(O*_B)`: ggen projects, Lean admits, mfact
certifies, and the manifest records standing.

There are no generated files with implicit authority; there are only artifacts
with receipts. All repository files are first-class and live at canonical
paths. Do not rely on directories, file headers, or path naming to decide
authority — authority comes from the artifact ledger (`.mfact/artifacts.toml`).
If a file is ledgered as produced by ggen or a builder script, do not patch it
directly as a final solution: modify its declared sources or template,
re-render, and verify `just regen-check` passes (any unreplayable edit is
`ARTIFACT_DRIFT_REFUSED`). If a file is NOT ledgered but contains release
standing, counts, audit status, or certification data, classify it as
`ORPHAN_ARTIFACT_REFUSED` and either ledger it or refuse the task.

`procint/ProcInt/Playground/**` and `pylab/**` are intentionally unledgered:
they carry no standing, counts, or certification data, so their absence from
`.mfact/artifacts.toml` is correct, not an omission. Do not add them to the
ledger. `procint/ProcInt/MFW/**` is likewise not in this ledger — it has its
own Standing Law above and is not ggen-rendered.

### Required workflow (ggen corpus)

1. Edit the source (fragment TTL, template, builder, gate).
2. `just render` (corpus) and/or `just standing-quadrature` (quadrature + paper fragments).
3. `just build` / `just audit`.
4. `just manifest && just certify` if release standing changed.
5. `just regen-check` — hand-edited generated output cannot pass admission.
6. Report commands run and resulting standing.

### Rules (ggen corpus)

* **No direct `pyproject.toml` modifications**: use `uv add` or another package
  manager command via a `just` recipe instead.
* **No unrequested Lean-Python integration**: do not implement custom Lean 4
  integration infrastructure (LSP clients, subprocess runners) in `pylab/`
  unless explicitly requested.
* **Deprecate `l2p`**: do not install, reference, or use the `l2p` planning
  library.
* Never manually write release counts, hashes, theorem totals, sorry counts,
  audit status, fixture status, quadrature status, or crown-jewel status —
  these come only from generated files.
* If the source/template for a generated artifact cannot be found, do not
  patch the output; refuse with `MISSING_GGEN_SOURCE` / `MISSING_GGEN_TEMPLATE`
  and name the file.

Typed refusal vocabulary: `HAND_CODED_GENERATED_OUTPUT`,
`GENERATED_OUTPUT_DRIFT`, `MISSING_GGEN_SOURCE`, `MISSING_GGEN_TEMPLATE`,
`ORPHAN_GENERATED_FILE`, `UNREGISTERED_PAPER_FRAGMENT`,
`UNSUPPORTED_STANDING_CLAIM`, `STATED_PROMOTED_TO_PROVEN`,
`MANUAL_RELEASE_COUNT`, `MANUAL_RELEASE_HASH`, `RECEIPT_RECURSION_REFUSED`,
`SOURCE_CHANGE_ASSERTION_UNSUPPORTED` (`MFACT_SOURCE_CHANGED=1` requires a
changed source/template/TTL in the same commit, not a bare assertion — the
pre-commit hook checks the commit's changed-file set, not a human claim).

### Agent cockpit

Agents actuate the ggen corpus only through `just` recipes. Do not call raw
lake/ggen/mfact commands unless a recipe explicitly instructs it for
debugging. If a task needs a new actuation path, add a `just` recipe first,
then use it. Final reports name the recipes used, not an ad hoc shell
history. `just status/next/doctor/trace/why` are READ-ONLY — they never dirty
the tree. Only `just check` / `just release` write `.mfact/reports/latest.*`
(ephemeral, gitignored, never ledgered). Certified status lives only in
`release/` artifacts.

(MFW-scoped work uses `lake build ProcInt` / `lake exe lint-style --procint`
directly, per `procint/AGENTS.md` and "Command Discipline" below — `procint/`
is documented in `procint/lakefile.toml` as a separate, unintegrated Lake
workspace, so the `just` cockpit does not currently reach it.)

### Core release identity (frozen)

The v26.7.7 core release is tag `v26.7.7-procint-certified`:
`CORE_RELEASE_HASH` = the manifest foldHash, `CORE_PROVEN`,
`CORE_TOTAL_DECLS` as recorded in `release/release-manifest.json` at the
tagged commit. **Post-release artifacts must not mutate the identity of the
core certified release they report.** If an operation would change the core
foldHash, proven count, decl count, or manifest, either refuse it as
`RECEIPT_RECURSION_REFUSED` or promote it explicitly into a new core
certification cycle with new manifest values — never both silently.
Post-release witnesses (e.g. `ProcInt.Release.PostRelease`) are counted as
`POST_RELEASE_WITNESSES`, never folded into `CORE_PROVEN`. The core tag is
pinned to the core release commit and is not moved by packet work; packets
get their own tags and their own packet hashes.

### Guardrails (post-v26.7.7-audit)

A 2026-07-07 five-rail audit (recorded in
`pylab/docs/jira/26.7.7/tickets/ticket_013_v26_7_7_gap_audit.md`) found a
sorry-backed theorem ledgered as `status "proven"` with no guard catching
it, plus several related silent-drift failure modes. These rules exist to
make each of those specific failures structurally impossible, not just
discouraged:

* **No status promotion without a checked guard.** Any TTL fragment that
  sets `procint:status "proven"` on a theorem must have a corresponding
  entry in `release/gates.json` (or an equivalent builder check) that
  mechanically verifies `#print axioms` shows no `sorryAx` for that
  declaration. A status literal written into TTL is never sufficient by
  itself. New refusal vocabulary for this class:
  `WFNET_INFINITE_TRANSITION_COUNTERMODEL` (status key for theorems in this
  family), `countermodel_not_promoted` (the guard name),
  `COUNTERMODEL_PROMOTION_REFUSED` (the refusal fired when the guard fails).
* **`regen-check` must not have untracked-file blind spots.** `git diff
  --exit-code` only sees tracked files. Any ledgered artifact's producer
  script must be invoked by `regen-check`/`check` itself. Newly created
  ledgered artifacts must be `git add`ed in the same commit that introduces
  them; an untracked-but-ledgered file whose disk hash disagrees with
  `.mfact/artifacts.toml` is `ORPHAN_ARTIFACT_REFUSED`, and this must
  actually fire, not just exist as a documented category.
* **Correspondence theorems must reference their extraction.** A
  correspondence obligation reported as `PROVEN` must have its Lean
  statement actually `import` and quantify over the extracted/generated
  declaration via its declared abstraction function — not merely a
  same-shaped statement over hand-written types. A receipt field like
  `aeneasDecl: "TBD"` is itself a refusal signal and must block `PROVEN`
  status, not ship alongside it.
* **Tag ancestry is part of certification.** `just certify`/`release` must
  verify the release commit is an ancestor of (or equal to) the certified
  git tag before reporting `CERTIFIED_RELEASE=PASS`. A tag that predates the
  currently-rendered artifacts is `RECEIPT_RECURSION_REFUSED`.
* **New fragments feeding `ontology.ttl` must be tracked before
  `regen-check` runs.** An untracked `.ttl` file silently concatenated into
  generated output is a source-provenance gap distinct from
  generated-artifact drift. Commit new fragment files before running any
  recipe that renders from them.

## Change Discipline

Before editing:

1. inspect the actual repository state and applicable agent laws;
2. determine canonical versus generated ownership (consult "Repository
   Authorities" above — the answer differs between MFW and the ggen corpus);
3. identify the current standing and claim ceiling;
4. run the smallest useful baseline check;
5. preserve unrelated user work.

While editing:

* keep changes within the authorized ticket and subsystem;
* never change a claim silently to make verification pass;
* prefer typed data and explicit outcomes over strings and implied state;
* preserve counterexamples and negative fixtures;
* avoid broad formatting or dependency churn;
* do not add a new framework before the current checkpoint requires it.

After editing:

1. run the subsystem's targeted verification (`lake build ProcInt` +
   `lake exe lint-style --procint` for MFW; `just check` for the ggen corpus);
2. run the applicable aggregate check (`lake build` or
   `lake exe lint-style --procint` from the repo root for MFW work; `just
   regen-check && just build && just audit` for ggen-corpus work);
3. inspect the final diff and standing;
4. record checks actually run and checks not run;
5. state exact standing and residual obligations;
6. never claim a receipt, replay, proof, or correspondence that was not observed.

## Verification Ladder

Verify in increasing scope:

```text
unit -> integration -> end-to-end -> chaos -> stress -> benchmark
-> verifier report -> replay
```

Not every ticket requires every rung, but skipping an applicable rung must be
explicit. A release requires the verifier report and replay appropriate to its
declared horizon.

Cross-language work must prove the relevant edges independently:

```text
Lean proof -> generated artifact (if applicable)
Rust implementation -> safety property
Rust execution -> receipt
receipt -> replay
```

Matching names or serialized fields are not a correspondence proof — see the
"Correspondence theorems must reference their extraction" guardrail above for
the specific, previously-real failure this generalizes from.

## Documentation and Claims

Documentation explains standing; it does not create standing.

Every major claim should identify:

* exact formal object;
* theorem or verifier receipt;
* admitted hypotheses and bounds;
* implementation correspondence, if any;
* current status (using the vocabulary scoped to its subsystem — see
  "Standing Law");
* exclusions and known falsifiers.

Do not describe a theoretical limit as a verified finite estimator. Do not call
a stated proposition proven. Do not call a build green a crown proof.

## Tooling Law

These agent plugins are available for this repository. Their use is subordinate to
every rule above; a plugin result is evidence, never standing.

### Semantic search (lumen)

Before reading a file in full to locate a definition, reference, or edge
across Lean, Rust, or scripts, query lumen first. Lumen indexes across language
boundaries. Re-run `reindex` after project structure changes; a stale index is
`UNKNOWN`, not evidence of absence.

Lumen narrows where to look. It never substitutes for reading the admitted
source and verifier output before making a claim.

### Planning and execution discipline (superpowers)

Apply `brainstorming` before starting work on any feature, design, or bounded
subsystem. The skill enforces a hard gate: gather user intent, explore design
alternatives, propose 2-3 approaches with trade-offs, present the design, get
user approval, and write a design spec before invoking any implementation skill.
It covers single features through multi-project decomposition (for large requests,
brainstorming surfaces the need to split into independent sub-projects). Apply
even for changes that seem "too simple to need a design" — simple projects are
where unexamined assumptions cause the most wasted work.

Apply `writing-plans` whenever you have a design spec or requirements for a
multi-step task. The skill produces bite-sized, fully-specified implementation
tasks (each 2-5 minutes, with exact code, test commands, and verification steps)
together with a global-constraints header and task interfaces. After writing the
plan, offer execution: subagent-driven (recommended, if platform supports) or
inline executing-plans.

Apply `executing-plans` when executing a written plan in a separate parallel
session (when subagent support is unavailable or a sequestered session is needed).
Note that `subagent-driven-development` is preferred on platforms with subagent
support because it preserves controller context and enables review-based fix loops.

Apply `test-driven-development` (red before green) for every implementation change:
write the failing test first, watch it fail with the expected error, write minimal
implementation to pass, verify it passes, then refactor. Exceptions (ask your human
partner): throwaway prototypes, generated code, configuration files. A test written
after implementation is not TDD — treat retrofitted tests as partial evidence of
correctness, not full evidence.

Apply `systematic-debugging` before proposing fixes for ANY technical issue: test
failures, production bugs, unexpected behavior, performance problems, build failures,
integration issues. The discipline is mandatory under time pressure (when "just one
quick fix" is tempting) and when you've already tried multiple fixes. Follow Phase 1
(root cause investigation — reproducibility, error messages, recent changes, evidence
gathering in multi-component systems) before forming hypotheses in Phase 3 and fixes
in Phase 4. If three fixes have failed, stop and question the architecture with your
human partner rather than attempting a fourth fix.

These two dispatch skills solve different problems and are not interchangeable:
apply `subagent-driven-development` to execute an existing plan's tasks sequentially
in the current session (fresh subagent per task, task-scoped review for spec compliance
and code quality after each, broad final review at completion); apply
`dispatching-parallel-agents` only to independent, unrelated failures with no shared
state (e.g. bugs in disjoint subsystems) that can run concurrently.

Apply `requesting-code-review` before a ticket is reported complete — never accept
self-reported "looks correct" as a code review. Dispatch the reviewer with carefully
curated context (task/feature summary, requirements, commit range diff in a file,
global constraints) so the reviewer sees only what's needed. Handle feedback: fix
Critical issues immediately, fix Important issues before proceeding, note Minor
issues for later.

Apply `receiving-code-review` whenever review feedback arrives: read the complete
feedback, restate each item in your own words to verify understanding, verify against
the codebase (check if suggestion breaks things, breaks backward compat, violates
YAGNI, or conflicts with prior architecture decisions), then respond with technical
reasoning or just implement the fix. Never respond with performative agreement
("You're absolutely right!", "Great point!") — technical acknowledgment or action
only. Push back with evidence if the suggestion is technically wrong or incomplete.
Clarify any unclear items before implementing (related items may have dependencies).

Apply `verification-before-completion` immediately before making any claim about
standing (`ALIVE`, `PARTIAL_ALIVE`, "proven", "verified", "correspondence"), before
committing, or before reporting a task complete. Run the verification command fresh
in the same turn, read the complete output, check the exit code, count passing/failing
results, and only then state the claim WITH evidence in the same message. No shortcuts:
"should work", "looks good", or confidence claims do not substitute for verification
output.

### Enforced constraints (hookify)

Hookify converts the Standing Law and Change Discipline sections above into
mechanically enforced hooks rather than prose an agent might drift from.
Configure `.claude/hooks/*.local.md` (via `/hookify:configure`) for at least:

* flagging `sorry`, `admit`, `axiom`, `opaque`, or `noncomputable` introduced
  at the repository root or in new Lean files outside explicit conjecture markers;
* flagging claim language that asserts `ALIVE`, "proven", "verified", or
  "correspondence" without a cited receipt or theorem in the same diff.

A hookify rule is a floor, not a ceiling: passing every configured hook is not
itself standing, proof, or a receipt.

## Command Discipline

Two command surfaces exist; use the one scoped to what you're touching.

**MFW** (`procint/ProcInt/MFW/**`): `lake build ProcInt` (from `procint/`) and
`lake exe lint-style --procint Mathlib.Init` (from the repository root).
`./scripts/verify-receipt.sh` runs both and writes a timestamped receipt to
`.verif-toolchain/receipts/`.

**ggen corpus** (`procint/ProcInt/**` except `MFW/`, `paper/`, `release/`):
`just` recipes only — see "Agent cockpit" above. Do not call raw
lake/ggen/mfact commands as the final actuation path unless a `just` recipe
or `doctor` report explicitly instructs it.

Commands must:

* run from the repository root (or `procint/` for the MFW `lake build`, per
  `procint/lakefile.toml`'s documented separate-workspace note);
* use the pinned Lean version in `lean-toolchain`;
* be noninteractive in CI;
* fail on linter warnings where standing requires it;
* avoid destructive cleanup outside generated or temporary surfaces;
* emit enough information to diagnose the failed semantic edge.

If a required command is missing, add the smallest reusable script to `scripts/`
(or the smallest `just` recipe for the ggen corpus) and document its inputs,
outputs, and mutation boundary.

## Completion

A task is complete when its requested consequence works at the declared horizon,
the appropriate evidence exists, and replay is possible where required.

The completion receipt should answer:

```text
What was observed?
What was admitted?
What construction ran?
What proof or verification succeeded?
What changed?
What was actuated?
What receipt was emitted?
Can the consequence be replayed?
What remains unresolved?
```

End every completion report with exactly one terminal status, drawn from the
vocabulary scoped to the subsystem touched (see "Standing Law"). If the task
touched both subsystems, state both.

If the evidence does not close the requested edge, report the strongest truthful
partial status instead of manufacturing completion.

## Known Residual Obligations (from the 2026-07-16 unification merge)

`feature/mfw-fixes` and `main` shared no common git ancestor before this
merge — two independently-evolved lineages, unioned with
`--allow-unrelated-histories`. Named, not silently absorbed:

* `procint/ProcInt.lean` now carries three hand-appended MFW import lines
  inside an otherwise ggen-rendered file — `ARTIFACT_DRIFT` relative to the
  Ledger Law above, until MFW gets a real ggen source/template or its own
  root import file.
* The MFW 8-word Standing vocabulary and the ggen corpus's 13-word vocabulary
  are not unified into one word list; `CONJECTURAL`/`STATED` are known
  near-synonyms arising independently, not yet merged.
* `procint/lakefile.toml`'s `Tests` `lean_lib` now has `roots = ["ProcInt.Tests",
  "ProcInt.MFW.Tests"]` — two disjoint test trees sharing one lake target;
  splitting them into separate targets is a reasonable future cleanup, not
  required for correctness.
* `docs/CHATMAN_EQUATION.md` is the newly-unified theoretical doctrine both
  lineages instantiate; no code in either subsystem has been rewritten to
  cite it yet beyond this file's cross-references.

## See Also

- `docs/CHATMAN_EQUATION.md` — the unifying doctrine both subsystems in this
  file instantiate; read this first for the "why" behind every rule above
- `docs/AGENT_FAILURE_MODES.md` — five agent failure-mode anti-patterns and
  concrete mfact incidents that illustrate each one
- `procint/AGENTS.md` — nested MFW subproject law (tighter Standing Law rules)
- `procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` — detailed findings from the MFW
  Lean formalization audit, including the Crown Theorem case
- `docs/LEXICON.md` — pinned MFW denotations projected from Lean sources,
  digest-bound, ranked by measured corpus-prior divergence
- `docs/REGRESSIONS.md` — falsifiable-constants protocols for this session's
  scaling-law claims (all UNVERIFIED pending execution)
- `docs/MFACT_CORE_DESIGN.md` — the Rust actuation layer's open contract
  questions (BLOCKED — no source exists)
- `STANDING.md` — the ggen corpus's own standing ledger
- `docs/HONEST_D1_STATEMENT.md` — a prior standing-honesty statement in the
  ggen corpus, sibling in spirit to the MFW audit this session performed
