# FINAL STATUS — v26.7.7

Rendered view over standing (post-release-pack). Nothing here is asserted
in prose: every value is projected from receipts. Layered standing — the
core release, the publication packet, and the auxiliary lanes are three
different identities and must not be flattened into one verdict.

## Core certified release (frozen)

```
CORE_RELEASE=ALIVE
CORE_RELEASE_HASH=942facf32d48cd1a26c0f06b9396c6c150ab4d95d601bd090a8e1b9e7ef2d434
CORE_PROVEN=197
CORE_TOTAL_DECLS=397
CORE_STATED=7
RENDERED_COMMIT=404b4c9
TAG_EXPECTED=v26.7.7-procint-certified
TAG_COMMIT=404b4c9
RENDERED_COMMIT_IS_ANCESTOR_OF_TAG=PASS
```

## Publication packet (separate identity; never self-actuated)

```
POST_RELEASE_PACKET_HASH=a4b7475180f0d73f55462c33b82561d76384e19e0b3cb83506315b61361770d1
PUBLICATION_ACTUATION=PENDING_EXTERNAL_ACTUATION
ARXIV_PACKET=PENDING
ARXIV_UPLOAD_PACKET=BLOCKED
GITHUB_PUSH_PACKET=BLOCKED
GITHUB_RELEASE_PACKET=ALIVE
```

arXiv gate: first pass (--plan): fragments not yet rendered.
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
