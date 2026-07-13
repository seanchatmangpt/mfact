-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.Tenancy

/-!
# SOC2 audit-flow tenancy violation (negative companion, non-vacuity discharge)

This file is the deliberate *negative* case of a two-tenant SOC2 audit-flow witness. It answers a
question a purely positive/compliant case can never answer by itself: what does a concrete
cross-tenant control failure actually look like when the `Separated` hypothesis that underwrites
isolation (`ProcInt.MFW.Residue.Tenancy`'s `crossTenant_residue_disjoint`) genuinely fails?
`AGENTS.md` §3 (the Combinatorial Maximalism Mandate) forbids attaching a compliance-sounding
claim ("tenant audit residues never leak") to a theorem that has only ever been exercised on
inputs where its hypotheses trivially hold — a guarantee never checked against a case where it
*could* fail is scaffolding, not evidence. This file is that non-vacuity discharge, phrased as a
SOC2-relevant control-failure scenario: two tenants (A, B) whose audit-evidence obligations are
supposed to stay isolated, and a concrete closure operator under which they do not.

Status note (honest, not aspirational): the design for this witness pairs this negative file with
a positive companion at `ProcInt.Playground.Swarm11.AuditFlow` (a compliant two-tenant closure
where `Separated` genuinely holds and `crossTenant_residue_disjoint` fires for real). That
positive file does not exist in this build yet. Rather than import a module that isn't there, or
gesture at a "compliant case" this repo cannot currently compile, this file is fully
self-contained: it depends only on `ProcInt.MFW.Residue.Tenancy` and reuses
`ProcInt.MFW.Residue.TenancyCountermodel` verbatim — `Obl`, `tag`, `C`, `C_zero`, `C_empty`,
`not_separated`, `singleton_mem_residue` — with no edits to `Tenancy.lean`. When the positive
companion lands, the two files together let the SOC2 audit-flow test distinguish a compliant run
from a control-failure run on the same underlying vocabulary (`Obl`, `tag`, `residue`,
`Separated`); until then, this file stands on its own as a genuine falsifier.

`TenancyCountermodel` already proves `¬ Separated C tag` (`not_separated`), but stops at showing
`minimalSupport_tenant_pure`'s single-goal purity conclusion fails. This file goes one step
further and targets `crossTenant_residue_disjoint` itself — the *cross-tenant* guarantee, not the
single-goal one — showing it fails too, in lock-step with `Separated`. Concretely: under the
countermodel closure `C`, the obligation `0` (tagged tenant A, `tag 0 = false`) is the *identical*
minimal support for both tenant A's own goal `0` and tenant B's goal `1`, given the empty context
for each. The same evidentiary artifact is load-bearing for two different tenants' audit trails at
once — exactly the kind of cross-tenant evidence leak a SOC2 logical-isolation control is meant to
catch. `crossTenant_residue_disjoint` cannot honestly be invoked here (its `Separated` hypothesis
is unavailable — `TenancyCountermodel.not_separated` proves it false, and no `sorry`/fake
hypothesis is introduced to force it through), and its would-be conclusion,
`Disjoint ({0} : Finset Obl) ({0} : Finset Obl)`, is independently exhibited false below.

Standing: every theorem in this file is `PROVEN` by direct proof term or `decide`; no `sorry`, no
`admit`, no `native_decide` standing in for a gap. `checks` at the bottom is a `Bool` sanity
companion in the `Crown.lean` style, restricted to facts that are cheaply and unambiguously
decidable (tags and small literal `Finset (Fin 2)` memberships) rather than re-deciding anything
that routes through the closure operator's internal `ClosureOperator.mk'` wrapper.
-/

namespace ProcInt.Playground.SOC2

namespace AuditFlowViolation

open ProcInt.MFW.Residue

/-- `{0}` is a minimal support for the tenant-A goal `0` itself, given the empty context, under
the countermodel closure `C`. Mirrors `TenancyCountermodel.singleton_mem_residue` exactly (same
proof shape, goal `0` in place of goal `1`): sufficient because `C {0} = {0, 1} ∋ 0`
(`TenancyCountermodel.C_zero`), and pointwise load-bearing because erasing the sole member `0`
collapses the support to `∅`, and `0 ∉ C ∅ = ∅` (`TenancyCountermodel.C_empty`). -/
theorem zero_mem_residue_for_zero_goal :
    ({0} : Finset TenancyCountermodel.Obl) ∈
      residue TenancyCountermodel.C (∅ : Finset TenancyCountermodel.Obl)
        (0 : TenancyCountermodel.Obl) := by
  refine ⟨?_, ?_⟩
  · show (0 : TenancyCountermodel.Obl) ∈
      TenancyCountermodel.C
        ((∅ : Finset TenancyCountermodel.Obl) ∪ ({0} : Finset TenancyCountermodel.Obl))
    rw [Finset.empty_union, TenancyCountermodel.C_zero]
    decide
  · intro a ha
    have ha0 : a = (0 : TenancyCountermodel.Obl) := Finset.mem_singleton.mp ha
    subst ha0
    show ¬ (0 : TenancyCountermodel.Obl) ∈
      TenancyCountermodel.C
        ((∅ : Finset TenancyCountermodel.Obl) ∪
          (({0} : Finset TenancyCountermodel.Obl).erase (0 : TenancyCountermodel.Obl)))
    rw [Finset.empty_union, Finset.erase_singleton, TenancyCountermodel.C_empty]
    decide

/-- The concrete leak: the very same support set `{0}` is a minimal support for the tenant-A goal
`0` (`zero_mem_residue_for_zero_goal`, proved above) *and* for the tenant-B goal `1`
(`TenancyCountermodel.singleton_mem_residue`, reused verbatim from `Tenancy.lean`). One tenant-A
obligation, one identical residue set, feeding two different tenants' goals. -/
theorem violation_shared_support :
    ({0} : Finset TenancyCountermodel.Obl) ∈
        residue TenancyCountermodel.C (∅ : Finset TenancyCountermodel.Obl)
          (0 : TenancyCountermodel.Obl) ∧
      ({0} : Finset TenancyCountermodel.Obl) ∈
        residue TenancyCountermodel.C (∅ : Finset TenancyCountermodel.Obl)
          (1 : TenancyCountermodel.Obl) :=
  ⟨zero_mem_residue_for_zero_goal, TenancyCountermodel.singleton_mem_residue⟩

/-- The two goals genuinely belong to different tenants (`tag 0 = false`, tenant A;
`tag 1 = true`, tenant B) — this is the `hne` side condition `crossTenant_residue_disjoint` would
need, so the failure below is not merely "the goals happened to coincide". -/
theorem violation_tenants_differ :
    TenancyCountermodel.tag (0 : TenancyCountermodel.Obl) ≠
      TenancyCountermodel.tag (1 : TenancyCountermodel.Obl) := by
  rw [TenancyCountermodel.tag_zero, TenancyCountermodel.tag_one]
  decide

/-- The cross-tenant disjointness guarantee genuinely fails here: the two supports from
`violation_shared_support` are not merely inequal, they are *identical*, hence maximally
non-disjoint. This is the exhibited failure of `crossTenant_residue_disjoint`'s conclusion, proved
directly (not via a `decide` on `Disjoint` — `Finset.disjoint_left` unfolds it to a concrete
membership contradiction instead, keeping the proof independent of whichever `Decidable Disjoint`
instance happens to be in scope). -/
theorem violation_not_disjoint :
    ¬ Disjoint ({0} : Finset TenancyCountermodel.Obl) ({0} : Finset TenancyCountermodel.Obl) := by
  intro hdisjoint
  exact (Finset.disjoint_left.mp hdisjoint (Finset.mem_singleton_self 0))
    (Finset.mem_singleton_self 0)

/-- The two-part violation, packaged: the hypothesis `crossTenant_residue_disjoint` needs
(`Separated C tag`) fails (`TenancyCountermodel.not_separated`, reused verbatim), and — not merely
"therefore left unproved" but independently checked — its conclusion fails too
(`violation_not_disjoint`). This is what distinguishes a genuine countermodel from an merely
unproved theorem: both the premise and the would-be conclusion are shown false on the same
concrete data, so `Separated` is exhibited as load-bearing for cross-tenant isolation, not
decorative. -/
theorem violation_summary :
    ¬ Separated TenancyCountermodel.C TenancyCountermodel.tag ∧
      ¬ Disjoint ({0} : Finset TenancyCountermodel.Obl) ({0} : Finset TenancyCountermodel.Obl) :=
  ⟨TenancyCountermodel.not_separated, violation_not_disjoint⟩

/-- Standing-aware sanity checks consumed by a live verifier, `Crown.lean`-style. Restricted to
cheaply decidable facts (Bool-valued `tag`, small literal `Finset (Fin 2)` membership) rather than
re-deciding anything that routes through `TenancyCountermodel.C`'s `ClosureOperator.mk'` wrapper —
those facts are instead carried by the proof terms above. -/
def checks : List (String × Bool) := [
  ("tenant-a-goal-tagged-false",
    TenancyCountermodel.tag (0 : TenancyCountermodel.Obl) == false),
  ("tenant-b-goal-tagged-true",
    TenancyCountermodel.tag (1 : TenancyCountermodel.Obl) == true),
  ("goal-tenants-differ",
    TenancyCountermodel.tag (0 : TenancyCountermodel.Obl) !=
      TenancyCountermodel.tag (1 : TenancyCountermodel.Obl)),
  ("leaking-obligation-in-shared-support",
    decide ((0 : TenancyCountermodel.Obl) ∈ ({0} : Finset TenancyCountermodel.Obl))),
  ("shared-support-nonempty",
    decide (({0} : Finset TenancyCountermodel.Obl) ≠ ∅))
]

end AuditFlowViolation

end ProcInt.Playground.SOC2
