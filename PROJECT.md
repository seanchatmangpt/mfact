# Project: Process Intelligence zk-SNARK Trace Verification and GPU FFI Acceleration

This project expands the `mfact` formal verification suite with two core components:
1. **Zero-Knowledge Proof (zk-SNARK) Trace Verification**: Mathematical representations and soundness/completeness proofs in Lean 4 for payload-carrying Petri nets, utilizing homomorphic multiset commitments to verify trace executions while maintaining payload confidentiality.
2. **GPU-Accelerated Theorem Proving via FFI**: Integration of Lean 4's parallel `Task` monad with native macOS (Metal) and cross-platform (CUDA) GPU solvers to offload state-equation and reachability search problems, verified locally by Lean's kernel.

---

### Architecture
```
                     +---------------------------------------+
                     |             Lean 4 Kernel             |
                     |  (Formal Proofs, Invariant Checks)    |
                     +---+---------------+---------------+---+
                         |               |               |
                         v               v               v
             +-----------+-----------+  +--------+------+  +-----+-----+
             |   zk-SNARK Verifier   |  | OpenQASM 3.0  |  | Loihi SNN |
             |   (Petri Net Trace)   |  | Compiler      |  | Exporter  |
             +-----------+-----------+  +--------+------+  +-----+-----+
                         |                       |               |
                         | (Commitments)         v (Equivalence) v (Refinement)
                         v                  Quantum State   Neuromorphic
             +-----------+-----------+      Morphisms       State Morphisms
             |  GPU Solver (Metal/   |
             |  CUDA Native Helper)  |
             +-----------------------+
```

1. **zk-SNARK Verification Layer**: We formalize data-carrying Petri nets where tokens carry data values $v \in V$ ($PMarking\ P\ V := P \to Multiset\ V$). State transitions are verified by showing the homomorphic relation on markings: $C_{M'} = C_M - C_{in} + C_{out}$ over commitment group $C$, while non-linear payload relations are proved in zero-knowledge.
2. **GPU FFI Engine**: Native FFI modules compiled into static libraries (`libmetal_prov.a` or `libcuda_prov.a`) compiled by programmable Lake configurations (`lakefile.lean`). Communication is done using flat `ByteArray` arrays.
3. **OpenQASM 3.0 Compiler**: Translates formal safe Petri Nets to OpenQASM 3.0 AST for quantum simulation/execution, mapping marking states to quantum registers and transitions to multi-controlled X gate sequences.
4. **SNN Loihi Exporter**: Translates Petri Nets to neuromorphic Spiking Neural Network (SNN) representations, mapping places to place integrator neurons and transitions to transition threshold neurons with synchronous synaptic feedback loops.
5. **Untrusted Oracle Boundary**: The GPU and hardware targets are untrusted. Any traces or state equation solutions found by target architectures are checked by the Lean kernel to guarantee that the proof standing remains certified (`PROVEN` / `PROVEN_CONDITIONALLY`).

---

## Code Layout
- `procint/ProcInt/Petri/Net.lean` (Core Petri Net definitions)
- `procint/ProcInt/Petri/Firing.lean` (Enabledness and step transitions)
- `procint/ProcInt/Petri/Reachability.lean` (Firing sequences and reachability)
- `procint/ProcInt/Petri/StateEquation.lean` (State equation theorems)
- `procint/ProcInt/Petri/ZeroKnowledge.lean` (Payload Petri nets, multiset commitments, soundness and completeness proofs)
- `procint/ProcInt/Petri/GPU.lean` (Lean FFI declarations and async Task wrappers)
- `procint/ProcInt/Petri/Qasm.lean` (OpenQASM AST, Compiler, and Equivalence proofs)
- `procint/ProcInt/Petri/Snn.lean` (SNN AST, Loihi Exporter, and Refinement proofs)
- `procint/ffi/gpu_proving.m` (Native macOS Metal compute shader implementation)
- `procint/ffi/gpu_proving.cu` (Native CUDA compute shader implementation)

---

## Milestones

| Milestone | Scope | Dependencies | Status |
|-----------|-------|--------------|--------|
| **M1: Quantum AST & Compiler** | Define OpenQASM AST and compiler from safe Petri Nets to QASM programs. | None | PLANNED |
| **M2: Quantum Equivalence Proof** | Formulate and prove the quantum state transition equivalence theorem. | M1 | PLANNED |
| **M3: SNN AST & Exporter** | Define SNN target AST and compile/export function to Loihi-compatible network. | None | PLANNED |
| **M4: SNN Correctness Proof** | Formulate and prove the SNN step-equivalence/refinement theorem. | M3 | PLANNED |
| **M5: Integration & Verification** | E2E testing of QASM & SNN compilers, run audits to ensure no `sorryAx` violations. | M2, M4 | PLANNED |

---

## Interface Contracts

### 1. zk-SNARK Relation Interface
- **Public Inputs ($x$)**:
  - `t : T` (Fired transition)
  - `C_M, C_M' : P → C` (Commitments to start and end markings)
  - `C_in, C_out : P → C` (Commitments to consumed and produced payloads)
- **Witness ($w$)**:
  - `M, M' : P → Multiset V` (Secret start and end payload markings)
  - `in_p, out_p : P → Multiset V` (Secret consumed and produced payload multisets)
  - `R_M, R_M', R_in, R_out : P → Multiset R` (Blinding randomness multisets)
- **Verifier Obligation**:
  - Check $C_{M'}(p) = C_M(p) - C_{in}(p) + C_{out}(p)$ for all $p \in P$.
  - Verify proof $\pi$ against public inputs $x$.

### 2. GPU FFI Binary Contract
- **Extern Function**:
  ```lean
  @[extern "check_state_equation_gpu_ffi"]
  opaque checkStateEquationGpu (pre : ByteArray) (post : ByteArray) (markings : ByteArray) : ByteArray
  ```
- **Byte Layout**:
  - `pre`, `post`: Contiguous 32-bit signed integers representing a flattened matrix of size $|P| \times |T|$.
  - `markings`: Contiguous 32-bit signed integers representing candidate markings.
  - `returns`: Contiguous bytes representing boolean flags (1 if state equation is solvable, 0 if not).
- **Compilation & Linkage**:
  - macOS: Linked using `-framework Metal -framework Foundation`.
  - Linux: Linked using `-L/usr/local/cuda/lib64 -lcudart`.

### 3. OpenQASM Compiler Contract
- **Compile Function**:
  ```lean
  def compileToQasm {P T : Type} [DecidableEq P] [DecidableEq T] [Fintype P] [Fintype T]
      (N : PetriNet P T) (p_str : P → String) (t_str : T → String) : QasmProgram
  ```
- **Equivalence Obligation**:
  Prove that for a 1-safe Petri net, compiling a transition and executing it on a basis state matching marking $M$ results in a basis state matching the fired marking $N.fire\ M\ t$ (if enabled) or $M$ (if disabled), with ancilla qubits uncomputed back to 0.

### 4. SNN Loihi Exporter Contract
- **Export Function**:
  ```lean
  def compileToSnn {P T : Type} [DecidableEq P] [DecidableEq T] [Fintype P] [Fintype T]
      (N : PetriNet P T) (p_str : P → String) (t_str : T → String) : SnnNetwork
  ```
- **Refinement Obligation**:
  Prove that the discrete-time execution of the exported SNN (comprising place, enablement, and transition neurons with appropriate thresholding and feedback synaptic weights) is step-equivalent to the symbolic firing of the Petri net transition.
