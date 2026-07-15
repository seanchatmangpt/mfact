import ProcInt.MFW.CompilerPipeline

namespace ProcInt.MFW.Tests

-- 1. Define toy instances of TTLGraph and TeraTemplate.
def toyTTLGraph : TTLGraph := {}
def toyTeraTemplate : TeraTemplate := {}
def toyRustExecutable : RustExecutable := {}

def toyCoords : ComplexityCoordinates := {
  time := 10
  space := 5
  multiplicative_depth := 3
}

-- 2. Prove that the cascade functors successfully preserve signatures.
def toyTunnel : MultiplicativeCascadeWindTunnel where
  coords := toyCoords
  graph := project_ttl toyCoords
  template := interpolate_tera (project_ttl toyCoords)
  exe := compile_rust (interpolate_tera (project_ttl toyCoords))
  ttl_proj_eq := rfl
  tera_interp_eq := rfl
  rust_comp_eq := rfl

theorem cascade_signatures_preserve (tunnel : MultiplicativeCascadeWindTunnel) :
    tunnel.graph = project_ttl tunnel.coords ∧
    tunnel.template = interpolate_tera tunnel.graph ∧
    tunnel.exe = compile_rust tunnel.template := by
  exact ⟨tunnel.ttl_proj_eq, tunnel.tera_interp_eq, tunnel.rust_comp_eq⟩

end ProcInt.MFW.Tests
