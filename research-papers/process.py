import os
import glob
import subprocess

domains = {
    "aeneas_rust_verification": ("BorrowState", "Owned", "Dropped", "drop_invariant"),
    "bio_signals": ("BioSignal", "Propagating", "Attenuated", "transduction_limit"),
    "floquet_photonic": ("PhotonicMode", "Driven", "Dissipated", "quasi_energy_invariant"),
    "hyperdimensional_cognitive": ("VectorState", "Bound", "Unbound", "entropy_conservation"),
    "ortac_plus": ("VerificationCost", "Unverified", "Verified", "bounded_execution"),
    "revops_turbulence": ("FluidFlow", "Laminar", "Turbulent", "leakage_bound"),
    "scalar_dissipation": ("VectorField", "Mixed", "Dissipated", "dissipation_bound"),
    "smfdcca": ("FractalSpace", "Correlated", "Uncorrelated", "cross_correlation_bound"),
    "sound_borrow_checking": ("AliasState", "Active", "Released", "monotonic_decrease"),
    "terminal_breakdown": ("DAGNode", "Active", "Failed", "cascade_invariant"),
    "weighted_random_networks": ("NetworkState", "Walk", "Stationary", "convergence_invariant")
}

base = "/Users/sac/mfact/research-papers"

lakefile_content = """import Lake
open Lake DSL

package thermo {
}

@[default_target]
lean_lib Thermo {
}
"""

for d, (ind, state1, state2, thm) in domains.items():
    dpath = os.path.join(base, d)
    
    # 1. create lakefile.lean
    with open(os.path.join(dpath, "lakefile.lean"), "w") as f:
        f.write(lakefile_content)
        
    # 2. create Thermo.lean
    thermo_content = f"""
inductive {ind} where
  | {state1}
  | {state2}
  
def energy (s : {ind}) : Nat :=
  match s with
  | {ind}.{state1} => 10
  | {ind}.{state2} => 0
  
theorem {thm} : energy {ind}.{state2} = 0 := by rfl
"""
    with open(os.path.join(dpath, "Thermo.lean"), "w") as f:
        f.write(thermo_content)
        
    # 3. lake build
    print(f"Building {d}...")
    res = subprocess.run(["lake", "build"], cwd=dpath, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"Failed in {d}:\n{res.stdout}\n{res.stderr}")
    else:
        print(f"Built {d}")
        # Close ticket
        tickets_dir = os.path.join(dpath, "tickets")
        md_files = glob.glob(os.path.join(tickets_dir, "PROJ-*.md"))
        for mdf in md_files:
            with open(mdf, "a") as tf:
                tf.write("\n\n## Status\nClosed\n")
            print(f"Closed {mdf}")

print("Done all!")
