import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

namespace ProcInt

structure SnnNeuron where
  id : String
  threshold : Nat
  deriving Repr, DecidableEq

structure SnnSynapse where
  source : String
  target : String
  weight : Int
  deriving Repr, DecidableEq

structure SnnNetwork where
  neurons : List SnnNeuron
  synapses : List SnnSynapse
  deriving Repr, DecidableEq

def compileToSnn {P T : Type} [DecidableEq P] [DecidableEq T] [Fintype P] [Fintype T]
    (N : PetriNet P T) (p_str : P → String) (t_str : T → String) : SnnNetwork :=
  let p_list := Finset.univ.toList (α := P)
  let t_list := Finset.univ.toList (α := T)
  let place_neurons := p_list.map (fun p => SnnNeuron.mk s!"n_{p_str p}" 1)
  let enablement_neurons := t_list.flatMap (fun t =>
    let pre_places := p_list.filter (fun p => N.pre t p > 0)
    pre_places.map (fun p => SnnNeuron.mk s!"n_{p_str p}_{t_str t}" (N.pre t p))
  )
  let transition_neurons := t_list.map (fun t =>
    let num_pre := (p_list.filter (fun p => N.pre t p > 0)).length
    SnnNeuron.mk s!"n_{t_str t}" num_pre
  )
  let place_to_enable_synapses := t_list.flatMap (fun t =>
    let pre_places := p_list.filter (fun p => N.pre t p > 0)
    pre_places.map (fun p => SnnSynapse.mk s!"n_{p_str p}" s!"n_{p_str p}_{t_str t}" 1)
  )
  let enable_to_trans_synapses := t_list.flatMap (fun t =>
    let pre_places := p_list.filter (fun p => N.pre t p > 0)
    pre_places.map (fun p => SnnSynapse.mk s!"n_{p_str p}_{t_str t}" s!"n_{t_str t}" 1)
  )
  let trans_to_place_synapses := t_list.flatMap (fun t =>
    p_list.filter (fun p => N.pre t p > 0 ∨ N.post t p > 0) |>.map (fun p =>
      let weight := (N.post t p : Int) - (N.pre t p : Int)
      SnnSynapse.mk s!"n_{t_str t}" s!"n_{p_str p}" weight
    )
  )
  { neurons := place_neurons ++ enablement_neurons ++ transition_neurons,
    synapses := place_to_enable_synapses ++ enable_to_trans_synapses ++ trans_to_place_synapses }

structure SnnState where
  v_place : String → Nat
  v_enable : String → Nat
  v_trans : String → Nat

def snn_step (net : SnnNetwork) (s : SnnState) : SnnState :=
  let s_enable (name : String) : Bool :=
    match net.neurons.find? (fun n => n.id == name) with
    | some n => s.v_enable name ≥ n.threshold
    | none => false
  let v_trans_next (t_name : String) : Nat :=
    let incoming := net.synapses.filter (fun syn => syn.target == t_name)
    incoming.foldl (fun acc syn =>
      if s_enable syn.source then acc + 1 else acc
    ) 0
  let s_trans (t_name : String) : Bool :=
    match net.neurons.find? (fun n => n.id == t_name) with
    | some n => v_trans_next t_name ≥ n.threshold
    | none => false
  let v_place_next (p_name : String) : Nat :=
    let incoming := net.synapses.filter (fun syn => syn.target == p_name)
    let net_change := incoming.foldl (fun (acc : Int) syn =>
      if s_trans syn.source then acc + syn.weight else acc
    ) 0
    Int.toNat ( (s.v_place p_name : Int) + net_change )
  let v_enable_next (e_name : String) : Nat :=
    let incoming := net.synapses.filter (fun syn => syn.target == e_name)
    incoming.foldl (fun acc syn =>
      acc + s.v_place syn.source
    ) 0
  { v_place := v_place_next,
    v_enable := v_enable_next,
    v_trans := v_trans_next }

def SnnRefinement {P : Type} (p_str : P → String) (M : Marking P) (s : SnnState) : Prop :=
  (∀ p, s.v_place (s!"n_{p_str p}") = M p) ∧
  (∀ p t_name, s.v_enable (s!"n_{p_str p}_{t_name}") = M p)

theorem snn_step_equivalence {P T : Type} [DecidableEq P] [DecidableEq T] [Fintype P] [Fintype T]
    (N : PetriNet P T) (p_str : P → String) (t_str : T → String)
    (M : Marking P) (s : SnnState) (t : T)
    (h_ref : SnnRefinement p_str M s)
    (h_enabled : N.Enabled M t)
    (h_exclusive : ∀ t' ≠ t, ¬ N.Enabled M t') :
    SnnRefinement p_str (N.fire M t) (snn_step (compileToSnn N p_str t_str) s) := by
  sorry

end ProcInt
