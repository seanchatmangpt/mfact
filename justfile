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
