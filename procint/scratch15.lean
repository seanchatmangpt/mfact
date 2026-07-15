namespace ProcInt.MFW

structure TTLGraph deriving Inhabited
structure TeraTemplate deriving Inhabited
structure RustExecutable deriving Inhabited

structure ComplexityCoordinates where
  time : Nat
  space : Nat
  multiplicative_depth : Nat
deriving Inhabited

opaque project_ttl : ComplexityCoordinates → TTLGraph
opaque interpolate_tera : TTLGraph → TeraTemplate
opaque compile_rust : TeraTemplate → RustExecutable

structure MultiplicativeCascadeWindTunnel where
  coords : ComplexityCoordinates
  graph : TTLGraph
  template : TeraTemplate
  exe : RustExecutable
  ttl_proj_eq : graph = project_ttl coords
  tera_interp_eq : template = interpolate_tera graph
  rust_comp_eq : exe = compile_rust template

def cascade_complexity_bound (tunnel : MultiplicativeCascadeWindTunnel) : Prop :=
  tunnel.coords.multiplicative_depth ≤ tunnel.coords.time

end ProcInt.MFW
