-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib.Data.Finset.Defs
import Mathlib.Data.Finset.Basic
import ProcInt.Playground.Swarm11.Standing
import ProcInt.MFW.Residue.Tenancy
import ProcInt.Playground.Swarm11.Replay
import ProcInt.Playground.SOC2.AuditFlow
import ProcInt.Playground.SOC2.AuditFlowViolation
import ProcInt.Playground.SOC2.ManufactureTenancyGap
import ProcInt.Playground.SOC2.AxiomAuditSOC2

/-! # Standing Path — SOC2 crown (testing-atlas T132/T133, real compiled witness)

Instantiates testing-atlas **T132** (`MFW.TST.STANDING_PATH.EDGE_COVERAGE.132`, "Are all
declared mathematical/correspondence edges represented by admitted proofs or explicit gaps?")
and **T133** (`MFW.TST.STANDING_PATH.PATH_COVERAGE.133`, "Does every crown claim have a complete
admitted path from controlled source to crown consequence?") — see
`docs/testing-atlas/10_llm_guides/30_standing_path.md` — against the SOC2 two-tenant audit-flow
crown, using the **Eleven-Witness Crown Matrix**
(`docs/testing-atlas/10_llm_guides/31_ELEVEN_WITNESS_CROWN_MATRIX.md`):
`W_C(SOC2) = (K,P,N,C_m,P_b,M_e,M_u,C_o,F,R,S)`.

**Gap closed.** `docs/TESTING_ATLAS_INTEGRATION.md` §4's aspirational-families table records,
independently confirmed here: "**STANDING_PATH**: `StandingPathReceipt` exists only in
`docs/testing-atlas/30_templates/StandingPath.lean.template`;
`grep -rl \"StandingPathReceipt\|StandingPath\" procint/ProcInt --include=\"*.lean\"` returns
nothing." This file is the first `ProcInt` artifact to instantiate that template's shape against
a real crown's `checks` lists as a standing-coupled claim, per this wave's assignment: "the
crown's `checks` lists exist but nothing consumes them as a standing-coupled claim."

**The honest result, stated up front (no vacuous `complete` proof).** Of the eleven rows, six
are genuinely admitted for this crown (`K, P, N, C_m, C_o, R`), one is carved out as
`NOT_APPLICABLE` (`P_b`, not force-admitted — see the P_b section below), and four remain open
(`M_e, M_u, F, S`). `admitted ⊂ required` (`admitted_ssubset_required` below) is what this file
proves — not `admitted = required`. Per `AGENTS.md` §3 ("No vacuous tautologies") this file does
not force the template's `complete : admitted = required` field for a receipt that does not
exist yet; `missing_eq_exact_rows` names the exact four open rows, machine-derived by `decide`
on the concrete `Finset`s below, not asserted in prose.

**Claim ceiling.** This file establishes exactly what `decide` proves about the two concrete
`Finset RequiredEdge` values below (`required`, `admitted`) and what `#check`ing the cited
identifiers establishes (that they exist and type-check). It does not establish that the atlas's
informal per-row "primary tests" (T001, T003, T050, …) are individually satisfied in the atlas's
own sense — only that a real, previously-committed, kernel-checked theorem in this repo backs
each row this file marks admitted. Whether that theorem's content is the *correct* formalization
of the row's intent is a `CORRESPONDENCE`-edge question (`AGENTS.md` §4), out of scope here,
exactly as `AxiomAuditSOC2.lean`'s own claim-ceiling note states for T006/T007.
-/

namespace ProcInt.Playground.SOC2.StandingPathSOC2

open ProcInt.Playground.Swarm11 (Standing Claim ClaimCeiling)

/-! ## `RequiredEdge` / `NodeId` — adapted from the template

`docs/testing-atlas/30_templates/StandingPath.lean.template`:

```
structure NodeId where
  value : String

structure RequiredEdge where
  source : NodeId
  target : NodeId
  witnessName : Name
```

Reproduced below field-for-field, with one adaptation: `witnessName : Name` (a `Lean.Name`)
becomes `witnessName : String`. Nothing in this file's use of `RequiredEdge` needs elaborated
`Name` machinery (macro hygiene, dot-notation resolution, `Name`-level scoping) — every row is
compared purely by string identity, and `String` carries `DecidableEq` just as directly. Using
`Name` here would add an `import Lean` dependency for no behavioral difference. -/

structure NodeId where
  value : String
  deriving DecidableEq, Repr

structure RequiredEdge where
  source : NodeId
  target : NodeId
  witnessName : String
  deriving DecidableEq, Repr

/-- Every row's source: the concrete two-tenant SOC2 audit scenario this crown's claim is about
(`AuditFlow`'s `Obl2`/`tag2`/`C2`, `AuditFlowViolation`'s reused `TenancyCountermodel`, and the
`ManufactureTenancyGap` refutation, together). -/
def controlledSource : NodeId := ⟨"SOC2.TwoTenantAuditFlowScenario"⟩

/-- Every row's target: the crown consequence this claim card is chasing —
`CrownAlive(SOC2-two-tenant-audit-flow)` in the sense of
`31_ELEVEN_WITNESS_CROWN_MATRIX.md`'s "Crown law". -/
def crownConsequence : NodeId := ⟨"SOC2.CrownAlive"⟩

private def edge (name : String) : RequiredEdge := ⟨controlledSource, crownConsequence, name⟩

/-! ## The eleven rows, `W_C(SOC2) = (K,P,N,C_m,P_b,M_e,M_u,C_o,F,R,S)` -/

/-- K — Kernel (T001, T002, T006, T007). -/
def rowK : RequiredEdge := edge "K:Kernel[T001,T002,T006,T007]"

/-- P — Positive (T003, T008). -/
def rowP : RequiredEdge := edge "P:Positive[T003,T008]"

/-- N — Negative (T010, T011, T021, T094). -/
def rowN : RequiredEdge := edge "N:Negative[T010,T011,T021,T094]"

/-- C_m — Countermodel (T050–T054). -/
def rowCm : RequiredEdge := edge "Cm:Countermodel[T050-T054]"

/-- P_b — Property (T029–T032). -/
def rowPb : RequiredEdge := edge "Pb:Property[T029-T032]"

/-- M_e — Metamorphic (T041–T049). -/
def rowMe : RequiredEdge := edge "Me:Metamorphic[T041-T049]"

/-- M_u — Mutation (T055). -/
def rowMu : RequiredEdge := edge "Mu:Mutation[T055]"

/-- C_o — Composition (T004, T063). -/
def rowCo : RequiredEdge := edge "Co:Composition[T004,T063]"

/-- F — Flow (T064). -/
def rowF : RequiredEdge := edge "F:Flow[T064]"

/-- R — Replay (T048, T071–T073). -/
def rowR : RequiredEdge := edge "R:Replay[T048,T071-T073]"

/-- S — Standing Path (T132, T133) — the family this very file instantiates. -/
def rowS : RequiredEdge := edge "S:StandingPath[T132,T133]"

/-- The full atlas matrix requirement for this crown: all eleven rows, before any
crown-specific carve-out. -/
def elevenRowRequired : Finset RequiredEdge :=
  {rowK, rowP, rowN, rowCm, rowPb, rowMe, rowMu, rowCo, rowF, rowR, rowS}

theorem elevenRowRequired_card : elevenRowRequired.card = 11 := by decide

/-! ## The P_b (Property) carve-out — `NOT_APPLICABLE`, not force-admitted, not silently dropped

Per the crown law (`31_ELEVEN_WITNESS_CROWN_MATRIX.md`): "A claim card may explicitly mark a
witness `NOT_APPLICABLE`, but must state the structural reason. `NOT_IMPLEMENTED` and
`NOT_APPLICABLE` are never synonyms." The stated reason, quoted verbatim from
`docs/TESTING_ATLAS_INTEGRATION.md` §5 ("The P_b (Property) Ruling") — Wave 1's own ruling for
exactly this crown's finite carrier: -/

/-- The stated structural reason `P_b` is `NOT_APPLICABLE` for this crown, quoting
`docs/TESTING_ATLAS_INTEGRATION.md` §5 verbatim (not paraphrased, so a future reader can diff
this string against the source doc directly). -/
def pbNotApplicableReason : String :=
  "For finite, decide-closed carriers -- the norm in this repo's SOC2/tenancy work (e.g. the " ++
  "TenancyCountermodel finite Finset Obl instance in Tenancy.lean) -- property-based or " ++
  "randomized testing is ruled NOT_APPLICABLE, not skipped silently. The atlas's own crown law " ++
  "explicitly permits and distinguishes NOT_APPLICABLE from NOT_IMPLEMENTED " ++
  "(31_ELEVEN_WITNESS_CROWN_MATRIX.md:26-27). Exhaustive kernel decide over a small finite " ++
  "domain strictly dominates a sampled-and-shrunk run: the decide result is a kernel-checked " ++
  "total case analysis over the domain, while a Plausible run is 100 generated samples with no " ++
  "completeness guarantee over the same domain. (docs/TESTING_ATLAS_INTEGRATION.md §5, " ++
  "\"The P_b (Property) Ruling\")"

/-- This crown's actual required set: the eleven-row atlas matrix minus the `P_b` carve-out.
`P_b` is *removed* from `required` for this crown (the carve-out), not force-admitted into
`admitted` — the difference matters: a removed row does not count toward `admitted ⊂ required`
being "closer to complete" than it honestly is. -/
def notApplicable : Finset RequiredEdge := {rowPb}

def required : Finset RequiredEdge := elevenRowRequired \ notApplicable

theorem required_card : required.card = 10 := by decide

theorem rowPb_in_elevenRowRequired : rowPb ∈ elevenRowRequired := by decide
theorem rowPb_removed_from_required : rowPb ∉ required := by decide

/-! ## The six genuinely admitted rows — cited to real, previously-committed theorems

Each `#check` below is a real compile-time identifier reference: this file fails to build if any
target theorem is renamed, deleted, or stops type-checking. This is the identifier-level
correspondence backing `admitted` — not prose. -/

/- K (Kernel): backed by `AxiomAuditSOC2.lean` (imported above), whose twenty
`#guard_msgs in #print axioms` pairs re-elaborate at import time — a mismatched axiom set or a
`sorry`-tainted theorem among any of its twenty targets would fail this file's build, not
silently pass. Spot-checked directly here against two of those twenty targets. -/
#check @ProcInt.MFW.Residue.minimalSupport_tenant_pure
#check @ProcInt.Playground.SOC2.ManufactureTenancyGap.manufactureStep_not_tenant_pure

/- P (Positive): the compliant two-tenant scenario in `AuditFlow.lean`, where `Separated`
genuinely holds. -/
#check @ProcInt.Playground.SOC2.AuditFlow.separated_C2
#check @ProcInt.Playground.SOC2.AuditFlow.piece1_tenantA_pure
#check @ProcInt.Playground.SOC2.AuditFlow.piece1_tenantB_pure

/- N (Negative): the packaged control-failure refutation in `AuditFlowViolation.lean`. -/
#check @ProcInt.Playground.SOC2.AuditFlowViolation.violation_summary

/- C_m (Countermodel): the non-vacuity discharge `Separated` genuinely fails on, reused
verbatim by `AuditFlowViolation` from `Tenancy.lean`. -/
#check @ProcInt.MFW.Residue.TenancyCountermodel.not_separated

/- R (Replay): the causal-replay/trace-equivalence machinery and its two concrete
instantiations on the two-tenant audit trace. -/
#check @ProcInt.Playground.Swarm11.Replay.replay_eq_of_traceEq
#check @ProcInt.Playground.Swarm11.Replay.manufacturedReceipt_valid
#check @ProcInt.Playground.SOC2.AuditFlow.reorder_replay_eq
#check @ProcInt.Playground.SOC2.AuditFlow.auditReceipt_valid

/-- **C_o (Composition) evidence.** Not merely re-citing `AuditFlow`'s already-composed pieces
again (that would be P/R's job) — a freshly built, minimal composition witness: Card 1's
tenant-purity conclusion and Card 2's zero-unreceipted-completion conclusion hold *jointly* on
the same concrete two-tenant scenario (`AuditFlow.Obl2`/`C2`/`s3`), not merely each true in
isolation. This is what "composition" means for T004/T063: two independently-proven theorem-card
conclusions, reused (not reproven), conjoined on shared concrete data. -/
theorem card1_and_card2_compose :
    (∀ a ∈ ProcInt.Playground.SOC2.AuditFlow.S1,
        ProcInt.Playground.SOC2.AuditFlow.tag2 a =
          ProcInt.Playground.SOC2.AuditFlow.tag2 ProcInt.Playground.SOC2.AuditFlow.g1) ∧
      ¬ ∃ i, ProcInt.Playground.SOC2.AuditFlow.s3.completed i ∧
          ¬ ProcInt.Playground.SOC2.AuditFlow.s3.receipted i :=
  ⟨ProcInt.Playground.SOC2.AuditFlow.piece1_tenantA_pure,
    ProcInt.Playground.SOC2.AuditFlow.s3_zero_unreceipted⟩

def admitted : Finset RequiredEdge := {rowK, rowP, rowN, rowCm, rowCo, rowR}

theorem admitted_card : admitted.card = 6 := by decide

/-! ## The four open rows — why each is honestly not admitted, verified by grep at write time

* **M_e (Metamorphic, T041–T049).** `docs/testing-atlas/10_llm_guides/07_metamorphic.md` requires
  an explicit `transform : X → X` and `observe : X → Y` pair with a proved-or-finitely-tested
  `observe (transform x) = observe x`. No such pair exists for any SOC2 object:
  `grep -rn "Metamorphic" procint/ProcInt --include="*.lean"` (excluding `.lake`) returns nothing
  repo-wide, not just in `SOC2/`.
* **M_u (Mutation, T055).** `docs/testing-atlas/10_llm_guides/09_mutation.md` requires a named
  mutant with one changed law and a killer witness distinguishing real from mutant.
  `grep -rn "Mutation\b\|MutationKiller" procint/ProcInt --include="*.lean"` returns nothing
  repo-wide.
* **F (Flow, T064).** `docs/testing-atlas/10_llm_guides/14_flow.md`'s family law: "A positive
  scenario and its negative companion should use the same domain vocabulary and differ at the
  exact violated invariant" — implying the *same concrete carrier*, with a violation companion
  built by breaking exactly one admission condition on it. `AuditFlow` (`Obl2 := Fin 4`, closure
  `C2`) and `AuditFlowViolation` (reused `TenancyCountermodel.Obl := Fin 2`, closure `C`) share
  domain *vocabulary* (`Obl`, `tag`, `residue`, `Separated` as concepts — `AuditFlowViolation`'s
  own docstring says as much) but are built on two different concrete carriers, not one carrier
  with one condition flipped. That is a genuine gap against the Flow family law as stated, not a
  close-enough match — hence open, not admitted.
* **S (Standing Path, T132, T133).** This file is the real, first `StandingPathReceipt`-shaped
  apparatus in `ProcInt` (closing the `docs/TESTING_ATLAS_INTEGRATION.md` §4 gap), but the row
  `S` means the crown's standing path is *complete*, and it is not: `required \ admitted` is
  nonempty (four rows, including `S` itself). Marking `S` admitted here — on the strength of
  merely having built the auditing apparatus, independent of what it concludes — would be exactly
  the self-serving promotion `AGENTS.md` §2 forbids ("never attach... to unbenchmarked/unproven
  work"). The apparatus existing is necessary for `S`, not sufficient; `S` stays open until a
  future wave closes `M_e`/`M_u`/`F` (at which point `required = admitted` and this same
  machinery would honestly prove `S` too, non-circularly). -/

theorem admitted_subset_required : admitted ⊆ required := by decide

theorem admitted_ne_required : admitted ≠ required := by decide

/-- The honest headline fact this file proves in place of the template's forced
`complete : admitted = required`: `admitted` is a genuine, *proper* subset of `required` for the
SOC2 crown. -/
theorem admitted_ssubset_required : admitted ⊂ required :=
  Finset.ssubset_iff_subset_ne.mpr ⟨admitted_subset_required, admitted_ne_required⟩

/-- The exact four rows still open for this crown — named by `decide` on the concrete `Finset`s,
not asserted in prose. -/
def missing : Finset RequiredEdge := required \ admitted

theorem missing_eq_exact_rows : missing = {rowMe, rowMu, rowF, rowS} := by decide

theorem missing_card : missing.card = 4 := by decide

/-! ## The template's `StandingPathReceipt`, and why no instance of it exists for this crown yet

```
structure StandingPathReceipt where
  required : Finset RequiredEdge
  admitted : Finset RequiredEdge
  expectedNonempty : required.Nonempty
  complete : admitted = required
```

`complete` is a proof obligation baked into the structure: a well-formed value of this type is
constructible only when the standing path genuinely is complete. Since `admitted ≠ required`
here (`admitted_ne_required`), no honest value of `StandingPathReceipt` for the SOC2 crown exists
yet, and none is fabricated below with a `sorry`/`decide`-forced `complete` field — that is
precisely the vacuous-tautology move `AGENTS.md` §3 rules out. The structure is still reproduced
here (field-for-field, modulo the `Name → String` adaptation noted above) because part of what
T132/T133 asks for is that this *shape* exist and be exercised in `ProcInt`, not that it be
trivially satisfied. -/
structure StandingPathReceipt where
  required : Finset RequiredEdge
  admitted : Finset RequiredEdge
  expectedNonempty : required.Nonempty
  complete : admitted = required

/-- The honest current status for the SOC2 crown's standing path, in place of a
`StandingPathReceipt` instance. Every field is either the concrete data or a real proof about it;
`notComplete` is the true fact (`admitted ≠ required`), not its negation. -/
structure StandingPathStatus where
  required : Finset RequiredEdge
  admitted : Finset RequiredEdge
  missing : Finset RequiredEdge
  expectedNonempty : required.Nonempty
  admittedSubset : admitted ⊆ required
  missingIsRequiredMinusAdmitted : missing = required \ admitted
  notComplete : admitted ≠ required

/-- The SOC2 crown's real, current standing-path status: six of ten required rows admitted
(`P_b` carved out of the eleven-row matrix as `NOT_APPLICABLE`), `M_e`/`M_u`/`F`/`S` open. -/
def soc2Status : StandingPathStatus where
  required := required
  admitted := admitted
  missing := missing
  expectedNonempty := ⟨rowK, by decide⟩
  admittedSubset := admitted_subset_required
  missingIsRequiredMinusAdmitted := rfl
  notComplete := admitted_ne_required

/-! ## Coupling to this repo's real `Standing`/`Claim` algebra (`Swarm11/Standing.lean`)

Reusing `ProcInt.Playground.Swarm11.Standing`/`Claim`/`Claim.authorized` as instructed, not
inventing a parallel one. `Claim` has no constructor for "six of ten rows admitted" — its
`Standing` inductive (`candidateOnly`, `finiteVerified`, `refuted`, `proven`, `blocked`,
`unknown`, `unsupported`) is a single-claim evidence class, not a multi-row crown-completion
state. Forcing this crown's claim to `.proven` would overclaim (four rows are open);
`.finiteVerified` would misclassify kernel-proven rows as finite-experiment evidence
(`docs/TESTING_ATLAS_INTEGRATION.md` §3's own rule: "`FINITE_VERIFIED` ranks *below* `PROVEN`").
`.candidateOnly` ("named, not yet evidenced" per that same §3 crosswalk) is the least dishonest
single-value approximation available for *the crown-alive claim as a whole* — it is not a
license to also call the six admitted rows unevidenced; that finer-grained truth lives entirely
in `admitted`/`required`/`missing` above, which `Claim`'s one-`Standing`-field shape cannot
carry. -/

/-- The SOC2 crown's `CrownAlive` claim, expressed in the repo's real `Claim` algebra. Ceiling is
`.theorem` (the aspiration is theorem-tier crown-alive standing, per `31_ELEVEN_WITNESS_CROWN_
MATRIX.md`'s `CrownAlive(c)`); standing is `.candidateOnly` (see the coupling note above) — so
`Claim.authorized` correctly evaluates to `false`, matching `admitted_ssubset_required`. -/
def soc2CrownAliveClaim : Claim :=
  { name :=
      "SOC2 two-tenant audit-flow crown is CrownAlive " ++
        "(all eleven Eleven-Witness-Crown-Matrix rows admitted, P_b carved out NOT_APPLICABLE)"
    standing := Standing.candidateOnly
    ceiling := ClaimCeiling.theorem }

/-- `Claim.authorized` on the SOC2 crown-alive claim is `false` — the real `Standing`/`Claim`
gate agrees with `admitted_ssubset_required`, not a hand-typed duplicate of that fact. -/
theorem soc2CrownAliveClaim_not_authorized : soc2CrownAliveClaim.authorized = false := rfl

end ProcInt.Playground.SOC2.StandingPathSOC2
