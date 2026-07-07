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
    cd /Users/sac/mfact/paper && latexmk -pdf -interaction=nonstopmode main.tex > /dev/null && tar czf arxiv-submission.tar.gz -C /Users/sac/mfact README_REPRODUCIBILITY.md -C /Users/sac/mfact/paper main.tex main.bbl refs.bib $(cd /Users/sac/mfact/paper && ls generated/*.tex)
    @tar tzf /Users/sac/mfact/paper/arxiv-submission.tar.gz

# Print the standing report.
standing:
    @cat /Users/sac/mfact/STANDING.md

# The decisive lock: regenerate everything from source and refuse on drift.
# Hand-edited generated output cannot pass admission.
regen-check:
    cat /Users/sac/praxis/packs/lean-math-pack/fragments/*.ttl > /Users/sac/praxis/packs/lean-math-pack/ontology.ttl
    python3 /Users/sac/mfact/scripts/build_quadrature.py > /dev/null
    rm -f /Users/sac/mfact/ggen.lock
    cd /Users/sac/mfact && /Users/sac/praxis/target/debug/ggen sync run > /dev/null
    cd /Users/sac/mfact && git diff --exit-code -- procint/ProcInt procint/AxiomAudit.lean procint/ProcInt.lean paper/generated || (echo "REFUSED: GENERATED_OUTPUT_DRIFT — hand edit or stale render detected above" && exit 1)
    @echo "regen-check: no generated drift"

# Volatile standing claims must not appear in hand-authored prose.
prose-lint:
    @! grep -nE '(^|[^0-9])(145|309)([^0-9]|$)|ff62f3e5|CERTIFIED_RELEASE=PASS' /Users/sac/mfact/paper/main.tex || (echo "REFUSED: UNSUPPORTED_STANDING_CLAIM — volatile standing value in hand-authored prose" && exit 1)
    @echo "prose-lint: clean"
