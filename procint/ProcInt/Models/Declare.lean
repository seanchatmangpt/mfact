-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Models.Declare

DECLARE declarative constraint templates (existence, absence, exactlyOne, response, precedence, succession, notCoexistence), constraints as template + activities, and trace-satisfaction semantics as decidable Props with kernel-decided concrete checks. Port of wasm4pm-compat declare.rs; canonical source: van der Aalst and Pesic, DecSerFlow/DECLARE (2006/2007). -/

namespace ProcInt

/-- DECLARE constraint templates (core selection of the 22 canonical
templates of van der Aalst and Pesic, DecSerFlow/DECLARE). Port of
`declare.rs` `DeclareTemplate`. -/
inductive DeclareTemplate where
  | existence
  | absence
  | exactlyOne
  | response
  | precedence
  | succession
  | notCoexistence
deriving DecidableEq, Repr

/-- Template arity: 1 for unary (existence family), 2 for binary
(ordering and mutual-exclusion). Port of `declare.rs` `DeclareTemplate::arity`. -/
def DeclareTemplate.arity : DeclareTemplate → ℕ
  | .existence => 1
  | .absence => 1
  | .exactlyOne => 1
  | _ => 2

/-- A DECLARE constraint: a template applied to an activation activity and,
for binary templates, a target activity. Port of `declare.rs`
`DeclareConstraint` (scope omitted: single-trace semantics). -/
structure DeclareConstraint (α : Type u) where
  template : DeclareTemplate
  activation : α
  target : Option α
deriving DecidableEq, Repr

/-- Response semantics: every occurrence of a is eventually followed by an
occurrence of b — ∀ i, trace(i) = a → ∃ j > i, trace(j) = b.
Van der Aalst and Pesic, DECLARE response template; `declare.rs` `Response`. -/
abbrev Response [DecidableEq α] (a b : α) (t : List α) : Prop :=
  ∀ i : Fin t.length, t.get i = a → ∃ j : Fin t.length, i < j ∧ t.get j = b

/-- Precedence semantics: every occurrence of b is preceded by an earlier
occurrence of a — ∀ j, trace(j) = b → ∃ i < j, trace(i) = a.
Van der Aalst and Pesic, DECLARE precedence template; `declare.rs` `Precedence`. -/
abbrev Precedence [DecidableEq α] (a b : α) (t : List α) : Prop :=
  ∀ j : Fin t.length, t.get j = b → ∃ i : Fin t.length, i < j ∧ t.get i = a

/-- Satisfaction of a DECLARE constraint by a trace, per template:
existence (a ∈ t), absence (a ∉ t), exactlyOne (count = 1), response,
precedence, succession (response ∧ precedence), notCoexistence
(¬(a ∈ t ∧ b ∈ t)). Binary templates without a target are unsatisfiable
(declare.rs `DeclareRefusal::MissingTarget`). -/
abbrev DeclareConstraint.Satisfies [DecidableEq α] (c : DeclareConstraint α)
    (t : List α) : Prop :=
  match c.template, c.target with
  | .existence, _ => c.activation ∈ t
  | .absence, _ => c.activation ∉ t
  | .exactlyOne, _ => t.count c.activation = 1
  | .response, some b => Response c.activation b t
  | .precedence, some b => Precedence c.activation b t
  | .succession, some b => Response c.activation b t ∧ Precedence c.activation b t
  | .notCoexistence, some b => ¬(c.activation ∈ t ∧ b ∈ t)
  | _, none => False

/-- Concrete kernel check: response(0, 1) holds on the trace [0, 1, 0, 1]
(every 0 is followed by a later 1) — decided by the kernel. -/
theorem response_concrete : Response 0 1 [0, 1, 0, 1] := by decide

/-- Concrete kernel check: precedence(0, 1) holds on [0, 1, 1] and
response(1, 0) fails on it — decided by the kernel. -/
theorem precedence_concrete : Precedence 0 1 [0, 1, 1] ∧ ¬ Response 1 0 [0, 1, 1] := by
  decide

/-- Succession entails response: the succession template is the conjunction
of response and precedence (van der Aalst and Pesic; declare.rs Succession). -/
theorem succession_imp_response [DecidableEq α] (a b : α) (t : List α)
    (h : (DeclareConstraint.mk .succession a (some b)).Satisfies t) :
    Response a b t := h.1

/-- Existence is monotone under trace extension on the right: if a occurs
in t it occurs in t ++ s (DECLARE existence template monotonicity). -/
theorem existence_append [DecidableEq α] (a : α) (t s : List α)
    (h : (DeclareConstraint.mk .existence a none).Satisfies t) :
    (DeclareConstraint.mk .existence a none).Satisfies (t ++ s) :=
  List.mem_append_left s h

/-- NotCoexistence is symmetric in its two activities
(mutual-exclusion law; declare.rs NotCoExistence). -/
theorem notCoexistence_comm [DecidableEq α] (a b : α) (t : List α) :
    (DeclareConstraint.mk .notCoexistence a (some b)).Satisfies t ↔
    (DeclareConstraint.mk .notCoexistence b (some a)).Satisfies t := by
  constructor <;> exact fun h hc => h ⟨hc.2, hc.1⟩

/-- Every template arity is 1 or 2 (declare.rs `arity` codomain law). -/
theorem arity_one_or_two (tp : DeclareTemplate) : tp.arity = 1 ∨ tp.arity = 2 := by
  cases tp <;> simp [DeclareTemplate.arity]


end ProcInt
