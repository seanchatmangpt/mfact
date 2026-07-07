# FINAL STATUS — v26.7.7

Rendered view over standing (post-release-pack). Nothing here is asserted
in prose: every value is projected from receipts. Layered standing — the
core release, the publication packet, and the auxiliary lanes are three
different identities and must not be flattened into one verdict.

## Core certified release (frozen)

```
CORE_RELEASE=ALIVE
CORE_RELEASE_HASH=e25724e88d4b2ee396b7442d5604dafa1b6da9fd6c61614ebd4062ad073c080d
CORE_PROVEN=145
CORE_TOTAL_DECLS=318
CORE_STATED=2
RENDERED_COMMIT=b130f4a
TAG_EXPECTED=v26.7.7-procint-certified
TAG_COMMIT=cbf0043
RENDERED_COMMIT_IS_ANCESTOR_OF_TAG=PASS
```

## Publication packet (separate identity; never self-actuated)

```
POST_RELEASE_PACKET_HASH=e3f7ea36babc0fb0ed8295585e03f027f8aad2ae7b06adaeeb9b75d951e6b87a
PUBLICATION_ACTUATION=PENDING_EXTERNAL_ACTUATION
ARXIV_PACKET=ALIVE
ARXIV_UPLOAD_PACKET=ALIVE
GITHUB_PUSH_PACKET=ALIVE
GITHUB_RELEASE_PACKET=ALIVE
```

arXiv gate: cold build PASS from untarred package (13 declared files).
Actuation packets whose requirements are all met are ALIVE; publication
itself remains the user's action in every case.

## Auxiliary lanes

```
REPLAY=REPLAY_PASS
DOCS_LANE=PASS
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
