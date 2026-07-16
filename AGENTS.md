# MFact Repository Agent Law

## Scope

This file governs the mfact repository and every path beneath it. A nested
`AGENTS.md` may impose tighter domain rules but may not weaken the admission,
receipt, replay, or standing boundaries declared here.

Agents may start at the repository root or inside a subproject. Before changing a
file, read this file and every applicable `AGENTS.md` between the root and that
file.

## Mission

MFact manufactures correct formal specifications and implementations by integrating
constructive mathematics (Lean), verification infrastructure, and production Rust.
The repository enforces strict standing distinctions between compilation success
and mathematical proof, and between valid Rust execution and authorized consequence.

The fundamental unit is a mathematically consequential distinction, not a task or
file.

## Repository Authorities

Keep these authorities separate:

| Surface       | Authority                                                                    |
| ------------- | ---------------------------------------------------------------------------- |
| `procint/`    | Nested MFW subproject; see `procint/AGENTS.md` for tighter rules            |
| `Mathlib/`    | Vendored Mathlib; read-only except where locally patched per standing law   |
| `batteries/`  | Vendored Lean batteries; read-only                                          |
| `crates/`     | Rust execution, tests, and verification tooling                             |
| `scripts/`    | Build, lint, test, and verification scripts                                 |
| `.lean` files | Top-level Lean declarations, Counterexamples, Archive imports               |
| `docs/`       | Explanations and projections; never standing authority                      |

Resolve the actual tree before assuming a listed path exists. Do not manufacture
empty directories or speculative subsystems merely to match this table.

## Standing Law

Never conflate:

```text
observation
admitted observation
candidate declaration
rendered artifact
compiled artifact
proved theorem
proved theorem instance
formal/runtime correspondence
authorized actuation
receipted actuation
replay
```

The standing chain is:

```text
law -> admitted hypotheses -> concrete instance -> object correspondence
-> authorized consequence -> actuation -> receipt -> replay
```

Every missing edge lowers the claim ceiling. Nodes at both ends do not prove an
edge exists.

Use these statuses precisely:

* `ALIVE`: the declared consequence works and the required evidence is present;
* `PARTIAL_ALIVE`: a bounded working checkpoint exists but the larger crown does
  not;
* `BLOCKED`: a named external prerequisite prevents lawful progress;
* `BUILD_BROKEN`: the relevant build or projection fails;
* `UNKNOWN`: observation is insufficient to classify standing;
* `UNSUPPORTED`: the required capability or semantic coordinate is absent.

Two further words complete the canonical vocabulary as declaration-level `Standing:`
tags in Lean docstrings, enforced by `lake exe lint-style --procint` and defined in
`procint/AGENTS.md`:

* `CONJECTURAL`: a stated obligation honestly labeled unproven — a statement, not a
  result;
* `PROVEN`: the declaration carries a complete, sorry-free proof accepted by the Lean
  kernel.

`UNKNOWN` is not `UNSUPPORTED`. `BOUNDED` is not exhaustion. A candidate is not
standing.

## Constructive Lean Boundary

All Lean work must be compiled and logically sound. Production theory may not use
`opaque`, `noncomputable`, `axiom`, `sorry`, `admit`, `native_decide`, semantic
constants, `True` stubs, or hidden choice as substitutes for constructions.
`noncomputable` is tolerated only where Lean requires it for genuinely classical
objects (`Real`-valued definitions and their consumers), never to stand in for a
missing construction.

**Current standing**: PARTIAL_ALIVE — the procint build and lint are green and the
cataloged labeling, vacuous-predicate, and hidden-choice defects are repaired; the
Crown and its supporting conjectures remain CONJECTURAL/open.

The items previously cataloged here (unmarked axioms and unproven theorem-shaped
definitions in `procint/ProcInt/MFW/`) were resolved on 2026-07-16:

* bodyless `opaque` declarations were converted to explicit theory-structure
  hypotheses (`CausalOrderAssignment`, `ManufactureTheory`, `FalsificationTheory`,
  `ExploreExploitTheory`, `CompilerPipelineTheory`, `TemporalEntropyAssignment`)
  or deleted where they had no consumer;
* theorem-shaped `def : Prop` declarations — including the flagship Crown
  statement `KernelCharacterization` — were reframed as explicit conjectures
  carrying `Standing: CONJECTURAL` tags with named blockers;
* vacuous `True` predicates were given real constraining bodies
  (`validTopologicalSort` in `Ledger.lean`; `HierarchicalScaleSystem.refines` in
  `TransformBasic.lean`, whose containment conclusion is now `Powl.IsSubmodelOf`
  rather than `True`) or explicit hypothesis parameters;
* a hidden-choice defect found in adversarial review — `stateTraceOf`
  (`Kernel.lean`) applied `Classical.choice` to a `Nonempty` proof, returning one
  constant list for every behavior and degenerating `StateEquiv` into the total
  relation — was replaced by the real replay construction
  (`BehaviorTrace.stateTrace`), with faithfulness proved
  (`stateTrace_eq_some_stateTraceOf`).

Receipt: `.verif-toolchain/receipts/receipt-20260716T222045Z.txt` — from `procint/`,
`lake build ProcInt` exit 0 (8579 jobs); from the root,
`lake exe lint-style --procint Mathlib.Init` exit 0; Overall: PASS. This receipt is
procint-scoped: it attests the ProcInt library build, not a root-workspace
`lake build`. The historical catalog remains at
`procint/ProcInt/MFW/AUDIT_FOLLOWUP.md`.

The Crown conjecture and its supporting conjectures are stated obligations, not
proved theorems. A green build plus honest labels is not proof closure.

Do not weaken this law from the repository root. If a requested theorem cannot be
constructed, preserve it as an exact obligation and return a typed partial outcome.
When procint reaches proof closure of the Crown, update this section again: cite
the closing theorem and its receipt, and raise the standing accordingly.

## Change Discipline

Before editing:

1. inspect the actual repository state and applicable agent laws;
2. determine canonical versus generated ownership;
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

1. run the subsystem's targeted verification;
2. run the applicable aggregate check (`lake build` or `lake exe lint-style --procint`);
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

Matching names or serialized fields are not a correspondence proof.

## Documentation and Claims

Documentation explains standing; it does not create standing.

Every major claim should identify:

* exact formal object;
* theorem or verifier receipt;
* admitted hypotheses and bounds;
* implementation correspondence, if any;
* current status;
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

Use `lake build` to build the entire project and `lake exe lint-style --procint`
to run the unified linter suite (including procint-specific checks).

Commands must:

* run from the repository root;
* use the pinned Lean version in `lean-toolchain`;
* be noninteractive in CI;
* fail on linter warnings where standing requires it;
* avoid destructive cleanup outside generated or temporary surfaces;
* emit enough information to diagnose the failed semantic edge.

If a required command is missing, add the smallest reusable script to `scripts/`
and document its inputs, outputs, and mutation boundary.

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

If the evidence does not close the requested edge, report the strongest truthful
partial status instead of manufacturing completion.

## See Also

- `/Users/sac/mfact/docs/AGENT_FAILURE_MODES.md` — five agent failure-mode anti-patterns and
  concrete mfact incidents that illustrate each one
- `/Users/sac/mfact/procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` — detailed findings from the MFW
  Lean formalization audit, including the Crown Theorem case and the inventory of unproven
  theorem-shaped defs, vacuous predicates, and unmarked axioms
