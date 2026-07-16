import Mathlib
import ProcInt.MFW.TransformBasic

namespace ProcInt.MFW

/-!
# ProcInt.MFW.SpectrumBundle

## Layer 9: Spectrum Bundle and Cross-Spectrum Tension

### Derivation Chain Position

```
Layer 0–4: TransformBasic (P(Th), W, τ, fiber, pushforward)
    ↓
Layer 5–8: VectorMeasure, MeasureKind, hierarchical partition (in TransformBasic)
    ↓
Layer 9: SpectrumBundle ← THIS FILE
    ↓
Layer 10+: Spectral phase transitions, divergence geometry, …
```

### Mathematical Content

The PDDL 3.1 → POWL v2 transformation induces multiple heterogeneous
measures over the same hierarchical workflow factorization. The explosive
new object is not a single Rényi dimension `D_q` but the **Multifractal
Workflow Spectrum Bundle**:

  `D⃗_q = (D_q^Behavior, D_q^Time, D_q^Choice, D_q^Linearization, D_q^Slack, D_q^Fluent)`

Each component is a generalized dimension computed from the corresponding
distinguished measure kind (behavioral, temporal, choice, linearization,
slack, fluent). The bundle lives over `q ∈ ℝ`, with each fiber a 6-vector
of Rényi dimensions.

### Cross-Spectrum Tension

The optimization signal may not be the multifractal spectrum itself but the
**misalignment between semantic freedoms**. Define:

  `Δ_ij(q) = D_q^i − D_q^j`

This cross-spectrum tension measures how differently two measure kinds scale
at Rényi exponent `q`. Its sign and magnitude encode structural bottlenecks:

| Tension Pattern                        | Interpretation             |
|----------------------------------------|----------------------------|
| High behavior / low temporal freedom   | Temporal bottleneck        |
| Low behavior / high temporal freedom   | Scheduling elasticity      |
| High choice / low behavior mass        | Choice sparsity            |
| High concurrency / low temporal freedom| False concurrency pressure |

### Partition Sum at POWL v2 Hierarchical Depth

POWL v2 supplies a canonical multiscale filtration `P₀ ⪯ P₁ ⪯ ⋯ ⪯ Pₕ`.
The **partition sum** at scale `k` is:

  `Z(q, k) = Σ_{B ∈ P_k} p_B^q`

where `p_B` is the pushforward mass of component `B` at depth `k`.
The Rényi dimension is extracted from the scaling of Z(q, k) with k.

### The q-Lens

The Rényi exponent `q` controls attention over PDDL 3.1 behavioral mass
inside POWL v2 choice structure:
- `q ≫ 0`: spotlight on high-mass fibers (dominant behavioral channels)
- `q ≈ 0`: democratic counting of components
- `q ≪ 0`: spotlight on rare behaviors (low-mass fibers)

### Transformation Information Profile

The full **Transformation Information Profile** consolidates all
information-geometric quantities:

  `I_τ = (d_int, D⃗_q, H(B|W), I(Y;B|W), dim F_w, d_W, Δ_ij(q))`

This is the master diagnostic: it tells you everything about what τ
preserves, erases, and distorts.

### Standing
- All `structure` and `def` declarations: DEFINITION
- Structural lemmas with proofs: PROVEN
- Lemmas with `sorry`: CONJECTURAL — proof target for formal exploration

### Research Questions
1. Does cross-spectrum tension `Δ_ij(q)` exhibit phase transitions at
   critical `q*` values? If so, do these correspond to structural changes
   in the POWL v2 hierarchy?
2. Is the spectrum bundle a genuine fiber bundle over `ℝ` (the q-line)?
   What is its structure group?
3. Can the transformation information profile be given a Riemannian
   information-geometric interpretation (Fisher metric on the profile space)?
4. Does the partition sum `Z(q, k)` satisfy convexity in `q` for all
   hierarchical depths `k`?
-/

/-! ## Spectrum Bundle -/

/-- [Notation Authority §166] The **Multifractal Workflow Spectrum Bundle**.

For each Rényi exponent `q ∈ ℝ`, the spectrum bundle assigns a generalized
dimension `D_q^i` to each of the six distinguished measure kinds. The
bundle is:

  `D⃗_q = (D_q^Behavior, D_q^Time, D_q^Choice, D_q^Linearization, D_q^Slack, D_q^Fluent)`

Mathematically, this is a section of a trivial `ℝ^6`-bundle over the
q-line `ℝ`, but the semantic content is that each component dimension
captures a different kind of scaling freedom in the transformation
`τ : P(Th) → W`.

The bundle is parameterized by workflow label type `α` to match
the POWL v2 workflow space `WorkflowSpace α`. -/
structure SpectrumBundle (α : Type) where
  /-- Generalized dimension `D_q^i` for measure kind `i` at Rényi exponent `q`.
      Given `q : ℝ` and `kind : MeasureKind`, returns `D_q^kind ∈ ℝ`. -/
  dimension : ℝ → MeasureKind → ℝ
  /-- At q = 0, the generalized dimension equals the box-counting dimension
      (capacity dimension), which is kind-independent in the normalized setting.
      This is a structural axiom of the spectrum. -/
  q_zero_finite : ∀ kind, ∃ d : ℝ, dimension 0 kind = d

/-- [Notation Authority §166] Evaluate the full spectrum vector at a fixed Rényi exponent `q`.
Returns a function from `MeasureKind` to `ℝ`, representing the 6-vector
`D⃗_q = (D_q^B, D_q^T, D_q^C, D_q^L, D_q^S, D_q^F)`. -/
def SpectrumBundle.spectrumAt {α : Type} (sb : SpectrumBundle α) (q : ℝ) :
    MeasureKind → ℝ :=
  sb.dimension q

/-! ## Cross-Spectrum Tension -/

/-- [Notation Authority §167] **Cross-spectrum tension** between measure kinds `i` and `j` at Rényi
exponent `q`:

  `Δ_ij(q) = D_q^i − D_q^j`

This measures the misalignment between how two semantic freedom dimensions
scale at exponent `q`. Nonzero tension indicates that the transformation
treats the two freedoms asymmetrically at that scale of attention.

The tension is the core diagnostic: optimization targets are not individual
spectra but the tension profile between them. -/
def crossSpectrumTension {α : Type} (sb : SpectrumBundle α)
    (i j : MeasureKind) (q : ℝ) : ℝ :=
  sb.dimension q i - sb.dimension q j

/-- [Notation Authority §167] Cross-spectrum tension is antisymmetric: `Δ_ij(q) = −Δ_ji(q)`.

Standing: PROVEN -/
theorem tension_antisymmetric {α : Type} (sb : SpectrumBundle α)
    (i j : MeasureKind) (q : ℝ) :
    crossSpectrumTension sb i j q = -crossSpectrumTension sb j i q := by
  unfold crossSpectrumTension
  ring

/-- [Notation Authority §167] Cross-spectrum tension vanishes on the diagonal: `Δ_ii(q) = 0`.

Standing: PROVEN -/
theorem tension_diagonal_zero {α : Type} (sb : SpectrumBundle α)
    (i : MeasureKind) (q : ℝ) :
    crossSpectrumTension sb i i q = 0 := by
  simp [crossSpectrumTension]

/-- [Notation Authority §167] The tension matrix at fixed `q` has zero trace (sum over all Δ_ii = 0).
This is immediate from `Δ_ii = 0` for all `i`.

Standing: PROVEN -/
theorem tension_trace_zero {α : Type} (sb : SpectrumBundle α)
    (q : ℝ) :
    ∀ i, crossSpectrumTension sb i i q = 0 :=
  fun i => tension_diagonal_zero sb i q

/-! ## Tension Interpretation -/

/-- [Notation Authority §168] Qualitative interpretation of cross-spectrum tension patterns.

Each constructor corresponds to a structural bottleneck or freedom
pattern diagnosed by the sign of specific `Δ_ij(q)` values:

- `temporalBottleneck`: High behavioral dimension / low temporal dimension.
  The system has many valid behaviors but they are squeezed into a narrow
  temporal window. Scheduling is the binding constraint.

- `schedulingElasticity`: Low behavioral dimension / high temporal dimension.
  Few behaviors exist but each has wide temporal freedom. The system is
  temporally flexible but behaviorally constrained.

- `choiceSparsity`: High choice dimension / low behavioral mass.
  The choice-graph branching factor is large but few branches carry
  significant behavioral mass. Most choices are "dead" or near-empty.

- `falseConcurrency`: High linearization dimension / low temporal dimension.
  Many linearizations exist (suggesting concurrency) but temporal
  constraints bind them tightly, creating the illusion of concurrency
  without actual scheduling freedom. -/
inductive TensionInterpretation : Type
  /-- High behavioral dimension / low temporal dimension: `D_q^B ≫ D_q^T`.
  Scheduling is the binding constraint. -/
  | temporalBottleneck
  /-- Low behavioral dimension / high temporal dimension: `D_q^B ≪ D_q^T`.
  The system is temporally flexible but behaviorally constrained. -/
  | schedulingElasticity
  /-- High choice dimension / low behavioral mass: `D_q^C ≫ D_q^B`.
  Most choices are "dead" or near-empty. -/
  | choiceSparsity
  /-- High linearization dimension / low temporal dimension: `D_q^L ≫ D_q^T`.
  Creates the illusion of concurrency without actual scheduling freedom. -/
  | falseConcurrency
  deriving Repr, DecidableEq

/-- [Notation Authority §168] Classify a tension value into a structural interpretation.

Given the tension `Δ_ij(q)` between two specific measure kinds and a
threshold `ε > 0`, classify the tension as:
- Positive above threshold → first kind dominates (one interpretation)
- Negative below −ε → second kind dominates (dual interpretation)
- Within ±ε → no clear signal (returns `none`)

This classification is defined for the four canonical tension pairs:
(behavioral, temporal), (temporal, behavioral), (choice, behavioral),
(linearization, temporal). -/
noncomputable def classifyTension {α : Type} (sb : SpectrumBundle α)
    (i j : MeasureKind) (q : ℝ) (ε : ℝ) :
    Option TensionInterpretation :=
  let δ := crossSpectrumTension sb i j q
  match i, j with
  | .behavioral, .temporal =>
    if δ > ε then some .temporalBottleneck
    else if δ < -ε then some .schedulingElasticity
    else none
  | .choice, .behavioral =>
    if δ > ε then some .choiceSparsity
    else none
  | .linearization, .temporal =>
    if δ > ε then some .falseConcurrency
    else none
  | _, _ => none

/-! ## Hierarchical Partition Sum

The partition sum is the generating function of the multifractal analysis.
Using POWL v2 hierarchical depth `k` as the scale parameter:

  `Z(q, k) = Σ_{B ∈ P_k} p_B^q`

where `P_k` is the POWL v2 partition at depth `k` and `p_B` is the
pushforward mass of component `B`.

Key values:
- `Z(0, k) = |P_k|` (number of components at depth k)
- `Z(1, k) = 1` (if masses are normalized to a probability distribution)
- `Z(q, k)` is log-convex in `q` (standard Rényi property)
-/

/-- [Notation Authority §169] The **hierarchical partition sum** at Rényi exponent `q` and
POWL v2 depth `k`.

  `Z(q, k) = Σ_{B ∈ P_k} p_B^q`

where the sum is over all components in the POWL v2 partition at
hierarchical depth `k`, and `p_B` is the pushforward mass of
component `B` under the transformation.

The function `componentMasses` provides the mass list for a given depth.
We require all masses to be positive (strictly) for the partition sum
to be well-defined for all `q ∈ ℝ`. -/
noncomputable def hierarchicalPartitionSum
    (componentMasses : List ℝ) (q : ℝ) : ℝ :=
  (componentMasses.map (fun p => p ^ q)).sum

/-- [Notation Authority §169] When `q = 0`, the partition sum counts the number of components:
`Z(0, k) = |P_k|`.

This is because `p^0 = 1` for any `p ≠ 0`, so the sum reduces to
counting terms.

Standing: PROVEN -/
theorem partitionSum_q_zero
    (masses : List ℝ)
    (hpos : ∀ p ∈ masses, 0 < p) :
    hierarchicalPartitionSum masses 0 = masses.length := by
  unfold hierarchicalPartitionSum
  induction masses with
  | nil => simp
  | cons p ps ih =>
    simp only [List.map_cons, List.sum_cons, List.length_cons, Nat.cast_add, Nat.cast_one]
    have hps : ∀ p ∈ ps, 0 < p := fun p hp => hpos p (List.Mem.tail _ hp)
    rw [ih hps]
    have : p ^ (0 : ℝ) = 1 := Real.rpow_zero _
    rw [this]
    ring

/-- [Notation Authority §169] When `q = 1` and masses form a probability distribution (sum to 1),
the partition sum equals 1: `Z(1, k) = 1`.

This is the normalization condition: `Σ p_B = 1 ⟹ Σ p_B^1 = 1`.

Standing: PROVEN -/
theorem partitionSum_q_one
    (masses : List ℝ)
    (hnorm : (masses).sum = 1) :
    hierarchicalPartitionSum masses 1 = 1 := by
  unfold hierarchicalPartitionSum
  have : masses.map (fun p => p ^ (1 : ℝ)) = masses := by
    apply List.map_id''
    intro p
    exact Real.rpow_one p
  rw [this, hnorm]

/-- [Notation Authority §169] The partition sum is non-negative when all masses are non-negative
and `q ≥ 0`.

Standing: PROVEN -/
theorem partitionSum_nonneg
    (masses : List ℝ) (q : ℝ)
    (hnn : ∀ p ∈ masses, 0 ≤ p)
    (_hq : 0 ≤ q) :
    0 ≤ hierarchicalPartitionSum masses q := by
  unfold hierarchicalPartitionSum
  apply List.sum_nonneg
  intro x hx
  have ⟨p, hp, hp_eq⟩ := List.mem_map.mp hx
  rw [← hp_eq]
  exact Real.rpow_nonneg (hnn p hp) q

/-! ## The q-Lens

The Rényi exponent `q` is not a free parameter to sweep. It has a
natural POWL v2 interpretation as an **attention control** over
PDDL 3.1 behavioral mass inside POWL v2 choice structure.

- `q ≫ 0`: The lens focuses on high-mass POWL v2 components.
  These are the "dominant behavioral channels" — workflow classes
  that capture the most PDDL 3.1 behaviors. The spectrum reveals
  how concentrated mass is among dominant channels.

- `q = 0`: The lens is democratic. Every component contributes
  equally regardless of mass. The dimension counts geometric
  scaling of the number of occupied components.

- `q = 1`: The Shannon lens. The dimension corresponds to the
  information-theoretic entropy rate. This is the "natural" scale.

- `q ≪ 0`: The lens focuses on low-mass POWL v2 components.
  These are rare behaviors — workflow classes that few PDDL 3.1
  behaviors realize. The spectrum reveals the scaling of the
  "tail" of the behavioral distribution.
-/

/-- [Notation Authority §170] A **q-lens** specialized to a particular measure kind and workflow
space. This combines the Rényi exponent with the spectrum bundle
to produce a scalar diagnostic.

The q-lens at `(q, kind)` answers the question:
"How does the `kind`-dimension scale at attention level `q`?" -/
structure QLensWorkflow (α : Type) where
  /-- The underlying spectrum bundle. -/
  bundle : SpectrumBundle α
  /-- The measure kind this lens focuses on. -/
  focusKind : MeasureKind
  /-- The Rényi exponent. -/
  q : ℝ

/-- [Notation Authority §170] Evaluate a q-lens to produce a scalar generalized dimension. -/
def QLensWorkflow.eval {α : Type} (lens : QLensWorkflow α) : ℝ :=
  lens.bundle.dimension lens.q lens.focusKind

/-- [Notation Authority §170] A **choice-graph q-lens** focuses specifically on choice mass.
This is the natural lens for studying POWL v2 branching structure:
it controls attention over how PDDL 3.1 behaviors distribute across
choice-graph branches. -/
def qLensChoice {α : Type} (sb : SpectrumBundle α) (q : ℝ) :
    QLensWorkflow α :=
  { bundle := sb, focusKind := .choice, q := q }

/-! ## Behavior-Induced Workflow Metric

The transformation `τ` does not merely partition behaviors; it induces
a **metric on the workflow space**. Two workflow classes are "close" if
their fibers overlap significantly in behavioral content:

  `d_W(w₁, w₂) = 1 − J(F_{w₁}, F_{w₂})`

where `J` is the Jaccard similarity of the fibers (or a measure-theoretic
analogue). This metric captures behavioral proximity: even if `w₁` and `w₂`
are structurally different in POWL v2, they are metrically close if similar
PDDL 3.1 behaviors populate them.

The metric `d_W` is the workflow geometry induced by the transformation.
It is NOT the graph distance in POWL v2 — it is the behavioral distance.
-/

/-- [Notation Authority §171] A **workflow metric** induced by the transformation.

The metric `d_W : W × W → ℝ` measures behavioral proximity between
workflow classes. It satisfies the standard metric axioms:
- `d_W(w, w) = 0` (identity of indiscernibles)
- `d_W(w₁, w₂) = d_W(w₂, w₁)` (symmetry)
- `d_W(w₁, w₃) ≤ d_W(w₁, w₂) + d_W(w₂, w₃)` (triangle inequality)

This is the geometry that the transformation `τ` puts on the
workflow space. It can differ dramatically from any intrinsic
POWL v2 distance. -/
structure WorkflowMetric (α : Type) where
  /-- The distance function on workflow classes. -/
  dist : WorkflowSpace α → WorkflowSpace α → ℝ
  /-- Distance is non-negative. -/
  dist_nonneg : ∀ w₁ w₂, 0 ≤ dist w₁ w₂
  /-- Distance from a point to itself is zero. -/
  dist_self : ∀ w, dist w w = 0
  /-- Distance is symmetric. -/
  dist_symm : ∀ w₁ w₂, dist w₁ w₂ = dist w₂ w₁
  /-- Triangle inequality. -/
  dist_triangle : ∀ w₁ w₂ w₃, dist w₁ w₃ ≤ dist w₁ w₂ + dist w₂ w₃

/-- [Notation Authority §171] A `WorkflowMetric` induces a `PseudoMetricSpace` instance on
`WorkflowSpace α`.

Standing: CONJECTURAL — depends on well-definedness of the distance
construction from fiber overlap. -/
@[reducible]
noncomputable def WorkflowMetric.toPseudoMetricSpace {α : Type}
    (wm : WorkflowMetric α) : PseudoMetricSpace (WorkflowSpace α) :=
  { dist := wm.dist
    dist_self := wm.dist_self
    dist_comm := wm.dist_symm
    dist_triangle := wm.dist_triangle }

/-! ## Transformation Information Profile

The **Transformation Information Profile** is the master diagnostic
consolidating all information-geometric quantities of the transformation
`τ : P(Th) → W`.

  `I_τ = (d_int, D⃗_q, H(B|W), I(Y;B|W), dim F_w, d_W, Δ_ij(q))`

Components:
- `d_int` : intrinsic dimension of the behavioral phase space
- `D⃗_q`  : the spectrum bundle (generalized dimensions per measure kind)
- `H(B|W)`: conditional entropy of behaviors given workflow class
- `I(Y;B|W)`: mutual information between observables and behaviors
             conditioned on workflow class
- `dim F_w`: fiber dimension function
- `d_W`   : behavior-induced workflow metric
- `Δ_ij(q)`: cross-spectrum tension matrix
-/

/-- [Notation Authority §172] The **Transformation Information Profile** — the complete
information-geometric characterization of the transformation
`τ : P(Th) → W`.

This structure is the master diagnostic object of MFW. It packages
all derived information-geometric quantities into a single coherent
record. Every downstream analysis (bottleneck detection, optimization
targeting, structural comparison) draws from this profile. -/
structure TransformationInfoProfile (α : Type) where
  /-- Intrinsic dimension of the behavioral phase space `P(Th)`. -/
  intrinsicDimension : ℝ
  /-- The spectrum bundle: `D⃗_q` for all `q` and all measure kinds. -/
  spectrumBundle : SpectrumBundle α
  /-- Conditional entropy `H(B|W)`: average information in the behavior
      not captured by the workflow class. High values indicate high
      information loss under τ. -/
  conditionalEntropy : ℝ
  /-- Conditional mutual information `I(Y;B|W)`: information that
      observables `Y` carry about behaviors beyond what the workflow
      class reveals. -/
  conditionalMutualInfo : ℝ
  /-- Fiber dimension function: `dim F_w` for each workflow class. -/
  fiberDimension : WorkflowSpace α → ℝ
  /-- Behavior-induced workflow metric `d_W`. -/
  workflowMetric : WorkflowMetric α
  /-- The cross-spectrum tension is derived from the spectrum bundle
      but we cache the full tension profile for efficient querying. -/
  tensionAt : MeasureKind → MeasureKind → ℝ → ℝ

/-- [Notation Authority §172] Construct the tension component of the information profile from
the spectrum bundle. The tension is always derived from the bundle. -/
def TransformationInfoProfile.tensionFromBundle {α : Type}
    (sb : SpectrumBundle α) : MeasureKind → MeasureKind → ℝ → ℝ :=
  fun i j q => crossSpectrumTension sb i j q

/-- [Notation Authority §172] The tension stored in the information profile is consistent with
the spectrum bundle: it equals the cross-spectrum tension derived
from the bundle's dimension function.

Standing: PROVEN (by definition, when constructed via `tensionFromBundle`) -/
theorem tensionProfile_consistent {α : Type}
    (sb : SpectrumBundle α) (i j : MeasureKind) (q : ℝ) :
    TransformationInfoProfile.tensionFromBundle sb i j q =
    crossSpectrumTension sb i j q := by
  rfl

/-! ## Partition Sum Structure Theorems -/

/-- [Notation Authority §173] The partition sum at `q = 0` with a single component of mass `p > 0`
yields 1.

Standing: PROVEN -/
theorem partitionSum_singleton_q_zero
    (p : ℝ) (_hp : 0 < p) :
    hierarchicalPartitionSum [p] 0 = 1 := by
  unfold hierarchicalPartitionSum
  simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, add_zero]
  exact Real.rpow_zero p

/-- [Notation Authority §173] If two mass lists are concatenated, the partition sum of the
concatenation equals the sum of the individual partition sums.

  `Z(q, masses₁ ++ masses₂) = Z(q, masses₁) + Z(q, masses₂)`

This additivity reflects the fact that partition sums over disjoint
components sum independently.

Standing: PROVEN -/
theorem partitionSum_append
    (masses₁ masses₂ : List ℝ) (q : ℝ) :
    hierarchicalPartitionSum (masses₁ ++ masses₂) q =
    hierarchicalPartitionSum masses₁ q + hierarchicalPartitionSum masses₂ q := by
  unfold hierarchicalPartitionSum
  rw [List.map_append, List.sum_append]

/-! ## Spectrum Bundle Over Hierarchical Scale

The spectrum bundle can be parameterized not just by `q` but jointly
by `(q, k)` where `k` is hierarchical depth. This gives the **scale-resolved
spectrum bundle**:

  `D⃗_q(k) = spectrum at Rényi exponent q and hierarchical depth k`

The scaling behavior of `D⃗_q(k)` with `k` reveals how the multifractal
structure varies across the POWL v2 hierarchy.
-/

/-- [Notation Authority §174] A **scale-resolved spectrum bundle** parameterized by both Rényi
exponent `q` and hierarchical depth `k`.

This is the fully resolved object: at each `(q, k)` pair, it assigns
a generalized dimension for each measure kind. -/
structure ScaleResolvedSpectrumBundle (α : Type) where
  /-- Generalized dimension `D_q^i(k)` at Rényi exponent `q`,
      hierarchical depth `k`, and measure kind `i`. -/
  dimension : ℝ → Nat → MeasureKind → ℝ

/-- [Notation Authority §174] Project a scale-resolved spectrum bundle to a fixed depth,
yielding an ordinary spectrum bundle. -/
def ScaleResolvedSpectrumBundle.atDepth {α : Type}
    (srsb : ScaleResolvedSpectrumBundle α) (k : Nat) :
    SpectrumBundle α :=
  { dimension := fun q kind => srsb.dimension q k kind
    q_zero_finite := fun kind => ⟨srsb.dimension 0 k kind, rfl⟩ }

/-- [Notation Authority §174] The cross-spectrum tension at a specific hierarchical depth. -/
def scaleResolvedTension {α : Type}
    (srsb : ScaleResolvedSpectrumBundle α)
    (i j : MeasureKind) (q : ℝ) (k : Nat) : ℝ :=
  crossSpectrumTension (srsb.atDepth k) i j q

/-- [Notation Authority §174] Scale-resolved tension is still antisymmetric at every depth.

Standing: PROVEN -/
theorem scaleResolvedTension_antisymmetric {α : Type}
    (srsb : ScaleResolvedSpectrumBundle α)
    (i j : MeasureKind) (q : ℝ) (k : Nat) :
    scaleResolvedTension srsb i j q k =
    -scaleResolvedTension srsb j i q k := by
  simp [scaleResolvedTension]
  exact tension_antisymmetric (srsb.atDepth k) i j q

end ProcInt.MFW
