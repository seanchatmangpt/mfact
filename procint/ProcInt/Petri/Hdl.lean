-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

/-! # ProcInt.Petri.Hdl

Target HDL (Hardware Description Language) AST and Petri-to-HDL compiler. -/

namespace ProcInt

/-- Signal widths supported by the compiler target. -/
inductive HdlWidth where
  | single                  -- 1-bit signal
  | vector (n : Nat)        -- n-bit bus: [n-1:0]
  deriving DecidableEq, Repr

/-- Expressions in the target HDL AST. -/
inductive HdlExpr where
  | const (w : HdlWidth) (val : Nat)
  | var (name : String)
  | add (e1 e2 : HdlExpr)
  | sub (e1 e2 : HdlExpr)
  | mul (e1 e2 : HdlExpr)
  | eq (e1 e2 : HdlExpr)
  | geq (e1 e2 : HdlExpr)
  | mux (cond e_then e_else : HdlExpr)
  | and (e1 e2 : HdlExpr)
  deriving Repr

/-- Statements in the target HDL AST. -/
inductive HdlStmt where
  | assign (lhs : String) (rhs : HdlExpr)
  | seqAssign (lhs : String) (rhs : HdlExpr)
  | alwaysPosedge (clk : String) (rst : String) (body : List HdlStmt)
  | block (stmts : List HdlStmt)
  deriving Repr

/-- An HDL module containing inputs, outputs, registers, wires, and statements. -/
structure HdlModule where
  name : String
  inputs : List (String × HdlWidth)
  outputs : List (String × HdlWidth)
  wires : List (String × HdlWidth)
  regs : List (String × HdlWidth)
  stmts : List HdlStmt
  deriving Repr

def getTransitionFireActualName (idx : Nat) : String :=
  s!"fire_actual_{idx}"

/-- Code generator helper: accumulates transitions' token contributions for place `p`. -/
def compileNextStateExpr {P T : Type} [DecidableEq P] (N : PetriNet P T) (t_list : List T)
    (p : P) (w : Nat) (p_str : P → String) : HdlExpr :=
  let rec loop (idx : Nat) (expr : HdlExpr) : List T → HdlExpr
    | [] => expr
    | t :: ts =>
      let pre_val := N.pre t p
      let post_val := N.post t p
      let cond := HdlExpr.var (getTransitionFireActualName idx)
      let next_expr :=
        if post_val >= pre_val then
          HdlExpr.add expr (HdlExpr.mux cond (HdlExpr.const (HdlWidth.vector w) (post_val - pre_val)) (HdlExpr.const (HdlWidth.vector w) 0))
        else
          HdlExpr.sub expr (HdlExpr.mux cond (HdlExpr.const (HdlWidth.vector w) (pre_val - post_val)) (HdlExpr.const (HdlWidth.vector w) 0))
      loop (idx + 1) next_expr ts
  loop 0 (HdlExpr.var s!"M_{p_str p}_reg") t_list

/-- Compiler from a Petri net to an HDL module.
    Automatically designs the hardware registers, priority encoder for conflict resolution,
    next-state update logic, and reset circuitry. -/
def compileToHdl {P T : Type} [DecidableEq P] [DecidableEq T] [Fintype P] [Fintype T]
    (N : PetriNet P T) (w : Nat) (p_str : P → String) (t_str : T → String) : HdlModule :=
  let p_list := Finset.univ.toList (α := P)
  let t_list := Finset.univ.toList (α := T)
  
  -- Inputs: clk, rst, and t_fire for each transition
  let inputs := [("clk", HdlWidth.single), ("rst", HdlWidth.single)] ++
    t_list.map (fun t => (s!"t_fire_{t_str t}", HdlWidth.single))
  
  -- Outputs: marking of each place
  let outputs := p_list.map (fun p => (s!"M_{p_str p}", HdlWidth.vector w))
  
  -- Wires for enablement and firing
  let rec makeWires (idx : Nat) : List T → List (String × HdlWidth)
    | [] => []
    | t :: ts =>
      [ (s!"enabled_{t_str t}", HdlWidth.single),
        (s!"fire_req_{t_str t}", HdlWidth.single),
        (getTransitionFireActualName idx, HdlWidth.single) ] ++ makeWires (idx + 1) ts
  let wires := makeWires 0 t_list
  
  -- Registers: state registers for the marking of each place
  let regs := p_list.map (fun p => (s!"M_{p_str p}_reg", HdlWidth.vector w))
  
  -- 1. Continuous assignments for enabledness and firing request
  let rec makeStmts1 : List T → List HdlStmt
    | [] => []
    | t :: ts =>
      let pre_places := p_list.filter (fun p => N.pre t p > 0)
      let enabled_expr := pre_places.foldr (fun p acc =>
        HdlExpr.and (HdlExpr.geq (HdlExpr.var s!"M_{p_str p}_reg") (HdlExpr.const (HdlWidth.vector w) (N.pre t p))) acc
      ) (HdlExpr.const HdlWidth.single 1)
      [ HdlStmt.assign s!"enabled_{t_str t}" enabled_expr,
        HdlStmt.assign s!"fire_req_{t_str t}" (HdlExpr.and (HdlExpr.var s!"enabled_{t_str t}") (HdlExpr.var s!"t_fire_{t_str t}")) ] ++ makeStmts1 ts
  let stmts1 := makeStmts1 t_list
  
  -- 2. Priority encoder for actual firing
  let rec makeStmts2 (idx : Nat) : List T → List HdlStmt
    | [] => []
    | t :: ts =>
      let prior_items := t_list.take idx
      let inhibit := prior_items.foldl (fun acc pt =>
        HdlExpr.and acc (HdlExpr.eq (HdlExpr.var s!"fire_req_{t_str pt}") (HdlExpr.const HdlWidth.single 0))
      ) (HdlExpr.const HdlWidth.single 1)
      let actual_expr := HdlExpr.and (HdlExpr.var s!"fire_req_{t_str t}") inhibit
      HdlStmt.assign (getTransitionFireActualName idx) actual_expr :: makeStmts2 (idx + 1) ts
  let stmts2 := makeStmts2 0 t_list
  
  -- 3. Register reset and next-state assignments
  let seq_stmts : List HdlStmt := p_list.map (fun p =>
    let next_expr := compileNextStateExpr N t_list p w p_str
    let rst_mux := HdlExpr.mux (HdlExpr.var "rst") (HdlExpr.const (HdlWidth.vector w) 0) next_expr
    HdlStmt.seqAssign s!"M_{p_str p}_reg" rst_mux
  )
  let stmts3 := [HdlStmt.alwaysPosedge "clk" "rst" seq_stmts]
  
  -- 4. Output assignments: M_p = M_p_reg
  let stmts4 : List HdlStmt := p_list.map (fun p =>
    HdlStmt.assign s!"M_{p_str p}" (HdlExpr.var s!"M_{p_str p}_reg")
  )
  
  let stmts := stmts1 ++ stmts2 ++ stmts3 ++ stmts4
  
  { name := "petri_controller",
    inputs := inputs,
    outputs := outputs,
    wires := wires,
    regs := regs,
    stmts := stmts }

/-- State valuation of hardware registers for places. -/
def RegisterState (P : Type) (w : Nat) := P → BitVec w

/-- Refinement abstraction relation: maps hardware BitVec register state to formal Petri net marking. -/
def Refinement {P : Type} (M : Marking P) (regVal : RegisterState P w) : Prop :=
  ∀ p, (M p : ℤ) = (regVal p).toNat


end ProcInt
