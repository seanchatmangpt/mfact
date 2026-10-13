-- Hand-authored lane (strata-valve window-capacity law, CHATMAN_K = 8).
-- Pattern follows ProcInt/Petri/PN64Conservation.lean: hand-authored, core-Lean
-- (no Mathlib import), admitted by `lake build ProcInt.Petri.ValveWindow`.
-- Model of packs/strata-valve-pack/generated/window_capacity.rs (READ-ONLY).
-- Ground truth: knhk guards `run.len > 8` (knhk_hooks.erl) and `tau > 8`
-- (knhk_epoch.erl), atoms verbatim.

/-! # ProcInt.StrataValve

The strata-valve window-capacity law: a window of capacity `CHATMAN_K = 8`
— sealed at the literal 8, NOT generalized to arbitrary K (the knhk guard
atoms `run.len > 8` / `tau > 8` are pinned at 8; a `∀ K` theorem would not
witness that the projected table enforces 8 exactly — see the Rust closure's
`wrong_capacity` fail-closed branch). `CHATMAN_K_val : CHATMAN_K = 8` is
proved by `rfl` so downstream KATs re-derive the literal.

Results:

1. No over-admission (a): at capacity the admit is refused `none`, and every
   state reachable from `empty` by successful admits has count `≤ CHATMAN_K`.
2. Admit-then-release cycle invariant (b): the cycle restores the exact prior
   count and each leg preserves the capacity invariant.
3. Conservation (c): `closureCount t + countReleases t = countAdmits t` — the
   live count is exactly admits minus releases; the walk stays bounded by the
   constant (`closure_invariant`), so Nat truncation never bites in-range.
-/

namespace ProcInt.StrataValve

/-! ## The Chatman constant -/

/-- The shared window capacity (knhk: `Len ≤ 8`, `Tau ≤ 8`). Sealed literal,
NOT generalized — see module docstring. -/
def CHATMAN_K : Nat := 8

/-- Sealing fact: the constant is the literal 8 (proved by `rfl`). -/
theorem CHATMAN_K_val : CHATMAN_K = 8 := rfl

/-! ## Window states and transitions -/

/-- A window state is its live count. -/
abbrev Window := Nat

/-- The empty window. -/
def empty : Window := 0

/-- The invariant: a window holds at most `CHATMAN_K` live elements. -/
def AtCapacity (w : Window) : Prop := w ≤ CHATMAN_K

/-- Definitional unfolding of the invariant (core-Lean, no Mathlib). -/
theorem atCapacity_iff (w : Nat) : AtCapacity w ↔ w ≤ CHATMAN_K := Iff.rfl

/-- Admit transition (result-typed): succeeds only below capacity. At
capacity the admit is *refused* (`none`) — the Lean-side twin of the Rust
`WindowCapacityRefusal` guard. -/
def admit (w : Window) : Option Window :=
  if w < CHATMAN_K then some (w + 1) else none

/-- Refusal predicate: admit fails exactly at capacity. -/
def Refused (w : Window) : Prop := admit w = none

/-- Release transition: removing one element from a nonempty window.
Releasing an empty window is refused too (nothing to release). -/
def release (w : Window) : Option Window :=
  if 0 < w then some (w - 1) else none

/-! ## (a) No over-admission -/

/-- Reachability: `w` is reachable in `n` steps from `empty` by successful
admits. -/
def reach : Nat → Window → Prop
  | 0, w => w = empty
  | n + 1, w => ∃ w', reach n w' ∧ admit w' = some w

/-- Refusal happens exactly at capacity: typed form of the `run.len > 8` /
`tau > 8` guard atoms — capacity-8 admits refuse. -/
theorem refused_iff_at_capacity (w : Nat) : Refused w ↔ ¬ (w < CHATMAN_K) := by
  unfold Refused admit
  by_cases h : w < CHATMAN_K
  · simp [h]
  · simp [h]

/-- Direct refusal witness: a full window refuses. -/
theorem full_window_refuses : admit CHATMAN_K = none := by
  unfold admit
  rw [CHATMAN_K_val]
  simp only [if_neg (by omega : ¬ (8 : Nat) < 8)]

/-- Successful admits land exactly one above. -/
theorem admit_success_iff (w : Nat) :
    admit w = some (w + 1) ↔ w < CHATMAN_K := by
  unfold admit
  by_cases h : w < CHATMAN_K
  · simp [h]
  · simp [h]

/-- An admit that succeeds lands exactly one above, below the constant. -/
theorem admit_some_inv (w o : Nat) (hstep : admit w = some o) :
    o = w + 1 ∧ w < CHATMAN_K := by
  unfold admit at hstep
  rw [CHATMAN_K_val] at hstep ⊢
  split at hstep
  · next hlt => simp at hstep; exact ⟨hstep.symm, hlt⟩
  · next => simp at hstep

/-- An admit that succeeds cannot produce an over-capacity window. -/
theorem admit_keeps_invariant (w o : Nat) (hstep : admit w = some o) :
    o ≤ CHATMAN_K := by
  have ⟨h1, h2⟩ := admit_some_inv w o hstep
  rw [CHATMAN_K_val] at h2 ⊢
  omega

/-- **Main theorem (a): no over-admission state is reachable.** Every window
reached from `empty` by any trace of successful admits satisfies the capacity
invariant. -/
theorem no_over_admission :
    ∀ (n : Nat) (w : Window), reach n w → AtCapacity w := by
  intro n
  induction n with
  | zero =>
    intro w h
    simp only [reach] at h
    subst h
    exact Nat.zero_le _
  | succ n ih =>
    intro w h
    simp only [reach] at h
    have ⟨w', hw', hstep⟩ := h
    exact admit_keeps_invariant w' w hstep

/-! ## (b) Admit-then-release cycle invariant -/

/-- The admit-then-release cycle is the identity on capacity: releasing an
element just admitted restores the exact prior window. -/
theorem release_admit_cycle (w : Nat) (hlt : w < CHATMAN_K) :
    release (w + 1) = some w := by
  unfold release
  simp

/-- Capacity is invariant across a full admit-then-release cycle: the window
after the cycle equals the window before it. -/
theorem cycle_capacity_invariant (w : Nat) (hlt : w < CHATMAN_K) :
    ∃ w1 w2 : Window, admit w = some w1 ∧ release w1 = some w2 ∧ w2 = w := by
  have hadm : admit w = some (w + 1) := by
    unfold admit
    rw [CHATMAN_K_val] at hlt ⊢
    exact if_pos hlt
  exact ⟨w + 1, w, hadm, release_admit_cycle w hlt, rfl⟩

/-- A release that succeeds removes exactly one: `o = w - 1` with `w` nonempty. -/
theorem release_some_inv (w o : Nat) (hcap : release w = some o) :
    o = w - 1 ∧ 0 < w := by
  unfold release at hcap
  split at hcap
  · next hpos => simp at hcap; exact ⟨hcap.symm, hpos⟩
  · next => simp at hcap

/-- The release leg preserves the invariant. -/
theorem release_keeps_invariant (w o : Nat) (h : w ≤ CHATMAN_K)
    (hcap : release w = some o) : o ≤ CHATMAN_K := by
  rw [CHATMAN_K_val] at h ⊢
  have ⟨h1, _⟩ := release_some_inv w o hcap
  omega

/-! ## (c) Conservation: closure count = admits - releases -/

/-- One valve event, mirroring the two transition directions. -/
inductive Ev where
  | admitE : Ev
  | releaseE : Ev

/-- One valve step, shared by the closure fold and the validity checker. -/
def stepFn (c : Nat) (ev : Ev) : Nat :=
  match ev with
  | .admitE => if c < CHATMAN_K then c + 1 else c
  | .releaseE => if 0 < c then c - 1 else c

/-- The closure function: fold a trace of valve steps over the empty window.
Refused steps are no-ops (admit at capacity, release at empty) — the
fold-based twin of the Rust `window_capacity_closure` walk, which instead
fails closed on any capacity drift. -/
def closureCount (t : List Ev) : Nat := t.foldl stepFn 0

theorem step_admit_lt (c : Nat) (h : c < CHATMAN_K) :
    stepFn c Ev.admitE = c + 1 := by unfold stepFn; simp [h]

theorem step_admit_ge (c : Nat) (h : ¬ (c < CHATMAN_K)) :
    stepFn c Ev.admitE = c := by unfold stepFn; simp [h]

theorem step_release_pos (c : Nat) (h : 0 < c) :
    stepFn c Ev.releaseE = c - 1 := by unfold stepFn; simp [h]

theorem step_release_zero (c : Nat) (h : ¬ (0 < c)) :
    stepFn c Ev.releaseE = c := by unfold stepFn; simp [h]

/-- Trace validity from count `c`: every step must succeed (no admit at
capacity, no release at empty). -/
def validFrom : Nat → List Ev → Bool
  | _, [] => true
  | c, .admitE :: t => decide (c < CHATMAN_K) && validFrom (c + 1) t
  | c, .releaseE :: t => decide (0 < c) && validFrom (c - 1) t

/-- Census: number of admit events in a trace. -/
def countAdmits : List Ev → Nat
  | [] => 0
  | Ev.admitE :: t => countAdmits t + 1
  | Ev.releaseE :: t => countAdmits t

/-- Census: number of release events in a trace. -/
def countReleases : List Ev → Nat
  | [] => 0
  | Ev.releaseE :: t => countReleases t + 1
  | Ev.admitE :: t => countReleases t

/-- **Main theorem (c): conservation.** Over a valid trace (every step
succeeds), the closure count equals admits minus releases: the live count is
exactly admits minus releases. Refused steps are valve no-ops and never
appear in a valid trace. -/
theorem closure_conservation (t : List Ev) (hv : validFrom 0 t = true) :
    closureCount t + countReleases t = countAdmits t := by
  have key : ∀ (t : List Ev) (c : Nat), validFrom c t = true →
      (t.foldl stepFn c) + countReleases t = countAdmits t + c := by
    intro t
    induction t with
    | nil => intro c _; simp [countAdmits, countReleases]
    | cons ev rest ih =>
      cases ev with
      | admitE =>
        intro c hv
        simp only [validFrom, Bool.and_eq_true] at hv
        obtain ⟨hlt, hrest⟩ := hv
        have hlt' : c < CHATMAN_K := of_decide_eq_true hlt
        have hstep : stepFn c Ev.admitE = c + 1 := by
          unfold stepFn; simp [hlt']
        simp only [List.foldl_cons, countAdmits, countReleases]
        rw [hstep]
        have hfin := ih _ hrest
        omega
      | releaseE =>
        intro c hv
        simp only [validFrom, Bool.and_eq_true] at hv
        obtain ⟨hpos, hrest⟩ := hv
        have hpos' : 0 < c := of_decide_eq_true hpos
        have hstep : stepFn c Ev.releaseE = c - 1 := by
          unfold stepFn; simp [hpos']
        simp only [List.foldl_cons, countAdmits, countReleases]
        rw [hstep]
        have hfin := ih _ hrest
        omega
  unfold closureCount
  exact key t 0 hv

/-- The invariant along the closure walk: the live count never exceeds the
Chatman constant, on any trace from any in-capacity window. -/
theorem closure_invariant (t : List Ev) :
    closureCount t ≤ CHATMAN_K := by
  have key : ∀ (t : List Ev) (c : Nat), c ≤ CHATMAN_K →
      (t.foldl stepFn c) ≤ CHATMAN_K := by
    intro t
    induction t with
    | nil => intro c hc; exact hc
    | cons ev rest ih =>
      cases ev with
      | admitE =>
        intro c hc
        simp only [List.foldl_cons]
        by_cases hlt : c < CHATMAN_K
        · rw [step_admit_lt c hlt]
          exact ih _ (by have := CHATMAN_K_val; omega)
        · rw [step_admit_ge c hlt]
          exact ih _ hc
      | releaseE =>
        intro c hc
        simp only [List.foldl_cons]
        by_cases hpos : 0 < c
        · rw [step_release_pos c hpos]
          exact ih _ (by have := CHATMAN_K_val; omega)
        · rw [step_release_zero c hpos]
          exact ih _ hc
  unfold closureCount
  exact key t 0 (Nat.zero_le _)

end ProcInt.StrataValve