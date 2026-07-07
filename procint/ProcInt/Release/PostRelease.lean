-- RENDERED by `ggen sync` from the post-release graph (post-release-pack).
-- Candidate Lean: admitted only by `lake build PostRelease`.
-- ggen renders; Lean admits; mfact certifies.

/-! # Post-release witness — v26.7.6

A finite, kernel-checked witness over the publication packet: no actuation
packet self-actuates (publication is pending external actuation in every
case, however ALIVE the packet's requirements), and the crown research
theorem is never silently promoted past STATED. The lists below are
rendered from the same graph as `release/FINAL_STATUS.md`; a render in
which either law fails makes the corresponding `rfl` proof false and the
kernel refuses this file. -/

namespace ProcInt.Release

/-- Packet identity of the post-release graph this witness was rendered from. -/
def postReleasePacketHash : String :=
  "9c787499b845d2dcbe4212ac416f3469f0849b187bfcf80b21bf60d2313ada29"

/-- Actuation packets: (packet id, packet status, publication field). -/
def actuationPackets : List (String × String × String) := [
  ("arxiv_upload", "ALIVE", "PENDING_EXTERNAL_ACTUATION"),
  ("github_push", "BLOCKED", "PENDING_EXTERNAL_ACTUATION"),
  ("github_release", "ALIVE", "PENDING_EXTERNAL_ACTUATION")
]

/-- No packet self-actuates: every packet's publication field is
`PENDING_EXTERNAL_ACTUATION`, regardless of its ALIVE/BLOCKED status. -/
theorem packets_never_self_actuate :
    actuationPackets.all (fun p => p.2.2 == "PENDING_EXTERNAL_ACTUATION") = true := by rfl

/-- Crown research lane: (obligation name, catalog-derived status). -/
def crownObligations : List (String × String) := [
  ("sound_iff_shortCircuit_live_bounded", "STATED"),
  ("proper_completion_support", "PROVEN_SUPPORT"),
  ("dead_transition_support", "PROVEN_SUPPORT"),
  ("unfolding_correctness", "STATED")
]

/-- The crown lane's aggregate status as recorded in the graph. -/
def crownStatus : String := "STATED"

/-- STATED is never silently promoted: the crown lane stands at STATED and
the crown equivalence obligation itself is recorded as STATED. Promoting
either requires the catalog to change, which re-renders this witness. -/
theorem crown_not_promoted :
    crownStatus = "STATED" ∧
    (crownObligations.filter (fun o => o.1 == "sound_iff_shortCircuit_live_bounded")
      |>.all (fun o => o.2 == "STATED")) = true := by
  exact ⟨rfl, rfl⟩

end ProcInt.Release

/-! ## Self-audit: the post-release witness is axiom-pure. -/

/-- info: 'ProcInt.Release.packets_never_self_actuate' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Release.packets_never_self_actuate

/-- info: 'ProcInt.Release.crown_not_promoted' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Release.crown_not_promoted
