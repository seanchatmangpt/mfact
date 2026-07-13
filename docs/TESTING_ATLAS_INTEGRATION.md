# Testing Atlas Integration

Status: Active — governs citation of `docs/testing-atlas` (vendored verbatim, 93 files,
commit `f735022`). Last updated: 2026-07-13.

This is the only document that governs how the vendored Lean Testing Atlas may be cited by
future agents. The atlas itself (`docs/testing-atlas/**`) is never edited — it is a frozen,
verbatim import. This file is the correction and crosswalk of record, in the same shape as
AGENTS.md section 3's citation of arXiv:2607.09510, which is imported "as empirical
methodology only" and, per the No Ambient Theorem Authority law, "lends no proof-theoretic
standing to any mfact claim." Read this file before citing anything under `docs/testing-atlas`
in prose, a commit message, or a claim card.

## 1. Standing Declaration

The atlas is imported as **methodology only**. It is a manufacturing playbook — vocabulary,
families, per-test recipes, and templates for *how to write* tests — not a body of proven
results about mfact. No atlas token, no catalog row, and no green test result in the atlas's
own vocabulary ever upgrades the formal standing of an mfact/MFW claim. Standing is set
exclusively by the AGENTS.md section 4 lattice (`PROVEN`, `PROVEN_CONDITIONALLY`, `IMPORTED`,
`CONJECTURAL`, `BLOCKED_ON_CORRESPONDENCE`), never by atlas apparatus.

The atlas ships its own self-reported standing for the import itself, in
`docs/testing-atlas/SOURCE_AUDIT.json`, quoted verbatim:

```json
{
  "schema": "mfact.testing.atlas.source-audit.v1",
  "buildAttempted": false,
  "leanOrLakeInvoked": false,
  "standing": "SOURCE_COMPLETE_BUILD_NOT_RUN"
}
```

Read literally: the atlas's own authors never invoked `lake build` or `lean` against a single
one of its 133 catalog entries or 9 buildable-shaped templates before delivery. Every
`mfw_instance` name in the catalog is an unverified claim about this repo's source tree until
an agent in *this* repo independently re-checks it against the live checkout. Section 2 below
records six catalog claims that were re-checked and found factually wrong.

## 2. Errata Table

`docs/testing-atlas/20_catalog/TEST_INSTANCE_CATALOG.yaml` makes six claims about this repo's
source tree that independent verification found **factually wrong** — not merely aspirational,
but naming artifacts that do not exist anywhere under `procint/`. Each row below was
re-verified against the live tree at the time this document was written; the exact grep used
is given so a future agent can re-run it rather than trust this table on faith.

| ID | Family | Catalog names (wrong) | Real artifact |
|----|--------|------------------------|----------------|
| T055 | MUTATION | `closureWithoutIdempotence`, `replayReverseParents` | `bindDropSeqRight` |
| T062 | REGRESSION | `SocketShadow`, `StandingForgery`, `ParallelProjection` | none exist |
| T094 | EXPECTED_FAIL | `StandingForgery`, `CrossTenantGraft`, `MissingDescent` | no fail lane |
| T021 | DIAG | `crossTenantLeak` refusal constructor | `TenancyCountermodel` |
| T068 | CORRESPONDENCE | "TTL declaration→generated Lean declaration" | Actor→AtomVM |
| T029–T032 | PROPERTY | Plausible-sampled closure/receipt-DAG laws | finite-verified theorems |

### T055 — MUTATION

Catalog: `mfw_instance: "bindDropSeqRight / closureWithoutIdempotence / replayReverseParents"`.

```bash
grep -rn "closureWithoutIdempotence\|replayReverseParents" procint --include="*.lean"
# no matches
```

Only `bindDropSeqRight` (`procint/ProcInt/Playground/Experimental/WorkflowWorlds.lean:126`) is
real; it is also exercised at
`procint/ProcInt/Playground/ExperimentalWalkthrough.lean:96`. The other two mutant names in the
catalog row do not exist anywhere in the repo.

### T062 — REGRESSION

Catalog: `mfw_instance: "SocketShadow / StandingForgery / ParallelProjection"`.

```bash
grep -rn "SocketShadow\|StandingForgery\|ParallelProjection" procint --include="*.lean"
# no matches
```

None of the three named fixtures exist. Note also that
`docs/testing-atlas/10_llm_guides/12_regression.md`'s own Lean/Lake skeleton example reuses
the fabricated name `StandingForgery` inside a `namespace Regression.*.StandingForgery`
block — the error is not an isolated catalog typo, it is repeated in the guide prose too.

### T094 — EXPECTED_FAIL

Catalog: `mfw_instance: "StandingForgery / CrossTenantGraft / MissingDescent"`.

```bash
grep -rn "StandingForgery\|CrossTenantGraft\|MissingDescent" procint --include="*.lean"
# no matches
grep -ni "expected.fail\|expected_fail" justfile
# no matches
```

None of the three fixtures exist, and there is no failing-fixture package or expected-fail
build lane anywhere in `justfile`, `scripts/`, or `.github/workflows/*.yml`.

### T021 — DIAG

Catalog: `mfw_instance: "crossTenantLeak refusal"`.

```bash
grep -rn "crossTenantLeak" procint --include="*.lean"
# no matches
```

No such constructor exists. The real artifact modeling cross-tenant leakage is the
`TenancyCountermodel` section of `procint/ProcInt/MFW/Residue/Tenancy.lean` (a `Separated`
countermodel: `theorem not_separated`, `theorem tenant_purity_conclusion_fails`) — a proof
that the `Separated` hypothesis is load-bearing, not a typed refusal value. The only
`Except`-based typed refusal in `ProcInt` is `ClosureRefusal`
(`procint/ProcInt/Playground/Experimental/Closure.lean:53`); confirmed the sole hit by
grepping every file that mentions both `Except` and `Refusal`.

### T068 — CORRESPONDENCE

Catalog: `mfw_instance: "TTL declaration→generated Lean declaration"`.

The canonical `StepCorrespondence` inhabitant in the repo
(`procint/ProcInt/Playground/Swarm11/Correspondence/AtomVM.lean:33`) is typed over an abstract
actor step and a runtime state (its own header: "Abstract Actor to AtomVM Transition
Correspondence"), not TTL and Lean. `LedgerBridge.lean` in the same directory supplies a
positive instance and a kernel-checked negative result against that same `StepCorrespondence`
structure — none of it is about TTL projection. TTL→Lean is a ggen render step in this repo's
build pipeline, not a proven preservation theorem with an admitted `StepCorrespondence`
witness; conflating the two is exactly the T068 catalog error.

### T029–T032 — PROPERTY

Catalog: `mechanism: "Plausible/Testable"` / `"Plausible Gen"` / `"Plausible shrink"`, claiming
closure-idempotence and receipt-DAG laws are established by generated sampling.

```bash
grep -rln "Plausible\|plausible" procint/ProcInt --include="*.lean"
# procint/ProcInt/Registry/Breeds.lean  (single hit)
grep -n "Plausible\|plausible" procint/ProcInt/Registry/Breeds.lean
# 61: ...Pearl, J. (1988) "...Networks of Plausible Inference."...
grep -n "^import Plausible\|import Plausible" procint/ProcInt --include="*.lean" -r
# no matches
```

The single grep hit is a bibliographic citation string ("Networks of Plausible Inference",
Pearl 1988) inside an algorithm-registry entry — not a library import. `Plausible` is vendored
at `procint/.lake/packages/plausible/` (declared in `procint/lake-manifest.json`) but is
imported by **zero** `ProcInt` modules. The actual closure-idempotence and receipt-DAG laws in
this repo are proven or finite-verified theorems (e.g. `TenancyCountermodel`'s
`f_idempotent`), not sampled/shrunk properties. Section 5 below states the standing rule this
errata entry follows from.

## 3. Vocabulary Crosswalk

This is the section that defuses the real collision risk: the atlas and AGENTS.md both use the
words `PROVEN`, `CORRESPONDENCE`, and evidence-ranking vocabulary, but they are **not the same
lattice**. Never let an atlas term stand in for an AGENTS.md term in prose about this repo's
own standing.

| Atlas term | AGENTS.md equivalent | Rule |
|---|---|---|
| `CANDIDATE_ONLY` | `CONJECTURAL` | Direct map; both mean "named, not yet evidenced." |
| `FINITE_VERIFIED` | ranks *below* `PROVEN` | See `Standing.finiteVerified` below. |
| `ALIVE` / `CrownAlive(c)` | no automatic equivalent | See rule below; never write as `PROVEN`. |
| atlas `PROVEN` (claim class) | **different word** from AGENTS.md `PROVEN` | See rule below. |
| family-17 `CORRESPONDENCE` (T068) | **not** AGENTS.md `CORRESPONDENCE` edge | See rule below. |
| `EXPLICIT_GAP` / `MISSING_NODE` / `MISSING_EDGE` | `MISSING` | Direct map. |
| — (no token) | `IMPORTED`, `PROVEN_CONDITIONALLY`, `BLOCKED_ON_CORRESPONDENCE` | Coverage hole. |

**`FINITE_VERIFIED` ranks below `PROVEN`.** The atlas's own `10_llm_guides/24_inventory.md`
(`T109`, line 173) names the canonical instance as "FINITE_VERIFIED vs PROVEN" — the atlas
itself treats these as distinct classes. This repo has a load-bearing Lean artifact making the
same distinction executable: `Standing.finiteVerified` in
`procint/ProcInt/Playground/Swarm11/Standing.lean`. Its `canClaimTheorem` projection
(`Standing.lean:47-49`) returns `true` only for `.proven`, and the file proves the negative
case as a `@[simp]` theorem:

```lean
-- procint/ProcInt/Playground/Swarm11/Standing.lean:57-58
@[simp] theorem finiteVerified_not_theorem :
    Standing.finiteVerified.canClaimTheorem = false := rfl
```

`finiteVerified.canClaimTheorem = false` is proved by `rfl` in this repo's own kernel-checked
source — an atlas `FINITE_VERIFIED` claim class must never be read or written as AGENTS.md
`PROVEN`.

**`ALIVE` / `CrownAlive(c)` has no automatic AGENTS.md equivalent.** Per
`10_llm_guides/31_ELEVEN_WITNESS_CROWN_MATRIX.md`: `CrownAlive(c)` is permitted only when
every witness required by a claim card's 11-row matrix `(K,P,N,C_m,P_b,M_e,M_u,C_o,F,R,S)` is
admitted, and a witness may be explicitly marked `NOT_APPLICABLE` with a stated structural
reason ("`NOT_IMPLEMENTED` and `NOT_APPLICABLE` are never synonyms," line 27). This is a
crown-completeness predicate over a witness *tuple*, not a standing value on a single claim.
Rule, stated explicitly: an atlas `ALIVE`/`CrownAlive` verdict ranks at or below the **weakest**
evidence class among its admitted witnesses, and must never be read or written as AGENTS.md
`PROVEN`. If even one witness in the tuple is `FINITE_DECISION`-tier, the whole `CrownAlive`
verdict is capped at that tier, regardless of how many other witnesses are kernel proofs.

**Atlas `PROVEN` (a claim class reachable via `FINITE_DECISION`-tier evidence, per
`05_property.md`: "Property testing... never promotes a candidate law to PROVEN") is a
different word from AGENTS.md `PROVEN`** (a standing value reachable only via kernel-checked
proof under an allowed axiom set, AGENTS.md section 4). The atlas term is **deprecated in
mfact prose**: when writing about this repo's own standing, use the AGENTS.md lattice
exclusively and never write bare "PROVEN" without disambiguating which vocabulary it comes
from.

**Atlas family-17 "correspondence" (artifact projection, e.g. T068's TTL→Lean claim) is not
the same as AGENTS.md's `CORRESPONDENCE` edge** (a standing-transferring morphism `κ : A → B`
with discharged structure-preservation obligations, AGENTS.md section 4). Rule, stated
explicitly: a green atlas correspondence test (family CORRESPONDENCE, T068–T069) discharges
**nothing** on an AGENTS.md correspondence obligation. Passing `encodeLedger_preservesStep` in
`LedgerBridge.lean` is evidence about that one `StepCorrespondence` instance; it is not a
theorem card and does not admit a `κ` for any mfact/MFW claim.

**Coverage hole.** The atlas has no token for `IMPORTED`, `PROVEN_CONDITIONALLY`, or
`BLOCKED_ON_CORRESPONDENCE`, and no theorem-card apparatus at all — no field in
`00_SYSTEM_CONSTITUTION.md`'s "Required header before writing any test" corresponds to
AGENTS.md's Object / Imported theorem / Source hypotheses / Correspondence map / Preserved
structure / Conclusion / Standing card. AGENTS.md's theorem-card requirement continues to
apply in full on top of any atlas-flavored workflow. The atlas governs *how a test is written*;
it does not substitute for, shorten, or pre-satisfy the theorem-card obligation.

## 4. Aspirational-Families Disclosure

Independent sampling across all 30 families (40+ catalog entries) found roughly 62% of sampled
instances grounded in real repo artifacts today, roughly 15% partial, and roughly 23%
aspirational — apparatus the family's guide describes but that has not been built in this repo
yet. (This 62/15/23 split is a sampling estimate carried from that review pass, not a
recomputed census of all 133 entries in this document; treat it as an order-of-magnitude
signal, not an exact count.) The aspirational share concentrates in seven families. A future
agent must not mistake the catalog's `mfw_instance` column for an inventory of things that
already exist — the table below records what independent spot-checks in this pass confirmed
is still missing for each.

| Family | What's missing (one line) |
|---|---|
| PROPERTY | `Plausible` vendored, imported by zero `ProcInt` modules. |
| DIFFERENTIAL | No A/B implementation-compare harness anywhere in `ProcInt`. |
| REGRESSION | No regression namespace/directory; named fixtures are fabricated (T062). |
| EXPECTED_FAIL | No failing-fixture package, no expected-fail Lake target. |
| PERF | No benchmark harness: no `*bench*` path, no `Benchmark` declarations. |
| COMPLEXITY | "Complexity" is prose/citation text only; no scaling-exponent apparatus. |
| STANDING_PATH | `StandingPathReceipt` exists only in the template, not in `ProcInt`. |

Detail per family, each independently re-checked at write time:

- **PROPERTY**: see section 2 (T029–T032) for the full grep evidence.
- **DIFFERENTIAL**: `grep -rl "[Dd]ifferential" procint/ProcInt --include="*.lean"` returns
  nothing — no A/B compare harness exists.
- **REGRESSION**: no directory or namespace named `Regression` under `procint/ProcInt`; the
  only named fixtures anywhere are the fabricated catalog names from T062 (section 2).
- **EXPECTED_FAIL**: `grep -ni "expected.fail\|expected_fail" justfile` and equivalent checks
  of `scripts/` and `.github/workflows/*.yml` all return nothing (section 2, T094).
- **PERF**: no path under `procint/` matches `*bench*`, and no `Benchmark` declaration exists
  in any `.lean` file.
- **COMPLEXITY**: the only hits for "complexity" are prose/citation strings in
  `Registry/Algorithms.lean` (e.g. `alg_complexity_metrics`, a van der Aalst 2016 citation) —
  no scaling-exponent measurement in the sense AGENTS.md section 2 requires for a phase-change
  claim.
- **STANDING_PATH**: `StandingPathReceipt` exists only in
  `docs/testing-atlas/30_templates/StandingPath.lean.template`;
  `grep -rl "StandingPathReceipt\|StandingPath" procint/ProcInt --include="*.lean"` returns
  nothing.

## 5. The P_b (Property) Ruling

For finite, `decide`-closed carriers — the norm in this repo's SOC2/tenancy work (e.g. the
`TenancyCountermodel` finite `Finset Obl` instance in `Tenancy.lean`) — property-based or
randomized testing is ruled **`NOT_APPLICABLE`**, not skipped silently. The atlas's own crown
law explicitly permits and distinguishes `NOT_APPLICABLE` from `NOT_IMPLEMENTED`
(`31_ELEVEN_WITNESS_CROWN_MATRIX.md:26-27`, quoted in section 3 above). Exhaustive kernel
`decide` over a small finite domain strictly dominates a sampled-and-shrunk run: the `decide`
result is a kernel-checked total case analysis over the domain, while a Plausible run is 100
generated samples with no completeness guarantee over the same domain.

The Plausible caveat is load-bearing, not cosmetic. Its own doc comment states the tactic's
success behavior plainly:

```text
-- procint/.lake/packages/plausible/Plausible/Tactic.lean:137-138
If `plausible` successfully tests 100 examples, it acts like
admit. If it gives up or finds a counter-example, it reports an error.
```

and the implementation matches the doc comment exactly — on success it calls `admitGoal g`
(`Tactic.lean:206`, also `:176`). `admitGoal` is Lean 4 core
(`Lean/Elab/Tactic/Basic.lean` in the pinned `leanprover/lean4:v4.31.0` toolchain,
confirmed at `procint/lean-toolchain`):

```lean
def admitGoal (mvarId : MVarId) (synthetic : Bool := true): MetaM Unit :=
  mvarId.withContext do
    let mvarType ← inferType (mkMVar mvarId)
    mvarId.assign (← mkLabeledSorry mvarType (synthetic := synthetic) (unique := true))
```

`admitGoal` assigns the goal via `mkLabeledSorry` — the `sorryAx` mechanism. A `plausible`
tactic call that finds no counterexample **closes the goal via `sorryAx`, exactly like
`sorry`**, and any such theorem carries a `sorryAx` axiom dependency detectable by
`#print axioms` or `Lean.collectAxioms`. Rule: `plausible` must never appear inside a crown
theorem body — its use, if any, belongs strictly outside the trusted kernel-checked core (e.g.
as a pre-proof exploratory falsifier search), never as the closing tactic of an admitted claim.

## 6. Template Buildability Table

Of the 9 `.lean.template` files under `docs/testing-atlas/30_templates/`, 3 contain no literal
`...` placeholder holes and are near-buildable against the pinned toolchain; the other 6 are
pseudocode skeletons with unresolved holes.

| Template | Status | `...` holes |
|---|---|---|
| `EnvironmentAuditor.lean.template` | near-buildable | 0 |
| `StandingPath.lean.template` | near-buildable | 0 |
| `ClaimCard.lean.template` | near-buildable | 0 |
| `CompositionFlow.lean.template` | pseudocode | 2 |
| `Countermodel.lean.template` | pseudocode | 1 |
| `Metamorphic.lean.template` | pseudocode | 4 |
| `MutationKiller.lean.template` | pseudocode | 4 |
| `NegativeFixture.lean.template` | pseudocode | 1 |
| `PositiveWitness.lean.template` | pseudocode | 2 |

Confirmed by `grep -l "\.\.\." docs/testing-atlas/30_templates/*.template` at write time; the
6 pseudocode files were exactly the 6 hits, the 3 near-buildable files had zero hits.

Detail on the 3 near-buildable files:

- `EnvironmentAuditor.lean.template` does `import Lean` and `import Lean.Util.CollectAxioms`.
  `Lean.Util.CollectAxioms` is confirmed to exist at the pinned `v4.31.0` toolchain
  (`src/lean/Lean/Util/CollectAxioms.lean`). Its body is comment-only steps ("collectAxioms
  for each theorem," etc.) describing the auditor, not executable code — no `...` holes, but
  also no function bodies to actually run yet.
- `StandingPath.lean.template` and `ClaimCard.lean.template` both declare real `structure`s
  (`StandingPathReceipt`, `ClaimCard`) with zero `...` holes, but neither file has an `import`
  line at all, despite using `Name` and `Finset` — both need `import Lean` and a Mathlib
  `Finset` import added before they would actually compile. "Near-buildable" means
  hole-free, not literally ready to `lake build` unmodified.

The remaining 3 files in the directory are non-Lean and out of scope for buildability:
`ExpectedFailure.README.md` (prose checklist), `LakeTargets.md` (prose list of target names),
`TestMetadata.yaml.template` (a YAML fill-in-the-blank form, all fields are `____` placeholders
by design — it is metadata, not code).

## 7. Guide-Quality Summary

All 30 per-family guides (`docs/testing-atlas/10_llm_guides/{01..30}_*.md`) tile `T001`–`T133`
exactly: a fresh count found exactly 133 `## T###` headers across the 30 files, covering every
ID from `T001` to `T133` with zero gaps and zero duplicate coverage across files (cross-checked
against the catalog, which independently has the same 133 IDs with zero gaps and zero
duplicates). No Lean/Lake API named in the guides was found to be fictitious at the pinned
v4.31.0 toolchain: `#guard_panic` exists (`Init/Notation.lean`), `#guard_msgs` exists
(`Lean/Elab/GuardMsgs.lean`), and `Lean.collectAxioms`/`native_decide` are likewise real APIs
at this toolchain. This document did not independently reconfirm the specific historical claim
"`#guard_panic` real since Lean v4.28" — only the pinned v4.31.0 and an older v4.11.0-rc2 elan
toolchain were available locally, and v4.28 itself was not installed to check; that detail
**could not be reconfirmed as of this writing** and is flagged rather than silently dropped.

Two disclosed demerits, both independently reconfirmed in this pass:

- **Boilerplate recipe.** The per-test "LLM implementation recipe" (8 numbered steps) is
  identical across families except for two token substitutions: step 1 (the test's own ID) and
  step 6 (the mechanism name in bold). Steps 2, 3, 4, 5, 7, and 8 are byte-identical prose in
  every guide checked (compared `01_kernel.md` T001 against `25_perf.md` T112). Real content
  lives only in each guide's top matter: "Family law," "Mandatory implementation sequence,"
  "Core-team anti-patterns," and the Lean/Lake skeleton.
- **Missing claim-ceiling sentence.** `34_NO_AMBIENT_TEST_AUTHORITY.md` mandates a sentence of
  the form "This evidence establishes X... It does not establish Y" before any standing
  promotion. Direct reading of each guide's "Family law" section (not a mechanical grep — the
  literal phrase "does not establish" appears nowhere in any of the 30 family guides, only in
  the constitution doc itself as a template) found four guides whose family law is purely
  descriptive with no explicit disclaimer of what the family's evidence does *not* establish:
  `03_diag.md`, `06_algebra.md`, `07_metamorphic.md`, `18_invariant.md`. Contrast
  `04_finite.md`'s family law, which states the ceiling inline: "`native_decide` can produce a
  proof for a decidable proposition but does not generalize beyond the encoded finite
  proposition." The four flagged guides carry no equivalent sentence.

Ratings inherited from the review that produced this document: 10 STRONG, 17 ADEQUATE, 3 WEAK
(`14_flow.md`, `15_e2e.md`, `12_regression.md` — thin, not wrong). This pass directly read all
three WEAK-rated guides in full and confirms the "thin" characterization: each has a
single-paragraph family law, exactly one test instance, three anti-pattern bullets, and no
worked example beyond the generic skeleton — none contains an incorrect API call or a false
claim about this repo. The full STRONG/ADEQUATE split across the remaining 27 guides was **not
independently re-scored line-by-line in this pass**; a lines-per-test-instance proxy computed
during verification did not cleanly separate STRONG from ADEQUATE (single-test-instance guides
are structurally shorter regardless of prose quality), so that count is carried from the prior
review rather than freshly re-derived here, and is flagged accordingly rather than presented as
independently confirmed.
