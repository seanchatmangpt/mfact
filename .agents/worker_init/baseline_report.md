# Baseline Report

Captured on: 2026-07-07T16:46:14-07:00
Current Git Commit / Tag Context:
- Core Release Tag: `v26.7.7-procint-certified` @ `6f4c370`
- Rendered Commit: `350cb1d`

## `just status` Output

```
core release      v26.7.7  (tag v26.7.7-procint-certified @ 6f4c370, rendered from 350cb1d, ancestor check FAIL)
core identity     foldHash 942facf32d48cd1a…  decls 397  proven 202  stated 2
gates             sorryFree=PASS  axiomsClean=PASS  fixturesPass=PASS  evidenceComplete=PASS
quadrature        FAIL  (orphans 5)
tree              DIRTY   ledgered artifacts 87
correctness       SEMANTIC_FIXTURES=PASS  NEGATIVE_FIXTURES=PASS  ORACLE_CASES=PASS  AXIOM_AUDIT=PASS  CROSS_SURFACE_CONFORMANCE=PASS
non-PASS          VALID_OBJECTION=UNINHABITED
non-PASS          PUBLICATION_ACTUATION=PENDING_EXTERNAL_ACTUATION
non-PASS          ARXIV_PACKET=UNVERIFIED
non-PASS          GITHUB_PUSH_PACKET=UNVERIFIED
non-PASS          GITHUB_RELEASE_PACKET=UNVERIFIED
non-PASS          INDEPENDENT_REPLAY=REPLAY_PASS
non-PASS          NEXT_DOMAIN_FOUNDRY=PLANNED
non-PASS          WFNET_CROWN_EQUIVALENCE=STATED
```

## `just doctor` Output

```
OK     lake (elan shim)  /Users/sac/.elan/bin/lake
OK     b3sum  /opt/homebrew/bin/b3sum
OK     latexmk  /Library/TeX/texbin/latexmk
OK     just  /Users/sac/.cargo/bin/just
OK     ggen  /Users/sac/.cargo/bin/ggen  (ggen 26.7.4)
OK     procint/lean-toolchain  pinned=leanprover/lean4:v4.31.0
OK     mfact/lean-toolchain  pinned=leanprover/lean4:v4.31.0
OK     release/release-manifest.json
OK     release/gates.json
OK     release/standing.env
OK     release/quadrature.json
OK     .mfact/artifacts.toml
OK     .ggen-v2/receipt.json
FAIL   tag gate: v26.7.7-procint-certified @ 6f4c370 descends from rendered commit 350cb1d
OK     gate sorryFree
OK     gate axiomsClean
OK     gate fixturesPass
OK     gate evidenceComplete
--- pack sources ---
OK     pack  /Users/sac/mfact/packs/lean-math-pack
OK     pack  /Users/sac/mfact/packs/quadrature-pack
OK     pack  /Users/sac/mfact/packs/post-release-pack
OK     ggen.lock  /Users/sac/mfact/ggen.lock
OK     CLAUDE.md is @AGENTS.md import: '@AGENTS.md'
```
