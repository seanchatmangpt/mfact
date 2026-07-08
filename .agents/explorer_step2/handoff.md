# Handoff Report: paper Restructuring & rslab Design

This handoff report summarizes the read-only exploration and analysis of the standing-manufacturing graph structure of the paper and the greenfield `rslab` empirical evidence rail design.

---

## 1. Observation

1. **Section Headers in `paper/main.tex`**:
   - `\section{Introduction}`: Line 109
   - `\section{The Receipted Manufacturing Law}`: Line 228
   - `\section{From Public Ontology to Domain Standing}`: Line 280
   - `\section{Related Work}`: Line 309
   - `\section{The mfact Framework}`: Line 380
   - `\section{procint: the Mathematical Canon}`: Line 423
   - `\section{The Manufacturing Run}`: Line 524
   - `\section{Use of Generative AI Tools}`: Line 585
   - `\section{Evaluation}`: Line 616
     - `\subsection{Standing Quadrature}`: Line 640
     - `\subsection{D1 Correspondence Pilot}`: Line 669
   - `\section{Falsifier and Valid Objection Surface}`: Line 711
   - `\section{Limitations and Standing}`: Line 735
   - `\section{Availability}`: Line 798
   - `\section{Conclusion}`: Line 848

2. **D1 Correspondence/Aeneas References**:
   - Line 365: `Section~\ref{sec:correspondence} extracts an external Rust crate into Lean`
   - Line 670: `\label{sec:correspondence}` under `\subsection{D1 Correspondence Pilot}`.
   - The Aeneas section spans lines 669–710 in `/Users/sac/mfact/paper/main.tex`.

3. **Jira Tickets in `pylab/docs/jira/26.7.7/tickets/`**:
   - **`ticket_016_paper_standing_graph_restructure.md`**: Outlines the required structure of the paper, including 17 sections, promoting Aeneas to a top-level section, adding placeholders, and adding a rails table for the Standing-Manufacturing Graph.
   - **`ticket_017_rslab_skeleton.md`**: Provides the verbatim 4-line doctrine block for `rslab/README.md`, required fields for `manifest.toml`, `benchmark_result.schema.json`, `profiler_result.schema.json`, and the requirements for `benchmark_plan.md`.
   - **`ticket_018_praxis_graphlaw_benchmark_import.md`**: Lists the exact cargo benchmark and test commands, and receipt properties to be validated against the schema.
   - **`ticket_019_rslab_paper_fragment_wiring.md`**: Explains how generated fragments are wired into the paper and ledgered.

---

## 2. Logic Chain

1. **Mapping of Sections to Rails**:
   - From *Observation 3 (Ticket 016)*, we trace that the target paper layout matches a five-rail architecture consisting of Formal, Process-law, Benchmark, Correspondence, and Paper rails.
   - Comparing this to the current layout in *Observation 1*, we see that the benchmark rail has no representation in the top-level section list, and the correspondence rail (Aeneas) is currently subordinated inside `Evaluation`.
   - Promoting `\subsection{D1 Correspondence Pilot}` (lines 669–710) to `\section{Implementation Correspondence with Aeneas}` (Section 12) directly aligns the layout with its importance as an independent rail.
   - Creating stubs for §9 `praxis-graphlaw: Executable Law-State Evaluation` and §10 `rslab: Empirical Evidence Rail` sets up the placeholders to represent the benchmark/operational rail.

2. **Placement of Stubs**:
   - From *Observation 3 (Ticket 016)*, the stubs for `praxis-graphlaw` and `rslab` must reside between `The Manufacturing Run` (Section 8) and `Use of Generative AI Tools` (Section 11).
   - *Observation 1* shows `The Manufacturing Run` ends at line 584 and `Use of Generative AI Tools` begins at line 585, making this the correct insertion point.

3. **`rslab` Schema & Plan Content**:
   - From *Observation 3 (Ticket 017 & 018)*, the schema `benchmark_result.schema.json` must validate receipts that contain either a single command execution record or a list of multiple raw output files (e.g. `raw/bench_graphlaw.txt`, `raw/bench_root.txt`, etc.).
   - The JSON Schema was designed with optional parameters and flexible lists (`files`) to validate both single and multi-file receipt structures while enforcing the mandatory fields (`builder`, `experiment_id`, `toolchain`, `evidence`).
   - The benchmark plan in `benchmark_plan.md` matches the exact execution commands from `/Users/sac/praxis` (such as `cargo bench -p praxis-graphlaw`, `cargo test -p praxis-graphlaw`, etc.) and documents the caveats identified in Ticket 017 (no profiling tooling, mixed harnesses, etc.).

---

## 3. Caveats

- **No Implementation**: As a read-only explorer agent, no files have been modified. The reordering instructions and file contents are provided as specification/design only.
- **RSLAB/Praxis Version & Toolchain**: The benchmark plan assumes the toolchain and repository paths (`/Users/sac/praxis`) match the environment described in Ticket 017/018.

---

## 4. Conclusion

- **Aeneas Relocation**: Promote `\subsection{D1 Correspondence Pilot}` (lines 669–710) to a top-level section `\section{Implementation Correspondence with Aeneas}` at Section 12.
- **Section Restructuring**: Insert Section 4 (Architecture), Section 9 (praxis-graphlaw stub), Section 10 (rslab stub), and restructure Section 13 (Evaluation) into 13.1 (Formal Standing Evaluation), 13.2 (Standing Quadrature), and 13.3 (praxis/rslab Benchmark Evidence stub).
- **Greenfield `rslab`**: The defined schema and plan files are ready to be written to `rslab/` by the implementer agent.

---

## 5. Verification Method

- **Analysis Verification**:
  - The findings can be verified by checking `/Users/sac/mfact/.agents/explorer_step2/analysis.md` which has the complete analysis report including the exact contents for the greenfield files.
- **Paper Restructure Verification**:
  - Once implemented, verification can be run via:
    ```bash
    grep -n '\\section\|\\subsection' paper/main.tex
    just paper-check
    ```
- **Schema Validation Verification**:
  - Once files are written, validate the schemas via:
    ```bash
    python3 -c "import json; json.load(open('rslab/schemas/benchmark_result.schema.json'))"
    python3 -c "import json; json.load(open('rslab/schemas/profiler_result.schema.json'))"
    ```
