# MFW audit follow-up: content and soundness gaps (Tier 2)

Last updated: 2026-07-16.

This document originally cataloged findings from a full-codebase audit of `ProcInt/MFW`
that were deliberately not auto-fixed. A remediation pass has now been applied. Every item
below records the old defect, the action taken, the new standing (with justification), and
the current file:line. Overall build/lint state for the post-fix tree:

- Receipt: `/Users/sac/mfact/.verif-toolchain/receipts/receipt-20260716T222045Z.txt`
- `lake build ProcInt` (from `procint/`) exit 0, `lake exe lint-style --procint` exit 0,
  Overall: PASS
- Git HEAD at receipt time: `e0e25eb05d2` (working tree DIRTY — the fixes are uncommitted)

A round-1 adversarial review (2026-07-16, later the same day) found further defects that
grep-based verification could not detect; their repairs are folded into the sections below
and covered by the receipt above. Headline: `stateTraceOf` was a hidden-choice constant
(making `StateEquiv` total and `KernelRefinesStateEquiv` trivially provable) and is now a
real replay construction; `refines` gained a real `Powl.IsSubmodelOf` containment body;
K2 gained its equivalence lemmas; two unconstrained `Prop` data fields were removed.

Module-level standing: PARTIAL_ALIVE — the labeling, vacuous-predicate, and unmarked-axiom
defects are discharged and verified by the receipt above, but the deep mathematical
conjectures (the Crown biconditional and its supporting results) remain open by design.

## 1. Theorem-shaped defs (formerly "the flagship Crown Theorem is unproven")

Old defect: `Kernel.lean`'s `KernelCharacterization` and several supporting results were
`def : Prop` declarations whose docstrings called them "Theorem" (even "Crown Theorem"),
carrying no proof obligation — invisible to a zero-`sorry` check.

Action this session: no proofs were manufactured. Instead, every theorem-shaped def had its
docstring language downgraded from "Theorem" to "Conjecture" and received an R1-conformant
`Standing: CONJECTURAL — <named blocker>` tag. Section headers were renamed
("Crown Theorems" → "Crown Conjectures"). Verified by grep: zero standalone "Theorem"
words remain in doc comments of the affected files; the `theoremShapedDef` linter passes
(lint exit 0 in the receipt).

Per-item status (all remain open conjectures; each blocker is named in its Standing tag):

- `KernelCharacterization` — `Kernel.lean:417`. CONJECTURAL — both directions over the
  K1–K4 construction are unproven. This is the flagship open item.
- `TauRespectsTraceEquiv` — `Kernel.lean:377`. CONJECTURAL (forward direction).
- `KernelRefinesStateEquiv` — CONJECTURAL (reverse direction). Round-1 review found the
  statement was degenerate, not open: the old `stateTraceOf` used `Classical.choice` on a
  `Nonempty (List Th.State)` proof, so by proof irrelevance it returned one constant list
  for every behavior, `StateEquiv` was the total relation, and this "conjecture" was
  trivially provable. `stateTraceOf` is now the real replay construction
  (`b.trace.stateTrace.getD []`) with faithfulness proved
  (`stateTrace_eq_some_stateTraceOf`, PROVEN), so the statement is substantive and
  genuinely open again.
- `TraceSwapPreservesLawful` — `Kernel.lean:271`. Was labeled "Load-bearing theorem"
  without being flagged by the baseline; now "conjecture" + CONJECTURAL tag.
- `TraceClassEquivLinearExtensions` — `Kernel.lean:652`. CONJECTURAL; now parameterized
  over `CausalOrderAssignment` (see §3).
- `KernelGenerated` — `Kernel.lean:786`. CONJECTURAL; its conclusion was strengthened from
  `∃ path : KernelPath b₁ b₂, True` to `Nonempty (KernelPath b₁ b₂)` (propositionally
  equivalent, no vacuous tail).
- `FiberEntropyEqSerializationEntropy` — `Kernel.lean:705`. Formerly the worst case (a
  `→ True` body: even a proof would establish nothing). Now states the real equality
  `Real.log ((fiber τ (τ.map b)).ncard : ℝ) = serializationEntropy (A.order b I)`
  (`Kernel.lean:713`). CONJECTURAL — depends on `TraceClassEquivLinearExtensions` plus
  trace-class finiteness (`Set.ncard` returns 0 on infinite fibers; noted in the
  docstring).
- `DimensionLossZeroIffLocalDiffeo` — `IntrinsicDimension.lean:307`. Docstring now says
  "Conjecture"; the hidden `↔ True` tail was replaced by an explicit
  `(locallyInvertible : Prop)` hypothesis parameter (`IntrinsicDimension.lean:311-312`).
  CONJECTURAL — requires smooth structure on P(Th) and W.
- `FiberDimEqDimensionLoss` — `IntrinsicDimension.lean:358`. CONJECTURAL — requires a
  submersion hypothesis on τ at `b`.
- `DimensionLossDecomposes` — `IntrinsicDimension.lean:606`. CONJECTURAL — requires a
  direct-sum tangent decomposition; note added that under the stub
  `nullDimensionOfKind ≡ 0` the LHS is identically 0.
- `ZeroResidualImpliesSufficient` — `Observability.lean:463`. Docstring rewritten to
  "Conjecture (Zero Residual → Sufficiency)"; CONJECTURAL — requires the measure-theoretic
  bridge between zero conditional mutual information and deterministic factorization.

New standing: labeling defect ALIVE (fixed and receipt-verified); the mathematical content
of every item above remains CONJECTURAL/open with the named blocker. None is proven.

## 2. Vacuous predicates

- `Ledger.lean` `validTopologicalSort`. Old: body was bare `True`, accepting every sequence
  as a valid topological sort. Action: replaced with a real 4-conjunct predicate
  (`Ledger.lean:33`): duplicate-free sequence, exact coverage of the DAG's node-id set
  (both inclusions), and `idxOf fromNode < idxOf toNode` for every edge. A `Decidable`
  instance was added (`Ledger.lean:42`). `Tests/LedgerTests.lean` now discharges
  `toyDerivation` by `decide` (`Tests/LedgerTests.lean:48`) and proves three negative
  examples — `¬ valid [3,2,1]`, `¬ valid [1,3,2]`, `¬ valid [1,2]` — at lines 52, 55, 58,
  demonstrating the predicate constrains. New standing: ALIVE — the predicate is real,
  decidable, exercised positively and negatively, and the receipt shows the `decide`
  proofs closed (`Replayed ProcInt.MFW.Tests.LedgerTests` in the build log).
- `TransformBasic.lean` `HierarchicalScaleSystem.refines`. Old: existential body ending
  in bare `True` — the "containment" conclusion required only that the coarser partition
  be nonempty. First pass merely documented the vacuity. Round-1 review fix: a structural
  submodel relation `Powl.IsSubmodelOf` (inductive: reflexivity, xor children, loop
  do/redo parts, partial-order children) was added, and `refines` now concludes
  `Powl.IsSubmodelOf c_child.model c_parent.model`. New standing: ALIVE — the predicate
  is a real constraint; no consumers needed migration (none existed).
- `Kernel.lean` `FiberEntropyEqSerializationEntropy` `→ True` tail: fixed, see §1.

## 3. Unmarked opaque axioms

Old defect: bodyless `opaque` declarations with no characterizing axioms — functionally
unmarked axioms. The remediation converted every one to an explicit-hypothesis theory
record (fields of a `structure`, threaded as an explicit parameter) or deleted it when it
had zero consumers. Verified by grep: zero `opaque`/`axiom` declaration lines remain in
`ProcInt/MFW/*.lean` and `ProcInt/MFW/Tests/*.lean`; `noUnmarkedAxioms` passes (lint
exit 0 in the receipt).

- `Kernel.lean` `inducedCausalOrder`. Converted to `structure CausalOrderAssignment (Th)`
  (`Kernel.lean:151`) with field `order`; all three in-file consumers (`CausalEquiv`,
  `TraceClassEquivLinearExtensions`, `FiberEntropyEqSerializationEntropy`) now take an
  explicit `(A : CausalOrderAssignment Th)`. The formerly-unsatisfiable
  `DecidableRel (inducedCausalOrder b I).prec` hypothesis is now
  `DecidableRel (A.order b I).prec` — dischargeable by any concrete assignment.
  New standing: ALIVE (hypothesis made explicit; no hidden axiom).
- `Kernel.lean` `wassersteinWorkflowDist`. Deleted — zero consumers repo-wide (verified by
  grep); the removal is recorded in the Workflow Geometry section doc (`Kernel.lean:470`).
  New standing: ALIVE (defect removed by deletion).
- `Concurrency.lean` `temporalSerializationEntropy`. Converted to
  `structure TemporalEntropyAssignment (n : Nat)` (`Concurrency.lean:235`) with field
  `entropy`; `temporalRestrictionGap` (`Concurrency.lean:248`) takes an explicit
  `(E : TemporalEntropyAssignment n)`. Its docstring no longer asserts
  `H_ser − H_T ≥ 0` as fact; nonnegativity is tagged CONJECTURAL with the
  temporal-restriction submultiplicativity argument named as the blocker.
  New standing: ALIVE for the axiom defect; the gap-nonnegativity claim is CONJECTURAL.
- `Manufacture.lean` (12 opaques: `ObservationSpace`, `AdmittedObservation`,
  `ArtifactDomain`, `manufacturingLaw`, `stand`, `receipt`, `Actuation`, `isReceipted`,
  `DefectVectorImpl`, `Voice`, `ctqDerivation`, `riceContainment`). Converted to fields of
  `structure ManufactureTheory` (`Manufacture.lean:10`); `brceInvariant` and
  `DefectVector` are theory-relative. All Notation Authority tags preserved in-file.
  New standing: ALIVE (no hidden axioms; consumers parameterize explicitly).
- `Falsification.lean` (`empiricalFalsifier`, `getStatus`, `revoke`). Converted to fields
  of `structure FalsificationTheory` (`Falsification.lean:21`); `revocationCondition` and
  `empiricalFalsificationLoop` take `(Th : FalsificationTheory)`. New standing: ALIVE.
- `ExploreExploit.lean` (`explore`, `exploit`, `equivalentClosureSelection`). Converted to
  fields of `structure ExploreExploitTheory` (`ExploreExploit.lean:23`);
  `exploreExploitStrictSeparation` takes `(Th : ExploreExploitTheory)`.
  New standing: ALIVE.
- `CompilerPipeline.lean` (`projectTtl`, `interpolateTera`, `compileRust`). Converted to
  fields of `structure CompilerPipelineTheory` (`CompilerPipeline.lean:22`);
  `MultiplicativeCascadeWindTunnel` is parameterized by `(T : CompilerPipelineTheory)`.
  New standing: ALIVE.

## 4. Flagged proofs whose content was questionable

- `ObservableBasis.lean` `measure_observable_duality` (`ObservableBasis.lean:644`).
  Old: proof used the degenerate witness `fun _ => 0` while the docstring claimed the
  duality `μ_k(w) = Λ_k(δ_w)`, and the tag said CONJECTURAL on a closed proof.
  Action: proof kept intact; docstring rewritten to state exactly what is proved
  (existence of an additive, homogeneous functional via the zero witness; both parameters
  unused), with the nontrivial duality marked open. Tag is now
  `Standing: PROVEN — via degenerate zero-observable witness; the nontrivial duality
  remains open` (`ObservableBasis.lean:642`). New standing: PROVEN with the degeneracy
  caveat stated in the tag; the intended duality remains open.
- `IntrinsicDimension.lean` `dimension_loss_nonneg` (`IntrinsicDimension.lean:275`),
  `dimension_loss_profile_nonneg`, `effective_scaling_le_source_dim`.
  Old: "proven" only because `powlLocalDim`/`nullDimensionOfKind` are hardcoded `0` stubs;
  one docstring was factually wrong (described the wrong statement).
  Action: retagged `Standing: PROVEN — discharged under the current stub dimension model`
  (scope stated verbatim in each tag); the wrong docstring on
  `effective_scaling_le_source_dim` was rewritten to the truncated-subtraction bound it
  actually proves. New standing: PROVEN under the stub model only — these proofs will
  break, and the tags must be revisited, when the stubs get real definitions (stated in
  each tag). `Perturbation.lawful` and `LocalDimension.wellDefined` were unconstrained
  `Prop` data fields whose docs claimed enforced constraints; round-1 review removed
  both. `Perturbation.lawful` was redundant (the `perturbed` field's type,
  `BehavioralPhaseSpace Th = LawfulBehavior Th`, already carries the `IsLawful` proof);
  `NullPerturbation` and its three PROVEN lemmas were simplified accordingly.
  `LocalDimension` now documents that well-definedness must be an explicit consumer
  hypothesis. New standing: ALIVE for both field defects.

## 5. Test suite

Old defect: tests against `Manufacture`/`Falsification`/`CompilerPipeline`/`ExploreExploit`
were structurally tautological because those modules were built from bodyless opaques.

Action: the §3 theory-record conversion removes the structural cause. Tests are now
parameterized hypothesis-discharge theorems over explicit theory records
(`Tests/ManufactureTests.lean`, `Tests/FalsificationTests.lean`), and
`Tests/PipelineTests.lean` gained a concrete instance `toyPipelineTheory`
(`Tests/PipelineTests.lean:18`) with `toyTunnel` proved against it by `rfl` — a test that
can now fail if the fields change. `Tests/LedgerTests.lean` gained the three negative
examples listed in §2. New standing: PARTIAL_ALIVE — tests exercise real definitional
content and negative cases where concrete instances exist, but modules whose theories have
no concrete instance are still exercised only at the hypothesis-discharge level.
(`Tests/ExploreTests.lean` was deleted in the earlier mechanical pass; unchanged.)

## 6. Round-1 adversarial review repairs (2026-07-16, same day)

Items not previously cataloged, found and fixed in the round-1 review:

- `Kernel.lean` `stateTraceOf` hidden choice: see the `KernelRefinesStateEquiv` entry in
  §1. The K1 layer is no longer degenerate.
- `Kernel.lean` K2 (`CausalEquiv`) had no equivalence-property lemmas (K1/K3/K4 did).
  Added `causalEquiv_refl` / `causalEquiv_symm` / `causalEquiv_trans`, all PROVEN,
  relative to an explicit `CausalOrderAssignment`.
- `Kernel.lean` `independentGenerators`: body was purely syntactic
  (`gs.Nodup ∧ gs.length ≤ 4`) under a doc claiming semantic path-rewriting
  independence. Now parameterized over an explicit `KernelPathRewriting` theory record
  and states the documented condition: for distinct generators in the list, no nonempty
  pure-`g₁` path rewrites to a pure-`g₂` path. It had no consumers; no migration needed.
- `TransformBasic.lean` `refines`: real containment body, see §2.
- `IntrinsicDimension.lean` `Perturbation.lawful` / `LocalDimension.wellDefined`
  unconstrained `Prop` data fields removed, see §4.

## Open items and residuals

- Crown Conjecture `KernelCharacterization` and all §1 conjectures: open; blockers named
  in each Standing tag. This remains the ordered work queue, Crown first.
- `temporalRestrictionGap` nonnegativity: CONJECTURAL (§3).
- `Tests.lean:161`: pre-existing `sorry` (tagged CONJECTURAL) — requires showing no swap
  path exists; untouched this session.
- `Tests.lean:152`: pre-existing non-fatal `unreachableTactic`/`unusedTactic` warnings on
  `exact h` in `fourActionIndep.symm`; build still exits 0; untouched (out of scope).
- `scripts/lint-style.lean`: pre-existing `String.mk`/`String.trim` deprecation warnings
  emitted during compilation; baseline, excluded from scope.
- `QLens.lean`: pre-existing uncommitted diff and four >100-char lines (23, 36, 40, 41)
  from earlier branch work; untouched this session.

When the §1 conjectures gain real proofs, update this document and the root `AGENTS.md`
Constructive Lean Boundary section (currently PARTIAL_ALIVE: build/lint green with the
cataloged defects repaired, Crown and supporting conjectures still open).

## See Also

- `../../../AGENTS.md` — root repository agent law (Standing Law, Verification Ladder)
- `../../AGENTS.md` — procint subproject agent law
- `../../../docs/AGENT_FAILURE_MODES.md` — agent failure-mode anti-patterns with mfact
  incidents
- `../../../MFW_THESIS_SUMMARY.md` — MFW thesis summary
