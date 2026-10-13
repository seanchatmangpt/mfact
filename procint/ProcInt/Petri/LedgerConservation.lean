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
--   Gate 4 (funds + capacity, against a shadow copy): per input line
--     `cur = self.balance(&id)` (reads the ORIGINAL ledger, not the shadow);
--     `cur < amt` -> InsufficientFunds; outputs add onto the shadow with checked
--     adds; capacity gate counts new accounts. Capacity and u128 overflow are
--     vacuous in the Nat model (an honest modeling gap); only the account-id
--     range half of the capacity gate is modeled, as `id < MAX_ACCOUNTS`.
--   Commit: inputs deducted into the shadow (OVERWRITE per line, each line's `cur`
--     read from the original), outputs added onto the shadow; zero-balance
--     non-output accounts are removed (irrelevant to the sum).
--
-- ## LAW MISMATCH FOUND (real defect in the template, proved below)
--
-- The template reads each input line's `cur` from `self` (the original ledger) and
-- then OVERWRITES `shadow[id] = cur - amt`. If one tx lists the SAME input account
-- on two lines, the second line's insert overwrites the first line's deduction,
-- while Gate 3's `sum_in` still counts BOTH amounts and Gate 4 funds each line
-- against the original (unspent) balance. Net effect: value is CREATED. Proved
-- counterexample: s0 = [10, 0], inputs [(0,5),(0,5)], outputs [(1,10)] — every gate
-- passes, sum 10 = 10, but the committed state sums to 15, not 10. The main theorem
-- (`strata_ledger_total_value_conserved`) therefore carries the honest side
-- condition that the tx's input accounts are DISTINCT; under that condition the
-- template's overwrite-from-original coincides with a sequential deduction fold
-- (`deductFold`) and the conservation law holds.

/-! # ProcInt.StrataLedger

Total-value conservation for strata-ledger-pack, modeled from the real
`apply_transition` gate sequence.

Results:

1. **Main theorem.** If a transaction's input accounts are distinct, then any
   admitted transition (`Apply tx s = some s'`) conserves the total balance:
   `Σ s' = Σ s`.

2. **Refusal witnesses.** A value-changing tx violates the strict-equality sum
   gate and is refused (`Apply = none`); the zero-nonce tx is refused.

3. **Honest negative result (law mismatch, L34).** The template's masked-shadow
   commit does NOT conserve total value for transactions with a duplicated input
   account: value is created. Concrete decided counterexample proved.
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

/-- Gate 4 (funds half): every input amount is covered by the ORIGINAL balance of
its account (the template reads `cur = self.balance(&id)`, not the shadow). -/
def fundsOk (tx : Tx) (s : Bal) : Bool :=
  tx.inputs.all fun p => getB s p.1 ≥ p.2

/-- Gate 3 (conservation): `sum_in = sum_out` **exactly** (strict equality in the
template: `if sum_in != sum_out { return Err(LedgerRefusal::Conservation) }`). -/
def consOk (tx : Tx) : Bool :=
  sumAmts tx.inputs == sumAmts tx.outputs

/-- First projections of a pair list are pairwise distinct (`NoDup` on the input
account ids). Defined locally to keep the module core-Lean-only. -/
def NoDupIds : List Nat → Prop
  | [] => True
  | a :: l => a ∉ l ∧ NoDupIds l

/-- Sequential deduction fold. Under distinct input accounts this coincides with
the template's overwrite-from-original shadow commit (each input account is touched
once, so "read the original" and "read the evolving shadow" agree); the
`duplicate_input_creates_value` counterexample below exhibits the case where they
diverge. -/
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

/-- `Apply` mirrors `apply_transition`: every gate runs BEFORE any balance mutates
(masked commit); on refusal return `none` and the state is untouched. -/
def Apply (tx : Tx) (s : Bal) : Option Bal :=
  if nonceOk tx && rangeOk tx && fundsOk tx s && consOk tx then
    some (addFold (deductFold s tx.inputs) tx.outputs)
  else
    none

/-! ## Conservation of the deduction fold (distinct inputs) -/

/-- The deduction fold removes exactly the sum of its input amounts, provided each
input account is touched once (NoDupIds) and every amount was funded. -/
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

/-- **Main theorem (strata-ledger total-value conservation).** If the tx's input
accounts are distinct, every admitted transition conserves total value:
`Apply tx s = some s' → Σ s' = Σ s`. -/
theorem strata_ledger_total_value_conserved (tx : Tx) (s s' : Bal)
    (hnd : NoDupIds (tx.inputs.map Prod.fst))
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
  have hfunds' : (tx.inputs.all fun q => getB s q.1 ≥ q.2) = true := h2.2
  have hfunds : ∀ p ∈ tx.inputs, getB s p.1 ≥ p.2 := fun p hp =>
    of_decide_eq_true (List.all_eq_true.mp hfunds' p hp)
  have hs' : s' = addFold (deductFold s tx.inputs) tx.outputs := by
    simp only [Apply, hcond] at h
    exact Option.some.inj h.symm
  calc balSum s'
        = balSum (addFold (deductFold s tx.inputs) tx.outputs) := by rw [hs']
      _ = balSum (deductFold s tx.inputs) + sumAmts tx.outputs := addFold_sum _ _
      _ = balSum s := by
          have hd := deductFold_sum tx.inputs s hnd hfunds
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

/-! ## Honest negative result: duplicated input accounts CREATE value (law mismatch)

This models the template commit FAITHFULLY (`applyIns`: each line reads `cur` from
the original ledger and overwrites the shadow). Two lines at the same account: the
second insert erases the first deduction, while Gate 3 counts both amounts in
`sum_in` and Gate 4 funds each line against the untouched original balance. -/

/-- **Counterexample (value creation).** `s0 = [10, 0]`, inputs `[(0,5),(0,5)]`,
outputs `[(1,10)]`. All gates pass (`sum_in = 10 = sum_out`; each line's `cur = 10
≥ 5`), the transition is ADMITTED, yet the committed state sums to 15, not 10:
account 0 was deducted only once. This is a real defect in
`ledger_state.rs.tera::apply_transition` (no per-tx input-account dedup), not in
the conservation law. -/
theorem duplicate_input_creates_value :
    balSum (addFold (applyIns [10, 0] [10, 0] [(0, 5), (0, 5)]) [(1, 10)]) = 15 ∧
    balSum ([10, 0] : List Nat) = 10 ∧
    balSum (addFold (applyIns [10, 0] [10, 0] [(0, 5), (0, 5)]) [(1, 10)])
      ≠ balSum ([10, 0] : List Nat) := by
  refine ⟨by decide, rfl, by decide⟩

/-- The same tx passes the full faithful gate sequence: the nonce is fresh, all ids
are in range, every input line is funded against the original state, and the
masked sums are equal (10 = 10) — so the gates refuse nothing while value is
created. -/
theorem duplicate_input_tx_passes_all_gates :
    nonceOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } = true ∧
    rangeOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } = true ∧
    fundsOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } [10, 0] = true ∧
    consOk { inputs := [(0, 5), (0, 5)], outputs := [(1, 10)], nonce := 1 } = true := by
  refine ⟨rfl, rfl, rfl, rfl⟩

end ProcInt.StrataLedger
