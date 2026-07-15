import Mathlib

namespace ProcInt.MFW

/-!
# ProcInt.MFW.Concurrency

## Concurrency Theory: Independence, Traces, and Serialization Entropy

This module formalizes the concurrency-theoretic bridge between PDDL 3.1
temporal transition semantics and POWL v2 causal-concurrent workflow semantics.

### The Core Question

The PDDL 3.1 → POWL v2 transformation is fundamentally a **causal constraint
erasure**: remove every ordering distinction not forced by planning truth.

A total-order plan contains too much order. POWL v2 is the quotient produced
by erasing accidental chronology.

### Derivation Chain

```
  FiniteTemporalTransitionSystem
          ↓
  DurativeEventExpansion
          ↓
  TemporalConstraintTheory
          ↓
  TemporalClosure
          ↓
  SemanticDependence
          ↓
  IndependenceRelation
          ↓
  TraceEquivalence (Mazurkiewicz)
          ↓
  CausalPartialOrder
          ↓
  TemporalFeasibility
          ↓
  ConcurrencyComplex
          ↓
  POWLFactorization
```

### Standing
- Structural definitions: DEFINITION
- Algebraic lemmas (commutativity, closure): PROVEN where possible
- Topological claims (homology, persistent coordinates): CONJECTURAL
-/

/-! ## Independence Relation

Two actions commute when their effects and preconditions do not interact.
The algebraic question: `δ_b(δ_a(s)) = δ_a(δ_b(s))` under the admitted
state domain.

For PDDL 3.1 temporal planning, independence requires:
1. EffectsCommute(a, b)
2. PreconditionStable(a, b)
3. InvariantStable(a, b)
4. NumericFlowCompatible(a, b)
5. TrajectoryConstraintsPreserved(a, b)
-/

/-- An independence relation I ⊆ A × A on an action type.
Two actions are independent when they commute under state transition. -/
structure IndependenceRelation (Action : Type) where
  /-- The independence predicate. -/
  independent : Action → Action → Prop
  /-- Independence is symmetric: if a is independent of b, then b is
      independent of a. -/
  symm : ∀ a b, independent a b → independent b a

/-- The five components required for PDDL 3.1 temporal independence. -/
structure TemporalIndependenceWitness (Action State : Type) where
  /-- Effects of a and b commute: applying a then b yields the same state
      as applying b then a. -/
  effectsCommute : Action → Action → State → Prop
  /-- Preconditions of a are not destroyed by b and vice versa. -/
  preconditionStable : Action → Action → State → Prop
  /-- Over-all invariants of a are not violated during b's execution. -/
  invariantStable : Action → Action → Prop
  /-- Numeric fluent changes are compatible (no concurrent overspend). -/
  numericFlowCompatible : Action → Action → Prop
  /-- Trajectory constraints are preserved under reordering. -/
  trajectoryPreserved : Action → Action → Prop

/-- The dependence relation D = (A × A) \ I.
Two actions are dependent when they are NOT independent. -/
def dependenceRelation {Action : Type} (I : IndependenceRelation Action) :
    Action → Action → Prop :=
  fun a b => ¬ I.independent a b

/-! ## Trace Equivalence (Mazurkiewicz Traces)

Given independence relation I, two sequences commute when adjacent
independent actions are swapped:
  `u·a·b·v ~_I u·b·a·v` whenever `(a, b) ∈ I`

The equivalence closure gives Mazurkiewicz traces. Partial-order semantics
and trace semantics are deeply connected: traces correspond to partial
orders of transition occurrences.

**The optimization**: suppose n independent actions exist. Sequence semantics
sees n! linearizations. Trace quotient sees 1 concurrency class. Therefore:

  PDDL → POWL may be factorial state-space compression by quotienting
  interleavings.

The stronger claim: POWL is a candidate normal form for equivalence classes
of lawful plan interleavings.
-/

/-- A trace is a sequence of actions considered up to commutation of
adjacent independent pairs. We represent it as the underlying list
together with the independence relation that defines the equivalence. -/
structure Trace (Action : Type) where
  /-- The underlying action sequence. -/
  sequence : List Action
  /-- The independence relation defining commutation. -/
  indep : IndependenceRelation Action

/-- Two traces are equivalent when one can be obtained from the other
by a finite sequence of adjacent-independent-pair swaps. -/
inductive TraceEquiv {Action : Type} (I : IndependenceRelation Action) :
    List Action → List Action → Prop
  | refl (s : List Action) : TraceEquiv I s s
  | swap (pre : List Action) (a b : Action) (suf : List Action)
      (h : I.independent a b) :
      TraceEquiv I (pre ++ [a, b] ++ suf) (pre ++ [b, a] ++ suf)
  | trans (s₁ s₂ s₃ : List Action) :
      TraceEquiv I s₁ s₂ → TraceEquiv I s₂ s₃ → TraceEquiv I s₁ s₃
  | symm (s₁ s₂ : List Action) :
      TraceEquiv I s₁ s₂ → TraceEquiv I s₂ s₁

/-- Trace equivalence is an equivalence relation. -/
theorem traceEquiv_equivalence {Action : Type} (I : IndependenceRelation Action) :
    Equivalence (TraceEquiv I) :=
  ⟨TraceEquiv.refl, fun h => TraceEquiv.symm _ _ h, fun h₁ h₂ => TraceEquiv.trans _ _ _ h₁ h₂⟩

/-! ## Causal Partial Order

The POWL partial order is derived from the dependence relation.

Given a valid temporal plan (total order), seek the **least causal relation**
sufficient to preserve correctness:

  `R* = arg min_R |R|` subject to `Lin(E, R) ⊆ Valid(Π)`

where `Lin(E, R)` is the set of linear extensions of the partial order.

This is **Causal Constraint Erasure**: remove every ordering distinction
not forced by planning truth.
-/

/-- A causal partial order extracted from a plan trace.
The precedence `prec i j` means event i must causally precede event j.
This is the minimal order preserving plan validity. -/
structure CausalOrder (n : Nat) where
  /-- Precedence relation on event indices. -/
  prec : Fin n → Fin n → Prop
  /-- Irreflexivity. -/
  irrefl : ∀ i, ¬ prec i i
  /-- Transitivity. -/
  trans : ∀ i j k, prec i j → prec j k → prec i k

/-- A linear extension of a causal order: a total order compatible with it. -/
def IsLinearExtension {n : Nat} (co : CausalOrder n) (σ : Fin n → Fin n) : Prop :=
  Function.Bijective σ ∧ ∀ i j, co.prec i j → σ i < σ j

open Classical in
/-- Count of linear extensions for a finite causal order.
This measures the number of total serializations compatible with the
causal structure. -/
noncomputable def linearExtensionCount {n : Nat} (co : CausalOrder n) : Nat :=
  Finset.card (Finset.univ.filter (fun σ : Equiv.Perm (Fin n) => IsLinearExtension co σ))

/-! ## Serialization Entropy

Given poset `P = (E, ≺)`, let `e(P) = |Lin(P)|`. Define:
  `H_ser(P) = log e(P)`

**Serialization Entropy** measures how much accidental sequential
distinction the transformation removes.

- `H_ser = 0` means `e(P) = 1`: the process is totally forced.
- Large `H_ser` means many total serializations correspond to the
  same causal object.

The PDDL → POWL transformation has measurable distinction-erasure gain:
  `G_POWL = log(|linear plan representations| / |causal workflow classes|)`

For one concurrency class represented by `e(P)` linearizations:
  `G(P) = log e(P)`

### Temporal Serialization Entropy

Not all linear extensions are temporally feasible. Define:
  `Lin_T(P, N) = {ℓ ∈ Lin(P) : ℓ admits a schedule satisfying N}`

Then:
  `H_T(P, N) = log|Lin_T(P, N)|`

The difference `H_ser(P) - H_T(P, N)` measures how much apparent causal
concurrency is removed by metric temporal restrictions.

This is exactly why time cannot be omitted from the formalization.
-/

/-- Serialization entropy of a causal order: `H_ser = log(linearExtensionCount)`.
Measures the information content of accidental serialization. -/
noncomputable def serializationEntropy {n : Nat} (co : CausalOrder n)
    [DecidableRel co.prec] : ℝ :=
  Real.log (linearExtensionCount co)

/-- A temporal constraint system associates time-point variables
with difference-bound constraints: `l_ij ≤ t_j - t_i ≤ u_ij`. -/
structure SimpleTemporalNetwork (n : Nat) where
  /-- Lower bound on time difference t_j - t_i. -/
  lower : Fin n → Fin n → ℝ
  /-- Upper bound on time difference t_j - t_i. -/
  upper : Fin n → Fin n → ℝ
  /-- Bounds are well-ordered. -/
  bounds_wf : ∀ i j, lower i j ≤ upper i j

/-- Temporal serialization entropy: entropy of temporally feasible
linear extensions only.
  `H_T(P, N) = log|Lin_T(P, N)|` -/
opaque temporalSerializationEntropy {n : Nat}
    (co : CausalOrder n) (stn : SimpleTemporalNetwork n)
    [DecidableRel co.prec] : ℝ

/-- The temporal restriction gap: how much apparent causal concurrency
is removed by metric temporal constraints.
  `H_ser(P) - H_T(P, N) ≥ 0` -/
noncomputable def temporalRestrictionGap {n : Nat}
    (co : CausalOrder n) (stn : SimpleTemporalNetwork n)
    [DecidableRel co.prec] : ℝ :=
  serializationEntropy co - temporalSerializationEntropy co stn

/-! ## Concurrency Width and Antichain Structure

For a partial order `P = (E, ≺)`, define the width:
  `w(P) = max{|A| : A ⊆ E, A is an antichain}`

By Dilworth's theorem, width equals the minimum number of chains
needed to cover E.

An antichain is a set of pairwise incomparable events, so `w(P)`
is an immediate concurrency coordinate. But one scalar is too weak.

We need local antichain structure over workflow regions or scales,
leading to concurrency mass distributions and ultimately to
multifractal analysis of concurrency.
-/

/-- An antichain in a causal order: a set of pairwise incomparable events. -/
def IsAntichain {n : Nat} (co : CausalOrder n) (A : Finset (Fin n)) : Prop :=
  ∀ i ∈ A, ∀ j ∈ A, i ≠ j → ¬ co.prec i j ∧ ¬ co.prec j i

/-- Width of a causal order: the maximum antichain size.
This is the primary concurrency coordinate. -/
noncomputable def causalWidth {n : Nat} (co : CausalOrder n)
    [DecidablePred (IsAntichain co)] : Nat :=
  Finset.sup (Finset.univ.powerset.filter (IsAntichain co)) Finset.card

/-! ## Concurrency Complex

The concurrency complex `K_Π = {A ⊆ E : A is jointly concurrent}`
is the collection of all sets of events that can coexist under the
temporal/state laws.

If downward closed: `A ∈ K, B ⊆ A ⟹ B ∈ K`, then K is an abstract
simplicial complex. This means concurrency itself has topology.

Then `H_k(K_Π)` (simplicial homology) becomes meaningful, and
persistent homology can analyze concurrency as temporal or constraint
thresholds vary.

### The Research Question

The transformation `PDDL → ConcurrencyComplex → POWL` may be
selecting a hierarchical representation of this complex. And
persistent homology can reveal which concurrency structures persist
across tolerance thresholds.

**Falsifier**: The concurrency complex thesis fails if the complex
is trivially contractible for all admitted planning theories.
-/

/-- An abstract simplicial complex over a finite event set.
A family of subsets closed under taking subsets. -/
structure SimplicialComplex (n : Nat) where
  /-- The faces of the complex: subsets of events. -/
  faces : Finset (Finset (Fin n))
  /-- Downward closure: every subset of a face is a face. -/
  downward_closed : ∀ A ∈ faces, ∀ B, B ⊆ A → B ∈ faces
  /-- Empty set is a face. -/
  empty_mem : ∅ ∈ faces

/-- The concurrency complex K_Π: all subsets of events that can
coexist (are jointly concurrent) under the planning theory.

**Audit repair:** The previous version accepted an arbitrary predicate
and sorry'd the downward-closure and empty-membership proofs. But those
don't follow for arbitrary predicates (e.g. `concurrent(A) ↔ |A|=2`
violates downward closure). Now requires these as admission hypotheses. -/
def concurrencyComplex {n : Nat} (_co : CausalOrder n)
    (concurrent : Finset (Fin n) → Prop) [DecidablePred concurrent]
    (h_downward : ∀ A, concurrent A → ∀ B, B ⊆ A → concurrent B)
    (h_empty : concurrent ∅) : SimplicialComplex n where
  faces := Finset.univ.powerset.filter concurrent
  downward_closed := by
    intro A hA B hB
    simp only [Finset.mem_filter, Finset.mem_powerset] at hA ⊢
    exact ⟨Finset.Subset.trans hB hA.1, h_downward A hA.2 B hB⟩
  empty_mem := by
    simp only [Finset.mem_filter, Finset.mem_powerset]
    exact ⟨Finset.empty_subset _, h_empty⟩

/-- The dimension of the concurrency complex: the maximum face size minus 1.
A higher dimension means larger sets of events can be simultaneously active. -/
noncomputable def concurrencyDimension {n : Nat} (K : SimplicialComplex n) : Int :=
  (Finset.sup K.faces Finset.card : ℕ) - 1

/-! ## Temporal Abstraction Ladder

The abstraction hierarchy:
  `MetricTime → IntervalTime → CausalTime`

Each level preserves different questions:
- Exact scheduling: needs MetricTime
- May overlap? Possibly sufficient: IntervalTime
- Must precede? Possibly sufficient: CausalTime

Therefore: `TimeComplete(Q) ≠ TimeComplete(World)`.
Same law: the question determines the sufficient abstraction.

### Interval Orders

For durative actions with intervals `I_a = [s_a, e_a]`:
  `a ≺_I b ⟺ e_a < s_b`
induces an interval order.

We can distinguish:
- `I_a ∩ I_b ≠ ∅` (overlap)
- `e_a < s_b` (a strictly before b)
- `e_b < s_a` (b strictly before a)

The partial order induced by intervals encodes richer concurrency geometry.

The full chain:
  `TemporalPlan → IntervalOrder → CausalOrder → POWL`
-/

/-- Temporal abstraction level. Each erases different temporal distinctions. -/
inductive TemporalAbstraction : Type
  | metricTime      -- exact timestamps
  | intervalTime    -- interval orders [start, end]
  | causalTime      -- causal partial orders
  | hierarchicalTime -- workflow hierarchy
  deriving Repr, DecidableEq

/-- An interval order: events ordered by interval precedence.
  `a ≺_I b ⟺ end(a) < start(b)` -/
structure IntervalOrder (n : Nat) where
  /-- Start time of each event. -/
  start : Fin n → ℝ
  /-- End time of each event. -/
  finish : Fin n → ℝ
  /-- Start ≤ end for each event. -/
  interval_wf : ∀ i, start i ≤ finish i

/-- The precedence relation induced by an interval order. -/
def IntervalOrder.precedes {n : Nat} (io : IntervalOrder n)
    (i j : Fin n) : Prop :=
  io.finish i < io.start j

/-- Two events may overlap in an interval order. -/
def IntervalOrder.mayOverlap {n : Nat} (io : IntervalOrder n)
    (i j : Fin n) : Prop :=
  ¬ io.precedes i j ∧ ¬ io.precedes j i

/-! ## Four Concurrency Types

We explicitly separate:
- **CausalConcurrency**: events are unordered in the causal partial order
- **TemporalConcurrency**: event intervals may overlap in time
- **ResourceConcurrency**: events may share resources simultaneously
- **ExecutableConcurrency**: C_E = C_C ∩ C_T ∩ C_R

POWL v2 carries the causal/workflow factorization.
The temporal theory constrains it.
Resource theory constrains it.
Their intersection yields executable concurrency.
-/

/-- The four distinguished concurrency types.
Executable concurrency is the intersection of all three. -/
inductive ConcurrencyType : Type
  | causal     -- unordered in causal partial order
  | temporal   -- intervals may overlap
  | resource   -- resources permit simultaneous use
  | executable -- C_C ∩ C_T ∩ C_R
  deriving Repr, DecidableEq

/-- Executable concurrency is the intersection of causal, temporal,
and resource concurrency. -/
def executableConcurrency {n : Nat}
    (causalConc : Fin n → Fin n → Prop)
    (temporalConc : Fin n → Fin n → Prop)
    (resourceConc : Fin n → Fin n → Prop) :
    Fin n → Fin n → Prop :=
  fun i j => causalConc i j ∧ temporalConc i j ∧ resourceConc i j

end ProcInt.MFW
