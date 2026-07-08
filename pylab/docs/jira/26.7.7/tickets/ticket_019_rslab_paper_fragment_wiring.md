# Ticket 019 — rslab Normalization and Paper Fragment Wiring

## Type

Pipeline / Release Integration

## Standing

DECLARED

## Objective

Turn Ticket 018's receipted raw evidence into rendered `.tex` paper fragments,
following the exact governance pattern every other paper fragment in this repo
already uses: source → builder script → generated artifact → ledger entry →
release-gate wiring → `\ifreleasebuild` guard in `main.tex`. This is the ticket
that makes rslab evidence citable by the paper without violating the ledger law
(`.mfact/artifacts.toml` is the sole authority; a generated `.tex` file hand-edited
after this point is `ARTIFACT_DRIFT_REFUSED`).

## Non-Goals

This ticket must not:

* invent numbers not present in Ticket 018's receipt
* render a "profiles" fragment with real profiling data — no profiler evidence
  exists (Ticket 017 finding); the profiles fragment must render an explicit
  absence notice, not be silently omitted or filled with placeholder numbers
* skip the ledger entry step because rslab is a "new" surface — new surfaces still
  follow the ledger law once they produce artifacts with standing
* write directly into `procint/**` or any existing `packs/*/templates/*` file
  without checking whether a new `rslab-pack` or an extension of
  `quadrature-pack` is the better fit (decide and document the choice)
* run before Ticket 018 is ALIVE

## Required Artifacts

```text
mfact/rslab/scripts/collect_praxis_graphlaw.py
mfact/rslab/scripts/render_paper_fragments.py
mfact/rslab/experiments/praxis_graphlaw/processed/results.json
mfact/rslab/paper_fragments/rslab_praxis_graphlaw_summary.tex
mfact/rslab/paper_fragments/rslab_praxis_graphlaw_benchmarks.tex
mfact/rslab/paper_fragments/rslab_praxis_graphlaw_profiles.tex
mfact/rslab/paper_fragments/rslab_readiness.tex
```

### `collect_praxis_graphlaw.py`

* input: `rslab/receipts/praxis_graphlaw_benchmark_receipt.toml` +
  `rslab/experiments/praxis_graphlaw/raw/*`
* validates the receipt against `rslab/schemas/benchmark_result.schema.json`
* re-verifies every hash in the receipt against the raw files on disk; refuses
  (non-zero exit, named refusal string) on any mismatch
* emits `processed/results.json` — parsed, structured numbers extracted from the
  raw bench/test output (this is where "930 µs" style figures first become
  machine-readable; they must be parsed from the actual captured raw text, not
  retyped by hand)
* deterministic: same receipt + raw files in → same `results.json` out (no
  wall-clock, no random ordering)

### `render_paper_fragments.py`

* input: `processed/results.json`
* output: the four `.tex` fragments listed above
* `rslab_praxis_graphlaw_summary.tex` — one-paragraph prose summary + a small
  table of headline metrics, generated (no hand-typed numbers)
* `rslab_praxis_graphlaw_benchmarks.tex` — full benchmark results table (all
  suites from Ticket 018)
* `rslab_praxis_graphlaw_profiles.tex` — renders exactly one sentence: profiling
  evidence was not collected because no profiler tooling exists in the praxis
  workspace as of this release (cites Ticket 017's caveat) — this is itself a
  receipted claim (absence is asserted from the receipt's caveats field, not from
  silence)
* `rslab_readiness.tex` — a short statement of what evidence exists vs. what
  would be needed for a stronger claim (e.g. "throughput measured; latency
  percentiles not yet collected; profiling not yet available")
* fails closed: if `results.json` or the receipt is missing/invalid, the script
  exits non-zero with a named refusal (propose `RSLAB_EVIDENCE_MISSING`) rather
  than emitting empty or placeholder `.tex` files

### Release wiring

1. **Ledger**: add entries for the four fragments and the receipt to
   `.mfact/artifacts.toml` via `scripts/build_ledger.py`'s declared-builder-artifact
   list (same mechanism as the existing 8 builder entries — e.g. `evaluation.tex`).
   Producer = `rslab/scripts/render_paper_fragments.py`; sources = the receipt +
   `processed/results.json`.
2. **just recipe**: add `rslab-fragments` to `justfile` (actuation constitution:
   a new actuation path needs a recipe before use) that runs
   `collect_praxis_graphlaw.py` then `render_paper_fragments.py`.
3. **arxiv-package**: add the four fragment paths to the tar list in
   `justfile`'s `arxiv-package` recipe (currently an explicit list of 10 `.tex`
   files — this makes 14).
4. **main.tex wiring**: in the §13.3 placeholder from Ticket 016, replace the stub
   with the four fragments each wrapped in the same
   `\ifreleasebuild \input{...} \else \InputIfFileExists{...}{}{...} \fi` pattern
   every other fragment uses.
5. **regen-check**: confirm the new ledgered paths are covered by `just
   regen-check`'s drift diff (they will be, once in `.mfact/artifacts.toml`, since
   that recipe diffs every ledgered path).

## Required Verification Commands

```bash
python3 rslab/scripts/collect_praxis_graphlaw.py
python3 rslab/scripts/render_paper_fragments.py
just rslab-fragments   # must reproduce byte-identical output to the two commands above
diff <(just rslab-fragments >/dev/null; cat rslab/paper_fragments/rslab_praxis_graphlaw_summary.tex) \
     rslab/paper_fragments/rslab_praxis_graphlaw_summary.tex   # idempotence check
just regen-check
just paper-check
mv rslab/receipts/praxis_graphlaw_benchmark_receipt.toml /tmp/moved_receipt.toml
python3 rslab/scripts/render_paper_fragments.py; echo "exit=$?"   # must be non-zero
mv /tmp/moved_receipt.toml rslab/receipts/praxis_graphlaw_benchmark_receipt.toml
```

## Definition of Done

1. Both scripts exist and run end to end against Ticket 018's receipt.
2. `results.json` values trace to the raw captured output (spot-check at least
   three numbers against the raw `.txt` files).
3. All four fragments render, including the profiles fragment's explicit-absence
   sentence.
4. Re-running the pipeline twice produces byte-identical fragments (determinism).
5. `.mfact/artifacts.toml` has ledger entries for the receipt and all four
   fragments.
6. `just rslab-fragments` recipe exists and is documented in the justfile's recipe
   comment.
7. `arxiv-package`'s tar list includes the four new fragments.
8. `main.tex`'s §13.3 placeholder is replaced with the four guarded `\input`
   calls.
9. `just regen-check` exits 0 with the new paths included in its ledgered-path
   sweep.
10. `just paper-check` exits 0.
11. Deleting the receipt and re-running the render script produces a non-zero
    exit with the `RSLAB_EVIDENCE_MISSING` refusal (or equivalent named refusal),
    not an empty/placeholder fragment.
12. `RSLAB_EVIDENCE_MISSING` (or the chosen refusal name) is proposed to be added
    to AGENTS.md's typed refusal vocabulary — flagged in the receipt as a doctrine
    edit needing separate user approval, not silently added.

## Terminal States

* `ALIVE`: all 12 DoD items pass.
* `BLOCKED`: Ticket 018 is not ALIVE, or the choice between a new `rslab-pack`
  and extending `quadrature-pack` needs a user decision.
* `BUILD_BROKEN`: any of the verification commands fails after implementation
  (quote the failure).

No partial state.
