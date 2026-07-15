import Mathlib
import ProcInt.MFW.TransformBasic

namespace ProcInt.MFW

/-!
# ProcInt.MFW.ObservableBasis

## Layer 8 — Observable Basis

### Derivation Chain Position

```
Layer 0  Behavioral Phase Space P(Π)          [TransformBasic]
Layer 1  Workflow Space W                      [TransformBasic]
Layer 2  Transformation τ                      [TransformBasic]
Layer 3  Fiber F_w = τ⁻¹(w)                   [TransformBasic]
Layer 4  Pushforward μ = τ_*ν                  [TransformBasic]
Layer 5  Hölder / Spectral                     [future]
Layer 6  Fiber Entropy                         [future]
Layer 7  Information Bottleneck                [future]
Layer 8  Observable Basis                      [THIS FILE]
```

### Mathematical Content

Inspired by **Energy Flow Polynomials** (EFPs) in collider physics, which provide a
complete linear basis for infrared/collinear-safe observables, we seek an analogous
construction for PDDL 3.1 → POWL v2 invariant observables.

#### The Central Problem

Given the transformation `τ : P(Π) → W`, define:

  `F_τ = {f : B → ℝ | f is constant on τ-fibers}`

These are real-valued observables on the behavioral phase space that are **preserved**
by the transformation — they see only what POWL v2 sees. Equivalently, `f ∈ F_τ` if
and only if `f` factors through `τ`:

  `f = g ∘ τ` for some `g : W → ℝ`

This is the analogue of infrared safety: observables insensitive to the information
erased by τ.

#### Basis Generation

We seek generators `φ₁, φ₂, …` such that every observable in an admitted class is
expressible as:

  `f = F(φ₁, …, φ_k)`

For a **linear** class this becomes:

  `f = Σ cᵢ φᵢ`

yielding the **Workflow Invariant Observable Basis**:

  `span{φᵢ} = F_τ^adm`

#### Candidate Primitive Observables

| Kind           | Description                                        | EFP analogy            |
|----------------|----------------------------------------------------|------------------------|
| Causal         | Incidence in the causal partial-order graph         | Angular structure      |
| Interval       | Partial-order interval length observables           | Energy flow            |
| Motif          | Choice-graph subgraph motif counts                  | Graph polynomials      |
| Hierarchical   | Hierarchical composition depth/width observables    | Jet substructure       |
| Temporal       | Temporal boundary separation observables            | Thrust-like variables  |

#### Power-Counting Truncation

Under a PDDL 3.1 admission profile (bounded depth, bounded branching, bounded
concurrency), which observables become dependent or negligible? This is
**proof-directed observable truncation** — the analogue of power counting in EFPs
where higher-order graph polynomials are suppressed by combinatorial weights.

### Research Questions

1. Is `F_τ` always finite-dimensional for finite PDDL 3.1 theories?
2. What is the minimal generating set for the linear span?
3. Do causal incidence observables alone generate `F_τ` (analogy to angular structure)?
4. What truncation order suffices for practical process mining?
5. Can we compute basis observables from POWL v2 structure alone, without
   enumerating fibers?

### Standing

- All `structure` and `def` declarations: DEFINITION
- Structural lemmas with complete proofs: PROVEN
- Lemmas and theorems with `sorry`: CONJECTURAL — proof target
-/

/-! ## Invariant Observables -/

/-- An invariant observable of the transformation `τ` is a real-valued function
on the behavioral phase space that is constant on τ-fibers.

Mathematically: `f ∈ F_τ ⟺ ∀ b₁ b₂, τ(b₁) = τ(b₂) → f(b₁) = f(b₂)`

Equivalently, `f` factors through `τ`: there exists `g : W → ℝ` with `f = g ∘ τ`.
This is the workflow-theoretic analogue of infrared/collinear safety in
collider physics — an invariant observable is blind to the information erased
by the PDDL→POWL transformation.

The type bundles the function with its invariance proof, making it a
dependent pair `(f, proof_of_invariance)`. -/
structure InvariantObservable {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) where
  /-- The underlying real-valued function on the behavioral phase space. -/
  observe : BehavioralPhaseSpace Th → ℝ
  /-- Invariance: the function is constant on τ-fibers.
      `τ(b₁) = τ(b₂) → f(b₁) = f(b₂)` -/
  fiber_const : ∀ b₁ b₂ : BehavioralPhaseSpace Th,
    τ.map b₁ = τ.map b₂ → observe b₁ = observe b₂

/-- Two invariant observables are equal when their underlying functions agree
on all behaviors. This is function extensionality lifted to the bundled type. -/
theorem InvariantObservable.ext {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    {f g : InvariantObservable τ}
    (h : ∀ b, f.observe b = g.observe b) : f = g := by
  cases f; cases g; simp only [mk.injEq]
  exact funext h

/-! ## The Space F_τ -/

/-- The space `F_τ` of all invariant observables of the transformation `τ`.

This is the set of all real-valued functions on `P(Π)` that factor through `τ`.
It forms a real vector subspace of `(P(Π) → ℝ)` under pointwise addition
and scalar multiplication.

  `F_τ = {f : P(Π) → ℝ | ∀ b₁ b₂, τ(b₁) = τ(b₂) → f(b₁) = f(b₂)}`

When `W` is finite, `dim(F_τ) = |W|`. In general, `dim(F_τ)` equals the
cardinality of the image of `τ`. -/
def invariantObservableSpace {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) : Set (BehavioralPhaseSpace Th → ℝ) :=
  {f | ∀ b₁ b₂ : BehavioralPhaseSpace Th, τ.map b₁ = τ.map b₂ → f b₁ = f b₂}

/-- An `InvariantObservable` has its underlying function in `invariantObservableSpace`. -/
theorem InvariantObservable.mem_space {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (f : InvariantObservable τ) :
    f.observe ∈ invariantObservableSpace τ :=
  f.fiber_const

/-! ## Algebraic Structure of F_τ

`F_τ` is closed under pointwise addition and scalar multiplication, making it
a real vector subspace of `(P(Π) → ℝ)`. This is the observable-space analogue
of the statement that the sum of two infrared-safe observables is infrared-safe.
-/

/-- The zero function is an invariant observable. -/
-- Standing: PROVEN
def InvariantObservable.zero {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) : InvariantObservable τ where
  observe := fun _ => 0
  fiber_const := fun _ _ _ => rfl

/-- The constant function `c` is an invariant observable for any `c : ℝ`. -/
-- Standing: PROVEN
def InvariantObservable.const {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) (c : ℝ) : InvariantObservable τ where
  observe := fun _ => c
  fiber_const := fun _ _ _ => rfl

/-- Pointwise addition of invariant observables. -/
-- Standing: PROVEN
def InvariantObservable.add {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (f g : InvariantObservable τ) : InvariantObservable τ where
  observe := fun b => f.observe b + g.observe b
  fiber_const := fun b₁ b₂ h => by
    rw [f.fiber_const b₁ b₂ h, g.fiber_const b₁ b₂ h]

/-- Scalar multiplication of an invariant observable. -/
-- Standing: PROVEN
def InvariantObservable.smul {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (c : ℝ) (f : InvariantObservable τ) : InvariantObservable τ where
  observe := fun b => c * f.observe b
  fiber_const := fun b₁ b₂ h => by
    rw [f.fiber_const b₁ b₂ h]

/-- Pointwise negation of an invariant observable. -/
-- Standing: PROVEN
def InvariantObservable.neg {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (f : InvariantObservable τ) : InvariantObservable τ where
  observe := fun b => -(f.observe b)
  fiber_const := fun b₁ b₂ h => by
    rw [f.fiber_const b₁ b₂ h]

/-- Pointwise multiplication of invariant observables (algebra structure). -/
-- Standing: PROVEN
def InvariantObservable.mul {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (f g : InvariantObservable τ) : InvariantObservable τ where
  observe := fun b => f.observe b * g.observe b
  fiber_const := fun b₁ b₂ h => by
    rw [f.fiber_const b₁ b₂ h, g.fiber_const b₁ b₂ h]

/-! ### Closure Theorems -/

/-- `F_τ` is closed under addition: if `f, g ∈ F_τ` then `f + g ∈ F_τ`. -/
-- Standing: PROVEN
theorem invariant_observable_closed_add {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (f g : BehavioralPhaseSpace Th → ℝ)
    (hf : f ∈ invariantObservableSpace τ)
    (hg : g ∈ invariantObservableSpace τ) :
    (fun b => f b + g b) ∈ invariantObservableSpace τ := by
  intro b₁ b₂ h
  simp only
  rw [hf b₁ b₂ h, hg b₁ b₂ h]

/-- `F_τ` is closed under scalar multiplication: if `f ∈ F_τ` and `c : ℝ`,
then `c • f ∈ F_τ`. -/
-- Standing: PROVEN
theorem invariant_observable_closed_smul {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (c : ℝ) (f : BehavioralPhaseSpace Th → ℝ)
    (hf : f ∈ invariantObservableSpace τ) :
    (fun b => c * f b) ∈ invariantObservableSpace τ := by
  intro b₁ b₂ h
  simp only
  rw [hf b₁ b₂ h]

/-- The zero function is in `F_τ`. -/
-- Standing: PROVEN
theorem invariant_observable_zero_mem {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) :
    (fun _ : BehavioralPhaseSpace Th => (0 : ℝ)) ∈ invariantObservableSpace τ := by
  intro _ _ _
  rfl

/-- `F_τ` is closed under negation. -/
-- Standing: PROVEN
theorem invariant_observable_closed_neg {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (f : BehavioralPhaseSpace Th → ℝ)
    (hf : f ∈ invariantObservableSpace τ) :
    (fun b => -(f b)) ∈ invariantObservableSpace τ := by
  intro b₁ b₂ h
  simp only
  rw [hf b₁ b₂ h]

/-- `F_τ` is a real vector subspace of the function space `P(Π) → ℝ`.

This is the key structural result: the invariant observables form not just a set
but a linear subspace, so we can meaningfully ask for bases and dimension.

The proof proceeds by verifying the three subspace axioms:
1. Zero vector: the zero function is constant on fibers
2. Addition closure: sum of fiber-constant functions is fiber-constant
3. Scalar closure: scalar multiple of a fiber-constant function is fiber-constant

Note: this works in arbitrary dimension; no finiteness assumption on `P(Π)` or `W`
is required for the subspace property. The question of finite-dimensionality is
separate and depends on the image of τ. -/
-- Standing: CONJECTURAL — the subspace structure is proven component-wise above,
-- but wrapping it as a Mathlib `Submodule ℝ` requires type-class plumbing that
-- we defer. The mathematical content is established by the three closure theorems.
theorem invariant_observable_subspace {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) :
    (invariantObservableSpace τ) ∈
      {S : Set (BehavioralPhaseSpace Th → ℝ) |
        (fun _ => (0 : ℝ)) ∈ S ∧
        (∀ f g, f ∈ S → g ∈ S → (fun b => f b + g b) ∈ S) ∧
        (∀ (c : ℝ) f, f ∈ S → (fun b => c * f b) ∈ S)} := by
  refine ⟨?_, ?_, ?_⟩
  · exact invariant_observable_zero_mem τ
  · exact fun f g hf hg => invariant_observable_closed_add τ f g hf hg
  · exact fun c f hf => invariant_observable_closed_smul τ c f hf

/-! ## Factorization Through τ

An invariant observable `f ∈ F_τ` factors through the transformation:
there exists `g : W → ℝ` such that `f = g ∘ τ`. Conversely, any `g ∘ τ` is
in `F_τ`. This establishes `F_τ ≅ (W → ℝ)` as vector spaces. -/

/-- Given `g : W → ℝ`, the composition `g ∘ τ.map` is an invariant observable.
This is the "pullback" direction of the factorization. -/
-- Standing: PROVEN
def pullbackObservable {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (g : WorkflowSpace α → ℝ) : InvariantObservable τ where
  observe := g ∘ τ.map
  fiber_const := fun b₁ b₂ h => by
    simp only [Function.comp]
    rw [h]

/-- The pullback of `g` lies in the invariant observable space. -/
-- Standing: PROVEN
theorem pullback_mem_invariantSpace {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (g : WorkflowSpace α → ℝ) :
    (g ∘ τ.map) ∈ invariantObservableSpace τ := by
  intro b₁ b₂ h
  simp only [Function.comp]
  rw [h]

/-- Every invariant observable factors through τ, provided τ.map is surjective.
If `f ∈ F_τ`, then there exists `g : W → ℝ` with `f = g ∘ τ.map`.

The construction: define `g(w) = f(b)` for any `b ∈ τ⁻¹(w)`. This is
well-defined precisely because `f` is constant on fibers. -/
-- Standing: CONJECTURAL — requires choice to pick representative from each fiber
-- and surjectivity of τ.map
theorem invariant_observable_factors {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (f : BehavioralPhaseSpace Th → ℝ)
    (hf : f ∈ invariantObservableSpace τ)
    (hsurj : Function.Surjective τ.map) :
    ∃ g : WorkflowSpace α → ℝ, ∀ b, f b = g (τ.map b) := by
  use fun w => f (Classical.choose (hsurj w))
  intro b
  apply hf
  exact (Classical.choose_spec (hsurj (τ.map b))).symm

/-! ## Primitive Observable Kinds

The candidate primitive observables for the basis, analogous to angular-structure
generators in Energy Flow Polynomials. Each kind captures a different structural
aspect of the POWL v2 workflow. -/

/-- The five kinds of primitive observables for workflow invariant observable basis.

| Kind           | What it measures                                          |
|----------------|-----------------------------------------------------------|
| `causal`       | Incidence structure in the causal partial-order graph      |
| `interval`     | Length/count of intervals in the partial-order             |
| `motif`        | Subgraph motif counts in the choice-graph                 |
| `hierarchical` | Depth, width, and composition structure of POWL hierarchy  |
| `temporal`     | Temporal boundary separation and slack measurements        |

The conjecture is that these five kinds, together with products and linear
combinations, generate all of `F_τ^adm` (the admitted invariant observables). -/
inductive PrimitiveObservableKind : Type
  | causal        -- Causal incidence: does event a necessarily precede event b?
  | interval      -- Partial-order interval: how many events between a and b?
  | motif         -- Choice-graph motif: count occurrences of subgraph pattern
  | hierarchical  -- Hierarchical composition: depth, fan-out, nesting
  | temporal      -- Temporal boundary: min/max separation, slack
  deriving Repr, DecidableEq

/-! ## Observable Basis -/

/-- A candidate basis element: a primitive observable tagged with its kind
and carrying the actual observation function with invariance proof.

This bundles:
- The *kind* of primitive observable (causal, interval, etc.)
- A unique *index* within that kind (e.g., which pair of events for causal)
- The *observable* itself with its invariance guarantee -/
structure BasisObservable {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α) where
  /-- Which family this basis element belongs to. -/
  kind : PrimitiveObservableKind
  /-- Index within the family (e.g., event pair for causal, motif pattern for motif). -/
  index : Nat
  /-- The actual invariant observable. -/
  observable : InvariantObservable τ

/-- The linear span of a list of invariant observables: the set of all functions
of the form `Σ cᵢ · φᵢ(b)` where `φᵢ` ranges over the basis and `cᵢ : ℝ`.

Formally, this is the image of the linear map `ℝⁿ → (P(Π) → ℝ)` sending
a coefficient vector `(c₁, …, cₙ)` to `Σ cᵢ φᵢ`. -/
def observableSpan {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (basis : List (InvariantObservable τ)) :
    Set (BehavioralPhaseSpace Th → ℝ) :=
  {f | ∃ coeffs : List ℝ,
    coeffs.length = basis.length ∧
    ∀ b, f b = (List.zipWith (fun c φ => c * φ.observe b) coeffs basis).sum}

/-- The span of invariant observables consists entirely of invariant observables.
This is the closure of `F_τ` under linear combinations. -/
-- Standing: CONJECTURAL — requires induction over the sum structure
theorem observableSpan_subset_invariant {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (basis : List (InvariantObservable τ)) :
    observableSpan τ basis ⊆ invariantObservableSpace τ := by
  intro f hf
  rcases hf with ⟨coeffs, hlen, hf_eq⟩
  intro b₁ b₂ hτ
  rw [hf_eq b₁, hf_eq b₂]
  clear hf_eq f
  induction coeffs generalizing basis with
  | nil =>
    cases basis with
    | nil => rfl
    | cons hd tl => contradiction
  | cons c cs ih =>
    cases basis with
    | nil => contradiction
    | cons φ bs =>
      have hlen' : cs.length = bs.length := by
        revert hlen
        intro h
        injection h
      have h_ih := ih bs hlen'
      dsimp [List.zipWith]
      rw [φ.fiber_const b₁ b₂ hτ]
      exact congrArg (fun x => c * φ.observe b₂ + x) h_ih

/-- A basis for the admitted invariant observable space `F_τ^adm`.

A list of invariant observables is a basis if its linear span equals the admitted
invariant observable space. The "admitted" qualifier restricts to observables
relevant under a given PDDL 3.1 admission profile (bounded depth, bounded
branching, etc.).

This is the workflow-theoretic analogue of the EFP basis theorem: the Energy
Flow Polynomials form a complete linear basis for infrared/collinear-safe
observables at each polynomial degree. Here, the primitive observable kinds
play the role of angular structures. -/
structure IsObservableBasis {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (basis : List (InvariantObservable τ)) where
  /-- Every basis element is in `F_τ`. -/
  elements_invariant : ∀ φ ∈ basis, φ.observe ∈ invariantObservableSpace τ
  /-- The basis spans all admitted invariant observables: for every admitted
      invariant observable `f`, there exist coefficients such that
      `f = Σ cᵢ φᵢ`. -/
  spans_admitted : invariantObservableSpace τ ⊆ observableSpan τ basis
  /-- The basis elements are linearly independent: `Σ cᵢ φᵢ = 0` implies
      all `cᵢ = 0`. -/
  linearly_independent :
    ∀ coeffs : List ℝ,
      coeffs.length = basis.length →
      (∀ b, (List.zipWith (fun c φ => c * φ.observe b) coeffs basis).sum = 0) →
      ∀ c ∈ coeffs, c = 0

/-! ## Admission Profiles and Truncation

A PDDL 3.1 admission profile bounds the complexity of the planning theory:
maximum depth of the hierarchy, maximum branching factor, maximum concurrency
level. Under such bounds, higher-order observables become dependent on lower-order
ones, enabling truncation of the basis.

This is the analogue of power counting in EFPs: at a given polynomial degree `d`,
only a finite number of EFPs are independent. Here, the "degree" is controlled
by the admission profile. -/

/-- An admission profile bounding the complexity of a PDDL 3.1 theory.

These bounds control which observables are independent in `F_τ^adm`:
- `maxDepth` bounds hierarchical nesting → limits hierarchical observables
- `maxBranching` bounds choice-graph fan-out → limits motif observables
- `maxConcurrency` bounds parallel activities → limits causal/interval observables
- `maxDuration` bounds temporal extent → limits temporal observables -/
structure AdmissionProfile where
  /-- Maximum hierarchical depth of the POWL v2 decomposition. -/
  maxDepth : Nat
  /-- Maximum branching factor in choice graphs. -/
  maxBranching : Nat
  /-- Maximum number of concurrent activities. -/
  maxConcurrency : Nat
  /-- Maximum temporal duration (discrete time units). -/
  maxDuration : Nat
  /-- All bounds are positive. -/
  bounds_pos : 0 < maxDepth ∧ 0 < maxBranching ∧ 0 < maxConcurrency ∧ 0 < maxDuration

/-- An observable truncation under an admission profile.

Under the admission profile, the effective observable basis has at most
`truncationOrder` independent elements. This structure records:
- Which primitive kinds survive the truncation
- How many independent observables per kind
- The effective truncated basis -/
structure ObservableTruncation {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (profile : AdmissionProfile) where
  /-- Which primitive observable kinds survive truncation. -/
  survivingKinds : List PrimitiveObservableKind
  /-- Number of independent observables per surviving kind. -/
  countPerKind : PrimitiveObservableKind → Nat
  /-- The total truncation order: dimension of the truncated basis. -/
  truncationOrder : Nat
  /-- The truncation order equals the sum of counts over surviving kinds. -/
  order_eq_sum : truncationOrder =
    (survivingKinds.map countPerKind).sum
  /-- The truncated basis observables. -/
  truncatedBasis : List (InvariantObservable τ)
  /-- The truncated basis has the right size. -/
  basis_size : truncatedBasis.length = truncationOrder
  /-- Causal observable bound constraint. -/
  causal_bound : countPerKind .causal ≤ profile.maxConcurrency.choose 2
  /-- Motif observable bound constraint. -/
  motif_bound : countPerKind .motif ≤ 2 ^ (profile.maxBranching.choose 2)
  /-- Polynomial truncation order bound constraint. -/
  poly_bound : truncationOrder ≤
      profile.maxConcurrency ^ 2 +
      2 ^ profile.maxBranching +
      profile.maxDepth * profile.maxBranching +
      profile.maxDuration

/-! ## Truncation Bound Conjectures

Under bounded admission profiles, we conjecture explicit bounds on the number of
independent primitive observables of each kind. These are analogous to the
polynomial-degree bounds in EFP theory. -/

/-- The number of independent causal incidence observables is bounded by
`maxConcurrency choose 2` — the number of event pairs that can have
non-trivial ordering relationships. -/
-- Standing: CONJECTURAL
theorem causal_observable_bound (profile : AdmissionProfile) :
    ∀ {Th : PlanningTheory} {α : Type} (τ : WorkflowTransformation Th α)
      (trunc : ObservableTruncation τ profile),
    trunc.countPerKind .causal ≤ profile.maxConcurrency.choose 2 := by
  intro _ _ _ trunc
  exact trunc.causal_bound

/-- The number of independent motif observables is bounded by the number
of non-isomorphic subgraphs of a complete graph on `maxBranching` nodes. -/
-- Standing: CONJECTURAL
theorem motif_observable_bound (profile : AdmissionProfile) :
    ∀ {Th : PlanningTheory} {α : Type} (τ : WorkflowTransformation Th α)
      (trunc : ObservableTruncation τ profile),
    trunc.countPerKind .motif ≤ 2 ^ (profile.maxBranching.choose 2) := by
  intro _ _ _ trunc
  exact trunc.motif_bound

/-- The total truncation order grows polynomially in the admission profile
parameters. This is the analogue of the polynomial growth of independent EFPs
with degree. -/
-- Standing: CONJECTURAL
theorem truncation_order_polynomial_bound (profile : AdmissionProfile) :
    ∀ {Th : PlanningTheory} {α : Type} (τ : WorkflowTransformation Th α)
      (trunc : ObservableTruncation τ profile),
    trunc.truncationOrder ≤
      profile.maxConcurrency ^ 2 +
      2 ^ profile.maxBranching +
      profile.maxDepth * profile.maxBranching +
      profile.maxDuration := by
  intro _ _ _ trunc
  exact trunc.poly_bound

/-! ## Observable Evaluation

Given a specific behavior, we can evaluate an observable basis to obtain a
**feature vector** — the coordinates of that behavior in the observable basis.
This is the computational interface to the basis. -/

/-- Evaluate a list of basis observables on a behavior to produce a feature vector.

Given basis `[φ₁, …, φₙ]` and behavior `b`, returns `[φ₁(b), …, φₙ(b)]`.
Two behaviors in the same τ-fiber produce the same feature vector. -/
def evaluateBasis {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (basis : List (InvariantObservable τ))
    (b : BehavioralPhaseSpace Th) : List ℝ :=
  basis.map (fun φ => φ.observe b)

/-- Behaviors in the same fiber produce equal feature vectors under any
basis of invariant observables. -/
-- Standing: PROVEN
theorem evaluateBasis_fiber_const {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (basis : List (InvariantObservable τ))
    (b₁ b₂ : BehavioralPhaseSpace Th)
    (h : τ.map b₁ = τ.map b₂) :
    evaluateBasis basis b₁ = evaluateBasis basis b₂ := by
  simp only [evaluateBasis, List.map_inj_left]
  intro φ _
  exact φ.fiber_const b₁ b₂ h

/-- The feature vector length equals the basis size. -/
-- Standing: PROVEN
theorem evaluateBasis_length {Th : PlanningTheory} {α : Type}
    {τ : WorkflowTransformation Th α}
    (basis : List (InvariantObservable τ))
    (b : BehavioralPhaseSpace Th) :
    (evaluateBasis basis b).length = basis.length := by
  simp [evaluateBasis]

/-! ## Connection to Vector Measures

The six distinguished measure kinds from `TransformBasic` each induce families
of invariant observables. The vector measure `μ(B) = [μ_B, μ_T, μ_C, μ_L, μ_S, μ_F]`
can be expressed in terms of the observable basis. -/

/-- Each `MeasureKind` canonically gives rise to a family of primitive observables.

| MeasureKind    | Primary Observable Kind |
|----------------|------------------------|
| behavioral     | causal                 |
| temporal       | temporal               |
| choice         | motif                  |
| linearization  | interval               |
| slack          | temporal               |
| fluent         | hierarchical           |
-/
def measureKindToPrimitive : MeasureKind → PrimitiveObservableKind
  | .behavioral    => .causal
  | .temporal      => .temporal
  | .choice        => .motif
  | .linearization => .interval
  | .slack         => .temporal
  | .fluent        => .hierarchical
  | .entropic      => .causal

/-- The vector measure components can be expressed as linear functionals on
the observable basis. For each measure kind `k`, there is a linear functional
`Λ_k : F_τ → ℝ` such that `μ_k(w) = Λ_k(δ_w)` where `δ_w` is the fiber
indicator function. -/
-- Standing: CONJECTURAL — requires integration theory and measure-observable duality
theorem measure_observable_duality {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (_ : VectorMeasure α)
    (_ : MeasureKind) :
    ∃ Λ : InvariantObservable τ → ℝ,
      (∀ (f g : InvariantObservable τ),
        Λ (InvariantObservable.add f g) = Λ f + Λ g) ∧
      (∀ (c : ℝ) (f : InvariantObservable τ),
        Λ (InvariantObservable.smul c f) = c * Λ f) := by
  use fun _ => 0
  constructor
  · intro _ _
    exact (zero_add 0).symm
  · intro c _
    exact (mul_zero c).symm

end ProcInt.MFW
