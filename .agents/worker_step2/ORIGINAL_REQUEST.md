## 2026-07-07T17:55:42Z
You are a worker agent. Your working directory is /Users/sac/mfact/.agents/worker_step2.
Your task is to implement the Step 2: Ticket 016 Paper Restructure & Ticket 017 rslab Skeleton requirements:

1. Restructure `paper/main.tex` to implement the 17-section structure detailed in Ticket 016:
   - Add a new `\paragraph{The Four Evidence Kinds.}` inside Section 2 (The Receipted Manufacturing Law) after line 249:
     ```latex
     \paragraph{The Four Evidence Kinds.} We distinguish four classes of evidence within the manufacturing graph: (1) Formal evidence (Lean theorems and axiom audits); (2) Operational evidence (praxis-graphlaw benchmark and execution validation via rslab); (3) Correspondence evidence (Aeneas-extracted image to procint semantic equivalence proofs); and (4) Publication evidence (generated paper fragments and manifests).
     ```
   - In Section 6 (The mfact Framework), append at the end of the intro paragraph (right before `\paragraph{Candidates and refusals.}`):
     ```latex
     mfact is not the whole system: it is the Lean/Lake standing apparatus inside a larger standing-manufacturing graph.
     ```
   - Insert new Section 4: `Architecture: The Standing-Manufacturing Graph` before `Related Work` with the `tab:rails` table mapping each rail (Formal / Process-law / Benchmark / Correspondence / Paper) to source, admission boundary, and receipt form.
   - Retitle Section 7 from `procint: the Mathematical Canon` to `procint: Process Intelligence as Process Law` (content otherwise unchanged).
   - Insert Section 9 placeholder `praxis-graphlaw: Executable Law-State Evaluation` and Section 10 placeholder `rslab: Empirical Evidence Rail` stubs after `The Manufacturing Run` (Section 8) and before `Use of Generative AI Tools`. Note: Section 10 must contain the doctrine sentence verbatim: "rslab is not a proof engine. rslab is an empirical evidence rail."
   - Promote Aeneas section (`\subsection{D1 Correspondence Pilot}`) to top-level Section 12 `\section{Implementation Correspondence with Aeneas}`, maintaining `\label{sec:correspondence}`. Move the entire block text (including `\input{correspondence_status}`) there.
   - Restructure `\section{Evaluation}` (Section 13) into subsections:
     - 13.1 `Formal Standing Evaluation` (existing intro + `\input{evaluation}` + `\input{final_status}`)
     - 13.2 `Standing Quadrature` (existing, unchanged)
     - 13.3 `praxis/rslab Benchmark Evidence` (new placeholder stub)
   - Ensure all `\ifreleasebuild` guards are preserved and LaTeX builds cleanly without undefined references.
   - Verify the restructuring with `just paper-check` and `just prose-lint`.

2. Create the greenfield `rslab` directory structure under `/Users/sac/mfact/rslab/` with the exact files required by Ticket 017:
   - `rslab/README.md`: Contains the verbatim 4-line doctrine block, the O/O* /A mapping, governance details (inputs are unledgered, receipts/fragments are ledgered), and a pointer to status-ladder pattern (`DECLARED < EXTRACTED < STATED < PROVEN`).
   - `rslab/manifest.toml`: Declares `praxis_graphlaw` experiment with `status = "declared"`, plan pointing to `experiments/praxis_graphlaw/benchmark_plan.md`, and no results fields populated.
   - `rslab/schemas/benchmark_result.schema.json`: Valid JSON Schema validating the required benchmark fields (`builder`, `experiment_id`, `command`, `raw_output_path`, `raw_output_hash`, `toolchain`, `evidence`), with no `proven` or `stated` booleans.
   - `rslab/schemas/profiler_result.schema.json`: Valid JSON Schema same as above plus `profiler_tool`, with a top-level comment/description noting it is prepared for future use.
   - `rslab/experiments/praxis_graphlaw/benchmark_plan.md`: Details the execution plan, test verification, toolchain specs, and the caveats (mixed harnesses, no profiler tooling, transaction-path admission control framing).
   - Create `.gitkeep` files in `rslab/paper_fragments/`, `rslab/receipts/`, and `rslab/scripts/`.
   - Verify that NO numeric benchmark results exist in `rslab/` using:
     `grep -rn '[0-9]\+\.\?[0-9]*\s*\(ns\|µs\|ms\|s\)\b' rslab/` (except schema versions/pins).

3. Verify that `just regen-check` passes successfully.

4. Stage and commit the changes using `just commit "Ticket 016 & 017: Paper Restructure and rslab Skeleton"`.

MANDATORY INTEGRITY WARNING: DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Document your commands, results, and proof of successful build/check in /Users/sac/mfact/.agents/worker_step2/handoff.md and send me a handoff message when done.
