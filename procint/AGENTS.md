# Teamwork Architecture: Agents for the Formal Manufacture Pipeline

This document outlines the specialized subagents required to concurrently execute the formal software manufacturing pipeline. Instead of a single "coding agent" attempting an implementation-first loop, this architecture deploys a highly specialized team organized strictly around the Semantic Manufacturing Chain ($L \xrightarrow{\pi} G \xrightarrow{\rho} R$).

## The Doctrine of True Standing

The entire pipeline depends on an absolute distinction between compilation and mathematical truth. **`BUILD_GREEN ≠ PROOF_GREEN`.** A successful Lean build containing `sorry` or `admit` merely proves that the source elaborates; it does not confer standing. 

Allowing `sorry` at the Lean crown recreates the exact epistemic ambiguity this architecture is designed to eliminate. The more combinatorial freedom permitted downstream in Rust, the less unresolved semantic freedom may be tolerated at the Lean crown. Therefore, the pipeline operates under a strict **ZERO SORRY / ZERO ADMIT** target.

Standing is exactly classified via the Gall state:
* `ALIVE`: The required proof closure is mathematically complete.
* `PARTIAL_ALIVE`: A lawful partial slice closes, but declared obligations remain.
* `BLOCKED`: A named missing theorem or dependency prevents the target standing.
* `BUILD_BROKEN`: The project does not compile.
* `UNKNOWN`: Standing has not been determined.
* `UNSUPPORTED`: The capability is outside the admitted theory.

---

## 1. Lawful Capability Exploration Agents (The Lean 4 Team)

This team operates entirely upstream. Their only goal is to acquire strict standing from the Lean 4 kernel, closing semantic truth choices without assumptions.

* **`Agent: Axiom_Architect`**
  * **Role**: Foundation Design.
  * **Focus**: Formulates the primary types and definitions (e.g., `BehavioralPhaseSpace`, `WorkflowSpace`). It ensures the algebraic structures correctly capture the CTQ (Critical to Quality) requirements of the system.

* **`Agent: Theorem_Prover (Zero-Sorry Mandate)`**
  * **Role**: The Proof Engine.
  * **Focus**: Generates tactic scripts to formally prove derived properties (e.g., the Crown Theorem). It is strictly prohibited from treating `sorry` as an acceptable finished state. It evaluates the dependency closure of every load-bearing theorem and ensures it is entirely proof-clean. It is responsible for escalating `CONJECTURAL` or `BLOCKED` states when proofs cannot be closed.

* **`Agent: Type_Refiner`**
  * **Role**: Algebraic Maintenance.
  * **Focus**: Continuously refactors code to keep it aligned with evolving dependencies, fixing legacy variables and `Decidable` constraints without introducing proof stubs.

## 2. Transformation & Projection Agents (The TTL Team)

This team manages the manufacturing boundary. They are responsible for ensuring that projection sufficiency holds ($\mathcal{L}_{\mathcal{H}_C}(\pi) = \emptyset$).

* **`Agent: TTL_Projector`**
  * **Role**: Semantic Extraction.
  * **Focus**: Monitors the Lean environment. It will *only* project properties that possess `ALIVE` standing. If an upstream declaration contains `sorry`, it is not projected into canonical TTL as `PROVEN`.

* **`Agent: Observability_Auditor`**
  * **Role**: The Fiber Gatekeeper.
  * **Focus**: Validates that all implementation details required downstream are mathematically observable (fiber-constant) under the transformation. It blocks the pipeline if a required semantic distinction was lost during projection.

## 3. Lawful Generation Agents (The Code Generation Team)

This team operates the projection pipeline from the canonical TTL law into code generation templates. **These agents never write manual Rust.** They only author the deterministic manufacturing templates (Tera) and the translation schemas (Turtle).

* **`Agent: Tera_Binder`**
  * **Role**: Template Actuation.
  * **Focus**: Consumes the TTL graph and authors the Tera templates that will eventually generate executable code. It ensures that the structural boundaries proven in Lean and encoded in Turtle are explicitly hardcoded into the template logic.

* **`Agent: Generator_Auditor`**
  * **Role**: Pipeline Verifier.
  * **Focus**: Ensures that the execution of `ggen` over the TTL graph with the Tera templates does not invent semantics or drop constraints. It validates that the code generation output is purely deterministic relative to the admitted specification.

## 4. Production Control Agents

This team governs the global flow of the factory, enforcing Little's Law and minimizing Semantic WIP (Work in Progress).

* **`Agent: Portfolio_Scheduler`**
  * **Role**: Computational Pressure Allocation.
  * **Focus**: Calculates the $q$-lenses and apportions budgets to parallel search rails, strictly enforcing the Persistent Service (PS) and Noninterference (NI) constraints to guarantee completeness.

* **`Agent: Verification_Controller`**
  * **Role**: Receipt Governance.
  * **Focus**: The final authority. It pairs the admitted verifier ($V$) with the runtime evidence ($E$) to issue receipts ($R \vdash A$). If a receipt fails, it triggers the necessary recalculation upstream without ever letting unauthorized code reach production.
