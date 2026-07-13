-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Cslib.Foundations.Relation.Confluence
import ProcInt.Playground.Swarm11.Replay

/-!
# Newman's Lemma Correspondence for the Raw Adjacent-Swap Relation

`ROADMAP_SWARM_SUPPLY_CHAIN.md` Problem P17 asks for a correspondence from the swarm's
structural-independence swap relation into `cslib`'s
`LocallyConfluent.Terminating_toConfluent` (Newman's Lemma,
`Cslib/Foundations/Relation/Confluence.lean`), so that `ProcInt`'s existing
`replay_eq_of_traceEq` (`Replay.lean`, proven only for the *equivalence closure* `TraceEq` of
exhibited commuting swaps) can be generalized to the *raw* one-step swap relation `r`: any two
traces reachable from a common trace by valid commuting swaps, not just ones already connected by
a hand-built `TraceEq` derivation.

## Theorem card

* **Object.** `r := Swap step : List Event → List Event → Prop`, one adjacent transposition of a
  pair the caller has proved `Commute step`-related, at any list position.
* **Imported theorem.** `LocallyConfluent.Terminating_toConfluent`
  (`Cslib/Foundations/Relation/Confluence.lean`): `LocallyConfluent r → Terminating r → Confluent r`.
* **Source hypotheses.** `LocallyConfluent r` and `Terminating r`, both over the *same* `r`.
* **Correspondence map.** Identity: `r := Swap step` is fed directly as `cslib`'s abstract
  `r : α → α → Prop` with `α := List Event`. No further translation layer, unlike `κ_runtime` etc.
  in the Fence section of `ROADMAP_SWARM_SUPPLY_CHAIN.md`.
* **Preserved structure.** None yet admitted — see `not_terminating_of_swap` below.
* **Conclusion (target).** `Confluent (Swap step)`, hence (Wave S7 / T1) that every two traces
  reachable from a common trace by valid swaps replay identically.
* **Standing.** `BLOCKED_ON_HYPOTHESIS`. §2 below proves, for the raw `Swap` relation as specified,
  `Terminating (Swap step)` is **false** whenever a single nondegenerate commuting pair exists —
  not merely unproven, but refuted by an exhibited two-cycle. This is a correction to
  `ROADMAP_SWARM_SUPPLY_CHAIN.md`'s own framing of Problem P17 ("the more tractable half"): the
  obstruction is not `LocallyConfluent`'s overlapping case (as the roadmap's own warning
  anticipated) but `Terminating` itself, for a different, structural reason unrelated to C25's
  finite-order-ideal concern. See the closing summary for the precise correction filed against the
  ledger.
-/

namespace ProcInt.Playground.Swarm11

namespace Replay

/-!
## 1. The raw one-step swap relation

`Swap step a b` holds when `b` is obtained from `a` by swapping one adjacent pair of events that
the caller has proved `Commute step`-related, at any position in the list. This is exactly the
one-step relation whose equivalence closure `TraceEq` already carries as its `swap` constructor
(`Replay.lean`) — `Swap` is `TraceEq`'s generating relation, not its closure.
-/

/--
One admitted adjacent commuting swap, as a standalone one-step relation (not the equivalence
closure `TraceEq` already proves things about).

Carrier: event traces at any list position.
Admission: `Commute step left right`.
Excludes: reflexivity, symmetry, transitivity — those are `TraceEq`'s job, not `Swap`'s.
-/
inductive Swap {Event State : Type}
    (step : Event → State → State) :
    List Event → List Event → Prop where
  | intro
      (leading suffix : List Event)
      (left right : Event)
      (hCommute : Commute step left right) :
      Swap step
        (leading ++ left :: right :: suffix)
        (leading ++ right :: left :: suffix)

/--
`Swap` is symmetric: whenever a swap licenses `a → b`, the *same* commuting-pair witness (flipped
via `Commute.symm`, which holds unconditionally since `Commute step left right` and
`Commute step right left` are the same proposition up to `Eq.symm` in each pointwise instance)
licenses `b → a`. No `Commute step right left` side hypothesis needs to be separately supplied.
-/
theorem Swap.symm {Event State : Type}
    {step : Event → State → State}
    {a b : List Event}
    (h : Swap step a b) :
    Swap step b a := by
  cases h with
  | intro leading suffix left right hCommute =>
      exact Swap.intro leading suffix right left (fun state => (hCommute state).symm)

/-!
## 2. `Terminating (Swap step)` is false in general

`Terminating r := WellFounded (fun a b => r b a)` (`cslib`, `Cslib/Foundations/Relation/Defs.lean`)
is Lean/Mathlib's strong-normalization predicate: it holds iff `r` admits no infinite forward
chain `x₀ r x₁ r x₂ r ⋯`. A well-founded relation is in particular asymmetric
(`WellFounded.asymm`, `Mathlib/Order/WellFounded.lean`): `WellFounded R → (R a b → ¬ R b a)`.
Unfolding `Terminating` at `R := fun a b => r b a` gives: `Terminating r → (r a b → ¬ r b a)`.

`Swap.symm` above proves the *opposite*: `Swap step a b → Swap step b a`, unconditionally, for
every nondegenerate swap. So `Terminating (Swap step)` is refuted by any single witness with
`a ≠ b` (or even `a = b`, a self-loop) — not merely unproven, but false, by an explicit two-cycle.
This is a structural fact about the raw swap relation, independent of `Event`/`State`/`step`, and
independent of C25's finite-order-ideal concern (it holds even if `List Event` is restricted to a
finite set of permutations of one fixed reference trace).
-/

/--
Any relation admitting a two-cycle is not `Terminating` in `cslib`'s sense. General-purpose
lemma, stated once and reused, rather than reproving asymmetry ad hoc at each instance.
-/
theorem not_terminating_of_cycle
    {α : Type} {r : α → α → Prop} {a b : α}
    (hab : r a b) (hba : r b a) :
    ¬ Relation.Terminating r := by
  intro hterm
  exact hterm.asymm.asymm b a hab hba

/--
`Swap step` is never `Terminating`, for any `step` admitting a single nondegenerate commuting
pair. Concrete witness: `Event := Bool`, `State := Unit`, the constant `step`, where every pair
trivially commutes (`Commute` collapses to `∀ _, () = ()`), giving the genuine two-cycle
`[true, false] ↔ [false, true]`.

Standing: `PROVEN`. This refutes, for this concrete instantiation, the claim that a raw swap
relation (undirected: commuting pairs may be swapped in either direction from either underlying
`Commute` witness) can serve as `cslib`'s `r` for `LocallyConfluent.Terminating_toConfluent`
without further orientation. See the closing summary for the corrected Problem P17 statement.
-/
theorem not_terminating_swap_constUnit :
    ¬ Relation.Terminating (Swap (Event := Bool) (State := Unit) (fun _ _ => ())) := by
  have hCommute : Commute (Event := Bool) (State := Unit) (fun _ _ => ()) true false :=
    fun _ => rfl
  have hab : Swap (Event := Bool) (State := Unit) (fun _ _ => ()) [true, false] [false, true] :=
    Swap.intro [] [] true false hCommute
  exact not_terminating_of_cycle hab hab.symm

/-!
## 3. Local confluence at disjoint swap sites

Two swap sites are *disjoint* when they touch no common list position: one window occupies
positions `(i, i+1)`, the other `(j, j+1)`, with `j ≥ i + 2` (at least one untouched element, or
none, sits strictly between them — this is genuinely the "at least one untouched element"
disjointness the roadmap's warning describes, phrased as a nonnegative gap `mid`, `mid = []`
included). The tiling/interchange argument: applying either swap first does not disturb the
other window's two positions, so both application orders reach the same four-part rearrangement.
-/

/--
Disjoint-position local confluence, exhibited directly in tiled form (the swap sites are given
already-separated by a gap `mid`, rather than reconstructed from an equality hypothesis — see the
closing summary for what the general `LocallyConfluent (Swap step)` obligation additionally
needs). This is the "genuinely tractable" case named in the task brief.

Standing: `PROVEN`.
-/
theorem swap_disjoint_confluent
    {Event State : Type} (step : Event → State → State)
    (leading mid suffix : List Event)
    (left1 right1 left2 right2 : Event)
    (hCommute1 : Commute step left1 right1)
    (hCommute2 : Commute step left2 right2) :
    ∃ d,
      Swap step (leading ++ right1 :: left1 :: mid ++ left2 :: right2 :: suffix) d ∧
      Swap step (leading ++ left1 :: right1 :: mid ++ right2 :: left2 :: suffix) d := by
  refine ⟨leading ++ right1 :: left1 :: mid ++ right2 :: left2 :: suffix, ?_, ?_⟩
  · have step1 :=
      Swap.intro (leading ++ right1 :: left1 :: mid) suffix left2 right2 hCommute2
    simpa [List.append_assoc, List.cons_append] using step1
  · have step2 :=
      Swap.intro leading (mid ++ right2 :: left2 :: suffix) left1 right1 hCommute1
    simpa [List.append_assoc, List.cons_append] using step2

/-!
## 4. The general site-relationship trichotomy

To promote `swap_disjoint_confluent` from "a tiled instance" to an actual case of the
`LocallyConfluent (Swap step)` obligation `cslib` needs (universally quantified over `a b c` with
`Swap step a b` and `Swap step a c` as *given*, not chosen, hypotheses), the two swap-site
decompositions of the same list `a` must be reconciled. `List.append_eq_append_iff`
(`Init/Data/List/Lemmas.lean`, Lean core) supplies exactly the list-level case split needed;
splitting its witness list into `[]` / one element / two-or-more elements produces precisely the
same / overlap / disjoint trichotomy (doubled for which side is the shorter `leading`).
-/

/--
Every two decompositions of the same list into `leading ++ left :: right :: suffix` fall into
exactly one of five shapes: identical window, disjoint with a (possibly empty) gap on either
side, or overlapping by exactly one shared element on either side. The overlap conclusions name
the shared element precisely (`right1 = left2`, resp. `left1 = right2`) — this is the exact
"three mutually-adjacent events" shape referenced in the closing summary's `StronglyCommutingTriple`
discussion.

Standing: `PROVEN`.
-/
theorem swap_site_cases
    {Event : Type}
    (leading1 suffix1 leading2 suffix2 : List Event)
    (left1 right1 left2 right2 : Event)
    (hEq : leading1 ++ left1 :: right1 :: suffix1 = leading2 ++ left2 :: right2 :: suffix2) :
    (leading1 = leading2 ∧ left1 = left2 ∧ right1 = right2 ∧ suffix1 = suffix2) ∨
    (∃ mid, leading2 = leading1 ++ left1 :: right1 :: mid ∧
            suffix1 = mid ++ left2 :: right2 :: suffix2) ∨
    (leading2 = leading1 ++ [left1] ∧ right1 = left2 ∧ suffix1 = right2 :: suffix2) ∨
    (leading1 = leading2 ++ [left2] ∧ left1 = right2 ∧ suffix2 = right1 :: suffix1) ∨
    (∃ mid, leading1 = leading2 ++ left2 :: right2 :: mid ∧
            suffix2 = mid ++ left1 :: right1 :: suffix1) := by
  rcases List.append_eq_append_iff.mp hEq with ⟨as, hleading2, hrest⟩ | ⟨bs, hleading1, hrest⟩
  · rcases as with _ | ⟨x, _ | ⟨y, rest⟩⟩
    · simp only [List.nil_append, List.append_nil, List.cons.injEq] at hleading2 hrest
      obtain ⟨hl, hr, hs⟩ := hrest
      exact Or.inl ⟨hleading2.symm, hl, hr, hs⟩
    · simp only [List.cons_append, List.nil_append, List.cons.injEq] at hrest
      obtain ⟨hl, hr, hs⟩ := hrest
      subst hl
      exact Or.inr (Or.inr (Or.inl ⟨hleading2, hr, hs⟩))
    · simp only [List.cons_append, List.cons.injEq] at hrest
      obtain ⟨hl, hr, hs⟩ := hrest
      subst hl; subst hr
      exact Or.inr (Or.inl ⟨rest, hleading2, hs⟩)
  · rcases bs with _ | ⟨x, _ | ⟨y, rest⟩⟩
    · simp only [List.nil_append, List.append_nil, List.cons.injEq] at hleading1 hrest
      obtain ⟨hl, hr, hs⟩ := hrest
      exact Or.inl ⟨hleading1, hl.symm, hr.symm, hs.symm⟩
    · simp only [List.cons_append, List.nil_append, List.cons.injEq] at hrest
      obtain ⟨hl, hr, hs⟩ := hrest
      subst hl
      exact Or.inr (Or.inr (Or.inr (Or.inl ⟨hleading1, hr.symm, hs⟩)))
    · simp only [List.cons_append, List.cons.injEq] at hrest
      obtain ⟨hl, hr, hs⟩ := hrest
      subst hl; subst hr
      exact Or.inr (Or.inr (Or.inr (Or.inr ⟨rest, hleading1, hs⟩)))

/-!
## 5. Overlapping swap sites close too — no extra hypothesis needed

This is the case the task brief warned might need an additional hypothesis beyond pairwise
`Commute` (e.g. a `StronglyCommutingTriple`-shaped closure condition). It does not: the two given
witnesses `Commute step e1 e2` (from the first swap) and `Commute step e2 e3` (from the second)
suffice on their own, via a two-step detour through the *unswapped* middle order
`e1 :: e2 :: e3`, which needs only `Commute step e2 e1` (free, by `Commute` symmetry — the same
fact `Swap.symm` already uses) followed by `Commute step e2 e3` (already in hand):

`e2 :: e1 :: e3  →  e1 :: e2 :: e3  →  e1 :: e3 :: e2`

The first arrow swaps back the *first* pair; the second arrow swaps the *second* pair. Neither
step needs `Commute step e1 e3` (the two outer, non-adjacent-in-the-original-window events never
need to be compared at all). This closes the diamond onto `e1 :: e3 :: e2`, the *other* branch's
target, directly — not onto some third point — so the join is exhibited with zero slack.
-/

/--
Two swaps overlapping at a shared middle event (`e2`) are locally confluent, unconditionally.
`Standing: PROVEN`. This is the positive resolution of the task brief's flagged risk: the
overlapping case of `LocallyConfluent (Swap step)` does *not* need a `StronglyCommutingTriple`
hypothesis beyond the two `Commute` witnesses the two given swaps already carry.
-/
theorem swap_overlap_confluent
    {Event State : Type} (step : Event → State → State)
    (leading suffix : List Event)
    (e1 e2 e3 : Event)
    (hCommute12 : Commute step e1 e2)
    (hCommute23 : Commute step e2 e3) :
    Relation.ReflTransGen (Swap step)
      (leading ++ e2 :: e1 :: e3 :: suffix)
      (leading ++ e1 :: e3 :: e2 :: suffix) := by
  have firstStep :
      Swap step (leading ++ e2 :: e1 :: e3 :: suffix) (leading ++ e1 :: e2 :: e3 :: suffix) :=
    Swap.intro leading (e3 :: suffix) e2 e1 (fun state => (hCommute12 state).symm)
  have secondStep :
      Swap step (leading ++ e1 :: e2 :: e3 :: suffix) (leading ++ e1 :: e3 :: e2 :: suffix) := by
    have raw := Swap.intro (leading ++ [e1]) suffix e2 e3 hCommute23
    simpa [List.append_assoc] using raw
  exact Relation.ReflTransGen.head firstStep (Relation.ReflTransGen.single secondStep)

/-!
## 6. `LocallyConfluent (Swap step)`, unconditionally

Assembling `swap_site_cases`'s five shapes: shape 1 (same window) gives `b = c` directly; shapes
2 and 5 (disjoint, either side) are `swap_disjoint_confluent`; shapes 3 and 4 (overlap, either
side) are `swap_overlap_confluent` (shape 4 via `Join`'s built-in symmetry). No case is left open.
-/

/--
Non-dependent inversion for `Swap`. Deliberately stated with `Exists`-bound witnesses rather than
relying on the tactic `cases`/`rcases` directly at a call site where the source list is already a
compound expression: `cases` there would unify the constructor's pattern variables against the
already-fixed decomposition syntactically, collapsing to the *same* window instead of leaving the
second swap's window genuinely free — exactly the bug `swap_locallyConfluent` below must avoid.
Proving `inv` once, here, where `a`/`b` are still bare variables (the safe shape `Swap.symm`
already uses), sidesteps that trap for every downstream call.
-/
theorem Swap.inv {Event State : Type} {step : Event → State → State} {a b : List Event}
    (h : Swap step a b) :
    ∃ leading suffix left right,
      Commute step left right ∧
      a = leading ++ left :: right :: suffix ∧
      b = leading ++ right :: left :: suffix := by
  cases h with
  | intro leading suffix left right hCommute =>
      exact ⟨leading, suffix, left, right, hCommute, rfl, rfl⟩

/--
`Swap step` is locally confluent, for every `step`. `Standing: PROVEN`, kernel-checked, no
`sorry`, no extra hypothesis beyond the two `Commute` witnesses each `Swap` instance already
carries.
-/
theorem swap_locallyConfluent
    {Event State : Type} (step : Event → State → State) :
    Relation.LocallyConfluent (Swap step) := by
  intro a b c hab hac
  obtain ⟨leading1, suffix1, left1, right1, hCommute1, ha1, hb1⟩ := hab.inv
  obtain ⟨leading2, suffix2, left2, right2, hCommute2, ha2, hc2⟩ := hac.inv
  have hEq : leading1 ++ left1 :: right1 :: suffix1 = leading2 ++ left2 :: right2 :: suffix2 :=
    ha1.symm.trans ha2
  subst hb1; subst hc2
  rcases swap_site_cases leading1 suffix1 leading2 suffix2 left1 right1 left2 right2 hEq with
    ⟨hleading, hleft, hright, hsuffix⟩ |
    ⟨mid, hleading2, hsuffix1⟩ |
    ⟨hleading2, hshare, hsuffix1⟩ |
    ⟨hleading1, hshare, hsuffix2⟩ |
    ⟨mid, hleading1, hsuffix2⟩
  · -- same window: b and c are literally the same list
    subst hleading; subst hleft; subst hright; subst hsuffix
    exact ⟨_, Relation.ReflTransGen.refl, Relation.ReflTransGen.refl⟩
  · -- disjoint, window2 strictly after window1
    subst hleading2; subst hsuffix1
    obtain ⟨d, hd1, hd2⟩ := swap_disjoint_confluent step leading1 mid suffix2
      left1 right1 left2 right2 hCommute1 hCommute2
    refine ⟨d, ?_, ?_⟩
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd1
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd2
  · -- overlap, window2 shifted right by one (shares right1 = left2)
    subst hleading2; subst hshare; subst hsuffix1
    refine ⟨_, ?_, Relation.ReflTransGen.refl⟩
    simpa [List.append_assoc] using
      swap_overlap_confluent step leading1 suffix2 left1 right1 right2 hCommute1 hCommute2
  · -- overlap, window2 shifted left by one (shares left1 = right2): mirror of the above
    subst hleading1; subst hshare; subst hsuffix2
    refine ⟨_, Relation.ReflTransGen.refl, ?_⟩
    simpa [List.append_assoc] using
      swap_overlap_confluent step leading2 suffix1 left2 left1 right1 hCommute2 hCommute1
  · -- disjoint, window1 strictly after window2
    subst hleading1; subst hsuffix2
    obtain ⟨d, hd2, hd1⟩ := swap_disjoint_confluent step leading2 mid suffix1
      left2 right2 left1 right1 hCommute2 hCommute1
    refine ⟨d, ?_, ?_⟩
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd1
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd2

/-!
## 7. Newman's Lemma applies — conditionally — and the replay correspondence

`LocallyConfluent (Swap step)` (§6) is now unconditional. `cslib`'s
`LocallyConfluent.Terminating_toConfluent` therefore reduces `Confluent (Swap step)` to exactly
one remaining hypothesis: `Terminating (Swap step)`. §2 already proved that hypothesis false in
general. `swap_confluent_of_terminating` below states the conditional correctly (Newman's Lemma
applied by direct correspondence, not reproof — discharging the substance of Problem P17), and
`swap_replay_eq_of_confluent` connects `Confluent (Swap step)` back to `replay`, generalizing
`replay_eq_of_traceEq` from `TraceEq`'s hand-built equivalence closure to *any* two traces
`ReflTransGen`-reachable from a common source. Both are real, kernel-checked theorems; neither is
`Confluent (Swap step)` itself, which remains open pending an orientation on `Swap` (see the
closing summary).
-/

/--
Newman's Lemma, applied to `Swap step` by direct correspondence (§1's `Swap step` *is* `cslib`'s
abstract `r`, no translation layer): `Terminating (Swap step) → Confluent (Swap step)`, using the
already-unconditional `swap_locallyConfluent`. This is Problem P17's target conclusion, honestly
conditioned on the one hypothesis §2 shows is false for the raw relation — it is not vacuous
(nothing here claims `Terminating (Swap step)` holds), it is the correspondence step P17 asked
for, applied.

Standing: `PROVEN` (as a conditional). The antecedent is `BLOCKED`, per §2.
-/
theorem swap_confluent_of_terminating
    {Event State : Type} (step : Event → State → State)
    (hTerminating : Relation.Terminating (Swap step)) :
    Relation.Confluent (Swap step) :=
  Relation.LocallyConfluent.Terminating_toConfluent (swap_locallyConfluent step) hTerminating

/--
`Confluent (Swap step)` implies every two traces reachable from a common trace by valid swaps
replay identically — the correspondence back to `replay` that motivated this file. This
*generalizes* `equivalentTraces_sameFinal`/`replay_eq_of_traceEq`: those cover exactly the traces
connected by a hand-built `TraceEq` derivation (the equivalence closure of exhibited swaps);
`ReflTransGen (Swap step)`-reachability from a *common source*, closed under `Confluent`, covers
every pair of traces reachable from that source by *any* sequence of valid swaps, including ones
no caller ever built a `TraceEq` derivation for. It is a strictly different theorem, not a
restatement: `TraceEq` is symmetric and transitive by fiat (its own constructors); `Confluent`
delivers the analogous fact for `ReflTransGen (Swap step)` (reflexive-transitive only, not
symmetric on the nose) by proof, via the existence of a common descendant `d`, at the cost of the
`Confluent` hypothesis this file could not discharge unconditionally.

Standing: `PROVEN` (as a conditional on `Confluent (Swap step)`, which is itself conditional on
`Terminating (Swap step)` per `swap_confluent_of_terminating` — currently `BLOCKED`).
-/
theorem swap_replay_eq_of_confluent
    {Event State : Type} {step : Event → State → State}
    (hConfluent : Relation.Confluent (Swap step))
    {source left right : List Event}
    (hLeft : Relation.ReflTransGen (Swap step) source left)
    (hRight : Relation.ReflTransGen (Swap step) source right)
    (state : State) :
    replay step left state = replay step right state := by
  obtain ⟨d, hLeftD, hRightD⟩ := hConfluent hLeft hRight
  have hLeftEq : replay step left state = replay step d state := by
    clear hRight hRightD
    induction hLeftD with
    | refl => rfl
    | tail _ hStep ih =>
        rename_i mid final
        cases hStep with
        | intro leading suffix swapLeft swapRight hCommute =>
            rw [ih, replay_adjacent_swap_of_commute step leading suffix swapLeft swapRight state
              hCommute]
  have hRightEq : replay step right state = replay step d state := by
    clear hLeft hLeftD hLeftEq
    induction hRightD with
    | refl => rfl
    | tail _ hStep ih =>
        rename_i mid final
        cases hStep with
        | intro leading suffix swapLeft swapRight hCommute =>
            rw [ih, replay_adjacent_swap_of_commute step leading suffix swapLeft swapRight state
              hCommute]
  rw [hLeftEq, hRightEq]

/-!
## 8. Closing summary — standing, and the corrected Problem P17

**Proven, unconditionally, kernel-checked (`propext`/`Quot.sound`/`Classical.choice` only, no
`sorry`):**

* `not_terminating_of_cycle`, `not_terminating_swap_constUnit` — `Terminating (Swap step)` is
  **false** in general (refuted, not merely unproven), for every `step` admitting one
  nondegenerate commuting pair.
* `swap_disjoint_confluent`, `swap_site_cases`, `swap_overlap_confluent`, `swap_locallyConfluent`
  — `LocallyConfluent (Swap step)` holds **unconditionally**, for every `step`. All three site
  relationships (same window, disjoint, overlapping-by-one-shared-event) close; the overlap case
  needs no hypothesis beyond the two `Commute` witnesses already carried by the two given swaps.
* `swap_confluent_of_terminating`, `swap_replay_eq_of_confluent` — the two correspondence steps
  Problem P17 asked for (feeding `Swap step` into `LocallyConfluent.Terminating_toConfluent`, and
  connecting `Confluent` back to `replay`), each proven as a real conditional theorem.

**Not proven, and not falsely claimed:** `Confluent (Swap step)` itself. `swap_locallyConfluent`
discharges one of Newman's Lemma's two hypotheses unconditionally; `not_terminating_swap_constUnit`
proves the other hypothesis is false for the relation as specified in this file. Composing them
does not yield `Confluent (Swap step)` — it yields nothing, because `swap_confluent_of_terminating`
is never applicable to the raw `Swap` relation. This is the honest state: **BLOCKED**, with the
obstruction isolated to exactly one hypothesis, not vaguely distributed across the proof.

**Correction to the task brief's own risk assessment.** The brief anticipated the overlapping case
of local confluence as the likely blocker, needing an unnamed additional hypothesis (candidate
name `StronglyCommutingTriple`). That did not materialize: §5/§6 close the overlapping case with
zero extra hypotheses, via a two-step detour through the unswapped order
(`e2 :: e1 :: e3 → e1 :: e2 :: e3 → e1 :: e3 :: e2`) that only ever uses the two `Commute`
witnesses already in hand. The actual blocker is structural and was not on the task brief's list:
`Swap` is symmetric (§2, `Swap.symm`) because `Commute` is a symmetric predicate on its two
arguments, so *any* raw one-step swap relation built this way admits a two-cycle and can never be
`Terminating` in `cslib`'s strong-normalization sense — independent of `Event`/`State`/`step`,
independent of the causal DAG being finite (`ROADMAP_SWARM_SUPPLY_CHAIN.md` Correction C25's
concern), and independent of whether the ambient list type is restricted to a finite set of
permutations of one reference trace (still fails: a two-cycle refutes well-foundedness regardless
of the type's cardinality).

**Candidate fix, named precisely, not attempted here (new work, out of this file's scope).** To
get a `Terminating` relation suitable for Newman's Lemma, `Swap` needs an orientation breaking its
symmetry — e.g. fix a reference trace (or a priority function `Event → ℕ`) and restrict `Swap` to
only fire when the transposition strictly reduces the number of position-inversions relative to
that reference (the standard bubble-sort-termination technique: adjacent-transposition sorting
terminates because the rewrite is oriented, not because the underlying transposition relation is
well-founded on its own). This changes the theorem `Confluent (OrientedSwap step reference)` would
deliver: not "any two `Swap`-reachable traces from a common source replay identically" (Target
Theorem 9.1's original ambition) but "every `Swap`-equivalence-class has a unique normal form
reachable by `OrientedSwap` from any representative, and normal forms replay identically to every
representative" — a real, provable, and still useful theorem, but a *different* one from what
`ROADMAP_SWARM_SUPPLY_CHAIN.md` Wave S7 named. Filed as the corrected content for **Problem P22**
(continuing P14–P21): *Orientation for Newman's Lemma on the Swap Relation* — construct
`OrientedSwap` parametrized by a priority/reference structure, prove
`Terminating (OrientedSwap step priority)` via strict inversion-count decrease, reuse
`swap_locallyConfluent`'s case structure (same/disjoint/overlap) to reprove
`LocallyConfluent (OrientedSwap step priority)` (the disjoint case ports directly; the overlap
case's 2-step detour needs re-checking against the orientation constraint at each step), then
apply `LocallyConfluent.Terminating_toConfluent` for real. Closes the residual half of C25/C27
that Correction C27's own text did not anticipate (it named the finite-order-ideal issue and the
correspondence-into-`LocallyConfluent` issue, not the raw relation's non-well-foundedness).

**Relation to `replay_eq_of_traceEq` (`Replay.lean`).** `TraceEq` is `Swap`'s equivalence closure,
built from `refl`/`swap`/`symm`/`trans` constructors by fiat — a caller who wants
`replay_eq_of_traceEq` for two traces must construct the `TraceEq` derivation by hand (Replay.lean's
own module comment: "covers swap chains you have already constructed by hand"). `swap_locallyConfluent`
+ `swap_replay_eq_of_confluent` would, if `Confluent (Swap step)` were available, give the same
replay-equality conclusion for *any* two `ReflTransGen (Swap step)`-reachable traces from a common
source, without the caller ever building a `TraceEq` witness — strictly more general, exactly as
the task motivated. That generalization is real for the `LocallyConfluent` half (proven here) and
blocked on the `Terminating` half (also proven, negatively) — not available today, and precisely
why not.
-/

end Replay

end ProcInt.Playground.Swarm11
