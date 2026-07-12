-- RENDERED by `ggen sync` from the post-release graph (post-release-pack).
-- Candidate Lean: admitted only by `lake build PostRelease`.
-- ggen renders; Lean admits; mfact certifies.
import Mathlib
import ProcInt

/-! # Post-release witness — v26.7.7

A finite, kernel-checked witness over the publication packet: no actuation
packet self-actuates (publication is pending external actuation in every
case, however ALIVE the packet's requirements), and the crown research
lane's status is pinned to the catalog-derived value the template author
last confirmed. The lists below are
rendered from the same graph as `release/FINAL_STATUS.md`; a render in
which either law fails makes the corresponding `rfl` proof false and the
kernel refuses this file. These two `rfl`/`decide` witnesses certify
data-template self-consistency only — see the per-theorem docstrings below
for exactly what each one does and does not check — and are separately
coupled, below, to the live status of the underlying kernel-admitted
theorem the crown obligation names. -/

namespace ProcInt.Release

/-- Packet identity of the post-release graph this witness was rendered from. -/
def postReleasePacketHash : String :=
  "7668066273cdb51ef00e037e3ca1dda844fce44de3683e1bf31def1cd4ac07ec"

/-- Actuation packets: (packet id, packet status, publication field). -/
def actuationPackets : List (String × String × String) := [
  ("arxiv_upload", "BLOCKED", "PENDING_EXTERNAL_ACTUATION"),
  ("github_push", "BLOCKED", "PENDING_EXTERNAL_ACTUATION"),
  ("github_release", "ALIVE", "PENDING_EXTERNAL_ACTUATION")
]

/-- `rfl` decides that every triple rendered into `actuationPackets` above
carries `"PENDING_EXTERNAL_ACTUATION"` in its third (publication) field —
a closed check over this file's own hardcoded list, evaluated by the
kernel. It certifies that the render did not drop the invariant while
projecting the graph into this list; it is not itself evidence that any
real actuation system honors the field (that is an external-system
property, outside what a Lean witness can observe). -/
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

/-- Both conjuncts are `rfl`/`decide` over string/list literals hardcoded
in THIS template: the first checks `crownStatus` (the data-templated def
above) against the literal `"PROVEN"` this template author last confirmed,
so silently drifting the catalog value (up OR down) without a deliberate
edit to THIS template is refused at `lake build` time; the second checks
that `crownObligations` (also data-templated above) records the same
`"PROVEN"` status for the `sound_iff_shortCircuit_live_bounded` obligation
by name. Neither conjunct inspects any proof term — a template that hardcoded
`"PROVEN"` next to a `sorry`-backed theorem would still pass this `rfl`. The
obligation's live, kernel-checked, sorry-free status is what the real
theorem `ProcInt.WfNet.sound_iff_shortCircuit_live_bounded` (van der Aalst
1997, Lemma 8 / Theorem 11) exists to establish; the self-audit block below
names that declaration directly, so a `sorry` on it — not merely a stale
catalog string — makes this file's own build fail. -/
theorem crown_status_promoted :
    crownStatus = "PROVEN" ∧
    (crownObligations.filter (fun o => o.1 == "sound_iff_shortCircuit_live_bounded")
      |>.all (fun o => o.2 == "PROVEN")) = true := by
  exact ⟨rfl, rfl⟩

end ProcInt.Release

/-! ## Self-audit: the post-release witness's own claims are axiom-pure,
and the crown obligation the catalog names as `"PROVEN"` is the real,
currently-admitted, sorry-free theorem — not merely a string this template
hardcodes next to it. -/

/-- info: 'ProcInt.Release.packets_never_self_actuate' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Release.packets_never_self_actuate

/-- info: 'ProcInt.Release.crown_status_promoted' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Release.crown_status_promoted

/-! The `crown_status_promoted` data-template check above is only sound
while the obligation it names is still a real, kernel-admitted theorem: if
`ProcInt.WfNet.sound_iff_shortCircuit_live_bounded` were ever replaced by
`sorry`, this `#guard_msgs` would observe `sorryAx` in its axiom set,
mismatch the pinned message below, and refuse this file at `lake build`
time — coupling the crown obligation's catalog string to its live proof
term, not merely to itself. -/

/-- info: 'ProcInt.WfNet.sound_iff_shortCircuit_live_bounded' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.WfNet.sound_iff_shortCircuit_live_bounded
