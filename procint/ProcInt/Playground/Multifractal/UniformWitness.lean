-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Multifractal.GeneralizedDimension

/-!
# ProcInt.Playground.Multifractal.UniformWitness

The first genuine scaling-law theorem connecting the `Multifractal` definitional
scaffold (`ScalePartition`, `partitionFunction`, `massExponentSequence`,
`HasMassExponent`, `lowerGeneralizedDimension`) to an actually-computed limit,
on the cheapest nontrivial admitted object: Lebesgue measure on `ℝ`, partitioned
by the canonical dyadic intervals at the dyadic scale `Scale.dyadic`.

Lebesgue measure is monofractal (uniform), so every Rényi order `q` produces the
same generalized dimension `1`. This is deliberately the *unweighted* case: it
exercises the full partition-function-to-mass-exponent-to-dimension pipeline
end-to-end, but it is not yet a genuine multifractal (two-weight cascade)
witness.

## Deferred: the genuine multifractal (two-weight cascade) case

A real multifractal witness needs a self-similar measure built from at least two
distinct weights on the two halves of each dyadic cell (a binomial/Bernoulli
cascade), whose generalized-dimension spectrum `D_q` is non-constant in `q`.
That measure is **not constructed here**. It is refused, not silently deferred:
at this pin (Mathlib `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`), there is no
ready-made infinite-product / Bernoulli / cylinder measure on a boundary space
(`{0,1}^ℕ` or the dyadic-tree boundary) available off the shelf —
`MeasureTheory.Measure.pi` requires `Fintype` on the index type, and no
Ionescu–Tulcea cylinder-measure construction for a countably-infinite product is
present in the vendored checkout (verified by inspection of
`Mathlib/MeasureTheory/Constructions/Pi.lean` and the absence of any
Ionescu–Tulcea / Kolmogorov-extension file for infinite products at this pin).
Building that measure from scratch (a genuine Carathéodory extension on
cylinder sets) is real mathematical work beyond the scope of a single wave, and
is not attempted here as a shortcut or a stub.
-/

namespace ProcInt.Playground.Multifractal

open Filter MeasureTheory
open scoped Topology ENNReal Classical

noncomputable section

/-- The `k`-th dyadic cell of generation `n`: `[k/2ⁿ, (k+1)/2ⁿ)`. -/
private def dyadicCell (n k : ℕ) : Set ℝ :=
  Set.Ico ((k : ℝ) / 2 ^ n) (((k : ℝ) + 1) / 2 ^ n)

/-- Distinct generators `a ≠ b` produce distinct dyadic cells at the same
generation `n`: the left endpoint `a / 2ⁿ` lies in cell `a` (it is the closed
endpoint) but not in cell `b`, since the map `k ↦ k / 2ⁿ` is strictly monotone. -/
private theorem dyadicCell_ne_of_lt (n : ℕ) {a b : ℕ} (hab : a < b) :
    dyadicCell n a ≠ dyadicCell n b := by
  have h2n : (0 : ℝ) < (2 : ℝ) ^ n := by positivity
  have hmono : StrictMono (fun x : ℝ => x / (2 : ℝ) ^ n) := strictMono_div_right_of_pos h2n
  intro heq
  have hmemL : (a : ℝ) / 2 ^ n ∈ dyadicCell n a :=
    ⟨le_refl _, hmono (by linarith)⟩
  rw [heq] at hmemL
  have hba : (b : ℝ) ≤ (a : ℝ) := hmono.le_iff_le.mp hmemL.1
  have hab' : (a : ℝ) < (b : ℝ) := by exact_mod_cast hab
  linarith

/-- The generation-`n` dyadic-cell map `k ↦ [k/2ⁿ, (k+1)/2ⁿ)` is injective on
`Finset.range (2 ^ n)` (indeed on all of `ℕ`), by `dyadicCell_ne_of_lt`. -/
private theorem dyadicCell_injOn (n : ℕ) :
    Set.InjOn (dyadicCell n) (Finset.range (2 ^ n) : Set ℕ) := by
  intro a _ b _ heq
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hlt
  · exact dyadicCell_ne_of_lt n hlt heq
  · exact dyadicCell_ne_of_lt n hlt heq.symm

/-- The `2ⁿ` dyadic cells of generation `n`, covering `[0,1)`. -/
noncomputable def dyadicIntervals (n : ℕ) : Finset (Set ℝ) :=
  (Finset.range (2 ^ n)).image (dyadicCell n)

/-- The uniform dyadic `ScalePartition` of `ℝ`. -/
noncomputable def uniformDyadicPartition : ScalePartition ℝ :=
  ⟨dyadicIntervals⟩

/-- `dyadicIntervals n` has exactly `2ⁿ` cells: the generating map is injective
on `Finset.range (2 ^ n)`, so `Finset.image` does not collapse any cells. -/
theorem card_dyadicIntervals (n : ℕ) : (dyadicIntervals n).card = 2 ^ n := by
  unfold dyadicIntervals
  rw [Finset.card_image_of_injOn (dyadicCell_injOn n)]
  exact Finset.card_range _

/-- Every generation-`n` dyadic cell has Lebesgue length exactly `2⁻ⁿ`, hence
`q`-mass `(2⁻ⁿ)^q` for every `k`, regardless of which cell it is. -/
private theorem massPower_dyadicCell (n : ℕ) (q : ℝ) (k : ℕ) :
    massPower (volume : Measure ℝ) q (dyadicCell n k) = (1 / (2 : ℝ) ^ n) ^ q := by
  have honediff : ((k : ℝ) + 1) - (k : ℝ) = 1 := by ring
  have hlen : (((k : ℝ) + 1) / 2 ^ n) - (k : ℝ) / 2 ^ n = 1 / (2 : ℝ) ^ n := by
    rw [div_sub_div_same, honediff]
  unfold massPower cellMass dyadicCell
  rw [Real.volume_Ico, hlen, ENNReal.toReal_ofReal (by positivity)]
  rfl

/-- The exact (not merely asymptotic) partition function of the uniform dyadic
partition of Lebesgue measure: `Z(q,n) = 2ⁿ · (2⁻ⁿ)^q`, for every `n` (including
the degenerate `n = 0`, where both sides equal `1`). -/
theorem partitionFunction_uniformDyadic (n : ℕ) (q : ℝ) :
    partitionFunction (volume : Measure ℝ) uniformDyadicPartition q n
      = (2 : ℝ) ^ n * (1 / (2 : ℝ) ^ n) ^ q := by
  unfold partitionFunction uniformDyadicPartition dyadicIntervals
  rw [Finset.sum_image (dyadicCell_injOn n),
    Finset.sum_congr rfl (fun k _ => massPower_dyadicCell n q k),
    Finset.sum_const, Finset.card_range, nsmul_eq_mul]
  push_cast
  ring

/-- For every generation `n ≥ 1`, the mass-exponent sequence of the uniform
dyadic partition equals `q - 1` **exactly** (not merely in the limit): the
partition function collapses to `2ⁿ · (2⁻ⁿ)^q`, and
`log(2ⁿ·(2⁻ⁿ)^q) / log(2⁻ⁿ) = n·log 2·(1-q) / (-(n·log 2)) = q - 1`
whenever `n ≠ 0`. Generation `n = 0` is genuinely degenerate (`Z(q,0) = 1`,
`radius 0 = 1`, so the sequence value there is the junk value `0`, not `q - 1`)
and is excluded, matching `MassExponentAdmissible`'s own `radius n ≠ 1`
requirement. -/
theorem massExponentSequence_uniformDyadic_eq {n : ℕ} (hn : 1 ≤ n) (q : ℝ) :
    massExponentSequence (volume : Measure ℝ) uniformDyadicPartition Scale.dyadic q n
      = q - 1 := by
  have h2n : (0 : ℝ) < (2 : ℝ) ^ n := by positivity
  have hbase : (0 : ℝ) < 1 / (2 : ℝ) ^ n := by positivity
  have hlog2 : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hn' : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hnum : Real.log (partitionFunction (volume : Measure ℝ) uniformDyadicPartition q n)
      = (n : ℝ) * Real.log 2 * (1 - q) := by
    rw [partitionFunction_uniformDyadic n q,
      Real.log_mul (ne_of_gt h2n) (ne_of_gt (Real.rpow_pos_of_pos hbase q)),
      Real.log_pow, Real.log_rpow hbase,
      show (1 : ℝ) / (2 : ℝ) ^ n = ((2 : ℝ) ^ n)⁻¹ from one_div _,
      Real.log_inv, Real.log_pow]
    ring
  have hden : Real.log (Scale.dyadic.radius n) = -((n : ℝ) * Real.log 2) := by
    show Real.log ((1 / 2 : ℝ) ^ n) = -((n : ℝ) * Real.log 2)
    rw [Real.log_pow, show (1 : ℝ) / 2 = (2 : ℝ)⁻¹ from one_div _, Real.log_inv]
    ring
  have hne : ((n : ℝ) * Real.log 2) ≠ 0 := mul_ne_zero hn' (ne_of_gt hlog2)
  unfold massExponentSequence
  rw [hnum, hden]
  field_simp
  ring

/-- The uniform dyadic partition of Lebesgue measure has mass exponent
`τ(q) = q - 1` at every Rényi order `q`: monofractal (uniform) scaling. The
sequence is eventually (from `n = 1` on) exactly constant at `q - 1`, so the
limit is immediate from `tendsto_const_nhds` via `Filter.Tendsto.congr'`. -/
theorem hasMassExponent_uniform (q : ℝ) :
    HasMassExponent (volume : Measure ℝ) uniformDyadicPartition Scale.dyadic q (q - 1) := by
  have heq : (fun _ : ℕ => q - 1)
      =ᶠ[atTop] massExponentSequence (volume : Measure ℝ) uniformDyadicPartition Scale.dyadic q := by
    filter_upwards [Filter.eventually_ge_atTop 1] with n hn
    exact (massExponentSequence_uniformDyadic_eq hn q).symm
  exact Filter.Tendsto.congr' heq tendsto_const_nhds

/-- The lower generalized dimension of Lebesgue measure under the uniform
dyadic partition is `1` at every admissible Rényi order `q ≠ 1`: the classical
fact that Lebesgue measure on `ℝ` is monofractal, exhibited as an actual
computed limit rather than asserted. -/
theorem lowerGeneralizedDimension_uniform {q : ℝ} (hq : q ≠ 1) :
    lowerGeneralizedDimension (volume : Measure ℝ) uniformDyadicPartition Scale.dyadic q = 1 := by
  unfold lowerGeneralizedDimension lowerMassExponent
  rw [(hasMassExponent_uniform q).liminf_eq]
  exact div_self (sub_ne_zero.mpr hq)

/-- The upper generalized dimension coincides with the lower one here, since
the mass-exponent sequence genuinely converges (not just has equal liminf and
limsup by coincidence). -/
theorem upperGeneralizedDimension_uniform {q : ℝ} (hq : q ≠ 1) :
    upperGeneralizedDimension (volume : Measure ℝ) uniformDyadicPartition Scale.dyadic q = 1 := by
  unfold upperGeneralizedDimension upperMassExponent
  rw [(hasMassExponent_uniform q).limsup_eq]
  exact div_self (sub_ne_zero.mpr hq)

end

end ProcInt.Playground.Multifractal
