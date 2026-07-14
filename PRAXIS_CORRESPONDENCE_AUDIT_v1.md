# mfact ↔ Praxis Correspondence Audit — v1 (2026-07-13)

## Method note — read this before trusting anything below

This document records, for four Lean artifacts built in mfact's Operation Dogfood waves
(`procint/ProcInt/Playground/Dogfood/{Outcome,Guard,Lifecycle,PowlBounds}.lean`), what
actually exists in `~/praxis`'s real, committed Rust source as of commit `649cbdbb`, and
whether any admitted correspondence morphism (AGENTS.md §4) connects them.

**Every judgment of "this looks structurally similar" in this document was made by an AI
(a read-only exploration agent, graded by the author of this document, who is also an
AI) — not by any kernel, type checker, or automated proof obligation.** There is no
mechanism in this repo, or in praxis, or anywhere, that formally checks whether a Rust
function satisfies a Lean theorem's hypotheses. Lean's own kernel checks Lean proof
terms; nothing checks the claim that a Rust function *is* the thing a Lean theorem is
about. That check, right now, is entirely on the honor system — this document's honor
system, specifically — and the reader (a human, or a future agent) is the only
independent verification this document has. Read every "ANALOGY" entry below as "an AI
noticed a resemblance," not as evidence.

Per AGENTS.md §4's edge taxonomy (DEFINITIONAL / PROVEN / IMPORTED / CORRESPONDENCE /
CONJECTURAL / ANALOGY / MISSING), every edge recorded here is one of exactly two kinds:

- **MISSING** — no real Rust construction exists to even compare against.
- **ANALOGY** — a real Rust construction exists, an AI judged it structurally similar to
  the Lean object, and per AGENTS.md's own rule *"an ANALOGY edge never supports theorem
  prose"* — nothing below transfers standing from the Lean side to the Rust side, or
  vice versa, on the strength of an ANALOGY edge. No entry in this document is graded
  CORRESPONDENCE, because CORRESPONDENCE requires an admitted morphism with discharged
  structure-preservation obligations, and no such morphism has been constructed, checked,
  or even formally stated for anything below — there is currently no formalism in which
  "a Rust function corresponds to a Lean theorem" could even be posed as a checkable
  claim, let alone proven.

Source of the Rust-side facts: a read-only exploration agent, instructed to report only
exact `file:line` citations and to say "NOT FOUND" rather than extrapolate. Its full
report is not reproduced here; every claim below is independently re-quotable from that
transcript. Nothing in `~/praxis` was written, edited, or built by that agent or by this
document.

## Edge 1 — `SearchOutcome` (Outcome.lean) ↔ praxis's `SearchOutcome<P>`

**Lean side (real, kernel-checked, this session):** `inductive SearchOutcome (P F)` with
`found`/`exhausted`/`bounded(frontier)`/`unsupported`/`inconsistent`, non-collapse
theorems (`bound_hit_bounded`, `exhausted_stable`), a resume-composition law.

**Rust side: MISSING.** `grep -rn "SearchOutcome" --include=*.rs .` across all of
`~/praxis` returns zero hits in any `.rs` file. The type exists only as prose/design
text, and the two design documents that describe it **disagree with each other**:
`docs/releases/v26.7.13/PRESS_RELEASE.md:170-172` describes a 5-constructor version
matching this session's Lean shape; `docs/releases/v26.7.13/ARD.md:175-179` gives a
`// PLANNED` Rust sketch with only 3 constructors (`Found`/`Bounded`/`Exhausted`) and no
`Unsupported`/`Inconsistent`. A third document in the same repo,
`docs/releases/v26.7.13/OPERATION_DOGFOOD_PRD.md:566-576`, already flags this
contradiction independently and states its own repo-wide grep for
`enum SearchOutcome|struct SearchOutcome` under `crates/` also returned zero matches.

The closest real Rust constructions — `GroundError` (`crates/pddl-index/src/ground.rs:
44-57`) and `DecompositionOutcome` (`crates/cng/src/bench/decomp/mod.rs:83-95`) — are
each 3-variant, collapse "search exhausted" and "no plan exists" into one variant
(`NoAdmittedPlan`), and were judged by the exploration agent to not be structural
analogs even loosely, since neither distinguishes bounded-from-exhausted at all — which
is the entire content of the Lean theorem this edge would need to correspond to.

**Standing: MISSING.** There is nothing to write a correspondence to. Any claim that
mfact's `SearchOutcome` "supports" or "grounds" or "backs" praxis's outcome algebra is
false as stated today — praxis's outcome algebra does not yet exist as code.

## Edge 2 — `Approval`/`guardedCompleteStep` (Guard.lean) ↔ a mutation-approval gate

**Lean side (real, kernel-checked, this session):** `Approval` with decidable `covers`,
`guardedCompleteStep`, `zero_unauthorized_completion` over `GuardedTrace`.

**Rust side: MISSING for the specific shape; ANALOGY for the broader mechanism.**
`grep -rn "fn covers|struct Approval|enum Approval"` across `~/praxis` returns zero
hits — no mutation-surface-membership predicate exists under this or any name. What
*does* exist, real and tested: `Broker::authorize`
(`crates/multifractal-workflow/src/f18_broker_law.rs:515`) mints an `AuthorityToken`
(line 269) as a keyed BLAKE3 hash of `(secret, workflow_id, step_id, idempotency_key)`;
`Broker::claim_idempotency` (line 536) re-derives and checks that token before an atomic
`HashMap::entry` claim, refusing `AuthorityInvalid` on mismatch. This is a real
authorization gate, but it is structurally a *different mechanism* than `Approval.covers`:
the Lean object checks set-membership of an action inside a pre-declared mutation
surface; the Rust object checks equality of a deterministically-derived token. An AI
(this document's author) judges these "look related" — a mutation cannot proceed without
a matching credential in both — but that judgment is exactly the kind the method note
above warns against treating as more than a hunch.

Compounding this: **two separate broker implementations exist**, not one. The module
above (`f18_broker_law.rs`) discloses, in its own doc comment (lines 65-88), *"No
production caller in this repo. Nothing in `crates/multifractal-workflow` yet routes a
real external actuation through this `Broker`."* A second, unrelated broker
(`WorkdayHookBroker`, `crates/cng/src/bench/hooks.rs:67-79`) is the one actually invoked
by real code, but only inside `cng`'s own benchmark/demo pipeline — not a general
external mutation surface. Praxis's own vision text ("the broker remains the only lawful
DO path") does not currently correspond to a singular, universally-wired mechanism;
it corresponds to two partial, non-unified ones, one of which is explicitly disclosed as
unused.

**Standing: ANALOGY at best, and only for the general shape** (a credential-gated
mutation claim exists and is tested); **MISSING for the specific
mutation-surface-membership predicate** `Approval.covers` models. Neither licenses
theorem prose.

## Edge 3 — `receiptCheck`/lifecycle (Lifecycle.lean) ↔ receipt/idempotence machinery

**Lean side (real, kernel-checked, this session):** `receiptCheck_false_iff` (the
zero-unreceipted-actuation law over arbitrary event traces), `completeStep_idem` +
`guarded_refuses_duplicate` (step idempotence, no duplicate receipt), `resume_from_receipt`.

**Rust side: real code exists, and this is the edge where the resemblance is strongest —
which is precisely why it needs the most explicit caveat, not the least.**
`Broker::claim_idempotency` (`f18_broker_law.rs:536-566`) is a real, tested, atomic claim
that refuses a second processing of the same `ActionId` with
`DuplicateIdempotencyClaim{action, existing_state}`. `Broker::issue_receipt` (line 759)
and `Broker::replay_receipt` (line 818) share one function, `receipt_hash_input`
(lines 391-411), to both mint and re-verify a receipt — so issuance and replay cannot
silently diverge, by construction, in that Rust code. Separately,
`crates/praxis-core/src/receipt_validator.rs::ReceiptValidator::validate` (line 105) runs
a fixed 5-stage pipeline (schema, chain-recompute, chain-linkage, monotonic,
token-replay) over an arbitrary `&[ReceiptRecord]` trace — closer in *shape* to
`receiptCheck`'s "check an arbitrary trace" signature than `claim_idempotency`'s
"gate one live action" signature.

An AI (this document's author) judges: the *pattern* "issuance and replay share one
hash function, so they cannot silently disagree" in the Rust code, and the *pattern*
"a duplicate action is refused, never silently re-receipted" in `receiptCheck_false_iff`
and `guarded_refuses_duplicate`, look like they are gesturing at the same invariant. **No
proof of this exists.** Nothing has checked that `Broker`'s `ActionId`-keyed dedup
actually satisfies the Lean side's quantifier structure (over *arbitrary* traces, not
just live single-action gating), or that `ReceiptValidator`'s 5 stages jointly imply
anything the Lean theorem states. This is the single most tempting edge in this document
to overclaim, and the method note above exists specifically because of how tempting it
is.

**Standing: ANALOGY.** Two independent, real, tested Rust mechanisms exist that an AI
judged thematically related to this Lean artifact. Neither is proven to correspond, and
this document does not claim either does.

## Edge 4 — POWL boundedness (PowlBounds.lean) ↔ praxis's POWL crate

**Lean side (real, kernel-checked, this session):** `expandLayer_bounds_strictly`
(rescued from an orphan file), the island-bridge to `MFW/Termination`'s
`ManufactureStep`/`no_infinite_productive_mfw_chain`.

**Rust side: MISSING, and — unusually — praxis's own source already says so.**
`crates/powl2-decompose/src/powl.rs:11-22` contains an explicit, pre-existing disclosure
written by a different agent in this same praxis codebase: mfact's
`Models/{ChoiceGraph,Powl}.lean` "port a different, separate Rust crate
(`wasm4pm-compat`, not `powl2-decompose`)," and further (lines 79-92) that
`powl2-decompose::Powl` (choice-graph-based, Kourani/Park/van der Aalst 2025) is
**structurally different** from mfact's `Powl.lean` (tree-structured, Kourani & van
Zelst BPM 2023 Defs 1-2) — the module's own words: "these are not structural analogs."

This means the correspondence target for `PowlBounds.lean`, if one exists at all, is not
in `~/praxis` — it would be in the sibling `~/wasm4pm-compat` repository, which this
audit did not examine (out of scope for this pass; a future pass should read
`~/wasm4pm-compat`'s POWL source before attempting this edge, the same read-only-explore
discipline as this document).

**Standing: MISSING within `~/praxis`.** Whether an ANALOGY or better exists in
`~/wasm4pm-compat` is genuinely unknown — not investigated, not assumed.

## What this document does not do

It does not claim mfact's theorems are wrong, unused, or without value — the Dogfood
waves' kernel-checked standing is unaffected; nothing here touches Lean's own proof
obligations. It does not claim praxis's real code (the broker, the OCEL/PROV projection
in `crates/cng/src/otel_ocel.rs` and `otel_receipt.rs`, `pddl-index`'s PDDL8 bounds) is
deficient — that code is real, tested, and does real work; it simply doesn't yet
correspond to anything mfact proved, because no formalism exists in which that
correspondence could be checked rather than asserted.

It does not fix the earlier "implement the full crown demonstration" request's premise.
That request assumed `SearchOutcome<P>`, the broker as a singular DO path, and the six
slice-composition obligations already existed as wired, real components needing only
"missing edges." Edge 1 and the six-obligation check (found `// PLANNED` only, in the
same exploration, not separately carded here) show that premise does not hold: those
pieces are aspirational design text, in some cases contradicting each other, not
existing code with gaps between them.

## Standing summary

| Edge | Lean artifact | Rust target | Standing |
|---|---|---|---|
| 1 | `SearchOutcome` | none exists | MISSING |
| 2 | `Approval.covers` | none (broker credential-check exists, diff. shape) | MISSING / ANALOGY |
| 3 | `receiptCheck`/idempotence | `Broker::claim_idempotency`, `ReceiptValidator` | ANALOGY |
| 4 | POWL boundedness | none in praxis (redirect: `~/wasm4pm-compat`, unexamined) | MISSING |

No CORRESPONDENCE edges. No theorem prose licensed by any row above.
