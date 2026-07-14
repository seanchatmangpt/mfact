import Lean

open Lean

-- Let's check some properties of Json object
def test (j : Json) : IO Unit := do
  match j with
  | Json.obj o =>
    -- Let's see if we can convert it to list or map it
    -- #check o.toList
    -- #check o.fold
    pure ()
  | _ => pure ()
