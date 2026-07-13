# Eleven-Witness Crown Matrix

For every crown capability `c`, manufacture the following witness tuple:

\[
W_C(c) = (K,P,N,C_m,P_b,M_e,M_u,C_o,F,R,S)
\]

| Symbol | Witness | Primary atlas tests |
|---|---|---|
| K | Kernel | T001, T002, T006, T007 |
| P | Positive | T003, T008 |
| N | Negative | T010, T011, T021, T094 |
| C_m | Countermodel | T050–T054 |
| P_b | Property | T029–T032 |
| M_e | Metamorphic | T041–T049 |
| M_u | Mutation | T055 |
| C_o | Composition | T004, T063 |
| F | Flow | T064 |
| R | Replay | T048, T071–T073 |
| S | Standing Path | T132, T133 |

## Crown law

`CrownAlive(c)` is permitted only when every witness required by the claim card is
admitted. A claim card may explicitly mark a witness `NOT_APPLICABLE`, but must state
the structural reason. `NOT_IMPLEMENTED` and `NOT_APPLICABLE` are never synonyms.

## LLM algorithm

1. Read the claim card.
2. Create the 11-row witness matrix.
3. Resolve each row to exact test instance IDs.
4. Find existing tests by stable instance name.
5. Manufacture missing witnesses.
6. Run/review the environment-derived auditor.
7. Compute standing-path coverage.
8. Promote only when required witness rows and required path edges are complete.

## Empty-suite guard

The matrix fails when the required witness set is empty unless the claim itself is
explicitly `UNSUPPORTED`. This prevents a verifier from passing because zero checks
failed.
