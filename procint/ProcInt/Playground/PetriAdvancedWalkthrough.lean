-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-! Small worked instances exercising `ProcInt.Petri.Stochastic`,
`ProcInt.Petri.Unfolding`, and `ProcInt.Petri.OCPN`. -/

-- A two-place, two-transition net shared by the examples below.
inductive AdvPlace where
  | p1 : AdvPlace
  | p2 : AdvPlace
deriving DecidableEq, Repr

inductive AdvTrans where
  | t1 : AdvTrans
  | t2 : AdvTrans
deriving DecidableEq, Repr

noncomputable def netPT : PetriNet AdvPlace AdvTrans where
  pre
    | .t1 => Finsupp.single AdvPlace.p1 1
    | .t2 => Finsupp.single AdvPlace.p2 1
  post
    | .t1 => Finsupp.single AdvPlace.p2 1
    | .t2 => Finsupp.single AdvPlace.p1 1

/-- A stochastic net (`ProcInt.StochasticPetriNet`) on `netPT`: `t1` is an immediate
transition with weight 3, `t2` is a timed transition with weight 1 (Marsan et al. 1984
GSPN; Leemans 2019). -/
noncomputable def stochNet : StochasticPetriNet AdvPlace AdvTrans where
  net := netPT
  weight
    | .t1 => (3 : NNRat)
    | .t2 => (1 : NNRat)
  kind
    | .t1 => .immediate
    | .t2 => .timed

-- `net` is Finsupp-valued (noncomputable), so we reason about `stochNet` via the
-- library's own lemmas rather than `#eval`. The conflict set {t1, t2} has total
-- weight 4, so t1 fires 3/4 of the time and t2 fires 1/4 (choiceWeight / fireProb).
theorem stochNet_choiceWeight :
    stochNet.choiceWeight {AdvTrans.t1, AdvTrans.t2} = 4 := by
  unfold StochasticPetriNet.choiceWeight
  rw [Finset.sum_pair (by decide : AdvTrans.t1 ≠ AdvTrans.t2)]
  norm_num [stochNet]

example : stochNet.fireProb {AdvTrans.t1, AdvTrans.t2} AdvTrans.t1 = 3 / 4 := by
  unfold StochasticPetriNet.fireProb
  rw [stochNet_choiceWeight]
  norm_num [stochNet]

example : stochNet.fireProb {AdvTrans.t1, AdvTrans.t2} AdvTrans.t2 = 1 / 4 := by
  unfold StochasticPetriNet.fireProb
  rw [stochNet_choiceWeight]
  norm_num [stochNet]

/-- Instance of `StochasticPetriNet.fireProb_sum`: over `{t1, t2}` (nonzero total weight),
the firing probabilities sum to 1. -/
example : ((({AdvTrans.t1, AdvTrans.t2} : Finset AdvTrans)).sum
    fun t => stochNet.fireProb {AdvTrans.t1, AdvTrans.t2} t) = 1 :=
  stochNet.fireProb_sum {AdvTrans.t1, AdvTrans.t2} (by rw [stochNet_choiceWeight]; norm_num)

-- ## ProcInt.Petri.Unfolding

inductive Cond where
  | c1 : Cond
  | c2 : Cond
deriving DecidableEq, Repr

inductive UEvent where
  | e1 : UEvent
deriving DecidableEq, Repr

/-- A one-event occurrence net (`ProcInt.OccurrenceNet`): `e1` consumes `c1` and
produces `c2` (Murata 1989 Section VII). -/
def occ1 : OccurrenceNet Cond UEvent where
  preC := fun _ => {Cond.c1}
  postC := fun _ => {Cond.c2}

/-- Instance of `OccurrenceNet.Flow`: `c1` flows into `e1` since `c1 ∈ preC e1`. -/
example : occ1.Flow (Sum.inl Cond.c1) (Sum.inr UEvent.e1) := by
  unfold OccurrenceNet.Flow
  simp [occ1]

/-- Instance of `OccurrenceNet.flow_causality`: the flow above is in particular a
causal dependency. -/
example : occ1.Causality (Sum.inl Cond.c1) (Sum.inr UEvent.e1) :=
  occ1.flow_causality (by unfold OccurrenceNet.Flow; simp [occ1])

/-- A branching process (`ProcInt.BranchingProcess`) over `occ1`, labeling conditions
by places of `netPT` and the event by `t1` (Engelfriet 1991; Murata 1989 Section VII). -/
def bp1 : BranchingProcess AdvPlace AdvTrans Cond UEvent where
  occ := occ1
  condPlace
    | .c1 => AdvPlace.p1
    | .c2 => AdvPlace.p2
  eventTrans := fun _ => AdvTrans.t1

/-- A finite complete unfolding prefix (`ProcInt.UnfoldingPrefix`, McMillan 1992) with
no cut-off events. -/
def prefix1 : UnfoldingPrefix AdvPlace AdvTrans Cond UEvent where
  process := bp1
  cutoff := ∅

-- ## ProcInt.Petri.OCPN

inductive AdvObjType where
  | order : AdvObjType
  | item : AdvObjType
deriving DecidableEq, Repr

/-- An object-centric Petri net (`ProcInt.OCPN`, van der Aalst & Berti 2020 Def. 5.1)
on `netPT`: `p1` is typed `order`, `p2` is typed `item`, with no variable arcs. -/
noncomputable def ocpn1 : OCPN AdvPlace AdvTrans AdvObjType where
  net := netPT
  pt
    | .p1 => .order
    | .p2 => .item
  varArc := fun _ _ => False

/-- Instance of `OCPN.WellFormed`: vacuously well-formed since `varArc` never holds. -/
example : ocpn1.WellFormed := by
  intro t p q _ _ hvar _
  exact absurd hvar (by simp [ocpn1])

inductive AdvObj where
  | o1 : AdvObj
deriving DecidableEq, Repr

def otyp1 : AdvObj → AdvObjType := fun _ => .order

/-- A colored marking (`ProcInt.ColoredMarking`) with one `order`-typed token on `p1`. -/
def marking1 : ColoredMarking AdvPlace AdvObj := {(AdvPlace.p1, AdvObj.o1)}

/-- Instance of `OCPN.Conforms`: `marking1`'s single token matches its place's type. -/
example : ocpn1.Conforms otyp1 marking1 := by
  intro pr hpr
  simp only [marking1, Multiset.mem_singleton] at hpr
  subst hpr
  simp [ocpn1, otyp1]

/-- Instance of `OCPN.conforms_add`: doubling a conforming marking stays conforming. -/
example : ocpn1.Conforms otyp1 (marking1 + marking1) :=
  ocpn1.conforms_add otyp1
    (by
      intro pr hpr
      simp only [marking1, Multiset.mem_singleton] at hpr
      subst hpr
      simp [ocpn1, otyp1])
    (by
      intro pr hpr
      simp only [marking1, Multiset.mem_singleton] at hpr
      subst hpr
      simp [ocpn1, otyp1])

end ProcInt.Playground
