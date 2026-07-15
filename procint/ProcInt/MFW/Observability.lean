import Mathlib
import ProcInt.MFW.TransformBasic

namespace ProcInt.MFW

/-!
# ProcInt.MFW.Observability

## Layer 5 — Workflow Observability

### Mathematical Content

Given a transformation `τ : B → W`, every PDDL 3.1 property `P : B → Prop`
falls into exactly one of two categories:

1. **Observable** — `P` factors through `τ`:
     `∃ P̂ : W → Prop, ∀ b, P b ↔ P̂ (τ.map b)`
   Equivalently, `P` is constant on every fiber `F_w = τ⁻¹(w)`.

2. **Hidden** — `P` distinguishes behaviors that `τ` identifies:
     `∃ b₁ b₂, τ(b₁) = τ(b₂) ∧ P b₁ ∧ ¬ P b₂`

The **observable sigma-algebra** is the pullback:
  `O_τ = {τ⁻¹(U) : U ⊆ W} = {S ⊆ B : ∀ b₁ b₂, τ(b₁) = τ(b₂) → (b₁ ∈ S ↔ b₂ ∈ S)}`

The **information horizon** `H_τ` is the boundary between observable and hidden
properties. It is the conceptual frontier: everything inside the horizon is
determinable from the POWL v2 representation; everything outside is erased.

### Sufficiency

A property `Y : B → Prop` makes `τ` **sufficient** when all `Y`-relevant
information in `B` is retained by `W`. In the information-theoretic formulation:
  `I(Y ; B | W) = 0`

The deterministic version: there exists `f̂ : W → Prop` such that `Y = f̂ ∘ τ`.
This is exactly observability of `Y`. The deeper notion of sufficiency concerns
stochastic predictions: `P(Y | B) = P(Y | W)` almost surely.

We formalize the deterministic fragment and provide a placeholder for the
information-theoretic version.

### Standing
- All `structure` and `def` declarations: DEFINITION
- Structural lemmas with proofs: PROVEN
- Lemmas with `sorry`: CONJECTURAL — proof target for formal exploration
-/

/-! ## Observable Properties -/

/-- A PDDL 3.1 property `P : B → Prop` is **POWL-observable** through `τ`
when it factors through the transformation: there exists a property `P̂`
on the workflow space such that `P b ↔ P̂ (τ.map b)` for all behaviors `b`.

Operationally, this means `P` can be determined entirely from the POWL v2
representation, without inspecting the original PDDL 3.1 behavior.

Mathematically, `P` is measurable with respect to the pullback sigma-algebra
`O_τ = σ(τ) = τ⁻¹(Σ_W)`. -/
def IsObservable {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop) : Prop :=
  ∃ Ph : WorkflowSpace α → Prop, ∀ b, P b ↔ Ph (τ.map b)

/-- A PDDL 3.1 property `P` is **fiber-constant** through `τ` when it
takes the same truth value on all behaviors in every fiber.

If `τ(b₁) = τ(b₂)`, then `P b₁ ↔ P b₂`.

This is the pointwise criterion for observability: a property that cannot
distinguish behaviors identified by the transformation. -/
def IsFiberConstant {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop) : Prop :=
  ∀ b₁ b₂ : BehavioralPhaseSpace Th,
    τ.map b₁ = τ.map b₂ → (P b₁ ↔ P b₂)

/-- A PDDL 3.1 property `P` is **hidden** by the transformation `τ`:
there exist behaviors mapped to the same workflow class that disagree on `P`.

Hidden properties represent PDDL 3.1 distinctions that are **erased** by the
transformation. They live outside the information horizon. -/
def IsHidden {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop) : Prop :=
  ∃ b₁ b₂ : BehavioralPhaseSpace Th,
    τ.map b₁ = τ.map b₂ ∧ P b₁ ∧ ¬ P b₂

/-! ## Observable ↔ Fiber-Constant

The central characterization: a property is observable if and only if
it is constant on every fiber of the transformation.

Direction 1 (observable → fiber-constant): If `P = P̂ ∘ τ`, then
`τ(b₁) = τ(b₂)` implies `P̂(τ(b₁)) = P̂(τ(b₂))`, hence `P b₁ ↔ P b₂`.

Direction 2 (fiber-constant → observable): Define `P̂(w) := P(b)` for any
`b ∈ τ⁻¹(w)`. Fiber-constancy guarantees this is well-defined. This
direction uses choice to select a representative from each fiber.
-/

/-- **Theorem (Observable → Fiber-Constant).**
If `P` factors through `τ`, then `P` is constant on every fiber.

Standing: PROVEN. -/
theorem observable_implies_fiber_constant {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop)
    (h : IsObservable τ P) : IsFiberConstant τ P := by
  obtain ⟨Ph, hPh⟩ := h
  intro b₁ b₂ heq
  rw [hPh b₁, hPh b₂, heq]

/-- **Theorem (Fiber-Constant → Observable).**
If `P` is constant on every fiber, then `P` factors through `τ`.

The factoring property `P̂` is defined by: `P̂(w) := P(b)` for any `b`
with `τ(b) = w`. Fiber-constancy ensures independence of the choice.

Standing: CONJECTURAL — requires choice of fiber representatives. -/
-- CONJECTURAL: requires choice of fiber representatives across fibers
theorem fiber_constant_implies_observable {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop)
    (h : IsFiberConstant τ P) : IsObservable τ P := by
  exact ⟨fun w => ∀ b, τ.map b = w → P b,
    fun b => ⟨fun hPb b' heq => (h b b' (heq ▸ rfl) |>.mp) hPb,
             fun hall => hall b rfl⟩⟩

/-- **Theorem (Observable ↔ Fiber-Constant).**
The canonical characterization of observability.

Standing: PROVEN (both directions established). -/
theorem observable_iff_fiber_constant {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop) :
    IsObservable τ P ↔ IsFiberConstant τ P :=
  ⟨observable_implies_fiber_constant τ P,
   fiber_constant_implies_observable τ P⟩

/-! ## Observable vs Hidden: Dichotomy -/

/-- **Theorem (Hidden ↔ ¬ Fiber-Constant).**
A property is hidden if and only if it is not fiber-constant.

Standing: CONJECTURAL — the reverse direction needs choice of witnesses. -/
-- CONJECTURAL: reverse direction requires extracting witnesses from negation
theorem hidden_iff_not_fiber_constant {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop) :
    IsHidden τ P ↔ ¬ IsFiberConstant τ P := by
  constructor
  · rintro ⟨b₁, b₂, heq, hP, hnP⟩ hfc
    exact hnP ((hfc b₁ b₂ heq).mp hP)
  · intro hnfc
    by_contra h
    apply hnfc
    intro b₁ b₂ heq
    constructor
    · intro hb1
      by_contra hnb2
      exact h ⟨b₁, b₂, heq, hb1, hnb2⟩
    · intro hb2
      by_contra hnb1
      exact h ⟨b₂, b₁, heq.symm, hb2, hnb1⟩

/-- **Theorem (Observable → ¬ Hidden).**
Observable properties cannot be hidden.

Standing: PROVEN. -/
theorem observable_not_hidden {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop)
    (hobs : IsObservable τ P) : ¬ IsHidden τ P := by
  rintro ⟨b₁, b₂, heq, hP, hnP⟩
  have hfc := observable_implies_fiber_constant τ P hobs
  exact hnP ((hfc b₁ b₂ heq).mp hP)

/-! ## Observable Sigma-Algebra

The **observable sigma-algebra** `O_τ` consists of all subsets of the behavioral
phase space that are pullbacks of workflow-space subsets:
  `O_τ = {τ⁻¹(U) : U ⊆ W}`

Equivalently, `O_τ` is the set of all `S ⊆ B` such that membership in `S` is
constant on fibers:
  `O_τ = {S ⊆ B : ∀ b₁ b₂, τ(b₁) = τ(b₂) → (b₁ ∈ S ↔ b₂ ∈ S)}`

This is the largest sigma-algebra on `B` with respect to which `τ` is
measurable, i.e., the sigma-algebra generated by `τ`.
-/

/-- The pullback of a workflow-space subset through τ.
  `τ⁻¹(U) = {b ∈ B : τ(b) ∈ U}` -/
def pullbackSet {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (U : Set (WorkflowSpace α)) : Set (BehavioralPhaseSpace Th) :=
  {b | τ.map b ∈ U}

/-- A subset of the behavioral phase space is **τ-saturated** when it is
a union of complete fibers. Equivalently, membership is constant on fibers.

This is the set-level analogue of `IsFiberConstant`. -/
def IsSaturated {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : Set (BehavioralPhaseSpace Th)) : Prop :=
  ∀ b₁ b₂ : BehavioralPhaseSpace Th,
    τ.map b₁ = τ.map b₂ → (b₁ ∈ S ↔ b₂ ∈ S)

/-- The **observable sigma-algebra** `O_τ`: the collection of all τ-saturated
subsets of the behavioral phase space.

This is the set of all properties that can be determined from the POWL v2
representation alone. It equals `{τ⁻¹(U) : U ⊆ W}`. -/
def observableSigmaAlgebra {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) :
    Set (Set (BehavioralPhaseSpace Th)) :=
  {S | IsSaturated τ S}

/-- A set is in the observable sigma-algebra iff its indicator function
is fiber-constant, iff it is a pullback of some workflow-space subset.

Standing: PROVEN (first equivalence). -/
theorem mem_observableSigmaAlgebra_iff {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : Set (BehavioralPhaseSpace Th)) :
    S ∈ observableSigmaAlgebra τ ↔ IsFiberConstant τ (· ∈ S) := by
  simp [observableSigmaAlgebra, IsSaturated, IsFiberConstant]

/-- The pullback of any workflow-space subset is τ-saturated.

Standing: PROVEN. -/
theorem pullbackSet_saturated {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (U : Set (WorkflowSpace α)) :
    IsSaturated τ (pullbackSet τ U) := by
  intro b₁ b₂ heq
  simp [pullbackSet, heq]

/-- Every τ-saturated set is a pullback of some workflow-space subset.
Specifically, `S = τ⁻¹({w : ∃ b ∈ S, τ(b) = w})`.

Standing: PROVEN. -/
theorem saturated_is_pullback {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : Set (BehavioralPhaseSpace Th))
    (hS : IsSaturated τ S) :
    S = pullbackSet τ {w | ∃ b ∈ S, τ.map b = w} := by
  ext b
  simp [pullbackSet]
  constructor
  · intro hb
    exact ⟨b, hb, rfl⟩
  · rintro ⟨b', hb', heq⟩
    exact (hS b b' (heq ▸ rfl)).mpr hb'

/-! ## Closure Properties of Observable Properties

The observable properties form a Boolean algebra (closed under ¬, ∧, ∨, →)
and are closed under quantification over workflow-space parameters.
-/

/-- Observable properties are closed under negation.

Standing: PROVEN. -/
theorem observable_neg {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop)
    (h : IsObservable τ P) : IsObservable τ (fun b => ¬ P b) := by
  obtain ⟨Ph, hPh⟩ := h
  exact ⟨fun w => ¬ Ph w, fun b => by simp only [hPh b]⟩

/-- Observable properties are closed under conjunction.

Standing: PROVEN. -/
theorem observable_and {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P Q : BehavioralPhaseSpace Th → Prop)
    (hP : IsObservable τ P) (hQ : IsObservable τ Q) :
    IsObservable τ (fun b => P b ∧ Q b) := by
  obtain ⟨Ph, hPh⟩ := hP
  obtain ⟨Qh, hQh⟩ := hQ
  exact ⟨fun w => Ph w ∧ Qh w, fun b => by simp only [hPh b, hQh b]⟩

/-- Observable properties are closed under disjunction.

Standing: PROVEN. -/
theorem observable_or {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P Q : BehavioralPhaseSpace Th → Prop)
    (hP : IsObservable τ P) (hQ : IsObservable τ Q) :
    IsObservable τ (fun b => P b ∨ Q b) := by
  obtain ⟨Ph, hPh⟩ := hP
  obtain ⟨Qh, hQh⟩ := hQ
  exact ⟨fun w => Ph w ∨ Qh w, fun b => by simp only [hPh b, hQh b]⟩

/-- Observable properties are closed under implication.

Standing: PROVEN. -/
theorem observable_imp {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P Q : BehavioralPhaseSpace Th → Prop)
    (hP : IsObservable τ P) (hQ : IsObservable τ Q) :
    IsObservable τ (fun b => P b → Q b) := by
  obtain ⟨Ph, hPh⟩ := hP
  obtain ⟨Qh, hQh⟩ := hQ
  exact ⟨fun w => Ph w → Qh w, fun b => by simp only [hPh b, hQh b]⟩

/-! ## Composition of Observable Properties -/

/-- **Theorem (Observable Composition).**
If `f : Prop → Prop → Prop` is any binary connective and `P`, `Q` are
observable, then `fun b => f (P b) (Q b)` is observable.

This generalizes all Boolean closure properties.

Standing: PROVEN. -/
theorem observable_comp {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P Q : BehavioralPhaseSpace Th → Prop)
    (f : Prop → Prop → Prop)
    (hP : IsObservable τ P) (hQ : IsObservable τ Q) :
    IsObservable τ (fun b => f (P b) (Q b)) := by
  obtain ⟨Ph, hPh⟩ := hP
  obtain ⟨Qh, hQh⟩ := hQ
  exact ⟨fun w => f (Ph w) (Qh w), fun b => by simp only [hPh b, hQh b]⟩

/-- If `g : Prop → Prop` is any unary operation and `P` is observable,
then `fun b => g (P b)` is observable.

Standing: PROVEN. -/
theorem observable_unary_comp {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (P : BehavioralPhaseSpace Th → Prop)
    (g : Prop → Prop)
    (hP : IsObservable τ P) :
    IsObservable τ (fun b => g (P b)) := by
  obtain ⟨Ph, hPh⟩ := hP
  exact ⟨fun w => g (Ph w), fun b => by simp only [hPh b]⟩

/-! ## Trivial and Universal Observability -/

/-- The constantly true property is always observable.

Standing: PROVEN. -/
theorem observable_true {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) :
    IsObservable τ (fun _ : BehavioralPhaseSpace Th => True) :=
  ⟨fun _ => True, fun _ => Iff.rfl⟩

/-- The constantly false property is always observable.

Standing: PROVEN. -/
theorem observable_false {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) :
    IsObservable τ (fun _ : BehavioralPhaseSpace Th => False) :=
  ⟨fun _ => False, fun _ => Iff.rfl⟩

/-- Any property that depends only on the workflow image is observable.
If `P = Ph ∘ τ.map`, then `P` is observable by definition.

Standing: PROVEN. -/
theorem observable_of_factors {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (Ph : WorkflowSpace α → Prop) :
    IsObservable τ (fun b => Ph (τ.map b)) :=
  ⟨Ph, fun _ => Iff.rfl⟩

/-! ## Property-Relative Workflow Sufficiency

### Motivation

The question "Is the POWL v2 representation sufficient?" is ill-formed
without specifying *sufficient for what*. We make this precise:

**Definition.** The transformation `τ` is **sufficient for** a property
`Y : B → Prop` when knowing `τ(b)` determines `Y(b)`.

In the deterministic case, this is exactly observability of `Y`.

In the stochastic case (when we have a probability measure on `B`),
sufficiency means `I(Y ; B | W) = 0`, or equivalently, `Y ⊥ B | τ(B)`.

We formalize both versions.
-/

/-- **Deterministic sufficiency**: the transformation `τ` is sufficient for
predicting `Y` when `Y` factors through `τ`.

This is the deterministic fragment of the Fisher–Neyman sufficiency criterion
adapted to the workflow transformation setting.

In the information-theoretic formulation: `I(Y ; B | W) = 0`.
Deterministically: `Y = f̂ ∘ τ` for some `f̂`. -/
def IsSufficientFor {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (Y : BehavioralPhaseSpace Th → Prop) : Prop :=
  IsObservable τ Y

/-- **Theorem (Sufficient → Observable).**
If τ is sufficient for Y, then Y is observable through τ.
This is immediate from the definition in the deterministic case.

Standing: PROVEN. -/
theorem sufficient_implies_observable {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (Y : BehavioralPhaseSpace Th → Prop)
    (h : IsSufficientFor τ Y) : IsObservable τ Y := h

/-- **Corollary.** Sufficiency implies fiber-constancy of the target property.

Standing: PROVEN. -/
theorem sufficient_implies_fiber_constant {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (Y : BehavioralPhaseSpace Th → Prop)
    (h : IsSufficientFor τ Y) : IsFiberConstant τ Y :=
  observable_implies_fiber_constant τ Y h

/-! ## Semantic Residual Information (Placeholder)

The **semantic residual information** `I(Y ; B | W)` quantifies how much
information about `Y` is lost by the transformation `τ`. When this is zero,
the workflow representation is lossless for predicting `Y`.

  `I(Y ; B | W) = H(Y | W) - H(Y | B) = H(Y | W)`

since `H(Y | B) = 0` when `Y` is determined by `B`.

Full formalization requires:
1. A probability measure `ν` on `B`
2. Conditional entropy `H(Y | W)` defined via the pushforward
3. Mutual information `I(Y ; B | W)` as a conditional expectation

We provide a placeholder structure for the information-theoretic quantities.
-/

/-- Placeholder for the semantic residual information `I(Y ; B | W)`.

This captures the information about property `Y` that is present in the
full behavioral description `B` but absent from the workflow representation
`W = τ(B)`.

When `residual = 0`, the transformation retains all `Y`-relevant information.
When `residual > 0`, the transformation erases `Y`-relevant distinctions.

Full formalization is a research target requiring measure-theoretic conditional
entropy. -/
structure SemanticResidualInfo {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (Y : BehavioralPhaseSpace Th → Prop) where
  /-- The residual mutual information `I(Y ; B | W)`. -/
  residual : ℝ
  /-- Residual information is non-negative (by non-negativity of mutual information). -/
  nonneg : 0 ≤ residual

/-- **Theorem (Zero Residual → Sufficiency).**
If the semantic residual information is zero, the transformation is
sufficient for `Y` (in the deterministic fragment, this requires a
proof that zero conditional mutual information implies factorization).

Standing: CONJECTURAL — bridges information-theoretic and algebraic definitions. -/
-- CONJECTURAL: requires measure-theoretic bridge
def ZeroResidualImpliesSufficient {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (Y : BehavioralPhaseSpace Th → Prop)
    (info : SemanticResidualInfo τ Y) : Prop :=
    info.residual = 0 → IsSufficientFor τ Y

/-! ## Information Horizon

The **information horizon** `H_τ` is the conceptual boundary between
observable and hidden properties. It is not a single object but a
characterization of the transformation's information geometry:

- Inside `H_τ`: Properties in the observable sigma-algebra `O_τ`.
  These are determined by the POWL v2 representation.

- Outside `H_τ`: Hidden properties. These are PDDL 3.1 distinctions
  erased by the transformation.

The information horizon depends on:
1. The **granularity** of the POWL v2 hierarchy (deeper = more observable)
2. The **temporal precision** of POWL v2 (tighter = more observable)
3. The **data conditioning** (fluent values, object configurations)

We formalize the horizon as the partition of all properties into
observable and hidden, parameterized by the transformation.
-/

/-- The **information horizon** of a transformation `τ`.

This structure records the dichotomy between observable and hidden properties.
It serves as a diagnostic: given a candidate property `P`, one can test
whether it lies within or beyond the horizon. -/
structure InformationHorizon {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) where
  /-- Test whether a property is within the horizon (observable). -/
  isWithin : (BehavioralPhaseSpace Th → Prop) → Prop
  /-- The test agrees with observability. -/
  within_iff_observable :
    ∀ P, isWithin P ↔ IsObservable τ P

/-- Canonical construction of the information horizon from observability.

Standing: PROVEN. -/
def canonicalHorizon {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) :
    InformationHorizon τ where
  isWithin := fun P => IsObservable τ P
  within_iff_observable := fun _ => Iff.rfl

/-! ## Refinement of Transformations

When one transformation is finer than another (i.e., makes more distinctions),
it has more observable properties. This gives a partial order on transformations
ordered by observational power.
-/

/-- Transformation `τ₁` **refines** `τ₂` when every `τ₂`-fiber is a union
of `τ₁`-fibers. Equivalently, `τ₁(b₁) = τ₁(b₂) → τ₂(b₁) = τ₂(b₂)`:
`τ₁` makes at least as many distinctions as `τ₂`.

This means `τ₂ = ψ ∘ τ₁` for some `ψ : W₁ → W₂`. -/
def Refines {Th : PlanningTheory} {α β : Type}
    (τ₁ : WorkflowTransformation Th α)
    (τ₂ : WorkflowTransformation Th β) : Prop :=
  ∀ b₁ b₂ : BehavioralPhaseSpace Th,
    τ₁.map b₁ = τ₁.map b₂ → τ₂.map b₁ = τ₂.map b₂

/-- **Theorem (Refinement monotonicity).**
If `τ₁` refines `τ₂`, then every `τ₂`-observable property is `τ₁`-observable.

Standing: PROVEN. -/
theorem refines_observable_mono {Th : PlanningTheory} {α β : Type}
    (τ₁ : WorkflowTransformation Th α)
    (τ₂ : WorkflowTransformation Th β)
    (href : Refines τ₁ τ₂)
    (P : BehavioralPhaseSpace Th → Prop)
    (hobs : IsObservable τ₂ P) : IsObservable τ₁ P := by
  rw [observable_iff_fiber_constant] at hobs ⊢
  intro b₁ b₂ h₁
  exact hobs b₁ b₂ (href b₁ b₂ h₁)

/-- **Theorem (Refinement is reflexive).**

Standing: PROVEN. -/
theorem refines_refl {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) : Refines τ τ :=
  fun _ _ h => h

/-- **Theorem (Refinement is transitive).**

Standing: PROVEN. -/
theorem refines_trans {Th : PlanningTheory} {α β γ : Type}
    (τ₁ : WorkflowTransformation Th α)
    (τ₂ : WorkflowTransformation Th β)
    (τ₃ : WorkflowTransformation Th γ)
    (h₁₂ : Refines τ₁ τ₂) (h₂₃ : Refines τ₂ τ₃) :
    Refines τ₁ τ₃ :=
  fun b₁ b₂ h => h₂₃ b₁ b₂ (h₁₂ b₁ b₂ h)

/-! ## Research Questions

1. **Concrete observability audit**: For specific PDDL 3.1 domains and
   POWL v2 discovery pipelines, which planning properties are observable?
   Which are hidden? This is an empirical/formal audit.

2. **Minimal sufficient statistics**: What is the coarsest transformation
   (fewest workflow classes) that is still sufficient for a given target
   property `Y`? This connects to the theory of sufficient statistics.

3. **Information-theoretic bridge**: Full formalization of `I(Y ; B | W) = 0`
   using Mathlib's measure theory. Requires:
   - Probability measure on `BehavioralPhaseSpace Th`
   - Conditional entropy `H(Y | W)` via regular conditional distributions
   - Proof that zero conditional entropy implies a.s. factorization

4. **Hierarchical observability**: How does observability change across
   the POWL v2 hierarchical scale system? Properties observable at depth `k`
   but hidden at depth `k-1` characterize the information gained by
   hierarchical refinement.

5. **Observable sigma-algebra as a lattice**: The collection of observable
   sigma-algebras `{O_{τ_i}}_i` over a family of transformations forms a
   lattice under inclusion. What is its structure?
-/

end ProcInt.MFW
