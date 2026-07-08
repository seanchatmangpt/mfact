# Original User Request

## 2026-07-07T23:44:56Z

## Teamwork Project Prompt — Tickets 013 + 014

# Definition of Done

This project is **DONE** only when all of the following are true:

1. **Ticket 013 certification gaps are fully repaired.**

   * Countermodel theorem is demoted correctly.
   * Countermodel promotion is guarded.
   * `COUNTERMODEL_PROMOTION_REFUSED` is active.
   * AxiomAudit is fixed and passing.
   * Negative controls are run and receipted.
   * Ledger drift is fixed.
   * Correspondence theorems are re-bound.
   * Manifest, ledger, certification, and theorem status agree.

2. **Ticket 014 Standing Guard MCP server exists and is read-only.**

   * Implemented under:

   ```text
   pylab/src/mpops/standing_guard/
   ```

   * Exposes a callable `scan()` tool.
   * `scan()` checks all 8 certification-gap classes from Ticket 013.
   * `scan()` returns structured findings with severity and refusal codes.
   * The server contains no mutation, writing, repair, git, tagging, release, or status-promotion capability.

3. **Standing Guard proves both failure detection and final cleanliness.**

   * On the initial/baseline broken state, `scan()` reproduces every Ticket 013 BLOCKER.
   * On the final patched state, `scan()` reports **zero BLOCKER findings**.

4. **Canonical release pipeline is clean.**

   * `just check` succeeds.
   * `just release` succeeds.
   * Final manifest/certification state is clean.
   * Receipts/replay evidence exists.

5. **A clean release tag is cut.**

   ```text
   v26.7.7-procint-certified
   ```

6. **Final terminal state is exactly one of:**

   ```text
   ALIVE
   BLOCKED
   BUILD_BROKEN
   ```

Use `ALIVE` only if every Done condition above is satisfied.

Use `BLOCKED` only if required evidence, Ticket details, toolchain, baseline, or repository state is unavailable.

Use `BUILD_BROKEN` only if the deterministic build/release pipeline fails after repairs.

No “almost done.”
No “if green.”
No victory prose.
Write receipts.

---

# Mission

Restore the `v26.7.7` release to clean certified standing by executing Ticket 013, and build the read-only Standing Guard MCP server from Ticket 014 so the same certification gaps can be continuously detected.

Working directory:

```text
/Users/sac/mfact
```

Integrity mode:

```text
development
```

---

# Law-State Rules

MathProofOps is lawful artifact manufacture, not code generation.

```text
A = μ(O*)
R = receipt(A)
```

Raw observation `O` has no standing. Only admitted observation `O*` participates in manufacture.

Generation produces candidates. Admission produces standing. Receipts prove consequence. Replay proves receipts are not ornamental.

Status is algebra:

```text
DECLARED
EXTRACTED
STATED
PROVEN
REFUSED
BLOCKED
BUILD_BROKEN
UNKNOWN
UNSUPPORTED
ALIVE
```

Hard rules:

```text
STATED never silently becomes PROVEN.
EXTRACTED is not proof.
Generated is not admitted.
UNKNOWN is not admitted.
UNSUPPORTED is not refused.
mpops observes and assists.
scripts admit and receipt.
pylab is lab/cockpit/research/DX.
standing-producing scripts stay outside pylab.
```

The Standing Guard MCP server is an observer only. It must not create standing.

---

# Required Work

## 1. Establish Baseline Failure

Before fixing anything, establish the broken baseline.

Run or reconstruct the initial `v26.7.7` certification-gap state.

Then run Standing Guard `scan()` against that baseline and prove it detects every Ticket 013 BLOCKER.

If the current working tree is already partially patched, create or checkout a clean baseline worktree/tag/commit representing the broken state.

Baseline evidence must include:

```text
baseline commit/tag/worktree identity
initial scan output
all Ticket 013 BLOCKER classes detected
proof scan performed no mutation
```

Do not skip baseline reproduction.

---

## 2. Build Standing Guard MCP Server

Implement the read-only MCP server at:

```text
pylab/src/mpops/standing_guard/
```

It must expose:

```text
scan()
```

`scan()` must detect the 8 certification-gap classes documented in Ticket 013.

Each finding must include at minimum:

```text
gap_class
severity
refusal_code
path_or_target
evidence
expected
actual
recommended_action
standing_status
```

Severity values must include:

```text
BLOCKER
WARNING
INFO
```

The server may:

```text
read files
parse manifests
parse ledgers
parse certification outputs
parse audit outputs
parse negative-control receipts
parse theorem/correspondence status
run deterministic read-only checks
return structured findings
```

The server must not:

```text
write files
modify manifests
modify ledgers
modify Lean
modify TTL
modify receipts
run repair commands
create commits
create tags
run release
change theorem status
promote/demote status
```

Add tests or static checks proving mutation capability is absent.

Document the read-only boundary.

---

## 3. Fix Ticket 013 Certification Gaps

Execute all Ticket 013 action items.

Required repairs include:

```text
demote the countermodel theorem
fix AxiomAudit
run negative controls
fix ledger drift
re-bind correspondence theorems
restore certification state
```

For every repaired gap, record:

```text
gap class
original failing evidence
repair performed
files changed
command run
resulting status
receipt/replay evidence
```

The countermodel rail must remain boundary justification, not crown theorem standing.

The guard must remain active:

```text
countermodel_not_promoted
```

The refusal must remain active:

```text
COUNTERMODEL_PROMOTION_REFUSED
```

---

## 4. Run Final Standing Guard Scan

After repairs, run:

```text
scan()
```

Final scan must report:

```text
zero BLOCKER findings
```

Any remaining `WARNING`, `INFO`, `UNKNOWN`, `UNSUPPORTED`, or `BLOCKED` items must be listed explicitly with evidence and rationale.

---

## 5. Run Canonical Release Pipeline

Run:

```text
just check
just release
```

Both must succeed.

If either fails, terminal state is `BUILD_BROKEN` unless the failure is due to missing external evidence/tooling, in which case terminal state is `BLOCKED`.

---

## 6. Cut Clean Release Tag

Only after all Done conditions are satisfied, cut:

```text
v26.7.7-procint-certified
```

Do not tag before final scan, `just check`, and `just release` are clean.

---

# Acceptance Criteria

## Standing Guard

* [ ] MCP server exists under `pylab/src/mpops/standing_guard/`.
* [ ] `scan()` is callable.
* [ ] `scan()` checks all 8 Ticket 013 gap classes.
* [ ] Findings include severity and refusal codes.
* [ ] Baseline scan reproduces every Ticket 013 BLOCKER.
* [ ] Final scan reports zero BLOCKER findings.
* [ ] Server has no mutation capability.
* [ ] Read-only boundary is documented.
* [ ] Tests/static checks prove no mutation surface.

## Ticket 013 Repairs

* [ ] Countermodel theorem demoted.
* [ ] Countermodel cannot be promoted into crown standing.
* [ ] `countermodel_not_promoted` guard intact.
* [ ] `COUNTERMODEL_PROMOTION_REFUSED` refusal intact.
* [ ] AxiomAudit fixed and passing.
* [ ] Negative controls run and receipted.
* [ ] Ledger drift fixed.
* [ ] Correspondence theorems re-bound.
* [ ] Manifest/ledger/certification/theorem status agree.
* [ ] No `STATED → PROVEN` silent promotion.
* [ ] No generated Lean hand-edited.

## Release

* [ ] `just check` succeeds.
* [ ] `just release` succeeds.
* [ ] Final Standing Guard scan reports zero BLOCKER findings.
* [ ] Clean tag exists:

```text
v26.7.7-procint-certified
```

---

# Final Report Format

Produce the final report in exactly this structure:

```text
1. Terminal State
2. Definition-of-Done Checklist
3. Baseline Reproduction
4. Standing Guard MCP Implementation
5. Ticket 013 Gap Repairs
6. Final Standing Guard Scan
7. Canonical Pipeline Results
8. Release Tag Evidence
9. Files Changed
10. Receipts / Replay Evidence
11. Remaining UNKNOWN / BLOCKED / UNSUPPORTED Items
```

Every standing claim must cite a command result, manifest status, receipt, or replayable evidence.

No ungrounded claims.

## 2026-07-07T23:46:47Z

# Gemini Pro 3.1 Project Prompt — MathProofOps Tickets 013 + 014

## Definition of Done

This project is **DONE** only when the repository at:

```text
/Users/sac/mfact
```

has been restored to a clean certified `v26.7.7` release state and the new read-only Standing Guard MCP server proves that state.

Done means **all** of the following are true:

1. **Ticket 013 certification gaps are repaired.**

   * Countermodel theorem is demoted correctly.
   * Countermodel promotion is guarded.
   * `countermodel_not_promoted` exists and is active.
   * `COUNTERMODEL_PROMOTION_REFUSED` exists and is active.
   * AxiomAudit is fixed and passing.
   * Negative controls are run and receipted.
   * Ledger drift is fixed.
   * Correspondence theorems are re-bound.
   * Manifest, ledger, certification, theorem status, and receipts agree.

2. **Ticket 014 Standing Guard MCP server exists.**

   * Implemented under:

   ```text
   pylab/src/mpops/standing_guard/
   ```

   * Exposes a callable MCP tool:

   ```text
   scan()
   ```

   * `scan()` checks the 8 certification-gap classes documented in Ticket 013.
   * `scan()` returns structured findings with severity and refusal codes.
   * The MCP server is strictly read-only.
   * The MCP server contains no file-writing, mutation, repair, git, tagging, release, or status-promotion capability.

3. **Standing Guard proves both broken-state detection and final clean state.**

   * Baseline scan reproduces every Ticket 013 BLOCKER finding.
   * Final scan reports:

   ```text
   zero BLOCKER findings
   ```

4. **Canonical release pipeline is clean.**

   * `just check` succeeds.
   * `just release` succeeds.

5. **Clean release tag exists.**

   ```text
   v26.7.7-procint-certified
   ```

6. **Final terminal state is exactly one of:**

   ```text
   ALIVE
   BLOCKED
   BUILD_BROKEN
   ```

Use `ALIVE` only when every Done condition is satisfied with command evidence.

Use `BLOCKED` only when required evidence, ticket text, toolchain, baseline, or repository access is unavailable.

Use `BUILD_BROKEN` only when deterministic build or release commands fail after repairs.

No “almost done.”
No “should be fixed.”
No “if green.”
No victory prose.
Write receipts.

---

## Mission

You are operating as a deterministic implementation and verification agent inside the MathProofOps repository.

Your mission is to execute Ticket 013 and Ticket 014.

Ticket 013 restores the broken `v26.7.7` certification state.

Ticket 014 builds a read-only Standing Guard MCP server that continuously detects the same certification-gap classes.

Working directory:

```text
/Users/sac/mfact
```

Integrity mode:

```text
development
```

---

## Required First Action: Inspect the Repository

Before editing anything, inspect the repository and locate the authoritative Ticket 013 and Ticket 014 sources.

Find and read the ticket files, docs, issue files, ledger entries, manifests, or release notes that define:

```text
Ticket 013
Ticket 014
the 8 certification-gap classes
v26.7.7 certification state
countermodel theorem status
AxiomAudit status
negative controls
ledger drift
correspondence theorem bindings
```

Do not rely on memory or this prompt alone for the 8 gap classes.

Do not invent missing ticket details.

If the authoritative ticket text cannot be found, terminal state is `BLOCKED`.

---

## Law-State Rules

MathProofOps is lawful artifact manufacture, not code generation.

```text
A = μ(O*)
R = receipt(A)
```

Raw observation `O` has no standing. Only admitted observation `O*` participates in manufacture.

Generation produces candidates. Admission produces standing. Receipts prove consequence. Replay proves receipts are not ornamental.

Status is algebra:

```text
DECLARED
EXTRACTED
STATED
PROVEN
REFUSED
BLOCKED
BUILD_BROKEN
UNKNOWN
UNSUPPORTED
ALIVE
```

Hard rules:

```text
STATED never silently becomes PROVEN.
EXTRACTED is not proof.
Generated is not admitted.
UNKNOWN is not admitted.
UNSUPPORTED is not refused.
mpops observes and assists.
scripts admit and receipt.
pylab is lab/cockpit/research/DX.
standing-producing scripts stay outside pylab.
```

Standing Guard observes only. It does not create standing.

---

## Execution Order

### 1. Locate and Parse Tickets

Read Ticket 013 and Ticket 014.

Extract the exact 8 certification-gap classes from Ticket 013.

Record them in your working notes and final report.

Each gap class must map to:

```text
gap_class
expected evidence
failure condition
severity
refusal_code
repair action
verification command
```

---

### 2. Establish Baseline Failure

Before applying repairs, establish the broken baseline.

Use the current working tree only when it still represents the broken state.

When the current tree is already partially repaired, create or checkout a separate baseline worktree, tag, or commit representing the broken `v26.7.7` certification-gap state.

Run or simulate the Standing Guard scan against that baseline after the scanner exists.

Baseline evidence must include:

```text
baseline commit/tag/worktree identity
initial scan output
all Ticket 013 BLOCKER classes detected
proof scan performed no mutation
```

Do not skip baseline reproduction.

---

### 3. Build Standing Guard MCP Server

Implement the MCP server at:

```text
pylab/src/mpops/standing_guard/
```

Expose:

```text
scan()
```

The scan tool must detect the exact 8 certification-gap classes from Ticket 013.

Each finding must include:

```text
gap_class
severity
refusal_code
path_or_target
evidence
expected
actual
recommended_action
standing_status
```

Supported severity values:

```text
BLOCKER
WARNING
INFO
```

The server may:

```text
read files
parse manifests
parse ledgers
parse certification outputs
parse audit outputs
parse negative-control receipts
parse theorem status
parse correspondence status
run deterministic read-only checks
return structured findings
```

The server must not:

```text
write files
modify manifests
modify ledgers
modify Lean
modify TTL
modify receipts
run repairs
create commits
create tags
run release
change theorem status
promote status
demote status
```

Add a test or static check proving the server has no mutation surface.

Document the read-only boundary.

---

### 4. Repair Ticket 013 Gaps

Execute every Ticket 013 action item.

Known required repairs include:

```text
demote the countermodel theorem
fix AxiomAudit
run negative controls
fix ledger drift
re-bind correspondence theorems
restore certification state
```

For each repaired gap, record:

```text
gap class
original failing evidence
repair performed
files changed
command run
resulting status
receipt or replay evidence
```

The countermodel rail is boundary justification, not crown theorem standing.

The guard must remain active:

```text
countermodel_not_promoted
```

The refusal must remain active:

```text
COUNTERMODEL_PROMOTION_REFUSED
```

Do not silently promote the countermodel into crown standing.

Do not hand-edit generated Lean.

---

### 5. Run Final Standing Guard Scan

After repairs, run:

```text
scan()
```

Final scan must report:

```text
zero BLOCKER findings
```

Any remaining `WARNING`, `INFO`, `UNKNOWN`, `UNSUPPORTED`, or `BLOCKED` items must be listed explicitly with evidence and rationale.

---

### 6. Run Canonical Pipeline

Run:

```text
just check
just release
```

Both must succeed before tagging.

Capture command output evidence.

---

### 7. Cut Clean Release Tag

Only after final scan, `just check`, and `just release` are clean, cut:

```text
v26.7.7-procint-certified
```

Do not claim the tag exists unless a command verifies it.

Verify with:

```text
git tag --list v26.7.7-procint-certified
git status --short
```

---

## Acceptance Criteria

### Standing Guard

* [ ] MCP server exists under `pylab/src/mpops/standing_guard/`.
* [ ] `scan()` is callable.
* [ ] `scan()` checks all 8 Ticket 013 gap classes.
* [ ] Findings include severity and refusal codes.
* [ ] Baseline scan reproduces every Ticket 013 BLOCKER.
* [ ] Final scan reports zero BLOCKER findings.
* [ ] Server has no mutation capability.
* [ ] Read-only boundary is documented.
* [ ] Tests or static checks prove no mutation surface.

### Ticket 013 Repairs

* [ ] Countermodel theorem demoted.
* [ ] Countermodel cannot be promoted into crown standing.
* [ ] `countermodel_not_promoted` guard intact.
* [ ] `COUNTERMODEL_PROMOTION_REFUSED` refusal intact.
* [ ] AxiomAudit fixed and passing.
* [ ] Negative controls run and receipted.
* [ ] Ledger drift fixed.
* [ ] Correspondence theorems re-bound.
* [ ] Manifest, ledger, certification, theorem status, and receipts agree.
* [ ] No `STATED → PROVEN` silent promotion.
* [ ] No generated Lean hand-edited.

### Release

* [ ] `just check` succeeds.
* [ ] `just release` succeeds.
* [ ] Final Standing Guard scan reports zero BLOCKER findings.
* [ ] Clean tag exists:

```text
v26.7.7-procint-certified
```

---

## Final Report Format

Produce the final report in exactly this structure:

```text
1. Terminal State
2. Definition-of-Done Checklist
3. Authoritative Ticket Sources
4. Eight Certification-Gap Classes
5. Baseline Reproduction
6. Standing Guard MCP Implementation
7. Ticket 013 Gap Repairs
8. Final Standing Guard Scan
9. Canonical Pipeline Results
10. Release Tag Evidence
11. Files Changed
12. Receipts / Replay Evidence
13. Remaining UNKNOWN / BLOCKED / UNSUPPORTED Items
```

Every standing claim must cite one of:

```text
command result
manifest status
ledger entry
receipt
replay evidence
file path with exact changed object
```

Do not claim completion from intention.
Do not infer proof from generated output.
Do not infer release standing from prose.
Do not invent missing evidence.

