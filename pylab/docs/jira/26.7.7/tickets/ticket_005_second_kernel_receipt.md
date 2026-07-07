# Ticket: Second-Kernel Receipt via Lean4Lean

## Title
Independent second-kernel attestation of procint's admitted environment —
`pylab/src/math_factory_pylab/second_check.py` + MCP tool `lean4lean_check`

## Description
**Lean4Lean** (arXiv:2403.14064, Carneiro) is a complete, feature-parity Lean 4
typechecker written *in* Lean 4, closely mirroring the reference C++ kernel's
operations and order. Invocation is a CLI over a lake project's built `.olean` files:
`lake env lean4lean --fresh <Module>` — measured 20-50% slower than the C++ kernel
(their Figure 2: ~59 minutes for all of Mathlib single-threaded on a 12-core laptop,
vs ~44.5 minutes for the C++ path), so seconds-to-low-minutes for a project the size of
`procint/`. Its own construction found a real soundness bug in the reference kernel:
`cheapBetaReduce`'s loose-bound-variable check silently defaulted to `0` (the least
safe answer, enabling incorrect optimizations) on a `panic!`-and-continue overflow path
in `Expr.data`'s 20-bit field — found by working backward from a failed correctness
proof, not by fuzzing.

This is the one ticket in this batch with a legitimate path toward `release/gates.json`
— it produces a genuinely different, independently-computed fact about the same
admitted environment (re-typechecked by a second kernel implementation), which is
exactly the kind of receipt this repo's BLAKE3/genesis-folded discipline is built to
carry. It stays a pylab-tier research surface until a human decides to graduate it.

**Honest wording bound, carried into every downstream use of this ticket's output**:
Lean4Lean is written in Lean 4 and compiled by the Lean 4 toolchain, so it is a second
*kernel implementation*, not an independent *stack* — the paper itself points to
`trepplein` (Scala) and `nanoda_lib` (Rust) as the actually-independent-stack
verifiers. Any receipt or paper claim produced from this ticket must say "re-admitted
by a second, independent kernel implementation (Lean4Lean)," never "independently
verified" unscoped.

## Design

- Pin a `lean4lean` checkout (submodule or lake dependency) whose Lean toolchain
  version matches `procint/lean-toolchain` exactly — Lean4Lean shares the `Expr` type
  with the elaborator via import, so a version mismatch is a hard requirement, not a
  soft compatibility concern.
- `second_check.py`: `run_lean4lean(module: str) -> Attestation` shells out to
  `lake env lean4lean --fresh <module>` as a subprocess (same pattern pylab already
  uses for `lake_env_lean`), captures exit code, stderr, and wall-clock duration.
  `Attestation = {toolchain, lean4lean_rev, module, olean_blake3, exit_code, duration_s}`.
- Optional differential mode: also run `lean4checker` (the C++-kernel-path companion
  tool from the same paper) over the same oleans and diff pass/fail per declaration —
  any divergence between the two kernels on the same input is itself a reportable
  finding, per the paper's own methodology for finding the soundness bug.
- MCP tool `lean4lean_check(module: str)` — read-only, wraps `run_lean4lean`, returns
  the `Attestation` as JSON. Consistent with the existing `lake_build`/`lake_env_lean`
  MCP tools' read-only discipline.

## Acceptance Criteria
- `second_check.py` runs successfully against `procint`'s existing build, producing an
  `Attestation` with `exit_code == 0` for the current admitted environment (this is the
  expected/normal outcome — a failure here on an already-admitted environment would be
  a genuine finding worth escalating, not silently absorbed).
- Toolchain version match between `lean4lean` and `procint/lean-toolchain` is checked
  and refused (not silently skipped) if mismatched — a version-mismatched run produces
  a meaningless attestation and must say so loudly.
- MCP tool `lean4lean_check` added, read-only, no write path into `procint/ProcInt/**`
  or the ledger.
- A written note (in this ticket's PR, or `docs/`) states plainly that this attestation
  is pylab-tier and does **not** currently feed `release/gates.json` — that migration,
  if ever made, is a separate, core-repo, human-reviewed decision, explicitly out of
  this ticket's scope.

## Dependencies
None. Independent of Tickets 001-004; can be built any time.

## Verification Mechanism
1. `second_check.run_lean4lean("ProcInt")` (or the appropriate root module) exits 0
   against the current `procint` build, logged with toolchain/revision/duration.
2. MCP smoke test: `lean4lean_check` returns valid JSON matching the `Attestation`
   schema.
3. Toolchain-mismatch test: deliberately point at a `lean4lean` checkout pinned to a
   different Lean version, confirm the tool refuses with a clear error rather than
   producing a silently-meaningless pass/fail.
4. If differential mode is implemented: confirm `lean4checker` and `lean4lean` agree on
   the current admitted environment (expected outcome — divergence would be a
   stop-and-report event, not something this ticket resolves unilaterally).
