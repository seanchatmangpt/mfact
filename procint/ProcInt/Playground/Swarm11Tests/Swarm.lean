-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Swarm11

namespace ProcInt.Playground.Swarm11Tests

open ProcInt.Playground.Swarm11
open ProcInt.Playground.Swarm11.Swarm

inductive Node where
  | alpha
  | beta
  deriving Repr, DecidableEq

inductive Capability where
  | plan
  | ship
  deriving Repr, DecidableEq

def hasCapability : Node → Capability → Prop
  | .alpha, .plan => True
  | .beta, .ship => True
  | _, _ => False

def requires : Capability → Prop
  | .plan => True
  | .ship => True

theorem both_cover :
    Covers {Node.alpha, Node.beta} hasCapability requires := by
  intro capability hRequired
  cases capability with
  | plan =>
      exact ⟨Node.alpha, by simp, trivial⟩
  | ship =>
      exact ⟨Node.beta, by simp, trivial⟩

end ProcInt.Playground.Swarm11Tests
