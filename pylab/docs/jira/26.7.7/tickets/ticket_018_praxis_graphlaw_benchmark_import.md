# Ticket 018 — praxis-graphlaw Benchmark Import

## Type

Empirical Evidence Collection

## Standing

DECLARED

## Objective

Run the benchmark and test evidence enumerated in Ticket 017's
`benchmark_plan.md` against the real `/Users/sac/praxis` workspace, and import
the raw results into `rslab/experiments/praxis_graphlaw/raw/` with a receipt.
This ticket produces the first real `O*` (admitted observation) for the rslab
rail: praxis's raw output is `O`; hashed, schema-validated, receipted output is
`O*`.

## Non-Goals

This ticket must not:

* invent, estimate, round, or "typical-case" any number — every value in the
  receipt must trace to a raw command's actual stdout/stderr capture on this run
* run or claim any profiling/flamegraph evidence (confirmed not to exist in
  praxis's tooling by Ticket 017's exploration)
* modify anything under `/Users/sac/praxis` — this is a read/run-only import
* modify `paper/main.tex` or any paper fragment
* claim `PROVEN` or `STATED` status for imported evidence — empirical evidence
  from this rail uses `EXTRACTED` (existing ladder token) per Ticket 017's
  vocabulary decision
* run before Ticket 017 is ALIVE (the schemas and plan must exist first)

## Required Commands (from `/Users/sac/praxis`, captured verbatim)

```bash
cd /Users/sac/praxis
cargo bench -p praxis-graphlaw 2>&1 | tee /tmp/rslab_bench_graphlaw.txt
cargo bench 2>&1 | tee /tmp/rslab_bench_root.txt
cargo test -p praxis-graphlaw 2>&1 | tee /tmp/rslab_test_graphlaw.txt
cargo test -p ggen --test graphlaw_e2e 2>&1 | tee /tmp/rslab_test_e2e.txt
rustc --version
cat rust-toolchain.toml
uname -a
```

## Required Artifacts

```text
mfact/rslab/experiments/praxis_graphlaw/raw/bench_graphlaw.txt
mfact/rslab/experiments/praxis_graphlaw/raw/bench_root.txt
mfact/rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt
mfact/rslab/experiments/praxis_graphlaw/raw/test_e2e.txt
mfact/rslab/experiments/praxis_graphlaw/raw/toolchain_context.txt
mfact/rslab/experiments/praxis_graphlaw/raw/command_log.txt
mfact/rslab/receipts/praxis_graphlaw_benchmark_receipt.toml
```

### Receipt schema (mirrors `release/verif-receipt.json`'s shape, TOML form)

Required fields, validated against Ticket 017's `benchmark_result.schema.json`:

* `builder` (this ticket's identifier)
* `experiment_id = "praxis_graphlaw"`
* `praxis_commit` (git rev-parse HEAD of `/Users/sac/praxis` at capture time)
* `command_log_path`, `command_log_hash` (b3sum)
* per raw file: `path`, `hash` (b3sum) — four raw output files plus toolchain
  context, five hash entries total
* `toolchain` — `{rustc_version, toolchain_pin: "nightly-2026-04-15", os}`
* `evidence` — `{declared: true, extracted: true}` (no `proven`/`stated` — this
  is empirical, not formal, evidence)
* explicit `caveats` array carrying forward Ticket 017's two caveats (mixed
  harnesses; no profiler tooling) plus any new caveat discovered while running
  (e.g. a bench that failed to compile, a flaky test)
* no wall-clock timestamp field in the receipt body (mirrors
  `verif-receipt.json`'s determinism convention — the receipt is about content,
  not when it ran; capture time can live in the raw command log instead)

## Required Verification Commands

```bash
python3 -c "
import json, tomllib
schema = json.load(open('rslab/schemas/benchmark_result.schema.json'))
receipt = tomllib.load(open('rslab/receipts/praxis_graphlaw_benchmark_receipt.toml', 'rb'))
# validate required fields present (jsonschema or manual check)
"
b3sum rslab/experiments/praxis_graphlaw/raw/*.txt
# compare each printed hash against the receipt's recorded hash for that path
grep -c 'FAILED\|panicked' rslab/experiments/praxis_graphlaw/raw/test_graphlaw.txt || true
```

## Definition of Done

1. All four `cargo bench`/`cargo test` commands from the plan were run against
   the real `/Users/sac/praxis` workspace (not simulated, not copied from the
   pre-existing `docs/releases/v26.7.6/` results).
2. Raw output files exist for each command, byte-for-byte what the command
   produced (no hand-editing of captured output).
3. `command_log.txt` records the exact commands, in order, with exit codes.
4. `toolchain_context.txt` records rustc version, toolchain pin, and OS.
5. The receipt validates against Ticket 017's `benchmark_result.schema.json`.
6. Every hash in the receipt matches the current on-disk hash of its raw file
   (`b3sum` recheck).
7. If any bench or test failed to run (compile error, missing dependency,
   flaky failure), that is recorded as a caveat in the receipt, not silently
   dropped or worked around.
8. No number from this run appears in `paper/main.tex` or any paper fragment —
   that wiring is Ticket 019/020's job.
9. `/Users/sac/praxis` working tree is unmodified by this ticket (verify with
   `git -C /Users/sac/praxis status --short` before and after).

## Terminal States

* `ALIVE`: all 9 DoD items pass.
* `BLOCKED`: the praxis workspace does not build/bench in its current state
  (name which command failed and why, without attempting to fix praxis itself —
  that repo is out of this ticket's scope).
* `BUILD_BROKEN`: the receipt cannot be constructed to validate against the
  schema (quote the validation failure).

No partial state.
