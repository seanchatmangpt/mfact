import ProcInt.MFW.TransformBasic
import ProcInt.MFW.Concurrency
import ProcInt.MFW.Kernel
import ProcInt.MFW.Observability
import ProcInt.MFW.FiberEntropy
import ProcInt.MFW.IntrinsicDimension
import ProcInt.MFW.ObservableBasis
import ProcInt.MFW.SpectrumBundle
import ProcInt.MFW.Manufacture
import ProcInt.MFW.ExploreExploit
import ProcInt.MFW.Falsification
import ProcInt.MFW.CompilerPipeline
import ProcInt.MFW.Ledger

/-!
# ProcInt.MFW — Multi Fractal Workflow

## Transformation Information Geometry (v2 — Post-Audit)

Multi Fractal Workflow studies the multiscale distribution of PDDL 3.1 lawful
behavioral measures over the hierarchical behavior classes induced by POWL v2
transformation.

### The Central Formal Object

  `τ : (P_{PDDL 3.1}, d_P, ν) → (W_{POWL v2}, d_W, τ_*ν)`

### The Crown Theorem (in `Kernel.lean`)

  `τ(b₁) = τ(b₂) ↔ b₁ ≡_K b₂`

Once the kernel is characterized, every downstream object becomes derived:
- Observability = constant on K-classes
- Fiber entropy = entropy of K-classes
- Dimension loss = lost DOF within K-classes
- Observable basis = K-invariant functions
- Spectrum bundle = distribution of K-class measures over POWL v2 scale
- Workflow geometry = Wasserstein distance over conditional fiber measures

### Module Map (Dependency Order)

| Layer | Module | Status |
|-------|--------|--------|
| 0–4 | `TransformBasic` | v2: LawfulBehavior carries proof, WorkflowSpace wraps Powl, MeasureKind has 7 kinds |
| Bridge | `Concurrency` | v1: Independence, Mazurkiewicz traces, serialization entropy |
| **CENTER** | **`Kernel`** | **v1: Crown biconditional, state/causal/trace equiv layers, Wasserstein geometry** |
| 5 | `Observability` | v1: Needs downstream update to new TransformBasic types |
| 6 | `FiberEntropy` | v1: Needs η(w) = p(w)·log|F_w| additive construction |
| 7 | `IntrinsicDimension` | v1: BLOCKED — needs rebuild from geometric structure |
| 8 | `ObservableBasis` | v1: Needs downstream update to new TransformBasic types |
| 9 | `SpectrumBundle` | v1: Needs rebuild as derived object, not arbitrary function |

### Audit-Discovered Falsifiers (2026-07-14)

1. **Jaccard fiber metric is impossible:** `fiber_disjoint` proves
   `F_{w₁} ∩ F_{w₂} = ∅` for `w₁ ≠ w₂`, so `J(F_{w₁}, F_{w₂}) = 0`
   and the proposed geometry collapses to the discrete metric.
   **Repair:** Wasserstein distance over conditional fiber measures.

2. **Fiber entropy ≠ temporal slack:** These are orthogonal measures.
   `MeasureKind` now has 7 kinds including `.entropic`.

3. **The kernel must precede the spectrum:** Without `kernel_characterization`,
   τ is an arbitrary classifier and every downstream object is a named
   aspiration.

4. **`SpectrumBundle` cannot be constructed directly:** It must be
   manufactured from admitted measure + scale + fit evidence.
-/
