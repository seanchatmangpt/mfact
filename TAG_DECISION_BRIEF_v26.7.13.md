# Tag Decision Brief — v26.7.13

Updated 2026-07-13. Evidence anchor: all file/line citations below were verified at commit
`f4bf307`; HEAD has since advanced one docs-only commit (`fa05d31`, self-audit Pass 22
append). Companion documents: the readiness section of `RELEASE_v26.7.13_PRD.md`
("Release readiness — 2026-07-13 end of session") and `GAP_LEDGER_v26.7.12.md` entries
G4, G5, G6.

## Purpose

The mechanical DoD for v26.7.13 is green as cited in `RELEASE_v26.7.13_PRD.md`'s "Release
readiness — 2026-07-13 end of session" section: certify exits 0 with all four gates true,
regen-check shows no drift, the quadrature witness is consistent at HEAD, and the Swarm11
verifier fold is admitted. What remains on the tag path is exactly three open ledger
entries — G4 (countermodel gate), G5 (divergent count lineages), and G6 (release
identity) — and each is a judgment call, not a mechanical one: retire or wire a guard,
choose a regeneration policy, choose a bump sequence. This brief compresses the verified
forensics for each so that call is made on evidence, not memory. Every claim below is
verified at the anchor unless explicitly marked INFERRED.

## G4 — Countermodel gate: three artifacts, one live consumer

Ledger entry: `GAP_LEDGER_v26.7.12.md` §G4 (Status: OPEN).

### Evidence

There is no single "promotion guard". Three distinct artifacts exist, plus one
undocumented live consumer:

1. Policy check (the artifact that tripped): `scripts/build_manifest.py:120-132` checks a
   hardcoded 3-name dep list; on any `status=='proven'` it prints
   `COUNTERMODEL_PROMOTION_REFUSED` with no `sys.exit`, then line 141 writes
   `countermodel_not_promoted=false` into `release/gates.json` (committed at `b2f5b0e`).
   Its print string carries ticket-012's perpetual-STATED semantics.
2. Certify-time negative control: `scripts/countermodel_negative_controls.sh` (invoked by
   the `certify` recipe, `justfile:95`; PASS at `certify.log:2401-2402`) writes a forged
   standing.env that is never read afterward, builds a poisoned manifest copy with the
   countermodel artifact removed, and derives status from that copy — every fallback path
   prints STATED, so the control is structurally incapable of failing. It guards the
   derivation rule on a counterfactual manifest; its PASS is fully consistent with the
   real promotion having happened. (It also violates STANDING.md:126's own maxim that a
   gate must be able to fail.)
3. Production derivation: the justfile `test` recipe (~line 179) re-derives
   `WFNET_INFINITE_TRANSITION_COUNTERMODEL` in `release/standing.env` from the manifest's
   proven flag; `standing.env:43=PROVEN` is manifest-consistent (self-audit PB2 reached
   the same conclusion).
4. The certify binary ignores the field: `mfact/Mfact/Cli.lean:29-34` GatesJson has
   exactly 4 fields and `:36-37` maps only those; `certify.log:2394` shows exit-0 against
   the very gates.json containing the 5th field false. G4's "dead path" claim is correct
   at the certify boundary.
5. New finding — the field is not globally dead: `scripts/build_post_release.py:111`
   requires `gates_pass = all(gates.values())` for the github_release packet, which the
   false field forces to False — BLOCKED in `--plan` mode (the mode `just release` uses,
   `justfile:350-351`), exit 2 in full mode. This is the single live consumer, and it is
   the real operative G4 -> G5/G6 edge.

Promotion legitimacy: the TTL decl in `packs/lean-math-pack/ontology.ttl` is
`status="proven"` with a real axiom footprint (`[propext, Classical.choice, Quot.sound]`);
`procint/AxiomAudit.lean:372-375` carries the matching `#guard_msgs` on `#print axioms`,
and `just certify: build audit` makes that guard a certify prerequisite; `ac647a9` touched
both sides. A sorry would surface as `sorryAx` and break the guard. INFERRED (lake was
excluded from the run that produced this brief): "currently rebuilds green" rests on G1's
2026-07-13 fresh-certify record at `ee624be`, not on a rebuild performed for this brief.

Intent history: jira ticket_012:181,185 says the countermodel "may never be promoted"
(claim-direction hygiene); its specified `guard_countermodel_not_promoted.py`
(ticket_012:96,155) was never built (verified absent). Ticket_013's blocker was different:
proven-with-sorry-lemmas, an evidence-absence violation since cured by `ac647a9`. The
general rule already exists mechanically: manifest `proven` requires non-empty auditMsg
(`build_manifest.py:60`), the evidenceComplete gate requires it on all proven non-example
decls (`:138-140`), and AxiomAudit binds auditMsg content to the kernel.

### Options

- (a) Wire `countermodel_not_promoted` into GatesJson with post-promotion semantics.
  Supported by ticket_012's letter and G1's residual text. Tradeoffs: Cli.lean change plus
  mfact rebuild; "remain STATED" semantics would make certify exit 1 on a kernel-true
  state (institutionalizes a false surface, against AGENTS.md computed-not-asserted);
  "must be evidence-backed" semantics duplicates evidenceComplete + AxiomAudit (redundant
  scaffolding, rejected by AGENTS.md §3).
- (b) Retire the guard as fulfilled, with a dated ledger closure. Supported by the
  evidence chain `ac647a9` -> TTL auditMsg -> `AxiomAudit.lean:372-375` ->
  `certify.log:2394`; ticket_013's actual invariant is cured; the derivation-rule control
  and justfile derivation remain untouched. Tradeoff: closure-by-prose alone is nominal —
  if the field stays in gates.json at false, `build_post_release.py:111` keeps
  github_release BLOCKED.
- (c) Repoint at the general rule (no STATED->PROVEN without a matching kernel artifact).
  Tradeoff: that rule is already enforced twice (evidenceComplete gate + AxiomAudit gated
  by certify); a third enforcement is a rename plus the same rebuild cost as (a), unless
  it adds something new (an auditMsg-content-vs-kernel cross-check at manifest time).

### Recommendation

(b), with two mandatory riders in one commit: (1) delete `build_manifest.py:120-132` and
the `:141` gates field so gates.json's schema again equals GatesJson's — a retired guard
must stop emitting a permanently-false field, and this is what truthfully unblocks
`build_post_release.py:111`; (2) a dated GAP_LEDGER closure citing the full evidence chain
and stating explicitly that the general invariant survives in evidenceComplete + AxiomAudit
and that `countermodel_negative_controls.sh` is retained — so the diff cannot be read as
deleting a red gate to go green. Optional third rider (recommended): make the negative
control able to fail by additionally asserting the real standing.env value equals the
manifest-derived value. Address ticket_012's claim-direction concern with prose scope (the
manifest scope field already disclaims statement-faithfulness), not a gate. Sequencing:
the fix touches `release/gates.json` via `just manifest`, so execute only after audit
Pass 22 releases the regen surface.

## G5 — Count lineages: one basis, three epochs

Ledger entry: `GAP_LEDGER_v26.7.12.md` §G5 (Status: OPEN).

### Evidence

- Surface 1 (live): `release/release-manifest.json` — 401 artifacts / 203 proven /
  2 stated, foldHash `b1edfbeb`, runIdentifier `ee624be`. Generator `build_manifest.py`
  over every `procint:Decl` in `packs/lean-math-pack/ontology.ttl` (all kinds); proven
  requires `status=='proven'` and non-empty auditMsg (line 60). `ee624be` is 6 docs/chore
  commits behind the anchor, none touching the TTL, so the fold is epoch-current.
  quadrature.json and `paper/release_macros.tex` re-derive from this file.
- Surface 2 (hand-written): `STANDING.md` — 318/145/2, fold `e25724e8`. No generator
  exists (verified: the only repo reference is `justfile:158`, which cats it; git history
  shows hand authorship, `c7d4dd0` -> `2f4f0b5`). Same manifest basis at the ~2026-07-06
  epoch (fold seeded `mfact-v26.7.7-genesis` over 318 artifact hashes, STANDING.md:122-124).
  `README.md:48` calls it "the current, computed standing report" — false on both
  adjectives today.
- Surface 3 (tag-pinned): `dist/github-release/title.txt` + `release/final_status.json` —
  397/197/stated-7, coreReleaseHash `942facf3`, tagCommit `184e3a3`. Generated by
  `build_post_release.py` snapshotting the then-live manifest into the post-release pack
  (`post:coreProven 197`, `post:coreTotalDecls 397`, `post:statedCount 7`), then
  ggen-rendered. These numbers are true of the frozen tag `v26.7.7-procint-certified`.

Resolution of the fork question: all three surfaces are projections of the same
measurement basis — the `procint:Decl` population under build_manifest.py's proven rule —
at three epochs of the evolving catalog: `e25724e8`/318/145 (2026-07-06 hand snapshot) ->
`942facf3`/397/197/stated-7 (frozen tag `184e3a3`) -> `b1edfbeb`/401/203/stated-2 (live).
The deltas are real catalog evolution, checked against `ac647a9`'s diffstat (new
SemanticBridge/Thermo decls explain 397 -> 401; the countermodel/crown-lane promotions
explain stated 7 -> 2 and part of 197 -> 203). The ledger's "stated=7 vs 2 cannot both
hold" dissolves: they hold at different epochs. INFERRED (not replayed): `0e99a2b`'s
triple-quoted-auditMsg regex fix changed the effective proven rule itself, so an
unquantified part of 197 -> 203 is measurement-rule repair rather than catalog change;
separating the two would require replaying the old script against the old TTL.

A fourth lineage datum exists today: `paper/release_macros.tex` puts
`\ReleaseTag{v26.7.7-procint-certified}` beside live 203/401/2 and fold `b1edbeb` — live
counts attributed to a tag whose frozen fold is `942facf3`. This mixed-identity defect is
the strongest argument against regenerating tag-pinned surfaces under the old identity.

### Options

- (a) Regenerate everything at HEAD now under the v26.7.7 identity. Rejected: reproduces
  the release_macros.tex mixed-identity failure on every pinned surface, and is currently
  impossible anyway — `build_post_release.py:111` computes gates_pass False while G4's
  field sits in gates.json, and audit Pass 22 owns the regen surface.
- (b) Annotation only: banner STANDING.md as a frozen snapshot (fold `e25724e8`,
  2026-07-06), fix README.md:48, add epoch lines to final_status/title. Honest and small,
  but hand annotations on ggen-rendered outputs are GENERATED_OUTPUT_DRIFT, erased at the
  next render — they must live in the pack templates (`packs/*`) — and it leaves three
  divergent numbers standing for every reader to reconcile.
- (c) Regeneration under the new identity plus permanent epoch self-description: after G4
  closes and G6 cuts v26.7.13, `just release` re-snapshots 401/203/2 under the new tag;
  template a permanent epoch line (tag, tagCommit, foldHash, generation timestamp) into
  the gh_release_title / final_status / standing.env templates so staleness becomes
  self-describing rather than forensic; give STANDING.md a real generator (its per-family
  ladder is described as computable from the fragment TTLs, STANDING.md:40-42) or archive
  it with a dated banner and repoint README at `scripts/report.py status`.

### Recommendation

(c), sequenced G4 -> G6 -> G5-regeneration. Same-basis/three-epochs means regeneration is
the fix — but only under the new tag identity, never under v26.7.7 — and STANDING.md's
missing generator is the structural defect to close (or the document is archived, not
left claiming to be computed).

## G6 — Release identity: touch list and the real shape of the G4 block

Ledger entry: `GAP_LEDGER_v26.7.12.md` §G6 (Status: OPEN).

### Evidence

Hardcoded / hand-carried version sites (all verified at the anchor):

1. `scripts/build_manifest.py:94` `RELEASE = 'v26.7.7'` — the root identity source; line
   95 seeds the foldHash genesis from `f'mfact-{RELEASE}-genesis'`, so a bump changes the
   release fold by design, and every downstream hash re-derives. (The ledger cites line
   72; the file has grown — it is line 94 now.)
2. `mfact/Mfact/Cli.lean:6` `mfactVersion := "26.7.7"` — feeds only `mfact version`
   (`:42`); the certify banner (`:63`) prints the manifest's release field, so it follows
   build_manifest.py automatically. mfactVersion is an independent second identity
   requiring a lake rebuild to change.
3. `release/standing.env:1` header "release v26.7.6" — hand-carried relic, one release
   older than everything else; verified no writer exists (grep across scripts/, justfile,
   and all pack templates = 0 hits; `gen_type_inventory_hash.py` upserts only the
   TYPE_INVENTORY_HASH line). Line 2's dead scratchpad regen hint is G42 — same fix site.
4. `scripts/independent_replay.sh:9` `TAG=v26.7.7-procint-certified` — hardcode.
5. `scripts/mine_commit.py:7-8` — runs `git tag -f v26.7.7-procint-certified HEAD`;
   verified zero callers (justfile, scripts/, .github/ all clean). An orphan
   force-retagger: running it would silently re-bind every tag-pinned surface to HEAD,
   the exact frozen-tag violation G5 warns about. A standing hazard regardless of the
   bump.
6. Git tags: exactly two (`v26.7.6-procint-certified`, `v26.7.7-procint-certified`);
   naming convention `{RELEASE}-procint-certified`.

Derived sites need no edit (they follow the manifest): `build_post_release.py:47-52`
(including replay-receipt validity bound to the derived CORE_TAG at `:151-155`),
`build_quadrature.py:133`, quadrature release_id, `release_macros.tex` `\ReleaseTag`, the
certify banner. The justfile has no version hardcodes. Doc-level identities: STANDING.md:3
v26.7.7; ROADMAP self-identifies v26.7.11; the gap ledger is v26.7.12; the PRD/ARD name
v26.7.13.

Dependency check — the ledger's stated mechanism is stale; the dependency itself is real.
`GAP_LEDGER_v26.7.12.md:221-222` says G6 is "blocked in practice by G1/G4 (certify will
not pass until they land)". Certify passes today: `certify.log:2394` shows exit-0 against
the committed gates.json that contains `countermodel_not_promoted=false` (the 4-field
GatesJson ignores unknown keys). The dependency survives through a different, undocumented
edge:

```python
('gates_pass', all(gates.values())),  # scripts/build_post_release.py:111
```

With the field false, `just release` (which runs `--plan` mode, `justfile:350-351`)
renders the github_release packet BLOCKED into the new final_status.json; full mode exits
2 (PUBLICATION_PACKET_BLOCKED). So G6 is blocked by G4 via build_post_release, not via
certify.

The v26.7.13 touch list: (1) `build_manifest.py:94` -> 'v26.7.13'; (2) `Cli.lean:6` ->
"26.7.13" plus a rebuild of the mfact binary; (3) template the standing.env header from
the manifest's release field (`gen_type_inventory_hash.py` already upserts into that file
and is the natural owner; fixes G42's dead hint and adds the research-papers scope line
the ledger's G6 Fix asks for, in the same edit); (4) derive independent_replay.sh's TAG
from the manifest; (5) delete or quarantine mine_commit.py; (6) full `just release`
(regenerates the manifest with a new fold, certify banner, quadrature, the post-release
pack and its rendered final_status.json / title.txt / body / replay_plan, and
FINAL_STATUS.md); (7) cut annotated tag `v26.7.13-procint-certified` at the commit where
the regenerated manifest's runIdentifier passes report.py's ancestor check — regeneration
and tagging must land on the same commit (the current runIdentifier `ee624be` is already
6 commits behind the anchor); (8) `just independent-replay` against the new tag (closes
G8's stale REPLAY_PASS) and re-run the standing guard (G7); (9) prose: STANDING.md
header/banner, README, ledger version.

### Options

- (a) Bump now and accept the BLOCKED packet: ships a brand-new identity whose own status
  surface says github_release=BLOCKED for a reason (a retired-in-spirit guard) nobody
  intends. Rejected.
- (b) Decouple first: change `build_post_release.py:111` to enumerate the four certify
  gates explicitly instead of `all(gates.values())`. Small, but it un-wires the guard
  field's only live consumer as a side effect — resolving G4 silently inside a G6 patch,
  without the ledger card the discipline requires. Rejected as a standalone move.
- (c) Sequence: close G4 first (field removed from gates.json with a dated closure, which
  makes `all(gates.values())` truthfully all-true with no code change at `:111`); land the
  version-derivation hygiene (touch-list items 3-5) as version-neutral prep; then the
  two-line bump (items 1-2), full `just release`, tag, independent replay, standing guard.
  Longest path, but every surface flips atomically to the new identity with true gates,
  and the bump diff shrinks to two lines plus generated output.

### Recommendation

(c). Also correct G6's ledger dependency attribution (done via this brief's Update
bullet): blocked by G4 through `build_post_release.py:111`, no longer through certify
(stale since G1's `0e99a2b`/`b2f5b0e` fix chain), so the dependency graph the next
workflow schedules from is true. All code/regen work above is post-Pass-22: it touches
`release/*` and `packs/*` and requires just/lake targets excluded from the run that
produced this brief.

## Decision checklist

The minimal ordered decisions that produce an honest v26.7.13 tag:

1. G4 disposition (human call): retire-as-fulfilled per §G4's recommendation, or wire the
   field live per option (a). If retiring: one commit deleting `build_manifest.py:120-132`
   plus the `:141` field, with the dated ledger closure citing the evidence chain. Do not
   start before audit Pass 22 releases the regen surface (`just manifest` rewrites
   `release/gates.json`).
2. Version-hygiene prep (human call, chiefly on deleting mine_commit.py): §G6 touch-list
   items 3-5 — standing.env header templating (+ G42 fix + scope line),
   independent_replay.sh TAG derivation, mine_commit.py removal. Version-neutral; can land
   alongside step 1.
3. The bump (human call on committing to the v26.7.13 identity): `build_manifest.py:94`
   and `Cli.lean:6`, then full `just release`. This step is also G5's fix — all derived
   surfaces regenerate under the new identity with true gates. Decide the §G5(c) riders
   here: permanent epoch-line templating, and STANDING.md's fate (real generator vs
   archive with banner).
4. Tag: cut annotated `v26.7.13-procint-certified` at the exact regeneration commit (the
   runIdentifier ancestor check requires regeneration and tag on the same commit), then
   `just independent-replay` (closes G8's staleness) and the standing guard re-run (G7).
5. Tagging and pushing are user actions. Nothing in this brief, its commit, or any agent
   run tags, pushes, or claims v26.7.13 SHIPPED; this document records the decision
   surface only.

## References

- `RELEASE_v26.7.13_PRD.md` — "Release readiness — 2026-07-13 end of session" (the green
  mechanical DoD this brief presumes) and its "Residuals a tag decision must weigh" list.
- `GAP_LEDGER_v26.7.12.md` — entries G4, G5, G6 (each carries a dated Update bullet
  pointing at this brief), plus G7, G8, G42 referenced above.
- `AGENTS.md` — the Combinatorial Maximalism Mandate (§3) and No Ambient Theorem Authority
  law (§4) the recommendations are written under.
- `STANDING.md` — the stale hand-written standing surface discussed in §G5.
