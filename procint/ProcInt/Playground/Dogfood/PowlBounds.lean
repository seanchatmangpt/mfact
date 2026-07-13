-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Models.Powl
import ProcInt.MFW.Termination.CrownWellFounded
import ProcInt.Playground.Dogfood.Outcome

/-!
# POWL Hierarchy Boundedness, Rescued and Bridged (Operation Dogfood, Wave 4)

Pipeline:
`Powl (Models/Powl.lean) → layer-bounded expansion (rescued from the orphan
procint/test_expand.lean) → atom-layer measure → ManufactureStep witness →
CrownWellFounded termination`.

Crown law:
HTN-style hierarchical decomposition that spawns child layers strictly below the parent
preserves any layer bound (`expandLayer_bounds_strictly`), and one such refinement event
is literally one `ManufactureStep` on the layer-multiset crown state
(`powl_refinement_manufactureStep`) — so chains of admitted refinements terminate by
`no_infinite_productive_mfw_chain` (`MFW/Termination/CrownWellFounded.lean:66`). This
file is the first import edge joining the `Models/Powl` island to the `MFW/Termination`
island (audit finding: zero such edges existed).

Provenance:
`expandLayer`, `Bounded`, `Bounded.mono`, and `expandLayer_bounds_strictly` are rescued
from the orphan, never-built `procint/test_expand.lean` (tracked but outside every Lake
target — coverage audit C1 finding), re-elaborated against the current `Powl` at HEAD
rather than blindly copied. The orphan file is left untouched as historical scratch.

Preserves:
the layer bound across expansion; the untouched frontier remainder across a refinement
step; genericity over the atom type.

Excludes:
any PDDL→POWL preservation claim — this file is POWL-internal plus the obligation-measure
bridge; the preservation falsifier stays `MISSING` in the coverage report with this file
recorded as its first admitted fragment; any claim that a runtime engine's refinement
events satisfy `ManufactureStep` — that correspondence stays a consumer obligation
(`ManufactureDecrease.lean`'s own "Theorem boundary" note).

Standing:
kernel-proven theorems; the `AdmittedObligationOrder ℕ` instance is `local` (a carrier
can admit more than one admitted order — `ManufactureTenancyGap.lean:65` precedent).

Falsifier:
a strict refinement (`∀ a p, refine a = some p → Bounded layer (layer a) p`) whose
expansion violates the bound, or a refinement event whose layer multisets fail the
Dershowitz–Manna descent.

Downstream:
`Swarm11Verifier` (checks fold), `AxiomAuditDogfood`.

Claim ceiling: theorem; finite-domain for the demo checks.
-/

namespace ProcInt.Playground.Dogfood

open ProcInt
open ProcInt.MFW.Termination
open ProcInt.MFW.Residue

/-! ## Rescued from the orphan `procint/test_expand.lean` -/

/-- HTN-style hierarchical decomposition step: an atom either refines into a child POWL
layer or stays. Rescued from `test_expand.lean:10`. -/
def expandLayer {α : Type*} (refine : α → Option (Powl α)) : Powl α → Powl α
  | .atom a => match refine a with
    | some p => p
    | none => .atom a
  | .silent => .silent
  | .xor children => .xor (children.map (expandLayer refine))
  | .loop doP redoP => .loop (expandLayer refine doP) (expandLayer refine redoP)
  | .po children prec => .po (children.map (expandLayer refine)) prec

/-- A model is bounded by layer `n` when every atom's layer is strictly below `n`.
Rescued from `test_expand.lean:20`. -/
inductive Bounded {α : Type*} (layer : α → ℕ) (n : ℕ) : Powl α → Prop
  | atom (a : α) : layer a < n → Bounded layer n (.atom a)
  | silent : Bounded layer n .silent
  | xor (children : List (Powl α)) :
      (∀ c ∈ children, Bounded layer n c) → Bounded layer n (.xor children)
  | loop (doP redoP : Powl α) :
      Bounded layer n doP → Bounded layer n redoP → Bounded layer n (.loop doP redoP)
  | po (children : List (Powl α)) (prec : ℕ → ℕ → Prop) :
      (∀ c ∈ children, Bounded layer n c) → Bounded layer n (.po children prec)

/-- Bounds are monotone in the layer ceiling. Rescued from `test_expand.lean:27`. -/
theorem Bounded.mono {α : Type*} {layer : α → ℕ} {n m : ℕ} (h_le : n ≤ m) {p : Powl α}
    (h : Bounded layer n p) : Bounded layer m p := by
  induction h with
  | atom a hl => exact .atom a (Nat.lt_of_lt_of_le hl h_le)
  | silent => exact .silent
  | xor children _ ih => exact .xor children ih
  | loop doP redoP _ _ ihDo ihRedo => exact .loop _ _ ihDo ihRedo
  | po children prec _ ih => exact .po children prec ih

/-- **The rescued strict-bound theorem** (`test_expand.lean:38`): if refinement spawns
child layers bounded by the parent atom's own layer, expansion preserves every bound. -/
theorem expandLayer_bounds_strictly {α : Type*} {layer : α → ℕ}
    {refine : α → Option (Powl α)}
    (h_strict : ∀ a p, refine a = some p → Bounded layer (layer a) p)
    {n : ℕ} {p : Powl α} (h : Bounded layer n p) :
    Bounded layer n (expandLayer refine p) := by
  induction h with
  | atom a hl =>
      rw [expandLayer]
      cases h_ref : refine a with
      | none => exact .atom a hl
      | some p' =>
          have hb := h_strict a p' h_ref
          exact hb.mono (Nat.le_of_lt hl)
  | silent =>
      rw [expandLayer]
      exact .silent
  | xor children _ ih =>
      rw [expandLayer]
      refine .xor _ ?_
      intro c hc
      rw [List.mem_map] at hc
      rcases hc with ⟨c', hc', rfl⟩
      exact ih c' hc'
  | loop doP redoP _ _ ihDo ihRedo =>
      rw [expandLayer]
      exact .loop _ _ ihDo ihRedo
  | po children prec _ ih =>
      rw [expandLayer]
      refine .po _ _ ?_
      intro c hc
      rw [List.mem_map] at hc
      rcases hc with ⟨c', hc', rfl⟩
      exact ih c' hc'

/-! ## The island bridge: layer measure → ManufactureStep → termination -/

/-- The multiset of atom layers of a POWL model — the obligation measure the
Dershowitz–Manna machinery orders. -/
def atomLayers {α : Type*} (layer : α → ℕ) : Powl α → Multiset ℕ
  | .atom a => {layer a}
  | .silent => 0
  | .xor children => (children.map (atomLayers layer)).foldr (· + ·) 0
  | .loop doP redoP => atomLayers layer doP + atomLayers layer redoP
  | .po children _ => (children.map (atomLayers layer)).foldr (· + ·) 0

/-- Membership in a folded sum of multisets comes from some summand. -/
theorem mem_foldr_sum {β : Type*} {ms : List (Multiset β)} {m : β}
    (h : m ∈ ms.foldr (· + ·) 0) : ∃ s ∈ ms, m ∈ s := by
  induction ms with
  | nil => exact absurd h (Multiset.notMem_zero m)
  | cons head tail ih =>
      rcases Multiset.mem_add.mp h with h' | h'
      · exact ⟨head, List.mem_cons_self, h'⟩
      · obtain ⟨s, hs, hm⟩ := ih h'
        exact ⟨s, List.mem_cons_of_mem head hs, hm⟩

/-- A layer bound on the model is a strict bound on every member of its layer measure —
the descent clause of `ManufactureStep`, earned from `Bounded`. -/
theorem bounded_atomLayers_lt {α : Type*} {layer : α → ℕ} {n : ℕ} {p : Powl α}
    (h : Bounded layer n p) : ∀ m ∈ atomLayers layer p, m < n := by
  induction h with
  | atom a hl =>
      intro m hm
      rw [atomLayers, Multiset.mem_singleton] at hm
      exact hm ▸ hl
  | silent =>
      intro m hm
      rw [atomLayers] at hm
      exact absurd hm (Multiset.notMem_zero m)
  | xor children _ ih =>
      intro m hm
      rw [atomLayers] at hm
      obtain ⟨s, hs, hms⟩ := mem_foldr_sum hm
      rw [List.mem_map] at hs
      obtain ⟨c, hc, rfl⟩ := hs
      exact ih c hc m hms
  | loop doP redoP _ _ ihDo ihRedo =>
      intro m hm
      rw [atomLayers] at hm
      rcases Multiset.mem_add.mp hm with h' | h'
      · exact ihDo m h'
      · exact ihRedo m h'
  | po children prec _ ih =>
      intro m hm
      rw [atomLayers] at hm
      obtain ⟨s, hs, hms⟩ := mem_foldr_sum hm
      rw [List.mem_map] at hs
      obtain ⟨c, hc, rfl⟩ := hs
      exact ih c hc m hms

/-- The admitted obligation order on layer numbers. `local` deliberately: a carrier can
admit more than one admitted order (`ManufactureTenancyGap.lean:65` precedent), and this
file needs only the standard `ℕ` order. -/
local instance : AdmittedObligationOrder ℕ :=
  { (inferInstance : Preorder ℕ) with }

/-- **The bridge theorem.** One strict POWL refinement event — atom `a` replaced by a
child model whose atoms all sit strictly below `layer a` — is one `ManufactureStep`
(`MFW/Termination/ManufactureDecrease.lean:68`) on the layer-multiset crown state. The
witness triple is read directly off the refinement: resolved obligation `layer a`,
children `atomLayers layer child`, untouched remainder `common`; the descent clause is
`bounded_atomLayers_lt` applied to the strictness hypothesis. -/
theorem powl_refinement_manufactureStep {α : Type*} (layer : α → ℕ) (a : α)
    (child : Powl α) (hchild : Bounded layer (layer a) child)
    (common : Multiset ℕ) (s s' : CrownState ℕ)
    (hs : s.frontier = common + {layer a})
    (hs' : s'.frontier = common + atomLayers layer child) :
    ManufactureStep s s' :=
  ⟨layer a, atomLayers layer child, common, hs, hs', bounded_atomLayers_lt hchild⟩

/-- The payoff, consuming the Termination island: chains of admitted POWL refinements
terminate — `no_infinite_productive_mfw_chain` instantiated at the layer carrier `ℕ`. -/
theorem powl_refinement_chains_terminate :
    WellFounded (fun (s' s : CrownState ℕ) => ManufactureStep s s') :=
  no_infinite_productive_mfw_chain

/-! ## Concrete demo at the PDDL8 depth bound -/

/-- The demo child layer: an exclusive choice over two atoms at layers `1` and `2`. -/
def demoChild : Powl Nat := .xor [.atom 1, .atom 2]

/-- The demo child is bounded by its parent's layer `3`. -/
theorem demoChild_bounded : Bounded id 3 demoChild := by
  refine .xor _ ?_
  intro c hc
  rcases List.mem_cons.mp hc with rfl | hc
  · exact .atom 1 (by decide)
  · rcases List.mem_singleton.mp hc with rfl
    exact .atom 2 (by decide)

/-- The demo refinement: atom `3` decomposes into `demoChild`, everything else stays. -/
def demoRefine : Nat → Option (Powl Nat) := fun a =>
  if a = 3 then some demoChild else none

/-- The demo refinement is strict: it only ever spawns layers below the parent. -/
theorem demoRefine_strict : ∀ a p, demoRefine a = some p → Bounded id (id a) p := by
  intro a p h
  unfold demoRefine at h
  split at h
  · next heq =>
      injection h with h'
      subst heq
      exact h' ▸ demoChild_bounded
  · simp at h

/-- The rescued theorem instantiated at the PDDL8 depth bound: expanding a
depth-64-bounded workflow through the strict demo refinement stays depth-64-bounded. -/
theorem demo_expansion_bounded_at_depth :
    Bounded id MAX_PLAN_DEPTH (expandLayer demoRefine (.atom 3)) :=
  expandLayer_bounds_strictly demoRefine_strict (.atom 3 (by decide))

/-! ## Executable checks (folded into `swarm11-verify` at Wave 5) -/

/-- Standing-aware checks over the concrete demo data. -/
def powlChecks : List (String × Bool) := [
  ("powl-atom-layers-of-child",
    decide (atomLayers id demoChild = {1, 2})),
  ("powl-child-layers-strictly-below-parent",
    decide (∀ m ∈ atomLayers id demoChild, m < 3)),
  ("powl-refinement-frontier-before",
    decide ((({5, 3} : Multiset ℕ)) = ({5} : Multiset ℕ) + {3})),
  ("powl-refinement-frontier-after",
    decide ((({5, 1, 2} : Multiset ℕ)) = ({5} : Multiset ℕ) + atomLayers id demoChild)),
  ("powl-depth-bound-is-pddl8-mirror",
    MAX_PLAN_DEPTH == 64)
]

-- Build-time verification: every check passes at elaboration.
#guard powlChecks.all (·.2)

end ProcInt.Playground.Dogfood
