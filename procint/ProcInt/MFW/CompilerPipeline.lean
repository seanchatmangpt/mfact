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

-- Multiplicative Cascade Wind Tunnel (Parts XXXVI, XXXVII of Notation Authority)
structure MultiplicativeCascadeWindTunnel where
  coords : ComplexityCoordinates
  graph : TTLGraph
  template : TeraTemplate
  exe : RustExecutable
  ttl_proj_eq : graph = project_ttl coords
  tera_interp_eq : template = interpolate_tera graph
  rust_comp_eq : exe = compile_rust template

def wind_tunnel_complexity_bound (tunnel : MultiplicativeCascadeWindTunnel) : Prop :=
  tunnel.coords.multiplicative_depth ≤ tunnel.coords.time

end ProcInt.MFW
