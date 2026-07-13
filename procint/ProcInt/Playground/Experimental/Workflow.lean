-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
/-!
# Free-Socket Workflow Syntax

Pipeline:
`open sockets + operations → recursive syntax → monadic substitution`.

Crown law:
socket substitution satisfies right identity and associativity.

Preserves:
operation nodes and workflow constructors not targeted by substitution.

Excludes:
runtime adequacy; typed-color adequacy; independent-graft commutation without an
independence witness.

Standing:
formal syntax-manufacture rail.

Falsifier:
`bind_right_identity` or `bind_assoc` fails.

Downstream:
typed workflows, replay, recursive manufacture.
-/

namespace ProcInt.Playground.Experimental

/--
Workflow syntax with open sockets.

Law: `open` is the variable constructor; `bind` performs recursive substitution.
Carrier: free socket syntax over operation labels and four workflow constructors.
Admission: syntax only.
Preserves: constructor geometry under substitution.
Refuses: runtime semantics by implication.
Claim ceiling: syntax-manufacture law.
-/
inductive Workflow (Op Socket : Type) where
  | socket (socket : Socket)
  | atom (op : Op)
  | seq (left right : Workflow Op Socket)
  | par (left right : Workflow Op Socket)
  | choice (left right : Workflow Op Socket)
  deriving Repr, DecidableEq, BEq

namespace Workflow

/--
Monadic substitution over open sockets.

Law: recursively replaces each `open s` with `k s`.
Carrier: workflow syntax.
Admission: total substitution function.
Preserves: atom labels and constructor geometry.
Refuses: typed composition claims.
Claim ceiling: syntax substitution.
-/
def bind {Op A B : Type}
    (w : Workflow Op A) (k : A → Workflow Op B) : Workflow Op B :=
  match w with
  | .socket s => k s
  | .atom op => .atom op
  | .seq left right => .seq (bind left k) (bind right k)
  | .par left right => .par (bind left k) (bind right k)
  | .choice left right => .choice (bind left k) (bind right k)

/-- Targeted socket graft as monadic substitution. -/
def graft {Op Socket : Type} [DecidableEq Socket]
    (target : Socket) (replacement : Workflow Op Socket)
    (w : Workflow Op Socket) : Workflow Op Socket :=
  bind w fun socket =>
    if socket = target then replacement else .socket socket

/-- Open sockets in left-to-right syntax order. -/
def openSockets {Op Socket : Type}
    (w : Workflow Op Socket) : List Socket :=
  match w with
  | .socket s => [s]
  | .atom _ => []
  | .seq left right => openSockets left ++ openSockets right
  | .par left right => openSockets left ++ openSockets right
  | .choice left right => openSockets left ++ openSockets right

@[simp] theorem bind_open {Op A B : Type}
    (a : A) (k : A → Workflow Op B) :
    bind (.socket a) k = k a := rfl

@[simp] theorem bind_atom {Op A B : Type}
    (op : Op) (k : A → Workflow Op B) :
    bind (.atom op) k = .atom op := rfl

/--
Right identity for workflow substitution.

Law: replacing every socket by itself changes nothing.
Carrier: free-socket workflow syntax.
Admission: theorem admitted by Lean.
Preserves: full syntax tree.
Refuses: runtime interpretation.
Claim ceiling: theorem.
-/
theorem bind_right_identity {Op Socket : Type}
    (w : Workflow Op Socket) :
    bind w Workflow.socket = w := by
  induction w with
  | socket socket => rfl
  | atom op => rfl
  | seq left right ihLeft ihRight =>
      simp [bind, ihLeft, ihRight]
  | par left right ihLeft ihRight =>
      simp [bind, ihLeft, ihRight]
  | choice left right ihLeft ihRight =>
      simp [bind, ihLeft, ihRight]

/--
Associativity for recursive workflow substitution.

Law: `(w >>= k) >>= h = w >>= (fun x => k x >>= h)`.
Carrier: free-socket syntax.
Admission: theorem admitted by Lean.
Preserves: substitution meaning across nesting order.
Refuses: execution-order equivalence.
Claim ceiling: theorem.
-/
theorem bind_assoc {Op A B C : Type}
    (w : Workflow Op A)
    (k : A → Workflow Op B)
    (h : B → Workflow Op C) :
    bind (bind w k) h = bind w (fun x => bind (k x) h) := by
  induction w with
  | socket socket => rfl
  | atom op => rfl
  | seq left right ihLeft ihRight =>
      simp [bind, ihLeft, ihRight]
  | par left right ihLeft ihRight =>
      simp [bind, ihLeft, ihRight]
  | choice left right ihLeft ihRight =>
      simp [bind, ihLeft, ihRight]

@[simp] theorem graft_open_same {Op Socket : Type} [DecidableEq Socket]
    (socket : Socket) (replacement : Workflow Op Socket) :
    graft socket replacement (.socket socket) = replacement := by
  simp [graft, bind]

end Workflow

end ProcInt.Playground.Experimental
