-- Hand-authored construction lane (L45, strata-net-pack laws in core Lean).
-- Pattern follows ProcInt/Petri/PN64Conservation.lean (hand-authored, core-Lean-only,
-- def+decide+omega style, no Mathlib) so admission is a fast hermetic `lake build`.
--
-- Modeled from the strata-net-pack law set:
--   * SlotRateLimiter budget invariant (ECLIPSE_SUBNET_CAP noted separately);
--   * Mempool capacity law with minimum-digest eviction at capacity;
--   * the one-way conservation law: decode admits `sum_out >= sum_in` — inflation
--     passes the mempool shadow by design (strata-net template comment), so the
--     shadow is NOT a conservation gate. Stated honestly, with proved negatives
--     (inflation admitted, deflation refused) in the PN64 t02 honest-negative pattern.

namespace ProcInt.StrataNet

/-! ## SlotRateLimiter: the budget invariant -/

/-- Slot rate-limiter budget (strata-net-pack SlotRateLimiter). -/
def budget : Nat := 32

/-- Eclipse-subnet cap — a distinct constant, not the limiter budget. -/
def ECLIPSE_SUBNET_CAP : Nat := 8

/-- A rate-limiter op sequence: `note` = note_msg (admission attempt), `noop` =
any other slot activity that leaves the counter untouched. -/
inductive Op where
  | note : Op
  | noop : Op

/-- One limiter step: note_msg succeeds iff `seen < budget`, incrementing;
otherwise the counter saturates (the note is rejected). -/
def limStep (seen : Nat) : Nat :=
  if seen < budget then seen + 1 else seen

/-- Run an op sequence from an initial counter value (head of the list fires
first). -/
def limRun : List Op → Nat → Nat
  | [], s => s
  | Op.note :: ops, s => limStep (limRun ops s)
  | Op.noop :: ops, s => limRun ops s

/-- **Budget invariant.** Any op sequence run from a within-budget counter stays
within budget: `seen <= budget` is preserved by every step, hence by induction
over the whole sequence. -/
theorem limRun_le_budget : ∀ (ops : List Op) (s : Nat), s ≤ budget → limRun ops s ≤ budget
  | [], _, h => h
  | Op.note :: ops, s, h => by
      have hIn : limRun ops s ≤ budget := limRun_le_budget ops s h
      by_cases hlt : limRun ops s < budget
      · have hEq : limRun (Op.note :: ops) s = limRun ops s + 1 := by
          simp [limRun, limStep, hlt]
        omega
      · have hEq : limRun (Op.note :: ops) s = limRun ops s := by
          simp only [limRun]
          rw [limStep, if_neg hlt]
        omega
  | Op.noop :: ops, s, h => limRun_le_budget ops s h

/-- Saturated counter rejects: at `seen = budget` a note does not increment. -/
theorem limStep_saturated : limStep budget = budget := by
  simp [limStep]

/-! ## Mempool: capacity law with minimum-digest eviction

Digests are modeled as `Nat`; the BTreeSet is modeled as a sorted (non-strictly
ascending) list. -/

/-- Ascending-sortedness of a list (non-strict). -/
def Sorted : List Nat → Prop
  | [] => True
  | [_] => True
  | a :: b :: t => a ≤ b ∧ Sorted (b :: t)

/-- Ordered insertion. -/
def ins : Nat → List Nat → List Nat
  | d, [] => [d]
  | d, a :: t => if d ≤ a then d :: a :: t else a :: ins d t

theorem mem_ins (d x : Nat) (l : List Nat) :
    x ∈ ins d l ↔ x ∈ l ∨ x = d := by
  induction l with
  | nil => simp [ins]
  | cons a t ih =>
      by_cases h : d ≤ a
      · have hEq : ins d (a :: t) = d :: a :: t := by simp [ins, h]
        rw [hEq]
        simp only [List.mem_cons]
        exact or_comm
      · have hEq : ins d (a :: t) = a :: ins d t := by simp [ins, h]
        rw [hEq]
        simp only [List.mem_cons]
        rw [ih]
        constructor
        · intro hx
          rcases hx with h1 | (h1 | h1)
          · exact Or.inl (Or.inl h1)
          · exact Or.inl (Or.inr h1)
          · exact Or.inr h1
        · intro hx
          rcases hx with (h1 | h1) | h1
          · exact Or.inl h1
          · exact Or.inr (Or.inl h1)
          · exact Or.inr (Or.inr h1)

theorem ins_length_le : ∀ (l : List Nat) (d : Nat), (ins d l).length ≤ l.length + 1 := by
  intro l
  induction l with
  | nil => intro d; simp [ins]
  | cons a t ih =>
      intro d
      by_cases h : d ≤ a
      · have : ins d (a :: t) = d :: a :: t := by simp [ins, h]
        rw [this]
        simp
      · have : ins d (a :: t) = a :: ins d t := by simp [ins, h]
        rw [this]
        have := ih d
        simp
        omega

theorem ins_length_of_notMem : ∀ (l : List Nat) (d : Nat), d ∉ l →
    (ins d l).length = l.length + 1 := by
  intro l
  induction l with
  | nil => intro d _; simp [ins]
  | cons a t ih =>
      intro d hd
      by_cases h : d ≤ a
      · have hEq : ins d (a :: t) = d :: a :: t := by simp [ins, h]
        rw [hEq]
        simp
      · have hd' : d ∉ t := fun hmem => hd (by simp [hmem])
        have hEq : ins d (a :: t) = a :: ins d t := by simp [ins, h]
        rw [hEq]
        have := ih d hd'
        simp
        omega

theorem sorted_ins : ∀ (l : List Nat) (d : Nat), Sorted l → Sorted (ins d l) := by
  intro l
  induction l with
  | nil => intro d _; simp [ins, Sorted]
  | cons a t ih =>
      intro d hS
      cases t with
      | nil =>
          by_cases h : d ≤ a
          · have hEq : ins d [a] = d :: [a] := by simp [ins, h]
            rw [hEq]
            exact ⟨h, trivial⟩
          · have hEq : ins d [a] = a :: [d] := by simp [ins, h]
            rw [hEq]
            exact ⟨by omega, trivial⟩
      | cons b t' =>
          obtain ⟨hle, hst⟩ := hS
          by_cases h : d ≤ a
          · have hEq : ins d (a :: b :: t') = d :: a :: b :: t' := by simp [ins, h]
            rw [hEq]
            simp only [Sorted]
            exact ⟨h, hle, hst⟩
          · have hEq : ins d (a :: b :: t') = a :: ins d (b :: t') := by simp [ins, h]
            rw [hEq]
            by_cases h2 : d ≤ b
            · have hEq2 : ins d (b :: t') = d :: b :: t' := by simp [ins, h2]
              rw [hEq2]
              simp only [Sorted]
              exact ⟨by omega, h2, hst⟩
            · have hEq2 : ins d (b :: t') = b :: ins d t' := by simp [ins, h2]
              rw [hEq2]
              simp only [Sorted]
              have hrest := ih d hst
              rw [hEq2] at hrest
              exact ⟨hle, hrest⟩

/-! ### The mempool -/

/-- Mempool admit: a known digest is a no-op; below capacity the digest is
inserted in order; at capacity the incoming digest is admitted only if it
exceeds the current minimum `m`, evicting exactly `m`. A full pool of capacity
zero (empty pool at cap 0) rejects outright. -/
def admit (cap : Nat) (d : Nat) (l : List Nat) : List Nat :=
  if d ∈ l then l
  else if l.length < cap then ins d l
  else if l = [] then []
  else if l.headD 0 < d then ins d l.tail else l

theorem admit_capacity_step : ∀ (cap : Nat) (d : Nat) (l : List Nat),
    l.length ≤ cap → (admit cap d l).length ≤ cap := by
  intro cap d l hcap
  cases l with
  | nil =>
      unfold admit
      split
      · simp
      · split
        · simp only [ins, List.length_cons, List.length_nil]
          omega
        · simp
  | cons m t =>
      by_cases hmem : d ∈ m :: t
      · have hEq : admit cap d (m :: t) = m :: t := by
          unfold admit
          rw [if_pos hmem]
        rw [hEq]
        simpa using hcap
      · by_cases hlt : (m :: t).length < cap
        · have hEq : admit cap d (m :: t) = ins d (m :: t) := by
            unfold admit
            rw [if_neg hmem, if_pos hlt]
          rw [hEq]
          have := ins_length_le (m :: t) d
          omega
        · have hlen : (m :: t).length = cap := by omega
          by_cases hmd : m < d
          · have hhead : (m :: t).headD 0 = m := rfl
            have hEq : admit cap d (m :: t) = ins d t := by
              unfold admit
              rw [if_neg hmem, if_neg hlt, if_neg (show ¬(m :: t = []) from by simp),
                hhead, if_pos hmd, show (m :: t).tail = t from rfl]
            rw [hEq]
            have hd' : d ∉ t := fun h' => hmem (by simp [h'])
            rw [ins_length_of_notMem t d hd']
            omega
          · have hhead : (m :: t).headD 0 = m := rfl
            have hEq : admit cap d (m :: t) = m :: t := by
              unfold admit
              rw [if_neg hmem, if_neg hlt, if_neg (show ¬(m :: t = []) from by simp),
                hhead, if_neg hmd]
            rw [hEq]
            simpa using hcap

/-- **Mempool capacity law.** An admission sequence applied to a pool within
capacity leaves the pool within capacity — `len <= capacity` by induction over
the digest sequence. -/
theorem mempool_capacity : ∀ (cap : Nat) (ds : List Nat) (l : List Nat),
    l.length ≤ cap →
    (ds.foldl (fun acc d => admit cap d acc) l).length ≤ cap := by
  intro cap ds
  induction ds with
  | nil => intro l hcap; exact hcap
  | cons d rest ih =>
      intro l hcap
      exact ih (admit cap d l) (admit_capacity_step cap d l hcap)

/-- The head of a sorted list is a minimum: every tail element dominates it. -/
theorem head_le : ∀ (t : List Nat) (m : Nat), Sorted (m :: t) → ∀ x ∈ t, m ≤ x := by
  intro t
  induction t with
  | nil => intro m _ x hx; simp at hx
  | cons a t' ih =>
      intro m hS x hx
      obtain ⟨h1, h2⟩ := hS
      rcases List.mem_cons.1 hx with rfl | hx'
      · exact h1
      · have := ih a h2 x hx'
        omega

/-- **Eviction law.** At capacity, an admitted fresh digest evicts exactly the
minimum: the result is the ordered insert into the tail, of full capacity, the
evicted head `m` was the minimum of the pool, and `m` is gone from the result. -/
theorem admit_evicts_exactly_min (cap d m : Nat) (t : List Nat)
    (hd : d ∉ m :: t) (hS : Sorted (m :: t)) (hcap : (m :: t).length = cap)
    (hlt : m < d) (hnd : m ∉ t) :
    (admit cap d (m :: t)).length = cap
    ∧ (∀ x ∈ m :: t, m ≤ x)
    ∧ m ∉ admit cap d (m :: t) := by
  have hd' : d ∉ t := fun hmem => hd (by simp [hmem])
  have hlen : t.length + 1 = cap := by simpa using hcap
  have hres : admit cap d (m :: t) = ins d t := by
    unfold admit
    rw [if_neg hd,
        if_neg (show ¬((m :: t).length < cap) from by omega),
        if_neg (show ¬(m :: t = []) from by simp),
        show (m :: t).headD 0 = m from rfl,
        if_pos hlt,
        show (m :: t).tail = t from rfl]
  refine ⟨?_, ?_, ?_⟩
  · rw [hres, ins_length_of_notMem t d hd']
    omega
  · intro x hx
    rcases List.mem_cons.1 hx with rfl | hx'
    · omega
    · exact head_le t m hS x hx'
  · rw [hres]
    intro hmem
    rcases (mem_ins d m t).1 hmem with h' | h'
    · exact hnd h'
    · omega

/-! ## One-way conservation: decode admits `sum_out >= sum_in`

The strata-net mempool shadow checks one direction only: a decode whose output
sum is at least its input sum is admitted. Inflation therefore passes the
shadow **by design** — this is a one-way law, not a conservation gate. -/

/-- The decode admission predicate (the mempool shadow check). -/
def DecodeAdmitted (sumIn sumOut : Nat) : Prop :=
  sumIn ≤ sumOut

/-- **The exact one-way law.** Decode admits whenever `sum_out >= sum_in`. -/
theorem decode_admits_sum_out_ge_sum_in :
    ∀ (sumIn sumOut : Nat), sumOut ≥ sumIn → DecodeAdmitted sumIn sumOut :=
  fun _ _ h => h

/-- Honest negative (PN64 t02 pattern): inflation IS admitted — a decode with
input sum 2 and output sum 5 passes the shadow. The shadow is not a
conservation gate. -/
theorem inflation_admitted : DecodeAdmitted 2 5 := by
  unfold DecodeAdmitted; omega

/-- The one direction the shadow does enforce: deflation is refused. -/
theorem deflation_refused : ¬ DecodeAdmitted 5 2 := by
  intro h
  unfold DecodeAdmitted at h
  omega

/-- End-to-end mempool witness of the honest negative: a full pool of capacity 3
admitting digests `[5, 5, 5]` stays within capacity while the decode's inflated
shadow (`sum_out = 15` from `sum_in = 2`) is admitted. -/
theorem inflation_passes_mempool_shadow :
    ([5, 5, 5].foldl (fun acc d => admit 3 d acc) ([] : List Nat)).length ≤ 3
    ∧ DecodeAdmitted 2 15 := by
  exact ⟨mempool_capacity 3 [5, 5, 5] [] (by simp),
    decode_admits_sum_out_ge_sum_in 2 15 (by omega)⟩

#print axioms ProcInt.StrataNet.limRun_le_budget
#print axioms ProcInt.StrataNet.mempool_capacity
#print axioms ProcInt.StrataNet.admit_evicts_exactly_min
#print axioms ProcInt.StrataNet.decode_admits_sum_out_ge_sum_in
#print axioms ProcInt.StrataNet.inflation_admitted

end ProcInt.StrataNet
