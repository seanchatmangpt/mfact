# TEST_INFRA — Iteration 6 E2E Test Plan

This document defines the 4-tier End-to-End (E2E) testing plan and validation infrastructure for the OpenQASM 3.0 compiler (`Qasm.lean`) and the Spiking Neural Network (SNN) neuromorphic exporter (`Snn.lean`).

---

## Testing Tiers Overview

| Tier | Focus | Scope | Verification Tool |
|---|---|---|---|
| **Tier 1** | AST & Compiler Unit Verification | Structural check on compilation AST outputs for small nets. | `lake test` / Lean assertions |
| **Tier 2** | Property & Syntactic Verification | Parser validation and structural properties (qubit/neuron counts). | Python validation script |
| **Tier 3** | Formal Equivalence Proof Verification | Check proofs for zero `sorryAx` using axiom analysis. | `just audit` / Axiom collector |
| **Tier 4** | E2E Hardware Co-Simulation | Co-simulating outputs on virtual quantum/neuromorphic engines. | Qiskit (Quantum) / Lava (SNN) |

---

## Tier 1 — AST & Compiler Unit Verification

Verify that the compilers correctly construct their target AST structures from formal `PetriNet` objects.

### 1. Test Cases
- **Test Case 1.1**: Simple linear sequence (Place 1 $\to$ Transition 1 $\to$ Place 2).
- **Test Case 1.2**: Conflict resolution structure (Place 1 shared as input to Transition 1 and Transition 2).
- **Test Case 1.3**: Fork-Join structure (Transition 1 feeds Place 2 and Place 3; Transition 2 consumes both).

### 2. Execution Command
```bash
cd procint && lake test
```

### 3. Key Assertions (Lean 4)
```lean
-- Assertions in test harness:
#guard (compileToQasm simpleNet p_str t_str).stmts.length > 0
#guard (compileToSnn simpleNet p_str t_str).neurons.length == 3
```

---

## Tier 2 — Property & Syntactic Verification

Ensure that compiler outputs compile successfully using reference tools and satisfy target hardware invariants.

### 1. Property Checks
- **Quantum Qreg Size**: The number of qubits allocated in `QasmProgram` must exactly equal $|P| + |T|$.
- **SNN Neuron Size**: The number of neurons allocated in `SnnNetwork` must exactly equal $|P| + \sum_{t \in T} |pre(t)| + |T|$.
- **SNN Synaptic Integrity**: Every synapse's source and target must exist in the neuron set.

### 2. Execution Command
Run the verification compiler check:
```bash
python3 scripts/validate_target_syntax.py --qasm build/output.qasm --snn build/output.json
```

---

## Tier 3 — Formal Equivalence Proof Verification

Check that the correspondence theorems are verified by the Lean 4 kernel without any axiomatic cheats (`sorryAx` or `plausible` admits).

### 1. Verification Logic
We inspect the axiom dependencies of the main theorems:
1. `qasm_transition_equivalence`
2. `snn_refinement_step`

### 2. Execution Command
We run our forensic axiom auditor:
```bash
just audit
```
Which internally executes:
```bash
lean --run scripts/audit_axioms.lean ProcInt.qasm_transition_equivalence ProcInt.snn_refinement_step
```
### 3. Assertion
Ensure that the output contains:
```text
Axioms for ProcInt.qasm_transition_equivalence: [propext, Classical.choice, Quot.sound]
Axioms for ProcInt.snn_refinement_step: [propext, Classical.choice, Quot.sound]
STATUS: SUCCESS (0 sorryAx found)
```

---

## Tier 4 — E2E Hardware Co-Simulation

Validate the compilation output by running the code in external target simulators.

### 1. Quantum Co-Simulation (OpenQASM)
We export the QASM code and execute it on the Qiskit/Aer simulator to verify step equivalence.
- **Script**: `scripts/sim_qasm.py`
- **Steps**:
  1. Map Petri Net marking $M$ to quantum state $|M\rangle$.
  2. Run the compiled OpenQASM circuit.
  3. Measure the state.
  4. Assert the measured state matches $N.fire(M, t)$ when transition $t$ is fired.

```bash
python3 scripts/sim_qasm.py --circuit build/output.qasm --initial-marking "p1:1,p2:0" --fire "t1"
```

### 2. Neuromorphic Co-Simulation (Loihi/Lava)
We export the SNN network description to JSON and simulate it step-by-step using Intel Lava or a discrete LIF emulator.
- **Script**: `scripts/sim_snn.py`
- **Steps**:
  1. Initialize membrane potentials according to $M$.
  2. Inject a input spike to trigger transition $t$.
  3. Run the SNN for 2 clock cycles (gating + feedback).
  4. Read out the place potentials.
  5. Assert they match $N.fire(M, t)$.

```bash
python3 scripts/sim_snn.py --network build/output.json --initial-marking "p1:1,p2:0" --fire "t1"
```
