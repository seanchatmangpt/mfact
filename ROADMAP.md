# ROADMAP: The 16 Topological Bridges

This roadmap defines the core engineering trajectory for `mfact`. Previously, these 16 domains were represented as cosmetic `MULTIFRACTAL_APPLICATION.md` and `COMBINATORIAL_TOPOLOGY.md` files—speculative "vocabulary leaps" that failed mechanical validation. 

They were purged. The new mandate is to systematically rebuild all 16 domains as **mechanically verified Lean 4 formalizations**, bridging advanced mathematics strictly to zero-cost Rust typestates in the execution engine.

## Phase 1: The Core Five (Source Written, Not Yet Build-Verified)
These bridges' Lean sources contain 0 `sorry`s in text, but are not yet bonded to any Rust
typestate -- `safe-toolbox` and `mo-mae` are not real crates in this repo (the two real
crates are the root `mfact` package and `crates/mfact-core`, neither workspaced together;
neither contains any `PhantomData`/`type Proof` typestate bindings). The zero-cost
Rust bonding mandated below (Execution Rules) has not been built for any of the five.
1. **Random Walk / Galton-Watson Trees**: Proves the mathematical bijection between branching stochastic population processes and Agile Release Train story point decomposition. 
2. **RevOps Turbulence / Phase Changes**: Formally bounds turbulent phase shifts to exact thread-pool scheduling density and execution overhead.
3. **Star Graph Topologies**: Computes exact Betti numbers ($b_1 = 0$) and Euler characteristics to mathematically enforce hub-and-spoke execution bottlenecks for independent traffic flows.
4. **Stochastic Pair Correlation**: Formally bounds the variance of the execution engine, proving it asymptotically models an i.i.d. sequence under safe conditions.
5. **Scalar Dissipation / Metric Spaces**: Maps physical dissipation rates to concrete state-transition friction (e.g., funding cuts, market pivots).

Caveat: `star_graphs` has no `.lake` build directory in this tree
(`ls research-papers/star_graphs/.lake` fails) -- its Lean source has never been successfully
compiled here, so "0 `sorry`s in text" is not the same as "formally verified." Re-run
`lake build` for each of the five before re-labeling this phase "Constructed & Verified."

## Phase 2: The Next Horizon (In Progress / Scheduled)
These domains must be subjected to the same rigorous 80/20 formalization. No claims are permitted without a corresponding `.lean` proof and a zero-cost Rust `PhantomData` invariant.
6. **Quantum Hall Effect**: Map topological edge states to resilient, unblockable CI/CD deployment paths.
7. **SMFDCCA (Multifractal Detrended Cross-Correlation)**: Formalize the Cauchy-Schwarz bounding of cross-correlated system metrics.
8. **Sparse Chaos Diagnostics**: Map Lyapunov exponents to divergence in non-deterministic test suites.
9. **Terminal Breakdown**: Formalize failure cascades in DAG-based task execution.
10. **Weighted Random Networks**: Prove degree distribution bounds for dynamically allocated scrum teams.
11. **Combinatorial Topology (General)**: Formalize simplexes and cell complexes for generalized project dependency tracking.
12. **Hyperdimensional Cognitive Vectors**: Formalize exact orthogonality bounds for concurrent vector execution.
13. **Minimal Measures**: Prove the existence of invariant measures for stable team velocity.
14. **Ortac Plus (Automated Bounds)**: Map differential topology invariants to automated testing boundary generation.
15. **Signal Criticality**: Formalize critical slowing down (CSD) indicators prior to execution gridlock.
16. **Bio-Signals / Complex Systems**: Map physiological oscillation models to heartbeat metrics in autonomous agent swarms.

## Execution Rules
- **No Vocabulary Leaps**: If a topological concept cannot be expressed in Lean 4 and verified by `lake build`, it cannot be documented.
- **Zero-Cost Mechanisms**: Every verified Lean boundary must be represented in Rust as a compile-time constraint (`PhantomData`, `type Proof = ();`).
- **Complete Verification**: Do not trust completeness. Rely exclusively on `rigor_linter.py`, `lake build`, and `cargo check`.
