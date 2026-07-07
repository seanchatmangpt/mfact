-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Workflow.Flow

/-! # ProcInt.Workflow.WfNet

Workflow nets per van der Aalst 1997 (Verification of Workflow Nets, Definition 7): a Petri net with a source place with empty preset, a distinct sink place with empty postset, and every node on a source-to-sink path (equivalent to strong connectivity of the short-circuited net). Initial and final markings as Finsupp.single. Ports the WfNet/WfNetConst shapes of wasm4pm-compat src/petri.rs. -/

namespace ProcInt

/-- A workflow net (van der Aalst 1997, Verification of Workflow Nets, Def 7):
a Petri net with a distinguished source place `i` with no input transitions
(`•i = ∅`), a distinct sink place `o` with no output transitions (`o• = ∅`),
and every node on a path from source to sink — equivalent to strong
connectivity of the short-circuited net. Ported from the Rust
`WfNet`/`WfNetConst` shapes of wasm4pm-compat `src/petri.rs`, with the
typestate soundness markers replaced by the genuine `WfNet.Sound` proposition. -/
structure WfNet (P T : Type) where
  net : PetriNet P T
  source : P
  sink : P
  source_ne_sink : source ≠ sink
  source_no_input : ∀ t, net.post t source = 0
  sink_no_output : ∀ t, net.pre t sink = 0
  onPath : ∀ x : P ⊕ T,
    Relation.ReflTransGen net.FlowEdge (Sum.inl source) x ∧
    Relation.ReflTransGen net.FlowEdge x (Sum.inl sink)

/-- The initial marking `[i]` of a workflow net: one token on the source place
(van der Aalst 1997, Def 7 context; soundness is stated from `[i]`). -/
noncomputable def WfNet.initialMarking {P T : Type} [DecidableEq P] (W : WfNet P T) : Marking P :=
  Finsupp.single W.source 1

/-- The final marking `[o]` of a workflow net: one token on the sink place
(van der Aalst 1997; proper completion targets `[o]`). -/
noncomputable def WfNet.finalMarking {P T : Type} [DecidableEq P] (W : WfNet P T) : Marking P :=
  Finsupp.single W.sink 1

/-- The initial marking puts exactly one token on the source place. -/
theorem WfNet.initialMarking_source {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.initialMarking W.source = 1 := Finsupp.single_eq_same

/-- The initial marking puts no token on the sink place (uses `source ≠ sink`,
van der Aalst 1997 Def 7 clause i ≠ o). -/
theorem WfNet.initialMarking_sink {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.initialMarking W.sink = 0 := Finsupp.single_eq_of_ne (Ne.symm W.source_ne_sink)

/-- The final marking puts exactly one token on the sink place. -/
theorem WfNet.finalMarking_sink {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.finalMarking W.sink = 1 := Finsupp.single_eq_same

/-- The final marking puts no token on the source place. -/
theorem WfNet.finalMarking_source {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.finalMarking W.source = 0 :=
  Finsupp.single_eq_of_ne W.source_ne_sink

/-- The initial and final markings of a workflow net differ (they are
`Finsupp.single` at distinct places with weight 1). -/
theorem WfNet.initialMarking_ne_finalMarking {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.initialMarking ≠ W.finalMarking := by
  intro h
  have h1 : W.initialMarking W.source = W.finalMarking W.source := by rw [h]
  rw [W.initialMarking_source, W.finalMarking_source] at h1
  exact one_ne_zero h1

/-- No flow edge enters the source place: `•i = ∅`
(van der Aalst 1997, Def 7 clause 2). -/
theorem WfNet.not_flowEdge_to_source {P T : Type} (W : WfNet P T) (t : T) :
    ¬ W.net.FlowEdge (Sum.inr t) (Sum.inl W.source) := by
  intro h
  have h' : 0 < W.net.post t W.source := h
  rw [W.source_no_input t] at h'
  exact lt_irrefl 0 h'

/-- No flow edge leaves the sink place: `o• = ∅`
(van der Aalst 1997, Def 7 clause 3). -/
theorem WfNet.not_flowEdge_from_sink {P T : Type} (W : WfNet P T) (t : T) :
    ¬ W.net.FlowEdge (Sum.inl W.sink) (Sum.inr t) := by
  intro h
  have h' : 0 < W.net.pre t W.sink := h
  rw [W.sink_no_output t] at h'
  exact lt_irrefl 0 h'


end ProcInt
