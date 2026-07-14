import ProcInt.MFW.TransformBasic
import ProcInt.MFW.Concurrency

namespace ProcInt.MFW

/-!
# ProcInt.MFW.Kernel

## The Transformation Kernel: Center of MFW

This module is the **center of the entire MFW project**. Every other module
(observability, fiber entropy, dimension loss, observable basis, spectrum bundle)
becomes derived mathematics once the kernel is established.

### The Crown Theorem Target

```
  τ(b₁) = τ(b₂)  ↔  b₁ ≡_{K} b₂
```

where `K` is the **POWL v2-observational kernel**: the exact equivalence relation
on PDDL 3.1 lawful behaviors that characterizes which behavioral distinctions
the transformation erases.

### Why the Kernel Must Precede Everything Else

1. **Observability** factors through the kernel: `IsObservable τ P` becomes
   "P is constant on K-equivalence classes."
2. **Fiber entropy** `S_τ(w) = log|F_w|` is the entropy of a K-class.
3. **Dimension loss** `Δd_τ` is the lost degrees of freedom within K-classes.
4. **Observable basis** generators `φ_i` are exactly the K-invariant functions.
5. **Spectrum bundle** `D⃗_q` measures how K-classes distribute over POWL v2 scale.
6. **Workflow geometry** `d_W` must use conditional measures `ν_w = ν(· | τ = w)`
   and Wasserstein distance, not fiber overlap (which is empty by `fiber_disjoint`).

Without the kernel, τ is an arbitrary classifier and every downstream object is
a named aspiration rather than a derived theorem.

### Derivation Strategy

The kernel characterization proceeds in layers:

```
Layer K1: State Equivalence
    Two behaviors are state-equivalent if they produce the same state trace
    (ignoring temporal realization).

Layer K2: Causal Equivalence
    Two behaviors are causally equivalent if they induce the same causal
    partial order on events (same dependence/independence structure).

Layer K3: Trace Equivalence (Mazurkiewicz)
    Two behaviors are trace-equivalent if they are related by adjacent
    swaps of independent actions.

Layer K4: POWL v2 Observational Kernel
    The full kernel is the coarsest equivalence refining trace equivalence
    that is also consistent with POWL v2's hierarchical factorization
    and choice-graph structure.
```

### Standing
- Definitions: DEFINITION
- Equivalence-relation structure lemmas: PROVEN
- The crown biconditional: CONJECTURAL (the entire project leads here)
-/

/-! ## State Equivalence (Layer K1)

Two behaviors are state-equivalent when they produce the same
sequence of visited states, regardless of temporal realization.
This is the finest reasonable equivalence on behaviors. -/

/-- The state trace of a lawful behavior: the sequence of states visited.
Extracted from the lawfulness proof, which guarantees the trace exists. -/
noncomputable def stateTraceOf {Th : PlanningTheory}
    (b : LawfulBehavior Th) : List Th.State :=
  Classical.choice (by
    obtain ⟨trace, _, _, _, _, _⟩ := b.lawful
    exact ⟨trace⟩)

/-- Two behaviors are state-equivalent when they visit the same state
sequence (possibly via different event orderings or temporal realizations). -/
def StateEquiv {Th : PlanningTheory}
    (b₁ b₂ : LawfulBehavior Th) : Prop :=
  stateTraceOf b₁ = stateTraceOf b₂

theorem stateEquiv_refl {Th : PlanningTheory}
    (b : LawfulBehavior Th) : StateEquiv b b := rfl

theorem stateEquiv_symm {Th : PlanningTheory}
    {b₁ b₂ : LawfulBehavior Th} (h : StateEquiv b₁ b₂) :
    StateEquiv b₂ b₁ := h.symm

theorem stateEquiv_trans {Th : PlanningTheory}
    {b₁ b₂ b₃ : LawfulBehavior Th}
    (h₁₂ : StateEquiv b₁ b₂) (h₂₃ : StateEquiv b₂ b₃) :
    StateEquiv b₁ b₃ := h₁₂.trans h₂₃

/-! ## Causal Equivalence (Layer K2)

Two behaviors are causally equivalent when they induce the same
causal dependence structure on their events. This is coarser than
state equivalence: two different event orderings producing the same
causal partial order are causally equivalent.

The causal order is extracted from the independence relation:
  `a ≺ b ⟺ a and b are dependent ∧ a occurs before b`
-/

/-- The causal order induced by a behavior under an independence relation.
For events at positions `i < j`, they are causally ordered when they are
dependent (not independent). -/
def inducedCausalOrder {Th : PlanningTheory}
    (b : LawfulBehavior Th) (I : IndependenceRelation Th.Action) :
    CausalOrder b.trace.events.length where
  prec := fun i j =>
    i.val < j.val ∧ ¬ I.independent
      (b.trace.events.get (i.cast (by omega)))
      (b.trace.events.get (j.cast (by omega)))
  irrefl := fun i ⟨hlt, _⟩ => Nat.lt_irrefl i.val hlt
  trans := fun i j k ⟨hij, _⟩ ⟨hjk, _⟩ => by
    constructor
    · exact Nat.lt_trans hij hjk
    · -- The transitivity of "dependent" requires that if i depends on j
      -- and j depends on k, then i depends on k through j.
      sorry -- Standing: CONJECTURAL — requires transitivity of dependence

/-- Two behaviors are causally equivalent under independence relation I
when they induce the same causal partial order. -/
def CausalEquiv {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b₁ b₂ : LawfulBehavior Th) : Prop :=
  ∃ (hlen : b₁.trace.events.length = b₂.trace.events.length),
  ∀ (i j : Fin b₁.trace.events.length),
    (inducedCausalOrder b₁ I).prec i j ↔
    (inducedCausalOrder b₂ I).prec
      (i.cast hlen)
      (j.cast hlen)

/-! ## Trace Equivalence Lift (Layer K3)

Lift the Mazurkiewicz trace equivalence from `Concurrency.lean` to
operate on `LawfulBehavior`. Two lawful behaviors are trace-equivalent
when their event sequences are related by adjacent swaps of independent
actions (and the resulting trace is also lawful).

This is the mathematical bridge: trace equivalence preserves lawfulness
when the independence relation is correct.
-/

/-- Lift of Mazurkiewicz trace equivalence to lawful behaviors.
Two lawful behaviors are PDDL 3.1 trace-equivalent when their event
sequences are trace-equivalent under the independence relation. -/
def PDDL31TraceEquiv {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b₁ b₂ : LawfulBehavior Th) : Prop :=
  TraceEquiv I b₁.trace.events b₂.trace.events

/-- Trace equivalence of lawful behaviors is reflexive. -/
theorem pddl31TraceEquiv_refl {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b : LawfulBehavior Th) : PDDL31TraceEquiv I b b :=
  TraceEquiv.refl _

/-- Trace equivalence of lawful behaviors is symmetric. -/
theorem pddl31TraceEquiv_symm {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    {b₁ b₂ : LawfulBehavior Th}
    (h : PDDL31TraceEquiv I b₁ b₂) : PDDL31TraceEquiv I b₂ b₁ :=
  TraceEquiv.symm _ _ h

/-- Trace equivalence of lawful behaviors is transitive. -/
theorem pddl31TraceEquiv_trans {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    {b₁ b₂ b₃ : LawfulBehavior Th}
    (h₁₂ : PDDL31TraceEquiv I b₁ b₂)
    (h₂₃ : PDDL31TraceEquiv I b₂ b₃) : PDDL31TraceEquiv I b₁ b₃ :=
  TraceEquiv.trans _ _ _ h₁₂ h₂₃

/-- **Load-bearing theorem:** Swapping adjacent independent actions in a
lawful behavior produces another lawful behavior.

This connects the algebraic independence relation to the planning-theoretic
admission law. If `I` is a correct PDDL 3.1 independence relation, then
`TemporalIndependenceWitness` guarantees that effects commute, preconditions
are stable, invariants are preserved, numeric flows are compatible, and
trajectory constraints are maintained under the swap.

  `TraceEquiv I b₁.events b₂.events → IsLawful Th b₁ → IsLawful Th b₂` -/
theorem traceSwapPreservesLawful {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b₁ b₂ : BehaviorTrace Th)
    (hEquiv : TraceEquiv I b₁.events b₂.events)
    (hLawful : IsLawful Th b₁) :
    IsLawful Th b₂ :=
  sorry -- Standing: CONJECTURAL — this is the critical bridge theorem

/-! ## POWL v2 Observational Kernel (Layer K4)

The full kernel of the transformation τ is the equivalence relation:
  `b₁ ≡_K b₂ ⟺ τ(b₁) = τ(b₂)`

The **crown theorem** of MFW is that this kernel admits a structural
characterization as the coarsest equivalence that:
1. Refines trace equivalence (same causal structure → same workflow class)
2. Is consistent with POWL v2 hierarchical factorization
3. Preserves choice-graph branching structure

The forward direction:
  `PDDL31TraceEquiv I b₁ b₂ → τ(b₁) = τ(b₂)`
says that τ respects trace equivalence.

The reverse direction:
  `τ(b₁) = τ(b₂) → b₁ ≡_K b₂`
says that τ identifies exactly the right behaviors.
-/

/-- The transformation kernel: the exact equivalence relation on PDDL 3.1
lawful behaviors induced by τ.

  `KernelEquiv τ b₁ b₂ ⟺ τ(b₁) = τ(b₂)` -/
def KernelEquiv {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b₁ b₂ : BehavioralPhaseSpace Th) : Prop :=
  τ.map b₁ = τ.map b₂

/-- The kernel equivalence is reflexive. -/
theorem kernelEquiv_refl {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) (b : BehavioralPhaseSpace Th) :
    KernelEquiv τ b b := rfl

/-- The kernel equivalence is symmetric. -/
theorem kernelEquiv_symm {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) {b₁ b₂ : BehavioralPhaseSpace Th}
    (h : KernelEquiv τ b₁ b₂) : KernelEquiv τ b₂ b₁ := h.symm

/-- The kernel equivalence is transitive. -/
theorem kernelEquiv_trans {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) {b₁ b₂ b₃ : BehavioralPhaseSpace Th}
    (h₁₂ : KernelEquiv τ b₁ b₂) (h₂₃ : KernelEquiv τ b₂ b₃) :
    KernelEquiv τ b₁ b₃ := h₁₂.trans h₂₃

/-- The kernel equivalence is definitionally equal to `transformEquiv`. -/
theorem kernelEquiv_eq_transformEquiv {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) (b₁ b₂ : BehavioralPhaseSpace Th) :
    KernelEquiv τ b₁ b₂ ↔ transformEquiv τ b₁ b₂ :=
  Iff.rfl

/-! ## Crown Theorems

### Forward Direction: τ respects trace equivalence

If two lawful behaviors are trace-equivalent (their event sequences are
related by adjacent swaps of independent actions), then they map to the
same POWL v2 workflow class.

This is the **soundness** of the transformation: accidental serialization
differences do not affect the workflow classification.

### Reverse Direction: Kernel characterization

If two lawful behaviors map to the same workflow class, then they are
related by the POWL v2 observational kernel.

This is the **completeness** of the transformation: τ does not merge
behaviors that differ in causally meaningful ways.

### The Biconditional

The crown theorem combines both directions:
  `τ(b₁) = τ(b₂) ↔ b₁ ≡_K b₂`

Once established, this single theorem anchors every downstream object:
observability becomes "constant on K-classes," fiber entropy becomes
"entropy of a K-class," and the observable basis becomes "K-invariant functions."
-/

/-- **Crown Theorem (Forward):** τ respects trace equivalence.

Trace-equivalent lawful behaviors (differing only by adjacent swaps
of independent actions) map to the same POWL v2 workflow class.

  `PDDL31TraceEquiv I b₁ b₂ → τ(b₁) = τ(b₂)`

**Proof obligation:** This requires showing that the POWL v2 construction
preserves the causal partial order and is invariant under independent
action reordering. -/
theorem tau_respects_traceEquiv {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (I : IndependenceRelation Th.Action)
    {b₁ b₂ : BehavioralPhaseSpace Th}
    (hEquiv : PDDL31TraceEquiv I b₁ b₂) :
    KernelEquiv τ b₁ b₂ :=
  sorry -- Standing: CONJECTURAL — the soundness theorem

/-- **Crown Theorem (Reverse — Partial):** The kernel refines state equivalence.

If two lawful behaviors map to the same workflow class, they have the
same state trace (same causal effects).

  `KernelEquiv τ b₁ b₂ → StateEquiv b₁ b₂`

This is a partial reverse: it says τ does not merge state-inequivalent
behaviors. The full reverse characterization is `kernel_characterization`. -/
theorem kernel_refines_stateEquiv {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    {b₁ b₂ : BehavioralPhaseSpace Th}
    (hKernel : KernelEquiv τ b₁ b₂) :
    StateEquiv b₁ b₂ :=
  sorry -- Standing: CONJECTURAL — needs τ construction to inject state trace

/-- **Crown Theorem (Biconditional):** The transformation kernel is exactly
the POWL v2 observational equivalence.

  `τ(b₁) = τ(b₂) ↔ b₁ ≡_K b₂`

where `K` is characterized structurally as trace equivalence refined by
POWL v2 hierarchical consistency.

Once this theorem is proved, every downstream MFW object becomes derived:
- Observability = constant on K-classes
- Fiber entropy = entropy of K-classes
- Dimension loss = lost DOF within K-classes
- Observable basis = K-invariant functions
- Spectrum bundle = distribution of K-class measures over POWL v2 scale -/
theorem kernel_characterization {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (I : IndependenceRelation Th.Action)
    {b₁ b₂ : BehavioralPhaseSpace Th} :
    KernelEquiv τ b₁ b₂ ↔ PDDL31TraceEquiv I b₁ b₂ :=
  sorry -- Standing: CONJECTURAL — THE CROWN THEOREM OF MFW

/-! ## Derived Objects (Previews)

Once the kernel is established, these become constructive definitions
rather than named aspirations.
-/

/-- Observable properties are exactly those constant on kernel classes.
(Preview — the full proof follows from `kernel_characterization` +
`observable_iff_fiber_constant` in `Observability.lean`.) -/
theorem observable_iff_kernel_constant {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop) :
    (∀ b₁ b₂, KernelEquiv τ b₁ b₂ → (P b₁ ↔ P b₂)) ↔
    (∀ b₁ b₂, τ.map b₁ = τ.map b₂ → (P b₁ ↔ P b₂)) :=
  Iff.rfl

/-- The information horizon is the boundary of the kernel.
A property crosses the horizon (is hidden) exactly when it
distinguishes behaviors within the same kernel class. -/
def crossesHorizon {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop) : Prop :=
  ∃ b₁ b₂, KernelEquiv τ b₁ b₂ ∧ P b₁ ∧ ¬ P b₂

/-! ## Workflow Geometry via Conditional Measures

**Audit discovery:** The Jaccard fiber metric is mathematically killed by
`fiber_disjoint`: for distinct classes, `J(F_{w₁}, F_{w₂}) = 0`, so the
proposed "behavior-induced geometry" collapses to the discrete metric.

**Repair:** The correct construction uses conditional fiber measures and
optimal transport.

Given a metric `d_P` on the PDDL 3.1 behavioral phase space, define
conditional measures `ν_w = ν(· | τ = w)` and then:
  `d_W(w₁, w₂) = W_p(ν_{w₁}, ν_{w₂})`
using Wasserstein distance.

Fibers are disjoint as sets, but their behavior distributions may be
geometrically close in the PDDL phase space metric. That is the
collider/optimal-transport construction.
-/

/-- A metric on the behavioral phase space. -/
structure BehaviorMetric (Th : PlanningTheory) where
  dist : BehavioralPhaseSpace Th → BehavioralPhaseSpace Th → ℝ
  dist_self : ∀ b, dist b b = 0
  dist_symm : ∀ b₁ b₂, dist b₁ b₂ = dist b₂ b₁
  dist_nonneg : ∀ b₁ b₂, 0 ≤ dist b₁ b₂
  dist_triangle : ∀ b₁ b₂ b₃, dist b₁ b₃ ≤ dist b₁ b₂ + dist b₂ b₃

/-- The Wasserstein-induced workflow metric.
  `d_W(w₁, w₂) = inf over couplings of 𝔼[d_P(b₁, b₂)]`
where the infimum is over all joint distributions with marginals ν_{w₁}, ν_{w₂}.

Placeholder: the actual optimal transport construction requires measure theory
beyond this module's scope. -/
noncomputable def wassersteinWorkflowDist {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (d : BehaviorMetric Th)
    (w₁ w₂ : WorkflowSpace α) : ℝ :=
  sorry -- Standing: CONJECTURAL — requires Mathlib MeasureTheory.OptimalTransport

/-! ## Non-Circularity Proof

### Theorem-Design Test

The crown biconditional:
  `KernelEquiv τ b₁ b₂ ↔ PDDL31TraceEquiv I b₁ b₂`
is **non-circular** because its two sides are independently defined
from different mathematical objects.

**Left side** — defined in this file from the *transformation codomain*:
```
  KernelEquiv τ b₁ b₂ := τ.map b₁ = τ.map b₂
```
This unfolds to equality in `WorkflowSpace α = POWLv2Object α`.
It requires only `τ` and the POWL v2 equality. No reference to
independence, swaps, traces, or Mazurkiewicz.

**Right side** — defined in `Concurrency.lean` from *PDDL 3.1 behavioral semantics*:
```
  PDDL31TraceEquiv I b₁ b₂ := TraceEquiv I b₁.trace.events b₂.trace.events
```
which unfolds to the reflexive-symmetric-transitive closure of adjacent
swaps of I-independent actions. It requires only `I : IndependenceRelation`
and the event sequences. No reference to `τ`, `WorkflowSpace`, or POWL v2.

**Proof of independence:**
- `KernelEquiv` does not mention `IndependenceRelation` or `TraceEquiv`.
- `PDDL31TraceEquiv` does not mention `WorkflowTransformation` or `WorkflowSpace`.
- The two definitions live in different files with different imports.
- Neither definition was manufactured from the other.

**Therefore:** The biconditional `KernelEquiv τ ↔ PDDL31TraceEquiv I` connects
two independently specified equivalence relations. If proved, it says:

> The POWL v2 transformation τ identifies exactly those PDDL 3.1 behaviors
> that differ only by commutation of independent actions.

That is an extraordinary structural correspondence, not a definitional unfolding.

### What it would mean

  `ker(τ) = TraceEq_I`

The left side belongs to the transformation. The right to PDDL 3.1 semantics.
The theorem proves they meet. Every downstream MFW object inherits this.
-/

-- The following two lemmas witness non-circularity by exhibiting that
-- each side can be stated without the other's vocabulary.

/-- `KernelEquiv` unfolds without mentioning independence or traces.
This witnesses that the left side of the crown biconditional is
defined purely from the transformation τ. -/
theorem kernelEquiv_unfolds_without_traces {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b₁ b₂ : BehavioralPhaseSpace Th) :
    KernelEquiv τ b₁ b₂ = (τ.map b₁ = τ.map b₂) := rfl

/-- `PDDL31TraceEquiv` unfolds without mentioning τ or WorkflowSpace.
This witnesses that the right side of the crown biconditional is
defined purely from PDDL 3.1 behavioral semantics. -/
theorem traceEquiv_unfolds_without_tau {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b₁ b₂ : LawfulBehavior Th) :
    PDDL31TraceEquiv I b₁ b₂ = TraceEquiv I b₁.trace.events b₂.trace.events := rfl

/-! ## Fiber = Trace Class Identity

**This is the first major theorem after `kernel_characterization`.**

If `ker(τ) = TraceEq_I`, then:
  `F_{τ(b)} = [b]_{TraceEq_I}`

The fiber of a workflow class is exactly the Mazurkiewicz trace class
of any behavior in that fiber.

This immediately rewrites all fiber-based quantities:
- Fiber entropy becomes trace-class entropy
- Fiber cardinality becomes trace-class cardinality
- Fiber-constant observables become trace-invariant functions
-/

/-- The trace class of a behavior under independence I:
  `[b]_I = {b' | PDDL31TraceEquiv I b b'}` -/
def traceClass {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b : LawfulBehavior Th) : Set (BehavioralPhaseSpace Th) :=
  {b' | PDDL31TraceEquiv I b b'}

/-- **Fiber = Trace Class.** Under `kernel_characterization`:
  `F_{τ(b)} = [b]_{TraceEq_I}` as sets.

Proof strategy: unfold both sides.
  `F_{τ(b)} = {b' | τ(b') = τ(b)}`           — by definition of fiber
  `[b]_I    = {b' | TraceEquiv I b b'}`       — by definition of traceClass
  `kernel_characterization : τ(b') = τ(b) ↔ TraceEquiv I b b'` — the crown

Then extensionality. -/
theorem fiber_eq_traceClass {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (I : IndependenceRelation Th.Action)
    (b : BehavioralPhaseSpace Th)
    (hKernel : ∀ b₁ b₂ : BehavioralPhaseSpace Th,
      KernelEquiv τ b₁ b₂ ↔ PDDL31TraceEquiv I b₁ b₂) :
    fiber τ (τ.map b) = traceClass I b := by
  ext b'
  simp only [fiber, traceClass, Set.mem_setOf_eq, KernelEquiv] at *
  exact (hKernel b' b).trans ⟨pddl31TraceEquiv_symm I, pddl31TraceEquiv_symm I⟩

/-! ## Trace Class ≅ Linear Extensions

**This is the key bijection.**

For a behavior `b` with induced causal order `P_b`, the trace class
`[b]_I` should correspond bijectively to the linear extensions of `P_b`:
  `[b]_{TraceEq_I} ≅ Lin(P_b)`

Under exact hypotheses:
1. Finite event set
2. Fixed event multiplicity (each action occurs exactly once —
   the action set forms an antichain in multiplicity)
3. Trace equivalence exactly generated by adjacent independent swaps
4. Causal order faithfully represents dependence
5. Linear extensions correspond bijectively to trace-class representatives

If this closes:
  `|[b]_I| = |Lin(P_b)| = e(P_b)`

And therefore:
  `S_τ(τ(b)) = log|[b]_I| = log e(P_b) = H_ser(P_b)`

**Fiber entropy = Serialization entropy.**
-/

/-- Hypotheses required for the trace-class / linear-extension bijection.
These are the exact conditions under which the bijection holds. -/
structure TraceClassBijectionHypotheses {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b : LawfulBehavior Th) where
  /-- Events are distinct (each action appears at most once). -/
  events_distinct : b.trace.events.Nodup
  /-- The independence relation is decidable. -/
  indep_decidable : DecidableRel I.independent
  /-- Independence is the exact complement of causal dependence:
      `I.independent a₁ a₂ ↔ ¬ depend a₁ a₂` for some dependence `depend`. -/
  independence_exact : ∀ a₁ a₂,
    I.independent a₁ a₂ ↔ ¬ (∃ s, ∃ (h₁ : (Th.transition s a₁).isSome)
      (h₂ : (Th.transition s a₂).isSome),
        Th.transition ((Th.transition s a₁).get h₁) a₂ ≠
        Th.transition ((Th.transition s a₂).get h₂) a₁)

/-- **Target Bijection:** Trace class ≅ Linear extensions.

Under the bijection hypotheses:
  `[b]_{TraceEq_I} ≃ Lin(P_b)`

where `P_b` is the causal order induced by `b` under `I`.

Standing: CONJECTURAL — this is a known result in concurrency theory
(Mazurkiewicz 1977, Diekert & Rozenberg 1995) but needs explicit
formalization under PDDL 3.1 semantics.
-/
theorem traceClass_equiv_linearExtensions {Th : PlanningTheory}
    (I : IndependenceRelation Th.Action)
    (b : LawfulBehavior Th)
    (hyp : TraceClassBijectionHypotheses I b) :
    ∃ (f : traceClass I b → {σ : Equiv.Perm (Fin b.trace.events.length) //
           IsLinearExtension (inducedCausalOrder b I) σ}),
      Function.Bijective f :=
  sorry -- Standing: CONJECTURAL — the bijection theorem
         -- Reference: Mazurkiewicz trace theory, Diekert & Rozenberg 1995

/-! ## Entropy Collapse

**The decisive question:** Does `FiberEntropy = SerializationEntropy`?

If `fiber_eq_traceClass` and `traceClass_equiv_linearExtensions` both hold:

  `S_τ(τ(b)) = log|F_{τ(b)}|`      — fiber entropy definition
             `= log|[b]_I|`         — fiber = trace class
             `= log|Lin(P_b)|`      — bijection
             `= log e(P_b)`         — linear extension count
             `= H_ser(P_b)`         — serialization entropy definition

**FiberEntropy = SerializationEntropy** under:
1. `kernel_characterization` (crown theorem)
2. `traceClass_equiv_linearExtensions` (bijection)
3. Finite trace classes

This would be proof-first factorization eliminating a redundant
mathematical object. Two independently derived quantities collapse
into one theorem.

The conditions matter:
- Finite occurrence set ✓ (PDDL plans are finite)
- Fixed event multiplicity ✓ (ground actions)
- Trace equivalence exactly generated by adjacent independent swaps ✓
- Causal order faithfully representing dependence (hypothesis)
- Linear extensions corresponding bijectively to trace-class representatives (theorem)

If `FiberEntropy = SerializationEntropy`, then `D_q^{Entropic}` may equal
`D_q^{Linearization}` under some admitted profile. The kernel will have
reduced the spectrum basis before we constructed it.
-/

/-- **Entropy Collapse Theorem Target.** Under the bijection hypotheses:
  `log|F_{τ(b)}| = H_ser(P_b)`

Fiber entropy equals serialization entropy. -/
theorem fiberEntropy_eq_serializationEntropy {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (I : IndependenceRelation Th.Action)
    (b : BehavioralPhaseSpace Th)
    (hKernel : ∀ b₁ b₂ : BehavioralPhaseSpace Th,
      KernelEquiv τ b₁ b₂ ↔ PDDL31TraceEquiv I b₁ b₂)
    (hyp : TraceClassBijectionHypotheses I b)
    [DecidableRel (inducedCausalOrder b I).prec] :
    -- fiber entropy = serialization entropy
    -- log|F_{τ(b)}| = log e(P_b)
    True := -- Standing: CONJECTURAL — placeholder for the real statement
  sorry -- Standing: CONJECTURAL
        -- The real statement needs fiberCardinality and serializationEntropy
        -- to be computable on the same finite domain.
        -- The proof chains: fiber_eq_traceClass → bijection → cardinality → log.

/-! ## Kernel Generators

**Proof-first spectrum derivation.**

Do not start with seven measure names. Derive independent erasure modes
from `ker(τ)`.

If `KernelEquiv` is an equivalence closure generated by primitive
distinction-erasing moves, then each generator type corresponds to
an independent information-erasure mode.

Suppose:
  `ker(τ) = EqClosure({g_trace, g_choice, g_hierarchy, ...})`

Each generator erases a different kind of behavioral distinction.
The natural spectrum basis comes from measuring how each generator
contributes to the kernel.
-/

/-- Primitive kernel generators: the elementary distinction-erasing moves
that generate the kernel equivalence.

Each generator type corresponds to an independent mode of information
erasure by the transformation τ. -/
inductive KernelGenerator : Type
  | traceSwap           -- adjacent swap of independent actions
  | choiceNormalization  -- POWL v2 choice-graph equivalence
  | hierarchyCollapse    -- hierarchical submodel aggregation
  | temporalAbstraction  -- metric time → interval/causal time
  deriving Repr, DecidableEq

/-- A kernel path: a sequence of generator applications connecting
two kernel-equivalent behaviors.
  `b₁ →[g₁] b' →[g₂] ⋯ →[gₙ] b₂` -/
structure KernelPath {Th : PlanningTheory}
    (b₁ b₂ : LawfulBehavior Th) where
  /-- The sequence of generators applied. -/
  generators : List KernelGenerator
  /-- The intermediate behaviors. -/
  intermediates : List (LawfulBehavior Th)
  /-- Path length consistency. -/
  length_match : intermediates.length = generators.length + 1
  /-- Path endpoints. -/
  starts_at : intermediates.head? = some b₁
  ends_at : intermediates.getLast? = some b₂

/-- The generator count vector of a kernel path:
  `κ(path) = (n_trace, n_choice, n_hierarchy, n_temporal)` -/
def KernelPath.generatorCount {Th : PlanningTheory}
    {b₁ b₂ : LawfulBehavior Th}
    (path : KernelPath b₁ b₂)
    (g : KernelGenerator) : Nat :=
  path.generators.filter (· == g) |>.length

/-- **Kernel Generator Theorem Target.** The kernel equivalence is exactly
the equivalence closure of the primitive generators.

  `KernelEquiv τ b₁ b₂ ↔ ∃ path : KernelPath b₁ b₂, True`

If this holds, the kernel generators determine:
1. Which information erasure modes are independent
2. What the natural spectrum basis is (one D_q per independent generator)
3. Whether proposed measures (behavioral, temporal, etc.) are redundant
-/
theorem kernel_generated {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    {b₁ b₂ : BehavioralPhaseSpace Th}
    (hKernel : KernelEquiv τ b₁ b₂) :
    ∃ path : KernelPath b₁ b₂, True :=
  sorry -- Standing: CONJECTURAL — the generator decomposition theorem

/-- **Spectrum Basis Derivation.** Independent kernel generators yield
independent spectrum coordinates.

If generators g_i and g_j are independent (no g_i path can be rewritten
as a g_j path), then D_q^{g_i} and D_q^{g_j} are independent spectra.

This is the proof-first alternative to declaring seven measure kinds
by enumeration. The kernel tells us what spectra exist. -/
def independentGenerators (gs : List KernelGenerator) : Prop :=
  gs.Nodup ∧ gs.length ≤ 4 -- at most 4 independent generators

end ProcInt.MFW
