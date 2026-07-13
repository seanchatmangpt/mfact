-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.Tenancy
import ProcInt.Playground.Glue.RuntimeReplay
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Fintype.Powerset

/-!
# SOC2 audit-flow witness — two-tenant compliant flow (positive companion)

This file is the deliberate *positive* case of a two-tenant SOC2 audit-flow witness, sibling to
`ProcInt.Playground.SOC2.AuditFlowViolation` (the negative companion, already in this directory,
which reuses `ProcInt.MFW.Residue.TenancyCountermodel` to exhibit a concrete cross-tenant leak
when `Separated` fails). Where that file shows what a control *failure* looks like, this file
builds an independent two-tenant closure (`Obl2`, `tag2`, `C2`) for which `Separated` genuinely
*holds*, and composes four already-proven, already-committed theorems from Waves 1-7 on that one
concrete scenario. Nothing here is new mathematical content (`AGENTS.md` §2, "Specialize first —
prove on the concrete admitted object"); this is instantiation, demonstrating that theorems
proven and verified in isolation by separate waves actually compose on shared concrete data,
which no prior file has shown.

Every check below cites the `ROADMAP_SOC2_MATH.md` §2 theorem card it instantiates:

* **Pieces 1 & 2 → Card 1** ("Tenancy isolation as residue independence → CC6"). Instantiates
  `minimalSupport_tenant_pure` (`ProcInt.MFW.Residue.Tenancy:86`) and
  `crossTenant_residue_disjoint` (`:111`) on a concrete four-obligation, two-tenant closure
  `C2`/`tag2` (`Obl2 := Fin 4`: `0`/`1` tenant-A evidence/goal, `2`/`3` tenant-B evidence/goal).
  Unlike `TenancyCountermodel` (which exhibits `Separated`'s *negative* case),
  `separated_C2 : Separated C2 tag2` is proved to genuinely hold here — `piece1_tenantA_pure`/
  `piece1_tenantB_pure` are the concrete `∀ a ∈ S, tag a = tag g` instances,
  `piece2_cross_tenant_disjoint` is the concrete `Disjoint S1 S2`.
* **Piece 3 → Card 2** ("No completed action escapes receipt → Processing Integrity
  PI1.1-PI1.5"). Instantiates `zero_unreceipted_completion` (`MFW/Runtime.lean:62`) at three
  concrete `ExecutionState 3` values along a chained `ProcInt.Playground.Glue.completeStep` audit
  trace: `0` = evidence collected, `1` = tenant-A obligation closed, `2` = tenant-B obligation
  closed. Honest flag, matching `ROADMAP_SOC2_MATH.md` Card 2's own standing note:
  `zero_unreceipted_completion` holds by construction for *every* `ExecutionState` (it unpacks a
  structure field, `completionReceipted`), so this piece's mechanically-checked content is that
  the concrete 3-step `completeStep` chain actually type-checks and produces well-formed states,
  not a discovered fact about this specific data.
* **Piece 4 → Card 3** ("Reordered event logs replay to one state → Availability A1.1-A1.3").
  Instantiates `Replay.replay_eq_of_traceEq` (`Swarm11/Replay.lean:105`), via
  `ProcInt.Playground.Glue.concurrent_commute`/`frontier_interleaving_replay_eq`, on two concrete
  audit-step orderings (tenant-A-first `[0,1,2]` vs tenant-B-first `[0,2,1]`), licensed by the
  structural concurrency of the two tenants' obligation-closing steps: both `1` and `2` depend
  only on the shared "evidence collected" step `0`, not on each other
  (`order3_concurrent_1_2 : Concurrent order3 1 2`). `reorder_replay_eq` is a real proof term —
  it does **not** close by `rfl` or record-level `decide` (`ExecutionState n` has `Prop`-valued
  fields and no `DecidableEq` instance; reassociating the underlying `Or` chain needs `propext`,
  exactly what `Glue.concurrent_commute`'s own proof does explicitly). The `checks` list below
  uses pointwise `Decidable` proxies instead, per that same obstruction.
* **Piece 5 → Card 3** (same card as piece 4; receipt validity is the same `Replay` machinery).
  Instantiates `Replay.manufacturedReceipt_valid` (`Swarm11/Replay.lean:149`) on the manufactured
  receipt for the tenant-A-first trace. This one *does* close unconditionally by `rfl`
  (`Receipt.final` is *defined* as `replay step trace initial`) — no decidability obstruction,
  the cleanest of the five pieces.

`checks` mirrors `ProcInt.Playground.Swarm11.Crown.checks`'s exact `List (String × Bool)`
aggregator shape. Facts about `ExecutionState`-valued data (pieces 3-5) use pointwise
`Decidable` proxies (an existential or `Iff` quantified over the finite index type `Fin 3`)
rather than record-level `decide`/`==`, for the reason stated above. `ExecutionState n`/
`completeStep`/`Replay.replay` carry no automatic `Decidable` instances for typeclass search to
find (see the "Decidability instances for the `checks` aggregator" section below for exactly why
and how each one is supplied); once those instances are registered, every entry in `checks` is a
genuine, independently re-decided Bool computation over the concrete data, not a hardcoded
literal standing in for one.
-/

namespace ProcInt.Playground.SOC2

namespace AuditFlow

open ProcInt.MFW.Residue
open ProcInt.Playground.MFW
open ProcInt.Playground.Glue
open ProcInt.Playground.Swarm11

/-! ## Pieces 1 & 2 — two tenants, positive `Separated` instance, disjoint residues -/

/-- Obligation universe for the two-tenant audit scenario: `0` = tenant-A evidence, `1` =
tenant-A goal, `2` = tenant-B evidence, `3` = tenant-B goal. Reusing `Fin 4` (as
`TenancyCountermodel` reuses `Fin 2`) keeps `Fintype`/`DecidableEq` off-the-shelf from Mathlib. -/
abbrev Obl2 := Fin 4

/-- `tag2 a = false` for tenant A (`a ∈ {0, 1}`), `true` for tenant B (`a ∈ {2, 3}`). -/
def tag2 (a : Obl2) : Bool := decide (2 ≤ a.val)

theorem tag2_zero : tag2 (0 : Obl2) = false := by decide
theorem tag2_one : tag2 (1 : Obl2) = false := by decide
theorem tag2_two : tag2 (2 : Obl2) = true := by decide
theorem tag2_three : tag2 (3 : Obl2) = true := by decide

/-- Tenant-A closure step: closing on a set containing the evidence obligation `0` also admits
the goal obligation `1`. Identical shape to `TenancyCountermodel.f`, over `Fin 4` instead of
`Fin 2`. -/
def stepA (X : Finset Obl2) : Finset Obl2 :=
  if (0 : Obl2) ∈ X then insert (1 : Obl2) X else X

theorem stepA_pos {X : Finset Obl2} (h : (0 : Obl2) ∈ X) : stepA X = insert 1 X := if_pos h
theorem stepA_neg {X : Finset Obl2} (h : (0 : Obl2) ∉ X) : stepA X = X := if_neg h

/-- Tenant-B evidence membership survives the tenant-A step unchanged: inserting `1` never adds
or removes `2`, since `2 ≠ 1`. -/
theorem mem2_stepA {X : Finset Obl2} : (2 : Obl2) ∈ stepA X ↔ (2 : Obl2) ∈ X := by
  by_cases h0 : (0 : Obl2) ∈ X
  · rw [stepA_pos h0, Finset.mem_insert]
    constructor
    · rintro (h | h)
      · exact absurd h (by decide)
      · exact h
    · exact Or.inr
  · rw [stepA_neg h0]

/-- The composed two-tenant closure step: tenant-A's edge (`0 ↦ 1`) and tenant-B's edge
(`2 ↦ 3`) applied in sequence. Deliberately not the identity closure (so `Separated` below is not
vacuously interesting), and deliberately has no term that inserts a tenant-A obligation because of
a tenant-B one or vice versa — the real cross-references-within-a-tenant, none-across-tenants
shape `Separated` requires. -/
def f2 (X : Finset Obl2) : Finset Obl2 :=
  if (2 : Obl2) ∈ stepA X then insert (3 : Obl2) (stepA X) else stepA X

theorem f2_pos {X : Finset Obl2} (h : (2 : Obl2) ∈ stepA X) :
    f2 X = insert 3 (stepA X) := if_pos h
theorem f2_neg {X : Finset Obl2} (h : (2 : Obl2) ∉ stepA X) : f2 X = stepA X := if_neg h

theorem f2_monotone : Monotone f2 := by
  intro X Y hXY
  have hA : stepA X ⊆ stepA Y := by
    by_cases hX0 : (0 : Obl2) ∈ X
    · have hY0 : (0 : Obl2) ∈ Y := hXY hX0
      rw [stepA_pos hX0, stepA_pos hY0]
      exact Finset.insert_subset_insert 1 hXY
    · by_cases hY0 : (0 : Obl2) ∈ Y
      · rw [stepA_neg hX0, stepA_pos hY0]
        exact hXY.trans (Finset.subset_insert 1 Y)
      · rw [stepA_neg hX0, stepA_neg hY0]
        exact hXY
  by_cases hX2 : (2 : Obl2) ∈ stepA X
  · have hY2 : (2 : Obl2) ∈ stepA Y := hA hX2
    rw [f2_pos hX2, f2_pos hY2]
    exact Finset.insert_subset_insert 3 hA
  · by_cases hY2 : (2 : Obl2) ∈ stepA Y
    · rw [f2_neg hX2, f2_pos hY2]
      exact hA.trans (Finset.subset_insert 3 (stepA Y))
    · rw [f2_neg hX2, f2_neg hY2]
      exact hA

theorem stepA_extensive : ∀ X : Finset Obl2, X ⊆ stepA X := by
  intro X
  by_cases h0 : (0 : Obl2) ∈ X
  · rw [stepA_pos h0]; exact Finset.subset_insert 1 X
  · rw [stepA_neg h0]

theorem f2_extensive : ∀ X : Finset Obl2, X ≤ f2 X := by
  intro X
  by_cases h2 : (2 : Obl2) ∈ stepA X
  · rw [f2_pos h2]
    exact (stepA_extensive X).trans (Finset.subset_insert 3 (stepA X))
  · rw [f2_neg h2]
    exact stepA_extensive X

theorem mem0_stepA {X : Finset Obl2} : (0 : Obl2) ∈ stepA X ↔ (0 : Obl2) ∈ X := by
  by_cases h0 : (0 : Obl2) ∈ X
  · rw [stepA_pos h0]
    exact ⟨fun _ => h0, fun _ => Finset.mem_insert_of_mem h0⟩
  · rw [stepA_neg h0]

theorem mem0_f2 {X : Finset Obl2} : (0 : Obl2) ∈ f2 X ↔ (0 : Obl2) ∈ X := by
  by_cases h2 : (2 : Obl2) ∈ stepA X
  · rw [f2_pos h2, Finset.mem_insert]
    constructor
    · rintro (h | h)
      · exact absurd h (by decide)
      · exact mem0_stepA.mp h
    · intro h
      exact Or.inr (mem0_stepA.mpr h)
  · rw [f2_neg h2]
    exact mem0_stepA

theorem mem2_f2 {X : Finset Obl2} : (2 : Obl2) ∈ f2 X ↔ (2 : Obl2) ∈ X := by
  by_cases h2 : (2 : Obl2) ∈ stepA X
  · have hX2 : (2 : Obl2) ∈ X := mem2_stepA.mp h2
    rw [f2_pos h2]
    exact ⟨fun _ => hX2, fun _ => Finset.mem_insert_of_mem h2⟩
  · rw [f2_neg h2]
    exact mem2_stepA

theorem mem1_f2_of_mem0 {X : Finset Obl2} (h : (0 : Obl2) ∈ X) : (1 : Obl2) ∈ f2 X := by
  have h1 : (1 : Obl2) ∈ stepA X := by rw [stepA_pos h]; exact Finset.mem_insert_self 1 X
  by_cases h2 : (2 : Obl2) ∈ stepA X
  · rw [f2_pos h2]; exact Finset.mem_insert_of_mem h1
  · rw [f2_neg h2]; exact h1

theorem mem3_f2_of_mem2 {X : Finset Obl2} (h : (2 : Obl2) ∈ X) : (3 : Obl2) ∈ f2 X := by
  have h2' : (2 : Obl2) ∈ stepA X := mem2_stepA.mpr h
  rw [f2_pos h2']
  exact Finset.mem_insert_self 3 (stepA X)

/-- `f2 (f2 X) = f2 X` unconditionally: once tenant-A's insert (`1`, gated on `0`) and tenant-B's
insert (`3`, gated on `2`) have each fired once, re-running either gate is a no-op
(`Finset.insert_eq_self`), since the element each gate would insert is already present. -/
theorem f2_idempotent : ∀ X : Finset Obl2, f2 (f2 X) ≤ f2 X := by
  intro X
  have hStepA_eq : stepA (f2 X) = f2 X := by
    by_cases h0 : (0 : Obl2) ∈ f2 X
    · rw [stepA_pos h0, Finset.insert_eq_self]
      exact mem1_f2_of_mem0 (mem0_f2.mp h0)
    · rw [stepA_neg h0]
  have hEq : f2 (f2 X) = f2 X := by
    by_cases h2 : (2 : Obl2) ∈ stepA (f2 X)
    · rw [f2_pos h2, hStepA_eq, Finset.insert_eq_self]
      exact mem3_f2_of_mem2 (mem2_f2.mp (hStepA_eq ▸ h2))
    · rw [f2_neg h2, hStepA_eq]
  exact hEq.le

/-- The genuine `ClosureOperator` for the two-tenant scenario, built honestly from
`f2_monotone`/`f2_extensive`/`f2_idempotent`, exactly as `TenancyCountermodel.C` is built. -/
def C2 : SemanticClosure Obl2 := ClosureOperator.mk' f2 f2_monotone f2_extensive f2_idempotent

theorem C2_apply (X : Finset Obl2) : C2 X = f2 X := rfl

theorem C2_empty : C2 (∅ : Finset Obl2) = ∅ := by
  rw [C2_apply]; decide

theorem C2_zero : C2 ({0} : Finset Obl2) = {0, 1} := by
  rw [C2_apply]; decide

theorem C2_two : C2 ({2} : Finset Obl2) = {2, 3} := by
  rw [C2_apply]; decide

/-- `Separated` holds for real on `C2`/`tag2`: membership of a fixed-tenant goal in the closure
of `X` depends only on `X`'s same-tenant slice. A fully quantified check over
`Finset (Fin 4) × Fin 4` (16 × 4 = 64 decidable cases), closed by kernel `decide` since `C2`
transparently reduces to `f2` (`C2_apply`, `rfl`) and `Finset (Fin 4)`/`Fin 4` are both
`Fintype`+`DecidableEq`. This is the positive counterpart to
`TenancyCountermodel.not_separated`. -/
theorem separated_C2 : Separated C2 tag2 := by
  show ∀ (X : Finset Obl2) (g : Obl2),
    g ∈ C2 X ↔ g ∈ C2 (X.filter (fun a => tag2 a = tag2 g))
  decide

/-- Tenant-A context: empty. Tenant-A goal: the goal obligation `1`. -/
def G1 : Finset Obl2 := ∅
def g1 : Obl2 := 1
/-- The minimal support for tenant-A's goal: the tenant-A evidence obligation `0`. -/
def S1 : Finset Obl2 := {0}

/-- Tenant-B context: empty. Tenant-B goal: the goal obligation `3`. -/
def G2 : Finset Obl2 := ∅
def g2 : Obl2 := 3
/-- The minimal support for tenant-B's goal: the tenant-B evidence obligation `2`. -/
def S2 : Finset Obl2 := {2}

/-- `S1 = {0}` is a minimal support for tenant-A's goal `1`, given the empty context, under `C2`:
sufficient (`1 ∈ C2 {0} = {0, 1}`, `C2_zero`) and pointwise load-bearing (erasing `0` leaves `∅`,
and `1 ∉ C2 ∅ = ∅`, `C2_empty`). Mirrors `TenancyCountermodel.singleton_mem_residue` exactly. -/
theorem hS1 : S1 ∈ residue C2 G1 g1 := by
  refine ⟨?_, ?_⟩
  · show (1 : Obl2) ∈ C2 ((∅ : Finset Obl2) ∪ ({0} : Finset Obl2))
    rw [Finset.empty_union, C2_zero]
    decide
  · intro a ha
    have ha0 : a = (0 : Obl2) := Finset.mem_singleton.mp ha
    subst ha0
    show ¬ (1 : Obl2) ∈ C2 ((∅ : Finset Obl2) ∪ (({0} : Finset Obl2).erase (0 : Obl2)))
    rw [Finset.empty_union, Finset.erase_singleton, C2_empty]
    decide

/-- `S2 = {2}` is a minimal support for tenant-B's goal `3`, given the empty context, under `C2`:
the tenant-B mirror of `hS1`. -/
theorem hS2 : S2 ∈ residue C2 G2 g2 := by
  refine ⟨?_, ?_⟩
  · show (3 : Obl2) ∈ C2 ((∅ : Finset Obl2) ∪ ({2} : Finset Obl2))
    rw [Finset.empty_union, C2_two]
    decide
  · intro a ha
    have ha2 : a = (2 : Obl2) := Finset.mem_singleton.mp ha
    subst ha2
    show ¬ (3 : Obl2) ∈ C2 ((∅ : Finset Obl2) ∪ (({2} : Finset Obl2).erase (2 : Obl2)))
    rw [Finset.empty_union, Finset.erase_singleton, C2_empty]
    decide

/-- Both tenant contexts are vacuously tenant-pure (empty). -/
theorem hG1_pure : ∀ a ∈ G1, tag2 a = tag2 g1 := fun a ha => absurd ha (Finset.notMem_empty a)
theorem hG2_pure : ∀ a ∈ G2, tag2 a = tag2 g2 := fun a ha => absurd ha (Finset.notMem_empty a)

/-- The two goals genuinely belong to different tenants. -/
theorem hne_tags : tag2 g1 ≠ tag2 g2 := by decide

/-- **Card 1, first conclusion.** A real instantiation of `minimalSupport_tenant_pure`
(`ProcInt.MFW.Residue.Tenancy:86`) at concrete data: every member of tenant-A's minimal support
`S1` is tagged for tenant A. Concretely `tag2 0 = tag2 1` (`false = false`). -/
theorem piece1_tenantA_pure : ∀ a ∈ S1, tag2 a = tag2 g1 :=
  minimalSupport_tenant_pure separated_C2 hS1 hG1_pure

/-- **Card 1, first conclusion, tenant B.** The mirror instantiation for tenant B: concretely
`tag2 2 = tag2 3` (`true = true`). -/
theorem piece1_tenantB_pure : ∀ a ∈ S2, tag2 a = tag2 g2 :=
  minimalSupport_tenant_pure separated_C2 hS2 hG2_pure

/-- **Card 1, second conclusion.** A real instantiation of `crossTenant_residue_disjoint`
(`ProcInt.MFW.Residue.Tenancy:111`) at concrete data: tenant-A's minimal support `S1` and
tenant-B's minimal support `S2` are disjoint — concretely `Disjoint {0} {2}`. This is the
positive counterpart to `AuditFlowViolation.violation_not_disjoint`, which exhibits the same
guarantee failing when `Separated` does not hold. -/
theorem piece2_cross_tenant_disjoint : Disjoint S1 S2 :=
  crossTenant_residue_disjoint separated_C2 hG1_pure hG2_pure hne_tags hS1 hS2

/-! ## Piece 3 — `ExecutionState 3` audit trace, `zero_unreceipted_completion` at each step -/

/-- Order over the 3-step audit trace: index `0` = evidence collected, `1` = tenant-A obligation
closed, `2` = tenant-B obligation closed. `0` is a common prerequisite of `1` and `2`; `1`/`2`
are mutually concurrent (neither depends on the other, only both on `0`). -/
def order3 : StrictOrder 3 where
  before i j := i = 0 ∧ j ≠ 0
  decidableBefore := inferInstance
  irrefl := fun _ h => h.2 h.1
  trans := fun {_ _ _} hij hjk => absurd hjk.1 hij.2

/-- Tenant-A's and tenant-B's obligation-closing steps are structurally concurrent: neither `1`
precedes `2` nor `2` precedes `1` under `order3` (both only ever come *after* `0`, never after
each other). -/
theorem order3_concurrent_1_2 : Concurrent order3 1 2 := by
  show (1 : Fin 3) ≠ 2 ∧ ¬ order3.before 1 2 ∧ ¬ order3.before 2 1
  decide

/-- The initial audit state: nothing collected, nothing completed, nothing receipted, every step
authorized. -/
def s0 : ExecutionState 3 where
  authorized := fun _ => True
  completed := fun _ => False
  receipted := fun _ => False
  completionReceipted := fun _ h => h.elim

/-- After recording that evidence was collected (step `0`). -/
def s1 : ExecutionState 3 := completeStep order3 0 s0

/-- After additionally recording that tenant A's obligation was closed (step `1`). -/
def s2 : ExecutionState 3 := completeStep order3 1 s1

/-- After additionally recording that tenant B's obligation was closed (step `2`) — the fully
closed audit trace `[0, 1, 2]`. -/
def s3 : ExecutionState 3 := completeStep order3 2 s2

/-- **Card 2.** A real instantiation of `zero_unreceipted_completion` (`MFW/Runtime.lean:62`) at
the concrete state after step `0`. -/
theorem s1_zero_unreceipted : ¬ ∃ i, s1.completed i ∧ ¬ s1.receipted i :=
  zero_unreceipted_completion s1

/-- **Card 2.** The same instantiation after step `1`. -/
theorem s2_zero_unreceipted : ¬ ∃ i, s2.completed i ∧ ¬ s2.receipted i :=
  zero_unreceipted_completion s2

/-- **Card 2.** The same instantiation after step `2` — the fully closed audit trace. -/
theorem s3_zero_unreceipted : ¬ ∃ i, s3.completed i ∧ ¬ s3.receipted i :=
  zero_unreceipted_completion s3

/-! ## Piece 4 — two orderings of evidence collection, `TraceEq`/`replay_eq_of_traceEq` -/

/-- Tenant-A-first ordering: evidence, then tenant A's closing, then tenant B's closing. -/
def trace1 : List (Fin 3) := [0, 1, 2]

/-- Tenant-B-first ordering: evidence, then tenant B's closing, then tenant A's closing. -/
def trace2 : List (Fin 3) := [0, 2, 1]

/-- A real instantiation of `ProcInt.Playground.Glue.concurrent_commute`, consuming
`order3_concurrent_1_2`. -/
theorem hCommute12 : Replay.Commute (completeStep order3) 1 2 :=
  concurrent_commute order3 order3_concurrent_1_2

/-- `trace1` and `trace2` are related by exactly one admitted commuting swap (of the mutually
concurrent steps `1` and `2`), with leading segment `[0]` and empty suffix:
`[0] ++ [1, 2] = trace1`, `[0] ++ [2, 1] = trace2`. -/
theorem hTraceEq12 : Replay.TraceEq (completeStep order3) trace1 trace2 :=
  Replay.TraceEq.swap [0] [] 1 2 hCommute12

/-- **Card 3.** A real instantiation of `Replay.replay_eq_of_traceEq` (`Swarm11/Replay.lean:105`,
via `frontier_interleaving_replay_eq`'s direct pattern): both audit-step orderings replay to the
identical final `ExecutionState`. This does **not** close by `rfl` or `decide` — see the module
docstring for why (no `DecidableEq (ExecutionState n)`, and the underlying `Or`-reassociation is
only propositionally, not definitionally, equal). -/
theorem reorder_replay_eq :
    Replay.replay (completeStep order3) trace1 s0 =
      Replay.replay (completeStep order3) trace2 s0 :=
  Replay.replay_eq_of_traceEq (completeStep order3) hTraceEq12 s0

/-! ## Piece 5 — receipt, `ValidReceipt` -/

/-- The manufactured receipt for the tenant-A-first audit trace, starting from the initial
state. -/
def auditReceipt : Replay.Receipt (Fin 3) (ExecutionState 3) :=
  Replay.manufactureReceipt (completeStep order3) s0 trace1

/-- **Card 3.** A real instantiation of `Replay.manufacturedReceipt_valid`
(`Swarm11/Replay.lean:149`): the manufactured receipt is valid. Closes by `rfl` unconditionally
(`Receipt.final` is *defined* as `replay step trace initial`) — no decidability obstruction. -/
theorem auditReceipt_valid : Replay.ValidReceipt (completeStep order3) auditReceipt :=
  Replay.manufacturedReceipt_valid (completeStep order3) s0 trace1

/-! ## Decidability instances for the `checks` aggregator

`ExecutionState n` has `Prop`-valued fields and carries no `DecidableEq` instance, and
`completeStep`/`Replay.replay` are plain `def`s in other files. Lean's typeclass search does not
unfold plain `def`s the way `show`/`rfl` (default transparency) do, so it cannot automatically
discover that the concrete states built above are decidable, even though every one of them
unfolds — one `completeStep` layer at a time — to a plain `Or`/`False` chain over `Fin 3`. Each
instance below supplies exactly that one-step unfolding explicitly (`show` to the
definitionally-equal, already-decidable form, then `infer_instance`) — a real, mechanical
discharge of a real gap, not a shortcut around it. This is the identical obstruction
`ProcInt.Playground.Glue.concurrent_commute`'s own docstring names for `ExecutionState`
equality; here it blocks `Decidable` synthesis instead of `rfl`. -/

instance decidable_s0_completed : DecidablePred s0.completed := fun _ => by
  show Decidable False
  infer_instance

instance decidable_s0_receipted : DecidablePred s0.receipted := fun _ => by
  show Decidable False
  infer_instance

instance decidable_s1_completed : DecidablePred s1.completed := fun i => by
  show Decidable (i = 0 ∨ s0.completed i)
  infer_instance

instance decidable_s1_receipted : DecidablePred s1.receipted := fun i => by
  show Decidable (i = 0 ∨ s0.receipted i)
  infer_instance

instance decidable_s2_completed : DecidablePred s2.completed := fun i => by
  show Decidable (i = 1 ∨ s1.completed i)
  infer_instance

instance decidable_s2_receipted : DecidablePred s2.receipted := fun i => by
  show Decidable (i = 1 ∨ s1.receipted i)
  infer_instance

instance decidable_s3_completed : DecidablePred s3.completed := fun i => by
  show Decidable (i = 2 ∨ s2.completed i)
  infer_instance

instance decidable_s3_receipted : DecidablePred s3.receipted := fun i => by
  show Decidable (i = 2 ∨ s2.receipted i)
  infer_instance

/-- The tenant-B-first ordering's intermediate state: evidence collected (`0`), then tenant B's
obligation closed (`2`) — the second step of `trace2 = [0, 2, 1]`. -/
def s1alt : ExecutionState 3 := completeStep order3 2 s1

/-- The tenant-B-first ordering's final state — evidence, tenant B, tenant A — reached by
following `trace2` from `s0`. -/
def s2alt : ExecutionState 3 := completeStep order3 1 s1alt

instance decidable_s1alt_completed : DecidablePred s1alt.completed := fun i => by
  show Decidable (i = 2 ∨ s1.completed i)
  infer_instance

instance decidable_s1alt_receipted : DecidablePred s1alt.receipted := fun i => by
  show Decidable (i = 2 ∨ s1.receipted i)
  infer_instance

instance decidable_s2alt_completed : DecidablePred s2alt.completed := fun i => by
  show Decidable (i = 1 ∨ s1alt.completed i)
  infer_instance

instance decidable_s2alt_receipted : DecidablePred s2alt.receipted := fun i => by
  show Decidable (i = 1 ∨ s1alt.receipted i)
  infer_instance

/-- `Replay.replay` over `trace1 = [0, 1, 2]` from `s0` unfolds, by pure computation through the
recursive definition of `Replay.replay` and three `completeStep` applications, to exactly `s3` —
the same tenant-A-first chain `s0 → s1 → s2 → s3` defined above. Closes by `rfl`. -/
theorem replay_trace1_eq_s3 : Replay.replay (completeStep order3) trace1 s0 = s3 := rfl

/-- `Replay.replay` over `trace2 = [0, 2, 1]` from `s0` unfolds, the same way, to `s2alt` — the
tenant-B-first chain `s0 → s1 → s1alt → s2alt`. Closes by `rfl`. -/
theorem replay_trace2_eq_s2alt : Replay.replay (completeStep order3) trace2 s0 = s2alt := rfl

/-- The Card-3 conclusion (`reorder_replay_eq`) restated on the two named final states:
`s3 = s2alt`. Derived from the real theorem plus the two computational identities above, not
independently asserted — this is what licenses deciding pointwise agreement between `s3` and
`s2alt` below as a genuine re-verification of `reorder_replay_eq`, not an unrelated coincidence. -/
theorem s3_eq_s2alt : s3 = s2alt := by
  have h := reorder_replay_eq
  rw [replay_trace1_eq_s3, replay_trace2_eq_s2alt] at h
  exact h

/-- `auditReceipt.final` unfolds, by the same computation (`manufactureReceipt`'s `final` field is
literally `replay step trace initial`), to `s3`. Closes by `rfl`. -/
theorem auditReceipt_final_eq_s3 : auditReceipt.final = s3 := rfl

instance decidable_auditReceipt_final_completed : DecidablePred auditReceipt.final.completed := by
  rw [auditReceipt_final_eq_s3]
  infer_instance

instance decidable_auditReceipt_final_receipted : DecidablePred auditReceipt.final.receipted := by
  rw [auditReceipt_final_eq_s3]
  infer_instance

/-! ## `checks` — standing-aware Bool aggregator, `Crown.lean`-style -/

/-- Standing-aware audit-flow checks consumed by a live verifier, mirroring
`ProcInt.Playground.Swarm11.Crown.checks`'s exact `List (String × Bool)` shape. Every entry is a
genuine, independently re-decided Bool computation over the concrete data above (via the
instances registered just above for pieces 3-5), not a hardcoded literal standing in for one. -/
def checks : List (String × Bool) := [
  ("card1-tenantA-minimal-support-tenant-pure",
    decide (tag2 (0 : Obl2) = tag2 g1)),
  ("card1-tenantB-minimal-support-tenant-pure",
    decide (tag2 (2 : Obl2) = tag2 g2)),
  ("card1-cross-tenant-residues-disjoint",
    decide (Disjoint S1 S2)),
  ("card1-tenants-distinctly-tagged",
    decide (tag2 g1 ≠ tag2 g2)),
  ("card1-separated-holds-on-two-tenant-closure",
    decide (∀ (X : Finset Obl2) (g : Obl2),
      g ∈ C2 X ↔ g ∈ C2 (X.filter (fun a => tag2 a = tag2 g)))),
  ("card2-audit-step1-zero-unreceipted-completion",
    decide (¬ ∃ i : Fin 3, s1.completed i ∧ ¬ s1.receipted i)),
  ("card2-audit-step2-zero-unreceipted-completion",
    decide (¬ ∃ i : Fin 3, s2.completed i ∧ ¬ s2.receipted i)),
  ("card2-audit-step3-zero-unreceipted-completion",
    decide (¬ ∃ i : Fin 3, s3.completed i ∧ ¬ s3.receipted i)),
  ("card3-dual-order-replay-completed-agree",
    decide (∀ i : Fin 3, s3.completed i ↔ s2alt.completed i)),
  ("card3-dual-order-replay-receipted-agree",
    decide (∀ i : Fin 3, s3.receipted i ↔ s2alt.receipted i)),
  ("card3-manufactured-receipt-completed-matches-computed-final",
    decide (∀ i : Fin 3, auditReceipt.final.completed i ↔ s3.completed i)),
  ("card3-manufactured-receipt-receipted-matches-computed-final",
    decide (∀ i : Fin 3, auditReceipt.final.receipted i ↔ s3.receipted i))
]

end AuditFlow

end ProcInt.Playground.SOC2
