# FINAL STATUS — v26.7.6

Rendered view over standing (post-release-pack). Nothing here is asserted
in prose: every value is projected from receipts. Layered standing — the
core release, the publication packet, and the auxiliary lanes are three
different identities and must not be flattened into one verdict.

## Core certified release (frozen)

```
CORE_RELEASE=ALIVE
CORE_RELEASE_HASH=a138ee84d0c08e0e946e0d0bb805a563b8304cf268eb97e6b9784bd36279fd86
CORE_PROVEN=145
CORE_TOTAL_DECLS=318
CORE_STATED=2
RENDERED_COMMIT=bdd8e99
TAG_EXPECTED=v26.7.6-procint-certified
TAG_COMMIT=1712d76
RENDERED_COMMIT_IS_ANCESTOR_OF_TAG=PASS
```

## Publication packet (separate identity; never self-actuated)

```
POST_RELEASE_PACKET_HASH=9c787499b845d2dcbe4212ac416f3469f0849b187bfcf80b21bf60d2313ada29
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
REPLAY=REPLAY_NOT_RUN
DOCS_LANE=PLANNED
WFNET_CROWN_THEOREM=STATED
NEXT_DOMAIN_FOUNDRY=PLANNED
```

## Crown research lane

| Obligation | Status | Note |
|---|---|---|
| `sound_iff_shortCircuit_live_bounded` | STATED | the crown equivalence itself (van der Aalst 1997, Lemma 8) |
| `proper_completion_support` | PROVEN_SUPPORT | soundness implies the final marking is reachable |
| `dead_transition_support` | PROVEN_SUPPORT | soundness implies every transition can fire |
| `unfolding_correctness` | STATED | branching-process unfolding statement (separate stated lane) |

STATED is never silently promoted: `ProcInt.Release.crown_not_promoted`
is kernel-admitted over this same list.
