# mfact / procint

A receipted mathematical manufacturing pipeline for process intelligence:
**ggen** projects a Lean 4 declaration catalog, **Lean** admits it under
the pinned toolchain, and **mfact** certifies the result. Nothing here is
asserted in prose — every standing claim (proven/stated counts, gate
results, fixture status) is computed from a build, an axiom audit, or a
git commit, never hand-typed. This is the code artifact behind the paper
*Receipted Mathematical Manufacturing: A Lean 4 Pipeline for Process
Intelligence*.

## Quickstart

```sh
git clone <this repo> && cd mfact
just install    # reports which required tools (elan, ggen, latexmk, b3sum) are present
just doctor     # health check: toolchain pins, pack sources, release gates
just check      # full admission sweep: regen-check, build, test, paper
```

`just install` only reports tool presence — it never force-installs
anything. If `ggen` is missing, it's built from a sibling `praxis` checkout
(`just install-ggen` there) or from `crates/ggen` directly.

## What's here

- **`packs/`** — the ontology fragments and Tera templates ggen renders
  from: `lean-math-pack` (the `procint` declaration catalog), `quadrature-pack`
  (the Standing Quadrature cross-product), `post-release-pack` (the
  publication packet). This is the actual math *source* — everything under
  `procint/ProcInt/**/*.lean` is rendered from it, never hand-edited.
- **`procint/`** — the rendered Lean 4 package (process-intelligence
  formalization: event logs, process models, conformance checking, Petri
  nets, OCEL) plus its axiom audit and correctness-ladder fixtures.
- **`paper/`** — the LaTeX paper. Standing-derived numbers are rendered
  fragments (`\input`), never hand-typed (`just prose-lint` enforces this).
- **`release/`** — the manifest, gates, and standing artifacts that are the
  actual authority for any claim about this project's state.
- **`.mfact/artifacts.toml`** — the artifact ledger. Authority comes from
  here, not from file paths or headers: every generated file is either
  ledgered (rendered from a declared source, re-render-and-diff verified by
  `just regen-check`) or it doesn't get to make a standing claim.

## Where to look next

- **`AGENTS.md`** — the doctrine: edit surfaces, refusal vocabulary, the
  agent actuation constitution. Read this before changing anything.
- **`STANDING.md`** — the current, computed standing report.
- **`README_REPRODUCIBILITY.md`** — full from-scratch reproduction steps.
- **`just --list`** — every recipe, grouped (`setup`, `manufacture`,
  `cockpit`, `paper`, `release`, `demo`) with a one-line description.
  Start with the `cockpit` group (`just status`, `just next`, `just doctor`)
  for read-only diagnostics that never touch the tree.
