-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11.OrientedSwap
import ProcInt.Playground.Glue.RuntimeReplay
import Cslib.Foundations.Relation.Confluence

/-!
# Unconditional Newman's Lemma for `OrientedSwap (completeStep p) priority`

`OrientedSwap.lean`'s closing summary (§7) leaves `Relation.LocallyConfluent (OrientedSwap step
priority)` open **in general**: `not_orientedSwap_locallyConfluent` exhibits a genuine
counterexample `step` for which it fails, and `orientedSwap_overlap_confluent_of_commute13` names
the precise missing hypothesis — a third `Commute step e1 e3` witness relating the two swapped
pairs' outer events at every overlapping triple.

This file composes that open theorem card with `RuntimeReplay.lean`'s `completeStep`/
`concurrent_commute`, which were never combined with `OrientedSwap` anywhere in the tree (grep
confirms `OrientedSwap`/`invCount`/`priority` occur only in `Swarm11/OrientedSwap.lean`, applied
there only to the abstract toy carrier `Ev3`/`St3`). The composition closes the missing hypothesis
for free: `concurrent_commute`'s proof body (`RuntimeReplay.lean:96-105`) never actually uses its
own `Concurrent p i j` hypothesis — the field updates are `Or`-reassociations (`or_left_comm`),
symmetric for *every* `i j : Fin n`, concurrent or not. So `completeStep p` commutes at every pair,
unconditionally (`completeStep_commute_all` below), which is exactly the third witness
`orientedSwap_overlap_confluent_of_commute13` asks for, available here for every triple rather than
assumed.

## Theorem card

* **Object.** `Replay.OrientedSwap (completeStep p) priority : List (Fin n) → List (Fin n) → Prop`
  for a fixed `p : StrictOrder n` and `priority : Fin n → ℕ`.
* **Imported theorem.** `Relation.LocallyConfluent.Terminating_toConfluent`
  (`Cslib/Foundations/Relation/Confluence.lean:269`), same as `OrientedSwap.lean` and
  `NewmanCorrespondence.lean`.
* **Source hypotheses.** `LocallyConfluent (OrientedSwap (completeStep p) priority)` and
  `Terminating (OrientedSwap (completeStep p) priority)`.
* **Correspondence map.** Identity: `OrientedSwap (completeStep p) priority` is fed directly as
  `cslib`'s abstract `r`, exactly as in `OrientedSwap.lean`/`NewmanCorrespondence.lean`.
* **Preserved structure.** `Terminating` — already unconditional for every `step`
  (`Replay.orientedSwap_terminating`, `OrientedSwap.lean:226-232`), instantiated here at
  `step := completeStep p`, no new work. `LocallyConfluent` — closed here, unconditionally, by
  supplying `completeStep`'s every-pair commutativity as the third witness
  `orientedSwap_overlap_confluent_of_commute13` names as missing.
* **Conclusion.** `Confluent (OrientedSwap (completeStep p) priority)`, hence every two
  `completeStep p`-traces `OrientedSwap`-reachable from a common source replay to the same
  `ExecutionState` (`orientedSwap_replay_eq_completeStep` below).
* **Standing.** `PROVEN`, unconditionally, for every `p : StrictOrder n` and `priority : Fin n → ℕ`.
  Not a hand-picked instance of the counterexample `step` in `OrientedSwap.lean` §6a — a genuine
  new general theorem about the concrete `completeStep` family, holding for every `n`, every `p`,
  and every `priority`.
-/

namespace ProcInt.Playground.Glue

open ProcInt.Playground.MFW
open ProcInt.Playground.Swarm11

/-!
## 1. `completeStep p` commutes at every pair — not just concurrent ones

Literally `concurrent_commute` (`RuntimeReplay.lean:96-105`) with its `Concurrent p i j`
hypothesis deleted: that proof never referenced `h`, so the same tactic script discharges the
unconditional statement. Reported honestly as what it is — a strictly stronger fact about this
concrete representation, not a new proof technique.
-/

/--
`completeStep p` commutes at *every* pair `i j : Fin n`, concurrent or not. This is
`concurrent_commute` (`RuntimeReplay.lean:96`) with the unused `Concurrent p i j` hypothesis
dropped: the field updates are `Or`-reassociations (`or_left_comm`), which hold regardless of
whether `i = j`.

Standing: `PROVEN`.
-/
theorem completeStep_commute_all (p : StrictOrder n) (i j : Fin n) :
    Replay.Commute (completeStep p) i j := by
  intro s
  refine executionState_ext rfl ?_ ?_
  · funext k
    show (k = j ∨ (k = i ∨ s.completed k)) = (k = i ∨ (k = j ∨ s.completed k))
    exact propext or_left_comm
  · funext k
    show (k = j ∨ (k = i ∨ s.receipted k)) = (k = i ∨ (k = j ∨ s.receipted k))
    exact propext or_left_comm

/-!
## 2. `LocallyConfluent (OrientedSwap (completeStep p) priority)`, unconditionally

Mirrors `Replay.swap_locallyConfluent`'s case split exactly (`NewmanCorrespondence.lean:305-346`),
using the fully generic `Replay.swap_site_cases` (`NewmanCorrespondence.lean:193-229`, which
depends only on `List`/`Event`, not on `step`), `Replay.OrientedSwap.inv`
(`OrientedSwap.lean:122-132`), `Replay.orientedSwap_disjoint_confluent`
(`OrientedSwap.lean:250-269`), and `Replay.orientedSwap_overlap_confluent_of_commute13`
(`OrientedSwap.lean:436-472`), fed `completeStep_commute_all` for the third witness the
unconditional statement is missing in general.
-/

/--
`OrientedSwap (completeStep p) priority` is locally confluent, for every `p` and `priority`.
Unlike the abstract `step` in `OrientedSwap.lean` §6, `completeStep p`'s every-pair commutativity
(`completeStep_commute_all`) discharges the overlap case's missing third `Commute` witness for
every triple, so the case split closes completely.

Standing: `PROVEN`.
-/
theorem orientedSwap_locallyConfluent_completeStep
    (p : StrictOrder n) (priority : Fin n → ℕ) :
    Relation.LocallyConfluent (Replay.OrientedSwap (completeStep p) priority) := by
  intro a b c hab hac
  obtain ⟨leading1, suffix1, left1, right1, hCommute1, hPrio1, ha1, hb1⟩ := hab.inv
  obtain ⟨leading2, suffix2, left2, right2, hCommute2, hPrio2, ha2, hc2⟩ := hac.inv
  have hEq : leading1 ++ left1 :: right1 :: suffix1 = leading2 ++ left2 :: right2 :: suffix2 :=
    ha1.symm.trans ha2
  subst hb1; subst hc2
  rcases Replay.swap_site_cases leading1 suffix1 leading2 suffix2 left1 right1 left2 right2 hEq with
    ⟨hleading, hleft, hright, hsuffix⟩ |
    ⟨mid, hleading2, hsuffix1⟩ |
    ⟨hleading2, hshare, hsuffix1⟩ |
    ⟨hleading1, hshare, hsuffix2⟩ |
    ⟨mid, hleading1, hsuffix2⟩
  · -- same window
    subst hleading; subst hleft; subst hright; subst hsuffix
    exact ⟨_, Relation.ReflTransGen.refl, Relation.ReflTransGen.refl⟩
  · -- disjoint, window2 strictly after window1
    subst hleading2; subst hsuffix1
    obtain ⟨d, hd1, hd2⟩ := Replay.orientedSwap_disjoint_confluent (completeStep p) priority
      leading1 mid suffix2 left1 right1 left2 right2 hCommute1 hCommute2 hPrio1 hPrio2
    refine ⟨d, ?_, ?_⟩
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd1
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd2
  · -- overlap, window2 shifted right by one (shares right1 = left2)
    subst hleading2; subst hshare; subst hsuffix1
    obtain ⟨hjoinB, hjoinC⟩ := Replay.orientedSwap_overlap_confluent_of_commute13
      (completeStep p) priority leading1 suffix2 left1 right1 right2
      hCommute1 hCommute2 (completeStep_commute_all p left1 right2) hPrio1 hPrio2
    exact ⟨_, by simpa [List.append_assoc] using hjoinB,
             by simpa [List.append_assoc] using hjoinC⟩
  · -- overlap, window2 shifted left by one (shares left1 = right2): mirror
    subst hleading1; subst hshare; subst hsuffix2
    obtain ⟨hjoinC, hjoinB⟩ := Replay.orientedSwap_overlap_confluent_of_commute13
      (completeStep p) priority leading2 suffix1 left2 left1 right1
      hCommute2 hCommute1 (completeStep_commute_all p left2 right1) hPrio2 hPrio1
    exact ⟨_, by simpa [List.append_assoc] using hjoinB,
             by simpa [List.append_assoc] using hjoinC⟩
  · -- disjoint, window1 strictly after window2
    subst hleading1; subst hsuffix2
    obtain ⟨d, hd2, hd1⟩ := Replay.orientedSwap_disjoint_confluent (completeStep p) priority
      leading2 mid suffix1 left2 right2 left1 right1 hCommute2 hCommute1 hPrio2 hPrio1
    refine ⟨d, ?_, ?_⟩
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd1
    · simpa [List.append_assoc] using Relation.ReflTransGen.single hd2

/-!
## 3. Newman's Lemma applied — unconditionally
-/

/--
`OrientedSwap (completeStep p) priority` is confluent, for every `p : StrictOrder n` and
`priority : Fin n → ℕ`. Newman's Lemma (`Relation.LocallyConfluent.Terminating_toConfluent`,
`Cslib/Foundations/Relation/Confluence.lean:269`) applied to the now-unconditional
`orientedSwap_locallyConfluent_completeStep` and the already-unconditional
`Replay.orientedSwap_terminating` (`OrientedSwap.lean:226-232`).

Standing: `PROVEN`, unconditionally.
-/
theorem orientedSwap_confluent_completeStep (p : StrictOrder n) (priority : Fin n → ℕ) :
    Relation.Confluent (Replay.OrientedSwap (completeStep p) priority) :=
  Relation.LocallyConfluent.Terminating_toConfluent
    (orientedSwap_locallyConfluent_completeStep p priority)
    (Replay.orientedSwap_terminating (completeStep p) priority)

/-!
## 4. The payoff: replay correspondence for `OrientedSwap`-reachable `completeStep` traces

Mirrors `Replay.swap_replay_eq_of_confluent` (`NewmanCorrespondence.lean:395-424`), instantiated at
the now-unconditional `orientedSwap_confluent_completeStep`.
-/

/--
Any two `completeStep p`-event-traces `OrientedSwap (completeStep p) priority`-reachable from a
common source (by *any* sequence of oriented swaps, not just a hand-built `TraceEq` derivation)
replay to the identical final `ExecutionState`.

Standing: `PROVEN`, unconditionally.
-/
theorem orientedSwap_replay_eq_completeStep
    (p : StrictOrder n) (priority : Fin n → ℕ)
    {source left right : List (Fin n)}
    (hLeft : Relation.ReflTransGen (Replay.OrientedSwap (completeStep p) priority) source left)
    (hRight : Relation.ReflTransGen (Replay.OrientedSwap (completeStep p) priority) source right)
    (state : ExecutionState n) :
    Replay.replay (completeStep p) left state = Replay.replay (completeStep p) right state := by
  obtain ⟨d, hLeftD, hRightD⟩ := orientedSwap_confluent_completeStep p priority hLeft hRight
  have hLeftEq : Replay.replay (completeStep p) left state
      = Replay.replay (completeStep p) d state := by
    clear hRight hRightD
    induction hLeftD with
    | refl => rfl
    | tail _ hStep ih =>
        rename_i mid final
        obtain ⟨leading, suffix, swapLeft, swapRight, hCommute, _hPrio, hmidEq, hfinalEq⟩ :=
          hStep.inv
        rw [ih, hmidEq, hfinalEq,
          Replay.replay_adjacent_swap_of_commute (completeStep p) leading suffix
            swapLeft swapRight state hCommute]
  have hRightEq : Replay.replay (completeStep p) right state
      = Replay.replay (completeStep p) d state := by
    clear hLeft hLeftD hLeftEq
    induction hRightD with
    | refl => rfl
    | tail _ hStep ih =>
        rename_i mid final
        obtain ⟨leading, suffix, swapLeft, swapRight, hCommute, _hPrio, hmidEq, hfinalEq⟩ :=
          hStep.inv
        rw [ih, hmidEq, hfinalEq,
          Replay.replay_adjacent_swap_of_commute (completeStep p) leading suffix
            swapLeft swapRight state hCommute]
  rw [hLeftEq, hRightEq]

end ProcInt.Playground.Glue
