def parMap {α β : Type} (f : α → β) (xs : List α) : List β :=
  let tasks := xs.map (fun x => Task.spawn (fun _ => f x))
  tasks.map Task.get

#eval parMap (fun x => x + 1) [1, 2, 3]
