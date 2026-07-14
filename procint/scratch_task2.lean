def parMap {α β : Type} (f : α → β) (xs : List α) : List β :=
  let tasks := xs.map (fun x => Task.spawn (fun _ => f x))
  tasks.map Task.get

def test (xs : List Nat) : List Nat :=
  parMap (fun x => x + 1) xs
