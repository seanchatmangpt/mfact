-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-- A concrete `concept:name` attribute, exercising `ProcInt.XesAttribute` with
a `ProcInt.XesValue.str` payload (IEEE 1849-2016 `concept:name`). -/
def conceptNameAttr : XesAttribute :=
  { key := "concept:name", value := .str "Register Order" }

/-- A concrete `time:timestamp` attribute, exercising `ProcInt.XesAttribute`
with a `ProcInt.XesValue.timestamp` payload. -/
def timestampAttr : XesAttribute :=
  { key := "time:timestamp", value := .timestamp 1700000000 }

/-- A concrete `cost:amount`-style attribute, exercising `ProcInt.XesAttribute`
with a `ProcInt.XesValue.int` payload (negative integers are valid XES ints). -/
def costAttr : XesAttribute :=
  { key := "cost:amount", value := .int (-42) }

/-- A concrete boolean attribute, exercising `ProcInt.XesAttribute` with a
`ProcInt.XesValue.bool` payload. -/
def urgentAttr : XesAttribute :=
  { key := "case:urgent", value := .bool true }

-- Field access on a concrete `XesAttribute` literal.
#eval conceptNameAttr.key

/-- The standard event classifier keying on `concept:name` and
`lifecycle:transition`, exercising `ProcInt.XesClassifier`
(IEEE 1849-2016 §7.2, the classic "MXML Legacy Classifier"-style key list). -/
def standardClassifier : XesClassifier :=
  { name := "Standard Classifier", keys := ["concept:name", "lifecycle:transition"] }

#eval standardClassifier.keys

/-- Worked instance of the round-trip law `XesLifecycleTransition.parse_asString`
for the `.complete` transition: printing then parsing `.complete` recovers
`.complete`. -/
example : XesLifecycleTransition.parse XesLifecycleTransition.complete.asString
    = some .complete :=
  XesLifecycleTransition.parse_asString .complete

-- Direct evaluation of the same round trip, plus the canonical string itself
-- (mapped through `asString` since `XesLifecycleTransition` has no `Repr`).
#eval XesLifecycleTransition.complete.asString
#eval (XesLifecycleTransition.parse XesLifecycleTransition.complete.asString).map
  XesLifecycleTransition.asString

/-- Worked instance of `XesLifecycleTransition.asString_injective`: the
distinct transitions `.start` and `.suspend` have distinct canonical strings. -/
example : XesLifecycleTransition.start.asString ≠ XesLifecycleTransition.suspend.asString := by
  intro h
  have := XesLifecycleTransition.asString_injective h
  simp at this

/-- Worked instance of `XesLifecycleTransition.asString_parse`: parsing the
literal string `"withdraw"` yields `.withdraw`, matching its own `asString`. -/
example : XesLifecycleTransition.withdraw.asString = "withdraw" :=
  XesLifecycleTransition.asString_parse (t := .withdraw) (by rfl)

end ProcInt.Playground
