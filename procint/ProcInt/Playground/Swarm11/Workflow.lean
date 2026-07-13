-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
/-!
# Recursive Workflow Syntax

Pipeline:
`open holes + operation nodes → recursive syntax → Kleisli substitution`.

Crown law:
substitution satisfies right identity and associativity.

Preserves:
operation labels and constructor geometry.

Excludes:
runtime adequacy and physical actuation authority.

Falsifier:
either monad law fails in Lean.
-/

namespace ProcInt.Playground.Swarm11

/--
Workflow syntax with explicit open holes.

Law: `bind` substitutes workflows for holes.
Carrier: recursive syntax over operation and hole alphabets.
Admission: syntax only.
Preserves: constructor geometry.
Refuses: physical execution claims.
Claim ceiling: syntax theorem rail.
-/
inductive Workflow (Op Hole : Type) where
  | hole (id : Hole)
  | atom (op : Op)
  | seq (left right : Workflow Op Hole)
  | par (left right : Workflow Op Hole)
  | choice (left right : Workflow Op Hole)
  deriving Repr, DecidableEq, BEq

namespace Workflow

/-- Recursive substitution of workflows for open holes. -/
def bind {Op A B : Type}
    (workflow : Workflow Op A)
    (substitute : A → Workflow Op B) : Workflow Op B :=
  match workflow with
  | .hole holeId => substitute holeId
  | .atom op => .atom op
  | .seq left right =>
      .seq (bind left substitute) (bind right substitute)
  | .par left right =>
      .par (bind left substitute) (bind right substitute)
  | .choice left right =>
      .choice (bind left substitute) (bind right substitute)

/-- Targeted graft as Kleisli substitution. -/
def graft {Op Hole : Type} [DecidableEq Hole]
    (target : Hole)
    (replacement : Workflow Op Hole)
    (workflow : Workflow Op Hole) : Workflow Op Hole :=
  bind workflow fun holeId =>
    if holeId = target then replacement else .hole holeId

/-- Open holes in left-to-right syntax order. -/
def openHoles {Op Hole : Type}
    (workflow : Workflow Op Hole) : List Hole :=
  match workflow with
  | .hole holeId => [holeId]
  | .atom _ => []
  | .seq left right => openHoles left ++ openHoles right
  | .par left right => openHoles left ++ openHoles right
  | .choice left right => openHoles left ++ openHoles right

@[simp] theorem bind_hole {Op A B : Type}
    (holeId : A) (substitute : A → Workflow Op B) :
    bind (.hole holeId) substitute = substitute holeId := rfl

@[simp] theorem bind_atom {Op A B : Type}
    (op : Op) (substitute : A → Workflow Op B) :
    bind (.atom op) substitute = .atom op := rfl

/--
Right identity of workflow substitution.

Law: replacing every hole by the same hole changes nothing.
Carrier: recursive workflow syntax.
Admission: kernel theorem.
Preserves: the complete syntax tree.
Refuses: execution semantics.
Claim ceiling: theorem.
-/
theorem bind_right_identity {Op Hole : Type}
    (workflow : Workflow Op Hole) :
    bind workflow Workflow.hole = workflow := by
  induction workflow with
  | hole holeId => rfl
  | atom op => rfl
  | seq left right leftIH rightIH =>
      simp [bind, leftIH, rightIH]
  | par left right leftIH rightIH =>
      simp [bind, leftIH, rightIH]
  | choice left right leftIH rightIH =>
      simp [bind, leftIH, rightIH]

/--
Associativity of recursive workflow substitution.

Law:
`bind (bind w k) h = bind w (fun x => bind (k x) h)`.
Carrier: recursive workflow syntax.
Admission: kernel theorem.
Preserves: nested substitution meaning.
Refuses: runtime scheduling equivalence.
Claim ceiling: theorem.
-/
theorem bind_assoc {Op A B C : Type}
    (workflow : Workflow Op A)
    (first : A → Workflow Op B)
    (second : B → Workflow Op C) :
    bind (bind workflow first) second =
      bind workflow (fun holeId => bind (first holeId) second) := by
  induction workflow with
  | hole holeId => rfl
  | atom op => rfl
  | seq left right leftIH rightIH =>
      simp [bind, leftIH, rightIH]
  | par left right leftIH rightIH =>
      simp [bind, leftIH, rightIH]
  | choice left right leftIH rightIH =>
      simp [bind, leftIH, rightIH]

@[simp] theorem graft_hole_same {Op Hole : Type} [DecidableEq Hole]
    (holeId : Hole) (replacement : Workflow Op Hole) :
    graft holeId replacement (.hole holeId) = replacement := by
  simp [graft, bind]

end Workflow

end ProcInt.Playground.Swarm11
