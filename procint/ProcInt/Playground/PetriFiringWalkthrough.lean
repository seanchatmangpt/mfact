-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

/-! # Playground: firing a toy "request → grant" Petri net

A worked instance of `ProcInt.PetriNet` (`ProcInt.Petri.Net`) and the firing
rule (`ProcInt.Petri.Firing`). `PetriNet.fire` is `noncomputable` (it goes
through `Finsupp` subtraction), so it cannot be `#eval`'d directly — instead
this file shows the two ledgered ways to reason about a fired marking:
computing it place-by-place, and citing the token-conservation identity
`PetriNet.fire_add_pre` directly. -/

namespace ProcInt.Playground

/-- Two places: a token waiting to be granted, and a token recording that
it was granted. -/
inductive Place where
  | requested
  | granted
  deriving DecidableEq, Fintype

/-- One transition: grant the request. -/
inductive Trans where
  | grant
  deriving DecidableEq, Fintype

/-- `grant` consumes one token from `requested` and produces one token in
`granted` — the smallest nontrivial place/transition net. -/
noncomputable def net : PetriNet Place Trans where
  pre  := fun _ => Finsupp.single .requested 1
  post := fun _ => Finsupp.single .granted 1

/-- One request pending, nothing granted yet. -/
noncomputable def initial : Marking Place := Finsupp.single .requested 1

/-- `grant` is enabled at `initial`: the one required `requested` token is
present. -/
example : net.Enabled initial .grant := by
  simp [PetriNet.Enabled, net, initial]

/-- Firing `grant` at `initial` moves the token from `requested` to
`granted`: the marking is now `granted ↦ 1`, `requested ↦ 0`. Computed
place-by-place from the definition of `fire`. -/
example : net.fire initial .grant = Finsupp.single .granted 1 := by
  apply Finsupp.ext
  intro p
  cases p <;> simp [PetriNet.fire, net, initial]

/-- The same firing, viewed via the ledgered token-conservation identity:
`fire M t + pre t = M + post t` (Murata 1989, section II.C), instantiated
at `initial`/`grant` without unfolding `fire` at all. -/
example :
    net.fire initial .grant + net.pre .grant = initial + net.post .grant :=
  net.fire_add_pre (by simp [PetriNet.Enabled, net, initial])

end ProcInt.Playground
