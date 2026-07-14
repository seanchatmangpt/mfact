# PROJ-03: Implement Thermo.lean for Floquet Photonic

## Objective
Establish the `Thermo.lean` execution model mapped to the Floquet photonic topology.

## Requirements
- Define the core execution model in `Thermo.lean`.
- Construct a topology mapping periodically driven (Floquet) photonic systems, demonstrating the conservation of quasi-energy across the lattice.
- The execution model must track photonic mode transitions as thermodynamic operations.
- **Zero `sorry`s:** All topological mappings and energy conservations must be fully proved.
- **Environment:** Must strictly pass the `just doctor` environment scanner.

## Acceptance Criteria
1. `Thermo.lean` captures the Floquet quasi-energy invariant.
2. `just doctor` runs successfully on the `floquet_photonic` domain.
3. The codebase contains exactly 0 `sorry`s.


## Status
Closed
