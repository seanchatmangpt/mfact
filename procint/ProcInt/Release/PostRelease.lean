-- RENDERED by `ggen sync` from the post-release graph (post-release-pack).
-- Candidate Lean: admitted only by `lake build PostRelease`.
-- ggen renders; Lean admits; mfact certifies.

/-! # Post-release witness — v26.7.7

A finite, kernel-checked witness over the publication packet: no actuation
packet self-actuates (publication is pending external actuation in every
case, however ALIVE the packet's requirements), and the crown research
lane's status is pinned to the catalog-derived value the template author
last confirmed. The lists below are
rendered from the same graph as `release/FINAL_STATUS.md`; a render in
which either law fails makes the corresponding `rfl` proof false and the
kernel refuses this file. -/

namespace ProcInt.Release

/-- Packet identity of the post-release graph this witness was rendered from. -/
def postReleasePacketHash : String :=
  "0c4c9f7674c9a453f4e40c1c550a7a787a8592d7468ebc345d082584b9ff115d"

/-- Actuation packets: (packet id, packet status, publication field). -/
def actuationPackets : List (String × String × String) := [
  ("arxiv_upload", "BLOCKED", "PENDING_EXTERNAL_ACTUATION"),
  ("github_push", "BLOCKED", "PENDING_EXTERNAL_ACTUATION"),
  ("github_release", "ALIVE", "PENDING_EXTERNAL_ACTUATION")
]

/-- No packet self-actuates: every packet's publication field is
`PENDING_EXTERNAL_ACTUATION`, regardless of its ALIVE/BLOCKED status. -/
theorem packets_never_self_actuate :
    actuationPackets.all (fun p => p.2.2 == "PENDING_EXTERNAL_ACTUATION") = true := by rfl

/-- Crown research lane: (obligation name, catalog-derived status). -/
def crownObligations : List (String × String) := [
  ("sound_iff_shortCircuit_live_bounded", "PROVEN"),
  ("proper_completion_support", "PROVEN_SUPPORT"),
  ("dead_transition_support", "PROVEN_SUPPORT"),
  ("unfolding_correctness", "STATED")
]

/-- The crown lane's aggregate status as recorded in the graph. -/
def crownStatus : String := "PROVEN"

/-- The crown lane's status is pinned to a literal here, independently of
the data-templated `crownStatus` def above: this `rfl` only type-checks
when the catalog-derived value equals the literal this template hardcodes,
so silently drifting the catalog value (up OR down) without a deliberate
edit to THIS template is refused at `lake build` time, not merely rendered
over. The crown equivalence obligation itself must carry the same status.
As of this render the crown lane has been promoted to PROVEN: the crown
equivalence (`ProcInt.WfNet.sound_iff_shortCircuit_live_bounded`, van der
Aalst 1997, Lemma 8 / Theorem 11) is a kernel-admitted, axiom-audited
theorem, not merely a stated obligation. -/
theorem crown_status_promoted :
    crownStatus = "PROVEN" ∧
    (crownObligations.filter (fun o => o.1 == "sound_iff_shortCircuit_live_bounded")
      |>.all (fun o => o.2 == "PROVEN")) = true := by
  exact ⟨rfl, rfl⟩

end ProcInt.Release

/-! ## Self-audit: the post-release witness is axiom-pure. -/

/-- info: 'ProcInt.Release.packets_never_self_actuate' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Release.packets_never_self_actuate

/-- info: 'ProcInt.Release.crown_status_promoted' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Release.crown_status_promoted
