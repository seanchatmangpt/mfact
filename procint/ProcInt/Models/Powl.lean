-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Models.Powl

POWL — Partially Ordered Workflow Language (Kourani and van Zelst, BPM 2023, Definitions 1-2): atoms, silent steps, n-ary exclusive choice, do/redo loops, and partial orders over submodels with an index-level precedence relation, plus the WellFormed predicate encoding the arity and strict-partial-order side conditions. Ported from wasm4pm-compat powl.rs (PowlNodeKind and the InvalidChoiceArity / CyclicPartialOrder refusal laws). -/

namespace ProcInt

/-- POWL model (Kourani and van Zelst, BPM 2023, Definitions 1-2): an activity
atom, a silent step, an exclusive choice over a list of submodels, a loop with
do-part and redo-part, and a partial order over a list of submodels whose
precedence relation is given on child indices. Ported from wasm4pm-compat
powl.rs. -/
inductive Powl (α : Type*)
  | atom (a : α)
  | silent
  | xor (children : List (Powl α))
  | loop (doP redoP : Powl α)
  | po (children : List (Powl α)) (prec : ℕ → ℕ → Prop)

/-- Well-formedness of a POWL model (BPM 2023 Def 1-2 side conditions, matching
the wasm4pm-compat refusal laws InvalidChoiceArity and CyclicPartialOrder):
an xor needs at least two children; a partial order's precedence must be
irreflexive and transitive on indices below the children count; well-formedness
is hereditary. -/
inductive Powl.WellFormed {α : Type*} : Powl α → Prop
  | atom (a : α) : Powl.WellFormed (Powl.atom a)
  | silent : Powl.WellFormed (Powl.silent : Powl α)
  | xor (children : List (Powl α))
      (hlen : 2 ≤ children.length)
      (hall : ∀ c ∈ children, Powl.WellFormed c) :
      Powl.WellFormed (Powl.xor children)
  | loop (doP redoP : Powl α) :
      Powl.WellFormed doP → Powl.WellFormed redoP →
      Powl.WellFormed (Powl.loop doP redoP)
  | po (children : List (Powl α)) (prec : ℕ → ℕ → Prop)
      (hirr : ∀ i, i < children.length → ¬ prec i i)
      (htrans : ∀ i j k, i < children.length → j < children.length →
        k < children.length → prec i j → prec j k → prec i k)
      (hall : ∀ c ∈ children, Powl.WellFormed c) :
      Powl.WellFormed (Powl.po children prec)

/-- Inversion: a well-formed xor has at least two children (the arity law
behind PowlRefusal.InvalidChoiceArity in wasm4pm-compat powl.rs). -/
theorem Powl.WellFormed.xor_length {α : Type*} {children : List (Powl α)}
    (h : Powl.WellFormed (Powl.xor children)) : 2 ≤ children.length := by
  cases h with
  | xor _ hlen _ => exact hlen

/-- The binary choice between an atom and the silent step is well-formed. -/
theorem Powl.wellFormed_xor_pair {α : Type*} (a : α) :
    Powl.WellFormed (Powl.xor [Powl.atom a, Powl.silent]) := by
  refine .xor _ (by simp) ?_
  intro c hc
  rcases List.mem_cons.mp hc with rfl | hc
  · exact .atom a
  · rcases List.mem_singleton.mp hc with rfl
    exact .silent

/-- A loop of two atoms is well-formed (POWL loop has exactly a do-part and a
redo-part; BPM 2023 Def 1). -/
theorem Powl.wellFormed_loop_atoms {α : Type*} (a b : α) :
    Powl.WellFormed (Powl.loop (Powl.atom a) (Powl.atom b)) :=
  .loop _ _ (.atom a) (.atom b)

/-- A partial order over two atoms with the empty precedence relation is
well-formed: the empty relation is trivially irreflexive and transitive
(fully concurrent partial order, BPM 2023 Def 2). -/
theorem Powl.wellFormed_po_emptyPrec {α : Type*} (a b : α) :
    Powl.WellFormed (Powl.po [Powl.atom a, Powl.atom b] (fun _ _ => False)) := by
  refine .po _ _ (fun i _ h => h) (fun i j k _ _ _ h _ => h.elim) ?_
  intro c hc
  rcases List.mem_cons.mp hc with rfl | hc
  · exact .atom a
  · rcases List.mem_singleton.mp hc with rfl
    exact .atom b


end ProcInt
