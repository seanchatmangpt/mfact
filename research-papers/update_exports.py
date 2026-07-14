import os

domains = [
    "ortac_plus",
    "floquet_photonic",
    "hyperdimensional_cognitive",
    "sound_borrow_checking",
    "smfdcca",
    "scalar_dissipation",
    "bio_signals",
    "revops_turbulence"
]

base_dir = "/Users/sac/mfact/research-papers"

for domain in domains:
    file_path = os.path.join(base_dir, domain, "Thermo.lean")
    if os.path.exists(file_path):
        with open(file_path, "r") as f:
            content = f.read()
        
        # Replace 'def energy' with '@[export lp_thermo_energy_domain]\ndef energy'
        target = "def energy ("
        replacement = f"@[export lp_thermo_energy_{domain}]\ndef energy ("
        
        if replacement not in content:
            new_content = content.replace(target, replacement)
            with open(file_path, "w") as f:
                f.write(new_content)
            print(f"Updated {file_path}")
        else:
            print(f"Already updated {file_path}")
    else:
        print(f"Not found: {file_path}")

