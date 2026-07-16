# Agent Failure Modes and Anti-Patterns

This document catalogs five abstract failure modes and anti-patterns that AI agents (and
human operators) must actively guard against in this repository. It serves as a practical
check on the disciplines declared in the root `../AGENTS.md`.

Agents must read and internalize these failure modes before initiating debugging,
architectural changes, or tool modifications.

## 1. The Shadow Architecture Anti-Pattern (Check Exceptions)

**Failure Mode:** An agent encounters a semantic or domain-specific exception (e.g.,
"this one file violates the rule because it has a special role") and "solves" it by
hardcoding a special case directly into a linter check or transformation rule.

**Real incident from this repo:** During the MFW audit earlier this session, if a check
needed to exempt one specific file from flagging (e.g., `ProcInt/MFW/SpecialCase.lean`
shouldn't count as a scratch file), the agent might have added:
```lean
if fileName == "ProcInt/MFW/SpecialCase.lean" then return 0
```
directly inside the check logic, rather than:
1. Making that file's exemption a matter of structure (naming convention, directory
   placement, manifest entry), or
2. Documenting the exception in `procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` and keeping
   the check generic.

**The Law:** Linter checks must be perfectly generic and domain-agnostic. Domain-specific
rules (e.g., "this file is intentionally a counterexample") belong in documentation
(`AUDIT_FOLLOWUP.md`, `nolints-style.txt`), not embedded in check conditions. A check
should flag a structural pattern; the exceptions registry (`scripts/nolints-*.txt/json`)
should suppress the flag for intentional cases. Never hardcode project-specific names or
concepts into a generic tool.

---

## 2. The Bypass the Gate Anti-Pattern (Workaround Scripts)

**Failure Mode:** An agent encounters a failure in a canonical pipeline tool (`lake build`,
`lake exe lint-style`) and circumvents it by writing a one-off ad-hoc script (e.g.,
`fix_git_configs.py`, `render_template.sh`) that manually forces the artifact into
existence, bypassing the tool.

**Real incident from this repo:** `procint/fix_git_configs.py` — a script added to work
around git-config issues in the `.lake/packages/` directory. The script had hardcoded
absolute paths and was not idempotent. It was deleted this session; the right fix was to
identify and solve the underlying git-config problem at its source, or to document the
workaround in a README if it was truly unavoidable.

**The Law:** Do not bypass a failing canonical pipeline to achieve a "success" state.
- If `lake build` fails with a parse error, fix the `.lean` file or the `lakefile.toml`.
- If `lake exe lint-style` errors, fix the linter configuration or the flagged source.
- An artifact generated via a rogue script holds zero standing in this repository and
  corrupts the reproducibility chain.

A temporary workaround is acceptable **only if** it is:
1. Documented in a GitHub issue or `docs/` README as a known limitation,
2. Has an explicit removal plan (e.g., "remove this script once Lake bug #1234 is fixed"),
3. Is never used to silence a real check failure.

---

## 3. The Masked Root Cause Anti-Pattern (Infrastructure Blame)

**Failure Mode:** A localized syntax error in one file causes a global system failure that
surfaces as an unhelpful downstream error message (e.g., "file not found", "unknown type").
The agent assumes the underlying compiler/build system/linter is fundamentally broken and
begins rewriting core infrastructure (`lake`, `lint-style.lean`, `scripts/` mechanics)
instead of investigating the local source.

**Real incident from this repo:** Earlier this session, `/Users/sac/mfact/procint/ProcInt.lean`
was edited to remove direct imports. A docstring comment (`/--! # ProcInt library root`) was
placed **before** the `import` statements. Lean rejected this with "invalid 'import' command,
it must be used in the beginning of the file." The error message localized to the import line,
not the comment. The agent might have blamed Lake's import resolution and started rewriting
the module structure; the actual fix was moving the comment to after the imports.

**The Law:** When a previously stable global system abruptly fails with a "not found",
"invalid", "unknown", or "missing" error, **investigate the inputs you just changed before
rewriting the infrastructure that consumes them.**
- Was a file just edited or renamed? Check syntax and structure first.
- Was a config file (`lakefile.toml`, `lean-toolchain`) changed? Validate it.
- Was an import path changed? Verify the path exists and is accessible.
- Only after ruling out local issues should you question the build system itself.

Do not hack the compiler to dodge a syntax error.

---

## 4. The Unreceipted Artifact Anti-Pattern (Silencing via Exemption)

**Failure Mode:** An agent silences a linter or verification finding by adding it to an
exemption registry (`scripts/nolints-style.txt`, `scripts/nolints.json`) instead of
fixing the underlying issue. The exemption entry is added without a reasoned explanation
or a standing-aware assessment.

**Real incident from this repo:** The `scripts/nolints-style.txt` and `scripts/nolints.json`
files exist specifically to allow intentional exceptions (e.g., "this file intentionally
uses non-ASCII characters for mathematical notation" or "this code intentionally has
long lines for pedagogical reasons"). However, adding an entry merely to make CI pass —
without documenting the reason or assessing standing — corrupts the repository's standing
chain. The exemption registry is not a shortcut to green CI; it is a disciplined log of
**accepted, reasoned deviations** from the rules.

**The Law:**
- An entry in `nolints-style.txt`, `nolints.json`, or `noshake.json` must be paired with
  a documented reason (typically in a comment in the file being exempted, in a GitHub
  issue, or in `procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` for MFW-specific items).
- The reason should explain **why** the rule doesn't apply here, not just **that** it's
  being silenced.
- If you are silencing dozens of findings to make a branch merge, stop: that is not a
  scaling solution. Either fix the findings, or split the work and merge smaller pieces.
- Never use an exemption registry to hide uncertainty or "technical debt for later" — use
  `Standing: BLOCKED` or `Standing: UNKNOWN` in the code itself if work is incomplete.

---

## 5. The Hallucinated Resolution Anti-Pattern (Conflating Success with Proof)

**Failure Mode:** An agent observes that artifacts are written to disk or that the build
completes successfully, and prematurely reports completion without verifying that the
*semantic* or *proof* goal is actually satisfied. File-existence is conflated with
proof-existence; compilation-success is conflated with authorization-success.

**Real incident from this repo:** The Crown statement, `KernelCharacterization` in
`procint/ProcInt/MFW/Kernel.lean`, was for a time documented as a theorem while defined as:
```lean
def KernelCharacterization : Prop := KernelEquiv τ b₁ b₂ ↔ PDDL31TraceEquiv I b₁ b₂
```
It is a `def`, not a `theorem`, and has no proof body — just a naked `Prop` definition.
`lake build ProcInt` succeeds, which might lead an agent to conclude "the Crown Theorem
is now proven." But it is not. The definition exists; the proof does not.

Resolution (2026-07-16): the declaration remains a `def : Prop` but its docstring now
labels it a Conjecture and carries `Standing: CONJECTURAL` naming the missing proofs of
both directions over the K1–K4 kernel construction (receipt:
`../.verif-toolchain/receipts/receipt-20260716T215641Z.txt`). Full details are in
`../procint/ProcInt/MFW/AUDIT_FOLLOWUP.md`. This is the canonical instance of this
failure mode in this repository — the repair is honest labeling, not proof closure.

**The Law:**
- **"Written to disk" ≠ "proved".** A file existing is not proof that its contents are
  correct. A definition existing is not proof that it is proved. A theorem compiling is not
  proof that its proof body is sound (distinguish `theorem foo : P := sorry` — compiles
  but unproven — from `theorem foo : P := <real proof>` — compiles and proved).
- **"Compiles" ≠ "authorized".** `lake build` succeeding means the Lean syntax and type
  system are satisfied; it says nothing about the standing of the claims or the
  authorization-readiness of any derived artifact.
- **"Theorem" vs. "Conjecture" vs. "Definition".** In Lean 4:
  - `theorem foo : P := proof_body` — an asserted, proved claim.
  - `def bar : Prop := some_prop_expr` — a definition of a proposition; the existence of
    `bar` says nothing about whether the proposition is true.
  - Do not use `theorem` as a docstring label on a `def : Prop` unless the `def` body
    contains a real proof (not `sorry`, not just a bare tautology).

Before claiming any work is complete, read `../procint/ProcInt/MFW/AUDIT_FOLLOWUP.md`,
which catalogs exactly which formal objects in MFW have this status (proved vs. conjectural
vs. unproven vs. vacuous). Use the vocabulary from the root `../AGENTS.md` **Standing
Law** (ALIVE, PARTIAL_ALIVE, BLOCKED, BUILD_BROKEN, UNKNOWN, UNSUPPORTED) plus the
declaration-level tags CONJECTURAL and PROVEN defined in `../procint/AGENTS.md` for all
claims.

---

## See Also

- `../AGENTS.md` — root Standing Law, Change Discipline, Verification Ladder
- `../procint/AGENTS.md` — nested procint agent law and the full standing vocabulary
- `../procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` — detailed findings from the MFW audit,
  including the Crown Theorem case (failure mode #5) and the axiom/opaque/vacuous-predicate
  inventory (failures #1, #4); resolved 2026-07-16, kept as the historical catalog
- `../CURRENT_STATUS.md` — current standing and the 2026-07-16 verification receipt
- `../.claude/hookify.flag-mfw-axioms.local.md` — mechanically enforces guard against bare
  `sorry` and `axiom` declarations in MFW modules (related to failure modes #2, #4)
- `../.claude/hookify.flag-uncited-claims.local.md` — mechanically enforces citation of
  standing claims (related to failure mode #5)
