# mfact-core Rust Layer Design Contract

_Relocated 2026-07-16 from `crates/mfact-core/DESIGN.md`: the entire `/crates/` tree is
gitignored (`.gitignore` line 15), so a design contract stored there could never enter
version control. This copy in `docs/` is the canonical one._

This document is the design contract for the (not yet existing) `mfact-core` Rust crate. It
answers three questions: what the executable's contract is, where the Lean-Rust boundary
lies, and how Lean-Rust correspondence will be proved. Per repository law
(`../AGENTS.md`), this document explains standing; it does not create standing.

Current directory state: `crates/mfact-core/` contains only a stale `target/` build
directory left over from an earlier build. There is no `Cargo.toml`, no `src/`, and no
Rust source of any kind. Nothing in this directory is canonical yet. The stale `target/`
is deliberately left in place; deleting it is outside this document's mutation boundary.

## What is the Rust executable's contract?

The contract is an **open decision for the domain owner**. No choice has been made, and
this document does not pretend one has. The candidate contracts, with trade-offs:

1. **PDDL 3.1 parser front-end.** Parse PDDL 3.1 domains/problems into typed Rust
   structures mirroring the Lean planning-theory shapes.
   - Pro: smallest surface; correspondence targets are data types, not dynamics; the Lean
     side already fixes trace-level semantics (`PDDL31TraceEquiv`) to correspond against.
   - Con: a parser alone exercises none of the kernel/fiber theory; low consequence per
     line of correspondence work; PDDL 3.1 durative-action grammar is large.
2. **POWL workflow executor.** Execute POWL v2 workflow objects (partial orders, choice
   graphs) as a runtime, emitting event traces.
   - Pro: exercises the richest Lean structures (`Powl`, `POWLv2Object`, `ChoiceGraph`)
     and produces traces that the entropy/fiber theory is *about*; enables replay.
   - Con: execution semantics for POWL v2 are not yet pinned in Lean beyond
     `Powl.WellFormed`; the correspondence obligation includes dynamics, the hardest edge.
3. **CLI PDDL-to-POWL transformer.** A command-line tool implementing one concrete
   `WorkflowTransformation`: PDDL 3.1 behavior in, POWL v2 object out.
   - Pro: directly instantiates the central Lean object of the theory (a transformation
     `τ`), so fibers, kernels, and dimension loss get a concrete computational referent.
   - Con: largest scope (subsumes a parser and a POWL emitter); the Lean transformation
     theory is still largely `CONJECTURAL` (see `Kernel.lean` Crown Conjectures), so the
     spec being implemented against is itself unsettled.

Until the domain owner chooses, no `Cargo.toml` should be created. Any Rust code written
before the contract decision is a candidate declaration, not standing.

## What is the Lean-Rust boundary?

The boundary is the set of Lean declarations in `procint/ProcInt/MFW/` that Rust
artifacts would be claimed to correspond to. The real declarations, by candidate:

- **Shared foundation (all candidates)** — `TransformBasic.lean`:
  - `ProcInt.MFW.PlanningTheory` (states, actions, transition law) ↔ Rust domain model;
  - `ProcInt.MFW.BehaviorTrace` / `ProcInt.MFW.IsLawful` / `ProcInt.MFW.LawfulBehavior`
    ↔ Rust trace records and their validity checker;
  - `ProcInt.MFW.DurativeActionExpansion` ↔ Rust handling of PDDL 3.1 durative actions.
- **Candidate 1 (parser)** additionally targets:
  - `ProcInt.MFW.PDDL31TraceEquiv` (`Kernel.lean`) — the equivalence the parsed
    representation must not distinguish beyond;
  - `ProcInt.MFW.StateEquiv` (`Kernel.lean`) — state-level quotient the parser's typed
    output must respect.
- **Candidate 2 (executor)** additionally targets:
  - `ProcInt.MFW.Powl`, `ProcInt.MFW.Powl.WellFormed`, `ProcInt.MFW.ChoiceGraph`,
    `ProcInt.MFW.POWLv2Object`, `ProcInt.MFW.WorkflowSpace` (`TransformBasic.lean`)
    ↔ the executor's workflow IR and its well-formedness validator;
  - `ProcInt.MFW.CausalOrderAssignment` (`Kernel.lean`) — the executor's scheduler is a
    concrete candidate for the causal-order hypothesis the Lean theory parameterizes over.
- **Candidate 3 (transformer)** additionally targets:
  - `ProcInt.MFW.WorkflowTransformation` (`TransformBasic.lean`) ↔ the CLI's core
    function; `ProcInt.MFW.fiber` / `ProcInt.MFW.transformEquiv` ↔ testable quotients;
  - `ProcInt.MFW.KernelEquiv`, `ProcInt.MFW.traceClass`, and (as conjecture targets, not
    proved specs) `ProcInt.MFW.KernelCharacterization` and
    `ProcInt.MFW.FiberEntropyEqSerializationEntropy` (`Kernel.lean`).

Boundary caveat: several `Kernel.lean` targets are `Standing: CONJECTURAL` statement
shapes, not proved theorems. A Rust artifact can correspond to a *definition* (a type, a
predicate); it cannot inherit standing from an unproved conjecture about that definition.

## How will Lean-Rust correspondence be proved?

Matching names or serialized fields are **not** a correspondence proof. A Rust struct
named `PlanningTheory` with fields spelled like the Lean structure proves nothing; the
edge must be established independently, per the Verification Ladder and the
cross-language edge list in the root `AGENTS.md`:

```text
Lean proof -> generated artifact (if applicable)
Rust implementation -> safety property
Rust execution -> receipt
receipt -> replay
```

The planned mechanisms, mapped to ladder rungs:

1. **Type-mapping receipts** (unit rung). A checked-in mapping table pairing each Lean
   declaration with its Rust type, plus a script in `scripts/` that extracts both shapes
   (Lean via `lake env lean` metaprogram or exported JSON schema; Rust via a derive/schema
   dump) and diffs them structurally. The script's output file is the receipt; the table
   alone is prose.
2. **Property tests against Lean-exported oracles** (integration rung). For decidable
   Lean predicates (`IsLawful`, `Powl.WellFormed`, and `validTopologicalSort` in
   `Ledger.lean`, which has a `Decidable` instance), export evaluated verdicts on a
   generated corpus from Lean, then property-test the Rust implementation against that
   corpus (e.g., `proptest` with the corpus as regression seeds). Divergence on any input
   is a counterexample and must be preserved as a negative fixture.
3. **Replay** (end-to-end/replay rungs). Every Rust execution emits a typed receipt
   (input hash, artifact hash, verdicts). Replay re-runs the binary on the receipted
   input and compares hashes; for candidate 2/3, replay additionally re-checks the output
   trace or POWL object with the Lean-exported oracle from mechanism 2.

Each mechanism proves only its own edge. Passing all three still yields at most
`formal/runtime correspondence` for the *definitions* covered; it never upgrades a
`CONJECTURAL` Lean statement, and no receipt here is a proof of any Crown Conjecture.

Standing: BLOCKED — awaiting contract decision (question 1) and correspondence strategy
approval; no Rust source exists (crate has no Cargo.toml or src/).

## See Also

- `../AGENTS.md` — repository Standing Law, Verification Ladder, cross-language edges
- `../procint/AGENTS.md` — tighter rules for the procint Lean subproject
- `../procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` — audit of conjectural/unproved MFW items
- `../procint/ProcInt/MFW/TransformBasic.lean` — foundation declarations at the boundary
- `../procint/ProcInt/MFW/Kernel.lean` — kernel/trace-equivalence declarations and
  Crown Conjectures referenced above
