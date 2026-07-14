import Mfact
import Lean.Data.Json

open Lean Mfact

def mfactVersion : String := "26.7.13"

def usage : String := String.intercalate "\n" [
  "mfact — Lean 4 mathematical manufacturing CLI",
  "usage:",
  "  mfact version                    print version",
  "  mfact manifest <path>            parse+validate a release manifest, echo canonical JSON",
  "  mfact certify <manifest> <gates> assemble a certified release; exit 0 iff all gates pass",
  "exit codes: 0 ok · 1 gate failure · 2 typed refusal (malformed input)"]

/-- Parse a JSON file into `α`, with a typed refusal message on failure. -/
def parseFile (α : Type) [FromJson α] (path : String) : IO (Except String α) := do
  try
    let contents ← IO.FS.readFile path
    match Json.parse contents with
    | .error e => return .error s!"refusal: malformed JSON in {path}: {e}"
    | .ok j =>
      match fromJson? (α := α) j with
      | .error e => return .error s!"refusal: schema mismatch in {path}: {e}"
      | .ok v => return .ok v
  catch e =>
    return .error s!"refusal: cannot read {path}: {e}"

structure GatesJson where
  sorryFree : Bool
  axiomsClean : Bool
  fixturesPass : Bool
  evidenceComplete : Bool
  deriving ToJson, FromJson

def GatesJson.toGateResults (g : GatesJson) : GateResults :=
  ⟨g.sorryFree, g.axiomsClean, g.fixturesPass, g.evidenceComplete⟩

def main (args : List String) : IO UInt32 := do
  match args with
  | ["version"] =>
    IO.println s!"mfact {mfactVersion}"
    return 0
  | ["manifest", path] =>
    match ← parseFile Manifest path with
    | .error e => IO.eprintln e; return 2
    | .ok m =>
      IO.println (toJson m).pretty
      return 0
  | ["certify", manifestPath, gatesPath] =>
    match ← parseFile Manifest manifestPath with
    | .error e => IO.eprintln e; return 2
    | .ok m =>
      match ← parseFile GatesJson gatesPath with
      | .error e => IO.eprintln e; return 2
      | .ok g =>
        let gates := g.toGateResults
        if gates.allPass then
          let _release : CertifiedRelease := ⟨m, gates⟩
          -- `no_valid_objection _release h` holds by construction here;
          -- the audited theorem is in Mfact.Objection.
          IO.println (toJson m).pretty
          IO.eprintln s!"certified: {m.release} (proven {m.provenCount}/{m.artifacts.length}, objection type uninhabited)"
          return 0
        else
          IO.eprintln s!"gate failure: sorryFree={gates.sorryFree} axiomsClean={gates.axiomsClean} fixturesPass={gates.fixturesPass} evidenceComplete={gates.evidenceComplete}"
          return 1
  | _ =>
    IO.eprintln usage
    return 2
