-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net

/-! # ProcInt.Petri.Unfolding

Petri net unfoldings (Murata 1989 Section VII; Engelfriet 1991 branching processes; McMillan 1992 finite complete prefixes): occurrence nets over condition and event types with a bipartite flow relation on C ⊕ E, causality as its transitive closure, acyclicity and no-backward-conflict axioms, branching processes as labeled occurrence nets, and unfolding prefixes with cut-off event sets. Small lemmas (flow embeds in causality, causality transitive, flow irreflexive by bipartiteness, acyclicity forbids self-flow) are proven; the full unfolding homomorphism condition is stated. Ported from Condition/Event/BranchingProcess/UnfoldingPrefix in wasm4pm-compat src/petri.rs. -/

namespace ProcInt

/-- Occurrence-net shape underlying a branching process: conditions C (place instances) and
events E (transition occurrences) with pre/post condition sets (Murata 1989 Section VII;
McMillan 1992; Engelfriet 1991 branching processes). Ported from Condition / Event /
BranchingProcess in wasm4pm-compat petri.rs. -/
structure OccurrenceNet (C E : Type) where
  preC : E → Set C
  postC : E → Set C

/-- The immediate flow relation on nodes (conditions ⊕ events): condition-to-event via preC,
event-to-condition via postC; never condition-condition or event-event (bipartiteness of
occurrence nets, Murata 1989 Section VII). -/
def OccurrenceNet.Flow {C E : Type} (O : OccurrenceNet C E) :
    (C ⊕ E) → (C ⊕ E) → Prop
  | Sum.inl c, Sum.inr e => c ∈ O.preC e
  | Sum.inr e, Sum.inl c => c ∈ O.postC e
  | _, _ => False

/-- Causality: the transitive closure of the flow relation (Engelfriet 1991, the strict
causal order of an occurrence net). -/
def OccurrenceNet.Causality {C E : Type} (O : OccurrenceNet C E) :
    (C ⊕ E) → (C ⊕ E) → Prop :=
  Relation.TransGen O.Flow

/-- The occurrence relation is acyclic: no node causally precedes itself
(Murata 1989 Section VII: occurrence nets are acyclic). -/
def OccurrenceNet.Acyclic {C E : Type} (O : OccurrenceNet C E) : Prop :=
  ∀ n, ¬ O.Causality n n

/-- No backward conflict: each condition has at most one producing event (occurrence-net
axiom, Engelfriet 1991 Def. 2.3 / Murata 1989: conditions are unbranched on input). -/
def OccurrenceNet.NoBackwardConflict {C E : Type} (O : OccurrenceNet C E) : Prop :=
  ∀ c e₁ e₂, c ∈ O.postC e₁ → c ∈ O.postC e₂ → e₁ = e₂

/-- Flow embeds in causality (single-step case of the transitive closure). -/
theorem OccurrenceNet.flow_causality {C E : Type} (O : OccurrenceNet C E)
    {a b : C ⊕ E} (h : O.Flow a b) : O.Causality a b :=
  Relation.TransGen.single h

/-- Causality is transitive (transitive closures are transitive; Engelfriet 1991). -/
theorem OccurrenceNet.causality_trans {C E : Type} (O : OccurrenceNet C E)
    {a b c : C ⊕ E} (h₁ : O.Causality a b) (h₂ : O.Causality b c) :
    O.Causality a c :=
  Relation.TransGen.trans h₁ h₂

/-- The flow relation is irreflexive by bipartiteness: no node flows to itself. -/
theorem OccurrenceNet.flow_irrefl {C E : Type} (O : OccurrenceNet C E)
    (n : C ⊕ E) : ¬ O.Flow n n := by
  cases n <;> simp [OccurrenceNet.Flow]

/-- In an acyclic occurrence net there is no self-flow: acyclicity kills causal self-loops
of any length, in particular length one. -/
theorem OccurrenceNet.acyclic_no_self_flow {C E : Type} (O : OccurrenceNet C E)
    (h : O.Acyclic) (n : C ⊕ E) : ¬ O.Flow n n :=
  fun hf => h n (O.flow_causality hf)

/-- Branching process of a Petri net (Engelfriet 1991; Murata 1989 Section VII): an
occurrence net together with a homomorphism labeling conditions by places and events by
transitions of the original net. Ported from BranchingProcess in wasm4pm-compat petri.rs. -/
structure BranchingProcess (P T C E : Type) where
  occ : OccurrenceNet C E
  condPlace : C → P
  eventTrans : E → T

/-- Finite complete unfolding prefix (McMillan 1992): a branching process plus a designated
set of cut-off events truncating infinite behavior. Ported from UnfoldingPrefix in
wasm4pm-compat petri.rs. -/
structure UnfoldingPrefix (P T C E : Type) where
  process : BranchingProcess P T C E
  cutoff : Set E

/-- Statement (stated, not proven): a branching process is a legal unfolding of net N when
its occurrence net is acyclic, has no backward conflict, and the labeling respects the
pre/post structure of N on singleton arcs (Engelfriet 1991, Def. 3.1 homomorphism condition,
specialized to ordinary nets). -/
def BranchingProcess.isUnfoldingOf_statement {P T C E : Type}
    (B : BranchingProcess P T C E) (N : PetriNet P T) : Prop :=
  B.occ.Acyclic ∧ B.occ.NoBackwardConflict ∧
  (∀ e c, c ∈ B.occ.preC e → N.pre (B.eventTrans e) (B.condPlace c) ≠ 0) ∧
  (∀ e c, c ∈ B.occ.postC e → N.post (B.eventTrans e) (B.condPlace c) ≠ 0)


end ProcInt
