-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Models.Bpmn

BPMN core graph shape: node kinds (task, XOR gateway, AND gateway, start event, end event), sequence-flow edges, and processes with structural wellformedness (single start, single end, no dangling edges). Port of wasm4pm-compat bpmn.rs (BpmnNodeKind, BpmnNode, BpmnEdge, BpmnProcess::validate); canonical source: OMG BPMN 2.0 specification, 2011. -/

namespace ProcInt

/-- The kind of a BPMN flow node: a named task, an exclusive (XOR) gateway,
a parallel (AND) gateway, a start event, or an end event. Port of
`bpmn.rs` `BpmnNodeKind`/`BpmnGateway`/`BpmnEvent` (BPMN 2.0, OMG 2011). -/
inductive BpmnNodeKind where
  | task (name : String)
  | xorGateway
  | andGateway
  | startEvent
  | endEvent
deriving DecidableEq, Repr

/-- A BPMN node: an identified vertex carrying its kind. Port of
`bpmn.rs` `BpmnNode` (id keys the node in the process graph). -/
structure BpmnNode where
  id : String
  kind : BpmnNodeKind
deriving DecidableEq, Repr

/-- A BPMN sequence flow: a directed edge between node ids. Port of
`bpmn.rs` `BpmnEdge`. -/
structure BpmnEdge where
  source : String
  target : String
deriving DecidableEq, Repr

/-- A BPMN process: a graph of nodes joined by sequence-flow edges.
Port of `bpmn.rs` `BpmnProcess` (structure only, no token semantics). -/
structure BpmnProcess where
  nodes : List BpmnNode
  edges : List BpmnEdge
deriving Repr

/-- Whether a node is a start event (bpmn.rs `BpmnEvent::Start` match arm). -/
def BpmnNode.isStart (n : BpmnNode) : Bool :=
  n.kind = BpmnNodeKind.startEvent

/-- Whether a node is an end event (bpmn.rs `BpmnEvent::End` match arm). -/
def BpmnNode.isEnd (n : BpmnNode) : Bool :=
  n.kind = BpmnNodeKind.endEvent

/-- BPMN structural wellformedness: exactly one start event, exactly one
end event, and every edge endpoint is a declared node id. Port of
`bpmn.rs` `BpmnProcess::validate` laws MissingStartEvent / MissingEndEvent /
DanglingEdge, strengthened to single start/end. -/
def BpmnProcess.WellFormed (p : BpmnProcess) : Prop :=
  (p.nodes.filter BpmnNode.isStart).length = 1 ∧
  (p.nodes.filter BpmnNode.isEnd).length = 1 ∧
  ∀ e ∈ p.edges, (∃ n ∈ p.nodes, n.id = e.source) ∧ (∃ n ∈ p.nodes, n.id = e.target)

/-- The minimal admissible BPMN process start → task → end
(bpmn.rs `BpmnProcess::new` doctest instance). -/
def bpmnMinimal : BpmnProcess :=
  ⟨[⟨"s", BpmnNodeKind.startEvent⟩, ⟨"t", BpmnNodeKind.task "work"⟩,
    ⟨"e", BpmnNodeKind.endEvent⟩],
   [⟨"s", "t"⟩, ⟨"t", "e"⟩]⟩

/-- The minimal start → task → end process is wellformed — the positive
fixture of `bpmn.rs` `BpmnProcess::validate`. -/
theorem bpmnMinimal_wellFormed : bpmnMinimal.WellFormed := by
  refine ⟨by decide, by decide, ?_⟩
  intro e he
  simp [bpmnMinimal] at he
  rcases he with h | h <;> subst h <;> exact ⟨by simp [bpmnMinimal], by simp [bpmnMinimal]⟩

/-- A process with no nodes has no start event, hence is not wellformed —
the `bpmn.rs` `BpmnRefusal::EmptyProcess` law. -/
theorem bpmn_empty_not_wellFormed : ¬ (BpmnProcess.mk [] []).WellFormed := by
  intro h
  simp [BpmnProcess.WellFormed] at h


end ProcInt
