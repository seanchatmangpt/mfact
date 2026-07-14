# PROJ-01: Implement Thermo.lean for Aeneas Rust Verification

## Objective
Establish the `Thermo.lean` execution model mapped to the Rust verification topology.

## Requirements
- Define the core execution model in `Thermo.lean`.
- Map the state transitions and ownership lifetimes of Rust's borrow checker to a thermodynamic execution framework (e.g., modeling memory drops as energy dissipation).
- Ensure the topology rigorously enforces borrow-checking invariants structurally.
- **Zero `sorry`s:** All theorems and definitions must be fully proved.
- **Environment:** Must strictly pass the `just doctor` environment scanner.

## Acceptance Criteria
1. `Thermo.lean` compiles without errors or warnings.
2. `just doctor` passes for the `aeneas_rust_verification` domain.
3. No `sorry`s remain in the codebase.


## Status
Closed
