-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Models.ProcessTree

Block-structured process trees (Leemans 2013 inductive miner; van der Aalst, Process Mining 2016 ch. 3): leaf, silent, seq, xor, par, loop operators with a recursively defined trace-language semantics, including an explicit interleaving function for the parallel operator and a loop-language inductive predicate. Ported from wasm4pm-compat process_tree.rs (structure-only shape canon). -/

namespace ProcInt

/-- A block-structured process tree (Leemans 2013 inductive-miner operators;
ported from wasm4pm-compat process_tree.rs ProcessTreeOperator): activity leaf,
silent step (tau), binary sequence, exclusive choice, parallel composition, and
loop with a do-body and a redo-branch. -/
inductive ProcessTree (α : Type*)
  | leaf (a : α)
  | silent
  | seq (l r : ProcessTree α)
  | xor (l r : ProcessTree α)
  | par (l r : ProcessTree α)
  | loop (body redo : ProcessTree α)

/-- All interleavings (shuffles) of two lists: the trace semantics of the
parallel operator. Recursion on the sum of lengths. -/
def interleavings {α : Type*} : List α → List α → List (List α)
  | [], ys => [ys]
  | xs, [] => [xs]
  | x :: xs, y :: ys =>
      ((interleavings xs (y :: ys)).map (fun w => x :: w)) ++
      ((interleavings (x :: xs) ys).map (fun w => y :: w))
  termination_by xs ys => xs.length + ys.length

/-- Concatenation language: traces of a sequence operator are concatenations
u ++ v with u from the left language and v from the right language. -/
def seqLang {α : Type*} (A B : Set (List α)) : Set (List α) :=
  setOf (fun w => ∃ u ∈ A, ∃ v ∈ B, w = u ++ v)

/-- Loop language of do-language B and redo-language R: a do-trace, followed by
zero or more (redo-trace ++ do-trace) rounds. Semantics of the loop operator
(Leemans 2013: loop(body, redo) plays body, then optionally redo then body again). -/
inductive LoopLang {α : Type*} (B R : Set (List α)) : List α → Prop
  | base {w : List α} : w ∈ B → LoopLang B R w
  | step {u v w : List α} : LoopLang B R u → v ∈ R → w ∈ B → LoopLang B R (u ++ v ++ w)

/-- Trace language of a process tree (structural recursion). leaf a admits the
singleton trace, silent the empty trace, seq concatenates, xor unions, par takes
interleavings, loop takes LoopLang of body and redo languages. -/
def ProcessTree.language {α : Type*} : ProcessTree α → Set (List α)
  | .leaf a => ({[a]} : Set (List α))
  | .silent => ({([] : List α)} : Set (List α))
  | .seq l r => seqLang l.language r.language
  | .xor l r => l.language ∪ r.language
  | .par l r => setOf (fun w => ∃ u ∈ l.language, ∃ v ∈ r.language, w ∈ interleavings u v)
  | .loop b r => setOf (fun w => LoopLang b.language r.language w)

/-- The language of an activity leaf is exactly the singleton trace, and the
language of the silent step is exactly the empty trace. -/
theorem ProcessTree.language_leaf_silent {α : Type*} (a : α) :
    (ProcessTree.leaf a).language = ({[a]} : Set (List α)) ∧
      (ProcessTree.silent : ProcessTree α).language = ({([] : List α)} : Set (List α)) :=
  ⟨rfl, rfl⟩

/-- The two-activity sequence seq(leaf a, leaf b) admits the trace a·b. -/
theorem ProcessTree.mem_language_seq_leaf {α : Type*} (a b : α) :
    [a, b] ∈ ((ProcessTree.leaf a).seq (ProcessTree.leaf b)).language := by
  refine ⟨[a], rfl, [b], rfl, rfl⟩

/-- Every interleaving of xs and ys has length xs.length + ys.length. -/
theorem length_of_mem_interleavings {α : Type*} :
    ∀ (xs ys : List α), ∀ w ∈ interleavings xs ys, w.length = xs.length + ys.length
  | [], ys, w, h => by
      simp only [interleavings, List.mem_singleton] at h
      subst h; simp
  | x :: xs, [], w, h => by
      simp only [interleavings, List.mem_singleton] at h
      subst h; simp
  | x :: xs, y :: ys, w, h => by
      simp only [interleavings, List.mem_append, List.mem_map] at h
      rcases h with ⟨l, hl, rfl⟩ | ⟨l, hl, rfl⟩
      · have := length_of_mem_interleavings xs (y :: ys) l hl
        simp only [List.length_cons] at *
        omega
      · have := length_of_mem_interleavings (x :: xs) ys l hl
        simp only [List.length_cons] at *
        omega
  termination_by xs ys => xs.length + ys.length

/-- Concatenation of languages is associative (list append associativity lifted
to trace languages). -/
theorem seqLang_assoc {α : Type*} (A B C : Set (List α)) :
    seqLang (seqLang A B) C = seqLang A (seqLang B C) := by
  ext w
  constructor
  · rintro ⟨uv, ⟨u, hu, v, hv, rfl⟩, c, hc, rfl⟩
    exact ⟨u, hu, v ++ c, ⟨v, hv, c, hc, rfl⟩, List.append_assoc u v c⟩
  · rintro ⟨u, hu, vc, ⟨v, hv, c, hc, rfl⟩, rfl⟩
    exact ⟨u ++ v, ⟨u, hu, v, hv, rfl⟩, c, hc, (List.append_assoc u v c).symm⟩

/-- The sequence operator is associative at the language level:
language(seq(seq t u, v)) = language(seq(t, seq u v)). -/
theorem ProcessTree.language_seq_assoc {α : Type*} (t u v : ProcessTree α) :
    ((t.seq u).seq v).language = (t.seq (u.seq v)).language := by
  simp only [ProcessTree.language]
  exact seqLang_assoc _ _ _


end ProcInt
