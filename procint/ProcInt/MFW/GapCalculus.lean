import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Order.Interval.Finset.Nat
import Mathlib.Computability.Halting
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# Gap Calculus — kernel-checked anchors for the scaling and bound vocabulary

This module pins the conversation-derived gap-calculus vocabulary so that each term has a
kernel-checked denotation. Its contents are held at three distinct standings:

* PROVEN items are finite or algebraic anchors: the discrete sample-path occupancy
  identity (Little's law in its distribution-free finite form), the restart-vs-receipt
  cost-ratio identity, and a direct corollary of Mathlib's `ComputablePred.rice`.
* The plain definitions (`uslThroughput`, `uslPeak`, `pkWaitingTime`, `coherenceHorizon`,
  `throughputCeiling`) are formulas only. Their queueing (M/G/1 FCFS) and scalability
  (USL) interpretations are modeling assumptions and carry no applicability claim.
* CONJECTURAL items are statement shapes (`def ... : Prop`) with named blockers; none is
  asserted as a result.
-/

namespace ProcInt.MFW

/-! ## Discrete sample-path Little's law -/

/-- Discrete occupancy `N_t`: the number of jobs `i` present in the system at time `t`,
i.e. with `a i ≤ t < d i`, for arrival times `a : Fin n → ℕ` and departure times
`d : Fin n → ℕ`. -/
def occupancy (n : ℕ) (a d : Fin n → ℕ) (t : ℕ) : ℕ :=
  (Finset.univ.filter fun i => a i ≤ t ∧ t < d i).card

/-- Discrete sample-path Little's law, exact form: total observed occupancy over the
horizon `[0, T)` equals the total sojourn time `∑ i, (d i - a i)` when every departure
happens by `T`. Distribution-free: no stochastic assumptions enter; the identity is a
finite double count of (job, time-slot) incidences. Since `ℕ` subtraction truncates, the
hypothesis `a i ≤ d i` is not needed for the identity itself; under the intended model
(`a i ≤ d i`) the summand `d i - a i` is exactly job `i`'s sojourn time.
Standing: PROVEN — finite sample-path identity, distribution-free. -/
theorem occupancy_sum_eq_sojourn_sum (n T : ℕ) (a d : Fin n → ℕ) (hdT : ∀ i, d i ≤ T) :
    ∑ t ∈ Finset.range T, occupancy n a d t = ∑ i, (d i - a i) := by
  unfold occupancy
  simp only [Finset.card_filter]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [← Finset.card_filter]
  have hIco : (Finset.range T).filter (fun t => a i ≤ t ∧ t < d i)
      = Finset.Ico (a i) (d i) := by
    ext t
    simp only [Finset.mem_filter, Finset.mem_range, Finset.mem_Ico]
    exact ⟨fun h => h.2, fun h => ⟨lt_of_lt_of_le h.2 (hdT i), h⟩⟩
  rw [hIco, Nat.card_Ico]

/-- Averaged corollary of `occupancy_sum_eq_sojourn_sum` over `ℝ`: time-average occupancy
equals arrival rate times mean sojourn time, `L = λ·W`, in the finite exact form
`(∑ N_t)/T = (n/T) · ((∑ (d i - a i))/n)`. The hypothesis `a i ≤ d i` lets the sojourn
sum be written with real subtraction.
Standing: PROVEN — cast and rearrangement of the exact identity; still distribution-free. -/
theorem little_average (n T : ℕ) (a d : Fin n → ℕ)
    (ha : ∀ i, a i ≤ d i) (hdT : ∀ i, d i ≤ T) (hT : T ≠ 0) (hn : n ≠ 0) :
    (∑ t ∈ Finset.range T, (occupancy n a d t : ℝ)) / T
      = ((n : ℝ) / T) * ((∑ i, ((d i : ℝ) - (a i : ℝ))) / n) := by
  have hsum : (∑ t ∈ Finset.range T, (occupancy n a d t : ℝ))
      = ∑ i, ((d i : ℝ) - (a i : ℝ)) := by
    rw [← Nat.cast_sum, occupancy_sum_eq_sojourn_sum n T a d hdT, Nat.cast_sum]
    exact Finset.sum_congr rfl fun i _ => Nat.cast_sub (ha i)
  have hT' : (T : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hT
  have hn' : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn
  rw [hsum]
  field_simp

/-! ## Restart-vs-receipt cost separation -/

/-- Gall/receipts cost-ratio identity: `(n / p^n) / (n / p) = 1 / p^(n-1)` for `p ≠ 0`,
`n ≥ 1`. Reading: with per-step success probability `p`, `n / p^n` models the expected
cost of restart-whole construction (all `n` steps must succeed jointly) and `n / p` the
expected cost of incremental construction with receipted checkpoints (each step retried
independently); their ratio is the exponential-vs-linear separation `p^{-(n-1)}`.
Standing: PROVEN — algebraic identity over ℝ; the queueing/reliability interpretation of
each side is a modeling assumption, not part of the proved content. -/
theorem gall_cost_ratio (p : ℝ) (hp : p ≠ 0) (n : ℕ) (hn : 1 ≤ n) :
    ((n : ℝ) / p ^ n) / ((n : ℝ) / p) = 1 / p ^ (n - 1) := by
  have hn0 : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.one_le_iff_ne_zero.mp hn)
  have hsplit : p ^ n = p ^ (n - 1) * p := by
    conv_lhs => rw [← Nat.sub_add_cancel hn]
    rw [pow_succ]
  have hpn : p ^ (n - 1) ≠ 0 := pow_ne_zero _ hp
  rw [hsplit]
  field_simp

/-! ## Rice mechanism-1 anchor -/

/-- Rice mechanism-1 anchor for the admission doctrine: no nontrivial extensional
property of partial recursive code is computably decidable at the code level. If some
partial recursive `f` inhabits the semantic class `C` and some partial recursive `g`
avoids it, then no admission gate deciding `eval c ∈ C` from the code `c` is a
computable predicate. Direct application of Mathlib's `ComputablePred.rice`
(`Mathlib.Computability.Halting`, pinned rev `fabf563a7c95`).
Standing: PROVEN — one-line corollary of `ComputablePred.rice`. -/
theorem rice_admission_anchor (C : Set (ℕ →. ℕ)) {f g : ℕ →. ℕ}
    (hf : Nat.Partrec f) (hg : Nat.Partrec g) (hfC : f ∈ C) (hgC : g ∉ C) :
    ¬ ComputablePred fun c => Nat.Partrec.Code.eval c ∈ C :=
  fun h => hgC (ComputablePred.rice C h hf hg hfC)

/-! ## Formula vocabulary (definitions only, no applicability claims) -/

/-- USL throughput `X(N) = λ·N / (1 + σ·(N-1) + κ·N·(N-1))`. Modeling scope: Gunther's
Universal Scalability Law with contention coefficient `σ` and coherence coefficient `κ`;
a formula only, with no claim that any given system obeys it. -/
noncomputable def uslThroughput (lam sigma kappa N : ℝ) : ℝ :=
  lam * N / (1 + sigma * (N - 1) + kappa * N * (N - 1))

/-- USL peak concurrency `N* = √((1-σ)/κ)`: the concurrency level at which USL
throughput is claimed to peak. Modeling scope: USL; the peak property itself is stated
separately (see `uslRetrogradeConjectural`) and is not proved here. -/
noncomputable def uslPeak (sigma kappa : ℝ) : ℝ :=
  Real.sqrt ((1 - sigma) / kappa)

/-- Pollaczek–Khinchine mean waiting time `W_q = λ·E[S²] / (2·(1-ρ))`. Modeling scope:
stationary M/G/1 FCFS queue with arrival rate `λ`, service-time second moment `E[S²]`,
and utilization `ρ < 1`; a formula only, with no claim of applicability. -/
noncomputable def pkWaitingTime (lam ES2 rho : ℝ) : ℝ :=
  lam * ES2 / (2 * (1 - rho))

/-- Coherence horizon `L_max / λ_F`: maximum sustainable in-flight coherent state divided
by the fault/invalidation rate. A formula naming a modeling quantity only. -/
noncomputable def coherenceHorizon (Lmax lamF : ℝ) : ℝ :=
  Lmax / lamF

/-- Throughput ceiling `L_max / W_min`: Little-style upper bound on sustainable
throughput from bounded in-flight work `L_max` and minimum per-item latency `W_min`.
A formula naming a modeling quantity only. -/
noncomputable def throughputCeiling (Lmax Wmin : ℝ) : ℝ :=
  Lmax / Wmin

/-! ## Conjectural statement shapes -/

/-- **Conjecture (USL retrograde scaling).**
Standing: CONJECTURAL — proving the peak requires positivity management of the rational
denominator on `(0, ∞)` plus an AM–GM argument over `Real.sqrt`; not attempted here.
Shape: for `0 < λ`, `0 ≤ σ < 1`, `0 < κ`, and a denominator that stays positive on
`(0, ∞)`, USL throughput is maximized at `uslPeak σ κ`; beyond the peak, adding
concurrency reduces throughput (retrograde scaling). -/
def uslRetrogradeConjectural (lam sigma kappa : ℝ) : Prop :=
  0 < lam → 0 ≤ sigma → sigma < 1 → 0 < kappa →
    (∀ N : ℝ, 0 < N → 0 < 1 + sigma * (N - 1) + kappa * N * (N - 1)) →
    ∀ N : ℝ, 0 < N →
      uslThroughput lam sigma kappa N ≤ uslThroughput lam sigma kappa (uslPeak sigma kappa)

/-- **Conjecture (heavy-tail waiting-time divergence).**
Standing: CONJECTURAL — no M/G/1 queue formalization exists in the pinned Mathlib, so
`isMG1FCFS`, `finiteServiceSecondMoment`, and `finiteMeanWait` are uninterpreted
predicates here; the statement is a shape over an abstract queue type, not a result.
Shape: in an M/G/1 FCFS queue whose service-time distribution has infinite second
moment, the stationary mean waiting time is infinite (the Pollaczek–Khinchine numerator
diverges). -/
def heavyTailDivergenceConjectural (Queue : Type) (isMG1FCFS : Queue → Prop)
    (finiteServiceSecondMoment : Queue → Prop) (finiteMeanWait : Queue → Prop) : Prop :=
  ∀ q : Queue, isMG1FCFS q → ¬ finiteServiceSecondMoment q → ¬ finiteMeanWait q

/-- **Conjecture (surface-verifier diagonal).**
Standing: CONJECTURAL — requires a formal model of a "surface-computable verifier class"
(verdicts computed from bounded surface features of the artifact) before this is more
than a statement shape; `passes`, `correct`, and `isSurface` are uninterpreted here.
Shape: for every verifier in the surface class there exists an artifact that passes the
verifier but is not correct — the Goodhart/LLM-Rice mechanism-2 diagonal. -/
def surfaceVerifierDiagonalConjectural (Artifact Verifier : Type)
    (passes : Verifier → Artifact → Prop) (correct : Artifact → Prop)
    (isSurface : Verifier → Prop) : Prop :=
  ∀ V : Verifier, isSurface V → ∃ x : Artifact, passes V x ∧ ¬ correct x

end ProcInt.MFW
