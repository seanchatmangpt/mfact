import os
import glob

base_dir = "/Users/sac/mfact/research-papers"
domains = []

for entry in os.scandir(base_dir):
    if entry.is_dir() and not entry.name.startswith(('.', '_')):
        tickets_dir = os.path.join(entry.path, "tickets")
        if os.path.exists(tickets_dir):
            md_files = glob.glob(os.path.join(tickets_dir, "PROJ-*.md"))
            if md_files:
                domains.append((entry.name, entry.path, md_files[0]))

for d_name, d_path, t_path in domains:
    print(f"--- Domain: {d_name} ---")
    with open(t_path, "r") as f:
        print(f.read().strip())
    print("\n")
