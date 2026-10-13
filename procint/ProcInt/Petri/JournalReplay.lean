-- Hand-authored construction lane (L34 candidate 2, L83).
-- Pattern follows ProcInt/Petri/PN64Conservation.lean and LedgerConservation.lean
-- (core-Lean-only, def+induction+omega; "ggen renders; Lean admits"). This module
-- admits strata-store-pack's journal replay/recovery law at the Lean level.
--
-- The real law: packs/strata-store-pack/templates/store_engine.rs.tera,
-- `complete_pending_undo` (countdown recovery: `while self.journal.len() >
-- rec.target_len { pop }`) and the L47 rollback/undo interleave guard
-- (`rollback_to` REFUSES with `UndoInterruptedPending` while a recovery entry is
-- outstanding; the sabotaged twin is the unguarded body kept for the runtime
-- corpus).
--
-- ## Model
--
-- `Journal := List Key` (`Key := Nat`), head = newest entry; undo pops the head.
--   `undo_step j`     — one pop (total: popping the empty journal is a no-op).
--   `undo_all j target` — pop until `length ≤ target` (the Rust while-loop).
--   `crash_at k j target` — the first `k` pops of an undo *in progress*, each
--     pop target-guarded exactly as the runtime's recovery loop is (a pop that
--     would take the journal below `target` does not happen); the process then
--     halts.
--   `recover j target` — re-invoked countdown recovery, `undo_all j target`.
--
-- Modeling note (deviation from the task's literal shape
-- `recover (crash_at (undo_all j target) k) target`): applying RAW pops to the
-- *completed* journal can take its length strictly below `target`, and recovery
-- is a pop-only operation — no theorem can restore entries that were popped past
-- the target. The honest model makes the crash pops target-guarded (each pop is
-- one iteration of the same runtime loop), which yields a strictly STRONGER
-- unconditional main theorem: recovery after a crash at ANY position k —
-- including k beyond the needed pop count — equals the clean undo.
--
-- Results:
-- 1. Main theorem `recover_after_crash`: `recover (crash_at k j target) target =
--    undo_all j target` for every crash position k, unconditionally.
-- 2. Idempotence `recover_recover`: re-invoked recovery after completion is a
--    no-op (via `undo_all_len`: the post-undo length is exactly `min len target`).
-- 3. Honest negative (the L47 finding, as a theorem)
--    `rollback_interleaved_diverges`: if rollback truncates the journal to a
--    length strictly below `target` while the undo is pending, recovery — a
--    pop-only operation — can never restore the lost entries: the final journal
--    has the truncated length, not `target`, so it differs from the clean undo.
--    This is exactly why the runtime refuses interleaved rollback
--    (`UndoInterruptedPending`); the theorem is the guard's justification.

/-! # ProcInt.StrataStore

Journal replay equivalence for strata-store-pack: crash-position-independent
recovery, idempotent recovery, and the proved necessity of the rollback guard.
-/

namespace ProcInt.StrataStore

/-! ## The journal model -/

/-- Store key (the template journals `Key` values). -/
abbrev Key := Nat

/-- Append-only journal; head = newest entry; undo pops the head. -/
abbrev Journal := List Key

/-- One undo pop. Total: popping the empty journal is a no-op. -/
def undo_step : Journal → Journal
  | [] => []
  | _ :: t => t

/-- Countdown undo (the template's `complete_pending_undo` while-loop):
pop until the journal length is at most `target`. -/
def undo_all : Journal → Nat → Journal
  | [], _ => []
  | h :: t, target =>
      if t.length < target then h :: t else undo_all t target

/-- A crash `k` pops into an in-progress undo: each pop is one iteration of the
same target-guarded loop; after `k` pops the process halts. -/
def crash_at : Nat → Journal → Nat → Journal
  | 0, j, _ => j
  | k + 1, j, target =>
      if j.length ≤ target then j else crash_at k (undo_step j) target

/-- Re-invoked countdown recovery (`complete_pending_undo` on restart). -/
def recover (j : Journal) (target : Nat) : Journal :=
  undo_all j target

/-! ## Replay-equivalence lemmas -/

/-- Post-undo length is exactly `min len target`. -/
theorem undo_all_len (j : Journal) (target : Nat) :
    (undo_all j target).length = min j.length target := by
  induction j with
  | nil => simp [undo_all]
  | cons h t ih =>
    unfold undo_all
    split
    · simp only [List.length_cons]
      omega
    · rename_i hlen
      rw [ih]
      simp only [List.length_cons]
      omega

/-- Undoing an already-at-target journal is the identity. -/
theorem undo_all_self (j : Journal) (target : Nat) (h : j.length ≤ target) :
    undo_all j target = j := by
  cases j with
  | nil => rfl
  | cons m t =>
    have hc : t.length < target := by
      simp [List.length_cons] at h
      omega
    unfold undo_all
    rw [if_pos hc]

/-- Re-invoked recovery is a no-op (idempotence). -/
theorem undo_all_idem (j : Journal) (target : Nat) :
    undo_all (undo_all j target) target = undo_all j target := by
  apply undo_all_self
  rw [undo_all_len]
  omega

theorem undo_step_cons (m : Key) (t : Journal) : undo_step (m :: t) = t := rfl

/-- One pop of an over-target journal does not change the undo outcome. -/
theorem undo_step_preserves (j : Journal) (target : Nat) (h : target < j.length) :
    undo_all (undo_step j) target = undo_all j target := by
  cases j with
  | nil => exact absurd h (by simp)
  | cons m t =>
    have hle : ¬ (t.length < target) := by
      have h' : target < t.length + 1 := by simpa using h
      omega
    rw [undo_step_cons, undo_all, if_neg hle]

/-! ## Main theorem -/

/-- **Main theorem.** Recovery after a crash at ANY position `k` (including no
crash, `k = 0`, and over-count `k` past the needed pops) yields exactly the
clean undo journal. Crash position is invisible in the final state. -/
theorem crash_undo_all (k : Nat) : ∀ (j : Journal) (target : Nat),
    undo_all (crash_at k j target) target = undo_all j target := by
  induction k with
  | zero => intro j target; rfl
  | succ k ih =>
    intro j target
    unfold crash_at
    split
    · rfl
    · rename_i hlen
      rw [ih (undo_step j) target, undo_step_preserves j target (by omega)]

theorem recover_after_crash (k : Nat) (j : Journal) (target : Nat) :
    recover (crash_at k j target) target = undo_all j target :=
  crash_undo_all k j target

/-- Idempotence in the runtime's vocabulary: re-invoked recovery after
completion is a no-op. -/
theorem recover_recover (j : Journal) (target : Nat) :
    recover (recover j target) target = recover j target :=
  undo_all_idem j target

/-! ## Honest negative: the rollback guard is necessary -/

/-- **The L47 finding, as a theorem.** If an (unguarded) rollback truncates the
journal to `trunc` entries while an undo to `target` is pending — with
`trunc < target ≤ len j` — then recovery cannot restore the lost entries: the
final journal has the truncated length, not `target`, hence differs from the
clean undo. Recovery is pop-only; entries lost below the target are gone. This
is exactly the divergence the runtime's `UndoInterruptedPending` refusal
prevents. -/
theorem rollback_interleaved_diverges (j : Journal) (target : Nat) (trunc : Nat)
    (hinter : trunc < target) (hlen : target ≤ j.length) :
    undo_all (List.take trunc j) target ≠ undo_all j target := by
  intro heq
  have h1 := undo_all_len (List.take trunc j) target
  have h2 := undo_all_len j target
  rw [List.length_take] at h1
  rw [heq] at h1
  omega

/-! ## Concrete witnesses (decided) -/

/-- Crash mid-undo: journal `[3,2,1]`, target 1, crash after 1 pop; recovery
still lands on the clean undo `[1]`. -/
example : recover (crash_at 1 [3, 2, 1] 1) 1 = [1] := by decide

/-- Crash before any pop; recovery performs the whole undo. -/
example : recover (crash_at 0 [3, 2, 1] 1) 1 = [1] := by decide

/-- Over-count crash (more pops than the undo needed); recovery is a no-op and
the clean undo is unchanged. -/
example : recover (crash_at 5 [3, 2, 1] 1) 1 = [1] := by decide

/-- The interleaved-rollback witness: truncate `[3,2,1]` to 0 while pending on
target 1; recovery leaves the empty journal, not the clean undo `[1]`. -/
example : undo_all (List.take 0 [3, 2, 1]) 1 = [] ∧ undo_all [3, 2, 1] 1 = [1] :=
  by decide

end ProcInt.StrataStore
