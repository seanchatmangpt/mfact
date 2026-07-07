-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-- A small order-handling trace over `ℕ`-coded activities:
`0` = submit, `1` = approve, `2` = ship. Each of submit/approve occurs
twice, ship occurs once. Used below to instantiate `ProcInt.DeclareConstraint`
and check `ProcInt.DeclareConstraint.Satisfies` (van der Aalst and Pesic,
DECLARE, 2006/2007). -/
def declareTrace : List ℕ := [0, 1, 2, 0, 1]

/-- `existence 0`: submit occurs at least once in `declareTrace`
(`ProcInt.DeclareTemplate.existence`, unary arity 1 per
`ProcInt.DeclareTemplate.arity`). -/
def existenceSubmit : DeclareConstraint ℕ :=
  { template := .existence, activation := 0, target := none }

example : existenceSubmit.Satisfies declareTrace := by
  simp only [existenceSubmit, declareTrace, DeclareConstraint.Satisfies]
  decide

/-- `absence 9`: an activity that never appears in `declareTrace`
(`ProcInt.DeclareTemplate.absence`). -/
def absenceUnused : DeclareConstraint ℕ :=
  { template := .absence, activation := 9, target := none }

example : absenceUnused.Satisfies declareTrace := by
  simp only [absenceUnused, declareTrace, DeclareConstraint.Satisfies]
  decide

/-- `exactlyOne 2`: ship occurs exactly once in `declareTrace`
(`ProcInt.DeclareTemplate.exactlyOne`). -/
def exactlyOneShip : DeclareConstraint ℕ :=
  { template := .exactlyOne, activation := 2, target := none }

example : exactlyOneShip.Satisfies declareTrace := by
  simp only [exactlyOneShip, declareTrace, DeclareConstraint.Satisfies]
  decide

/-- `response (0, 1)`: every submit is eventually followed by an approve
(`ProcInt.Response`, `ProcInt.DeclareTemplate.response`). -/
def responseSubmitApprove : DeclareConstraint ℕ :=
  { template := .response, activation := 0, target := some 1 }

example : responseSubmitApprove.Satisfies declareTrace := by
  simp only [responseSubmitApprove, declareTrace, DeclareConstraint.Satisfies, Response]
  decide

/-- `precedence (1, 2)`: ship is preceded by an earlier approve
(`ProcInt.Precedence`, `ProcInt.DeclareTemplate.precedence`). -/
def precedenceApproveShip : DeclareConstraint ℕ :=
  { template := .precedence, activation := 1, target := some 2 }

example : precedenceApproveShip.Satisfies declareTrace := by
  simp only [precedenceApproveShip, declareTrace, DeclareConstraint.Satisfies, Precedence]
  decide

/-- `succession (0, 1)`: submit/approve satisfy both response and
precedence simultaneously, so `Satisfies` reduces to their conjunction
(`ProcInt.DeclareTemplate.succession`, mirrors library theorem
`ProcInt.succession_imp_response`). -/
def successionSubmitApprove : DeclareConstraint ℕ :=
  { template := .succession, activation := 0, target := some 1 }

example : successionSubmitApprove.Satisfies declareTrace := by
  simp only [successionSubmitApprove, declareTrace, DeclareConstraint.Satisfies, Response,
    Precedence]
  decide

/-- `notCoexistence (3, 4)`: neither of two unrelated activities appears
in `declareTrace`, so they trivially never coexist
(`ProcInt.DeclareTemplate.notCoexistence`). -/
def notCoexistenceUnused : DeclareConstraint ℕ :=
  { template := .notCoexistence, activation := 3, target := some 4 }

example : notCoexistenceUnused.Satisfies declareTrace := by
  simp only [notCoexistenceUnused, declareTrace, DeclareConstraint.Satisfies]
  decide

-- Arity check for every template used above (`ProcInt.DeclareTemplate.arity`).
#eval existenceSubmit.template.arity
#eval responseSubmitApprove.template.arity

end ProcInt.Playground
