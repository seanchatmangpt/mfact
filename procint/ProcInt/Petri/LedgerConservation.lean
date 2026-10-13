-- Hand-authored construction lane (L34 candidate 1, L72).
-- Pattern follows ProcInt/Petri/PN64Conservation.lean (core-Lean-only, def+decide+omega;
-- "ggen renders; Lean admits"). This module admits strata-ledger-pack's core
-- value-conservation law at the Lean level.
--
-- The real law: packs/strata-ledger-pack/templates/ledger_state.rs.tera,
-- `LedgerState::apply_transition`. Read verbatim from the template, the gates are:
--   Gate 1 (replay valve): digest already seen -> refuse. (Out of scope here: the
--     `Bal` model carries no digest set; replay is orthogonal to value conservation.)
--   Gate 2 (double-spend valve): `tx.nonce == 0 || tx.nonce <= last` -> refuse.
--     Modeled as `nonceOk := tx.nonce != 0` (the `Bal` model carries no per-account
--     nonce map; the strict-advance semantics is a nonce-store property, not a
--     balance property).
--   Gate 3 (overflow + conservation): masked sums with checked adds;
--     `sum_in != sum_out` -> `LedgerRefusal::Conservation`. **Strict equality** —
--     the task's "(3) sum_in = sum_out exactly" reading of the template is correct;
--     there is no <= / >= tolerance anywhere in the template's sum gate. In the Nat
--     model the u128 overflow half of the gate is vacuous (no overflow); this is an
--     honest modeling gap, not a law mismatch.
--   Gate 4 (funds + capacity, against a shadow copy): FIXED (commit 1d16f2472,
--     DUPLICATE-INPUT DEBIT ACCUMULATION LAW): same-account input rows are first
--     ACCUMULATED into one per-account debit (`debits: BTreeMap` + checked_add,
--     overflow refused), then each accumulated debit is checked once against the
--     ORIGINAL balance (`cur < debit` -> InsufficientFunds) and applied once to
--     the shadow; outputs add onto the shadow with checked adds; capacity gate
--     counts new accounts. Capacity and u128 overflow are vacuous in the Nat
--     model (an honest modeling gap); only the account-id range half of the
--     capacity gate is modeled, as `id < MAX_ACCOUNTS`.
--   Commit: accumulated debits deducted into the shadow (one deduction per
--     account), outputs added onto the shadow; zero-balance non-output accounts
--     are removed (irrelevant to the sum).
--
-- ## LAW MISMATCH FOUND, then FIXED (history retained below)
--
-- The OLD template read each input line's `cur` from `self` (the original ledger)
-- and then OVERWROTE `shadow[id] = cur - amt`. If one tx listed the SAME input
-- account on two lines, the second line's insert overwrote the first line's
-- deduction, while Gate 3's `sum_in` still counted BOTH amounts. Net effect: value
-- was CREATED (counterexample: s0 = [10, 0], inputs [(0,5),(0,5)], outputs
-- [(1,10)] — committed state summed to 15, not 10). The main theorem then carried
-- a NoDupIds side condition. The template was FIXED in commit 1d16f2472 (debit-
-- delta accumulation): Σ conservation now holds UNCONDITIONALLY over every
-- gate-passing tx, and the old counterexample tx admits with Σ conserved (or
-- refuses when the accumulated debit exceeds the balance). The old per-row-read
-- model and its value-creation counterexample are retained below as history
-- (`duplicate_input_created_value_under_per_row_read`), modeled by `applyIns`.

/-! # ProcInt.StrataLedger

Total-value conservation for strata-ledger-pack, modeled from the real
`apply_transition` gate sequence.

Results:

1. **Main theorem (unconditional).** Every admitted transition
   (`Apply tx s = some s'`) conserves the total balance: `Σ s' = Σ s`. No
   NoDupIds side condition: the fixed template accumulates same-account input
   rows into one per-account debit before the single balance check (commit
   1d16f2472), and `Apply` mirrors that fold.

2. **Refusal witnesses.** A value-changing tx violates the strict-equality sum
   gate and is refused (`Apply = none`); the zero-nonce tx is refused; the
   historical duplicate-input counterexample tx with an underfunded accumulated
   debit is refused.

3. **History (law mismatch, L34; FIXED in 1d16f2472).** The OLD per-row-read
   shadow commit (`applyIns`) did NOT conserve total value for transactions with
   a duplicated input account: value was created. Concrete decided counterexample
   retained (`duplicate_input_created_value_under_per_row_read`), plus the
   post-fix witness `duplicate_input_now_admits_and_conserves`.
-/

namespace ProcInt.StrataLedger

/-! ## Balances, accounts, and the point-update primitives -/

/-- Account identifiers (strata-ledger `AccountId`). -/
abbrev AccountId := Nat

/-- The account-id capacity constant (`MAX_ACCOUNTS`). -/
def MAX_ACCOUNTS : Nat := 65536

/-- Balance state: `Bal := List Nat`, indexed by account id (position `i` is the
balance of account `i`; reads past the end of the list are 0). -/
abbrev Bal := List Nat

/-- `getB s i` — balance of account `i` in state `s` (0 beyond the list end). -/
def getB : List Nat → Nat → Nat
  | [], _ => 0
  | b :: _, 0 => b
  | _ :: bs, i + 1 => getB bs i

/-- `setB s i v` — point update, extending with zeros past the list end. -/
def setB : List Nat → Nat → Nat → List Nat
  | [], 0, v => [v]
  | [], i + 1, v => 0 :: setB [] i v
  | _ :: bs, 0, v => v :: bs
  | b :: bs, i + 1, v => b :: setB bs i v

/-- Total value of a state. -/
def balSum : List Nat → Nat
  | [] => 0
  | b :: bs => b + balSum bs

/-! ## Ground facts about the point-update primitives -/

theorem getB_setB_same : ∀ (i : Nat) (l : List Nat) (v : Nat), getB (setB l i v) i = v := by
  intro i
  induction i with
  | zero =>
      intro l v
      cases l with
      | nil => rfl
      | cons b bs => rfl
  | succ i ih =>
      intro l v
      cases l with
      | nil => simp only [setB, getB]; exact ih [] v
      | cons b bs => simp only [setB, getB]; exact ih bs v

theorem getB_setB_ne :
    ∀ (i j : Nat) (l : List Nat) (v : Nat), i ≠ j → getB (setB l j v) i = getB l i := by
  intro i j
  induction i generalizing j with
  | zero =>
      intro l v hne
      cases j with
      | zero => exact absurd rfl hne
      | succ j =>
          cases l with
          | nil => rfl
          | cons b bs => rfl
  | succ i ih =>
      intro l v hne
      cases j with
      | zero =>
          cases l with
          | nil => rfl
          | cons b bs => rfl
      | succ j =>
          cases l with
          | nil => exact ih j [] v (fun h => hne (by rw [h]))
          | cons b bs => exact ih j bs v (fun h => hne (by rw [h]))

theorem balSum_setB : ∀ (i : Nat) (l : List Nat) (v : Nat),
    balSum (setB l i v) + getB l i = balSum l + v := by
  intro i
  induction i with
  | zero =>
      intro l v
      cases l with
      | nil => simp [setB, getB, balSum]
      | cons b bs => simp [setB, getB, balSum]; omega
  | succ i ih =>
      intro l v
      cases l with
      | nil =>
          have hih := ih ([] : List Nat) v
          simp only [setB, getB, balSum] at hih ⊢
          omega
      | cons b bs =>
          simp only [setB, getB, balSum]
          have := ih bs v
          omega

/-! ## Transactions and the gate predicates -/

/-- Minimal tx shape (`TxLike` in the template): inputs and outputs are small lists
of `(AccountId, Nat)` pairs, plus a nonce. -/
structure Tx where
  inputs : List (Nat × Nat)
  outputs : List (Nat × Nat)
  nonce : Nat

/-- Sum of the amounts on one side of a tx (masked sum; no overflow in Nat). -/
def sumAmts : List (Nat × Nat) → Nat
  | [] => 0
  | ⟨_, a⟩ :: rest => a + sumAmts rest

/-- Gate 1 (range/capacity half): every referenced account is `< MAX_ACCOUNTS`. -/
def rangeOk (tx : Tx) : Bool :=
  (tx.inputs.all fun p => p.1 < MAX_ACCOUNTS) &&
  (tx.outputs.all fun p => p.1 < MAX_ACCOUNTS)

/-- Gate 2 (nonce half of the double-spend valve): the nonce must strictly advance;
the `Bal` model carries no per-account nonce store, so `nonce = 0` is refused. -/
def nonceOk (tx : Tx) : Bool :=
  tx.nonce != 0

/-- First projections of a pair list are pairwise distinct (`NoDup` on the input
account ids). Defined locally to keep the module core-Lean-only. Note: POST-FIX
this is a shape fact about the accumulated debit map (BTreeMap keys), not a side
condition on the theorem. -/
def NoDupIds : List Nat → Prop
  | [] => True
  | a :: l => a ∉ l ∧ NoDupIds l

/-- DUPLICATE-INPUT DEBIT ACCUMULATION (commit 1d16f2472): merge one `(id, amt)`
row into the per-account debit map — add onto an existing entry, or append a new
one. Mirrors `debits: BTreeMap<AccountId, u128>` + `checked_add` (the u128
overflow refusal is vacuous in the Nat model). -/
def updAcc : List (Nat × Nat) → Nat → Nat → List (Nat × Nat)
  | [], id, a => [(id, a)]
  | (id', a') :: rest, id, a =>
      if id' = id then (id', a' + a) :: rest else (id', a') :: updAcc rest id a

/-- Accumulate same-account input rows into one per-account debit list (the
template's `debits` BTreeMap fold over `tx.inputs`). -/
def accDebits : List (Nat × Nat) → List (Nat × Nat) → List (Nat × Nat)
  | acc, [] => acc
  | acc, (id, a) :: ins => accDebits (updAcc acc id a) ins

/-- Ground fact: merging a row adds exactly its amount to the debit sum. -/
theorem updAcc_sum : ∀ (acc : List (Nat × Nat)) (id a : Nat),
    sumAmts (updAcc acc id a) = sumAmts acc + a := by
  intro acc id a
  induction acc with
  | nil => simp [updAcc, sumAmts]
  | cons p rest ih =>
      obtain ⟨id', a'⟩ := p
      by_cases h : id' = id
      · rw [updAcc, if_pos h]
        simp only [sumAmts]
        omega
      · rw [updAcc, if_neg h]
        simp only [sumAmts]
        rw [ih]
        omega

/-- Ground fact: accumulation preserves the amount sum. -/
theorem accDebits_sum : ∀ (ins acc : List (Nat × Nat)),
    sumAmts (accDebits acc ins) = sumAmts acc + sumAmts ins := by
  intro ins
  induction ins with
  | nil => intro acc; simp [accDebits, sumAmts]
  | cons p rest ih =>
      intro acc
      obtain ⟨id, a⟩ := p
      have h := updAcc_sum acc id a
      simp only [accDebits, sumAmts]
      rw [ih]
      omega

/-- Ground fact: a merged row keeps the key list if the key is present, else
appends it at the end (the BTreeMap fold's discovery order). -/
theorem updAcc_keys : ∀ (acc : List (Nat × Nat)) (id a : Nat),
    (updAcc acc id a).map Prod.fst =
      if id ∈ acc.map Prod.fst then acc.map Prod.fst
      else acc.map Prod.fst ++ [id] := by
  intro acc id a
  induction acc with
  | nil => rfl
  | cons p rest ih =>
      obtain ⟨id', a'⟩ := p
      by_cases h : id' = id
      · subst h
        simp [updAcc]
      · simp only [updAcc, if_neg h, List.map_cons]
        by_cases hm : id ∈ rest.map Prod.fst
        · rw [ih, if_pos hm, if_pos (by simp [hm])]
        · have h2 : ¬(id ∈ id' :: rest.map Prod.fst) := by
            intro hc
            rcases List.mem_cons.mp hc with hc1 | hc2
            · exact h hc1.symm
            · exact hm hc2
          rw [ih, if_neg hm, if_neg h2]
          simp [List.cons_append]

/-- Ground fact: appending a fresh key preserves key distinctness. -/
theorem NoDupIds_append : ∀ (l : List Nat) (x : Nat),
    NoDupIds l → x ∉ l → NoDupIds (l ++ [x]) := by
  intro l
  induction l with
  | nil =>
      intro x _ _
      show x ∉ ([] : List Nat) ∧ NoDupIds ([] : List Nat)
      exact ⟨by simp, by simp [NoDupIds]⟩
  | cons y ys ih =>
      intro x h h0
      obtain ⟨hnd, hrec⟩ : y ∉ ys ∧ NoDupIds ys := h
      have hrest := ih x hrec (fun hc => h0 (List.mem_cons_of_mem _ hc))
      refine ⟨?_, hrest⟩
      intro hc
      rcases List.mem_append.mp hc with h1 | h1
      · exact hnd h1
      · rcases List.mem_singleton.mp h1 with h1'
        exact h0 (by rw [h1']; exact List.mem_cons_self ..)

/-- Ground fact: the accumulated debit list has distinct keys (BTreeMap shape). -/
theorem accDebits_nodup : ∀ (ins acc : List (Nat × Nat)),
    NoDupIds (acc.map Prod.fst) →
    NoDupIds ((accDebits acc ins).map Prod.fst) := by
  intro ins
  induction ins with
  | nil => intro acc h; exact h
  | cons p rest ih =>
      intro acc h
      obtain ⟨id, a⟩ := p
      have hkeys := updAcc_keys acc id a
      have hupd : NoDupIds ((updAcc acc id a).map Prod.fst) := by
        rw [hkeys]
        split
        · exact h
        · rename_i h0
          exact NoDupIds_append _ _ h h0
      exact ih _ hupd

/-- Gate 4 (funds half, POST-FIX): every ACCUMULATED per-account debit is covered
by the ORIGINAL balance of its account (one check per account, before any
mutation — the template's `for (id, debit) in debits.iter()` loop). -/
def fundsOk (tx : Tx) (s : Bal) : Bool :=
  (accDebits [] tx.inputs).all fun p => getB s p.1 ≥ p.2

/-- Gate 3 (conservation): `sum_in = sum_out` **exactly** (strict equality in the
template: `if sum_in != sum_out { return Err(LedgerRefusal::Conservation) }`). -/
def consOk (tx : Tx) : Bool :=
  sumAmts tx.inputs == sumAmts tx.outputs

/-- Sequential deduction fold over the ACCUMULATED per-account debit list
(post-fix commit sequence). Each accumulated debit is deducted once against the
original balance; distinct keys make the point updates independent. -/
def deductFold (s : Bal) : List (Nat × Nat) → Bal
  | [] => s
  | (id, a) :: ins => deductFold (setB s id (getB s id - a)) ins

/-- Output commit: add each output amount onto the account (shadow chaining:
adding twice at the same account accumulates, exactly like the template). -/
def addFold (s : Bal) : List (Nat × Nat) → Bal
  | [] => s
  | (id, a) :: outs => addFold (setB s id (getB s id + a)) outs

/-- The faithful template commit for INPUTS: every line reads `cur` from the
ORIGINAL state `s0` and overwrites the shadow. Models the template's input loop
exactly (when no gate fires). -/
def applyIns (s0 shadow : Bal) : List (Nat × Nat) → Bal
  | [] => shadow
  | (id, a) :: ins => applyIns s0 (setB shadow id (getB s0 id - a)) ins

/-- `Apply` mirrors `apply_transition` (POST-FIX, commit 1d16f2472): every gate
runs BEFORE any balance mutates (masked commit); same-account input rows are
accumulated into one per-account debit (`accDebits`) before the single funds
check; on refusal return `none` and the state is untouched. -/
def Apply (tx : Tx) (s : Bal) : Option Bal :=
  if nonceOk tx && rangeOk tx && fundsOk tx s && consOk tx then
    some (addFold (deductFold s (accDebits [] tx.inputs)) tx.outputs)
  else
    none

/-! ## Conservation of the deduction fold over accumulated debits -/

/-- The deduction fold removes exactly the sum of its debit amounts, provided the
debit keys are distinct (true of the accumulated map) and every debit was funded. -/
theorem deductFold_sum : ∀ (ins : List (Nat × Nat)) (s : Bal),
    NoDupIds (ins.map Prod.fst) →
    (∀ p ∈ ins, getB s p.1 ≥ p.2) →
    balSum (deductFold s ins) + sumAmts ins = balSum s := by
  intro ins
  induction ins with
  | nil => intro s _ _; simp [deductFold, sumAmts]
  | cons p rest ih =>
      intro s hnd hfunds
      obtain ⟨id, a⟩ := p
      -- NoDupIds ((id,a) :: rest).map Prod.fst reduces to `id ∉ ids(rest) ∧ NoDupIds ids(rest)`
      have hsplit : id ∉ rest.map Prod.fst ∧ NoDupIds (rest.map Prod.fst) := hnd
      have hmem : getB s id ≥ a := hfunds (id, a) (List.mem_cons_self ..)
      have hsum : balSum (setB s id (getB s id - a)) + a = balSum s := by
        have := balSum_setB id s (getB s id - a)
        omega
      have hrestfunds : ∀ q ∈ rest, getB (setB s id (getB s id - a)) q.1 ≥ q.2 := by
        intro q hq
        have hne : q.1 ≠ id := by
          intro h
          exact hsplit.1 (h ▸ List.mem_map_of_mem hq)
        rw [getB_setB_ne q.1 id s (getB s id - a) hne]
        exact hfunds q (List.mem_cons_of_mem _ hq)
      have := ih (setB s id (getB s id - a)) hsplit.2 hrestfunds
      simp only [deductFold, sumAmts] at this ⊢
      omega

/-- The output commit adds exactly the sum of its output amounts (shadow chaining
included: repeated output accounts accumulate). -/
theorem addFold_sum : ∀ (outs : List (Nat × Nat)) (s : Bal),
    balSum (addFold s outs) = balSum s + sumAmts outs := by
  intro outs
  induction outs with
  | nil => intro s; simp [addFold, sumAmts]
  | cons p rest ih =>
      intro s
      obtain ⟨id, a⟩ := p
      have hstep : balSum (setB s id (getB s id + a)) = balSum s + a := by
        have := balSum_setB id s (getB s id + a)
        omega
      simp only [addFold, sumAmts]
      rw [ih]
      omega

/-! ## The main theorem -/

/-- **Main theorem (strata-ledger total-value conservation, UNCONDITIONAL).**
Every admitted transition conserves total value: `Apply tx s = some s' → Σ s' =
Σ s`. No side condition on the tx's input accounts: the fixed template
accumulates same-account input rows into one per-account debit before the single
balance check (commit 1d16f2472, DUPLICATE-INPUT DEBIT ACCUMULATION LAW), and
accumulation preserves both the amount sum (`accDebits_sum`) and key distinctness
(`accDebits_nodup`). -/
theorem strata_ledger_total_value_conserved (tx : Tx) (s s' : Bal)
    (h : Apply tx s = some s') : balSum s' = balSum s := by
  have hcond : (nonceOk tx && rangeOk tx && fundsOk tx s && consOk tx) = true := by
    cases hb : (nonceOk tx && rangeOk tx && fundsOk tx s && consOk tx) with
    | false =>
        exfalso
        simp only [Apply] at h
        rw [hb] at h
        simp at h
    | true => rfl
  have h1 := Bool.and_eq_true_iff.mp hcond        -- ((nonceOk && rangeOk) && fundsOk) = true ∧ consOk = true
  have h2 := Bool.and_eq_true_iff.mp h1.1         -- (nonceOk && rangeOk) = true ∧ fundsOk = true
  have hcons' : (sumAmts tx.inputs == sumAmts tx.outputs) = true := h1.2
  have hcon : sumAmts tx.inputs = sumAmts tx.outputs := by
    simp at hcons'
    exact hcons'
  have hfunds' : ((accDebits [] tx.inputs).all fun q => getB s q.1 ≥ q.2) = true := h2.2
  have hfunds : ∀ p ∈ accDebits [] tx.inputs, getB s p.1 ≥ p.2 := fun p hp =>
    of_decide_eq_true (List.all_eq_true.mp hfunds' p hp)
  have hnd : NoDupIds ((accDebits [] tx.inputs).map Prod.fst) :=
    accDebits_nodup tx.inputs [] (by simp [NoDupIds])
  have hsum : sumAmts (accDebits [] tx.inputs) = sumAmts tx.inputs := by
    have := accDebits_sum tx.inputs []
    simpa [sumAmts] using this
  have hs' : s' = addFold (deductFold s (accDebits [] tx.inputs)) tx.outputs := by
    simp only [Apply, hcond] at h
    exact Option.some.inj h.symm
  calc balSum s'
        = balSum (addFold (deductFold s (accDebits [] tx.inputs)) tx.outputs) := by rw [hs']
      _ = balSum (deductFold s (accDebits [] tx.inputs)) + sumAmts tx.outputs :=
          addFold_sum _ _
      _ = balSum s := by
          have hd := deductFold_sum (accDebits [] tx.inputs) s hnd hfunds
          omega

/-! ## Refusal witnesses: the strict-equality sum gate and the nonce valve -/

/-- A concrete value-changing tx is refused outright by the strict-equality
conservation gate (`sum_in = sum_out` exactly): no state is produced, so no
value can move. `Σ in = 5 ≠ 4 = Σ out`. -/
theorem apply_refuses_sum_mismatch :
    (Apply { inputs := [(0, 5)], outputs := [(0, 4)], nonce := 1 } [7, 0]) = none := by
  rfl

/-- The nonce valve refuses `nonce = 0` outright. -/
theorem apply_refuses_zero_nonce :
    (Apply { inputs := [(0, 2)], outputs := [(1, 2)], nonce := 0 } [7, 0]) = none := by
  rfl

/-! ## History: duplicated input accounts CREATED value under the old per-row
read (law mismatch, FIXED in commit 1d16f2472)

`applyIns` models the OLD template commit faithfully (each line reads `cur` from
the original ledger and overwrites the shadow). Two lines at the same account: the
second insert erases the first deduction, while Gate 3 counts both amounts in
`sum_in`. The template was fixed by the DUPLICATE-INPUT DEBIT ACCUMULATION LAW
(commit 1d16f2472): same-account rows fold into one per-account debit before the
single balance check, so this model no longer matches the shipped projection —
it is retained only as the historical counterexample. -/

/-- **Counterexample (value creation, OLD model only).** `s0 = [10, 0]`, inputs
`[(0,5),(0,5)]`, outputs `[(1,10)]`. All gates pass (`sum_in = 10 = sum_out`),
the transition is ADMITTED under the old per-row-read commit, yet the committed
state sums to 15, not 10: account 0 was deducted only once. This defect in
`ledger_state.rs.tera::apply_transition` was FIXED in commit 1d16f2472 (debit-
delta accumulation); see `duplicate_input_now_admits_and_conserves` below for the
post-fix behavior of the exact same tx under the current `Apply`. -/
theorem duplicate_input_created_value_under_per_row_read :
    balSum (addFold (applyIns [10, 0] [10, 0] [(0, 5), (0, 5)]) [(1, 10)]) = 15 ∧
    balSum ([10, 0] : List Nat) = 10 ∧
    balSum (addFold (applyIns [10, 0] [10, 0] [(0, 5), (0, 5)]) [(1, 10)])
      ≠ balSum ([10, 0] : List Nat) := by
  refine ⟨by decide, rfl, by decide⟩

/-- The exact historical counterexample tx passes every gate of the FIXED model
too: nonce fresh, ids in range, the ACCUMULATED debit (0,10) is funded by the
balance-10 account, masked sums equal (10 = 10). -/
theorem duplicate_input_tx_passes_all_gates :
    nonceOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } = true ∧
    rangeOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } = true ∧
    fundsOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } [10, 0] = true ∧
    consOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } = true := by
  refine ⟨rfl, rfl, rfl, rfl⟩

/-! ## Post-fix witness: the duplicate-input tx now admits AND conserves -/

/-- **The exact counterexample tx, post-fix (commit 1d16f2472).** With balance 10
the duplicate-input tx `inputs [(0,5),(0,5)], outputs [(1,10)]` now ADMITS and the
result state is `[0, 10]` — Σ conserved (10 = 10), no value minted. With balance 5
the ACCUMULATED debit (0,10) exceeds the balance, so the single funds check
refuses (`Apply = none`). The unconditional main theorem then gives conservation
for the admitting case directly. -/
theorem duplicate_input_now_admits_and_conserves :
    (Apply { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } [10, 0])
      = some [0, 10] ∧
    (Apply { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } [5, 0])
      = none := by
  refine ⟨rfl, rfl⟩

end ProcInt.StrataLedger
