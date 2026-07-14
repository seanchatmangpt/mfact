import Lean

open Lean

def testJsonParse (s : String) : String :=
  match Json.parse s with
  | Except.ok j =>
    match j.getObjVal? "marking" with
    | Except.ok (Json.obj m) => "success"
    | _ => "no marking object"
  | Except.error e => "error: " ++ e

#eval testJsonParse "{\"marking\": {}}"
