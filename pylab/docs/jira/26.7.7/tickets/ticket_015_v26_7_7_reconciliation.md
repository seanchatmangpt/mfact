# Ticket 015 — v26.7.7 Reconciliation and Re-Certification

## Type

Governance / Release Integrity

## Standing

DECLARED

## Objective

Ticket 013 (v26.7.7 release gap audit, 2026-07-07) found five BLOCKERs against the
disk state at that time. Since that audit, this session's Ticket 012 execution
(Agents 0-9) demoted the infinite-transition countermodel theorem to STATED,
created `scripts/countermodel_negative_controls.sh`, and wired the
`countermodel_not_promoted` gate into `release/gates.json` (now `true`). Part of
013's findings are therefore stale; part are still live. Ticket 015 re-verifies
013's findings against *current* disk truth — trusting neither the 013 audit nor
the 012 receipt at face value — closes what remains open, and re-cuts the certified
release tag as an explicit new certification cycle.

This ticket does not formalize new theorems, does not touch the paper, and does not
create the rslab rail. It closes the governance gap so that tickets 016-020 (paper
restructure, rslab rail) can proceed against a release whose tag actually points at
its manifest.

## Non-Goals

This ticket must not:

* edit `paper/main.tex` or any paper fragment
* create `rslab/` or any praxis-graphlaw evidence
* prove any new theorem or weaken any existing one
* promote any STATED declaration to PROVEN by assertion — only by admitted proof
* silently mutate the core release identity (`CORE_RELEASE_HASH`, `CORE_PROVEN`,
  `CORE_TOTAL_DECLS`) — any change to these values is an explicit new certification
  cycle with new manifest values, recorded in the receipt, never a silent edit

## Required Verification (current disk truth, run first — read-only)

```bash
# Re-verify each 013 finding against current HEAD before acting on it
grep -A2 'infinite_transition_countermodel_sound_not_bounded' \
  release/release-manifest.json
grep 'WFNET_INFINITE_TRANSITION_COUNTERMODEL' release/standing.env
test -f scripts/countermodel_negative_controls.sh && \
  bash scripts/countermodel_negative_controls.sh
grep -A6 '"gates"' release/gates.json 2>/dev/null || cat release/gates.json
grep -n 'aeneasDecl' research/verif/obligations.toml
git merge-base --is-ancestor \
  "$(git rev-parse v26.7.7-procint-certified)" HEAD && echo ANCESTOR || echo NOT_ANCESTOR
grep -c 'PROCINT_SEMANTIC_FIXTURES' release/standing.env
```

## Required Remediation (only for findings that verify as still-live)

1. **Countermodel promotion status** — if the read-only check above confirms
   `WFNET_INFINITE_TRANSITION_COUNTERMODEL=STATED`, the guard script exists, and it
   exits 0 with a refusal message, this finding is CLOSED (no action). If any of
   those three checks fails, treat as still-open and fix it: demote the TTL
   `procint:status` for the theorem's dependency lemmas to `stated`, re-render,
   re-audit.
2. **D1 correspondence binding** — if `aeneasDecl` in `research/verif/obligations.toml`
   (a ggen/build_verif.py-rendered file — do not hand-edit it) still reads `"TBD"`,
   locate its source in the verif TTL catalog and bind it to the real Aeneas-extracted
   declaration name from the `wasm4pm-compat` correspondence pipeline. Re-run
   `just verif-status` (or the equivalent recipe that regenerates
   `verif-status.generated.ttl` and `verif-receipt.json`) so the binding is derived,
   not hand-typed.
3. **standing.env dedup bug** — `justfile`'s `test` recipe strips prior
   `PROCINT_*`/`WFNET_*` keys with a `grep -v` pattern that uses a literal `|`
   instead of `grep -E`, so the alternation never matches and old blocks accumulate
   (6 duplicate blocks observed this session). Fix the recipe to either use
   `grep -vE '^PROCINT_|^WFNET_'` or run two separate `grep -v` passes, and confirm
   `release/standing.env` contains exactly one `PROCINT_SEMANTIC_FIXTURES=` line
   after the next `just test` run.
4. **Tag ancestry** — if `git merge-base --is-ancestor` reports NOT_ANCESTOR, the
   tag `v26.7.7-procint-certified` does not certify the current tree. After items
   1-3 are closed and the pipeline (`just render && just build && just audit &&
   just manifest && just certify && just regen-check`) passes clean, re-cut the tag
   at the new commit as an explicit new core certification cycle: record the new
   `foldHash`, proven/stated counts, and certified line in the ticket receipt. Per
   AGENTS.md core-release-identity law, this is a promotion into a new cycle, not a
   silent mutation of the old one.

## Required Verification Commands (post-remediation)

```bash
just render
just build
just audit
just manifest
just certify
just regen-check
just test
grep -c 'PROCINT_SEMANTIC_FIXTURES' release/standing.env   # expect 1
grep 'aeneasDecl' research/verif/obligations.toml           # expect not "TBD"
git merge-base --is-ancestor "$(git rev-parse v26.7.7-procint-certified)" HEAD
```

## Definition of Done

1. Every 013 finding has been re-verified against current disk state, not assumed.
2. Countermodel status confirmed STATED with guard present and refusing (or fixed
   if it was not).
3. D1 `aeneasDecl` binding is real, not `"TBD"`, and derived by the builder, not
   hand-typed.
4. `release/standing.env` contains no duplicate `PROCINT_*`/`WFNET_*` blocks.
5. `just regen-check` exits 0.
6. `just certify` exits 0 and all negative controls (certify, countermodel,
   quadrature, verif) pass.
7. The certified tag is an ancestor of HEAD, or has been re-cut as an explicit new
   cycle with receipted foldHash/counts.
8. No paper file touched.
9. No `rslab/` directory created.
10. Ticket receipt (`ticket_015_receipt.md`) records: which 013 findings were
    already closed by Ticket 012's session work, which required remediation here,
    exact commands run, before/after standing.env, before/after foldHash, and the
    certified line.

## Terminal States

* `ALIVE`: all 10 DoD items pass.
* `BLOCKED`: a finding requires a decision only the user can make (e.g. whether to
  re-cut the tag now or defer to the next release).
* `BUILD_BROKEN`: a remediation step causes a pipeline command to fail (quote the
  failure).

No partial state.
