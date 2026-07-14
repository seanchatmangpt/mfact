import Lean.Elab.Command
import Lean.Linter.Basic
import Lean.Parser.Command

open Lean Elab Command Linter Meta

namespace MfactLinter

register_option linter.mfact.rigor : Bool := {
  defValue := true
  descr := "enable the mfact native rigor linter"
}

/-- Helper to recursively search Syntax for specific identifiers or atoms -/
def syntaxContainsWord (stx : Syntax) (words : List String) : Bool :=
  match stx.find? fun s =>
    (s.isIdent && words.any (·.toLower == s.getId.toString.toLower)) ||
    (s.isAtom && words.any (·.toLower == s.getAtomVal.toLower))
  with
  | some _ => true
  | none => false

/-- Check if an Expr contains a reference to sorryAx -/
partial def exprContainsSorry (e : Expr) : Bool :=
  match e with
  | .const name _ => name == ``sorryAx
  | .app f a      => exprContainsSorry f || exprContainsSorry a
  | .lam _ _ b _  => exprContainsSorry b
  | .forallE _ _ b _ => exprContainsSorry b
  | .letE _ _ v b _  => exprContainsSorry v || exprContainsSorry b
  | .mdata _ b       => exprContainsSorry b
  | .proj _ _ b      => exprContainsSorry b
  | _             => false

/-- Check if an Expr contains any branching/comparison constants -/
partial def exprHasMechanism (e : Expr) : Bool :=
  match e with
  | .const name _ =>
    let nameStr := name.toString
    nameStr.contains "dite" || nameStr.contains "ite" || nameStr.contains "casesOn" ||
    nameStr.contains "rec" || nameStr.contains "beq" || nameStr.contains "ne" ||
    nameStr.contains "lt" || nameStr.contains "gt" || nameStr.contains "le" || nameStr.contains "ge"
  | .app f a      => exprHasMechanism f || exprHasMechanism a
  | .lam _ _ b _  => exprHasMechanism b
  | .forallE _ _ b _ => exprHasMechanism b
  | .letE _ _ v b _ => exprHasMechanism v || exprHasMechanism b
  | .mdata _ b       => exprHasMechanism b
  | .proj _ _ b      => exprHasMechanism b
  | _             => false

/-- Find all declaration commands recursively in the module syntax -/
partial def findDeclCommands (stx : Syntax) : Array Syntax :=
  match stx with
  | s@(.node _ kind args) =>
    if kind == ``Lean.Parser.Command.declaration ||
       kind == ``Lean.Parser.Command.structure ||
       kind == ``Lean.Parser.Command.inductive then
      #[s]
    else
      args.flatMap findDeclCommands
  | _ => #[]

/-- The native rigor linter -/
def rigorLinter : Linter where run := fun stx => do
  unless getLinterValue linter.mfact.rigor (← getLinterOptions) do
    return
  if (← get).messages.hasErrors then
    return

  let env ← getEnv
  let fm ← getFileMap

  -- 1. Empty File / Hello-Stub check (G14)
  if stx.isOfKind ``Lean.Parser.Module.module then
    let header := stx[0]
    let cmds := stx[1].getArgs
    let imports := header[1].getArgs
    Linter.logLint linter.mfact.rigor stx s!"DEBUG header kind: {header.getKind}, numArgs: {header.getNumArgs}"
    for i in [0:header.getNumArgs] do
      Linter.logLint linter.mfact.rigor stx s!"DEBUG header[{i}] kind: {header[i].getKind}, numArgs: {header[i].getNumArgs}, stx: {header[i]}"
    if cmds.isEmpty && imports.isEmpty then
      Linter.logLint linter.mfact.rigor stx "Empty `.lean` file detected. Libraries must contain actual content."
      return
    if cmds.size == 1 && syntaxContainsWord cmds[0]! ["hello"] then
      Linter.logLint linter.mfact.rigor stx "Hello-stub file detected. Stub code must be replaced."
      return

  -- Traverse all declaration commands
  for cmd in findDeclCommands stx do
    -- Find declModifiers to check docstring
    let mods? := cmd.getArgs.find? fun arg => arg.isOfKind ``Lean.Parser.Command.declModifiers
    let mut hasDocString := false
    let mut docLower := ""
    let mut docStx? : Option Syntax := none

    if let some mods := mods? then
      let docOpt := mods[0]
      if docOpt.getNumArgs > 0 then
        let docStx := docOpt[0]
        unless docStx.isMissing do
          let docString ← try getDocStringText ⟨docStx⟩ catch _ => pure ""
          docLower := docString.toLower
          hasDocString := true
          docStx? := some docStx

          -- 2. Forbidden Sci-Fi Vocabulary Check
          let sciFiTerms := ["warp drive", "bekenstein bound", "heat death", "subkolmogorov", "quantum blocker"]
          for term in sciFiTerms do
            if docLower.contains term then
              Linter.logLint linter.mfact.rigor docStx s!"Forbidden sci-fi vocabulary detected in docstring: '{term}'."

          -- 3. Universal LLM Hedge Comments & Mocks Check
          let hedgeTerms := ["in a real implementation", "for now", "todo: implement", "mock", "dummy"]
          for term in hedgeTerms do
            if docLower.contains term then
              Linter.logLint linter.mfact.rigor docStx s!"Hedge comment or mock language detected: '{term}'."

    -- Find declId to check the declaration itself
    if let some declId := cmd.find? fun arg => arg.isOfKind ``Lean.Parser.Command.declId then
      let localId := declId[0]
      let localName := localId.getId
      let fullName := (← getCurrNamespace) ++ localName

      -- Retrieve declaration info from environment
      let info? := match env.find? fullName with
        | some info => some info
        | none => env.find? localName
      if let some info := info? then
        -- 4. Unproved Theorem / sorry check
        let hasSorry := (info.value?.map exprContainsSorry).getD false || exprContainsSorry info.type
        if hasSorry then
          Linter.logLint linter.mfact.rigor localId "Unproved theorem containing `sorry` detected. All proofs must be mechanically verified."

        -- 5. Claim-without-Mechanism Check
        if hasDocString then
          let claimKeywords := ["statically", "enforced", "verified", "proven", "guarantee", "rejects", "borrow checker"]
          if claimKeywords.any (docLower.contains ·) then
            if let some val := info.value? then
              unless exprHasMechanism val do
                if let some docStx := docStx? then
                  Linter.logLint linter.mfact.rigor docStx
                    s!"Claim-without-mechanism in '{fullName}': docstring uses enforcement language but body lacks branching or comparisons."

      -- 6. Dead alternative names check
      let localNameStr := localName.toString
      if localNameStr.endsWith "_v2" || localNameStr.endsWith "_alt" ||
         localNameStr.endsWith "_correct" || localNameStr.endsWith "_fixed" ||
         localNameStr.endsWith "_working" then
        Linter.logLint linter.mfact.rigor localId s!"Dead alternative name pattern detected in '{localName}'."

initialize addLinter rigorLinter

end MfactLinter
