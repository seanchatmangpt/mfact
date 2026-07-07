# FINAL STATUS — v26.7.7

Rendered view over standing (post-release-pack). Nothing here is asserted
in prose: every value is projected from receipts. Layered standing — the
core release, the publication packet, and the auxiliary lanes are three
different identities and must not be flattened into one verdict.

## Core certified release (frozen)

```
CORE_RELEASE=ALIVE
CORE_RELEASE_HASH=c528304f40660e304d444dd1ad2a2edbeac0d6f7c12ae3368e2577c9d38ea9e0
CORE_PROVEN=197
CORE_TOTAL_DECLS=388
CORE_STATED=2
RENDERED_COMMIT=3994029
TAG_EXPECTED=v26.7.7-procint-certified
TAG_COMMIT=6f4c370
RENDERED_COMMIT_IS_ANCESTOR_OF_TAG=FAIL
```

## Publication packet (separate identity; never self-actuated)

```
POST_RELEASE_PACKET_HASH=041926326e80761c4b868bcd21151f617572a6dc27689c9d85adf1eb46d7f334
PUBLICATION_ACTUATION=PENDING_EXTERNAL_ACTUATION
ARXIV_PACKET=ALIVE
ARXIV_UPLOAD_PACKET=ALIVE
GITHUB_PUSH_PACKET=BLOCKED
GITHUB_RELEASE_PACKET=ALIVE
```

arXiv gate: cold build PASS from untarred package (13 declared files).
Actuation packets whose requirements are all met are ALIVE; publication
itself remains the user's action in every case.

## Auxiliary lanes

```
REPLAY=REPLAY_PASS
DOCS_LANE=PASS
WFNET_CROWN_THEOREM=PROVEN
NEXT_DOMAIN_FOUNDRY=PLANNED
```

## Crown research lane

| Obligation | Status | Note |
|---|---|---|
| `sound_iff_shortCircuit_live_bounded` | PROVEN | the crown equivalence itself (van der Aalst 1997, Lemma 8) |
| `proper_completion_support` | PROVEN_SUPPORT | soundness implies the final marking is reachable |
| `dead_transition_support` | PROVEN_SUPPORT | soundness implies every transition can fire |
| `unfolding_correctness` | STATED | branching-process unfolding statement (separate stated lane) |

The crown lane's status is pinned, not asserted: `ProcInt.Release.crown_status_promoted`
is kernel-admitted over this same list.
