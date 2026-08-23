# mfact Agent Operating Contract

This contract governs the repository unless a deeper `AGENTS.md` narrows a subtree. Live tree, ledger, manifests, checked proofs, and executed recipes outrank stale prose. Nested doctrine may tighten constraints but may not silently weaken evidence, authority, replay, or publication law.

## Prime directive

`mfact` is a mathematical manufacturing system. Do not hand-code manufactured outputs. Candidate producers—including models—may propose source declarations, templates, fixtures, tests, and hand-authored prose; they do not confer standing by directly editing emitted artifacts.

The correspondence is:

```text
ggen renders → Lean admits → mfact certifies → manifest/ledger records standing
A = μ(O*)
R = receipt(A)
```

Resolve repo/ref/base to an exact commit before work. Read applicable `AGENTS.md`, architecture/docs, `Justfile`, `.mfact/artifacts.toml`, manifests, gates, generators, CI, and release policy. Apply Chesterton's fence before removing a boundary. Preserve maximal reversible lawful options before irreversible selection.

## Evidence / standing

Use `UNKNOWN | PARTIAL_ALIVE | ALIVE | BLOCKED | BUILD_BROKEN | UNSUPPORTED` plus typed `REFUSED_*`; retain repository-specific formal states such as `STATED` and `PROVEN` only where a checked artifact defines them. `ALIVE` requires exact admitted execution. A written `proven` literal is not a proof; terminal prose is not standing; a receipt-shaped file is not a replay-verified receipt.

Track observed/admitted/executed/changed/verified/inferred/refused/blocked/unsupported separately. Never promote `STATED` to `PROVEN` without the repository's mechanical Lean/manifest guard.

## Canonical edit authority

Authority comes from `.mfact/artifacts.toml` and the live manufacturing graph, not path names or headers. Ledgered outputs are not direct edit surfaces. Change their declared source fragment/template/builder, re-render, and verify replay/regen identity. Intentionally unledgered research/demo areas remain ordinary code only while the live ledger/docs confirm they carry no certification standing.

If the source/template for a manufactured artifact is absent, refuse with the repository's typed missing-source/missing-template category rather than patching the output. If an unledgered object carries release standing, counts, hashes, audit status, or certification data, treat it as an orphan-standing refusal until ledgered or removed from the claim.

Dependency mutations must use the repository's package-manager/recipe path; do not manually edit dependency manifests when doctrine forbids it. Do not introduce custom Lean↔Python execution infrastructure or deprecated planning dependencies unless the task explicitly admits that change.

## Actuation

Separate `SELECT`, `CONSTRUCT`, `DO`. Raw input, planner/model output, generated code, proof text, and hooks have no ambient execution authority. Agents actuate through the repository's `just` recipes. Read-only cockpit/diagnostic recipes do not confer standing; manufacturing/certification recipes do. If a new consequential path is needed, add/admit a recipe first rather than making an ad-hoc shell path canonical.

Follow:

```text
parse → orient → resolve → materialize → read doctrine → inspect
→ admit/refuse → diagnose/repair → construct → actuate
→ receipt → replay → standing
```

## Proof/manufacturing guardrails

- A theorem may be reported `PROVEN` only when the live mechanical guard confirms the admitted declaration has no forbidden proof escape such as `sorryAx`.
- Regen/replay checks must cover tracked and newly introduced source/artifact inputs; untracked inputs that affect generated output are provenance failure, not a passing regen check.
- Correspondence claims must reference the actual extracted/generated declaration and abstraction binding, not a same-shaped handwritten surrogate.
- Certification must check current release/tag ancestry and manifest identity. Historical certified tags are immutable evidence, not the identity of every later release.
- New source fragments that feed manufactured outputs must be committed in the same coherent change before certification.

## Verification

Use the exact user acceptance command when supplied; otherwise use the live documented `just` recipe. Run the narrowest high-information recipe first, then render/build/audit/manifest/certify/regen/release gates as the affected claim requires. Preserve command, exit, diagnostics, and generated status. Never rerun an unchanged failure without a new hypothesis. CI supplements local execution; it does not replace it when local execution is available.

## GitHub / receipt

Never silently move the admitted base. Publish on a purpose branch with intentional commits and a draft PR; never force-push or merge unless explicitly requested. Final reports identify source edits, regenerated artifacts, recipes/commands and exits, certification result, any direct generated edit (normally `none`), repo/base/tree, branch/SHA/PR, replay path, standing, and falsifiers.