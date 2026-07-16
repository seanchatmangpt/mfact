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

-- 2. Supply a toy pipeline theory: the functors are explicit test witnesses,
-- not hidden global axioms.
def toyPipelineTheory : CompilerPipelineTheory where
  projectTtl := fun _ => toyTTLGraph
  interpolateTera := fun _ => toyTeraTemplate
  compileRust := fun _ => toyRustExecutable

-- 3. Prove that the cascade functors successfully preserve signatures.
def toyTunnel : MultiplicativeCascadeWindTunnel toyPipelineTheory where
  coords := toyCoords
  graph := toyPipelineTheory.projectTtl toyCoords
  template := toyPipelineTheory.interpolateTera (toyPipelineTheory.projectTtl toyCoords)
  exe := toyPipelineTheory.compileRust
    (toyPipelineTheory.interpolateTera (toyPipelineTheory.projectTtl toyCoords))
  ttlProjEq := rfl
  teraInterpEq := rfl
  rustCompEq := rfl

theorem cascade_signatures_preserve {T : CompilerPipelineTheory}
    (tunnel : MultiplicativeCascadeWindTunnel T) :
    tunnel.graph = T.projectTtl tunnel.coords ∧
    tunnel.template = T.interpolateTera tunnel.graph ∧
    tunnel.exe = T.compileRust tunnel.template := by
  exact ⟨tunnel.ttlProjEq, tunnel.teraInterpEq, tunnel.rustCompEq⟩

end ProcInt.MFW.Tests
