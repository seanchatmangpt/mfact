-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Petri.Net

Place/transition Petri nets with weighted arcs encoded as finitely supported pre/post multisets, and markings as finitely supported token counts (Murata 1989, Petri Nets: Properties, Analysis and Applications, Proc. IEEE 77(4), section II; the Finsupp marking unifies weighted and colored presentations). -/

namespace ProcInt

/-- A place/transition Petri net (Murata 1989, section II): places P,
transitions T, with pre- and post-incidence given as finitely supported
multisets of places per transition (arc weights encoded in the
multiplicities). -/
structure PetriNet (P : Type) (T : Type) where
  pre  : T → (P →₀ ℕ)
  post : T → (P →₀ ℕ)

/-- A marking assigns finitely many tokens to each place (Murata 1989):
a finitely supported function P →₀ ℕ. -/
abbrev Marking (P : Type) := P →₀ ℕ


end ProcInt
