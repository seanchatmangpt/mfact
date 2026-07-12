# Analysis — /Users/sac/praxis Exploration

## 1. Directory Existence and Structure
The directory `/Users/sac/praxis` exists and is a valid Rust Cargo workspace.
- **Root Files/Folders**: Contains standard files such as `Cargo.toml`, `Cargo.lock`, `justfile`, `rust-toolchain.toml`, `src/`, `crates/`, `tests/`, `benches/`.
- **Workspace Members**: The workspace defines 12 member crates:
  1. `crates/agent8`
  2. `crates/ggen`
  3. `crates/chatman-common`
  4. `crates/praxis-core`
  5. `crates/praxis-proposer`
  6. `crates/praxis-retrofit`
  7. `crates/rust-fable-testbed`
  8. `crates/powl2-decompose`
  9. `crates/pddl-index`
  10. `crates/praxis-synthesis`
  11. `crates/praxis-lean`
  12. `crates/praxis-graphlaw`

---

## 2. Git Commit and Toolchain Details
- **Git Commit Hash**: `c745c14f646870eb148f3df090f7a8026801cef4` (checked via `git rev-parse HEAD`).
- **Toolchain Details** (defined in `/Users/sac/praxis/rust-toolchain.toml`):
  - **Channel**: Pinned stable/nightly: `nightly-2026-04-15`
  - **Components**: `["rustfmt", "clippy", "llvm-tools-preview"]`
  - **Profile**: `minimal`

---

## 3. Compilation, Test, and Benchmark Commands
Three main benchmarks are defined under `[[bench]]` targets in `/Users/sac/praxis/Cargo.toml`:
1. `bench_main` (using Criterion)
2. `receipt_validate` (using Criterion)
3. `blue_river_dam` (using Divan)

### Working Commands (Default Features Only)
- **Compile Workspace**:
  ```bash
  cargo check --workspace
  ```
- **Compile & Check Integration Tests**:
  ```bash
  cargo check --workspace --tests
  ```
- **Compile & Check Benchmarks**:
  ```bash
  cargo check --bench bench_main --bench receipt_validate --bench blue_river_dam
  ```
- **Run Tests**:
  ```bash
  cargo test --workspace
  ```
- **Run Criterion Benchmarks**:
  ```bash
  cargo bench --bench bench_main
  cargo bench --bench receipt_validate
  ```
- **Run Divan Benchmark**:
  ```bash
  cargo bench --bench blue_river_dam
  ```

### Justfile Defined Target Commands (Fails on `all-features` Compilation)
The `justfile` in `/Users/sac/praxis` defines the following shortcut recipes:
- `build`: `cargo build` (defaults to default features)
- `check`: `cargo check --workspace --all-features` (compilation fails)
- `test`: `cargo test --workspace --all-features` (compilation fails)
- `clippy`: `cargo clippy --all-targets --all-features -- -D warnings` (compilation fails)
- `verify-all`: runs `check test clippy doctor` sequentially (compilation fails)

---

## 4. Issues, Caveats, and Readiness
- **Compilation Failure on `--all-features`**:
  Executing compilation commands with `--all-features` (or any features enabling `lsp-max`, `andon`, or `mcp`) fails due to a dependency version mismatch on the registry dependency `affidavit` (v26.6.22):
  ```
  error[E0599]: no method named `id` found for reference `&wasm4pm_compat::petri::Transition` in the current scope
     --> /Users/sac/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/affidavit-26.6.22/src/model_mining.rs:103:34
      |
  103 |     transitions.sort_by(|a, b| a.id().cmp(b.id()));
      |                                  ^^ field, not a method
  ```
  This occurs because `Cargo.toml` patches `wasm4pm-compat` to the local path `../wasm4pm-compat` (`/Users/sac/wasm4pm-compat`), which contains an updated API where `Transition::id` is a field or requires `TransitionExt` trait scope. However, `affidavit` (v26.6.22) is compiled against this patched local `wasm4pm-compat` and expects the older API method `id()`.
- **Default Features Readiness**:
  The workspace compiles and passes checking completely under the **default features** configuration. We verified that:
  1. `cargo check --workspace` completes successfully in ~59 seconds.
  2. `cargo check --workspace --tests` completes successfully in ~1m 45s.
  3. `cargo check --bench bench_main --bench receipt_validate --bench blue_river_dam` completes successfully in ~31 seconds.
- **Readiness Verdict**:
  - Running benchmarks and tests **under default features is ready to run**.
  - Running benchmarks and tests **with `--all-features` is blocked** until the `affidavit` crate / `wasm4pm-compat` API conflict is resolved.
