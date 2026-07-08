# Ticket 017 — rslab Skeleton: The Empirical Evidence Rail

## Type

Infrastructure / New Surface

## Standing

DECLARED

## Objective

Create `mfact/rslab/`, a new empirical-evidence rail, greenfield (zero prior
mentions anywhere in the repo, verified by search). Its job: turn praxis-graphlaw
benchmark/test output into schema-validated, receipted, replayable evidence that
downstream paper fragments can cite. This ticket creates structure only — no
benchmark has been run yet, no numbers exist yet, and none may be invented here.

## Doctrine (record verbatim in `rslab/README.md`)

```text
praxis executes.
rslab measures and receipts.
mfact admits formal standing.
paper renders admitted/receipted claims.

rslab is not a proof engine.
rslab is an empirical evidence rail.

praxis raw output = O
schema-validated, receipted output = O*
paper fragment generated from an rslab receipt = A
```

## Non-Goals

This ticket must not:

* run any benchmark (that is Ticket 018)
* write any benchmark number, timing, or result anywhere in this skeleton
* write `rslab/scripts/*.py` implementations (name the files in `manifest.toml`
  and this ticket's doc; Ticket 019 implements them)
* invent a new status token (e.g. `MEASURED`) — imported empirical evidence uses
  the existing ladder token `EXTRACTED` until a separate vocabulary-change ticket
  is opened and approved
* add `rslab/` to `.mfact/artifacts.toml` yet — the skeleton itself carries no
  standing; only receipts and generated fragments (Ticket 019) need ledgering
* touch the paper

## Required Artifacts

```text
mfact/rslab/README.md
mfact/rslab/manifest.toml
mfact/rslab/schemas/benchmark_result.schema.json
mfact/rslab/schemas/profiler_result.schema.json
mfact/rslab/experiments/praxis_graphlaw/benchmark_plan.md
mfact/rslab/paper_fragments/.gitkeep
mfact/rslab/receipts/.gitkeep
mfact/rslab/scripts/.gitkeep
```

### `README.md` must state

* the doctrine block above, verbatim
* the O/O*/A mapping
* that rslab experiment *inputs* (this skeleton, benchmark plans, scripts) are
  unledgered — same governance tier as `pylab/`: hand-authored, never
  ggen-rendered, edit freely
* that rslab *receipts* and any *generated paper fragments* built from them
  (Ticket 019) must be ledgered in `.mfact/artifacts.toml`, because they carry
  evidence that feeds paper claims
* a pointer to `research/verif/obligations.toml`'s status-ladder pattern
  (`DECLARED < EXTRACTED < STATED < PROVEN`) as the schema this rail reuses

### `manifest.toml` must declare

* one experiment entry: `praxis_graphlaw`, `status = "declared"`, pointing at
  `experiments/praxis_graphlaw/benchmark_plan.md`
* no results fields populated

### `schemas/benchmark_result.schema.json` must define (JSON Schema draft)

* required fields: `builder`, `experiment_id`, `command`, `raw_output_path`,
  `raw_output_hash` (b3sum, mirroring `release/verif-receipt.json`'s hashing
  convention), `toolchain` (object: rust version/date, hardware note),
  `evidence` (object: `declared`, `extracted` booleans — mirrors
  `verif-receipt.json`'s per-obligation evidence shape)
* explicitly no `proven`/`stated` booleans (this rail produces empirical, not
  formal, evidence — do not overload the formal-proof ladder fields)

### `schemas/profiler_result.schema.json` must define

* same shape as above, plus a `profiler_tool` field
* a top-level comment/description noting: as of this ticket, no profiling/
  flamegraph tooling exists in `/Users/sac/praxis` (verified by exploration) — this
  schema is prepared for future use, not populated by Ticket 018

### `experiments/praxis_graphlaw/benchmark_plan.md` must enumerate exactly

(no more, no less — this is a plan against verified-runnable evidence, not an
aspirational list):

* `cargo bench -p praxis-graphlaw` — four suites: `bench` (ImaRS window add/update,
  `bencher` harness), `hierarchies` (N3 forward-chaining at depth 1000/10000,
  `bencher`), `dialects` (SHACL/ShEx/N3/Datalog throughput at 100/1000/5000 focus
  nodes, `bencher`), `blue_river_dam` (`TripleStore::materialize()` incremental
  delta, `divan`)
* root-level `cargo bench` — `receipt_validate` (criterion, <5 ms target for ~100
  records), `bench_main` (criterion), `blue_river_dam` (divan; control-layer
  surfaces: standing transitions, PDDL grounding, POWL scheduler, receipt chain)
* `cargo test -p praxis-graphlaw` — conformance/stress/fuzz suite (README claims
  380 passed at time of exploration; Ticket 018 must re-run, not cite this number
  as current)
* `cargo test -p ggen --test graphlaw_e2e` — 5 admission/refusal/determinism tests
* explicit caveats section: mixed benchmark harnesses in use (`bencher`, `divan`,
  `criterion` — no single harness); no flamegraph/profiler tooling exists in the
  praxis workspace as of this exploration; "transaction-path admission control" is
  not an existing named artifact in praxis (nearest existing concepts: SHACL/ShEx
  admission gates, `bcinr_powl::admit::{admit, AdmissionContext}`) — any paper
  language using that phrase must describe it as a design goal, not a shipped
  feature
* toolchain pin: `nightly-2026-04-15` (from `/Users/sac/praxis/rust-toolchain.toml`)

## Required Verification Commands

```bash
test -f rslab/README.md
test -f rslab/manifest.toml
test -f rslab/schemas/benchmark_result.schema.json
test -f rslab/schemas/profiler_result.schema.json
test -f rslab/experiments/praxis_graphlaw/benchmark_plan.md
python3 -c "import json; json.load(open('rslab/schemas/benchmark_result.schema.json'))"
python3 -c "import json; json.load(open('rslab/schemas/profiler_result.schema.json'))"
grep -rn '[0-9]\+\.\?[0-9]*\s*\(ns\|µs\|ms\|s\)\b' rslab/ || echo "no numeric benchmark claims found (expected)"
just regen-check
```

## Definition of Done

1. All seven required files/dirs exist at the paths listed above.
2. `README.md` contains the doctrine block verbatim and the O/O*/A mapping.
3. Both JSON schemas parse as valid JSON and define the required fields.
4. `benchmark_plan.md` lists exactly the four verified-runnable evidence sources
   and both caveat items (mixed harnesses, no profiler tooling).
5. No benchmark number, timing, or result appears anywhere under `rslab/`.
6. `manifest.toml` declares the one experiment as `status = "declared"`.
7. `.mfact/artifacts.toml` is NOT modified by this ticket.
8. `paper/main.tex` is NOT modified by this ticket.
9. `just regen-check` exits 0 (rslab/ is unledgered; must not appear in the diff).

## Terminal States

* `ALIVE`: all 9 DoD items pass.
* `BLOCKED`: a required upstream fact (e.g. exact praxis crate version) cannot be
  confirmed without user input.
* `BUILD_BROKEN`: not applicable at this ticket's scope (no code, no build step) —
  use `BLOCKED` instead if something prevents completion.

No partial state.
