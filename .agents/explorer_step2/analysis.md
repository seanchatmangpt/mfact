# Analysis Report: Paper Restructure & rslab Infrastructure

## Overview

This report details the findings and plans for restructuring `paper/main.tex` around the five-rail architecture and establishing the greenfield `rslab` empirical evidence rail. All investigations are read-only; no files outside of the agent's folder have been modified.

---

## 1. Structure of `paper/main.tex` (Current vs. Restructured)

### Current Structure
The existing structure of `paper/main.tex` consists of 13 top-level sections:
1. `\section{Introduction}` (Line 109)
2. `\section{The Receipted Manufacturing Law}` (Line 228)
3. `\section{From Public Ontology to Domain Standing}` (Line 280)
4. `\section{Related Work}` (Line 309)
5. `\section{The mfact Framework}` (Line 380)
6. `\section{procint: the Mathematical Canon}` (Line 423)
7. `\section{The Manufacturing Run}` (Line 524)
8. `\section{Use of Generative AI Tools}` (Line 585)
9. `\section{Evaluation}` (Line 616)
   - `\subsection{Standing Quadrature}` (Line 640)
   - `\subsection{D1 Correspondence Pilot}` (Line 669) [Aeneas Section]
10. `\section{Falsifier and Valid Objection Surface}` (Line 711)
11. `\section{Limitations and Standing}` (Line 735)
12. `\section{Availability}` (Line 798)
13. `\section{Conclusion}` (Line 848)

---

## 2. Reordering to Match Five-Rail Architecture

The five-rail architecture maps to the new section order as follows:

| Rail | Focus | Primary Paper Sections |
|---|---|---|
| **Formal** | Lean kernel proofs, axiom audits | §7 (procint), §13.1 (Formal Standing Evaluation), §13.2 (Standing Quadrature) |
| **Process-law** | Governing law ($A = \mu(O^*)$), status algebra | §2 (Receipted Manufacturing Law), §6 (mfact Framework) |
| **Benchmark** | Executable law-state engine & runtime metrics | §9 (praxis-graphlaw), §10 (rslab), §13.3 (Benchmark Evidence) |
| **Correspondence** | Binary extraction & logic equivalence proof | §12 (Implementation Correspondence with Aeneas) |
| **Paper** | Artifact ledger, reproducibility & manifest verification | §3 (Public Ontology to Domain Standing), §4 (Architecture Graph), §8 (Manufacturing Run), §14 (Objection Surface) |

### Target Section Order (17 Sections)
1. **Introduction** (Existing content preserved)
2. **The Receipted Manufacturing Law** (Existing content, with a new `\paragraph{The Four Evidence Kinds.}` added)
3. **From Public Ontology to Domain Standing** (Existing content)
4. **Architecture: The Standing-Manufacturing Graph** (*NEW* section containing the rails table mapping source, boundary, and receipt)
5. **Related Work** (Existing content)
6. **The mfact Framework** (Existing content, plus sentence stating that mfact is the Lean/Lake apparatus in a larger standing graph)
7. **procint: Process Intelligence as Process Law** (Existing content retitled from "procint: the Mathematical Canon")
8. **The Manufacturing Run** (Existing content)
9. **praxis-graphlaw: Executable Law-State Evaluation** (*NEW* placeholder stub)
10. **rslab: Empirical Evidence Rail** (*NEW* placeholder stub + doctrine verbatim)
11. **Use of Generative AI Tools** (Existing content)
12. **Implementation Correspondence with Aeneas** (*NEW* top-level section; promoted from the Evaluation subsection)
13. **Evaluation** (Restructured into three labeled subsections: 13.1 Formal Standing Evaluation, 13.2 Standing Quadrature, 13.3 *NEW* placeholder praxis/rslab Benchmark Evidence)
14. **Falsifier and Valid Objection Surface** (Existing content)
15. **Limitations and Standing** (Existing content)
16. **Availability** (Existing content)
17. **Conclusion** (Existing content)

---

## 3. Promotion of the Aeneas Section

### Current Location
- **File**: `/Users/sac/mfact/paper/main.tex`
- **Lines**: 669–710
- **Current Header**: `\subsection{D1 Correspondence Pilot}` (located within `\section{Evaluation}`)
- **Label**: `\label{sec:correspondence}`

### Target Promotion
It will be promoted to the top-level **Section 12**, titled `\section{Implementation Correspondence with Aeneas}`.
- **Label**: `\label{sec:correspondence}` is kept intact (referenced at line 365: `Section~\ref{sec:correspondence} extracts...`).
- **Body**: The entire text from lines 672–710 (the description of Aeneas/Charon pipeline, token-replay counts, and the `correspondence_status` input calls) moves to this new top-level section.

---

## 4. Detailed Reordering Instructions for `paper/main.tex`

### Action A: Insert Section 4 (Architecture)
Insert the following LaTeX block right before `\section{Related Work}` (line 309):

```latex
\section{Architecture: The Standing-Manufacturing Graph}
\label{sec:architecture}

The standing-manufacturing graph is organized around a five-rail architecture. Table~\ref{tab:rails} details each rail's source, admission boundary, and receipt form.

\begin{table}[h]
\centering
\small
\begin{tabular}{llll}
\toprule
Rail & Source & Admission Boundary & Receipt Form \\
\midrule
Formal & Lean catalog, corpus & Lean kernel, axiom policy & Audit log, print axioms \\
Process-law & mfact core definitions & Conformance obligs. & covers proof, ValidObjection \\
Benchmark & praxis execution & rslab schemas & JSON/TOML result receipt \\
Correspondence & Rust crate source & Aeneas extraction & build\_verif.py check \\
Paper & Manifest status & ggen sync & Manifest foldHash, regen-check \\
\bottomrule
\end{tabular}
\caption{The Five-Rail standing-manufacturing architecture.}
\label{tab:rails}
\end{table}
```

### Action B: Additions to Sections 2 and 6
1. **In Section 2 (The Receipted Manufacturing Law)**: After line 249, insert:
   ```latex
   \paragraph{The Four Evidence Kinds.} We distinguish four classes of evidence within the manufacturing graph: (1) Formal evidence (Lean theorems and axiom audits); (2) Operational evidence (praxis-graphlaw benchmark and execution validation via rslab); (3) Correspondence evidence (Aeneas-extracted image to procint semantic equivalence proofs); and (4) Publication evidence (generated paper fragments and manifests).
   ```
2. **In Section 6 (The mfact Framework)**: At the end of the intro paragraph (line 385, right before `\paragraph{Candidates and refusals.}`), append:
   ```latex
   mfact is not the whole system: it is the Lean/Lake standing apparatus inside a larger standing-manufacturing graph.
   ```

### Action C: Insert Sections 9 and 10
Insert the stubs for `praxis-graphlaw` and `rslab` right after `\section{The Manufacturing Run}` block (line 584) and right before `\section{Use of Generative AI Tools}` (line 585):

```latex
\section{praxis-graphlaw: Executable Law-State Evaluation}
\label{sec:praxis-graphlaw}

This section is completed under Ticket 020, once Ticket 019's rslab fragments exist to cite.

\section{rslab: Empirical Evidence Rail}
\label{sec:rslab}

rslab is not a proof engine. rslab is an empirical evidence rail.

This section is completed under Ticket 020, once Ticket 019's rslab fragments exist to cite.
```

### Action D: Extract & Move Aeneas Block
1. **Cut** lines 669–710 from `\section{Evaluation}`.
2. **Insert** the cut block right after `\section{Use of Generative AI Tools}` (ends at line 615) and before `\section{Evaluation}`.
3. **Modify** the header of the inserted block from:
   ```latex
   \subsection{D1 Correspondence Pilot}
   \label{sec:correspondence}
   ```
   to:
   ```latex
   \section{Implementation Correspondence with Aeneas}
   \label{sec:correspondence}
   ```

### Action E: Restructure Section 13 (Evaluation)
Currently, lines 616–639 contain the Evaluation intro and Final Status paragraph.
1. Insert `\subsection{Formal Standing Evaluation}` and label `\label{sec:formal_eval}` right after `\label{sec:eval}` (line 617) so that lines 619–639 become subsection 13.1.
2. The `Standing Quadrature` subsection (lines 640–668) remains unchanged and automatically becomes subsection 13.2.
3. Right after the `Standing Quadrature` block (line 668, where the Aeneas block was cut), insert:
   ```latex
   \subsection{praxis/rslab Benchmark Evidence}
   \label{sec:rslab_benchmark}

   This section is completed under Ticket 020, once Ticket 019's rslab fragments exist to cite.
   ```

---

## 5. Contents of Greenfield `rslab` Infrastructure Files

Here are the defined exact contents for the new `rslab/` files to be created in the subsequent implementation steps.

### File 1: `rslab/README.md`
```markdown
# rslab: The Empirical Evidence Rail

## Doctrine

```text
praxis executes.
rslab measures and receipts.
mfact admits formal standing.
paper renders admitted/receipted claims.

rslab is not a proof engine.
rslab is an empirical evidence rail.

praxis raw output = O
schema-validated, receipted output = O*
paper fragment generated from an rslab receipt = A
```

## Governance and Metadata Tiers

In accordance with the project's manufacturing pipeline:

1. **Unledgered Inputs (Experiment Configuration & Scripts)**:
   - All files under `rslab/` representing experiment definitions, scripts, schemas, and benchmark plans (e.g., this `README.md`, `manifest.toml`, `schemas/*.schema.json`, `experiments/praxis_graphlaw/benchmark_plan.md`, and scripts under `scripts/`) are *unledgered*.
   - They belong to the same governance tier as `pylab/`: hand-authored, never generated by the `ggen` pipeline, and can be edited freely.

2. **Ledgered Outputs (Receipts & Generated Fragments)**:
   - All generated experiment *receipts* (under `rslab/receipts/`) and any *generated paper fragments* (under `rslab/paper_fragments/`) built from them are *ledgered* in `.mfact/artifacts.toml`.
   - These files carry evidence that directly feeds paper claims and are subject to the ledger law. Any manual edits to these files post-generation will trigger `ARTIFACT_DRIFT_REFUSED`.

3. **Status Schema**:
   - The status schema in `manifest.toml` reuses the status-ladder pattern defined in `research/verif/obligations.toml` and `research/wfnet/obligations.toml`:
     `DECLARED < EXTRACTED < STATED < PROVEN`
```

### File 2: `rslab/manifest.toml`
```toml
# rslab Experiment Manifest
# Reuses the status ladder pattern: DECLARED < EXTRACTED < STATED < PROVEN

[manifest]
manifest_version = "1.0.0"

[[experiments]]
id = "praxis_graphlaw"
status = "declared"
plan = "experiments/praxis_graphlaw/benchmark_plan.md"
```

### File 3: `rslab/schemas/benchmark_result.schema.json`
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Benchmark Result Schema",
  "description": "Schema for validating rslab benchmark results and receipts.",
  "type": "object",
  "properties": {
    "builder": {
      "type": "string",
      "description": "Identifier of the builder script or ticket that generated this receipt."
    },
    "experiment_id": {
      "type": "string",
      "description": "The unique identifier of the experiment."
    },
    "command": {
      "type": "string",
      "description": "The benchmark command that was executed."
    },
    "raw_output_path": {
      "type": "string",
      "description": "Relative path to the raw command output file."
    },
    "raw_output_hash": {
      "type": "string",
      "pattern": "^[a-f0-9]{64}$",
      "description": "BLAKE3 hash (b3sum) of the raw output file."
    },
    "praxis_commit": {
      "type": "string",
      "pattern": "^[a-f0-9]{40}$",
      "description": "Git commit hash of the praxis repository at runtime."
    },
    "command_log_path": {
      "type": "string",
      "description": "Relative path to the command execution log."
    },
    "command_log_hash": {
      "type": "string",
      "pattern": "^[a-f0-9]{64}$",
      "description": "BLAKE3 hash of the command execution log."
    },
    "files": {
      "type": "array",
      "description": "Array of files receipted during this benchmark run.",
      "items": {
        "type": "object",
        "properties": {
          "path": {
            "type": "string"
          },
          "hash": {
            "type": "string",
            "pattern": "^[a-f0-9]{64}$"
          }
        },
        "required": ["path", "hash"]
      }
    },
    "toolchain": {
      "type": "object",
      "description": "Metadata regarding the toolchain and environment.",
      "properties": {
        "rustc_version": {
          "type": "string"
        },
        "toolchain_pin": {
          "type": "string"
        },
        "os": {
          "type": "string"
        },
        "hardware_note": {
          "type": "string"
        }
      },
      "required": ["rustc_version", "toolchain_pin", "os"]
    },
    "evidence": {
      "type": "object",
      "description": "Booleans mirroring the verif-receipt.json evidence shape, tracking empirical readiness.",
      "properties": {
        "declared": {
          "type": "boolean"
        },
        "extracted": {
          "type": "boolean"
        }
      },
      "required": ["declared", "extracted"],
      "additionalProperties": false
    },
    "caveats": {
      "type": "array",
      "description": "Explicit caveats recorded during execution.",
      "items": {
        "type": "string"
      }
    }
  },
  "required": [
    "builder",
    "experiment_id",
    "toolchain",
    "evidence"
  ],
  "additionalProperties": true
}
```

### File 4: `rslab/schemas/profiler_result.schema.json`
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Profiler Result Schema",
  "description": "Schema for validating rslab profiling results and receipts. NOTE: As of this release, no profiling/flamegraph tooling exists in /Users/sac/praxis (verified by exploration). This schema is prepared for future use and is not populated.",
  "type": "object",
  "properties": {
    "builder": {
      "type": "string",
      "description": "Identifier of the builder script or ticket that generated this receipt."
    },
    "experiment_id": {
      "type": "string",
      "description": "The unique identifier of the experiment."
    },
    "command": {
      "type": "string",
      "description": "The profiler command that was executed."
    },
    "raw_output_path": {
      "type": "string",
      "description": "Relative path to the raw command output file."
    },
    "raw_output_hash": {
      "type": "string",
      "pattern": "^[a-f0-9]{64}$",
      "description": "BLAKE3 hash (b3sum) of the raw output file."
    },
    "profiler_tool": {
      "type": "string",
      "description": "The profiling/flamegraph tool utilized."
    },
    "praxis_commit": {
      "type": "string",
      "pattern": "^[a-f0-9]{40}$",
      "description": "Git commit hash of the praxis repository at runtime."
    },
    "command_log_path": {
      "type": "string",
      "description": "Relative path to the command execution log."
    },
    "command_log_hash": {
      "type": "string",
      "pattern": "^[a-f0-9]{64}$",
      "description": "BLAKE3 hash of the command execution log."
    },
    "files": {
      "type": "array",
      "description": "Array of files receipted during this profiling run.",
      "items": {
        "type": "object",
        "properties": {
          "path": {
            "type": "string"
          },
          "hash": {
            "type": "string",
            "pattern": "^[a-f0-9]{64}$"
          }
        },
        "required": ["path", "hash"]
      }
    },
    "toolchain": {
      "type": "object",
      "description": "Metadata regarding the toolchain and environment.",
      "properties": {
        "rustc_version": {
          "type": "string"
        },
        "toolchain_pin": {
          "type": "string"
        },
        "os": {
          "type": "string"
        },
        "hardware_note": {
          "type": "string"
        }
      },
      "required": ["rustc_version", "toolchain_pin", "os"]
    },
    "evidence": {
      "type": "object",
      "description": "Booleans mirroring the verif-receipt.json evidence shape, tracking empirical readiness.",
      "properties": {
        "declared": {
          "type": "boolean"
        },
        "extracted": {
          "type": "boolean"
        }
      },
      "required": ["declared", "extracted"],
      "additionalProperties": false
    },
    "caveats": {
      "type": "array",
      "description": "Explicit caveats recorded during execution.",
      "items": {
        "type": "string"
      }
    }
  },
  "required": [
    "builder",
    "experiment_id",
    "profiler_tool",
    "toolchain",
    "evidence"
  ],
  "additionalProperties": true
}
```

### File 5: `rslab/experiments/praxis_graphlaw/benchmark_plan.md`
```markdown
# Benchmark Plan: praxis-graphlaw Evaluation

This document outlines the verified-runnable benchmark and test suites for `praxis-graphlaw`.

## 1. Benchmark Execution Plan

### 1.1 Crate-Level Benchmarks
Run the benchmark suite defined within `praxis-graphlaw`:
```bash
cargo bench -p praxis-graphlaw
```
This runs the following four suites using the corresponding harnesses:
1. **`bench`** (Harness: `bencher`): Measures ImaRS window add/update throughput.
2. **`hierarchies`** (Harness: `bencher`): Measures N3 forward-chaining materialization at depth 1,000 and 10,000.
3. **`dialects`** (Harness: `bencher`): Measures SHACL, ShEx, N3, and Datalog throughput evaluated at 100, 1,000, and 5,000 focus nodes.
4. **`blue_river_dam`** (Harness: `divan`): Measures `TripleStore::materialize()` incremental delta performance.

### 1.2 Root-Level Benchmarks
Run root-level benchmarks within the workspace:
```bash
cargo bench
```
This executes:
1. **`receipt_validate`** (Harness: `criterion`): Validates receipts under a <5 ms latency target for ~100 records.
2. **`bench_main`** (Harness: `criterion`): Measures core pipeline throughput.
3. **`blue_river_dam`** (Harness: `divan`): Evaluates control-layer surfaces including standing transitions, PDDL grounding, POWL scheduler, and receipt chain verification.

## 2. Test Verification Plan

### 2.1 Crate-Level Conformance Tests
Execute the conformance, stress, and fuzz suites to verify functional correctness:
```bash
cargo test -p praxis-graphlaw
```
*Note: Do not hardcode past test counts (e.g., 380 passed); the exact results must be dynamically captured at runtime.*

### 2.2 End-to-End Admission Tests
Run end-to-end integration tests within the generation pipeline:
```bash
cargo test -p ggen --test graphlaw_e2e
```
This verifies 5 specific cases covering admission, refusal, and determinism check gates.

## 3. Toolchain & Environment Specifications

- **Toolchain Pin**: `nightly-2026-04-15` (specified in `/Users/sac/praxis/rust-toolchain.toml`)
- **Captured Properties**: `rustc` version details, OS description (`uname -a`).

## 4. Caveats & Architectural Clarifications

1. **Harness Diversity**: The workspace uses multiple distinct benchmark frameworks (`bencher`, `divan`, `criterion`) simultaneously; comparison of raw performance metrics across these harnesses is not directly supported.
2. **No Profiling/Flamegraph Tooling**: As of this exploration, no profiling or flamegraph tooling exists in the `/Users/sac/praxis` workspace. The `profiler_result.schema.json` is provided for future extensions and is currently unpopulated.
3. **Terminology on Admission Control**: "Transaction-path admission control" is not an existing named class or interface inside the `praxis` codebase. The nearest structural representations are SHACL/ShEx admission gates and the POWL admission context (`bcinr_powl::admit::{admit, AdmissionContext}`). Any paper language referring to "transaction-path admission control" must frame it as a future design objective rather than an implemented feature.
```
