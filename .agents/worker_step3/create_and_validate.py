import os
import subprocess
import json
import tomllib
from jsonschema import validate

# Setup paths
MFACT_DIR = "/Users/sac/mfact"
PRAXIS_DIR = "/Users/sac/praxis"
RAW_OUT_DIR = os.path.join(MFACT_DIR, "rslab/experiments/praxis_graphlaw/raw")
RECEIPT_PATH = os.path.join(MFACT_DIR, "rslab/receipts/praxis_graphlaw_benchmark_receipt.toml")
SCHEMA_PATH = os.path.join(MFACT_DIR, "rslab/schemas/benchmark_result.schema.json")

def b3(filepath):
    # Compute BLAKE3 using b3sum
    res = subprocess.run(["b3sum", "--no-names", filepath], capture_output=True, text=True, check=True)
    return res.stdout.strip()

# Compute hashes for all 6 files
raw_files = [
    "bench_graphlaw.txt",
    "bench_root.txt",
    "test_graphlaw.txt",
    "test_e2e.txt",
    "toolchain_context.txt"
]

files_list = []
for filename in raw_files:
    filepath = os.path.join(RAW_OUT_DIR, filename)
    file_hash = b3(filepath)
    rel_path = f"rslab/experiments/praxis_graphlaw/raw/{filename}"
    files_list.append({
        "path": rel_path,
        "hash": file_hash
    })

command_log_path = os.path.join(RAW_OUT_DIR, "command_log.txt")
command_log_hash = b3(command_log_path)
command_log_rel_path = "rslab/experiments/praxis_graphlaw/raw/command_log.txt"

# Get git commit hash from /Users/sac/praxis
praxis_commit = subprocess.run(["git", "rev-parse", "HEAD"], cwd=PRAXIS_DIR, capture_output=True, text=True, check=True).stdout.strip()

# Retrieve rustc version and uname
rustc_ver = subprocess.run(["rustc", "--version"], cwd=PRAXIS_DIR, capture_output=True, text=True, check=True).stdout.strip()
uname_a = subprocess.run(["uname", "-a"], capture_output=True, text=True, check=True).stdout.strip()

# Check if declared
manifest_path = os.path.join(MFACT_DIR, "rslab/manifest.toml")
is_declared = False
if os.path.exists(manifest_path):
    with open(manifest_path, "rb") as mf:
        manifest_data = tomllib.load(mf)
        for exp in manifest_data.get("experiments", []):
            if exp.get("id") == "praxis_graphlaw":
                is_declared = True
                break

# Check if extracted
is_extracted = len(files_list) > 0 and all(os.path.exists(os.path.join(MFACT_DIR, f["path"])) for f in files_list)

# Build receipt TOML content (NO wall-clock timestamp)
receipt_data = {
    "builder": "ticket_018",
    "experiment_id": "praxis_graphlaw",
    "praxis_commit": praxis_commit,
    "command_log_path": command_log_rel_path,
    "command_log_hash": command_log_hash,
    "files": files_list,
    "toolchain": {
        "rustc_version": rustc_ver,
        "toolchain_pin": "nightly-2026-04-15",
        "os": uname_a
    },
    "evidence": {
        "declared": is_declared,
        "extracted": is_extracted
    },
    "caveats": [
        "Harness Diversity: The workspace uses multiple distinct benchmark frameworks (bencher, divan, criterion) simultaneously; comparison of raw performance metrics across these harnesses is not directly supported.",
        "No Profiling/Flamegraph Tooling: As of this exploration, no profiling or flamegraph tooling exists in the /Users/sac/praxis workspace. The profiler_result.schema.json is provided for future extensions and is currently unpopulated.",
        "Terminology on Admission Control: 'Transaction-path admission control' is not an existing named class or interface inside the praxis codebase. The nearest structural representations are SHACL/ShEx admission gates and the POWL admission context (bcinr_powl::admit::{admit, AdmissionContext}). Any paper language referring to 'transaction-path admission control' must frame it as a future design objective rather than an implemented feature.",
        "Warnings: Compile profile warning (non-root package profiles ignored, panic setting ignored for bench profile) and unused code or missing docs warnings in ggen lib."
    ]
}

# Write TOML manually
def format_toml(d):
    lines = []
    lines.append(f'builder = "{d["builder"]}"')
    lines.append(f'experiment_id = "{d["experiment_id"]}"')
    lines.append(f'praxis_commit = "{d["praxis_commit"]}"')
    lines.append(f'command_log_path = "{d["command_log_path"]}"')
    lines.append(f'command_log_hash = "{d["command_log_hash"]}"')
    lines.append("")
    lines.append("caveats = [")
    for cav in d["caveats"]:
        lines.append(f'    "{cav}",')
    lines.append("]")
    lines.append("")
    lines.append("[toolchain]")
    lines.append(f'rustc_version = "{d["toolchain"]["rustc_version"]}"')
    lines.append(f'toolchain_pin = "{d["toolchain"]["toolchain_pin"]}"')
    lines.append(f'os = "{d["toolchain"]["os"]}"')
    lines.append("")
    lines.append("[evidence]")
    lines.append(f'declared = {str(d["evidence"]["declared"]).lower()}')
    lines.append(f'extracted = {str(d["evidence"]["extracted"]).lower()}')
    lines.append("")
    lines.append("[[files]]")
    for i, file_obj in enumerate(d["files"]):
        if i > 0:
            lines.append("")
            lines.append("[[files]]")
        lines.append(f'path = "{file_obj["path"]}"')
        lines.append(f'hash = "{file_obj["hash"]}"')
    return "\n".join(lines)

toml_content = format_toml(receipt_data)
with open(RECEIPT_PATH, "w") as f:
    f.write(toml_content)
print(f"Receipt written to {RECEIPT_PATH}")

# Validate using JSON Schema
with open(RECEIPT_PATH, "rb") as f:
    parsed_toml = tomllib.load(f)

with open(SCHEMA_PATH, "r") as f:
    schema = json.load(f)

# Validate
validate(instance=parsed_toml, schema=schema)
print("Validation passed successfully!")
