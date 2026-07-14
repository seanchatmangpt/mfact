import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

namespace ProcInt

inductive QasmRegister where
  | qreg (name : String) (size : Nat)
  | creg (name : String) (size : Nat)
  deriving Repr, DecidableEq

inductive QasmStmt where
  | decl (reg : QasmRegister)
  | cx (ctrl target : String)
  | mcx (ctrls : List String) (target : String)
  deriving Repr, DecidableEq

structure QasmProgram where
  version : String
  headers : List String
  stmts : List QasmStmt
  deriving Repr, DecidableEq

def compileTransitionToQasm {P T : Type} [DecidableEq P] (N : PetriNet P T) (t : T)
    (p_str : P → String) (t_str : T → String) : List QasmStmt :=
  let pre_places := (N.pre t).support.toList
  let post_places := (N.post t).support.toList
  let pre_names := pre_places.map (fun p => s!"q_{p_str p}")
  let ancilla := s!"ancilla_{t_str t}"
  [ QasmStmt.mcx pre_names ancilla ] ++
  pre_places.map (fun p => QasmStmt.cx ancilla s!"q_{p_str p}") ++
  post_places.map (fun p => QasmStmt.cx ancilla s!"q_{p_str p}") ++
  [ QasmStmt.mcx pre_names ancilla ]

def compileToQasm {P T : Type} [DecidableEq P] [DecidableEq T] [Fintype P] [Fintype T]
    (N : PetriNet P T) (p_str : P → String) (t_str : T → String) : QasmProgram :=
  let p_list := Finset.univ.toList (α := P)
  let t_list := Finset.univ.toList (α := T)
  let place_decls := p_list.map (fun p => QasmStmt.decl (QasmRegister.qreg s!"q_{p_str p}" 1))
  let ancilla_decls := t_list.map (fun t => QasmStmt.decl (QasmRegister.qreg s!"ancilla_{t_str t}" 1))
  let transition_stmts := t_list.flatMap (fun t => compileTransitionToQasm N t p_str t_str)
  { version := "3.0"
    headers := ["include \"stdgates.inc\";"]
    stmts := place_decls ++ ancilla_decls ++ transition_stmts }

def JointState (P T : Type) [Fintype P] [Fintype T] := (P → Bool) × (T → Bool) → ℝ

def injectMarking {P T : Type} [Fintype P] [Fintype T] [DecidableEq P] [DecidableEq T]
    (M : P → Bool) : JointState P T :=
  fun ⟨Mp, Mt⟩ => if Mp = M ∧ Mt = (fun _ => false) then 1 else 0

opaque U_t {P T : Type} [Fintype P] [Fintype T] [DecidableEq P] [DecidableEq T]
    (N : PetriNet P T) (t : T) : JointState P T → JointState P T

def markingOfBool {P : Type} (M : P → Bool) : Marking P :=
  fun p => if M p then 1 else 0

def boolOfMarking {P : Type} (M : Marking P) : P → Bool :=
  fun p => M p > 0

theorem qasm_transition_equivalence {P T : Type} [Fintype P] [Fintype T] [DecidableEq P] [DecidableEq T]
    (N : PetriNet P T) (t : T) (M : P → Bool) (h_safe : ∀ p, (N.pre t p ≤ 1 ∧ N.post t p ≤ 1)) :
    U_t N t (injectMarking M) =
      injectMarking (if N.Enabled (markingOfBool M) t then boolOfMarking (N.fire (markingOfBool M) t) else M) := by
  sorry

end ProcInt
