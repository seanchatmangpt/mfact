import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Petri.Covering
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

theorem WfNet.sound_iff_shortCircuit_live_bounded {P T : Type} [DecidableEq P] [Finite T]
    (W : WfNet P T) : W.sound_iff_shortCircuit_live_bounded_statement := by
  haveI := Fintype.ofFinite T
  unfold WfNet.sound_iff_shortCircuit_live_bounded_statement
  exact ⟨fun h => ⟨WfNet.live_of_sound h, WfNet.bounded_of_sound h⟩,
    fun ⟨hl, hb⟩ => WfNet.sound_of_live_bounded hl hb⟩

end ProcInt

#print axioms ProcInt.WfNet.sound_iff_shortCircuit_live_bounded
