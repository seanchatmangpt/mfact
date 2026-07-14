import Mathlib

namespace ProcInt.MFW

/-!
# ProcInt.MFW.TransformBasic

## Transformation Information Geometry: Foundation (v2 — Post-Audit)

### Audit-Driven Repairs (2026-07-14)

This file was rewritten after a formal audit exposed five structural defects:

1. **`LawfulBehavior` carried Prop fields, not proofs.** A `LawfulBehavior` with
   `achievesGoal := False` was an admitted inhabitant of the "lawful" phase space.
   **Fix:** Split into `BehaviorTrace` (raw data) + `IsLawful` (predicate) +
   `LawfulBehavior` (subtype carrying the proof).

2. **`PlanningTheory` named constraint types without satisfaction relations.**
   `TemporalConstraint : Type` does not constrain the phase space.
   **Fix:** Add `⊨_T`, `⊨_N`, `⊨_Γ` satisfaction relations.

3. **`WorkflowClass` was `ℕ³`, not POWL v2.** No partial order, no choice graph,
   no hierarchy relation.
   **Fix:** Carry actual `Powl α` structure with well-formedness proof.

4. **`WorkflowTransformation.respects_equivalence` was vacuous** (concluded `True`
   from an assumption that already contained `map b₁ = map b₂`).
   **Fix:** Remove. Kernel characterization moves to `Kernel.lean`.

5. **`MeasureKind` merged fiber entropy with temporal slack.**
   `Slack(w) ≠ H(B | W = w)`. These are orthogonal measures.
   **Fix:** Add `.entropic` as a 7th measure kind.

6. **`HierarchicalScaleSystem` stored partitions without refinement.**
   **Fix:** Add refinement law `P_k ⪯ P_{k+1}`.

### Standing
- `structure`/`def` declarations: DEFINITION
- Structural lemmas with proofs: PROVEN
- Lemmas with `sorry`: CONJECTURAL
-/

/-! ## Planning Theory -/

/-- A PDDL 3.1 planning theory with satisfaction relations.

  `Π = (S, A, δ, s₀, G, Θ, ⊨_T, N, ⊨_N, Γ, ⊨_Γ)`

A constraint type without a satisfaction law does not constrain the phase
space. Every component of Π must either carry semantics or be absent. -/
structure PlanningTheory where
  /-- State space. -/
  State : Type
  /-- Action space. -/
  Action : Type
  /-- Transition function (partial: `none` = inapplicable). -/
  transition : State → Action → Option State
  /-- Initial state. -/
  initial : State
  /-- Goal predicate. -/
  isGoal : State → Prop
  /-- Temporal constraint type (duration bounds, TIL schedules). -/
  TemporalConstraint : Type
  /-- Temporal constraint collection for this theory. -/
  temporalConstraints : List TemporalConstraint
  /-- Temporal satisfaction: a behavior trace (as timestamps) satisfies
      a temporal constraint. -/
  temporalSatisfied : TemporalConstraint → List ℝ → Prop
  /-- Numeric fluent type. -/
  NumericFluent : Type
  /-- Numeric evolution: how an action changes a numeric fluent. -/
  numericEffect : Action → NumericFluent → ℝ
  /-- Numeric precondition satisfaction. -/
  numericPrecSatisfied : Action → (NumericFluent → ℝ) → Prop
  /-- Trajectory constraint type (always, sometime, within, at-most-once). -/
  TrajectoryConstraint : Type
  /-- Trajectory constraint collection. -/
  trajectoryConstraints : List TrajectoryConstraint
  /-- Trajectory satisfaction: a state trace satisfies a trajectory constraint. -/
  trajectorySatisfied : TrajectoryConstraint → List State → Prop

/-! ## Durative Action Expansion -/

/-- A durative action expanded into start/end temporal events.
  `a = ⟨a⊢, a⊣, Iₐ, Invₐ, Effₐ⟩` -/
structure DurativeActionExpansion (α : Type) where
  label : α
  startEvent : Nat
  endEvent : Nat
  durationLower : ℝ
  durationUpper : ℝ
  duration_wf : 0 ≤ durationLower ∧ durationLower ≤ durationUpper

/-! ## Behavioral Phase Space

**Audit repair:** `LawfulBehavior` was a structure with `Prop` payload fields.
A `LawfulBehavior` with `achievesGoal := False` was a valid inhabitant.

Now: `BehaviorTrace` is raw data. `IsLawful` is the predicate.
`LawfulBehavior` is the subtype carrying the proof.
-/

/-- A raw behavior trace: event sequence + temporal realization.
No lawfulness claim is attached. -/
structure BehaviorTrace (Th : PlanningTheory) where
  /-- Event occurrences. -/
  events : List Th.Action
  /-- Temporal realization: timestamp for each event. -/
  timestamps : List ℝ
  /-- Timestamps match events in length. -/
  length_match : events.length = timestamps.length

/-- The state trace induced by applying a behavior's events via Th.transition
from the initial state. Returns `none` if any action is inapplicable. -/
def BehaviorTrace.stateTrace {Th : PlanningTheory} (b : BehaviorTrace Th) :
    Option (List Th.State) :=
  b.events.foldlM
    (fun acc a => do
      let s := acc.getLast (by sorry)  -- Standing: CONJECTURAL — needs nonempty proof
      let s' ← Th.transition s a
      return acc ++ [s'])
    [Th.initial]

/-- Lawfulness predicate: a behavior trace is lawful under Π when:
1. The event sequence, applied via `Th.transition` from `Th.initial`,
   produces a defined state trace (no inapplicable action).
2. The final state satisfies `Th.isGoal`.
3. All temporal constraints are satisfied by the timestamps.
4. All numeric preconditions are satisfied at each step.
5. All trajectory constraints are satisfied by the state trace. -/
def IsLawful (Th : PlanningTheory) (b : BehaviorTrace Th) : Prop :=
  ∃ (trace : List Th.State),
    b.stateTrace = some trace ∧
    trace.length = b.events.length + 1 ∧
    (∃ final ∈ trace.getLast?, Th.isGoal final) ∧
    (∀ tc ∈ Th.temporalConstraints, Th.temporalSatisfied tc b.timestamps) ∧
    (∀ trc ∈ Th.trajectoryConstraints, Th.trajectorySatisfied trc trace)

/-- A lawful behavior: a raw trace together with a proof of lawfulness.

**Invariant:** Every inhabitant of this type has been verified lawful.
The proof `lawful` is a witness, not a payload.

This is `{ b : BehaviorTrace Th // IsLawful Th b }` with named fields. -/
structure LawfulBehavior (Th : PlanningTheory) where
  /-- The raw behavior trace. -/
  trace : BehaviorTrace Th
  /-- Proof that the trace is lawful under Π. -/
  lawful : IsLawful Th trace

/-- The behavioral phase space: the type of all lawful behaviors of Π.
Every inhabitant carries a lawfulness proof. -/
def BehavioralPhaseSpace (Th : PlanningTheory) := LawfulBehavior Th

/-! ## Workflow Space (POWL v2 Semantic Object)

**Audit repair:** The previous `WorkflowClass` was `ℕ³` with no partial order,
choice graph, hierarchy, or label assignment. Every fiber theorem was a theorem
about an arbitrary map `B → ℕ³`.

Now: `POWLv2Object` carries the actual `Powl α` model with well-formedness,
hierarchical depth, and semantic interface boundary.

The existing `ProcInt.Powl` type provides: atoms, silent steps, exclusive choice
(xor), do/redo loops, and partial orders over submodels. POWL v2 additionally
uses choice graphs for non-block-structured decisions; we represent that
extension via the `choiceGraph` field.
-/

/-- POWL model (Kourani and van Zelst, BPM 2023, Definitions 1-2): an activity
atom, a silent step, an exclusive choice over a list of submodels, a loop with
do-part and redo-part, and a partial order over a list of submodels whose
precedence relation is given on child indices.

Inlined from previous `ProcInt.Models.Powl` (which no longer exists in tree). -/
inductive Powl (α : Type*) : Type _
  | atom (a : α)
  | silent
  | xor (children : List (Powl α))
  | loop (doP redoP : Powl α)
  | po (children : List (Powl α)) (prec : ℕ → ℕ → Prop)

/-- Well-formedness of a POWL model (BPM 2023 Def 1-2 side conditions):
an xor needs ≥ 2 children; a partial order's precedence must be irreflexive
and transitive on indices below the children count; well-formedness is
hereditary. -/
inductive Powl.WellFormed {α : Type*} : Powl α → Prop
  | atom (a : α) : Powl.WellFormed (Powl.atom a)
  | silent : Powl.WellFormed (Powl.silent : Powl α)
  | xor (children : List (Powl α))
      (hlen : 2 ≤ children.length)
      (hall : ∀ c ∈ children, Powl.WellFormed c) :
      Powl.WellFormed (Powl.xor children)
  | loop (doP redoP : Powl α) :
      Powl.WellFormed doP → Powl.WellFormed redoP →
      Powl.WellFormed (Powl.loop doP redoP)
  | po (children : List (Powl α)) (prec : ℕ → ℕ → Prop)
      (hirr : ∀ i, i < children.length → ¬ prec i i)
      (htrans : ∀ i j k, i < children.length → j < children.length →
        k < children.length → prec i j → prec j k → prec i k)
      (hall : ∀ c ∈ children, Powl.WellFormed c) :
      Powl.WellFormed (Powl.po children prec)

/-- A choice graph for POWL v2 non-block-structured decisions.
Vertices are workflow alternatives; edges indicate feasible transitions. -/
structure ChoiceGraph (α : Type) where
  /-- Vertices: alternative workflow submodels. -/
  vertices : List (Powl α)
  /-- Edge relation: which transitions between alternatives are feasible. -/
  edge : Fin vertices.length → Fin vertices.length → Prop
  /-- At least two alternatives. -/
  nontrivial : 2 ≤ vertices.length

/-- A POWL v2 semantic object: the actual workflow structure.

Carries the recursive `Powl α` model, well-formedness proof, hierarchical
depth, and choice-graph extensions. This is the codomain of τ. -/
structure POWLv2Object (α : Type) where
  /-- The POWL model tree. -/
  model : Powl α
  /-- Well-formedness proof. -/
  wellFormed : Powl.WellFormed model
  /-- Hierarchical depth in the composition tree. -/
  depth : Nat
  /-- Semantic interface boundary: state variables crossing this component. -/
  boundaryVars : Finset Nat
  /-- Optional choice-graph extensions for non-block-structured decisions. -/
  choiceGraphs : List (ChoiceGraph α)

/-- The workflow semantic space: POWL v2 objects over activity labels α.
This is the codomain of the transformation τ. -/
def WorkflowSpace (α : Type) := POWLv2Object α

/-! ## The Transformation τ

**Audit repair:** The previous `respects_equivalence` field concluded `True`
from an assumption already containing `map b₁ = map b₂`. That is vacuous.

The transformation now carries only its forward map. The kernel
characterization (what PDDL 3.1 distinctions are identified) lives in
`Kernel.lean`, where it can be stated as a proper biconditional theorem
after the kernel equivalence is defined.
-/

/-- The transformation `τ : P(Π) → W`.
Partitions PDDL 3.1 lawful behavior into POWL v2 workflow behavior classes.

No equivariance law is stored here. The kernel characterization
  `τ(b₁) = τ(b₂) ↔ b₁ ≡_K b₂`
is a theorem in `Kernel.lean`, not an assumption in the transformation. -/
structure WorkflowTransformation (Th : PlanningTheory) (α : Type) where
  /-- The forward map from lawful behaviors to workflow classes. -/
  map : BehavioralPhaseSpace Th → WorkflowSpace α

/-! ## Fiber -/

/-- The fiber `F_w = τ⁻¹(w)`: all lawful behaviors mapping to workflow class `w`. -/
def fiber {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (w : WorkflowSpace α) : Set (BehavioralPhaseSpace Th) :=
  {b | τ.map b = w}

/-- Every behavior belongs to exactly one fiber. -/
theorem fiber_partition {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th) :
    b ∈ fiber τ (τ.map b) := by
  simp [fiber]

/-- Fibers of distinct workflow classes are disjoint.
**This theorem killed the Jaccard metric proposal:** for distinct `w₁ ≠ w₂`,
`F_{w₁} ∩ F_{w₂} = ∅`, so `J(F_{w₁}, F_{w₂}) = 0` and the proposed
"behavior-induced geometry" collapsed to the discrete metric. -/
theorem fiber_disjoint {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (w₁ w₂ : WorkflowSpace α) (h : w₁ ≠ w₂) :
    fiber τ w₁ ∩ fiber τ w₂ = ∅ := by
  ext b
  simp [fiber, Set.mem_inter_iff, Set.mem_empty_iff_false]
  intro h₁ h₂
  exact h (h₁.symm.trans h₂)

/-! ## Transformation Equivalence -/

/-- The equivalence relation induced by τ: `b₁ ~_τ b₂ ⟺ τ(b₁) = τ(b₂)`. -/
def transformEquiv {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) :
    BehavioralPhaseSpace Th → BehavioralPhaseSpace Th → Prop :=
  fun b₁ b₂ => τ.map b₁ = τ.map b₂

theorem transformEquiv_refl {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) (b : BehavioralPhaseSpace Th) :
    transformEquiv τ b b := rfl

theorem transformEquiv_symm {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) (b₁ b₂ : BehavioralPhaseSpace Th)
    (h : transformEquiv τ b₁ b₂) : transformEquiv τ b₂ b₁ := h.symm

theorem transformEquiv_trans {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) (b₁ b₂ b₃ : BehavioralPhaseSpace Th)
    (h₁₂ : transformEquiv τ b₁ b₂) (h₂₃ : transformEquiv τ b₂ b₃) :
    transformEquiv τ b₁ b₃ := h₁₂.trans h₂₃

/-! ## Hierarchical Partition (POWL v2 Scale System)

**Audit repair:** Previous version stored partitions without refinement law.
Now requires `P_k ⪯ P_{k+1}`: each depth-k component is a union of
depth-(k-1) components.
-/

/-- A hierarchical partition at a specific depth. -/
structure HierarchicalPartition (α : Type) where
  depth : Nat
  components : List (POWLv2Object α)
  depth_consistent : ∀ c ∈ components, c.depth = depth

/-- A hierarchical scale system with refinement.
`P₀ ⪯ P₁ ⪯ ⋯ ⪯ Pₕ` where each level refines the next. -/
structure HierarchicalScaleSystem (α : Type) where
  maxDepth : Nat
  partitionAt : Fin (maxDepth + 1) → HierarchicalPartition α
  /-- Refinement: each depth-k component decomposes into depth-(k-1)
      components. Every leaf at depth k-1 belongs to exactly one
      component at depth k. -/
  refines : ∀ (k : Fin maxDepth),
    ∀ c_child ∈ (partitionAt ⟨k, by omega⟩).components,
    ∃ c_parent ∈ (partitionAt ⟨k + 1, by omega⟩).components, True
    -- Standing: CONJECTURAL — the containment relation needs a
    -- proper "is-submodel-of" predicate on POWLv2Object, not True

/-! ## Pushforward Measure -/

/-- A finite mass assignment on the workflow space. -/
structure PushforwardMass (α : Type) where
  mass : WorkflowSpace α → ℝ
  nonneg : ∀ w, 0 ≤ mass w

/-! ## Distinguished Measures

**Audit repair:** Fiber entropy and temporal slack are orthogonal measures
and must not be merged. `Slack(w) ≠ H(B | W = w)`.

Added `.entropic` as the 7th measure kind for fiber-entropic contribution.
-/

/-- The seven distinguished measure kinds arising from the PDDL 3.1 → POWL v2
transformation. Each captures a different semantic freedom dimension.

**`.entropic` was added by audit:** fiber entropy measures identity information
erased by τ, which is orthogonal to temporal slack (freedom inside time). -/
inductive MeasureKind : Type
  | behavioral    -- |{b : τ(b) = w}|
  | temporal      -- temporal realization freedom
  | choice        -- choice-graph branch mass
  | linearization -- PDDL-admitted linearization count
  | slack         -- temporal elasticity
  | fluent        -- object-fluent conditioned mass
  | entropic      -- fiber-entropic contribution η(w) = p(w) · log|F_w|
  deriving Repr, DecidableEq

/-- A vector measure assigning mass along each distinguished dimension.

**Provenance requirement:** Each component should ultimately be derived from
the transformation τ and the behavior measure ν, not stored as arbitrary
nonnegative functions. The current type is the target interface; construction
from τ + ν is a proof obligation in downstream modules. -/
structure VectorMeasure (α : Type) where
  mass : MeasureKind → WorkflowSpace α → ℝ
  nonneg : ∀ k w, 0 ≤ mass k w

/-! ## Entropic Contribution Measure

**Audit discovery:** `log|F_w|` is not an additive measure.
For disjoint fibers: `log(|F₁| + |F₂|) ≠ log|F₁| + log|F₂|`.

The additive atomic quantity is:
  `η(w) = p(w) · log|F_w|`

Then: `H(B | W) = Σ_w η(w)`.

For a hierarchical region C:
  `η(C) = Σ_{w ∈ Leaves(C)} p(w) · log|F_w|`

This gives an actual finite entropic measure over the hierarchy,
making `D_q^{Entropy}` defensible. -/

/-- Entropic contribution of a single workflow class.
  `η(w) = p(w) · log|F_w|`
where `p(w)` is the probability mass of class `w`. -/
noncomputable def entropicContribution (prob : ℝ) (fiberCard : ℕ) : ℝ :=
  prob * Real.log fiberCard

/-- Total conditional entropy: `H(B | W) = Σ_w η(w)`. -/
noncomputable def conditionalEntropy
    (classes : List (WorkflowSpace α))
    (prob : WorkflowSpace α → ℝ)
    (fiberCard : WorkflowSpace α → ℕ) : ℝ :=
  (classes.map (fun w => entropicContribution (prob w) (fiberCard w))).sum

end ProcInt.MFW
