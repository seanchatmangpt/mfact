# mfact/procint — Standing Report

Release `v26.7.7`. Every field below is computed from a build, an audit, or
a git commit — nothing here is asserted in prose. Machine-checkable form:
`release/standing.env`. Full manifest: `release/release-manifest.json`.

## Scope

This report certifies exactly what the gates below check: that the named
declarations kernel-admit under the pinned toolchain, that their axiom
footprint is the trusted set, that the named fixtures build, and that the
release manifest is internally consistent. It does not certify that the
catalog-curated statements are a faithful rendering of the cited primary
literature (Section "Limitations and Standing" of the paper) — that is a
citation-review obligation, not a theorem this pipeline can discharge.

## Source Origin

The canonical source of `procint` is not handwritten `.lean` files. It is
the RDF/Turtle declaration catalog (`packs/lean-math-pack`). Declaration
bodies were curated into the catalog by LLM-assisted lanes under human
review (each candidate kernel-verified via `lake env lean` on a scratch
file before being recorded — LLMs are untrusted candidate producers).
ggen renders the Lean modules, the root import index, the axiom-audit
guard, and the registry tables from that catalog. The rendered Lean is a
candidate artifact: it is not trusted because it was rendered. It acquires
standing only through Lean kernel admission, the Lake build, the no-sorry
audit, the axiom audit, the negative fixtures, and release certification.

ggen renders. Lean admits. mfact certifies.

`DECLARATION_SOURCE=RDF_TTL`
`LEAN_SOURCE_ORIGIN=GGEN_RENDERED_FROM_TTL`
`GGEN_RENDERED_LEAN_SOURCE=TRUE`
`GGEN_CERTIFIED_MATHEMATICS=FALSE`
`LEAN_KERNEL_ADMITTED=TRUE`

## Ladder (per module family)

Exact per-fragment counts (computed by walking every `procint:Decl` block
in each fragment file; the totals row is independently taken from
`release-manifest.json` and matches):

| Family | Modules | Decls | Axiom-audited (proven) | Stated | Definitions |
|---|---:|---:|---:|---:|---:|
| Foundations + Petri core | 5 | 20 | 7 | 0 | 13 |
| Petri ext (OCPN/Stochastic/Unfolding/StateEq/Invariants) | 5 | 37 | 15 | 1 | 21 |
| Workflow | 4 | 30 | 22 | 1 | 7 |
| Logs | 4 | 37 | 23 | 0 | 14 |
| Conformance | 4 | 29 | 13 | 0 | 16 |
| Ocel/Ocpq | 5 | 35 | 18 | 0 | 17 |
| Models (trees/POWL/choice-graph) | 3 | 25 | 12 | 0 | 13 |
| Models (DFG/CausalNet/BPMN/Declare) | 4 | 37 | 15 | 0 | 22 |
| Analytics | 8 | 55 | 20 | 0 | 35 |
| Fixtures\* | 2 | 4 | 0 | 0 | 0 |
| Tests (correctness ladder)\* | 6 | 9 | 0 | 0 | 9 |
| **Total** | **50** | **318** | **145** | **2** | **171** |

\* The fixture and test-oracle declarations are `example`s and `#guard`s
(Lean's anonymous-declaration
form): they are kernel-verified — the corpus does not build if they stop
type-checking or a negative fixture stops failing — but `#print axioms`
cannot target an anonymous declaration, so they are not part of the
145-theorem axiom-audited set. Their status is `"proven"` in the ontology
(kernel-verified) but they carry no `auditMsg` and are excluded from the
axiom-audit table below by construction, not by omission.

## Crown jewel

`ProcInt.crownJewel_status = "stated"`. The target theorem (van der Aalst
1997, Lemma 8: workflow-net soundness iff liveness and boundedness of the
short-circuited net) is formalized as
`WfNet.sound_iff_shortCircuit_live_bounded_statement` and type-checks;
neither direction is proven in this release. Two supporting lemmas about
`WfNet.Sound` (`reaches_final`, `enabled_of_transition`) are proven and
axiom-audited. `BranchingProcess.isUnfoldingOf_statement` is the second
stated-not-proven declaration, unrelated to the crown jewel (an
unfolding-correctness statement in the Petri-net seed lane).

## Refusal / repair log

Three cross-family bugs were found and fixed at the fragment level (never
by hand-editing the assembled `.lean` files directly), each re-rendered and rebuilt
before proceeding:

1. `Workflow.Soundness` — missing `import ProcInt.Petri.Boundedness`
   (used `PetriNet.Live`/`PetriNet.Bounded` without importing their module).
2. `Ocpq.Query` — missing `import ProcInt.Ocel.Relations` (used
   `OCEL.mem_objectsOf` without importing its module).
3. `Conformance.Quality` — redeclared `UnitRat` locally instead of
   importing the canonical one from `ProcInt.Foundations.Metric`
   (duplicate-declaration error).

One template-level bug was found and fixed in the fixtures fragment: two
consecutive `/-- -/` doc-comments before one declaration is illegal Lean
syntax; the human-readable description was converted to `--` line
comments, keeping only the `#guard_msgs`-matching docstring as a true
Lean doc-comment.

No declaration was silently downgraded without a corresponding line in
this log or a `"stated"` status visible in `release-manifest.json`.

## Axiom audit

145 theorems probed via real `#print axioms` output (not asserted):

| Axiom footprint | Count |
|---|---:|
| none | 37 |
| `propext` | 28 |
| `propext, Quot.sound` | 25 |
| `propext, Classical.choice, Quot.sound` | 55 |

Zero unauthorized axioms. Zero transitive `sorryAx`.
`Mfact.no_valid_objection` (the mfact framework's own closed-objection
theorem) is the strongest case in the whole release: it depends on **no
axioms at all**.

## Certification

`mfact certify release-manifest.json gates.json` — exit 0.
Genesis-folded release hash (BLAKE3, seed `mfact-v26.7.7-genesis`, folded
over all 318 artifact hashes in name order):
`e25724e88d4b2ee396b7442d5604dafa1b6da9fd6c61614ebd4062ad073c080d`.

Negative controls (the gate must be able to fail, or it certifies
nothing):
- `gates.json` with `sorryFree=false` → `mfact certify` exits **1** with
  an explicit gate-failure message.
- Syntactically corrupted `release-manifest.json` → `mfact certify` exits
  **2** with a typed refusal, not a crash.

## Wall-clock

Git-receipted span of the work reported in this document: six commits
from `2026-07-06T20:41:32-07:00` to `2026-07-06T21:09:48-07:00` (28
minutes), covering bug discovery/repair, fixtures, axiom reconciliation,
and certification. Earlier stages (ontology authoring, initial corpus
generation via concurrent LLM lanes, first green render/build) preceded
this commit span and are not independently timestamped in this
repository's git history — this report does not extrapolate a total
run duration from partial receipts.

## Standing schema

See `release/standing.env` for the flat, `grep`/`jq`-able form of this
report (`TYPE_INVENTORY_HASH`, `GGEN_MODULE_GENERATION`, `LEAN_BUILD`,
`SORRY_COUNT`, `ADMIT_COUNT`, `AXIOM_AUDIT`, `NEGATIVE_FIXTURES`,
`PROCESS_EVIDENCE`, `PROOF_MANIFEST`, `VALID_OBJECTION`,
`LLM_TRUSTED_BASE`, `CERTIFIED_RELEASE`, `PAPER_EVIDENCE_GENERATED`).
Every field there is computed by the commands recorded in
`release/certify.log`, never typed from memory.

## Standing Quadrature

`STANDING_QUADRATURE=PASS` (`release/quadrature.env`, `release/quadrature.json`,
`release/quadrature.md`). The release closes the cross-product between five
surfaces — TTL declaration catalog, admitted Lean corpus, release manifest,
process evidence, paper claims — with zero orphans on every edge. Closure is
kernel-checked: `procint/ProcInt/Release/Quadrature.lean` (rendered by ggen
from the quadrature graph) proves the catalog/manifest/audit proven-surfaces
pairwise equal by `rfl`, proves every traced paper claim carries evidence,
and proves the manufacturing run trace monotone and conformant to its
declared Declare process model — procint models the process by which mfact
manufactured procint. Three negative controls (corrupted evaluation number,
evidence-free claim, orphan catalog declaration) each produce a typed
refusal (`release/quadrature-negative-controls.log`). Reproduce:
`just standing-quadrature`.
