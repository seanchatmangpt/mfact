# SOC2 Flow-Test Pattern

Use the two-tenant SOC2 audit flow as the reference pattern for world-centered tests.

## Positive file

One concrete scenario should:

1. Construct a nonidentity closure operator.
2. Prove the tenancy separation hypothesis genuinely holds.
3. Fire minimal-support / tenant-residue isolation.
4. Construct a concrete execution chain.
5. Fire the receipted-completion invariant at every step.
6. Construct two differently ordered traces over the same evidence.
7. Prove the independent events commute.
8. Apply adjacent-swap / trace-equivalence replay.
9. Validate the manufactured receipt on the exact shared state.
10. End with a scenario-specific conclusion.

## Negative companion

Reuse the same domain vocabulary and, where possible, the same known countermodel.
Break `Separated` and show the stronger cross-tenant residue conclusion fails.

## What this pattern prevents

- unrelated theorem islands;
- hand-authored analogues at every layer;
- positive-only happy paths;
- vacuous theorem firing;
- local replay examples unrelated to the business flow.

## Scope

This flow remains inside mfact's controlled mathematical/specification chain. It
does not verify a downstream runtime or cloud deployment.
