-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Lean
import Lean.Util.Sorry
import ProcInt.Playground.Swarm11
import ProcInt.Playground.Swarm11Tests
import ProcInt.Playground.SOC2.AuditFlow
import ProcInt.Playground.SOC2.AuditFlowViolation
import ProcInt.Playground.SOC2.ManufactureTenancyGap

open Lean
open ProcInt.Playground.Swarm11

/--
Audit receipt derived from the compiled `ProcInt.Playground.Swarm11` and
`ProcInt.Playground.Swarm11Tests` olean environments.

The counts are not handwritten metadata. `computeAudit` imports the compiled
modules and inspects `Environment.constants` directly — the same technique
this repo's other integrated packages self-reported via static text files
(STATIC_AUDIT.json, KERNEL_RECEIPT.md) that turned out wrong or unverifiable
on independent rebuild. This tool computes the same class of numbers from
the actual compiled environment instead.

Adapted from the delivered `Verifier.lean`, which audited only the library
module (`ProcInt`) despite also importing its test module (`ProcIntTests`)
at the file level — meaning the tests were built, but never counted toward
`sorryDeclarationCount`/`theoremCount`. Extended here to audit both.

A per-declaration name-listing diagnostic (which category flagged which
declaration, not just a count) was attempted and reproducibly segfaulted
the compiled executable — bisected across release/debug builds and stack
size limits without finding the trigger; even a single extra `List`
traversal derived from `declarations` alongside the existing `countWhere`
calls was enough in some configurations, not in others, with no
build-mode-dependent pattern. This is a genuine runtime-level anomaly at
this toolchain pin (leanprover/lean4:v4.31.0), not a defect in the counted
values below, and is out of scope for this integration to chase further.
Left as a known open question rather than shipped broken or silently
dropped.

**SOC2 extension (added alongside `StandingPathSOC2.lean`, same wave).** The Swarm11 crown's
`Crown.checks` fold below is unchanged. Additively, this file now also folds
`ProcInt.Playground.SOC2.AuditFlow.checks` and `ProcInt.Playground.SOC2.AuditFlowViolation.checks`
the identical `List (String × Bool)`-fold way `crownFailureCount` already folds
`Swarm11.Crown.checks` — a small, additive change, not a rewrite of the existing Swarm11
behavior.

**G53 closure wiring (this wave).** `ProcInt.Playground.SOC2.ManufactureTenancyGap.checks` is now
also folded into `soc2Checks` below, superseding the earlier note in this docstring that excluded
it as out-of-scope. `ManufactureTenancyGap.checks` was itself extended (same wave) with three
`repair-*` entries (`repair-positive-descent-legal`, `repair-positive-same-tenant`,
`repair-mismatched-hS-fails`) exercising `manufactureStep_tenant_pure_of_residue`'s positive
specialization (`positiveRepair_manufactureStep`) and the hypothesis-removal corollary
(`hypothesisRemoval_is_gap_witness`) — G53's repair theorems are now genuinely load-bearing in
`just swarm11-verify`'s exit code, not sitting in an unreferenced list. The pre-existing
`gap-*` entries (the soundness-gap counterexample itself) are folded in alongside them; both were
already `PROVEN`, so this is purely an aggregation change, no new proof content here.
This verifier remains hand-authored/Playground-exempt, not ggen-rendered, and is still never
consumed by standing, gates, or the manifest (see `justfile`'s `swarm11-verify`/`soc2-verify`
comments).
-/
structure AuditReceipt where
  declarationCount : Nat
  theoremCount : Nat
  definitionCount : Nat
  inductiveCount : Nat
  axiomCount : Nat
  unsafeCount : Nat
  partialCount : Nat
  sorryDeclarationCount : Nat
  crownCheckCount : Nat
  crownCheckFailureCount : Nat
  soc2CheckCount : Nat
  soc2CheckFailureCount : Nat
  deriving Repr

private def countWhere {α : Type}
    (values : List α) (predicate : α → Bool) : Nat :=
  values.foldl
    (fun count value => if predicate value then count + 1 else count)
    0

private def projectDeclaration
    (entry : Name × ConstantInfo) : Bool :=
  (`ProcInt.Playground.Swarm11).isPrefixOf entry.1 ||
    (`ProcInt.Playground.Swarm11Tests).isPrefixOf entry.1

private def constantHasSorry (info : ConstantInfo) : Bool :=
  info.type.hasSorry ||
    match info.value? true with
    | none => false
    | some value => value.hasSorry

/--
Compiler-synthesized recursive-function auxiliaries are named with a
trailing `_unsafe_rec` component and flag `ConstantInfo.isPartial = true`
at the compiled level even for ordinary, fully kernel-checked, structurally
recursive source definitions with no `partial` keyword — this is how Lean
4's code generator implements recursion over inductive types, not a sign
of unproven or incomplete work. Confirmed by diagnosis (via the Lean
interpreter, not a compiled binary — see the note on `computeAudit` about
why): all 6 `isPartial` declarations audited here are
`{Workflow.bind, Workflow.openHoles, Replay.replay,
instDecidableEqWorkflow.decEq, instBEqWorkflow.beq,
instReprWorkflow.repr}._unsafe_rec`, i.e. every one of them is this
compiler artifact, none is a real `partial def`. Excluded from the count
accordingly, so `AuditReceipt.ok` reflects actual proof debt.
-/
private def isCompilerSynthesizedRec (name : Name) : Bool :=
  match name with
  | .str _ "_unsafe_rec" => true
  | _ => false

private def crownFailureCount : Nat :=
  countWhere Crown.checks (fun check => !check.2)

/-- SOC2 extension: `AuditFlow.checks`, `AuditFlowViolation.checks`, and (G53 closure, this wave)
`ManufactureTenancyGap.checks` combined, folded the identical `crownFailureCount` way. See the
`AuditReceipt` docstring's "G53 closure wiring" note. -/
private def soc2Checks : List (String × Bool) :=
  ProcInt.Playground.SOC2.AuditFlow.checks ++ ProcInt.Playground.SOC2.AuditFlowViolation.checks ++
    ProcInt.Playground.SOC2.ManufactureTenancyGap.checks

private def soc2FailureCount : Nat :=
  countWhere soc2Checks (fun check => !check.2)

/--
Loads the compiled `ProcInt.Playground.Swarm11` and `...Swarm11Tests` modules
and derives the audit from the actual environment.

This is intentionally `unsafe` because Lean module loading is an IO/runtime
operation; the mathematical declarations being audited remain kernel checked.
-/
unsafe def computeAudit : IO AuditReceipt := do
  initSearchPath (← findSysroot)
  Lean.withImportModules
      #[{ module := `ProcInt.Playground.Swarm11 },
        { module := `ProcInt.Playground.Swarm11Tests }] {} fun environment => do
    let declarations :=
      environment.constants.toList.filter projectDeclaration
    pure {
      declarationCount := declarations.length
      theoremCount :=
        countWhere declarations (fun entry => entry.2.isTheorem)
      definitionCount :=
        countWhere declarations (fun entry => entry.2.isDefinition)
      inductiveCount :=
        countWhere declarations (fun entry => entry.2.isInductive)
      axiomCount :=
        countWhere declarations (fun entry => entry.2.isAxiom)
      unsafeCount :=
        countWhere declarations (fun entry => entry.2.isUnsafe)
      partialCount :=
        countWhere declarations (fun entry =>
          entry.2.isPartial && !isCompilerSynthesizedRec entry.1)
      sorryDeclarationCount :=
        countWhere declarations (fun entry => constantHasSorry entry.2)
      crownCheckCount := Crown.checks.length
      crownCheckFailureCount := crownFailureCount
      soc2CheckCount := soc2Checks.length
      soc2CheckFailureCount := soc2FailureCount
    }

private def AuditReceipt.ok (receipt : AuditReceipt) : Bool :=
  receipt.declarationCount != 0 &&
  receipt.theoremCount != 0 &&
  receipt.axiomCount == 0 &&
  receipt.unsafeCount == 0 &&
  receipt.partialCount == 0 &&
  receipt.sorryDeclarationCount == 0 &&
  receipt.crownCheckFailureCount == 0 &&
  receipt.soc2CheckFailureCount == 0

private def jsonBool (value : Bool) : String :=
  if value then "true" else "false"

-- `s!"{{ ... }}"` does not escape to a literal brace the way it does in
-- some other languages' string interpolation — this is genuinely how the
-- delivered source spelled it, and it is a parse error at this Lean
-- version (found while integrating; `{` inside `s!"..."` always opens an
-- interpolation hole and expects a term, not a literal). Built via plain
-- string concatenation instead, so the brace characters are never inside
-- an interpolation hole at all.
private def renderJson (receipt : AuditReceipt) : String :=
  "{\n" ++
  "  \"schema\": \"procint.swarm11verifier.v1\",\n" ++
  "  \"modules\": [\"ProcInt.Playground.Swarm11\", \"ProcInt.Playground.Swarm11Tests\"],\n" ++
  s!"  \"declarations\": {receipt.declarationCount},\n" ++
  s!"  \"theorems\": {receipt.theoremCount},\n" ++
  s!"  \"definitions\": {receipt.definitionCount},\n" ++
  s!"  \"inductives\": {receipt.inductiveCount},\n" ++
  s!"  \"axioms\": {receipt.axiomCount},\n" ++
  s!"  \"unsafeDeclarations\": {receipt.unsafeCount},\n" ++
  s!"  \"partialDeclarations\": {receipt.partialCount},\n" ++
  s!"  \"sorryDeclarations\": {receipt.sorryDeclarationCount},\n" ++
  s!"  \"crownChecks\": {receipt.crownCheckCount},\n" ++
  s!"  \"crownCheckFailures\": {receipt.crownCheckFailureCount},\n" ++
  s!"  \"soc2Checks\": {receipt.soc2CheckCount},\n" ++
  s!"  \"soc2CheckFailures\": {receipt.soc2CheckFailureCount},\n" ++
  s!"  \"admitted\": {jsonBool receipt.ok}\n" ++
  "}"

private def printCrownChecks : IO Unit := do
  for check in Crown.checks do
    IO.println s!"  {check.1}: {if check.2 then "PASS" else "FAIL"}"

/-- SOC2 extension: prints
`AuditFlow.checks ++ AuditFlowViolation.checks ++ ManufactureTenancyGap.checks`,
`printCrownChecks` style. -/
private def printSoc2Checks : IO Unit := do
  for check in soc2Checks do
    IO.println s!"  {check.1}: {if check.2 then "PASS" else "FAIL"}"

unsafe def main : IO UInt32 := do
  let receipt ← computeAudit
  let json := renderJson receipt
  IO.FS.createDirAll "artifacts"
  IO.FS.writeFile "artifacts/swarm11-verifier.json" json

  IO.println "PROCINT SWARM11 VERIFIER"
  IO.println "========================="
  IO.println s!"compiled declarations : {receipt.declarationCount}"
  IO.println s!"compiled theorems     : {receipt.theoremCount}"
  IO.println s!"compiled definitions  : {receipt.definitionCount}"
  IO.println s!"compiled inductives   : {receipt.inductiveCount}"
  IO.println s!"project axioms        : {receipt.axiomCount}"
  IO.println s!"unsafe declarations   : {receipt.unsafeCount}"
  IO.println s!"partial declarations  : {receipt.partialCount}"
  IO.println s!"sorry-bearing decls   : {receipt.sorryDeclarationCount}"
  IO.println "crown checks:"
  printCrownChecks
  IO.println "soc2 checks (AuditFlow ++ AuditFlowViolation ++ ManufactureTenancyGap):"
  printSoc2Checks
  IO.println s!"receipt: artifacts/swarm11-verifier.json"

  if receipt.ok then
    IO.println "STANDING: ALIVE"
    return 0
  else
    IO.eprintln "STANDING: REFUSED"
    return 1
