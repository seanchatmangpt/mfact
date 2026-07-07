-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Ocel.Core

/-! # ProcInt.Ocel.Relations

Qualified E2O/O2O relation projections and the object interaction graph over an OCEL 2.0 log (arXiv 2403.01975 Def. 2 and Sec. 3): two objects interact iff they share an event. Includes soundness of the projection (raw triples land in objectsOf) and symmetry of interaction. Port of wasm4pm-compat src/ocel.rs fns e2o/o2o. -/

namespace ProcInt

/-- Qualified E2O projection: the (qualifier, object) pairs attached to event e
(OCEL 2.0 Def. 2; wasm4pm-compat src/ocel.rs fn e2o returns exactly these
qualified pairs). -/
def OCEL.e2oProj {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) (e : E) : List (Q × O) :=
  (L.e2o.filter (fun t => decide (t.1 = e))).map (fun t => t.2)

/-- Qualified O2O projection: the (qualifier, target) pairs whose source is o
(OCEL 2.0 Def. 2; wasm4pm-compat src/ocel.rs fn o2o). -/
def OCEL.o2oProj {E O ET OT Q V : Type} [DecidableEq O]
    (L : OCEL E O ET OT Q V) (o : O) : List (Q × O) :=
  (L.o2o.filter (fun t => decide (t.1 = o))).map (fun t => t.2)

/-- Object interaction graph edge: two objects interact iff they share an event
(standard object-interaction graph over an OCEL, cf. arXiv 2403.01975 Sec. 3). -/
def OCEL.Interacts {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) (o₁ o₂ : O) : Prop :=
  ∃ e : E, o₁ ∈ L.objectsOf e ∧ o₂ ∈ L.objectsOf e

/-- The interaction relation is symmetric: sharing an event is order-agnostic. -/
theorem OCEL.interacts_symm {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) {o₁ o₂ : O}
    (h : L.Interacts o₁ o₂) : L.Interacts o₂ o₁ := by
  obtain ⟨e, h₁, h₂⟩ := h
  exact ⟨e, h₂, h₁⟩

/-- Any object appearing in some event's E2O projection interacts with itself. -/
theorem OCEL.interacts_self {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) {o : O} {e : E}
    (h : o ∈ L.objectsOf e) : L.Interacts o o :=
  ⟨e, h, h⟩

/-- The qualified projection and the object projection of an event have equal
length: both are maps over the same filtered relation table. -/
theorem OCEL.e2oProj_length {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) (e : E) :
    (L.e2oProj e).length = (L.objectsOf e).length := by
  simp [OCEL.e2oProj, OCEL.objectsOf]

/-- Soundness of the E2O projection: a raw qualified triple (e, q, o) in the
relation table puts o into objectsOf e. -/
theorem OCEL.mem_objectsOf {E O ET OT Q V : Type} [DecidableEq E]
    (L : OCEL E O ET OT Q V) {e : E} {q : Q} {o : O}
    (h : (e, q, o) ∈ L.e2o) : o ∈ L.objectsOf e := by
  unfold OCEL.objectsOf
  exact List.mem_map.mpr ⟨(e, q, o), List.mem_filter.mpr ⟨h, by simp⟩, rfl⟩


end ProcInt
