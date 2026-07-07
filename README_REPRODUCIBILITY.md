# mfact / procint — Reproducibility Guide

mfact/procint is a Lean 4 mathematical-manufacturing release: the Lean source
(proofs, definitions, fixtures) is hand-authored with LLM assistance and
kernel-verified by the Lean 4 typechecker; `ggen` assembles the release's
generated files (manifests, cross-references) from a declaration catalog
mined out of the checked source, so nothing in the release is asserted-in —
every claim traces back to a kernel-checked term or a computed hash.

## Toolchain

| Component | Version / pin |
|---|---|
| Lean 4 | `v4.31.0` (see `lean-toolchain` at repo root, `mfact/`, `procint/`) |
| Lake | `5.0.0` |
| Mathlib | commit `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` (tag `v4.31.0`), pinned in `procint/lakefile.toml` |
| CSLib | commit `1dbda5335e3fc06c414b84ca885a35d4c6d4ab7c`, pinned in `procint/lakefile.toml` (`git = "https://github.com/leanprover/cslib.git"`) |

The `procint` package depends on `mfact` via a local path require
(`[[require]] name = "mfact" path = "../mfact"` in `procint/lakefile.toml`),
so `mfact` must build first.

Lean/Lake are invoked in this repo via the absolute elan shim
(`/Users/sac/.elan/bin/lake`), kept off `$PATH` by design — see `justfile`.

## Build

```sh
cd procint && lake build
cd mfact && lake build
```

(Equivalently, from the repo root: `just build`, which builds `procint`
first, then `mfact` including its `AxiomAudit` and `mfact` CLI targets, in
that dependency order.)

## Axiom audit

```sh
lake build AxiomAudit
```

Run in both packages (`mfact/lakefile.toml` and `procint/lakefile.toml` each
declare an `AxiomAudit` lean_lib target). From the repo root, `just audit`
runs the `procint` audit.

## Fixtures

```sh
cd procint && lake build ProcInt.Fixtures.Positive ProcInt.Fixtures.Negative
```

Source at `procint/ProcInt/Fixtures/Positive.lean` and
`procint/ProcInt/Fixtures/Negative.lean`.

## Certification

```sh
cd mfact && ./.lake/build/bin/mfact certify release/release-manifest.json release/gates.json
```

Note: `release/release-manifest.json` and `release/gates.json` are checked
in at the repo root's `release/` directory, not under `mfact/release/` — run
the command from the repo root, or adjust the paths relative to your cwd
(the CLI itself takes `mfact certify <manifest> <gates>` with no third
argument, per `mfact/Mfact/Cli.lean`).

Expected output: exit code `0`, with a line on stderr of the form:

```
certified: v26.7.7 (proven <N>/<M>, objection type uninhabited)
```

(`gates.json` must have all four gates — `sorryFree`, `axiomsClean`,
`fixturesPass`, `evidenceComplete` — set to `true`; any `false` gate makes
`mfact certify` exit `1` with a `gate failure: ...` message instead.)

## Where to find evidence

- `release/release-manifest.json` — the release's declaration/artifact
  manifest (parsed and validated by `mfact certify`/`mfact manifest`).
- `release/gates.json` — the four boolean gates checked by `mfact certify`.
- `release/certify.log` — captured output of the last certify run.
- `release/standing.env` — machine-checkable standing report (computed, not
  asserted): toolchain/build/audit/fixture pass flags and the type-inventory
  hash for the last certified release.
- `release/standing.json` — as of this writing this file is not yet present
  in `release/` (only `standing.env` is); if you regenerate the release and
  a `standing.json` appears, treat it as the JSON counterpart of
  `standing.env`.
- `STANDING.md` — repo-root narrative standing document (owned by a
  different lane; not modified as part of this reproducibility pass).

## Regenerating the release manifest

`release/standing.env` records the regeneration command used to produce the
current `release/`:

```
python3 <scratchpad>/build_manifest.py && mfact certify release-manifest.json gates.json
```

As of this writing there is no `scripts/build_manifest.py` in this repo —
the manifest builder was last run from a scratchpad path. See `release/` for
the last-generated manifest; the builder script is being relocated into
`scripts/` as part of this release.

## Paper

```sh
cd paper && latexmk -pdf main.tex
```
