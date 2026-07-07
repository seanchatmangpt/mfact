-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-!
A concrete two-place, one-transition workflow net `w0` on `P := Bool`
(`false` = source, `true` = sink), exercising:

* `ProcInt.WfNet` (`ProcInt/Workflow/WfNet.lean`) — the source/sink axioms
  and the `onPath` (strong connectivity) obligation.
* `ProcInt.WfNet.shortCircuit` (`ProcInt/Workflow/ShortCircuit.lean`) — the
  fresh closing transition `t*` and its conservativity lemmas.
* `ProcInt.WfNet.Sound` (`ProcInt/Workflow/Soundness.lean`) — the three
  independent soundness clauses, discharged for `w0`.

`w0` is the minimal workflow net: one transition `()` consuming the single
token on the source and depositing it on the sink, i.e. `i -> () -> o`. -/

/-- The underlying Petri net of `w0`: transition `()` consumes one token from
`false` and produces one token on `true`. -/
noncomputable def w0Net : PetriNet Bool Unit where
  pre  := fun _ => Finsupp.single false 1
  post := fun _ => Finsupp.single true 1

private theorem w0_pre_false (t : Unit) : w0Net.pre t false = 1 := by
  simp [w0Net]

private theorem w0_pre_true (t : Unit) : w0Net.pre t true = 0 := by
  simp only [w0Net]
  exact Finsupp.single_eq_of_ne (by decide)

private theorem w0_post_true (t : Unit) : w0Net.post t true = 1 := by
  simp [w0Net]

private theorem w0_post_false (t : Unit) : w0Net.post t false = 0 := by
  simp only [w0Net]
  exact Finsupp.single_eq_of_ne (by decide)

/-- Flow edge `false -> ()`: `false` is an input place of the only transition. -/
private theorem w0_edge_source : w0Net.FlowEdge (Sum.inl false) (Sum.inr ()) := by
  show 0 < w0Net.pre () false
  rw [w0_pre_false]; decide

/-- Flow edge `() -> true`: `true` is an output place of the only transition. -/
private theorem w0_edge_sink : w0Net.FlowEdge (Sum.inr ()) (Sum.inl true) := by
  show 0 < w0Net.post () true
  rw [w0_post_true]; decide

/-- `ProcInt.WfNet` (`Workflow/WfNet.lean`): the minimal one-transition
workflow net `i -> () -> o` on places `Bool` (`false` = source, `true` =
sink), witnessing every clause of Definition 7 (van der Aalst 1997). -/
noncomputable def w0 : WfNet Bool Unit where
  net := w0Net
  source := false
  sink := true
  source_ne_sink := by decide
  source_no_input := fun t => by
    have := w0_post_false t; simpa using this
  sink_no_output := fun t => by
    have := w0_pre_true t; simpa using this
  onPath := fun x => by
    constructor
    · -- every node is reachable from the source
      cases x with
      | inl p =>
        cases p with
        | false => exact Relation.ReflTransGen.refl
        | true =>
          exact Relation.ReflTransGen.tail
            (Relation.ReflTransGen.single w0_edge_source) w0_edge_sink
      | inr t =>
        cases t
        exact Relation.ReflTransGen.single w0_edge_source
    · -- every node reaches the sink
      cases x with
      | inl p =>
        cases p with
        | false =>
          exact Relation.ReflTransGen.tail
            (Relation.ReflTransGen.single w0_edge_source) w0_edge_sink
        | true => exact Relation.ReflTransGen.refl
      | inr t =>
        cases t
        exact Relation.ReflTransGen.single w0_edge_sink

-- `WfNet.initialMarking`/`WfNet.finalMarking` are `noncomputable` (built from
-- `Finsupp.single`), so we reason about `w0` with `rfl`/`simp`, not `#eval`.

/-- `ProcInt.WfNet.initialMarking_ne_finalMarking` instantiated at `w0`: the
one-token-on-source and one-token-on-sink markings differ. -/
example : w0.initialMarking ≠ w0.finalMarking := w0.initialMarking_ne_finalMarking

private theorem w0_init_false : w0.initialMarking false = 1 := by
  show Finsupp.single false (1 : ℕ) false = 1
  exact Finsupp.single_eq_same

private theorem w0_init_true : w0.initialMarking true = 0 := by
  show Finsupp.single false (1 : ℕ) true = 0
  exact Finsupp.single_eq_of_ne (by decide)

private theorem w0_final_true : w0.finalMarking true = 1 := by
  show Finsupp.single true (1 : ℕ) true = 1
  exact Finsupp.single_eq_same

private theorem w0_final_false : w0.finalMarking false = 0 := by
  show Finsupp.single true (1 : ℕ) false = 0
  exact Finsupp.single_eq_of_ne (by decide)

/-- The only transition is enabled at `w0`'s initial marking (one token
sitting on the source, matching the required pre-weight there). -/
theorem w0_enabled_init : w0.net.Enabled w0.initialMarking () := by
  show w0Net.pre () ≤ w0.initialMarking
  intro p
  cases p with
  | false => rw [w0_pre_false, w0_init_false]
  | true => rw [w0_pre_true]; exact Nat.zero_le _

/-- Firing the only transition at `w0`'s initial marking lands exactly on the
final marking: `i -> () -> o` (`ProcInt.PetriNet.fire`, `Workflow/WfNet.lean`
markings). -/
theorem w0_fire_init : w0.net.fire w0.initialMarking () = w0.finalMarking := by
  show w0.initialMarking - w0Net.pre () + w0Net.post () = w0.finalMarking
  show Finsupp.single false 1 - Finsupp.single false 1 + Finsupp.single true 1
      = Finsupp.single true 1
  rw [tsub_self, zero_add]

/-- `ProcInt.PetriNet.Step` (`Petri/Firing.lean`): firing `w0`'s transition at
the initial marking steps to the final marking. -/
theorem w0_step_init_final : w0.net.Step w0.initialMarking () w0.finalMarking :=
  ⟨w0_enabled_init, w0_fire_init.symm⟩

/-- Every marking reachable from `w0`'s initial marking is either the initial
marking itself or the final marking: `w0` has exactly two reachable states,
`[i]` and `[o]`. This is the closed-form reachability set used below to
discharge `WfNet.Sound`. -/
theorem w0_reach_cases {M : Marking Bool}
    (h : w0.net.Reaches w0.initialMarking M) :
    M = w0.initialMarking ∨ M = w0.finalMarking := by
  induction h with
  | refl => exact Or.inl rfl
  | tail _ hstep ih =>
    rename_i M' _
    rcases ih with rfl | rfl
    · obtain ⟨t, ht⟩ := hstep
      cases t
      exact Or.inr (ht.2.trans w0_fire_init)
    · exfalso
      obtain ⟨t, ht⟩ := hstep
      cases t
      have henab : w0Net.pre () ≤ w0.finalMarking := ht.1
      have h1 := henab false
      rw [w0_pre_false, w0_final_false] at h1
      omega

/-- `ProcInt.WfNet.Sound` (`Workflow/Soundness.lean`), fully instantiated for
`w0`: option-to-complete, proper completion, and no dead transitions, each
witnessed concretely via the two-state reachability set `{[i], [o]}`
(van der Aalst 1997, Def 7 of soundness). -/
theorem w0_sound : w0.Sound where
  option_to_complete := fun M hM => by
    rcases w0_reach_cases hM with rfl | rfl
    · exact Relation.ReflTransGen.single ⟨(), w0_step_init_final⟩
    · exact Relation.ReflTransGen.refl
  proper_completion := fun M hM hle => by
    rcases w0_reach_cases hM with rfl | rfl
    · exfalso
      have h1 := hle true
      rw [w0_final_true, w0_init_true] at h1
      omega
    · rfl
  no_dead_transitions := fun t => by
    cases t
    exact ⟨w0.initialMarking, w0.finalMarking,
      Relation.ReflTransGen.refl, w0_step_init_final⟩

/-- `ProcInt.WfNet.Sound.reaches_final` (`Workflow/Soundness.lean`)
instantiated at `w0`: the sound net indeed reaches `[o]` from `[i]`. -/
example : w0.net.Reaches w0.initialMarking w0.finalMarking :=
  w0_sound.reaches_final

/-! ## `WfNet.shortCircuit` (`Workflow/ShortCircuit.lean`)

The short-circuited net `w0.shortCircuit` adds one fresh transition `t* =
Sum.inr ()` closing `o` back to `i`, on transitions `Unit ⊕ Unit`. -/

/-- `ProcInt.WfNet.shortCircuit_pre_inl` at `w0`: the original transition
keeps its pre-weights inside the short-circuited net. -/
example : w0.shortCircuit.pre (Sum.inl ()) = w0Net.pre () :=
  w0.shortCircuit_pre_inl ()

/-- `ProcInt.WfNet.shortCircuit_pre_inr` at `w0`: the fresh closing
transition `t*` consumes exactly the final marking `[o]`. -/
example : w0.shortCircuit.pre (Sum.inr ()) = w0.finalMarking :=
  w0.shortCircuit_pre_inr ()

/-- `ProcInt.WfNet.shortCircuit_post_inr` at `w0`: `t*` produces exactly the
initial marking `[i]`, closing the net into a cycle `i -> () -> o -> t* -> i`. -/
example : w0.shortCircuit.post (Sum.inr ()) = w0.initialMarking :=
  w0.shortCircuit_post_inr ()

/-- `ProcInt.WfNet.shortCircuit_enabled_star` at `w0`: the fresh transition
`t*` is enabled the moment the net reaches its final marking. -/
example : w0.shortCircuit.Enabled w0.finalMarking (Sum.inr ()) :=
  w0.shortCircuit_enabled_star

/-- `ProcInt.WfNet.reaches_shortCircuit` at `w0`: the `[i] -> [o]` reachability
fact of the original net transfers unchanged into the short-circuited net. -/
example : w0.shortCircuit.Reaches w0.initialMarking w0.finalMarking :=
  w0.reaches_shortCircuit w0_sound.reaches_final

end ProcInt.Playground
