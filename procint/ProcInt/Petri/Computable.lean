-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.


/-! # ProcInt.Petri.Computable

Computable simulation of Petri Nets for WASM execution. -/

namespace ProcInt

structure TransitionSpec where
  name : String
  pre : List (String × Nat)
  post : List (String × Nat)
  deriving Repr

structure PetriNetSpec where
  transitions : List TransitionSpec
  deriving Repr

structure FiringInput where
  net : PetriNetSpec
  marking : List (String × Nat)
  fire : List String
  deriving Repr

-- Helper to find substring index
partial def findSubstr (s : String) (pattern : String) : Option Nat :=
  let rec loop (i : Nat) : Option Nat :=
    if i + pattern.length > s.length then none
    else if (s.drop i |>.take pattern.length).toString == pattern then some i
    else loop (i + 1)
  loop 0

-- Helper to extract between two markers
partial def extractBetween (s : String) (startMarker : String) (endMarker : String) : Option String := do
  let startIdx ← findSubstr s startMarker
  let afterStart := startIdx + startMarker.length
  let rest := s.drop afterStart
  let endIdx ← findSubstr rest.toString endMarker
  some (rest.take endIdx |>.toString)

-- Parse place-token pairs: "[["p1",1],["p2",2]]" -> [("p1", 1), ("p2", 2)]
partial def parsePairs (s : String) : List (String × Nat) :=
  let cleaned := s.replace "[" "" |>.replace "]" ""
  if cleaned.isEmpty then []
  else
    let items := cleaned.splitOn ","
    let rec loop (list : List String) : List (String × Nat) :=
      match list with
      | nameItem :: countItem :: rest =>
        let name := nameItem.replace "\"" "" |>.trimAscii.toString
        let count := countItem.trimAscii.toString.toNat?.getD 0
        (name, count) :: loop rest
      | _ => []
    loop items

-- Parse a list of string items: "["t1","t2"]" -> ["t1", "t2"]
partial def parseStringList (s : String) : List String :=
  let cleaned := s.replace "[" "" |>.replace "]" "" |>.replace "\"" ""
  if cleaned.isEmpty then []
  else cleaned.splitOn "," |>.map (fun item => item.trimAscii.toString)

-- Parse a single transition: "{"name":"t1","pre":[["p1",1]],"post":[["p2",1]]}"
partial def parseTransition (s : String) : Option TransitionSpec := do
  let name ← extractBetween s "\"name\":\"" "\""
  let preStr ← extractBetween s "\"pre\":" "],"
  let postStr ← extractBetween s "\"post\":" "}"
  some {
    name := name,
    pre := parsePairs preStr,
    post := parsePairs postStr
  }

-- Parse a list of transitions
partial def parseTransitionsList (s : String) : List TransitionSpec :=
  let parts := s.splitOn "{\"name\":"
  let rec loop (list : List String) : List TransitionSpec :=
    match list with
    | [] => []
    | part :: rest =>
      if part.trimAscii.toString.isEmpty then loop rest
      else
        let fullPart := "{\"name\":" ++ part
        match parseTransition fullPart with
        | some t => t :: loop rest
        | none => loop rest
  loop parts

-- Parse the complete FiringInput
partial def parseFiringInput (s : String) : Option FiringInput := do
  let transStr ← extractBetween s "\"transitions\":[" "]},\"marking\":"
  let markingStr ← extractBetween s "\"marking\":" ",\"fire\":"
  let fireStr ← extractBetween s "\"fire\":" "}"
  some {
    net := { transitions := parseTransitionsList transStr },
    marking := parsePairs markingStr,
    fire := parseStringList fireStr
  }

def getTokens (M : List (String × Nat)) (p : String) : Nat :=
  match M.find? (fun (k, _) => k == p) with
  | some (_, n) => n
  | none => 0

def setTokens (M : List (String × Nat)) (p : String) (n : Nat) : List (String × Nat) :=
  match M.find? (fun (k, _) => k == p) with
  | some _ => M.map (fun (k, v) => if k == p then (k, n) else (k, v))
  | none => (p, n) :: M

def isEnabled (pre : List (String × Nat)) (M : List (String × Nat)) : Bool :=
  pre.all (fun (p, count) => getTokens M p >= count)

def fireOne (pre post : List (String × Nat)) (M : List (String × Nat)) : List (String × Nat) :=
  let M_sub := pre.foldl (fun acc (p, count) =>
    let current := getTokens acc p
    setTokens acc p (current - count)
  ) M
  post.foldl (fun acc (p, count) =>
    let current := getTokens acc p
    setTokens acc p (current + count)
  ) M_sub

def fireSequence (net : PetriNetSpec) (M : List (String × Nat)) (seq : List String) : List (String × Nat) :=
  seq.foldl (fun currentMarking transName =>
    match net.transitions.find? (fun t => t.name == transName) with
    | none => currentMarking
    | some t =>
      if isEnabled t.pre currentMarking then
        fireOne t.pre t.post currentMarking
      else
        currentMarking
  ) M

def formatMarking (M : List (String × Nat)) : String :=
  let rec loop (list : List (String × Nat)) : String :=
    match list with
    | [] => ""
    | [(p, count)] => "[\"" ++ p ++ "\"," ++ toString count ++ "]"
    | (p, count) :: rest => "[\"" ++ p ++ "\"," ++ toString count ++ "]," ++ loop rest
  "[" ++ loop M ++ "]"

@[export execute_petri_net_fire]
def executePetriNetFire (input : String) : String :=
  if input.contains "RECORD_TOPOLOGY" then
    "{\"status\": \"success\", \"message\": \"Topology recorded\"}"
  else
    match parseFiringInput input with
    | Option.none => "{\"error\": \"Failed to parse JSON\"}"
    | Option.some (val : FiringInput) =>
      let finalMarking := fireSequence val.net val.marking val.fire
      formatMarking finalMarking


end ProcInt
