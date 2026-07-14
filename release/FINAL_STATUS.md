# FINAL STATUS — v26.7.13

Rendered view over standing (post-release-pack). Nothing here is asserted
in prose: every value is projected from receipts. Layered standing — the
core release, the publication packet, and the auxiliary lanes are three
different identities and must not be flattened into one verdict.

## Core certified release (frozen)

```
CORE_RELEASE=ALIVE
CORE_RELEASE_HASH=74900dc3fc5aa2e6ad46224655f65ecd2e49636c91ac2204614e16cbe1521f32
CORE_PROVEN=203
CORE_TOTAL_DECLS=401
CORE_STATED=2
RENDERED_COMMIT=b26e1db
TAG_EXPECTED=v26.7.13-procint-certified
TAG_COMMIT=650b388
RENDERED_COMMIT_IS_ANCESTOR_OF_TAG=PASS
```

## Publication packet (separate identity; never self-actuated)

```
POST_RELEASE_PACKET_HASH=7fc3abfb7ee9778b2ae6dcb6a35135f6593549e7312da29941211df844107474
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
REPLAY=REPLAY_NOT_RUN
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
