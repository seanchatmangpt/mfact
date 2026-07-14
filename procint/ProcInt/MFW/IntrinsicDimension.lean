import Mathlib
import ProcInt.MFW.TransformBasic

namespace ProcInt.MFW

/-!
# ProcInt.MFW.IntrinsicDimension

## Layer 7 — Intrinsic Dimension Loss

### Derivation Chain Position

```
Layer 0  P(Π) behavioral phase space          [TransformBasic]
Layer 1  W workflow space                      [TransformBasic]
Layer 2  τ : P(Π) → W                         [TransformBasic]
Layer 3  Fiber F_w = τ⁻¹(w)                   [TransformBasic]
Layer 4  Pushforward μ = τ_*ν                  [TransformBasic]
Layer 5  (reserved: spectral)
Layer 6  (reserved: multifractal)
Layer 7  Intrinsic dimension loss Δd_τ         [this file]
```

### Mathematical Content

The PDDL 3.1 behavioral phase space `P(Π)` has coordinates drawn from five
independent families:

  `x = (event occurrence, temporal, object-fluent, numeric, trajectory)`

Admissibility imposes equality constraints `C(x) = 0` (causal structure,
state-variable consistency) and inequality constraints `G(x) ≤ 0` (temporal
bounds, resource limits). The lawful space is generically *stratified*:
different discrete choice patterns produce pieces of different local
dimension.

  `P(Π) = ⋃_{σ ∈ Σ} P_σ`

where `Σ` indexes choice strata (action selection patterns, branch choices)
and each stratum `P_σ` is the subset of `P(Π)` with that discrete pattern.
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
4. Does the stratification of `P(Π)` induce a natural Whitney stratification?

### Standing

- All `structure` and `def` declarations: DEFINITION
- Structural lemmas with proofs: PROVEN
- Lemmas with `sorry`: CONJECTURAL — proof target for formal exploration
-/

/-! ## Phase-Space Coordinate Kinds

The five coordinate families of `P(Π)`.  These correspond to independent
parameter families that together parameterize the behavioral phase space.
A point `x ∈ P(Π)` has projections onto each coordinate kind. -/

/-- The five independent coordinate families of the behavioral phase space.

Every point `x ∈ P(Π)` has components in each family:
- `eventOccurrence`: which events occur and in what order (discrete)
- `temporal`: timestamp assignments (continuous, modulo constraint surfaces)
- `objectFluent`: object-valued fluent configurations
- `numeric`: numeric fluent values (continuous)
- `trajectory`: trajectory constraint witness structure -/
inductive PhaseCoordinateKind : Type
  | eventOccurrence  -- which events occur / ordering
  | temporal         -- timestamp assignments
  | objectFluent     -- object-valued fluent configurations
  | numeric          -- numeric fluent values
  | trajectory       -- trajectory constraint witnesses
  deriving Repr, DecidableEq

/-! ## Stratification

The behavioral phase space is not a smooth manifold — it is *stratified*.
Different action selection patterns yield subsets of different local
dimension.  The stratification is indexed by a discrete choice label `σ`
that captures which branch of every decision point was taken. -/

/-- A choice stratum label.

`σ ∈ Σ` encodes a complete discrete choice pattern: which actions were
selected, which branches of `(or ...)` goals were pursued, which XOR-choice
submodels were entered.  Two behaviors in the same stratum differ only in
their continuous parameters (temporal placement, numeric values). -/
structure StratumLabel where
  /-- An opaque identifier for the discrete choice pattern. -/
  id : Nat
  deriving Repr, DecidableEq

/-- A stratum of the behavioral phase space.

`P_σ` is the subset of `P(Π)` whose behaviors share the discrete choice
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

/-- The full stratified decomposition of the behavioral phase space.

  `P(Π) = ⋃_{σ ∈ Σ} P_σ`

Different strata may overlap only on their boundaries (lower-dimensional
pieces where constraint surfaces intersect). -/
structure StratifiedPhaseSpace (Th : PlanningTheory) where
  /-- The collection of strata. -/
  strata : List (Stratum Π)
  /-- Every lawful behavior belongs to at least one stratum. -/
  covering : ∀ b : BehavioralPhaseSpace Th, ∃ s ∈ strata, s.mem b

/-! ## Local Intrinsic Dimension

The local intrinsic dimension at a point `x ∈ P(Π)` is the dimension of
the constraint surface near `x`.  On a smooth stratum interior this is the
number of independent continuous parameters.  At stratum boundaries the
dimension drops.

Analogously, the POWL v2 workflow space `W` has a local dimension at each
point `w`.  The **dimension loss** is the difference. -/

/-- Local intrinsic dimension at a point of a space.

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
  /-- The dimension is well-defined (the point lies in the interior of
      some regular stratum). -/
  wellDefined : Prop
  deriving Repr

/-- Compute the local dimension of a behavior in the PDDL 3.1 phase space.
This requires identifying which stratum `b` belongs to and returning
that stratum's local dimension.

Given a stratified phase space decomposition and a behavior `b`, the
PDDL-side local dimension is the maximum dimension among all strata
containing `b` (taking the generic/interior value). -/
noncomputable def pddlLocalDim {Th : PlanningTheory}
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) : ℕ :=
  -- Take the supremum of stratum dimensions containing b.
  -- In the generic case (interior of one stratum) this is unique.
  let containing := S.strata.filter (fun s => decide (s.mem b) = true)
  containing.foldl (fun acc s => max acc s.localDim) 0

/-- The local dimension on the POWL v2 workflow side.

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

/-- The transformation dimension loss at a behavior `b`.

  `Δd_τ(b) = d_loc^PDDL(b) - d_loc^POWL(τ(b))`

Returns the signed difference as an integer to handle the (degenerate)
case where the POWL side has higher local dimension than expected.
Under normal conditions `Δd_τ ≥ 0`. -/
noncomputable def transformationDimensionLoss {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) : ℤ :=
  (pddlLocalDim S b : ℤ) - (powlLocalDim (τ.map b) : ℤ)

/-- **Theorem (CONJECTURAL):** Dimension loss is non-negative.

If τ is Lipschitz on each stratum (hence cannot increase local dimension),
then `Δd_τ(b) ≥ 0` for all behaviors `b`.

Geometric intuition: a Lipschitz map cannot increase the Hausdorff dimension
of a set.  Since POWL v2 workflow classes are images of strata under τ,
the image dimension is at most the source dimension.

Standing: CONJECTURAL — requires Lipschitz regularity hypothesis on τ. -/
theorem dimension_loss_nonneg {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) :
    0 ≤ transformationDimensionLoss τ S b := by
  -- Requires: τ is Lipschitz on each stratum of S.
  -- Then d_loc^POWL(τ(b)) ≤ d_loc^PDDL(b) by Lipschitz dimension bound.
  sorry

/-- **Theorem (CONJECTURAL):** Zero dimension loss characterizes local invertibility.

  `Δd_τ(b) = 0 ↔ τ is locally invertible at b`

When no dimension is lost, the transformation preserves all continuous
degrees of freedom, hence admits a local inverse (up to discrete
stratum labelling).

Forward direction: Δd = 0 implies the differential/tangent map of τ
is an isomorphism, hence τ is a local diffeomorphism by inverse function
theorem.

Reverse direction: if τ is a local diffeomorphism, it preserves local
dimension.

Standing: CONJECTURAL — requires smooth structure on P(Π) and W. -/
theorem dimension_loss_zero_iff_local_diffeo {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) :
    transformationDimensionLoss τ S b = 0 ↔
      True /- placeholder for: τ is a local diffeomorphism at b -/ := by
  -- Forward: Δd = 0 ⟹ dim source = dim target ⟹ tangent map is iso
  -- Reverse: local diffeo preserves dimension
  sorry

/-! ## Fiber Dimension

The dimension of the fiber `F_w = τ⁻¹(w)` is a measure of the
geometric complexity of the set of behaviors collapsed to `w`.

When τ is a submersion on a stratum, the fiber theorem gives:
  `dim(F_w) = dim(P_σ) - dim(W_local) = Δd_τ`

In general (stratified, non-smooth) the fiber may itself be stratified
and we define its dimension as the maximum stratum dimension restricted
to the fiber. -/

/-- The dimension of a fiber `F_w`, defined as the maximum local dimension
among all strata restricted to the fiber.

  `dim(F_w) = max_{σ : P_σ ∩ F_w ≠ ∅} dim_σ(F_w)`

This is the number of independent continuous degrees of freedom within
the set of behaviors that τ identifies with workflow class `w`. -/
noncomputable def fiberDimension {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (w : WorkflowSpace α) : ℕ :=
  -- For each stratum, if it intersects the fiber, contribute its localDim.
  -- The fiber dimension is the maximum such value.
  -- In the submersion case: fiberDimension = pddlLocalDim - powlLocalDim.
  let fiberStrata := S.strata.filter
    (fun s => decide (∃ b, s.mem b ∧ τ.map b = w) = true)
  fiberStrata.foldl (fun acc s => max acc s.localDim) 0

/-- **Theorem (CONJECTURAL):** When τ is a submersion on a stratum,
fiber dimension equals transformation dimension loss.

  `dim(F_{τ(b)}) = Δd_τ(b)`

This is a consequence of the fiber theorem (preimage theorem) in
differential geometry: if τ is a submersion at `b`, then `F_{τ(b)}`
is a smooth submanifold of dimension `dim(P_σ) - dim(W)`.

Standing: CONJECTURAL — requires submersion hypothesis and smooth structure. -/
theorem fiber_dim_eq_dimension_loss {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) :
    (fiberDimension τ S (τ.map b) : ℤ) = transformationDimensionLoss τ S b := by
  -- Requires submersion hypothesis on τ at b.
  sorry

/-! ## Perturbation Kinds

We classify perturbations of a behavior by which coordinate family they
affect.  This classification is fundamental because different perturbation
kinds reveal different modes of transformation insensitivity:

- A temporally invisible perturbation means the workflow doesn't see
  timestamp shifts → temporal slack is lost information.
- A numerically invisible perturbation means the workflow doesn't see
  numeric state changes → numeric precision is lost information.
-/

/-- A classification of perturbation kinds by which coordinate family
of `P(Π)` they affect.

A perturbation `δ` displaces a behavior `b` to `b ⊕ δ` along one or
more coordinate families.  We classify by the *primary* coordinate
family affected. -/
inductive PerturbationKind : Type
  | temporal     -- shift event timestamps within feasible slack
  | fluent       -- alter object-fluent valuations
  | numeric      -- change numeric fluent values
  | trajectory   -- modify trajectory-constraint witness structure
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

/-- A perturbation of a behavior: a displacement in the behavioral phase space.

Mathematically `δ` is a tangent vector at `b ∈ P(Π)`, or more precisely
an element of the perturbation space at `b` (which is a subset of the
tangent cone when the space is stratified).

The perturbation carries:
- The perturbed behavior `b ⊕ δ`
- The kind of coordinate family primarily affected
- Lawfulness: the perturbed behavior is still in `P(Π)` -/
structure Perturbation (Th : PlanningTheory) where
  /-- The original behavior. -/
  base : BehavioralPhaseSpace Th
  /-- The perturbed behavior `b ⊕ δ`. -/
  perturbed : BehavioralPhaseSpace Th
  /-- Which coordinate family this perturbation primarily affects. -/
  kind : PerturbationKind
  /-- The perturbed behavior is lawful (remains in P(Π)). -/
  lawful : Prop

/-- The null perturbation space at a behavior `b` under transformation `τ`.

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
    (b : BehavioralPhaseSpace Th) : Set (Perturbation Π) :=
  {δ | δ.base = b ∧ δ.lawful ∧ τ.map δ.perturbed = τ.map b}

/-- The null perturbation space restricted to a specific perturbation kind.

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
    (k : PerturbationKind) : Set (Perturbation Π) :=
  {δ ∈ NullPerturbation τ b | δ.kind = k}

/-- Classify which perturbation kinds have non-trivial null components
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

/-- The trivial (zero) perturbation is always in the null space.
Standing: PROVEN. -/
theorem trivial_perturbation_in_null {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (k : PerturbationKind)
    (h_lawful : Prop)
    (δ₀ : Perturbation Π)
    (h_base : δ₀.base = b)
    (h_pert : δ₀.perturbed = b)
    (h_kind : δ₀.kind = k)
    (h_law : δ₀.lawful = h_lawful)
    (h_lawful_true : h_lawful) :
    δ₀ ∈ NullPerturbation τ b := by
  simp [NullPerturbation, Set.mem_setOf_eq]
  exact ⟨h_base, h_law ▸ h_lawful_true, by rw [h_pert, h_base]⟩

/-- The null perturbation of kind `k` is a subset of the full null space.
Standing: PROVEN. -/
theorem null_kind_subset_null {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (k : PerturbationKind) :
    NullPerturbationOfKind τ b k ⊆ NullPerturbation τ b := by
  intro δ hδ
  exact hδ.1

/-- Null perturbations preserve the transformation equivalence class.
If `δ ∈ Null_τ(b)` then `b ~_τ (b ⊕ δ)`.
Standing: PROVEN. -/
theorem null_perturbation_preserves_equiv {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (δ : Perturbation Π)
    (hδ : δ ∈ NullPerturbation τ b) :
    transformEquiv τ b δ.perturbed := by
  simp [NullPerturbation, Set.mem_setOf_eq] at hδ
  simp [transformEquiv]
  exact hδ.2.2.symm

/-- Null perturbations land in the same fiber.
If `δ ∈ Null_τ(b)` then `b ⊕ δ ∈ F_{τ(b)}`.
Standing: PROVEN. -/
theorem null_perturbation_stays_in_fiber {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th)
    (δ : Perturbation Π)
    (hδ : δ ∈ NullPerturbation τ b) :
    δ.perturbed ∈ fiber τ (τ.map b) := by
  simp [fiber, Set.mem_setOf_eq]
  simp [NullPerturbation, Set.mem_setOf_eq] at hδ
  exact hδ.2.2

/-! ## Dimension Loss Decomposition

The total dimension loss decomposes by perturbation kind:

  `Δd_τ(b) = Δd_τ^temp(b) + Δd_τ^fluent(b) + Δd_τ^num(b) + Δd_τ^traj(b)`

where `Δd_τ^k(b) = dim(Null_τ^k(b))` is the dimension of the null
component along coordinate family `k`.  This decomposition tells us
*how much* of each type of freedom the transformation destroys. -/

/-- The dimension of the null perturbation space of a given kind.

  `Δd_τ^k(b) = dim(Null_τ^k(b))`

This counts the independent `k`-type perturbations invisible to τ at `b`. -/
noncomputable def nullDimensionOfKind {Th : PlanningTheory} {α : Type}
    (_τ : WorkflowTransformation Th α)
    (_b : BehavioralPhaseSpace Th)
    (_k : PerturbationKind) : ℕ :=
  -- Placeholder: in a concrete instantiation, this would compute the
  -- dimension of the null perturbation subspace along kind k.
  0

/-- A record collecting the per-kind dimension loss decomposition.

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

/-- The total dimension loss from the decomposition. -/
def DimensionLossDecomposition.total (d : DimensionLossDecomposition) : ℕ :=
  d.temporal + d.fluent + d.numeric + d.trajectory

/-- Compute the dimension loss decomposition at a behavior `b`.

Returns a `DimensionLossDecomposition` recording how many independent
degrees of freedom of each perturbation kind are lost. -/
noncomputable def dimensionLossDecomposition {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (b : BehavioralPhaseSpace Th) : DimensionLossDecomposition :=
  { temporal   := nullDimensionOfKind τ b .temporal
    fluent     := nullDimensionOfKind τ b .fluent
    numeric    := nullDimensionOfKind τ b .numeric
    trajectory := nullDimensionOfKind τ b .trajectory }

/-- **Theorem (CONJECTURAL):** The total decomposed dimension loss equals
the transformation dimension loss.

  `Δd_τ^temp(b) + Δd_τ^fluent(b) + Δd_τ^num(b) + Δd_τ^traj(b) = Δd_τ(b)`

This requires the null perturbation space to decompose as a direct sum
along coordinate families (no cross-term interactions).

Standing: CONJECTURAL — requires direct sum decomposition of tangent spaces. -/
theorem dimension_loss_decomposes {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) :
    ((dimensionLossDecomposition τ b).total : ℤ) =
      transformationDimensionLoss τ S b := by
  sorry

/-! ## Dimension Loss Profile

For analysis across the workflow space, we define the dimension loss
*profile*: a function assigning the dimension loss to each workflow class,
computed as the maximum (or generic) dimension loss across the fiber. -/

/-- The dimension loss profile across the workflow space.

  `ΔD_τ(w) = sup_{b ∈ F_w} Δd_τ(b)`

This gives a global view of how much dimensional freedom each workflow
class absorbs from the PDDL 3.1 behavioral phase space. -/
noncomputable def dimensionLossProfile {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (w : WorkflowSpace α) : ℤ :=
  -- In a concrete finite instantiation, take the maximum over behaviors
  -- in the fiber.  Here we use fiberDimension as a proxy.
  (fiberDimension τ S w : ℤ)

/-- **Theorem (CONJECTURAL):** The dimension loss profile is non-negative
everywhere.

Standing: CONJECTURAL — follows from dimension_loss_nonneg via the
definition of the profile as a supremum of non-negative quantities. -/
theorem dimension_loss_profile_nonneg {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (w : WorkflowSpace α) :
    0 ≤ dimensionLossProfile τ S w := by
  simp [dimensionLossProfile]
  exact Int.ofNat_nonneg _

/-! ## Dimension Loss and Information Measures

Connection to the measure-theoretic framework of Layer 4.  The dimension
loss at a fiber governs the *scaling behavior* of the pushforward measure:

If the source measure ν is d-dimensional (e.g. Lebesgue on a d-dimensional
stratum) and the fiber has dimension `k = Δd_τ`, then the pushforward
measure at scale ε satisfies:

  `μ(B_ε(w)) ~ ε^{d-k} · Vol_k(F_w ∩ B_ε)`

The dimension loss `k` directly controls how the measure concentrates. -/

/-- The effective scaling exponent at a workflow class.

  `α(w) = d_loc^PDDL(b) - Δd_τ(b) = d_loc^POWL(w)`

This is the dimension of the *image* at `w` — the number of independent
directions that survived the transformation.  It governs the local
scaling of the pushforward measure. -/
noncomputable def effectiveScalingDimension {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) : ℕ :=
  pddlLocalDim S b - (fiberDimension τ S (τ.map b))

/-- **Theorem (PROVEN):** The dimension loss profile is non-negative
(alternative proof via Nat cast).

Standing: PROVEN. -/
theorem effective_scaling_le_source_dim {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (S : StratifiedPhaseSpace Π)
    (b : BehavioralPhaseSpace Th) :
    effectiveScalingDimension τ S b ≤ pddlLocalDim S b := by
  simp [effectiveScalingDimension]
  exact Nat.sub_le _ _

end ProcInt.MFW
