-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt
import ProcInt.Playground.PetriFiringWalkthrough

/-! # Playground: the request→grant net is a workflow net

`ProcInt.Playground.net` (see `PetriFiringWalkthrough.lean`) already has the
shape van der Aalst 1997 calls a workflow net (`ProcInt.WfNet`): one source
place with no incoming flow, one distinct sink place with no outgoing flow,
and every node on a path from source to sink. This file discharges those
four proof obligations concretely and exercises the resulting initial/final
markings. -/

namespace ProcInt.Playground

open Relation (ReflTransGen)

/-- The `requested`-place-to-`grant`-transition flow edge: `grant` needs one
`requested` token (`net.pre`). -/
private theorem hpt : net.FlowEdge (Sum.inl Place.requested) (Sum.inr Trans.grant) := by
  simp [PetriNet.FlowEdge, net]

/-- The `grant`-transition-to-`granted`-place flow edge: `grant` produces
one `granted` token (`net.post`). -/
private theorem htp : net.FlowEdge (Sum.inr Trans.grant) (Sum.inl Place.granted) := by
  simp [PetriNet.FlowEdge, net]

private theorem path_req_grant :
    ReflTransGen net.FlowEdge (Sum.inl Place.requested) (Sum.inr Trans.grant) :=
  ReflTransGen.head hpt ReflTransGen.refl

private theorem path_grant_granted :
    ReflTransGen net.FlowEdge (Sum.inr Trans.grant) (Sum.inl Place.granted) :=
  ReflTransGen.head htp ReflTransGen.refl

private theorem path_req_granted :
    ReflTransGen net.FlowEdge (Sum.inl Place.requested) (Sum.inl Place.granted) :=
  ReflTransGen.head hpt path_grant_granted

/-- `net`, with `requested` as source and `granted` as sink, is a workflow
net: `requested ≠ granted`, nothing flows into `requested`, nothing flows
out of `granted`, and every node lies on a `requested ⤳ granted` path. -/
noncomputable def wfnet : WfNet Place Trans where
  net := net
  source := .requested
  sink := .granted
  source_ne_sink := by decide
  source_no_input := by intro _; simp [net]
  sink_no_output := by intro _; simp [net]
  onPath := fun x => by
    rcases x with p | t
    · rcases p with _ | _
      · exact ⟨ReflTransGen.refl, path_req_granted⟩
      · exact ⟨path_req_granted, ReflTransGen.refl⟩
    · rcases t with _
      exact ⟨path_req_grant, path_grant_granted⟩

/-- The workflow net's initial marking `[requested]` differs from its final
marking `[granted]` — the ledgered `WfNet.initialMarking_ne_finalMarking`,
instantiated on this concrete net. -/
example : wfnet.initialMarking ≠ wfnet.finalMarking :=
  wfnet.initialMarking_ne_finalMarking

end ProcInt.Playground
