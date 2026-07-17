namespace ProcInt.MFW

/-- Abstract target representing Turtle (TTL) semantic graphs. -/
structure TTLGraph deriving Inhabited

/-- Abstract target representing Tera code generation templates. -/
structure TeraTemplate deriving Inhabited

/-- Abstract target representing the final Rust executable artifact. -/
structure RustExecutable deriving Inhabited

/-- [Notation Authority §37] Complexity Coordinates across the compilation chain. -/
structure ComplexityCoordinates where
  time : Nat
  space : Nat
  multiplicativeDepth : Nat
deriving Inhabited

/-- Theory record bundling the compilation-chain functors as explicit hypotheses.
    Replaces three prior bodyless `opaque` declarations (hidden global axioms):
    every consumer must now supply concrete functors as visible data. -/
structure CompilerPipelineTheory where
  /-- Functor projecting complexity coordinates to a TTL graph. -/
  projectTtl : ComplexityCoordinates → TTLGraph
  /-- Functor interpolating a TTL graph into a Tera template. -/
  interpolateTera : TTLGraph → TeraTemplate
  /-- Functor compiling a Tera template to a Rust executable. -/
  compileRust : TeraTemplate → RustExecutable

/-- [Notation Authority §36] The Multiplicative Cascade Wind Tunnel.
    Captures the deterministic translation logic mapping specifications to code,
    relative to an explicit pipeline theory `T`. -/
structure MultiplicativeCascadeWindTunnel (T : CompilerPipelineTheory) where
  coords : ComplexityCoordinates
  graph : TTLGraph
  template : TeraTemplate
  exe : RustExecutable
  ttlProjEq : graph = T.projectTtl coords
  teraInterpEq : template = T.interpolateTera graph
  rustCompEq : exe = T.compileRust template

/-- [Notation Authority §36] Complexity bounding constraint of the wind tunnel. -/
def windTunnelComplexityBound {T : CompilerPipelineTheory}
    (tunnel : MultiplicativeCascadeWindTunnel T) : Prop :=
  tunnel.coords.multiplicativeDepth ≤ tunnel.coords.time

end ProcInt.MFW
