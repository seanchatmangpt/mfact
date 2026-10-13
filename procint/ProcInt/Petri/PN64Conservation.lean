-- Hand-authored construction lane (T1, innovation Tier-1 X7 candidate 1).
-- Pattern follows the ggen-rendered ProcInt/Petri modules ("ggen renders; Lean admits");
-- this module is deliberately core-Lean-only (no Mathlib import) so that admission is a
-- fast, hermetic `lake build` even in workspaces without a prebuilt Mathlib.
--
-- Core-Lean-only: no imports (the procint Mathlib checkout is source-only here).

/-! # ProcInt.Petri.PN64Conservation

PN64 mask-table conservation (strata-pn64-pack, six canonical RONR transitions t01-t06).

The PN64 fire law is `m' = (m ^ pre) | post` on the 16-bit RONR state word with
place masks taken verbatim from `packs/strata-pn64-pack/ontology.ttl`.

Results:

1. **Weighted P-invariant conservation (Murata Theorem 15 shape).** The weighting
   `w = (2, 2, 1, 1, 1, 1, 0, 2, 0)` over the nine RONR places
   (MAIN_MOTION, STATED, SECONDED, DEBATABLE, AMENDMENT_PENDING,
   PREV_QUESTION_MOVED, PREV_QUESTION_ORDERED, FLOOR, ADOPTED) satisfies
   `⟪w, m'⟫ = ⟪w, m⟫` for every enabled *fresh* firing — one where the
   places gained (`post \ pre`) are empty beforehand. Proved per transition
   (t01-t06) and composed along the full canonical firing sequence
   t01 → t02 → t03 → t04 → t05 → t06 from `0x0081` to `0x01C1`.

2. **Honest negative result (unweighted).** The naive token count is NOT
   conserved: t02 and t05 strictly increase it (counterexamples proved).

3. **Honest negative result (unconditioned weighted).** Under the idempotent
   PN64 fire law `(m ^ pre) | post`, conservation fails for enabled-but-not-fresh
   firings: if a place in `post \ pre` is already set, firing destroys the pre
   tokens without producing the compensating post tokens. t01 exhibits this at
   `m = 0x0083`: the weighted sum drops 6 → 4. Conservation is a law of fresh
   firings (and hence of the canonical run), not of enabledness alone.
-/

namespace ProcInt.PN64

/-! ## The PN64 fire law and the six canonical RONR transitions -/

/-- PN64 fire law: `m' = (m ^ pre) | post` (strata-pn64-pack ontology.ttl). -/
def Fire (pre post m : Nat) : Nat :=
  (m ^^^ pre) ||| post

/-- Enabledness: the pre mask must be fully present, `(m & pre) = pre`. -/
def Enabled (pre m : Nat) : Prop :=
  m &&& pre = pre

/-- Freshness: the places gained by the transition (`post \ pre`) are empty.
A *fresh* firing consumes exactly `pre` and produces exactly `post`. -/
def Fresh (pre post m : Nat) : Prop :=
  m &&& (post ^^^ pre ^^^ post) = 0

/-- t01 — move and state main motion (opcode 0x01): pre 0x0081, post 0x0082. -/
def t01 : Nat × Nat := (0x0081, 0x0082)

/-- t02 — second motion (opcode 0x02): pre 0x0002, post 0x000C. -/
def t02 : Nat × Nat := (0x0002, 0x000C)

/-- t03 — amend (opcode 0x03): pre 0x0008, post 0x0010. -/
def t03 : Nat × Nat := (0x0008, 0x0010)

/-- t04 — adopt amendment (opcode 0x04): pre 0x0010, post 0x0008. -/
def t04 : Nat × Nat := (0x0010, 0x0008)

/-- t05 — previous question (opcode 0x05): pre 0x0008, post 0x0060. -/
def t05 : Nat × Nat := (0x0008, 0x0060)

/-- t06 — adopt main motion (opcode 0x06): pre 0x0024, post 0x0101. -/
def t06 : Nat × Nat := (0x0024, 0x0101)

/-! ## Ground literal-bit facts (all `decide`-proved) -/

@[simp] theorem bit_129_0 : Nat.testBit 129 0 = true := by decide
@[simp] theorem bit_129_1 : Nat.testBit 129 1 = false := by decide
@[simp] theorem bit_129_2 : Nat.testBit 129 2 = false := by decide
@[simp] theorem bit_129_3 : Nat.testBit 129 3 = false := by decide
@[simp] theorem bit_129_4 : Nat.testBit 129 4 = false := by decide
@[simp] theorem bit_129_5 : Nat.testBit 129 5 = false := by decide
@[simp] theorem bit_129_6 : Nat.testBit 129 6 = false := by decide
@[simp] theorem bit_129_7 : Nat.testBit 129 7 = true := by decide
@[simp] theorem bit_129_8 : Nat.testBit 129 8 = false := by decide
@[simp] theorem bit_130_0 : Nat.testBit 130 0 = false := by decide
@[simp] theorem bit_130_1 : Nat.testBit 130 1 = true := by decide
@[simp] theorem bit_130_2 : Nat.testBit 130 2 = false := by decide
@[simp] theorem bit_130_3 : Nat.testBit 130 3 = false := by decide
@[simp] theorem bit_130_4 : Nat.testBit 130 4 = false := by decide
@[simp] theorem bit_130_5 : Nat.testBit 130 5 = false := by decide
@[simp] theorem bit_130_6 : Nat.testBit 130 6 = false := by decide
@[simp] theorem bit_130_7 : Nat.testBit 130 7 = true := by decide
@[simp] theorem bit_130_8 : Nat.testBit 130 8 = false := by decide
@[simp] theorem bit_2_0 : Nat.testBit 2 0 = false := by decide
@[simp] theorem bit_2_1 : Nat.testBit 2 1 = true := by decide
@[simp] theorem bit_2_2 : Nat.testBit 2 2 = false := by decide
@[simp] theorem bit_2_3 : Nat.testBit 2 3 = false := by decide
@[simp] theorem bit_2_4 : Nat.testBit 2 4 = false := by decide
@[simp] theorem bit_2_5 : Nat.testBit 2 5 = false := by decide
@[simp] theorem bit_2_6 : Nat.testBit 2 6 = false := by decide
@[simp] theorem bit_2_7 : Nat.testBit 2 7 = false := by decide
@[simp] theorem bit_2_8 : Nat.testBit 2 8 = false := by decide
@[simp] theorem bit_12_0 : Nat.testBit 12 0 = false := by decide
@[simp] theorem bit_12_1 : Nat.testBit 12 1 = false := by decide
@[simp] theorem bit_12_2 : Nat.testBit 12 2 = true := by decide
@[simp] theorem bit_12_3 : Nat.testBit 12 3 = true := by decide
@[simp] theorem bit_12_4 : Nat.testBit 12 4 = false := by decide
@[simp] theorem bit_12_5 : Nat.testBit 12 5 = false := by decide
@[simp] theorem bit_12_6 : Nat.testBit 12 6 = false := by decide
@[simp] theorem bit_12_7 : Nat.testBit 12 7 = false := by decide
@[simp] theorem bit_12_8 : Nat.testBit 12 8 = false := by decide
@[simp] theorem bit_8_0 : Nat.testBit 8 0 = false := by decide
@[simp] theorem bit_8_1 : Nat.testBit 8 1 = false := by decide
@[simp] theorem bit_8_2 : Nat.testBit 8 2 = false := by decide
@[simp] theorem bit_8_3 : Nat.testBit 8 3 = true := by decide
@[simp] theorem bit_8_4 : Nat.testBit 8 4 = false := by decide
@[simp] theorem bit_8_5 : Nat.testBit 8 5 = false := by decide
@[simp] theorem bit_8_6 : Nat.testBit 8 6 = false := by decide
@[simp] theorem bit_8_7 : Nat.testBit 8 7 = false := by decide
@[simp] theorem bit_8_8 : Nat.testBit 8 8 = false := by decide
@[simp] theorem bit_16_0 : Nat.testBit 16 0 = false := by decide
@[simp] theorem bit_16_1 : Nat.testBit 16 1 = false := by decide
@[simp] theorem bit_16_2 : Nat.testBit 16 2 = false := by decide
@[simp] theorem bit_16_3 : Nat.testBit 16 3 = false := by decide
@[simp] theorem bit_16_4 : Nat.testBit 16 4 = true := by decide
@[simp] theorem bit_16_5 : Nat.testBit 16 5 = false := by decide
@[simp] theorem bit_16_6 : Nat.testBit 16 6 = false := by decide
@[simp] theorem bit_16_7 : Nat.testBit 16 7 = false := by decide
@[simp] theorem bit_16_8 : Nat.testBit 16 8 = false := by decide
@[simp] theorem bit_96_0 : Nat.testBit 96 0 = false := by decide
@[simp] theorem bit_96_1 : Nat.testBit 96 1 = false := by decide
@[simp] theorem bit_96_2 : Nat.testBit 96 2 = false := by decide
@[simp] theorem bit_96_3 : Nat.testBit 96 3 = false := by decide
@[simp] theorem bit_96_4 : Nat.testBit 96 4 = false := by decide
@[simp] theorem bit_96_5 : Nat.testBit 96 5 = true := by decide
@[simp] theorem bit_96_6 : Nat.testBit 96 6 = true := by decide
@[simp] theorem bit_96_7 : Nat.testBit 96 7 = false := by decide
@[simp] theorem bit_96_8 : Nat.testBit 96 8 = false := by decide
@[simp] theorem bit_36_0 : Nat.testBit 36 0 = false := by decide
@[simp] theorem bit_36_1 : Nat.testBit 36 1 = false := by decide
@[simp] theorem bit_36_2 : Nat.testBit 36 2 = true := by decide
@[simp] theorem bit_36_3 : Nat.testBit 36 3 = false := by decide
@[simp] theorem bit_36_4 : Nat.testBit 36 4 = false := by decide
@[simp] theorem bit_36_5 : Nat.testBit 36 5 = true := by decide
@[simp] theorem bit_36_6 : Nat.testBit 36 6 = false := by decide
@[simp] theorem bit_36_7 : Nat.testBit 36 7 = false := by decide
@[simp] theorem bit_36_8 : Nat.testBit 36 8 = false := by decide
@[simp] theorem bit_257_0 : Nat.testBit 257 0 = true := by decide
@[simp] theorem bit_257_1 : Nat.testBit 257 1 = false := by decide
@[simp] theorem bit_257_2 : Nat.testBit 257 2 = false := by decide
@[simp] theorem bit_257_3 : Nat.testBit 257 3 = false := by decide
@[simp] theorem bit_257_4 : Nat.testBit 257 4 = false := by decide
@[simp] theorem bit_257_5 : Nat.testBit 257 5 = false := by decide
@[simp] theorem bit_257_6 : Nat.testBit 257 6 = false := by decide
@[simp] theorem bit_257_7 : Nat.testBit 257 7 = false := by decide
@[simp] theorem bit_257_8 : Nat.testBit 257 8 = true := by decide

/-! ## The P-invariant weighting -/

/-- Weighted token sum with weights w = (2,2,1,1,1,1,0,2,0) over the nine
RONR places at bit offsets 0-8 (strata-pn64-pack `st:bitOffset` values). -/
def wsum (m : Nat) : Nat :=
  (bif m.testBit 0 then 2 else 0) +
  (bif m.testBit 1 then 2 else 0) +
  (bif m.testBit 2 then 1 else 0) +
  (bif m.testBit 3 then 1 else 0) +
  (bif m.testBit 4 then 1 else 0) +
  (bif m.testBit 5 then 1 else 0) +
  (bif m.testBit 7 then 2 else 0)

/-- Unweighted token count over the nine places (the naive "token sum"). -/
def tokenSum (m : Nat) : Nat :=
  (bif m.testBit 0 then 1 else 0) +
  (bif m.testBit 1 then 1 else 0) +
  (bif m.testBit 2 then 1 else 0) +
  (bif m.testBit 3 then 1 else 0) +
  (bif m.testBit 4 then 1 else 0) +
  (bif m.testBit 5 then 1 else 0) +
  (bif m.testBit 6 then 1 else 0) +
  (bif m.testBit 7 then 1 else 0) +
  (bif m.testBit 8 then 1 else 0)

/-! ## Bit-extraction helpers -/

/-- If `m & c = c` then bit `i` of `m` is set whenever bit `i` of `c` is. -/
theorem testBit_of_and_eq {m c i : Nat} (h : m &&& c = c) (hc : c.testBit i = true) :
    m.testBit i = true := by
  have h' := congrArg (fun x => x.testBit i) h
  simpa [Nat.testBit_and, hc] using h'

/-- If `m & c = 0` then bit `i` of `m` is clear whenever bit `i` of `c` is. -/
theorem testBit_of_and_eq_zero {m c i : Nat} (h : m &&& c = 0) (hc : c.testBit i = true) :
    m.testBit i = false := by
  have h' := congrArg (fun x => x.testBit i) h
  simpa [Nat.testBit_and, hc] using h'

/-! ## Per-transition weighted conservation (fresh firings, Murata Thm 15 shape) -/

/-- t01 conserves the weighted sum on fresh firings: place MAIN_MOTION (weight 2)
is exchanged for STATED (weight 2); FLOOR (weight 2) is in pre ∩ post. -/
theorem t01_conserves (m : Nat) (h : m &&& 0x0081 = 0x0081) (hf : m &&& 0x0002 = 0) :
    wsum (Fire 0x0081 0x0082 m) = wsum m := by
  have b0 : m.testBit 0 = true := testBit_of_and_eq h (by decide)
  have b7 : m.testBit 7 = true := testBit_of_and_eq h (by decide)
  have f1 : m.testBit 1 = false := testBit_of_and_eq_zero hf (by decide)
  simp only [wsum, Fire, Nat.testBit_xor, Nat.testBit_or, b0, b7, f1]
  simp (config := { decide := true })

/-- t02 conserves the weighted sum on fresh firings: STATED (weight 2) is
exchanged for SECONDED + DEBATABLE (weights 1 + 1). -/
theorem t02_conserves (m : Nat) (h : m &&& 0x0002 = 0x0002) (hf : m &&& 0x000C = 0) :
    wsum (Fire 0x0002 0x000C m) = wsum m := by
  have b1 : m.testBit 1 = true := testBit_of_and_eq h (by decide)
  have f2 : m.testBit 2 = false := testBit_of_and_eq_zero hf (by decide)
  have f3 : m.testBit 3 = false := testBit_of_and_eq_zero hf (by decide)
  simp only [wsum, Fire, Nat.testBit_xor, Nat.testBit_or, b1, f2, f3]
  simp (config := { decide := true })

/-- t03 conserves the weighted sum on fresh firings: DEBATABLE (weight 1) for
AMENDMENT_PENDING (weight 1). -/
theorem t03_conserves (m : Nat) (h : m &&& 0x0008 = 0x0008) (hf : m &&& 0x0010 = 0) :
    wsum (Fire 0x0008 0x0010 m) = wsum m := by
  have b3 : m.testBit 3 = true := testBit_of_and_eq h (by decide)
  have f4 : m.testBit 4 = false := testBit_of_and_eq_zero hf (by decide)
  simp only [wsum, Fire, Nat.testBit_xor, Nat.testBit_or, b3, f4]
  simp (config := { decide := true })

/-- t04 conserves the weighted sum on fresh firings: AMENDMENT_PENDING (weight 1)
for DEBATABLE (weight 1). -/
theorem t04_conserves (m : Nat) (h : m &&& 0x0010 = 0x0010) (hf : m &&& 0x0008 = 0) :
    wsum (Fire 0x0010 0x0008 m) = wsum m := by
  have b4 : m.testBit 4 = true := testBit_of_and_eq h (by decide)
  have f3 : m.testBit 3 = false := testBit_of_and_eq_zero hf (by decide)
  simp only [wsum, Fire, Nat.testBit_xor, Nat.testBit_or, b4, f3]
  simp (config := { decide := true })

/-- t05 conserves the weighted sum on fresh firings: DEBATABLE (weight 1) for
PREV_QUESTION_MOVED (weight 1); PREV_QUESTION_ORDERED (bit 6) carries weight 0. -/
theorem t05_conserves (m : Nat) (h : m &&& 0x0008 = 0x0008) (hf : m &&& 0x0060 = 0) :
    wsum (Fire 0x0008 0x0060 m) = wsum m := by
  have b3 : m.testBit 3 = true := testBit_of_and_eq h (by decide)
  have f5 : m.testBit 5 = false := testBit_of_and_eq_zero hf (by decide)
  have f6 : m.testBit 6 = false := testBit_of_and_eq_zero hf (by decide)
  simp only [wsum, Fire, Nat.testBit_xor, Nat.testBit_or, b3, f5]
  simp (config := { decide := true })
  omega

/-- t06 conserves the weighted sum on fresh firings: SECONDED + PREV_QUESTION_MOVED
(weights 1 + 1) for MAIN_MOTION (weight 2); ADOPTED (bit 8) carries weight 0. -/
theorem t06_conserves (m : Nat) (h : m &&& 0x0024 = 0x0024) (hf : m &&& 0x0101 = 0) :
    wsum (Fire 0x0024 0x0101 m) = wsum m := by
  have b2 : m.testBit 2 = true := testBit_of_and_eq h (by decide)
  have b5 : m.testBit 5 = true := testBit_of_and_eq h (by decide)
  have f0 : m.testBit 0 = false := testBit_of_and_eq_zero hf (by decide)
  have f8 : m.testBit 8 = false := testBit_of_and_eq_zero hf (by decide)
  simp only [wsum, Fire, Nat.testBit_xor, Nat.testBit_or, b2, b5, f0]
  simp (config := { decide := true })
  omega

/-! ## The full canonical firing sequence t01 → t02 → t03 → t04 → t05 → t06 -/

/-- Initial marking of the canonical run: MAIN_MOTION | FLOOR. -/
def m0 : Nat := 0x0081

/-- After t01: STATED | FLOOR. -/
def m1 : Nat := Fire 0x0081 0x0082 0x0081

/-- After t02: SECONDED | DEBATABLE | FLOOR. -/
def m2 : Nat := Fire 0x0002 0x000C m1

/-- After t03: SECONDED | AMENDMENT_PENDING | FLOOR. -/
def m3 : Nat := Fire 0x0008 0x0010 m2

/-- After t04: SECONDED | DEBATABLE | FLOOR again. -/
def m4 : Nat := Fire 0x0010 0x0008 m3

/-- After t05: SECONDED | PREV_QUESTION_MOVED | PREV_QUESTION_ORDERED | FLOOR. -/
def m5 : Nat := Fire 0x0008 0x0060 m4

/-- After t06: MAIN_MOTION | ADOPTED | FLOOR = 0x01C1. -/
def m6 : Nat := Fire 0x0024 0x0101 m5

/-- The intermediate markings have the concrete values of the mask-table walk. -/
theorem m_values : m1 = 0x0082 ∧ m2 = 0x008C ∧ m3 = 0x0094 ∧ m4 = 0x008C ∧
    m5 = 0x00E4 ∧ m6 = 0x01C1 := by
  decide

/-- Each step of the canonical run is enabled at the marking produced by the
previous step. -/
theorem m_enabled :
    (m0 &&& 0x0081 = 0x0081) ∧ (m1 &&& 0x0002 = 0x0002) ∧ (m2 &&& 0x0008 = 0x0008) ∧
    (m3 &&& 0x0010 = 0x0010) ∧ (m4 &&& 0x0008 = 0x0008) ∧ (m5 &&& 0x0024 = 0x0024) := by
  decide

/-- Each step of the canonical run is fresh. -/
theorem m_fresh :
    (m0 &&& 0x0002 = 0) ∧ (m1 &&& 0x000C = 0) ∧ (m2 &&& 0x0010 = 0) ∧
    (m3 &&& 0x0008 = 0) ∧ (m4 &&& 0x0060 = 0) ∧ (m5 &&& 0x0101 = 0) := by
  decide

/-- **Main theorem.** The weighted token sum is conserved along the full canonical
firing sequence t01 → t02 → t03 → t04 → t05 → t06 from 0x0081 to 0x01C1
(Murata 1989, Theorem 15 for the PN64 mask table). -/
theorem pn64_sequence_conserves :
    wsum (Fire 0x0024 0x0101 (Fire 0x0008 0x0060 (Fire 0x0010 0x0008
      (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081)))))) =
    wsum 0x0081 := by
  calc wsum (Fire 0x0024 0x0101 (Fire 0x0008 0x0060 (Fire 0x0010 0x0008
      (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081)))))) =
      wsum (Fire 0x0008 0x0060 (Fire 0x0010 0x0008
      (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081))))) :=
        t06_conserves (m := Fire 0x0008 0x0060 (Fire 0x0010 0x0008
      (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081)))))
        (by decide) (by decide)
    _ = wsum (Fire 0x0010 0x0008
      (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081)))) :=
        t05_conserves (m := Fire 0x0010 0x0008
      (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081))))
        (by decide) (by decide)
    _ = wsum (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081))) :=
        t04_conserves (m := Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081)))
        (by decide) (by decide)
    _ = wsum (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081)) :=
        t03_conserves (m := Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081))
        (by decide) (by decide)
    _ = wsum (Fire 0x0081 0x0082 0x0081) :=
        t02_conserves (m := Fire 0x0081 0x0082 0x0081) (by decide) (by decide)
    _ = wsum 0x0081 := t01_conserves (m := 0x0081) (by decide) (by decide)

/-- The run genuinely progresses: the final marking differs from the initial one,
so the conservation is nontrivial (not a no-op identity). -/
theorem pn64_run_moves : m6 = 0x01C1 ∧ m0 = 0x0081 ∧ m6 ≠ m0 := by
  decide

/-- Even along the canonical run the naive token count is NOT conserved:
t05 adds the weight-0 place PREV_QUESTION_ORDERED and t06 adds ADOPTED, so the
count rises from 2 at m0 = 0x0081 to 4 at m6 = 0x01C1. -/
theorem pn64_sequence_tokenSum_increases :
    tokenSum m0 = 2 ∧ tokenSum m6 = 4 ∧ tokenSum m6 ≠ tokenSum m0 := by
  decide

/-! ## Honest negative result: the unweighted token sum is NOT conserved -/

/-- **Counterexample (t02).** Firing t02 at m = 0x0082 strictly increases the
unweighted token count from 2 to 3: one STATED token becomes SECONDED + DEBATABLE.
This is the falsifier for "PN64 conserves the naive token sum". -/
theorem t02_token_counterexample :
    tokenSum 0x0082 = 2 ∧
    tokenSum (Fire 0x0002 0x000C 0x0082) = 3 ∧
    tokenSum (Fire 0x0002 0x000C 0x0082) ≠ tokenSum 0x0082 := by
  refine ⟨rfl, rfl, by decide⟩

/-- **Counterexample (t05).** Firing t05 likewise increases the token count:
one DEBATABLE token becomes PREV_QUESTION_MOVED + PREV_QUESTION_ORDERED. -/
theorem t05_token_counterexample :
    tokenSum 0x008C = 3 ∧
    tokenSum (Fire 0x0008 0x0060 0x008C) = 4 ∧
    tokenSum (Fire 0x0008 0x0060 0x008C) ≠ tokenSum 0x008C := by
  refine ⟨rfl, rfl, by decide⟩

/-! ## Honest negative result: weighted conservation needs freshness -/

/-- **Counterexample (t01, non-fresh).** At `m = 0x0083` (MAIN_MOTION | STATED |
FLOOR — STATED already set), t01 is enabled but not fresh, and the weighted sum
DROPS from 6 to 4: firing destroys the already-set STATED token's weight without
producing a compensating token. This is the falsifier for "the weighting is
conserved by every enabled firing". -/
theorem t01_nonfresh_counterexample :
    (0x0083 &&& 0x0081 = 0x0081) ∧
    wsum (Fire 0x0081 0x0082 0x0083) = 4 ∧
    wsum 0x0083 = 6 ∧
    wsum (Fire 0x0081 0x0082 0x0083) ≠ wsum 0x0083 := by
  refine ⟨rfl, ?_, ?_, ?_⟩
  all_goals simp (config := { decide := true })
  all_goals omega


/-! ## Honest BLOCKED finding: the tabulated t04 masks do not implement the canonical run

The mask table (strata-pn64-pack ontology.ttl) tabulates t04 with pre 0x0008 and
post 0x0008. Under the PN64 fire law this pair is a no-op self-loop, and the
canonical RONR walk t01->t02->t03 leaves DEBATABLE (bit 3) clear, so the tabulated
t04 is not even enabled at m3. The sequence proofs above therefore use the
semantically corrected t04 masks pre 0x0010, post 0x0008 ("consume
AMENDMENT_PENDING, re-produce DEBATABLE"), which is what the transition's label
requires. Both facts are proved below.
-/

/-- This module carries the corrected t04 masks (pre 0x0010, post 0x0008);
ontology.ttl still tabulates (0x0008, 0x0008) — a divergence this finding records. -/
theorem t04_corrected_masks : t04 = (0x0010, 0x0008) := rfl

/-- The tabulated t04 is a self-loop: at any enabled marking (e.g. 0x008C) the
marking is reproduced exactly, so "adopt amendment" can never resolve
AMENDMENT_PENDING (bit 4 is never consumed). -/
theorem t04_tabulated_self_loop :
    Fire 0x0008 0x0008 0x008C = 0x008C := by
  decide

/-- Proved counterexample: after t01 -> t02 -> t03 the marking is 0x0094
(AMENDMENT_PENDING set, DEBATABLE clear), so the tabulated t04 is NOT enabled
there: the canonical run t01->t02->t03->t04->t05->t06 is not a legal firing
sequence of the mask table as written. This is a real defect in the mask table,
not in the fire law. -/
theorem t04_tabulated_not_enabled_at_m3 :
    (Fire 0x0008 0x0010 (Fire 0x0002 0x000C (Fire 0x0081 0x0082 0x0081))) &&& 0x0008 = 0 := by
  decide

end ProcInt.PN64
