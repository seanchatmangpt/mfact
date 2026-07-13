-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.EntailmentOrder
import ProcInt.Workflow.Multifractal
import ProcInt.Playground.MFW.Order

/-!
# Rank-order glue (Wave 1 — cross-layer bridges A×D, B×D)

Two cheap cross-layer bridges connecting the DAG rank function
(`ProcInt.Workflow.Multifractal.DAG`, layer D) to the admitted obligation order
(`ProcInt.MFW.Residue.EntailmentOrder.AdmittedObligationOrder`, layer A) and to the
antichain-producing `StrictOrder` machinery (`ProcInt.Playground.MFW.Order`, layer B).

`AdmittedObligationOrder` was declared in `EntailmentOrder.lean` as scaffolding for Wave M1,
with its own docstring noting it is "declared but not used by any Wave M0 theorem." This file
gives it its first instantiation: any `DAG`'s rank function lifts to an admitted obligation
preorder via Mathlib's `Preorder.lift`, and `DAG.edge` is exhibited as a strict descent in that
lifted order (bridge A×D). Separately, any rank function on `Fin n` induces a `StrictOrder`
(bridge vocabulary only), and the enabled frontier of that induced order inherits antichain-ness
for free from the already-proven `enabled_frontier_isAntichain` (bridge B×D) — no new antichain
argument is made here, only instantiation at a rank-induced order.

Standing: definitional glue plus two theorems (`DAG.edge_lt`,
`dag_rank_enabledFrontier_isAntichain`), both closed with no `sorry`/`admit`.
-/

namespace ProcInt.Workflow.Multifractal

/-- **A×D bridge, part 1.** Lifting a `DAG`'s rank function along `Preorder.lift` instantiates
the Wave-M0-scaffolded `AdmittedObligationOrder` class
(`ProcInt.MFW.Residue.EntailmentOrder`) for the first time: every `DAG` carries an admitted
obligation order for free, namely "lower rank." Deliberately a `def`, not a global `instance`:
a `V` can carry many different `DAG` structures (Lean's instance-argument check correctly
rejects `D` as non-inferable data), and `Preorder.lift` itself is documented in Mathlib as a
"reducible non-instance" for the same reason; tagged `@[reducible]` to match that convention. -/
@[reducible] def DAG.admittedOrder {V : Type*} (D : DAG V) :
    ProcInt.MFW.Residue.AdmittedObligationOrder V :=
  { Preorder.lift D.rank with }

/-- **A×D bridge, part 2.** A `DAG` edge is exactly a strict descent (`<`) in the admitted
obligation order induced by `DAG.admittedOrder`: restates `DAG.rank_lt` under the
admitted-order vocabulary that Wave M1's `manufacture_children_strictly_descend` will
eventually quantify over. -/
theorem DAG.edge_lt {V : Type*} (D : DAG V) {a b : V} (h : D.edge a b) :
    D.rank a < D.rank b :=
  D.rank_lt a b h

end ProcInt.Workflow.Multifractal

namespace ProcInt.Playground.MFW

/-- Any rank function on `Fin n` induces a finite `StrictOrder`: `i` precedes `j` exactly when
`r i < r j`, with irreflexivity, transitivity, and decidability all read off `Nat.lt`. -/
def StrictOrder.ofRank {n : Nat} (r : Fin n → Nat) : StrictOrder n where
  before i j := r i < r j
  decidableBefore i j := Nat.decLt (r i) (r j)
  irrefl i := Nat.lt_irrefl (r i)
  trans hij hjk := Nat.lt_trans hij hjk

end ProcInt.Playground.MFW

namespace ProcInt.Playground.Glue.RankOrder

open ProcInt.Workflow.Multifractal (DAG)
open ProcInt.Playground.MFW (StrictOrder Enabled IsAntichain enabled_frontier_isAntichain)

/-- **B×D bridge.** The enabled frontier of the `StrictOrder` induced by a `DAG`'s own rank
function (`StrictOrder.ofRank D.rank`) is an antichain. A direct instantiation of the
already-proven `enabled_frontier_isAntichain` (`ProcInt.Playground.MFW.Order`) at the
rank-induced order; no new antichain argument is made here. -/
theorem dag_rank_enabledFrontier_isAntichain {n : Nat} (D : DAG (Fin n)) (done : Fin n → Prop) :
    IsAntichain (StrictOrder.ofRank D.rank) (Enabled (StrictOrder.ofRank D.rank) done) :=
  enabled_frontier_isAntichain (StrictOrder.ofRank D.rank) done

end ProcInt.Playground.Glue.RankOrder
