# ROADMAP GAP ANALYSIS: SEMANTIC BRIDGE TO PDDL

## Executive Summary
A mechanical gap analysis of the `~/mfact` formal domains against `CLAUDE_ROADMAP.md` reveals a critical missing bridge: **The mathematical formalization does not support mapping semantic graphs to irreducible PDDL transition residues because the semantic graph side (Yin) is completely absent from the formal models.**

## Findings

1. **Current Formal Domains Support PDDL and POWL (Yang):**
   The `mfact` definitions in `procint/ProcInt` cover 10 formal domains (e.g., Petri Nets, OCEL, Analytics (e.g. `Correlation.lean`), Models (`Powl.lean`), Planning (`Pddl.lean`)). We have valid formal Lean models for PDDL planning (via `Finset Atom` states and `PddlPlan.validCheck`) and POWL process structures.

2. **Semantic Graph Domains are Missing (Yin):**
   The roadmap strictly dictates a runtime loop: 
   *admitted graph state → semantic closure (Datalog) → refusal (SHACL) → unresolved required state → PDDL plan.*
   However, mechanical grep and directory traversal of `procint/ProcInt` confirms there are zero Lean representations for RDF, Datalog, SHACL, ShEx, or SPARQL in `mfact`.

3. **The Missing Semantic Bridge:**
   The roadmap states that "Datalog and N3 subtract inference from work; PDDL identifies the irreducible state-transition residue." Since semantic graphs are unmodeled, there is no formal bridge to map the output of a Datalog closure / SHACL admission down to the starting `Finset Atom` (`s0`) and goal state (`sGoal`) required by `PddlAction.applicable`. 

## Conclusion
The math in `mfact` currently models the execution and planning layers but mathematically fails to support the roadmap's core "Yin/Yang" contraction phase. To fulfill the roadmap, `mfact` requires new formal domains modeling RDF graphs, Datalog inference rules, and a mathematical mapping function that projects unresolved semantic state into PDDL atoms.
