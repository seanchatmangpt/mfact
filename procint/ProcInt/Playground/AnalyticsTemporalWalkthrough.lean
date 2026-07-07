-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-! Worked instances over `ProcInt.Analytics.Temporal`, `.Streaming`,
`.Multiperspective`, and `.Prediction`. -/

-- A tiny order arrival, ship, deliver case with ℕ ticks
-- (exercises `ProcInt.TimedEvent`, `ProcInt.sojourn`, `ProcInt.HappensBefore`).
def orderEvent : TimedEvent String := ⟨"order", 0⟩
def shipEvent : TimedEvent String := ⟨"ship", 3⟩
def deliverEvent : TimedEvent String := ⟨"deliver", 10⟩

/-- The sojourn time from order to ship is 3 ticks (`ProcInt.sojourn`). -/
example : sojourn orderEvent shipEvent = 3 := rfl

/-- The sojourn time from ship to deliver is 7 ticks. -/
example : sojourn shipEvent deliverEvent = 7 := rfl

-- concrete evaluations of the same
#eval sojourn orderEvent shipEvent
#eval sojourn shipEvent deliverEvent

/-- `order` happens before `ship` (`ProcInt.HappensBefore`). -/
example : HappensBefore orderEvent shipEvent := by
  unfold HappensBefore orderEvent shipEvent
  decide

/-- Chaining `happensBefore_trans`: order before ship before deliver gives
order before deliver. -/
example : HappensBefore orderEvent deliverEvent :=
  happensBefore_trans
    (show HappensBefore orderEvent shipEvent by unfold HappensBefore orderEvent shipEvent; decide)
    (show HappensBefore shipEvent deliverEvent by unfold HappensBefore shipEvent deliverEvent; decide)

-- A temporal profile for the (order, ship) activity pair: mean 3 ticks, std 0
-- (`ProcInt.TemporalProfile`).
def orderShipProfile : TemporalProfile String :=
  ⟨("order", "ship"), 3, 0⟩

#eval orderShipProfile.avg

-- A size-2 sliding window of activity labels, built by pushing three events
-- through an initially empty window (`ProcInt.EventWindow`,
-- `ProcInt.EventWindow.empty`, `ProcInt.EventWindow.push`).
def win0 : EventWindow String 2 := EventWindow.empty String 2
def w1 : EventWindow String 2 := win0.push "order"
def w2 : EventWindow String 2 := w1.push "ship"
def w3 : EventWindow String 2 := w2.push "deliver"

-- oldest event ("order") has been evicted; window holds the two most recent
#eval w3.events

/-- The window never grows past its declared bound of 2, by the field proof
carried at every push (`ProcInt.push_bounded`). -/
example : w3.events.length ≤ 2 := w3.bounded

-- Streaming can run online (as events arrive) or offline (over a full log)
-- (`ProcInt.AnalysisContext`).
def liveContext : AnalysisContext := .online
def batchContext : AnalysisContext := .offline

#eval liveContext
#eval batchContext

-- A conformance-check score per perspective for one case, combined under the
-- uniform 1/4-each weighting (`ProcInt.combinedScore`, `ProcInt.uniformWeights`).
def perspectiveScore : ProcessPerspective → ℚ
  | .controlFlow => (9 : ℚ) / 10
  | .data => 4 / 5
  | .resource => 1
  | .time => 7 / 10

/-- Under uniform weights the combined score is exactly the mean of the four
per-perspective scores (`ProcInt.combinedScore_uniform`). -/
example : combinedScore uniformWeights perspectiveScore =
    (perspectiveScore .controlFlow + perspectiveScore .data +
      perspectiveScore .resource + perspectiveScore .time) / 4 :=
  combinedScore_uniform perspectiveScore

#eval combinedScore uniformWeights perspectiveScore

-- A predictive-monitoring problem over the two-event prefix [order, ship],
-- predicting remaining time within a 5-time-unit horizon
-- (`ProcInt.PredictionProblem`, `.prefixLen`, `.WellPosed`).
def remainingTimeProblem : PredictionProblem String :=
  ⟨["order", "ship"], .remainingTime, .timeUnits 5⟩

#eval remainingTimeProblem.prefixLen

/-- The two-event prefix is non-empty, so the problem is well-posed
(`ProcInt.PredictionProblem.WellPosed`). -/
example : remainingTimeProblem.WellPosed := by
  unfold PredictionProblem.WellPosed remainingTimeProblem
  decide

/-- Well-posedness gives a strictly positive prefix length
(`ProcInt.wellPosed_prefixLen_pos`). -/
example : 0 < remainingTimeProblem.prefixLen :=
  wellPosed_prefixLen_pos (by
    unfold PredictionProblem.WellPosed remainingTimeProblem
    decide)

end ProcInt.Playground
