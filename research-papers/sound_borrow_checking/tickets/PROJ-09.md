# PROJ-09: Implement Thermo.lean for Sound Borrow Checking

## Objective
Establish the `Thermo.lean` execution model mapped to the sound borrow checking topology.

## Requirements
- Define the core execution model in `Thermo.lean`.
- Map the soundness of borrow checking to a thermodynamic process, formalizing a monotonic decrease in available aliasing energy (entropy) as the program execution advances across the topology.
- Structurally enforce safety guarantees as physical conservation limits.
- **Zero `sorry`s:** All aliasing invariants and topological properties must be entirely proved.
- **Environment:** Must strictly pass the `just doctor` environment scanner.

## Acceptance Criteria
1. `Thermo.lean` effectively encapsulates borrow checker thermodynamics.
2. `just doctor` runs successfully on the `sound_borrow_checking` domain.
3. The codebase contains no `sorry`s.


## Status
Closed
