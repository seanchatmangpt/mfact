import ProcInt.MFW.CompilerPipeline

namespace ProcInt.MFW.Tests

-- 1. Define toy instances of TTLGraph and TeraTemplate.
def toyTTLGraph : TTLGraph := {}
def toyTeraTemplate : TeraTemplate := {}
def toyRustExecutable : RustExecutable := {}

def toyCoords : ComplexityCoordinates := {
  time := 10
  space := 5
  multiplicativeDepth := 3
}

-- 2. Prove that the cascade functors successfully preserve signatures.
def toyTunnel : MultiplicativeCascadeWindTunnel where
  coords := toyCoords
  graph := projectTtl toyCoords
  template := interpolateTera (projectTtl toyCoords)
  exe := compileRust (interpolateTera (projectTtl toyCoords))
  ttlProjEq := rfl
  teraInterpEq := rfl
  rustCompEq := rfl

theorem cascade_signatures_preserve (tunnel : MultiplicativeCascadeWindTunnel) :
    tunnel.graph = projectTtl tunnel.coords ∧
    tunnel.template = interpolateTera tunnel.graph ∧
    tunnel.exe = compileRust tunnel.template := by
  exact ⟨tunnel.ttlProjEq, tunnel.teraInterpEq, tunnel.rustCompEq⟩

end ProcInt.MFW.Tests
