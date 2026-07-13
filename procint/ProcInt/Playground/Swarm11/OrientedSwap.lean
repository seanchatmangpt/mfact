-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11.NewmanCorrespondence

/-!
# Problem P22 — Orientation for Newman's Lemma on the Swap Relation

`NewmanCorrespondence.lean`'s closing summary (§8) leaves Problem P17 `BLOCKED`: the raw `Swap`
relation is never `Terminating` (any commuting pair gives a two-cycle via `Swap.symm`), so
Newman's Lemma (`Relation.LocallyConfluent.Terminating_toConfluent`) never applies to it. That
summary names a precise candidate fix, filed there as Problem P22: break `Swap`'s symmetry with a
priority function on `Event`, restricting the relation to fire only when the transposition
strictly decreases the number of priority-inversions. This file constructs that relation,
`OrientedSwap`, and works through as much of the Newman's-Lemma correspondence as constructs
cleanly.

## Theorem card

* **Object.** `OrientedSwap step priority : List Event → List Event → Prop`, `Swap` restricted to
  only the transpositions that strictly decrease `invCount priority`.
* **Imported theorem.** `Relation.LocallyConfluent.Terminating_toConfluent`
  (`Cslib/Foundations/Relation/Confluence.lean`), same as `NewmanCorrespondence.lean`.
* **Source hypotheses.** `LocallyConfluent (OrientedSwap step priority)` and
  `Terminating (OrientedSwap step priority)`.
* **Correspondence map.** Identity, as in `NewmanCorrespondence.lean`: `OrientedSwap step priority`
  is fed directly as `cslib`'s abstract `r`.
* **Preserved structure.** `Terminating` — proven unconditionally below
  (`orientedSwap_terminating`), via strict well-founded descent on `invCount priority`.
  `LocallyConfluent` — **refuted** unconditionally below (`not_orientedSwap_locallyConfluent`);
  a genuine three-event counterexample exhibits two `OrientedSwap` steps out of a common source
  whose targets are both `OrientedSwap`-normal and distinct, so no join exists. A named, proven,
  *conditional* replacement (`orientedSwap_overlap_confluent_of_commute13`) identifies exactly the
  missing hypothesis: a third `Commute` witness across the two swapped pairs' outer events, closing
  the same "flagged risk" (a `StronglyCommutingTriple`-shaped condition) that the task brief for
  the unoriented `Swap` relation anticipated and that turned out unnecessary there
  (`NewmanCorrespondence.lean` §5). It resurfaces here, for real, because orientation removes the
  symmetric detour (`b → a → c` via reversing the first swap) that let the unoriented proof avoid
  ever comparing the two outer events.
* **Conclusion (target).** `Confluent (OrientedSwap step priority)`, hence a corresponding
  `orientedSwap_replay_eq_of_confluent`. **Not reached** — see the closing summary.
* **Standing.** `PARTIAL`. `Terminating` and disjoint-site local confluence are `PROVEN`
  unconditionally. Overlap-site local confluence is `REFUTED` unconditionally and `PROVEN`
  conditionally (given the missing third `Commute` witness). `Confluent` and the replay
  correspondence are correctly not attempted: they require the unconditional `LocallyConfluent`,
  which does not hold.
-/

namespace ProcInt.Playground.Swarm11

namespace Replay

/-!
## 1. Inversion count

`invCount priority trace` counts ordered pairs `(i, j)` with `i < j` in `trace` whose priorities
are *inverted* relative to `priority`-ascending order: the earlier event has strictly greater
priority than a later one. This is the classical bubble-sort potential: an adjacent transposition
that moves the lower-priority event earlier strictly decreases it (§3 below,
`invCount_swap_lt`), giving `OrientedSwap` its termination measure (§4, `orientedSwap_terminating`).

No ready-made list-inversion-count exists in Mathlib or Lean core at this pin (confirmed by
search); `List.countP_append`/`List.countP_cons` (Lean core, `Init/Data/List/Count.lean`) are the
building blocks, hand-assembled here.
-/

/--
Number of priority-inversions in `trace`: for each event, how many later events in the list have
strictly smaller `priority`, summed over all positions.

Carrier: finite event traces, any `priority : Event → ℕ`.
Falsifier: an adjacent transposition that does *not* strictly decrease this count relative to the
transposed pair's own priority order.
-/
def invCount {Event : Type} (priority : Event → ℕ) : List Event → ℕ
  | [] => 0
  | a :: rest => rest.countP (fun b => decide (priority b < priority a)) + invCount priority rest

@[simp]
theorem invCount_nil {Event : Type} (priority : Event → ℕ) :
    invCount priority ([] : List Event) = 0 := rfl

theorem invCount_cons {Event : Type} (priority : Event → ℕ) (a : Event) (rest : List Event) :
    invCount priority (a :: rest) =
      rest.countP (fun b => decide (priority b < priority a)) + invCount priority rest := rfl

/-!
## 2. `OrientedSwap`: `Swap` restricted to priority-decreasing transpositions

Exactly `Swap`'s constructor (`NewmanCorrespondence.lean` §1), with one extra admission: the pair
being transposed must already be priority-inverted (`priority right < priority left`), so firing
the swap moves the lower-priority event strictly earlier.
-/

/--
One admitted adjacent commuting swap that additionally strictly decreases priority-inversions:
`Swap` restricted to the orientation `NewmanCorrespondence.lean`'s closing summary names as the
candidate fix for Problem P22.

Carrier: event traces at any list position.
Admission: `Commute step left right` (as `Swap`) *and* `priority right < priority left`.
Excludes: the "wrong-direction" half of every commuting pair — `OrientedSwap`, unlike `Swap`, is
not symmetric.
-/
inductive OrientedSwap {Event State : Type}
    (step : Event → State → State) (priority : Event → ℕ) :
    List Event → List Event → Prop where
  | intro
      (leading suffix : List Event)
      (left right : Event)
      (hCommute : Commute step left right)
      (hPrio : priority right < priority left) :
      OrientedSwap step priority
        (leading ++ left :: right :: suffix)
        (leading ++ right :: left :: suffix)

/--
Non-dependent inversion for `OrientedSwap`, in the same safe (`Exists`-bound) shape as `Swap.inv`
(`NewmanCorrespondence.lean` §4) — needed for exactly the same reason: a call site's source list is
already a compound expression, and `cases` there would unify the constructor's pattern variables
against that fixed decomposition rather than leaving a second, independent witness's window free.
-/
theorem OrientedSwap.inv {Event State : Type} {step : Event → State → State}
    {priority : Event → ℕ} {a b : List Event}
    (h : OrientedSwap step priority a b) :
    ∃ leading suffix left right,
      Commute step left right ∧
      priority right < priority left ∧
      a = leading ++ left :: right :: suffix ∧
      b = leading ++ right :: left :: suffix := by
  cases h with
  | intro leading suffix left right hCommute hPrio =>
      exact ⟨leading, suffix, left, right, hCommute, hPrio, rfl, rfl⟩

/--
Forgetful map from `OrientedSwap` to `Swap`: every oriented swap is in particular a swap. Lets
downstream proofs reuse `Swap`'s lemmas (e.g. `replay_adjacent_swap_of_commute` via `Swap.inv`)
without reproving them for the restricted relation.

Standing: `PROVEN`.
-/
theorem orientedSwap_le_swap {Event State : Type} {step : Event → State → State}
    {priority : Event → ℕ} {a b : List Event}
    (h : OrientedSwap step priority a b) :
    Swap step a b := by
  cases h with
  | intro leading suffix left right hCommute _hPrio =>
      exact Swap.intro leading suffix left right hCommute

/-!
## 3. An oriented swap strictly decreases `invCount`

The base case (`leading = []`) does the real work: swapping an inverted adjacent pair
`(left, right)` removes exactly that one inversion and leaves every other pairing's contribution
untouched (each `suffix` event's relation to `left`/`right` is counted once either way; the
`Commute`d pair itself flips from contributing `1` to contributing `0`, since `priority right <
priority left` rules out the reverse inequality). The inductive step (`leading = x :: leadingRest`)
peels off one more leading event; its own contribution is invariant under swapping two elements
strictly after it (`List.Perm.swap` composed with `List.Perm.countP_eq` — reordering elements
after `x` cannot change how many of them satisfy a fixed predicate), and the remaining sum decreases
by the induction hypothesis.
-/

/--
Swapping a priority-inverted adjacent pair strictly decreases the trace's inversion count.

Standing: `PROVEN`.
-/
theorem invCount_swap_lt {Event : Type} (priority : Event → ℕ)
    (leading suffix : List Event) (left right : Event)
    (hPrio : priority right < priority left) :
    invCount priority (leading ++ right :: left :: suffix) <
      invCount priority (leading ++ left :: right :: suffix) := by
  induction leading with
  | nil =>
      have hR : (right :: suffix).countP (fun b => decide (priority b < priority left))
          = suffix.countP (fun b => decide (priority b < priority left)) + 1 :=
        List.countP_cons_of_pos (by simpa using hPrio)
      have hL : (left :: suffix).countP (fun b => decide (priority b < priority right))
          = suffix.countP (fun b => decide (priority b < priority right)) :=
        List.countP_cons_of_neg (by simpa using Nat.lt_asymm hPrio)
      simp only [List.nil_append, invCount_cons, hR, hL]
      omega
  | cons x leadingRest ih =>
      have hperm :
          (leadingRest ++ right :: left :: suffix).countP
              (fun b => decide (priority b < priority x)) =
            (leadingRest ++ left :: right :: suffix).countP
              (fun b => decide (priority b < priority x)) :=
        List.Perm.countP_eq _ (List.Perm.append_left leadingRest (List.Perm.swap left right suffix))
      simp only [List.cons_append, invCount_cons]
      omega

/--
Every `OrientedSwap` step strictly decreases `invCount priority`. Glues `invCount_swap_lt` (stated
in tiled `leading ++ … ++ suffix` form) to the constructor via `OrientedSwap.inv`.

Standing: `PROVEN`.
-/
theorem invCount_lt_of_orientedSwap {Event State : Type} {step : Event → State → State}
    {priority : Event → ℕ} {a b : List Event}
    (h : OrientedSwap step priority a b) :
    invCount priority b < invCount priority a := by
  obtain ⟨leading, suffix, left, right, _hCommute, hPrio, ha, hb⟩ := h.inv
  subst ha; subst hb
  exact invCount_swap_lt priority leading suffix left right hPrio

/-!
## 4. `Terminating (OrientedSwap step priority)`, unconditionally

`Terminating r := WellFounded (fun a b => r b a)` (`cslib`). `invCount_lt_of_orientedSwap` makes
`fun a b => OrientedSwap step priority b a` a `Subrelation` of `InvImage (· < ·) (invCount
priority)`, which is well-founded because `Nat.lt` is (`Nat.lt_wfRel.wf`, Lean core). This is the
one hypothesis of Newman's Lemma that was refuted for the raw `Swap` relation
(`NewmanCorrespondence.lean` §2); orientation repairs exactly this hypothesis.
-/

/--
`OrientedSwap step priority` is terminating, for every `step` and `priority`: strict descent along
`invCount priority`, pulled back to well-foundedness of `Nat.lt` via `InvImage.wf` and squeezed
through `Subrelation.wf`.

Standing: `PROVEN`. This is the hypothesis `not_terminating_swap_constUnit`
(`NewmanCorrespondence.lean` §2) refuted for the raw `Swap` relation — repaired here by
orientation, exactly as that file's closing summary anticipated.
-/
theorem orientedSwap_terminating {Event State : Type}
    (step : Event → State → State) (priority : Event → ℕ) :
    Relation.Terminating (OrientedSwap step priority) := by
  apply Subrelation.wf (r := InvImage (· < ·) (invCount priority))
  · intro a b hab
    exact invCount_lt_of_orientedSwap hab
  · exact InvImage.wf (invCount priority) Nat.lt_wfRel.wf

/-!
## 5. Local confluence at disjoint sites, unconditionally

Ports `swap_disjoint_confluent` (`NewmanCorrespondence.lean` §3) directly: each of the two swap
sites keeps its own independent `Commute`/priority witness, untouched by the other site's
transposition, so both application orders reach the same four-part rearrangement exactly as in the
unoriented case.
-/

/--
Disjoint-position local confluence for `OrientedSwap`, exhibited in the same tiled form as
`swap_disjoint_confluent`. Each site's priority admission (`hPrio1`, `hPrio2`) is carried through
unchanged, since neither swap's window overlaps the other's.

Standing: `PROVEN`.
-/
theorem orientedSwap_disjoint_confluent
    {Event State : Type} (step : Event → State → State) (priority : Event → ℕ)
    (leading mid suffix : List Event)
    (left1 right1 left2 right2 : Event)
    (hCommute1 : Commute step left1 right1)
    (hCommute2 : Commute step left2 right2)
    (hPrio1 : priority right1 < priority left1)
    (hPrio2 : priority right2 < priority left2) :
    ∃ d,
      OrientedSwap step priority
        (leading ++ right1 :: left1 :: mid ++ left2 :: right2 :: suffix) d ∧
      OrientedSwap step priority
        (leading ++ left1 :: right1 :: mid ++ right2 :: left2 :: suffix) d := by
  refine ⟨leading ++ right1 :: left1 :: mid ++ right2 :: left2 :: suffix, ?_, ?_⟩
  · have step1 :=
      OrientedSwap.intro (leading ++ right1 :: left1 :: mid) suffix left2 right2 hCommute2 hPrio2
    simpa [List.append_assoc, List.cons_append] using step1
  · have step2 :=
      OrientedSwap.intro leading (mid ++ right2 :: left2 :: suffix) left1 right1 hCommute1 hPrio1
    simpa [List.append_assoc, List.cons_append] using step2

/-!
## 6. Overlapping sites: the boundary this wave reaches

`swap_overlap_confluent` (`NewmanCorrespondence.lean` §5) closes the unoriented overlap case with
a two-step detour through the *unswapped* middle order `e1 :: e2 :: e3`: `e2 :: e1 :: e3 → e1 :: e2
:: e3 → e1 :: e3 :: e2`. Its first arrow reverses the very swap that produced the first branch —
for `OrientedSwap` that reversal needs `priority e1 < priority e2`, the *opposite* of what
produced that branch (`priority e2 < priority e1`), so it is never itself a legal `OrientedSwap`
step. Orientation removes the detour the unoriented proof relied on.

The two branches from a shared source `leading ++ e1 :: e2 :: e3 :: suffix` are:

* `b = leading ++ e2 :: e1 :: e3 :: suffix` (swapping `(e1, e2)`, licensed by `priority e2 <
  priority e1`)
* `c = leading ++ e1 :: e3 :: e2 :: suffix` (swapping `(e2, e3)`, licensed by `priority e3 <
  priority e2`)

Every `OrientedSwap` step usable from `b` or `c` fires on the pair `{e1, e2}` or `{e2, e3}` only —
`OrientedSwap`'s admission is a fact about the two *events*, not about list position, and no
witness for the pair `{e1, e3}` is anywhere in scope. §6a shows this is not a proof gap but a
genuine counterexample: with only the two given `Commute` witnesses, `b` and `c` can both be
`OrientedSwap`-normal (no legal step out of either) while still being distinct lists, so no join
exists — `LocallyConfluent (OrientedSwap step priority)` is **false** in general, refuted the same
way `NewmanCorrespondence.lean` §2 refuted `Terminating (Swap step)`: by an exhibited obstruction,
not merely an unproven goal. §6b then proves the natural repair: supplying the missing third
witness `Commute step e1 e3` (the `StronglyCommutingTriple`-shaped hypothesis the original task
brief for `Swap` flagged as a risk, and which resurfaces here) is exactly enough to reach the
priority-sorted triple `leading ++ e3 :: e2 :: e1 :: suffix` from both `b` and `c` in two oriented
steps each.
-/

/-!
### 6a. Refutation: `LocallyConfluent (OrientedSwap step priority)` is false in general

Concrete countermodel. Three events `A`, `B`, `C` with `priority A > priority B > priority C`
(`counterPriority`), and a `step` built from three permutations of a three-point state space
(`counterStep`): `A` and `B` both act as the identity-commuting pair via `B := id`; likewise `B`
and `C`. `A` and `C` are the two nontrivial transpositions `(0 1)` and `(1 2)` of `Fin 3`-shaped
`St3`, which do not commute (`counterNotCommuteAC`, witnessed at `s0`) — the standard fact that two
transpositions sharing one point need not commute.

From the shared source `[A, B, C]`, the two licensed `OrientedSwap` steps are
`intro [] [C] A B _ _ : [A,B,C] → [B,A,C]` and `intro [A] [] B C _ _ : [A,B,C] → [A,C,B]`. Both
targets are `OrientedSwap`-normal (`no_orientedSwap_of_triple`, applied twice): in `[B,A,C]`, pair
`(B,A)` fails the priority admission (already correctly oriented) and pair `(A,C)` fails the
`Commute` admission (`counterNotCommuteAC`); in `[A,C,B]`, pair `(A,C)` fails `Commute` again and
pair `(C,B)` fails priority. Two distinct `Relation.Normal` lists can only `ReflTransGen`-reach
themselves (`Relation.Normal.reflTransGen_eq`), so no common descendant exists.
-/

private inductive Ev3 : Type
  | A | B | C
  deriving DecidableEq

private inductive St3 : Type
  | s0 | s1 | s2
  deriving DecidableEq

/-- `A` transposes `s0`/`s1`; `B` is the identity; `C` transposes `s1`/`s2`. -/
private def counterStep : Ev3 → St3 → St3
  | Ev3.A, St3.s0 => St3.s1
  | Ev3.A, St3.s1 => St3.s0
  | Ev3.A, St3.s2 => St3.s2
  | Ev3.B, s => s
  | Ev3.C, St3.s0 => St3.s0
  | Ev3.C, St3.s1 => St3.s2
  | Ev3.C, St3.s2 => St3.s1

private def counterPriority : Ev3 → ℕ
  | Ev3.A => 2
  | Ev3.B => 1
  | Ev3.C => 0

private theorem counterCommuteAB : Commute counterStep Ev3.A Ev3.B := by
  intro state; cases state <;> rfl

private theorem counterCommuteBC : Commute counterStep Ev3.B Ev3.C := by
  intro state; cases state <;> rfl

private theorem counterNotCommuteAC : ¬ Commute counterStep Ev3.A Ev3.C := by
  intro h
  have hwitness := h St3.s0
  simp [counterStep] at hwitness

/--
No `OrientedSwap step priority` step fires on a fixed three-element window `[x, y, z]` when the
front pair `(x, y)` fails its admission (`Commute step x y ∧ priority y < priority x`) and the
back pair `(y, z)` fails its own (`Commute step y z ∧ priority z < priority y`). Every window
`OrientedSwap.inv` can produce from a three-element list is one of exactly these two (any `leading`
of length `≥ 2` overruns the list).
-/
private theorem no_orientedSwap_of_triple
    {Event State : Type} {step : Event → State → State} {priority : Event → ℕ}
    {x y z : Event}
    (h01 : ¬ (Commute step x y ∧ priority y < priority x))
    (h12 : ¬ (Commute step y z ∧ priority z < priority y)) :
    Relation.Normal (OrientedSwap step priority) [x, y, z] := by
  rintro ⟨w, hw⟩
  obtain ⟨leading, suffix, left, right, hCommute, hPrio, heq, -⟩ := hw.inv
  rcases leading with _ | ⟨a, _ | ⟨b, rest⟩⟩
  · simp only [List.nil_append, List.cons.injEq] at heq
    obtain ⟨hxl, hyr, -⟩ := heq
    exact h01 ⟨hxl ▸ hyr ▸ hCommute, hxl ▸ hyr ▸ hPrio⟩
  · simp only [List.cons_append, List.nil_append, List.cons.injEq] at heq
    obtain ⟨-, hyl, hzr, -⟩ := heq
    exact h12 ⟨hyl ▸ hzr ▸ hCommute, hyl ▸ hzr ▸ hPrio⟩
  · have hlen := congrArg List.length heq
    simp only [List.length_cons, List.length_nil, List.length_append] at hlen
    omega

/--
`LocallyConfluent (OrientedSwap step priority)` fails in general: `counterStep`/`counterPriority`
give two `OrientedSwap` steps out of the shared source `[A, B, C]` whose targets `[B, A, C]` and
`[A, C, B]` are both normal and distinct, so no `Join (ReflTransGen …)` exists between them.

Standing: `PROVEN` (as a refutation). This is the corrected content of Problem P22's overlap-case
risk: not an unmet proof obligation, but a genuine missing hypothesis, named precisely in
`orientedSwap_overlap_confluent_of_commute13` below.
-/
theorem not_orientedSwap_locallyConfluent :
    ∃ (step : Ev3 → St3 → St3) (priority : Ev3 → ℕ),
      ¬ Relation.LocallyConfluent (OrientedSwap step priority) := by
  refine ⟨counterStep, counterPriority, ?_⟩
  intro hlc
  have hab : OrientedSwap counterStep counterPriority
      [Ev3.A, Ev3.B, Ev3.C] [Ev3.B, Ev3.A, Ev3.C] :=
    OrientedSwap.intro [] [Ev3.C] Ev3.A Ev3.B counterCommuteAB (by decide)
  have hac : OrientedSwap counterStep counterPriority
      [Ev3.A, Ev3.B, Ev3.C] [Ev3.A, Ev3.C, Ev3.B] :=
    OrientedSwap.intro [Ev3.A] [] Ev3.B Ev3.C counterCommuteBC (by decide)
  have hNormalB : Relation.Normal (OrientedSwap counterStep counterPriority)
      [Ev3.B, Ev3.A, Ev3.C] :=
    no_orientedSwap_of_triple
      (fun ⟨_, hPrio⟩ => absurd hPrio (by decide))
      (fun ⟨hCommute, _⟩ => counterNotCommuteAC hCommute)
  have hNormalC : Relation.Normal (OrientedSwap counterStep counterPriority)
      [Ev3.A, Ev3.C, Ev3.B] :=
    no_orientedSwap_of_triple
      (fun ⟨hCommute, _⟩ => counterNotCommuteAC hCommute)
      (fun ⟨_, hPrio⟩ => absurd hPrio (by decide))
  obtain ⟨d, hbd, hcd⟩ := hlc hab hac
  have hbEq := Relation.Normal.reflTransGen_eq hNormalB hbd
  have hcEq := Relation.Normal.reflTransGen_eq hNormalC hcd
  exact absurd (hbEq.trans hcEq.symm) (by decide)

/-!
### 6b. The exact repair: a third `Commute` witness suffices

With `Commute step e1 e3` in hand as well, both branches reach the priority-sorted triple
`leading ++ e3 :: e2 :: e1 :: suffix` in two oriented steps: `b` fires `(e1, e3)` (licensed by
`priority e3 < priority e1`, from transitivity) then `(e2, e3)`; `c` fires `(e1, e3)` then
`(e1, e2)`. Neither path ever reuses a step in the wrong direction.
-/

/--
Overlapping `OrientedSwap` sites join, *given* the third `Commute` witness across the two swapped
pairs' outer events. This is the exact hypothesis `not_orientedSwap_locallyConfluent` shows is
missing from the unconditional statement — a `StronglyCommutingTriple`-shaped closure condition,
named precisely rather than left implicit.

Standing: `PROVEN` (as a conditional). Not yet assembled into a full `LocallyConfluent` instance:
doing so would require this extra hypothesis for *every* triple of mutually-adjacent-reachable
events, i.e. a global coherence condition on `step`, which is new scope beyond this wave (see the
closing summary).
-/
theorem orientedSwap_overlap_confluent_of_commute13
    {Event State : Type} (step : Event → State → State) (priority : Event → ℕ)
    (leading suffix : List Event)
    (e1 e2 e3 : Event)
    (hCommute12 : Commute step e1 e2)
    (hCommute23 : Commute step e2 e3)
    (hCommute13 : Commute step e1 e3)
    (hPrio12 : priority e2 < priority e1)
    (hPrio23 : priority e3 < priority e2) :
    Relation.ReflTransGen (OrientedSwap step priority)
        (leading ++ e2 :: e1 :: e3 :: suffix) (leading ++ e3 :: e2 :: e1 :: suffix) ∧
    Relation.ReflTransGen (OrientedSwap step priority)
        (leading ++ e1 :: e3 :: e2 :: suffix) (leading ++ e3 :: e2 :: e1 :: suffix) := by
  have hPrio13 : priority e3 < priority e1 := lt_trans hPrio23 hPrio12
  constructor
  · have step1 :
        OrientedSwap step priority
          (leading ++ e2 :: e1 :: e3 :: suffix) (leading ++ e2 :: e3 :: e1 :: suffix) := by
      have raw := OrientedSwap.intro (leading ++ [e2]) suffix e1 e3 hCommute13 hPrio13
      simpa [List.append_assoc] using raw
    have step2 :
        OrientedSwap step priority
          (leading ++ e2 :: e3 :: e1 :: suffix) (leading ++ e3 :: e2 :: e1 :: suffix) := by
      have raw := OrientedSwap.intro leading (e1 :: suffix) e2 e3 hCommute23 hPrio23
      simpa [List.append_assoc] using raw
    exact Relation.ReflTransGen.head step1 (Relation.ReflTransGen.single step2)
  · have step1 :
        OrientedSwap step priority
          (leading ++ e1 :: e3 :: e2 :: suffix) (leading ++ e3 :: e1 :: e2 :: suffix) := by
      have raw := OrientedSwap.intro leading (e2 :: suffix) e1 e3 hCommute13 hPrio13
      simpa [List.append_assoc] using raw
    have step2 :
        OrientedSwap step priority
          (leading ++ e3 :: e1 :: e2 :: suffix) (leading ++ e3 :: e2 :: e1 :: suffix) := by
      have raw := OrientedSwap.intro (leading ++ [e3]) suffix e1 e2 hCommute12 hPrio12
      simpa [List.append_assoc] using raw
    exact Relation.ReflTransGen.head step1 (Relation.ReflTransGen.single step2)

/-!
## 7. Closing summary — standing, and what remains for Problem P22

**Proven, unconditionally, kernel-checked (`propext`/`Quot.sound`/`Classical.choice` only, no
`sorry`):**

* `invCount`, `invCount_swap_lt`, `invCount_lt_of_orientedSwap` — the hand-rolled inversion-count
  potential (no ready-made version exists in Mathlib/Lean core at this pin) and its strict
  decrease under an oriented swap.
* `orientedSwap_terminating` — `Terminating (OrientedSwap step priority)`, for every `step` and
  `priority`. This repairs, by construction, the exact hypothesis
  `not_terminating_swap_constUnit` (`NewmanCorrespondence.lean` §2) refuted for raw `Swap`.
* `orientedSwap_disjoint_confluent` — disjoint-site local confluence, ported directly from
  `swap_disjoint_confluent`.
* `not_orientedSwap_locallyConfluent` — `LocallyConfluent (OrientedSwap step priority)` is **false**
  in general (refuted by an exhibited three-event, three-state countermodel), not merely unproven.
* `orientedSwap_overlap_confluent_of_commute13` — the precise conditional repair: given the third
  `Commute` witness the unconditional statement is missing, overlapping sites join in two oriented
  steps each, onto the priority-sorted triple.

**Not proven, and not falsely claimed:** `Relation.LocallyConfluent (OrientedSwap step priority)`
unconditionally, and therefore `Relation.Confluent (OrientedSwap step priority)` and the
corresponding replay correspondence (`swap_replay_eq_of_confluent`'s `OrientedSwap` analogue). The
task's own conditional structure ("if #7 closes, assemble #8") is honored by *not* attempting #8:
§6a shows #7 does not close in the form asked for, so forcing #8 on top of it would be building on
a false premise.

**Correction to Problem P22's own framing.** `NewmanCorrespondence.lean`'s closing summary named
the overlap case as needing "re-checking against the orientation constraint at each step" without
predicting whether it would close. It does not close unconditionally, for a structural reason
parallel to (but distinct from) `Swap`'s own non-termination: `Swap`'s failure was symmetry
admitting a two-cycle; `OrientedSwap`'s overlap failure is that orientation removes the one
detour (`b → a → c` through the *unswapped* order) that let `swap_overlap_confluent` avoid ever
needing a `Commute` witness for the two outer, non-adjacent events. Naming the missing hypothesis
precisely — `Commute step e1 e3` for every mutually-adjacent-reachable triple `(e1, e2, e3)`, i.e.
a `StronglyCommutingTriple`-shaped global coherence condition on `step` — is new work, not
attempted here: it would need threading through cslib's `LocallyConfluent` obligation for
*arbitrary* `a b c` (not just the one three-event shape `orientedSwap_overlap_confluent_of_commute13`
proves), which is a different, larger construction than this wave's scope.
-/

end Replay

end ProcInt.Playground.Swarm11
