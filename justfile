# mfact overnight recipes — deterministic generation rail.
# Lean toolchain is invoked via the absolute elan shim (off $PATH by design).

default:
    @just status

# Serialize all `lake build`/`lake test` invocations across recipes so two
# overlapping `just` runs (e.g. `release` + `tactic-search` in another shell)
# never race the same .lake/build directory and spawn duplicate lean procs.
# Lock is an atomic mkdir (portable, no flock dependency); stale locks from a
# killed process are reclaimed automatically once the holder pid is gone.
[group('internal')]
_lake +cmd:
    #!/usr/bin/env bash
    set -euo pipefail
    lockdir=/tmp/mfact-lake.lock
    while ! mkdir "$lockdir" 2>/dev/null; do
        holder=$(cat "$lockdir/pid" 2>/dev/null || echo "?")
        if [ -n "$holder" ] && [ "$holder" != "?" ] && ! kill -0 "$holder" 2>/dev/null; then
            echo "reclaiming stale lake lock (pid $holder gone)"
            rm -rf "$lockdir"
            continue
        fi
        echo "waiting for lake lock (held by pid $holder)..."
        sleep 2
    done
    trap 'rm -rf "$lockdir"' EXIT
    echo $$ > "$lockdir/pid"
    {{cmd}}

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
    rm -f ggen.lock
    ggen sync run

# Full build: procint package, then the mfact package (AxiomAudit + mfact lib).
[group('manufacture')]
build:
    just _lake "cd procint && /Users/sac/.elan/bin/lake build"
    just _lake "cd mfact && /Users/sac/.elan/bin/lake build AxiomAudit mfact"

# Axiom audit of the procint package only.
[group('manufacture')]
audit:
    just _lake "cd procint && /Users/sac/.elan/bin/lake build AxiomAudit"

# Regenerate the release manifest + gates from the TTL catalog.
[group('manufacture')]
manifest:
    python3 scripts/build_manifest.py

# Regenerate paper/evaluation.tex's derived tables/foldHash mention from the
# release manifest (never hand-edit those numbers; see AGENTS.md).
eval-tex:
    python3 scripts/build_evaluation_tex.py

# rslab normalization pair: receipt the praxis-graphlaw raw evidence (Ticket
# 018), then render the paper fragments that cite it. Also invoked inline by
# regen-check so the ledger's producer field is covered there directly.
[group('manufacture')]
rslab-fragments:
    python3 rslab/scripts/collect_praxis_graphlaw.py
    python3 rslab/scripts/render_paper_fragments.py

# Certify the release: exit 0 iff all gates pass.
[group('manufacture')]
certify: build audit
    cd mfact && ./.lake/build/bin/mfact certify ../release/release-manifest.json ../release/gates.json > ../release/certify.log 2> ../release/certify.stderr && cat ../release/certify.stderr >> ../release/certify.log && rm ../release/certify.stderr
    bash scripts/certify_negative_controls.sh >> release/certify.log 2>&1
    bash scripts/countermodel_negative_controls.sh >> release/certify.log 2>&1
    @grep "^certified:" release/certify.log

# Standing Quadrature: close the TTL x Lean x Manifest x Process x Paper cross-product and kernel-admit the witness.
[group('manufacture')]
standing-quadrature:
    python3 scripts/build_quadrature.py
    rm -f ggen.lock
    ggen sync run > /dev/null
    just _lake "cd procint && /Users/sac/.elan/bin/lake build Quadrature"
    @cat release/quadrature.env

# Hand-authored demo surface — never feeds standing, gates, or the manifest.
[group('demo')]
playground:
    just _lake "cd procint && /Users/sac/.elan/bin/lake build Playground"

# Hand-authored Python research surface — never feeds standing, gates, or the manifest.
[group('demo')]
pylab:
    cd pylab && uv run pytest

# Genetic tactic search over a Playground warm-up target — exploratory, off-ledger.
# See docs/genetic-tactic-search.md. Never writes to packs/*/fragments/*.ttl.
[group('demo')]
tactic-search target *args:
    just _lake "cd procint && /Users/sac/.elan/bin/lake build Playground"
    python3 scripts/genetic_tactic_search.py {{target}} {{args}}

# Negative controls for the quadrature gate (must REFUSE on poisoned copies).
[group('manufacture')]
quadrature-negative-controls:
    bash scripts/quadrature_negative_controls.sh

# Package the paper for arXiv (no submission).
[group('paper')]
arxiv-package:
    cd paper && TEXINPUTS=../rslab/paper_fragments: latexmk -pdf -interaction=nonstopmode main.tex > /dev/null && COPYFILE_DISABLE=1 tar czf arxiv-submission.tar.gz -C .. README_REPRODUCIBILITY.md -C paper main.tex main.bbl refs.bib release_macros.tex evaluation.tex quadrature.tex final_status.tex availability.tex conclusion.tex crown_jewel_status.tex publication_status.tex replay_status.tex -C ../rslab/paper_fragments praxis_graphlaw_evidence.tex
    @tar tzf paper/arxiv-submission.tar.gz

# Print the standing report (STANDING.md).
[group('cockpit')]
standing:
    @cat STANDING.md

# The decisive lock: re-render every ledgered artifact from source and refuse on drift.
[group('release')]
regen-check:
    python3 scripts/build_verif.py > /dev/null
    cat packs/lean-math-pack/fragments/*.ttl > packs/lean-math-pack/ontology.ttl
    python3 scripts/build_quadrature.py > /dev/null
    rm -f ggen.lock
    ggen sync run > /dev/null
    python3 rslab/scripts/collect_praxis_graphlaw.py > /dev/null
    python3 rslab/scripts/render_paper_fragments.py > /dev/null
    python3 scripts/build_ledger.py > /dev/null
    git diff --exit-code -- $(grep '^path = ' .mfact/artifacts.toml | cut -d'"' -f2 | grep -v 'standing.env\|artifacts.toml' | sort -u | tr '\n' ' ') || (echo "REFUSED: ARTIFACT_DRIFT_REFUSED — unreplayable edit or stale render detected above" && exit 1)
    @echo "regen-check: all ledgered artifacts reproducible from source"

# Correctness ladder: lake test drives the whole fixture surface; PROCINT_* keys merge only from real exit codes.
[group('manufacture')]
test:
    just _lake "cd procint && /Users/sac/.elan/bin/lake test"
    just _lake "cd procint && /Users/sac/.elan/bin/lake build AxiomAudit Quadrature"
    bash -c "set -e; grep -vE '^PROCINT_|^WFNET_CROWN_EQUIVALENCE=|^WFNET_INFINITE_TRANSITION_COUNTERMODEL=' release/standing.env > /tmp/se.$$ && mv /tmp/se.$$ release/standing.env; CROWN_STATUS=\$(python3 -c \"import json; d=json.load(open('release/release-manifest.json')); [print('PROVEN' if a.get('proven') else 'STATED') or exit(0) for a in d['artifacts'] if a.get('name') == 'ProcInt.WfNet.sound_iff_shortCircuit_live_bounded']; print('STATED')\" 2>/dev/null || echo 'STATED'); CM_STATUS=\$(python3 -c \"import json; d=json.load(open('release/release-manifest.json')); [print('PROVEN' if a.get('proven') else 'STATED') or exit(0) for a in d['artifacts'] if a.get('name') == 'ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded']; print('STATED')\" 2>/dev/null || echo 'STATED'); printf 'PROCINT_SEMANTIC_FIXTURES=PASS\nPROCINT_NEGATIVE_FIXTURES=PASS\nPROCINT_ORACLE_CASES=PASS\nPROCINT_AXIOM_AUDIT=PASS\nPROCINT_CROSS_SURFACE_CONFORMANCE=PASS\nWFNET_CROWN_EQUIVALENCE='\$CROWN_STATUS'\nWFNET_INFINITE_TRANSITION_COUNTERMODEL='\$CM_STATUS'\n' >> release/standing.env"
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

# ── Correspondence factory (D1, Steps 3-8) ──────────────────────────────────
# wasm4pm-compat is a sibling repo (../wasm4pm-compat); actuation for its
# extraction pipeline is still fronted here so agents never call raw
# charon/aeneas/lake commands directly. See docs/HONEST_D1_STATEMENT.md and
# packs/lean-math-pack/fragments/verif.ttl for obligation D1.

WASM4PM_COMPAT := "../wasm4pm-compat"

# Build/ensure the pinned charon+aeneas extraction toolchain at
# .verif-toolchain/bin/ (durable, gitignored, mfact-local, idempotent — skips
# rebuild if already present and pinned correctly). Lives here, not in
# wasm4pm-compat, which stays a clean source-only publishable crate. Never
# depend on a /tmp scratchpad for this.
[group('verif')]
verif-toolchain:
    bash scripts/verif_build_toolchain.sh

# Step 3-A: charon extraction of the D1 perimeter (conformance_counts.rs).
[group('verif')]
verif-extract: verif-toolchain
    bash {{WASM4PM_COMPAT}}/verify/scripts/run_charon_d1.sh

# Step 3-B: aeneas Lean codegen from the Step 3-A LLBC output.
[group('verif')]
verif-codegen: verif-toolchain
    bash {{WASM4PM_COMPAT}}/verify/scripts/run_aeneas_d1.sh

# Step 3 full pipeline: toolchain → extract → codegen → receipts/pipeline.json.
[group('verif')]
verif-pipeline: verif-extract verif-codegen
    bash scripts/verif_assemble_pipeline.sh

# Step 4: build the wasm4pm-compat verify/lean Lake package (Generated + Abs + Corr).
[group('verif')]
verif-lake-build:
    just _lake "cd {{WASM4PM_COMPAT}}/verify/lean && /Users/sac/.elan/bin/lake build"

# Step 5: negative controls (mfact-side refusal checks) + materialize
# (copy mfact dist/verif/ into wasm4pm-compat/verify/lean/, hash-checked).
[group('verif')]
verif-negative-controls:
    bash scripts/verif_negative_controls.sh

[group('verif')]
verif-materialize:
    bash scripts/verif_materialize.sh

# Step 6: rerun the builder now that pipeline.json exists, then rerender.
[group('verif')]
verif-status:
    python3 scripts/build_verif.py
    just render
    just regen-check

# Rebuild the paper PDF (paper/main.pdf).
[group('paper')]
paper:
    cd paper && TEXINPUTS=../rslab/paper_fragments: latexmk -pdf -interaction=nonstopmode main.tex > /dev/null
    @echo "paper: main.pdf rebuilt"

# Lint hand-authored prose for volatile standing claims, then rebuild the paper.
[group('paper')]
paper-check: prose-lint paper

# Rebuild the thesis-length monograph (thesis/thesis.pdf). Hand-authored
# narrative under thesis/, never ggen-rendered or ledgered; reuses the
# paper's own generated fragments and bibliography by relative \input.
[group('paper')]
thesis:
    cd thesis && latexmk -pdf -interaction=nonstopmode thesis.tex > /dev/null
    @echo "thesis: thesis.pdf rebuilt"

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
    uv run python scripts/build_post_release.py --plan
    rm -f ggen.lock
    ggen sync run > /dev/null
    just _lake "cd procint && /Users/sac/.elan/bin/lake build PostRelease"
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
    @! grep -nE 'Aeneas[[:space:]]+(proves|verified|checked|certified)' paper/main.tex || (echo "REFUSED: UNSUPPORTED_STANDING_CLAIM — 'Aeneas proves/verified/checked/certified' claims extraction where only extraction happened; say 'Aeneas extracts' and 'Lean proves'" && exit 1)
    @echo "prose-lint: clean"

[group('git')]
commit message:
    git add -A
    git commit -m "{{message}}"

[group('git')]
recut-tag name:
    git tag -d {{name}} || true
    git tag {{name}}

[group('git')]
push:
    git push && git push --tags
