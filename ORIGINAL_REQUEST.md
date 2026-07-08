# Original User Request

## Initial Request — 2026-07-07T18:38:21-07:00

# Teamwork Project Prompt — Final Launch Version

## Definition of Done

The project is complete only when all of the following are true:

1. The existing `v26.7.7-procint-certified` state is frozen with a post-victory receipt.
2. Git status is clean before new work begins.
3. `HEAD` matches `v26.7.7-procint-certified`, or any mismatch is explicitly resolved, committed, and re-tagged.
4. Standing Guard `scan()` reports zero `BLOCKER` findings before and after the new work.
5. Ticket 015 governance reconciliation is complete.
6. `standing.env` deduplication is fixed so duplicate keys do not accumulate.
7. The paper is restructured around the five-rail standing-manufacturing architecture:

   * Formal rail
   * Process-law rail
   * Benchmark/rslab rail
   * Correspondence/Aeneas rail
   * Paper/publication rail
8. `mfact/rslab/` exists as a declared empirical evidence rail.
9. Real praxis benchmark/test outputs are collected from `/Users/sac/praxis`.
10. No fake, placeholder, guessed, or hand-typed benchmark numbers appear anywhere.
11. Raw praxis outputs are imported into rslab.
12. rslab normalization validates raw evidence against schemas.
13. Receipts are generated for imported benchmark evidence.
14. LaTeX paper fragments are generated from processed rslab evidence.
15. `paper/main.tex` contains prose and `\input{...}` references only; empirical metrics come from generated fragments.
16. Missing raw data, missing receipt, invalid schema, failed parser, or unavailable praxis benchmark must fail closed as `BLOCKED` or `REFUSED`.
17. `just check`, `just release`, `just regen-check`, and `just paper-check` pass cleanly.
18. The final release tag is confirmed or re-cut to the clean final commit.
19. Terminal state is exactly one of:

* `ALIVE`
* `BLOCKED`
* `BUILD_BROKEN`

No victory claim is valid until an independent final audit confirms the tree is clean, the receipts agree, and the tag points to the final clean commit.

---

# Mission

Freeze the current `v26.7.7-procint-certified` release state with a post-victory receipt, resolve Ticket 015 governance issues, and execute Tickets 016–020 to restructure the paper and build the `rslab` empirical evidence rail using real praxis benchmark evidence.

Working directory:

`/Users/sac/mfact`

External benchmark source:

`/Users/sac/praxis`

Integrity mode:

`development`

---

# Core Doctrine

Preserve the rail boundaries.

`rslab` is not a proof engine.

`rslab` is the empirical evidence rail.

`praxis` executes law-state checks and benchmarks.

`rslab` collects, normalizes, schemas, receipts, and renders empirical evidence.

`mfact` admits formal standing.

`Aeneas` bridges Rust implementation into Lean-facing correspondence.

`Lake` is the formal admission actuator.

The paper is not source of truth. The paper reports admitted, receipted, or explicitly bounded claims.

Do not collapse empirical benchmark evidence into formal proof.

Do not collapse Aeneas correspondence into runtime benchmarking.

Do not treat generated fragments as source of truth.

Do not treat a passing build as standing unless the manifest, receipt, scan, and release gates agree.

---

# Execution Order

The work must execute in this order:

`R0 → Ticket 015 → Tickets 016 and 17 → Ticket 018 → Ticket 019 → Ticket 020`

Tickets 016 and 017 may run in parallel only after R0 and Ticket 015 are clean.

Ticket 018 must not begin until the `rslab` skeleton exists.

Ticket 019 must not begin until real raw praxis evidence exists or Ticket 018 is explicitly marked `BLOCKED`.

Ticket 020 must not handwrite benchmark numbers. It may only reference generated fragments.

---

# R0. Freeze Certified State

Before executing any new ticket, freeze the current certified release state.

Required actions:

1. Confirm git status is completely clean.
2. Confirm `HEAD` matches `v26.7.7-procint-certified`.
3. Verify Standing Guard `scan()` has zero `BLOCKER` findings.
4. Run `just check`.
5. Run `just release`.
6. Save the Standing Guard final scan output as a release receipt.
7. Commit or ledger the post-victory receipt.

Required commands or equivalent repo-native commands:

```bash
cd /Users/sac/mfact
git status --short
git rev-parse HEAD
git rev-parse v26.7.7-procint-certified
git tag --points-at HEAD
just check
just release
```

If `HEAD` and the tag differ, do not proceed casually. Determine whether the tag is stale, whether the tree is dirty, or whether the prior report has a commit-reference inconsistency. Resolve with receipts, commit, and re-tag only after validation.

Terminal result for R0:

`ALIVE`, `BLOCKED`, or `BUILD_BROKEN`.

---

# R1. Governance Reconciliation — Ticket 015

Reconcile and re-certify the governance state.

Required actions:

1. Re-verify the final state of Tickets 013 and 014.
2. Confirm Standing Guard sees zero blockers.
3. Fix `standing.env` deduplication logic in the `justfile`.
4. Ensure duplicate keys cannot accumulate across repeated runs.
5. Prefer robust filtering such as `grep -vE`, multiple grep passes, or a deterministic rewrite path.
6. Re-run the canonical certification pipeline.
7. Confirm or re-cut `v26.7.7-procint-certified` at the clean certified commit.

Canonical pipeline:

```bash
just render
just build
just audit
just manifest
just certify
just test
just regen-check
```

Acceptance:

* `justfile` deduplication bug fixed.
* `release/standing.env` has no duplicate keys after repeated runs.
* Standing Guard scan reports zero blockers.
* `just check` passes.
* `just release` passes.
* `just regen-check` passes.
* Tag is positioned at clean final governance commit.

---

# R2. Paper Restructure and rslab Skeleton — Tickets 016 and 017

## Ticket 016 — Paper Restructure

Restructure `paper/main.tex` around the five-rail standing-manufacturing architecture.

Required architecture:

1. Formal rail
2. Process-law rail
3. Benchmark/rslab rail
4. Correspondence/Aeneas rail
5. Paper/publication rail

Required paper changes:

1. Promote Aeneas to a top-level section.
2. Add or restructure a section for `praxis-graphlaw` as executable law-state evaluation.
3. Add or restructure a section for `rslab` as empirical evidence rail.
4. Preserve existing labels where possible.
5. Avoid breaking existing references.
6. Do not add benchmark numbers manually.
7. Use placeholders or generated fragment inputs only.
8. Ensure `just paper-check` passes.

Hard rule:

No empirical metrics may be hardcoded in `paper/main.tex`.

## Ticket 017 — rslab Skeleton

Create `mfact/rslab/` as a greenfield empirical evidence rail.

Required structure:

```text
rslab/
  README.md
  manifest.toml
  schemas/
    benchmark_result.schema.json
    profiler_result.schema.json
  experiments/
    praxis_graphlaw/
      benchmark_plan.md
      raw/
      processed/
      flamegraphs/
      tables/
      receipts/
  paper_fragments/
  receipts/
  scripts/
```

Required contents:

* `README.md` includes the rslab doctrine:

  * `rslab is not a proof engine.`
  * `rslab is the empirical evidence rail.`
  * `praxis executes; rslab measures, normalizes, receipts, and renders.`
  * `mfact admits formal standing.`
* `manifest.toml` declares the `praxis_graphlaw` experiment with `status = "DECLARED"` or repo-canonical equivalent.
* Schemas exist for benchmark and profiler evidence.
* `benchmark_plan.md` outlines planned praxis commands and expected artifact classes.
* `.gitkeep` files are added where needed.
* No benchmark results or numbers are invented.

Schema note:

Use public ontology-aligned metadata where appropriate, such as PROV-O, DCAT, DCTERMS, QUDT, SPDX/SBOM-style provenance, or machine/toolchain metadata. Do not block the project by inventing a perfect public ontology model. The minimum viable requirement is structured, validated, provenance-carrying empirical evidence.

Acceptance:

* rslab skeleton exists.
* rslab manifest declares status as `DECLARED`.
* No fake benchmark data exists.
* Paper builds with structural placeholders.

---

# R3. Import Benchmarks and Normalize — Tickets 018 and 019

## Ticket 018 — praxis Benchmark Import

Autonomously inspect `/Users/sac/praxis` and discover the real benchmark/test commands.

Do not assume benchmark names. Inspect:

* `Cargo.toml`
* workspace members
* `crates/praxis-graphlaw/`
* `benches/`
* test files
* existing reports
* existing just recipes
* existing criterion or benchmark harnesses

Collect real outputs for available categories:

* N3
* Datalog
* SHACL
* ShEx or ShExC

If one category is unavailable, mark it `UNSUPPORTED` or `BLOCKED` with evidence. Do not invent it.

Required import path:

```text
/Users/sac/mfact/rslab/experiments/praxis_graphlaw/raw/
```

Required receipt:

```text
/Users/sac/mfact/rslab/receipts/praxis_graphlaw_benchmark_receipt.toml
```

Receipt must include:

* praxis git commit
* mfact git commit
* command log
* toolchain versions
* OS/machine context where available
* raw file paths
* raw file hashes
* status
* timestamp
* unsupported or blocked categories, if any

Status must be empirical, such as `EXTRACTED`, not `PROVEN`.

Hard rule:

If `/Users/sac/praxis` is unavailable, or benchmark/test commands cannot produce real raw evidence, Ticket 018 must end `BLOCKED`. Do not create fake numbers.

## Ticket 019 — Normalization and Fragment Rendering

Build scripts:

```text
rslab/scripts/collect_praxis_graphlaw.py
rslab/scripts/render_paper_fragments.py
```

Required behavior:

1. Validate raw outputs against schemas.
2. Parse real benchmark/test output.
3. Produce processed structured files.
4. Generate receipts.
5. Generate LaTeX fragments from processed results.
6. Fail closed on missing or invalid evidence.
7. Refuse to render empirical metric fragments without a valid receipt.

Required generated fragments may include:

```text
rslab/paper_fragments/praxis_graphlaw_summary.tex
rslab/paper_fragments/praxis_graphlaw_benchmarks.tex
rslab/paper_fragments/praxis_graphlaw_profiles.tex
rslab/paper_fragments/rslab_readiness.tex
```

Wire into:

* `.mfact/artifacts.toml`
* `justfile`
* `paper/main.tex`
* arXiv packaging list, if applicable

Add or update just recipes:

```text
rslab-fragments
rslab-check
```

Acceptance:

* raw outputs imported
* processed outputs generated
* schemas validate
* receipt generated
* fragments generated
* missing receipt causes failure
* `just regen-check` passes
* generated/ledgered artifacts are not hand-edited

---

# R4. Final Paper Prose — Ticket 020

Write the final structural prose in `paper/main.tex`.

Sections to complete or restructure:

1. `praxis-graphlaw: Executable Law-State Evaluation`
2. `rslab: Empirical Evidence Rail`
3. `Implementation Correspondence with Aeneas`
4. `Evaluation`
5. `Limitations and Standing`
6. `Availability and Reproducibility`

Required distinctions:

* Formal proof rail is not benchmark rail.
* Benchmark rail is not correspondence rail.
* Aeneas correspondence is not runtime evidence.
* rslab evidence is empirical, schema-validated, and receipted.
* The paper reports from generated fragments and receipts.

Hard rule:

`paper/main.tex` may explain architecture, methods, and interpretation. It must not hand-type empirical metrics.

Acceptance:

```bash
just prose-lint
just paper-check
just regen-check
just check
just release
```

All must pass, or failures must be classified as `BLOCKED` or `BUILD_BROKEN`.

---

# Final Audit

Before claiming victory, spawn or run an independent final audit.

Audit must verify:

1. git status clean
2. no duplicate `standing.env` keys
3. Standing Guard zero blockers
4. `just check` pass
5. `just release` pass
6. `just regen-check` pass
7. `just paper-check` pass
8. no handcoded benchmark metrics in `paper/main.tex`
9. rslab raw outputs came from real praxis commands
10. receipt hashes match raw files
11. generated fragments match processed benchmark results
12. final tag points to final clean commit

Final report must include:

1. Terminal State
2. Definition-of-Done checklist
3. R0 freeze receipt evidence
4. Ticket 015 governance reconciliation summary
5. Paper restructure summary
6. rslab skeleton summary
7. praxis benchmark import summary
8. normalization and schema validation summary
9. generated paper fragment summary
10. paper build results
11. canonical pipeline results
12. tag evidence
13. files changed
14. receipts generated
15. remaining `UNKNOWN`, `UNSUPPORTED`, `BLOCKED`, or `BUILD_BROKEN` items

---

# Final Terminal State Rules

Use exactly one:

`ALIVE`

All gates pass, receipts agree, tag is clean, paper builds, rslab evidence is real and validated.

`BLOCKED`

The team cannot proceed because required evidence, repo state, praxis commands, schemas, or source files are unavailable.

`BUILD_BROKEN`

The repo, paper, or release pipeline fails after attempted repair.

No other terminal state is acceptable.
