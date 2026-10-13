-- Root module for the strata-store Lean admission lane (L34 candidate 2, L83).
-- Journal-replay laws live in ProcInt/Petri/JournalReplay.lean (same namespace);
-- this module adds the STORE ROLLBACK LAW formalizing the Rust store engine's
-- marker rollback (`rollback_to` / `undo_to_fork` in
-- packs/strata-store-pack/generated/store_engine.rs, READ-ONLY referent):
--   - a `StoreMarker` is the journal length at mark time;
--   - `rollback_to` pops the journal down to the marker, removing exactly the
--     post-marker insertions (tombstone-free rollback);
--   - rollback REFUSES (`RollbackPastGenesis`) for a marker beyond the journal
--     length;
--   - `put` dedups: an already-present key is not re-journaled, so the journal
--     is a fresh-key insertion log and the store state is determined by it.
import ProcInt.Petri.JournalReplay

/-! # ProcInt.StrataStore (rollback law) -/

namespace ProcInt.StrataStore.RollbackLaw

abbrev Key := Nat
abbrev Val := Nat

/-- Insertion journal: `(key, value)` pairs, head = oldest, newest appended at
the tail — the Rust `journal: Vec<[u8;32]>` with `push`/`pop` at the tail. -/
abbrev Journal := List (Key × Val)

/-- Store marker: the journal length at mark time. -/
abbrev Marker := Nat

/-- Apply a transaction write set (the `put` loop): only FRESH keys are
journaled (`put` dedups — an existing key returns early without journaling),
new writes are journaled in transaction order. -/
def commit (j : Journal) (txn : Journal) : Journal :=
  j ++ txn.filter (fun kv => List.lookup kv.1 j = none)

/-- The (unguarded) rollback body: pop the journal down to length `m` — the
`sabotaged_rollback_unguarded` body / `complete_pending_undo` while-loop. -/
def rollbackBody (j : Journal) (m : Marker) : Journal := j.take m

/-- Guarded rollback (`rollback_to`): REFUSES (`none` = `RollbackPastGenesis`)
for a marker beyond the journal length; otherwise truncates to `m`. -/
def rollbackTo (j : Journal) (m : Marker) : Option Journal :=
  if m ≤ j.length then some (rollbackBody j m) else none

/-! ## Guard law -/

/-- A marker beyond the journal length is refused (`RollbackPastGenesis`). -/
theorem rollback_past_genesis_refuses (j : Journal) (m : Marker) (hm : j.length < m) :
    rollbackTo j m = none := by
  unfold rollbackTo
  exact if_neg (Nat.not_le.mpr hm)

/-! ## Theorem (a): rollback after a partial transaction restores the initial state -/

/-- A committed prefix is untouched by a later rollback to its mark. The rolled
back journal is EXACTLY the journal at mark time: no lost commits, no phantom
writes (state equality). -/
theorem rollback_partial_txn_eq_initial (j txn : Journal) :
    rollbackBody (commit j txn) j.length = j := by
  unfold commit rollbackBody
  have h0 : List.length j - List.length j = 0 := Nat.sub_self _
  rw [List.take_append, h0, List.take_zero, List.append_nil, List.take_length]

/-! ## Theorem (b): committed writes survive rollback of a LATER transaction -/

/-- Rolling a store that already contains committed writes back to an earlier
marker `m` leaves exactly the marked prefix: every committed write with its
committed position in the journal survives; every later write is gone. -/
theorem committed_survive_later_rollback (j txn : Journal) (m : Marker)
    (hm : m ≤ j.length) :
    rollbackBody (commit j txn) m = j.take m := by
  unfold commit rollbackBody
  have hsub : m - j.length = 0 := Nat.sub_eq_zero_of_le hm
  rw [List.take_append, hsub, List.take_zero, List.append_nil]

/-! ## Theorem (c): rollback is idempotent -/

theorem rollback_idem (j : Journal) (m : Marker) :
    rollbackBody (rollbackBody j m) m = rollbackBody j m := by
  unfold rollbackBody
  rw [List.take_take, Nat.min_self]

/-! ## Concrete witnesses (decided) -/

/-- Dedup witness: re-writing key `1` in the transaction is not re-journaled. -/
example : commit [(1, 10)] [(2, 20), (1, 99)] = [(1, 10), (2, 20)] := by decide

/-- Rollback after a partial transaction: journal `[(1,10)]`, txn writes keys
2 and 1; rolling back to the pre-txn marker restores exactly `[(1,10)]`. -/
example : rollbackBody (commit [(1, 10)] [(2, 20), (1, 99)]) 1 = [(1, 10)] := by decide

/-- Idempotence witness. -/
example : rollbackBody (rollbackBody [(1, 10), (2, 20), (3, 30)] 2) 2
    = [(1, 10), (2, 20)] := by decide

end ProcInt.StrataStore.RollbackLaw
