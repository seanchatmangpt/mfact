# Ticket 016 — Paper Restructure: The Standing-Manufacturing Graph

## Type

Paper / Prose Architecture

## Standing

DECLARED

## Objective

`paper/main.tex` currently argues "mfact manufactures procint." The doctrine has
advanced: MathProofOps is the category, mfact is the Lean/Lake manufacturing
apparatus, procint is the first manufactured vertical, praxis-graphlaw is the
executable law-state engine, rslab is the empirical-evidence rail, and Aeneas is
the implementation-correspondence rail. This session already landed prose-level
fixes (title, abstract, doctrine equation split into `A = μ_B(O*_B)` /
`R_B = receipt(A)`, a new §"From Public Ontology to Domain Standing", the status
algebra paragraph, Aeneas re-fencing, "standing at submission" paragraph). What
remains is structural: reorder and add sections so the paper's shape matches the
five-rail architecture, and open two placeholder sections whose prose ticket 020
fills once the rslab fragments (ticket 019) exist to cite.

## Non-Goals

This ticket must not:

* invent rslab or praxis-graphlaw benchmark numbers — the two new sections opened
  here (§praxis-graphlaw, §rslab) get only structural placeholders in this ticket;
  their prose is Ticket 020's job, gated on Ticket 019's fragments existing
* touch any ledgered fragment `.tex` file (`evaluation.tex`, `quadrature.tex`,
  `correspondence_status.tex`, `crown_jewel_status.tex`, `final_status.tex`,
  `availability.tex`, `publication_status.tex`, `replay_status.tex`,
  `release_macros.tex`, `conclusion.tex`) — these are ggen/builder-rendered and
  hand-editing them is `ARTIFACT_DRIFT_REFUSED`
* remove or break any existing `\ifreleasebuild ... \input{...} ... \fi` guard
* collapse the praxis/rslab (empirical evidence) rail with the Aeneas
  (implementation-correspondence proof) rail — they must stay textually distinct
* run before Ticket 015 is ALIVE (the paper should not restructure around a
  release whose tag doesn't certify its own manifest)

## Required Restructure

Target section order in `paper/main.tex` (renumber `\section`/`\subsection`
accordingly; keep all existing `\label{}` keys stable where the section's content
is preserved, since `paper/main.tex` is the only hand-authored `.tex` and its
`\ref`s are hand-maintained):

1. Introduction — standing gap, MathProofOps thesis, four bounded contributions
   (existing content, keep)
2. The Receipted Manufacturing Law — existing content, add a new
   `\paragraph{The Four Evidence Kinds.}` subsection distinguishing: Formal (Lean
   theorem, axiom audit), Operational (praxis-graphlaw benchmark/validation
   evidence via rslab), Correspondence (Aeneas extracted image ↔ procint semantics),
   Publication (generated paper fragment)
3. From Public Ontology to Domain Standing — existing (added this session); make
   the chain explicit in prose: ontology → ggen → Lean admission → praxis execution
   → rslab receipt → paper fragment
4. **NEW** Architecture: The Standing-Manufacturing Graph — a rails table (Formal /
   Process-law / Benchmark / Correspondence / Paper), each row: source, admission
   boundary, receipt. Placed before Related Work.
5. Related Work — existing, unchanged
6. The mfact Framework — existing, add one sentence: "mfact is not the whole
   system: it is the Lean/Lake standing apparatus inside a larger
   standing-manufacturing graph."
7. procint — retitle section from "procint: the Mathematical Canon" to "procint:
   Process Intelligence as Process Law"; content otherwise unchanged
8. The Manufacturing Run — existing, unchanged
9. **NEW placeholder** praxis-graphlaw: Executable Law-State Evaluation — one
   paragraph stub: "This section is completed under Ticket 020, once Ticket 019's
   rslab fragments exist to cite." No benchmark claims here.
10. **NEW placeholder** rslab: Empirical Evidence Rail — same stub pattern, plus
    the doctrine sentence verbatim (this line may ship now, it makes no numeric
    claim): "rslab is not a proof engine. rslab is an empirical evidence rail."
11. Use of Generative AI Tools — existing, unchanged
12. Implementation Correspondence with Aeneas — **promoted from Evaluation
    subsection to top-level section**; move the current §6.2 "D1 Correspondence
    Pilot" content here in full, including its `\input{correspondence_status}`
    call; keep `\label{sec:correspondence}` unless it's referenced elsewhere with a
    different expected meaning (grep `\ref{sec:correspondence}` first)
13. Evaluation — restructure into four labeled subsections: 13.1 Formal Standing
    Evaluation (existing `\input{evaluation}` + `\input{final_status}`), 13.2
    Standing Quadrature (existing, unchanged), 13.3 **NEW placeholder**
    praxis/rslab Benchmark Evidence (stub, filled by Ticket 019/020's
    `\input{rslab_*}` calls), 13.4 removed — correspondence content now lives in
    §12
14. Falsifier and Valid Objection Surface — existing, unchanged
15. Limitations and Standing — existing, unchanged (includes this session's new
    "Standing at submission" paragraph)
16. Availability — existing, unchanged
17. Conclusion — existing, unchanged

## Required Verification Commands

```bash
grep -n '\\section\|\\subsection' paper/main.tex
grep -n '\\ref{sec:correspondence}' paper/main.tex
just prose-lint
just paper-check
just regen-check
```

## Definition of Done

1. Section order matches the target list above.
2. §procint retitled; content unchanged.
3. New §Architecture: The Standing-Manufacturing Graph exists with the five-row
   rails table.
4. §Implementation Correspondence with Aeneas is a top-level section (not an
   Evaluation subsection); its `\input{correspondence_status}` call still resolves.
5. §praxis-graphlaw and §rslab exist as placeholder stubs only — no invented
   numbers, no invented capabilities.
6. The rslab doctrine sentence appears verbatim.
7. Every pre-existing `\ifreleasebuild` guard still wraps its original `\input`.
8. `just prose-lint` exits 0.
9. `just paper-check` exits 0 (latexmk builds `main.pdf`).
10. `just regen-check` is unaffected (main.tex is unledgered; no ledgered file
    touched).
11. No `\ref{}` left dangling (grep for LaTeX "undefined reference" warnings in
    the latexmk log).

## Terminal States

* `ALIVE`: all 11 DoD items pass.
* `BLOCKED`: Ticket 015 is not yet ALIVE, or a `\ref` depends on content this
  ticket must not move.
* `BUILD_BROKEN`: `just paper-check` or `just prose-lint` fails after the
  restructure (quote the failure).

No partial state.
