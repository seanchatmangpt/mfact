# Benchmark Plan: praxis-graphlaw Evaluation

This document outlines the verified-runnable benchmark and test suites for `praxis-graphlaw`.

## 1. Benchmark Execution Plan

### 1.1 Crate-Level Benchmarks
Run the benchmark suite defined within `praxis-graphlaw`:
```bash
cargo bench -p praxis-graphlaw
```
This runs the following four suites using the corresponding harnesses:
1. **`bench`** (Harness: `bencher`): Measures ImaRS window add/update throughput.
2. **`hierarchies`** (Harness: `bencher`): Measures N3 forward-chaining materialization at depth 1,000 and 10,000.
3. **`dialects`** (Harness: `bencher`): Measures SHACL, ShEx, N3, and Datalog throughput evaluated at 100, 1,000, and 5,000 focus nodes.
4. **`blue_river_dam`** (Harness: `divan`): Measures `TripleStore::materialize()` incremental delta performance.

### 1.2 Root-Level Benchmarks
Run root-level benchmarks within the workspace:
```bash
cargo bench
```
This executes:
1. **`receipt_validate`** (Harness: `criterion`): Validates receipts under a <5 ms latency target for ~100 records.
2. **`bench_main`** (Harness: `criterion`): Measures core pipeline throughput.
3. **`blue_river_dam`** (Harness: `divan`): Evaluates control-layer surfaces including standing transitions, PDDL grounding, POWL scheduler, and receipt chain verification.

## 2. Test Verification Plan

### 2.1 Crate-Level Conformance Tests
Execute the conformance, stress, and fuzz suites to verify functional correctness:
```bash
cargo test -p praxis-graphlaw
```
*Note: Do not hardcode past test counts (e.g., 380 passed); the exact results must be dynamically captured at runtime.*

### 2.2 End-to-End Admission Tests
Run end-to-end integration tests within the generation pipeline:
```bash
cargo test -p ggen --test graphlaw_e2e
```
This verifies 5 specific cases covering admission, refusal, and determinism check gates.

## 3. Toolchain & Environment Specifications

- **Toolchain Pin**: `nightly-2026-04-15` (specified in `/Users/sac/praxis/rust-toolchain.toml`)
- **Captured Properties**: `rustc` version details, OS description (`uname -a`).

## 4. Caveats & Architectural Clarifications

1. **Harness Diversity**: The workspace uses multiple distinct benchmark frameworks (`bencher`, `divan`, `criterion`) simultaneously; comparison of raw performance metrics across these harnesses is not directly supported.
2. **No Profiling/Flamegraph Tooling**: As of this exploration, no profiling or flamegraph tooling exists in the `/Users/sac/praxis` workspace. The `profiler_result.schema.json` is provided for future extensions and is currently unpopulated.
3. **Terminology on Admission Control**: "Transaction-path admission control" is not an existing named class or interface inside the `praxis` codebase. The nearest structural representations are SHACL/ShEx admission gates and the POWL admission context (`bcinr_powl::admit::{admit, AdmissionContext}`). Any paper language referring to "transaction-path admission control" must frame it as a future design objective rather than an implemented feature.
