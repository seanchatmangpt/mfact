# Gap Analysis: Autonomic Expansion of POWL Layers

## Executive Summary
This report analyzes the `~/mfact` repository to determine whether it actually supports the "mathematical recursive manufacturing of POWL layers" (the W0 -> W1 -> W2 expansion), which is the core insight of the Multifractal Workflow runtime defined in `CLAUDE_ROADMAP.md`. 

The conclusion is that **the `~/mfact` codebase does not currently support recursive manufacturing**. The current implementation is strictly a passive certification framework (checking `BLAKE3` hashes in `mfact-core` Rust and defining basic structures in `ProcInt` Lean). Both the Lean 4 formalizations and the Rust runtime lack the structural semantics and the dynamic execution engine necessary to autonomicly grow process layers.

## 1. Does the Codebase Support W0 -> W1 -> W2?
**No.** 
- The `mfact-core` Rust crate only handles manifest parsing, hash computation (via `blake3`), and validation of static receipts. It contains zero execution, planning, or state-machine loops.
- The `ProcInt.Models.Powl` Lean formalization defines only flat, static POWL primitives (`atom`, `silent`, `xor`, `loop`, `po`). It lacks the concept of a hierarchical invocation or a dynamic sub-layer `W_{n+1}`. An `atom a` cannot currently yield to a new POWL geometry.
- The `ProcInt.Planning.Pddl` Lean formalization defines classical STRIPS planning (sequential lists of actions) without hierarchical task network (HTN) semantics or the ability to defer unresolvable state transitions to a child planner.

## 2. Gaps in Lean 4 Formalizations (`ProcInt`)
To support the autonomic expansion identified in the roadmap, the formalisms must be augmented:
1. **Hierarchical POWL (`ProcInt.Models.Powl`)**:
   - The `Powl` inductive type must introduce a `subworkflow (child: Powl α)` or `expansion (ref: Goal) (child: Powl α)` variant to encode `W0[a ↦ W1]`. 
   - Well-formedness rules must be updated to prevent infinite recursive descent (bounding the process depth).
2. **Goal State Deferral (`ProcInt.Planning.Pddl`)**:
   - STRIPS state transitions must distinguish between "executable hook" and "unresolved required state".
   - The `PddlPlan.validCheck` logic needs semantics for when a goal state `g` is false but reachable, prompting the manufacture of a new plan/layer rather than an immediate failure.
3. **Graph State Admission (`ProcInt.Graph`)**:
   - The repository currently lacks representations of RDF graph states, Datalog closures, or SHACL admission checks that the roadmap specifies as the prerequisite for identifying "unresolved state".

## 3. Bonding Lean 4 Formalizations to the Execution Engine
To make the Multifractal Workflow a reality, the mathematical proofs in Lean 4 must be bonded to a runtime process machine. The `mfact` codebase must expand (or bridge to `praxis`/`bcinr`) at the following boundaries:

1. **The Dynamic Planner Bridge**: 
   - The execution engine needs to dynamically query the Lean kernel (or a wasm-compiled extraction of it) during runtime. When the engine encounters a blocked node (a missing state in RDF), it must invoke the Lean `PDDL` planner to resolve a path, and the Lean `POWL` geometry generator to synthesize the child layer (`W_{n+1}`).
2. **Standing & Admission Hooks**:
   - Lean proofs regarding admissibility (e.g., `SHACL` adherence, well-formedness of the newly manufactured POWL tree) must generate receipts. The Rust execution loop must enforce that **no actuation happens without a Lean-certified receipt** of standing.
3. **Rust Loop Implementation**:
   - The `mfact-core` crate (or an outer OTP/Arazzo engine) must implement the "crown loop" from the roadmap: *admitted graph state → identify unresolved state → PDDL plan → POWL manufacture → local execution/dispatch → readmission via SPARQL CONSTRUCT*. 
   - Currently, `mfact-core` has no loops, actors, or state progression. A new crate or module (e.g., `mfact-runtime` or `mfact-broker`) is required to drive this recursive expansion loop and coordinate with the Lean kernel.
