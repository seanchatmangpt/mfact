# mfact overnight recipes — deterministic generation rail.
# Lean toolchain is invoked via the absolute elan shim (off $PATH by design).

# Merge pack fragments into the pack ontology, then render via ggen.
render:
    cat /Users/sac/praxis/packs/lean-math-pack/fragments/*.ttl > /Users/sac/praxis/packs/lean-math-pack/ontology.ttl
    cd /Users/sac/mfact && /Users/sac/praxis/target/debug/ggen sync run

# Full build: procint package, then the mfact package (AxiomAudit + mfact lib).
build:
    cd /Users/sac/mfact/procint && /Users/sac/.elan/bin/lake build
    cd /Users/sac/mfact/mfact && /Users/sac/.elan/bin/lake build AxiomAudit mfact

# Axiom audit of the procint package only.
audit:
    cd /Users/sac/mfact/procint && /Users/sac/.elan/bin/lake build AxiomAudit

# Regenerate the release manifest + gates from the TTL catalog.
manifest:
    python3 /Users/sac/mfact/scripts/build_manifest.py

# Certify the release: exit 0 iff all gates pass.
certify: build audit
    cd /Users/sac/mfact/mfact && ./.lake/build/bin/mfact certify /Users/sac/mfact/release/release-manifest.json /Users/sac/mfact/release/gates.json

# Standing Quadrature: close the TTL x Lean x Manifest x Process x Paper
# cross-product, render the artifacts, kernel-admit the witness.
# ggen renders. Lean admits. mfact certifies.
standing-quadrature:
    python3 /Users/sac/mfact/scripts/build_quadrature.py
    cd /Users/sac/mfact && /Users/sac/praxis/target/debug/ggen sync run > /dev/null
    cd /Users/sac/mfact/procint && /Users/sac/.elan/bin/lake build Quadrature
    @cat /Users/sac/mfact/release/quadrature.env

# Negative controls for the quadrature gate (must REFUSE on poisoned copies).
quadrature-negative-controls:
    bash /Users/sac/mfact/scripts/quadrature_negative_controls.sh

# Package the paper for arXiv (no submission).
arxiv-package:
    cd /Users/sac/mfact/paper && latexmk -pdf -interaction=nonstopmode main.tex > /dev/null && tar czf arxiv-submission.tar.gz -C /Users/sac/mfact README_REPRODUCIBILITY.md -C /Users/sac/mfact/paper main.tex main.bbl refs.bib release_macros.tex evaluation.tex quadrature.tex final_status.tex availability.tex conclusion.tex crown_jewel_status.tex
    @tar tzf /Users/sac/mfact/paper/arxiv-submission.tar.gz

# Print the standing report.
standing:
    @cat /Users/sac/mfact/STANDING.md

# The decisive lock: re-render every ledgered artifact from its declared
# sources and refuse on drift. An unreplayable edit cannot pass admission.
# Authority is the ledger (.mfact/artifacts.toml), not paths or headers.
regen-check:
    cat /Users/sac/praxis/packs/lean-math-pack/fragments/*.ttl > /Users/sac/praxis/packs/lean-math-pack/ontology.ttl
    python3 /Users/sac/mfact/scripts/build_quadrature.py > /dev/null
    rm -f /Users/sac/mfact/ggen.lock
    cd /Users/sac/mfact && /Users/sac/praxis/target/debug/ggen sync run > /dev/null
    python3 /Users/sac/mfact/scripts/build_ledger.py > /dev/null
    cd /Users/sac/mfact && git diff --exit-code -- $(grep '^path = ' /Users/sac/mfact/.mfact/artifacts.toml | cut -d'"' -f2 | grep -v 'standing.env\|artifacts.toml' | sort -u | tr '\n' ' ') || (echo "REFUSED: ARTIFACT_DRIFT_REFUSED — unreplayable edit or stale render detected above" && exit 1)
    @echo "regen-check: all ledgered artifacts reproducible from source"

# Correctness ladder: lake test drives the whole fixture surface; PROCINT_*
# standing keys are merged only from real exit codes, never asserted.
test:
    cd /Users/sac/mfact/procint && /Users/sac/.elan/bin/lake test
    cd /Users/sac/mfact/procint && /Users/sac/.elan/bin/lake build AxiomAudit Quadrature
    grep -v "^PROCINT_\|^WFNET_CROWN_EQUIVALENCE=" /Users/sac/mfact/release/standing.env > /tmp/se.$$ && mv /tmp/se.$$ /Users/sac/mfact/release/standing.env
    printf 'PROCINT_SEMANTIC_FIXTURES=PASS\nPROCINT_NEGATIVE_FIXTURES=PASS\nPROCINT_ORACLE_CASES=PASS\nPROCINT_AXIOM_AUDIT=PASS\nPROCINT_CROSS_SURFACE_CONFORMANCE=PASS\nWFNET_CROWN_EQUIVALENCE=STATED\n' >> /Users/sac/mfact/release/standing.env
    @echo "correctness ladder: PASS (keys merged into standing.env)"

# ── Agent cockpit (read-only diagnostics; nothing below dirties the tree) ──
# Agents actuate only through just recipes. status/next/trace/why/doctor are
# READ-ONLY; only check/release write the ephemeral .mfact/reports/latest.*.

status:
    @python3 /Users/sac/mfact/scripts/report.py status

next:
    @python3 /Users/sac/mfact/scripts/report.py next

doctor:
    @python3 /Users/sac/mfact/scripts/report.py doctor

trace target:
    @python3 /Users/sac/mfact/scripts/report.py trace {{target}}

why target:
    @python3 /Users/sac/mfact/scripts/report.py why {{target}}

# Full admission sweep; the only diagnostic allowed to write reports.
check:
    just regen-check
    just build
    just test
    just prose-lint
    @python3 /Users/sac/mfact/scripts/report.py status --write

# check → certify → paper packaging. External actuation stays with the user.
release:
    just check
    just certify
    just arxiv-package
    @python3 /Users/sac/mfact/scripts/report.py status --write

# Volatile standing claims must not appear in hand-authored prose.
prose-lint:
    @! grep -nE '(^|[^0-9])(145|318)([^0-9]|$)|a138ee84|CERTIFIED_RELEASE=PASS' /Users/sac/mfact/paper/main.tex || (echo "REFUSED: UNSUPPORTED_STANDING_CLAIM — volatile standing value in hand-authored prose" && exit 1)
    @echo "prose-lint: clean"
