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

-- 4. Witness pair for the complexity bounding constraint.

/-- Coordinates whose multiplicative depth exceeds the time budget (12 > 10). -/
def deepCoords : ComplexityCoordinates := {
  time := 10
  space := 5
  multiplicativeDepth := 12
}

/-- A wind tunnel over `deepCoords`: structurally valid, but its complexity bound fails. -/
def deepTunnel : MultiplicativeCascadeWindTunnel toyPipelineTheory where
  coords := deepCoords
  graph := toyPipelineTheory.projectTtl deepCoords
  template := toyPipelineTheory.interpolateTera (toyPipelineTheory.projectTtl deepCoords)
  exe := toyPipelineTheory.compileRust
    (toyPipelineTheory.interpolateTera (toyPipelineTheory.projectTtl deepCoords))
  ttlProjEq := rfl
  teraInterpEq := rfl
  rustCompEq := rfl

-- Witness pair: statement-adequacy check — `windTunnelComplexityBound` accepts `toyTunnel`
-- (multiplicative depth 3 ≤ time 10) and provably rejects `deepTunnel`
-- (multiplicative depth 12 > time 10).
example : windTunnelComplexityBound toyTunnel := by
  unfold windTunnelComplexityBound
  decide

example : ¬ windTunnelComplexityBound deepTunnel := by
  unfold windTunnelComplexityBound
  decide

end ProcInt.MFW.Tests
