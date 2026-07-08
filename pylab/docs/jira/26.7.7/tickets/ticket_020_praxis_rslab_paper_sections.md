# Ticket 020 — praxis-graphlaw and rslab Paper Sections

## Type

Paper / Prose

## Standing

DECLARED

## Objective

Fill the two placeholder sections Ticket 016 opened in `paper/main.tex`
(§praxis-graphlaw: Executable Law-State Evaluation, §rslab: Empirical Evidence
Rail) with real prose, now that Ticket 019's fragments exist to cite. This is the
final paper-prose ticket for the v26.7.7 redesign — after this ticket, the paper's
structure (016), rslab rail (017-019), and their prose (020) are all in place and
citable.

## Non-Goals

This ticket must not:

* hand-type any benchmark number in `main.tex` — every number belongs in a
  generated fragment (Ticket 019's `\input`s); prose may describe *what kind* of
  evidence exists, never the value itself
* claim "transaction-path admission control" as a shipped praxis feature — Ticket
  017's exploration found this phrase has no existing artifact in praxis; describe
  it as a design goal the SHACL/ShEx admission-gate and `bcinr_powl::admit`
  machinery is aimed at, if mentioned at all
* claim graphlaw benchmark evidence proves anything about mfact/procint
  performance — praxis and mfact are separate systems; rslab evidence is about
  praxis-graphlaw's own execution characteristics
* collapse §rslab and §Implementation Correspondence with Aeneas into one
  narrative — state explicitly that they are two distinct rails (empirical
  evidence vs. formal correspondence proof)
* run before both Ticket 016 (structure) and Ticket 019 (fragments) are ALIVE

## Required Prose Content

### §praxis-graphlaw: Executable Law-State Evaluation

Cover, in order:

1. What graphlaw is: a native RDF/N3/Datalog/SHACL/ShEx law-state engine (fork of
   `pbonte/roxi`), consumed by `ggen` through its `GraphEngine` seam
   (`GraphLawStore`).
2. RDF/TTL graph substrate — graphs as law state.
3. N3 + stratified Datalog materialization (`materialize`, `prove`, `solve`).
4. SHACL/ShEx validation as admission gates (`validate_shacl`, `validate_shex`),
   plus denial checking (`{ body } => false.`).
5. The typed refusal vocabulary at the ggen integration layer (`FM-LAW-001`
   through `FM-LAW-013`, e.g. `FM-LAW-011` denial violated, `FM-LAW-013` SHACL
   non-conformance) — this is graphlaw's own admission/refusal discipline, an
   independent instance of the same manufacturing-law shape as MathProofOps.
6. Why performance matters, framed honestly: admission gates sitting on a
   transaction path need to be fast; this is stated as the motivating design
   goal, not as an already-benchmarked claim about any specific latency target,
   unless Ticket 019's fragments provide a number to cite (in which case, cite the
   fragment, not a hand-typed figure).
7. Cite the praxis crate version (`praxis-graphlaw` v26.7.5 at time of writing)
   and its roxi-fork provenance honestly — this is derivative infrastructure, not
   a from-scratch engine, and the paper should say so.

### §rslab: Empirical Evidence Rail

Cover, in order:

1. The four-line doctrine (already landed verbatim in Ticket 016's placeholder;
   keep it, build the surrounding paragraphs around it): "praxis executes. rslab
   measures and receipts. mfact admits formal standing. paper renders
   admitted/receipted claims."
2. The O → O* → A mapping: praxis raw output is unadmitted observation; a
   schema-validated, hash-verified, receipted result is admitted; a fragment
   rendered from that receipt is the artifact with standing.
3. Experiment manifests (`rslab/manifest.toml`) and the receipt schema
   (mirrors `verif-receipt.json`'s shape: builder, hashes, evidence booleans, no
   wall-clock).
4. Fragment generation and its fail-closed behavior (Ticket 019: missing receipt
   → refused render, not a silent placeholder).
5. Readiness contracts — what rslab currently has evidence for
   (throughput/latency of specific graphlaw operations) versus what it does not
   (no profiling data; explicitly say why, citing Ticket 017's finding that no
   profiler tooling currently exists in the praxis workspace).
6. Distinguish rslab from Aeneas explicitly: "Where the correspondence rail
   (Section~\ref{sec:correspondence}) proves a bounded relationship between an
   implementation and admitted semantics, the rslab rail records what a system
   measurably does, without claiming that measurement constitutes proof of
   anything beyond itself."

## Required Verification Commands

```bash
grep -n '[0-9]\+\.\?[0-9]*\s*\(ns\|µs\|ms\)\b' paper/main.tex | \
  grep -v '\\input' || echo "no hand-typed timing numbers in main.tex (expected)"
grep -n 'transaction-path admission control' paper/main.tex
grep -n 'roxi' paper/main.tex
just prose-lint
just paper-check
just regen-check
just arxiv-package
```

## Definition of Done

1. Both placeholder sections replaced with full prose per the outlines above.
2. No hand-typed benchmark number appears in `main.tex` (all numbers reached via
   `\input{rslab_*}`).
3. "Transaction-path admission control," if used at all, is explicitly framed as
   a design goal, not a shipped/benchmarked feature.
4. graphlaw's roxi-fork provenance and version are stated honestly.
5. §rslab and §Implementation Correspondence with Aeneas are textually
   distinguished, with the exact sentence (or an equivalent carrying the same
   distinction) required above.
6. `just prose-lint` exits 0.
7. `just paper-check` exits 0.
8. `just regen-check` exits 0.
9. `just arxiv-package` succeeds and the resulting tar includes the rslab
   fragments (verify via `tar -tf` on the produced archive).
10. Full read-through: no sentence in either new section asserts something the
    rslab receipt (Ticket 018) does not actually contain.

## Terminal States

* `ALIVE`: all 10 DoD items pass.
* `BLOCKED`: Ticket 016 or Ticket 019 is not yet ALIVE.
* `BUILD_BROKEN`: `just paper-check`, `just prose-lint`, or `just arxiv-package`
  fails after the prose lands (quote the failure).

No partial state.
