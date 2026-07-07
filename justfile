# mfact overnight recipes — deterministic generation rail.
# Lean toolchain is invoked via the absolute elan shim (off $PATH by design).

default:
    @just status

# Bootstrap a fresh checkout: report toolchain presence, never force-install.
[group('setup')]
install:
    @if command -v elan >/dev/null 2>&1; then \
        echo "elan: OK ($(elan --version))"; \
    else \
        echo "elan: not found — install with: curl https://elan.dev/install.sh -sSf | sh"; \
    fi
    @if command -v ggen >/dev/null 2>&1; then \
        echo "ggen: OK ($(ggen --version))"; \
    else \
        echo "ggen: not found — from a praxis checkout (normally a sibling checkout, e.g. ../praxis), run: just install-ggen"; \
    fi
    @if command -v just >/dev/null 2>&1; then \
        echo "just: OK ($(just --version))"; \
    else \
        echo "just: not found — see https://github.com/casey/just for install instructions"; \
    fi
    @if command -v b3sum >/dev/null 2>&1; then \
        echo "b3sum: OK ($(b3sum --version))"; \
    else \
        echo "b3sum: not found — install the b3sum CLI (e.g. cargo install b3sum)"; \
    fi
    @if command -v latexmk >/dev/null 2>&1; then \
        echo "latexmk: OK ($(latexmk --version | head -1))"; \
    else \
        echo "latexmk: not found — install a TeX distribution providing latexmk"; \
    fi
    @echo "next: just doctor"

# Merge pack fragments into the pack ontology, then render every artifact via ggen.
[group('manufacture')]
render:
    cat packs/lean-math-pack/fragments/*.ttl > packs/lean-math-pack/ontology.ttl
    ggen sync run

# Full build: procint package, then the mfact package (AxiomAudit + mfact lib).
[group('manufacture')]
build:
    cd procint && /Users/sac/.elan/bin/lake build
    cd mfact && /Users/sac/.elan/bin/lake build AxiomAudit mfact

# Axiom audit of the procint package only.
[group('manufacture')]
audit:
    cd procint && /Users/sac/.elan/bin/lake build AxiomAudit

# Regenerate the release manifest + gates from the TTL catalog.
[group('manufacture')]
manifest:
    python3 scripts/build_manifest.py

# Regenerate paper/evaluation.tex's derived tables/foldHash mention from the
# release manifest (never hand-edit those numbers; see AGENTS.md).
eval-tex:
    python3 scripts/build_evaluation_tex.py

# Certify the release: exit 0 iff all gates pass.
[group('manufacture')]
certify: build audit
    cd mfact && ./.lake/build/bin/mfact certify ../release/release-manifest.json ../release/gates.json > ../release/certify.log 2> ../release/certify.stderr && cat ../release/certify.stderr >> ../release/certify.log && rm ../release/certify.stderr
    bash scripts/certify_negative_controls.sh >> release/certify.log 2>&1
    @grep "^certified:" release/certify.log

# Standing Quadrature: close the TTL x Lean x Manifest x Process x Paper cross-product and kernel-admit the witness.
[group('manufacture')]
standing-quadrature:
    python3 scripts/build_quadrature.py
    rm -f ggen.lock
    ggen sync run > /dev/null
    cd procint && /Users/sac/.elan/bin/lake build Quadrature
    @cat release/quadrature.env

# Hand-authored demo surface — never feeds standing, gates, or the manifest.
[group('demo')]
playground:
    cd procint && /Users/sac/.elan/bin/lake build Playground

# Hand-authored Python research surface — never feeds standing, gates, or the manifest.
[group('demo')]
pylab:
    cd pylab && uv run pytest

# Genetic tactic search over a Playground warm-up target — exploratory, off-ledger.
# See docs/genetic-tactic-search.md. Never writes to packs/*/fragments/*.ttl.
[group('demo')]
tactic-search target *args:
    cd procint && /Users/sac/.elan/bin/lake build Playground
    python3 scripts/genetic_tactic_search.py {{target}} {{args}}

# Negative controls for the quadrature gate (must REFUSE on poisoned copies).
[group('manufacture')]
quadrature-negative-controls:
    bash scripts/quadrature_negative_controls.sh

# Package the paper for arXiv (no submission).
[group('paper')]
arxiv-package:
    cd paper && latexmk -pdf -interaction=nonstopmode main.tex > /dev/null && COPYFILE_DISABLE=1 tar czf arxiv-submission.tar.gz -C .. README_REPRODUCIBILITY.md -C paper main.tex main.bbl refs.bib release_macros.tex evaluation.tex quadrature.tex final_status.tex availability.tex conclusion.tex crown_jewel_status.tex publication_status.tex replay_status.tex
    @tar tzf paper/arxiv-submission.tar.gz

# Print the standing report (STANDING.md).
[group('cockpit')]
standing:
    @cat STANDING.md

# The decisive lock: re-render every ledgered artifact from source and refuse on drift.
[group('release')]
regen-check:
    cat packs/lean-math-pack/fragments/*.ttl > packs/lean-math-pack/ontology.ttl
    python3 scripts/build_quadrature.py > /dev/null
    rm -f ggen.lock
    ggen sync run > /dev/null
    python3 scripts/build_ledger.py > /dev/null
    git diff --exit-code -- $(grep '^path = ' .mfact/artifacts.toml | cut -d'"' -f2 | grep -v 'standing.env\|artifacts.toml' | sort -u | tr '\n' ' ') || (echo "REFUSED: ARTIFACT_DRIFT_REFUSED — unreplayable edit or stale render detected above" && exit 1)
    @echo "regen-check: all ledgered artifacts reproducible from source"

# Correctness ladder: lake test drives the whole fixture surface; PROCINT_* keys merge only from real exit codes.
[group('manufacture')]
test:
    cd procint && /Users/sac/.elan/bin/lake test
    cd procint && /Users/sac/.elan/bin/lake build AxiomAudit Quadrature
    grep -v "^PROCINT_\|^WFNET_CROWN_EQUIVALENCE=" release/standing.env > /tmp/se.$$ && mv /tmp/se.$$ release/standing.env
    printf 'PROCINT_SEMANTIC_FIXTURES=PASS\nPROCINT_NEGATIVE_FIXTURES=PASS\nPROCINT_ORACLE_CASES=PASS\nPROCINT_AXIOM_AUDIT=PASS\nPROCINT_CROSS_SURFACE_CONFORMANCE=PASS\nWFNET_CROWN_EQUIVALENCE=STATED\n' >> release/standing.env
    @echo "correctness ladder: PASS (keys merged into standing.env)"

# ── Agent cockpit (read-only diagnostics; nothing below dirties the tree) ──
# Agents actuate only through just recipes. status/next/trace/why/doctor are
# READ-ONLY; only check/release write the ephemeral .mfact/reports/latest.*.

# One-screen standing summary: core release, gates, quadrature, correctness ladder.
[group('cockpit')]
status:
    @python3 scripts/report.py status

# What to run next, derived from the first non-passing gate/lane found.
[group('cockpit')]
next:
    @python3 scripts/report.py next

# Health check: required tools on PATH, toolchain pins, pack sources, tag gate.
[group('cockpit')]
doctor:
    @python3 scripts/report.py doctor

# Provenance of one ledgered artifact: producer, sources, content hash, receipt.
[group('cockpit')]
trace target:
    @python3 scripts/report.py trace {{target}}

# Explain why an artifact or quadrature claim exists and what it's computed from.
[group('cockpit')]
why target:
    @python3 scripts/report.py why {{target}}

# Correctness-ladder theorem counts: proven/stated/total from the manifest.
[group('cockpit')]
theorem-status:
    @python3 scripts/report.py theorem-status

# Crown research lane ladder — projected from the rendered obligations (STATED never promoted).
[group('cockpit')]
proof-blockers:
    @cat research/wfnet/obligations.toml

# Correctness-ladder standing (exit-code-backed PROCINT_* keys) from standing.env.
[group('cockpit')]
fixtures:
    @grep "^PROCINT_\|^WFNET_CROWN_EQUIVALENCE=" release/standing.env

# Alias: quadrature-negative-controls.
[group('manufacture')]
negative: quadrature-negative-controls
# Alias: standing-quadrature.
[group('manufacture')]
quadrature: standing-quadrature

# Rebuild the paper PDF (paper/main.pdf).
[group('paper')]
paper:
    cd paper && latexmk -pdf -interaction=nonstopmode main.tex > /dev/null
    @echo "paper: main.pdf rebuilt"

# Lint hand-authored prose for volatile standing claims, then rebuild the paper.
[group('paper')]
paper-check: prose-lint paper

# Write the ephemeral cockpit report (.mfact/reports/latest.*) — the only diagnostic allowed to.
[group('cockpit')]
report-write:
    @python3 scripts/report.py write

# Full admission sweep: regen-check, build, test, paper-check, then write the report.
[group('release')]
check:
    just regen-check
    just build
    just test
    just paper-check
    @python3 scripts/report.py status --write
    @echo "CHECK=PASS"
    @echo "NEXT=just release"

# check → certify → publication packet → paper packaging. External actuation stays with the user.
[group('release')]
release:
    just check
    just certify
    just manufacture-post-release
    just arxiv-package
    @python3 scripts/report.py status --write
    @echo "release/FINAL_STATUS.md"
    @grep -m1 "^CORE_RELEASE=" release/FINAL_STATUS.md || true

# Post-release publication packet: builder reads downstream receipts, ggen renders, Lean admits, ledger records.
[group('manufacture')]
manufacture-post-release:
    python3 scripts/build_post_release.py
    rm -f ggen.lock
    ggen sync run > /dev/null
    cd procint && /Users/sac/.elan/bin/lake build PostRelease
    python3 scripts/build_ledger.py > /dev/null
    grep -v "^POST_RELEASE_PACKET\|^PUBLICATION_ACTUATION=\|^ARXIV_PACKET=\|^GITHUB_PUSH_PACKET=\|^GITHUB_RELEASE_PACKET=\|^INDEPENDENT_REPLAY=\|^NEXT_DOMAIN_FOUNDRY=" release/standing.env > /tmp/se.$$ && mv /tmp/se.$$ release/standing.env
    python3 -c "import json; d=json.load(open('release/final_status.json')); p={x['id']:x['status'] for x in d['publicationPacket']['packets']}; print('POST_RELEASE_PACKET_HASH='+d['publicationPacket']['packetHash']); print('PUBLICATION_ACTUATION='+d['publicationPacket']['publicationActuation']); print('ARXIV_PACKET='+p['arxiv_upload']); print('GITHUB_PUSH_PACKET='+p['github_push']); print('GITHUB_RELEASE_PACKET='+p['github_release']); print('INDEPENDENT_REPLAY='+d['auxiliaryLanes']['replay']); print('NEXT_DOMAIN_FOUNDRY='+d['auxiliaryLanes']['nextDomainFoundry'])" >> release/standing.env
    @cat release/FINAL_STATUS.md

# Independent replay gate: clone the stand-in at the release tag into a scratch tree and re-run there.
[group('release')]
independent-replay:
    bash scripts/independent_replay.sh

# doc-gen4 lane: build HTML API docs (multi-hour; never blocks the release).
[group('paper')]
docs:
    bash scripts/build_docs.sh

# Serve the built doc-gen4 site locally (run `just docs` first if it hasn't been built).
[group('paper')]
docs-serve port="8000":
    @test -f procint/docbuild/.lake/build/doc/index.html || (echo "REFUSED: no doc-gen4 build found — run 'just docs' first" && exit 1)
    @echo "serving http://localhost:{{port}}/index.html  (Ctrl-C to stop)"
    cd procint/docbuild/.lake/build/doc && python3 -m http.server {{port}}

# Honest docs standing from the lane's own report, never asserted.
[group('paper')]
docs-check:
    @python3 -c "import json; d=json.load(open('release/docs_report.json')); print('LEAN_HTML_DOCS='+d['LEAN_HTML_DOCS']); print(d['detail'])" 2>/dev/null || echo "LEAN_HTML_DOCS=PLANNED (no report yet — run 'just docs')"

# Refuse volatile standing claims (proven counts, hashes) hand-typed into paper prose.
[group('paper')]
prose-lint:
    @! grep -nE '(^|[^0-9])(145|318)([^0-9]|$)|e25724e8|CERTIFIED_RELEASE=PASS' paper/main.tex || (echo "REFUSED: UNSUPPORTED_STANDING_CLAIM — volatile standing value in hand-authored prose" && exit 1)
    @echo "prose-lint: clean"
