-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11

namespace ProcInt.Playground.Swarm11Tests

open ProcInt.Playground.Swarm11
open ProcInt.Playground.Swarm11.Supply

inductive Material where
  | raw
  | product
  deriving Repr, DecidableEq, Fintype

inductive Activity where
  | convert
  deriving Repr, DecidableEq

def matrix : Stoichiometry Material Activity where
  coeff
    | .raw, .convert => -1
    | .product, .convert => 1

def inventory : Inventory Material
  | .raw => 10
  | .product => 2

theorem convert_conservative :
    ConservativeAt matrix Activity.convert := by
  unfold ConservativeAt
  decide

example :
    total (applyActivity matrix Activity.convert 3 inventory) =
      total inventory := by
  exact total_applyActivity_of_conservative
    matrix Activity.convert inventory 3 convert_conservative

end ProcInt.Playground.Swarm11Tests
