import Mathlib
import ProcInt.MFW.TransformBasic

namespace ProcInt.MFW

open Classical

/-!
# ProcInt.MFW.IntrinsicDimension

## Layer 7 — Intrinsic Dimension Loss

### Derivation Chain Position

```
Layer 0  P(Th) behavioral phase space          [TransformBasic]
Layer 1  W workflow space                      [TransformBasic]
Layer 2  τ : P(Th) → W                         [TransformBasic]
Layer 3  Fiber F_w = τ⁻¹(w)                   [TransformBasic]
Layer 4  Pushforward μ = τ_*ν                  [TransformBasic]
Layer 5  (reserved: spectral)
Layer 6  (reserved: multifractal)
Layer 7  Intrinsic dimension loss Δd_τ         [this file]
```

### Mathematical Content

The PDDL 3.1 behavioral phase space `P(Th)` has coordinates drawn from five
independent families:

  `x = (event occurrence, temporal, object-fluent, numeric, trajectory)`

Admissibility imposes equality constraints `C(x) = 0` (causal structure,
state-variable consistency) and inequality constraints `G(x) ≤ 0` (temporal
bounds, resource limits). The lawful space is generically *stratified*:
different discrete choice patterns produce pieces of different local
dimension.

  `P(Th) = ⋃_{σ ∈ Σ} P_σ`

where `Σ` indexes choice strata (action selection patterns, branch choices)
and each stratum `P_σ` is the subset of `P(Th)` with that discrete pattern.
Within a stratum, continuous degrees of freedom — temporal slack, numeric
state, trajectory parameters — govern the local intrinsic dimension.

#### Collider-Physics Analogy

In collider phase-space analysis, event-space geometry is treated as a
*global signal*: the intrinsic dimension of the phase-space region occupied
by events reveals the underlying process. We appropriate this mathematical
question directly:

**Define** the local intrinsic dimension `d_loc(x)` at a point `x` of the
behavioral phase space. Then the **transformation dimension loss** is:

  `Δd_τ(x) = d_loc^PDDL(x) - d_loc^POWL(τ(x))`

This is *stronger* than counting fiber cardinality. A fiber may contain
uncountably many points if temporal slack is high, yet all may lie on a
low-dimensional manifold. Conversely, a finite fiber of `k` points has
dimension 0, while the source may have had dimension `k - 1` in continuous
parameters. Dimension loss captures the number of *independent lawful
directions* destroyed by the transformation.

#### Null Perturbation Space

The **POWL-invisible perturbation** null space at a behavior `b` is:

  `Null_τ(b) = {δ : τ(b ⊕ δ) = τ(b)}`

all lawful perturbations that leave the POWL v2 classification unchanged.
We classify perturbations by kind:

- **Temporal**: shift timestamps within slack
- **Fluent**: alter object-fluent valuations
- **Numeric**: change numeric state values
- **Trajectory**: modify trajectory-constraint witnesses

Each kind reveals a different mode of transformation insensitivity.

### Research Questions

1. Is `Δd_τ(x) ≥ 0` always? (Yes if τ is Lipschitz on each stratum.)
2. Does `Δd_τ(x) = 0` characterize local invertibility of τ?
3. How does the null perturbation space decompose by perturbation kind?
4. Does the stratification of `P(Th)` induce a natural Whitney stratification?

### Standing

- Plain `structure` and `def` declarations carry no standing claim.
- Structural lemmas with complete proofs are tagged PROVEN; where a proof
  is discharged only by a stub dimension model, the tag says so.
- Statement-shaped `def ... : Prop` declarations are tagged CONJECTURAL
  with a named blocker; they impose no proof obligation.
-/

/-! ## Phase-Space Coordinate Kinds

The five coordinate families of `P(Th)`.  These correspond to independent
parameter families that together parameterize the behavioral phase space.
A point `x ∈ P(Th)` has projections onto each coordinate kind. -/

/-- [Notation Authority §91] The five independent coordinate families of the behavioral phase space.

Every point `x ∈ P(Th)` has components in each family:
- `eventOccurrence`: which events occur and in what order (discrete)
- `temporal`: timestamp assignments (continuous, modulo constraint surfaces)
- `objectFluent`: object-valued fluent configurations
- `numeric`: numeric fluent values (continuous)
- `trajectory`: trajectory constraint witness structure -/
inductive PhaseCoordinateKind : Type
  /-- Which events occur, and in what order. -/
  | eventOccurrence
  /-- Timestamp assignments. -/
  | temporal
  /-- Object-valued fluent configurations. -/
  | objectFluent
  /-- Numeric fluent values. -/
  | numeric
  /-- Trajectory constraint witnesses. -/
  | trajectory
  deriving Repr, DecidableEq

/-! ## Stratification

The behavioral phase space is not a smooth manifold — it is *stratified*.
Different action selection patterns yield subsets of different local
dimension.  The stratification is indexed by a discrete choice label `σ`
that captures which branch of every decision point was taken. -/

/-- [Notation Authority §92] A choice stratum label.

`σ ∈ Σ` encodes a complete discrete choice pattern: which actions were
selected, which branches of `(or ...)` goals were pursued, which XOR-choice
submodels were entered.  Two behaviors in the same stratum differ only in
their continuous parameters (temporal placement, numeric values). -/
structure StratumLabel where
  /-- An opaque identifier for the discrete choice pattern. -/
  id : Nat
  deriving Repr, DecidableEq

/-- [Notation Authority §93] A stratum of the behavioral phase space.

`P_σ` is the subset of `P(Th)` whose behaviors share the discrete choice
pattern `σ`.  Within a stratum the remaining freedom is continuous
(temporal slack, numeric state).  The local intrinsic dimension is constant
on the interior of a stratum. -/
structure Stratum (Th : PlanningTheory) where
  /-- The discrete choice pattern defining this stratum. -/
  label : StratumLabel
  /-- Membership predicate. -/
  mem : BehavioralPhaseSpace Th → Prop
  /-- The local intrinsic dimension within this stratum.
      This counts the number of independent continuous degrees of freedom
      (temporal slack, numeric state, etc.) available to behaviors sharing
      the same discrete choice pattern `σ`. -/
  localDim : ℕ

/-- [Notation Authority §94] The full stratified decomposition of the behavioral phase space.

  `P(Th) = ⋃_{σ ∈ Σ} P_σ`

Different strata may overlap only on their boundaries (lower-dimensional
pieces where constraint surfaces intersect). -/
structure StratifiedPhaseSpace (Th : PlanningTheory) where
  /-- The collection of strata. -/
  strata : List (Stratum Th)
  /-- Every lawful behavior belongs to at least one stratum. -/
  covering : ∀ b : BehavioralPhaseSpace Th, ∃ s ∈ strata, s.mem b

/-! ## Local Intrinsic Dimension

The local intrinsic dimension at a point `x ∈ P(Th)` is the dimension of
the constraint surface near `x`.  On a smooth stratum interior this is the
number of independent continuous parameters.  At stratum boundaries the
dimension drops.

Analogously, the POWL v2 workflow space `W` has a local dimension at each
point `w`.  The **dimension loss** is the difference. -/

/-- [Notation Authority §95] Local intrinsic dimension at a point of a space.

`d_loc(x)` counts the number of independent continuous degrees of freedom
available in an infinitesimal neighborhood of `x`.

For a behavior `b ∈ P_σ` in the interior of stratum `σ`:
  `d_loc^PDDL(b) = dim(P_σ)`
which equals the number of free continuous parameters (temporal slack
variables, unconstrained numeric fluents, etc.) after all equality and
active inequality constraints are imposed. -/
structure LocalDimension where
  /-- The intrinsic dimension value (a natural number for manifold-like spaces,
      or could be extended to ℝ for fractal dimensions). -/
  dim : ℕ
  deriving Repr
  -- Well-definedness (the point lies in the interior of some regular stratum) is NOT
  -- captured by this structure. A former `wellDefined : Prop` data field stored an
  -- arbitrary caller-chosen proposition while its doc claimed the constraint was
  -- enforced; it was removed. Consumers needing well-definedness must take it as an
  -- explicit hypothesis.

/-- [Notation Authority §96] Compute the local dimension of a behavior in the PDDL 3.1 phase space.
This requires identifying which stratum `b` belongs to and returning
that stratum's local dimension.

Given a stratified phase space decomposition and a behavior `b`, the
PDDL-side local dimension is the maximum dimension among all strata
containing `b` (taking the generic/interior value). -/
noncomputable def pddlLocalDim {Th : PlanningTheory}
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th) : ℕ :=
  -- Take the supremum of stratum dimensions containing b.
  -- In the generic case (interior of one stratum) this is unique.
  let containing := S.strata.filter (fun s => s.mem b)
  containing.foldl (fun acc s => max acc s.localDim) 0

/-- [Notation Authority §97] The local dimension on the POWL v2 workflow side.

At a workflow class `w ∈ W`, the local dimension is the number of
independent parameters in the POWL v2 representation near `w`.
For a discrete POWL v2 model this is typically 0 for the structural
component, but temporal POWL v2 may have continuous parameters. -/
noncomputable def powlLocalDim {α : Type}
    (_w : WorkflowSpace α) : ℕ :=
  -- Placeholder: in a temporal POWL v2, the local dimension at w
  -- could be the number of free temporal parameters in the workflow
  -- template.  For the purely structural (untimed) case, this is 0.
  0

/-! ## Transformation Dimension Loss

The central quantity of this layer:

  `Δd_τ(b) = d_loc^PDDL(b) - d_loc^POWL(τ(b))`

This is the number of independent lawful degrees of freedom erased by
the transformation.

**Why dimension, not cardinality?**
- A fiber with uncountably many points (continuous temporal slack) may
  have low dimension.
- A fiber of |F_w| = k discrete points has dimension 0.
- Dimension loss captures independent *directions* lost, a fundamentally
  geometric quantity.

**Relation to fiber dimension:**
  `Δd_τ(b) = dim(F_{τ(b)})` when τ is a submersion on the stratum
  containing `b` (i.e. the fiber theorem applies).
-/

/-- [Notation Authority §98] The transformation dimension loss at a behavior `b`.

  `Δd_τ(b) = d_loc^PDDL(b) - d_loc^POWL(τ(b))`

Returns the signed difference as an integer to handle the (degenerate)
case where the POWL side has higher local dimension than expected.
Under normal conditions `Δd_τ ≥ 0`. -/
noncomputable def transformationDimensionLoss {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th) : ℤ :=
  (pddlLocalDim S b : ℤ) - (powlLocalDim (τ.map b) : ℤ)

/-- Dimension loss is non-negative.

Under the current model this holds only because `powlLocalDim` is a
hardcoded 0 stub, so the loss reduces to `(pddlLocalDim S b : ℤ) ≥ 0`.

The intended general statement — if τ is Lipschitz on each stratum it
cannot increase local dimension, hence `Δd_τ(b) ≥ 0` — remains open and
needs a Lipschitz regularity hypothesis on τ that is not yet formalized.

Standing: PROVEN — discharged under the current stub dimension model
(powlLocalDim ≡ 0); strengthen when real POWL-side dimensions land. -/
theorem dimension_loss_nonneg {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th) :
    0 ≤ transformationDimensionLoss τ S b := by
  -- Requires: τ is Lipschitz on each stratum of S.
  -- Then d_loc^POWL(τ(b)) ≤ d_loc^PDDL(b) by Lipschitz dimension bound.
  simp [transformationDimensionLoss, powlLocalDim]

/-- **Conjecture:** Zero dimension loss characterizes local invertibility.

  `Δd_τ(b) = 0 ↔ τ is locally invertible at b`

When no dimension is lost, the transformation preserves all continuous
degrees of freedom, hence admits a local inverse (up to discrete
stratum labelling).

Forward direction: Δd = 0 implies the differential/tangent map of τ
is an isomorphism, hence τ is a local diffeomorphism by the inverse
function theorem.

Reverse direction: if τ is a local diffeomorphism, it preserves local
dimension.

`P(Th)` and `W` carry no smooth structure yet, so "τ is a local
diffeomorphism at `b`" cannot be stated internally.  It is therefore an
explicit hypothesis `locallyInvertible` supplied by the consumer, not a
hidden `True` placeholder.  This is a `def : Prop` — a statement shape,
not an asserted or proven result.

Standing: CONJECTURAL — requires smooth structure on P(Th) and W to
formalize local diffeomorphism; no proof obligation exists yet. -/
def DimensionLossZeroIffLocalDiffeo {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th)
    (locallyInvertible : Prop) : Prop :=
    transformationDimensionLoss τ S b = 0 ↔ locallyInvertible

/-! ## Fiber Dimension

The dimension of the fiber `F_w = τ⁻¹(w)` is a measure of the
geometric complexity of the set of behaviors collapsed to `w`.

When τ is a submersion on a stratum, the fiber theorem gives:
  `dim(F_w) = dim(P_σ) - dim(W_local) = Δd_τ`

In general (stratified, non-smooth) the fiber may itself be stratified
and we define its dimension as the maximum stratum dimension restricted
to the fiber. -/

/-- [Notation Authority §99] The dimension of a fiber `F_w`, defined as the maximum local dimension
among all strata restricted to the fiber.

  `dim(F_w) = max_{σ : P_σ ∩ F_w ≠ ∅} dim_σ(F_w)`

This is the number of independent continuous degrees of freedom within
the set of behaviors that τ identifies with workflow class `w`. -/
noncomputable def fiberDimension {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (w : WorkflowSpace α) : ℕ :=
  -- For each stratum, if it intersects the fiber, contribute its localDim.
  -- The fiber dimension is the maximum such value.
  -- In the submersion case: fiberDimension = pddlLocalDim - powlLocalDim.
  let fiberStrata := S.strata.filter
    (fun s => ∃ b, s.mem b ∧ τ.map b = w)
  fiberStrata.foldl (fun acc s => max acc s.localDim) 0

/-- **Conjecture:** When τ is a submersion on a stratum,
fiber dimension equals transformation dimension loss.

  `dim(F_{τ(b)}) = Δd_τ(b)`

This is a consequence of the fiber theorem (preimage theorem) in
differential geometry: if τ is a submersion at `b`, then `F_{τ(b)}`
is a smooth submanifold of dimension `dim(P_σ) - dim(W)`.

This is a `def : Prop` — a statement shape, not an asserted or proven
result.

Standing: CONJECTURAL — requires a submersion hypothesis on τ at `b` and
smooth structure on P(Th) and W, none of which is formalized yet. -/
def FiberDimEqDimensionLoss {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th) : Prop :=
    (fiberDimension τ S (τ.map b) : ℤ) = transformationDimensionLoss τ S b

/-! ## Perturbation Kinds

We classify perturbations of a behavior by which coordinate family they
affect.  This classification is fundamental because different perturbation
kinds reveal different modes of transformation insensitivity:

- A temporally invisible perturbation means the workflow doesn't see
  timestamp shifts → temporal slack is lost information.
- A numerically invisible perturbation means the workflow doesn't see
  numeric state changes → numeric precision is lost information.
-/

/-- [Notation Authority §100] A classification of perturbation kinds by which coordinate family
of `P(Th)` they affect.

A perturbation `δ` displaces a behavior `b` to `b ⊕ δ` along one or
more coordinate families.  We classify by the *primary* coordinate
family affected. -/
inductive PerturbationKind : Type
  /-- Shift event timestamps within feasible slack. -/
  | temporal
  /-- Alter object-fluent valuations. -/
  | fluent
  /-- Change numeric fluent values. -/
  | numeric
  /-- Modify trajectory-constraint witness structure. -/
  | trajectory
  deriving Repr, DecidableEq

/-! ## Null Perturbation Space

The null perturbation space at `b` under `τ`:

  `Null_τ(b) = {δ : τ(b ⊕ δ) = τ(b)}`

all lawful perturbations invisible to the transformation.  This is the
*tangent space to the fiber* at `b` when the fiber is smooth, and its
dimension equals `dim(F_{τ(b)})` at regular points.

The null space decomposes by perturbation kind:
  `Null_τ(b) = Null_τ^temp(b) ⊕ Null_τ^fluent(b) ⊕ Null_τ^num(b) ⊕ Null_τ^traj(b)`
giving a finer accounting of *what type* of information the transformation
discards.
-/

/-- [Notation Authority §101] A perturbation of a behavior: a displacement
in the behavioral phase space.

Mathematically `δ` is a tangent vector at `b ∈ P(Th)`, or more precisely
an element of the perturbation space at `b` (which is a subset of the
tangent cone when the space is stratified).

The perturbation carries:
- The perturbed behavior `b ⊕ δ`
- The kind of coordinate family primarily affected

Lawfulness is enforced by the field types: `base` and `perturbed` inhabit
`BehavioralPhaseSpace Th = LawfulBehavior Th`, whose every inhabitant carries an
`IsLawful` proof. (A former `lawful : Prop` data field stored an arbitrary
caller-chosen proposition while its doc claimed lawfulness was enforced; it was
removed as redundant and misleading.) -/
structure Perturbation (Th : PlanningTheory) where
  /-- The original behavior. -/
  base : BehavioralPhaseSpace Th
  /-- The perturbed behavior `b ⊕ δ` (lawful by the type of this field). -/
  perturbed : BehavioralPhaseSpace Th
  /-- Which coordinate family this perturbation primarily affects. -/
  kind : PerturbationKind

/-- [Notation Authority §102] The null perturbation space at a behavior `b`
under transformation `τ`.

  `Null_τ(b) = {δ : τ(b ⊕ δ) = τ(b)}`

This is the set of all lawful perturbations that are invisible to the
transformation — they change the PDDL 3.1 behavior without changing its
POWL v2 classification.

The null space is the *fiber tangent space* at regular points:
  `T_b(F_{τ(b)}) = Null_τ(b)`

Its dimension equals the fiber dimension at smooth points:
  `dim(Null_τ(b)) = dim(F_{τ(b)}) = Δd_τ(b)` -/
def NullPerturbation {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th) : Set (Perturbation Th) :=
  {δ | δ.base = b ∧ τ.map δ.perturbed = τ.map b}

/-- [Notation Authority §103] The null perturbation space restricted to a
specific perturbation kind.

  `Null_τ^k(b) = {δ ∈ Null_τ(b) : kind(δ) = k}`

This gives the component of τ-invisible perturbations along coordinate
family `k`.  For example:
- `Null_τ^temp(b)` = temporal perturbations invisible to τ
  (timestamp shifts within slack that POWL doesn't see)
- `Null_τ^num(b)` = numeric perturbations invisible to τ
  (numeric state changes that POWL doesn't see) -/
def NullPerturbationOfKind {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (k : PerturbationKind) : Set (Perturbation Th) :=
  {δ ∈ NullPerturbation τ b | δ.kind = k}

/-- [Notation Authority §104] Classify which perturbation kinds have non-trivial null components
at a behavior `b` under transformation `τ`.

Returns the set of perturbation kinds `k` for which there exists a
non-trivial perturbation of kind `k` that is invisible to τ.

This classification reveals *what type* of information the transformation
discards at each point of the behavioral phase space. -/
def classifyNullPerturbation {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th) : Set PerturbationKind :=
  {k | ∃ δ ∈ NullPerturbationOfKind τ b k,
         δ.perturbed ≠ δ.base}

/-! ## Structural Lemmas -/

/-- [Notation Authority §105] The trivial (zero) perturbation is always in the null space.
Standing: PROVEN -/
theorem trivial_perturbation_in_null {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (k : PerturbationKind)
    (δ₀ : Perturbation Th)
    (h_base : δ₀.base = b)
    (h_pert : δ₀.perturbed = b)
    (_h_kind : δ₀.kind = k) :
    δ₀ ∈ NullPerturbation τ b := by
  simp [NullPerturbation, Set.mem_setOf_eq]
  exact ⟨h_base, by rw [h_pert]⟩

/-- [Notation Authority §106] The null perturbation of kind `k` is a subset of the full null space.
Standing: PROVEN -/
theorem null_kind_subset_null {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (k : PerturbationKind) :
    NullPerturbationOfKind τ b k ⊆ NullPerturbation τ b := by
  intro δ hδ
  exact hδ.1

/-- [Notation Authority §107] Null perturbations preserve the transformation equivalence class.
If `δ ∈ Null_τ(b)` then `b ~_τ (b ⊕ δ)`.
Standing: PROVEN -/
theorem null_perturbation_preserves_equiv {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (δ : Perturbation Th)
    (hδ : δ ∈ NullPerturbation τ b) :
    transformEquiv τ b δ.perturbed := by
  simp [NullPerturbation, Set.mem_setOf_eq] at hδ
  simp [transformEquiv]
  exact hδ.2.symm

/-- [Notation Authority §108] Null perturbations land in the same fiber.
If `δ ∈ Null_τ(b)` then `b ⊕ δ ∈ F_{τ(b)}`.
Standing: PROVEN -/
theorem null_perturbation_stays_in_fiber {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (δ : Perturbation Th)
    (hδ : δ ∈ NullPerturbation τ b) :
    δ.perturbed ∈ fiber τ (τ.map b) := by
  simp [fiber, Set.mem_setOf_eq]
  simp [NullPerturbation, Set.mem_setOf_eq] at hδ
  exact hδ.2

/-! ## Dimension Loss Decomposition

The total dimension loss decomposes by perturbation kind:

  `Δd_τ(b) = Δd_τ^temp(b) + Δd_τ^fluent(b) + Δd_τ^num(b) + Δd_τ^traj(b)`

where `Δd_τ^k(b) = dim(Null_τ^k(b))` is the dimension of the null
component along coordinate family `k`.  This decomposition tells us
*how much* of each type of freedom the transformation destroys. -/

/-- [Notation Authority §109] The dimension of the null perturbation space of a given kind.

  `Δd_τ^k(b) = dim(Null_τ^k(b))`

This counts the independent `k`-type perturbations invisible to τ at `b`. -/
noncomputable def nullDimensionOfKind {Th : PlanningTheory} {α : Type}
    (_τ : WorkflowTransformation Th α)
    (_b : BehavioralPhaseSpace Th)
    (_k : PerturbationKind) : ℕ :=
  -- Placeholder: in a concrete instantiation, this would compute the
  -- dimension of the null perturbation subspace along kind k.
  0

/-- [Notation Authority §110] A record collecting the per-kind dimension loss decomposition.

  `Δd_τ(b) = temporal + fluent + numeric + trajectory`

Each component is `dim(Null_τ^k(b))` for the corresponding perturbation
kind `k`. -/
structure DimensionLossDecomposition where
  /-- Temporal degrees of freedom lost (timestamp shifts invisible to τ). -/
  temporal : ℕ
  /-- Object-fluent degrees of freedom lost (fluent changes invisible to τ). -/
  fluent : ℕ
  /-- Numeric degrees of freedom lost (numeric state changes invisible to τ). -/
  numeric : ℕ
  /-- Trajectory degrees of freedom lost (trajectory witness changes invisible to τ). -/
  trajectory : ℕ
  deriving Repr

/-- [Notation Authority §111] The total dimension loss from the decomposition. -/
def DimensionLossDecomposition.total (d : DimensionLossDecomposition) : ℕ :=
  d.temporal + d.fluent + d.numeric + d.trajectory

/-- [Notation Authority §112] Compute the dimension loss decomposition at a behavior `b`.

Returns a `DimensionLossDecomposition` recording how many independent
degrees of freedom of each perturbation kind are lost. -/
noncomputable def dimensionLossDecomposition {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th) : DimensionLossDecomposition :=
  { temporal   := nullDimensionOfKind τ b .temporal
    fluent     := nullDimensionOfKind τ b .fluent
    numeric    := nullDimensionOfKind τ b .numeric
    trajectory := nullDimensionOfKind τ b .trajectory }

/-- **Conjecture:** The total decomposed dimension loss equals
the transformation dimension loss.

  `Δd_τ^temp(b) + Δd_τ^fluent(b) + Δd_τ^num(b) + Δd_τ^traj(b) = Δd_τ(b)`

This requires the null perturbation space to decompose as a direct sum
along coordinate families (no cross-term interactions).

Note that under the current stub model (`nullDimensionOfKind ≡ 0`) the
left-hand side is identically 0, so this proposition is generally false
until real per-kind null dimensions land.  This is a `def : Prop` — a
statement shape, not an asserted or proven result.

Standing: CONJECTURAL — requires a direct sum decomposition of tangent
spaces, which is not yet formalized. -/
def DimensionLossDecomposes {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th) : Prop :=
    ((dimensionLossDecomposition τ b).total : ℤ) =
      transformationDimensionLoss τ S b

/-! ## Dimension Loss Profile

For analysis across the workflow space, we define the dimension loss
*profile*: a function assigning the dimension loss to each workflow class,
computed as the maximum (or generic) dimension loss across the fiber. -/

/-- [Notation Authority §113] The dimension loss profile across the workflow space.

  `ΔD_τ(w) = sup_{b ∈ F_w} Δd_τ(b)`

This gives a global view of how much dimensional freedom each workflow
class absorbs from the PDDL 3.1 behavioral phase space. -/
noncomputable def dimensionLossProfile {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (w : WorkflowSpace α) : ℤ :=
  -- In a concrete finite instantiation, take the maximum over behaviors
  -- in the fiber.  Here we use fiberDimension as a proxy.
  (fiberDimension τ S w : ℤ)

/-- The dimension loss profile is non-negative everywhere.

This holds trivially: `dimensionLossProfile` is currently defined as the
ℕ-valued `fiberDimension` cast to ℤ, so non-negativity is a property of
the cast, not a geometric comparison of dimensions.  The intended
supremum-of-losses reading of the profile remains informal.

Standing: PROVEN — trivially, as a ℕ-to-ℤ cast bound under the current
proxy definition of the profile; revisit when the profile becomes a real
supremum over the fiber. -/
theorem dimension_loss_profile_nonneg {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (w : WorkflowSpace α) :
    0 ≤ dimensionLossProfile τ S w := by
  simp [dimensionLossProfile]

/-! ## Dimension Loss and Information Measures

Connection to the measure-theoretic framework of Layer 4.  The dimension
loss at a fiber governs the *scaling behavior* of the pushforward measure:

If the source measure ν is d-dimensional (e.g. Lebesgue on a d-dimensional
stratum) and the fiber has dimension `k = Δd_τ`, then the pushforward
measure at scale ε satisfies:

  `μ(B_ε(w)) ~ ε^{d-k} · Vol_k(F_w ∩ B_ε)`

The dimension loss `k` directly controls how the measure concentrates. -/

/-- [Notation Authority §114] The effective scaling exponent at a workflow class.

  `α(w) = d_loc^PDDL(b) - Δd_τ(b) = d_loc^POWL(w)`

This is the dimension of the *image* at `w` — the number of independent
directions that survived the transformation.  It governs the local
scaling of the pushforward measure. -/
noncomputable def effectiveScalingDimension {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th) : ℕ :=
  pddlLocalDim S b - (fiberDimension τ S (τ.map b))

/-- The effective scaling dimension is bounded by the source dimension.

This holds by ℕ truncated subtraction (`a - b ≤ a`); it does not depend
on any geometric relationship between fiber and source dimensions.

Standing: PROVEN — by truncated-subtraction arithmetic; the bound is
definitional, not geometric. -/
theorem effective_scaling_le_source_dim {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Th)
    (b : BehavioralPhaseSpace Th) :
    effectiveScalingDimension τ S b ≤ pddlLocalDim S b := by
  simp [effectiveScalingDimension]

end ProcInt.MFW
