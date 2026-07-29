namespace ProcInt.MFW

/-
[W4PM-LEAN-GALL-030a] Rework-detection correspondence carrier.

Formalizes wasm4pm's rework-detection predicate exactly as implemented in
`wasm4pm/src/models.rs`: `ColumnarLog::count_loops_length_1` (adjacent equal
activity ids within one trace's event-id segment), `count_loops_length_2`
(a length-2 cycle `a,b,a` that is NOT already a length-1 loop), and
`count_traces_with_rework` (a trace has rework iff it has an L1 loop, or,
failing that, an L2 loop). This file states and proves the exact
existential characterization of `hasL1Loop`; no Mathlib import is used
(deliberately, since building mfact's Lean toolchain from an empty `.lake`
package cache would otherwise require a full Mathlib build, impractical to
run inline this checkpoint) — only Lean 4's `Init` core library.

This is a genuinely tractable target, unlike the other five algorithms
in this checkpoint's cluster: the predicate is a bounded existential over
a finite list (the same shape `Ledger.lean::validTopologicalSort` uses for
its own conjuncts), not an optimization/search/stochastic procedure.
-/

/-- A length-1 loop (self-loop) exists at some adjacent pair `l[i] = l[i+1]`.
Port of `wasm4pm/src/models.rs::ColumnarLog::count_loops_length_1`'s
per-trace existence check (`self.events[i] == self.events[i + 1]`). -/
def hasL1Loop : List Nat → Bool
  | [] => false
  | [_] => false
  | a :: b :: rest => (a == b) || hasL1Loop (b :: rest)

/-- A length-2 loop exists at some triple `l[i] = l[i+2] ∧ l[i] ≠ l[i+1]`
(excludes length-1 loops, matching the `count_loops_length_2` doc comment
"Excludes length-1 loops"). Port of the same file's
`ColumnarLog::count_loops_length_2` per-trace existence check. -/
def hasL2Loop : List Nat → Bool
  | a :: b :: c :: rest => (a == c && !(a == b)) || hasL2Loop (b :: c :: rest)
  | _ => false

/-- Rework: L1-loop-or-else-L2-loop. Port of
`ColumnarLog::count_traces_with_rework`'s per-trace predicate: "Check L1;
Check L2 if no L1 found" collapses to a plain disjunction for an
*existence* question (the Rust structure only matters for its early-return
optimization, not for the truth value). -/
def hasRework (l : List Nat) : Bool := hasL1Loop l || hasL2Loop l

/-- Zero-default indexing (avoids depending on `List.get!`, which is not
part of core Lean's `Init` — only `headD`/`drop` are). `idx l i` is the
`i`-th element of `l`, or `0` if out of range. -/
def idx (l : List Nat) (i : Nat) : Nat := (l.drop i).headD 0

/-- `hasL1Loop` is exactly "there exists an adjacent equal pair" — the
formal statement that the Rust `count_loops_length_1` existence check
(`self.events[i] == self.events[i + 1]` for some `i`) is deciding. -/
theorem hasL1Loop_iff (l : List Nat) :
    hasL1Loop l = true ↔ ∃ i, i + 1 < l.length ∧ idx l i = idx l (i + 1) := by
  induction l with
  | nil => simp [hasL1Loop]
  | cons a t ih =>
    cases t with
    | nil => simp [hasL1Loop]
    | cons b rest =>
      simp only [hasL1Loop, Bool.or_eq_true, beq_iff_eq]
      constructor
      · intro h
        cases h with
        | inl h => exact ⟨0, by simp, by simp [idx, h]⟩
        | inr h =>
          obtain ⟨i, hi, heq⟩ := ih.mp h
          refine ⟨i + 1, by simpa using hi, ?_⟩
          simpa [idx, List.drop_succ_cons] using heq
      · rintro ⟨i, hi, heq⟩
        cases i with
        | zero => left; simpa [idx] using heq
        | succ j =>
          right
          apply ih.mpr
          refine ⟨j, by simpa using hi, ?_⟩
          simpa [idx, List.drop_succ_cons] using heq

end ProcInt.MFW
