import subprocess
import os
import time

PRAXIS_DIR = "/Users/sac/praxis"
MFACT_DIR = "/Users/sac/mfact"
RAW_OUT_DIR = os.path.join(MFACT_DIR, "rslab/experiments/praxis_graphlaw/raw")
RECEIPT_DIR = os.path.join(MFACT_DIR, "rslab/receipts")

os.makedirs(RAW_OUT_DIR, exist_ok=True)
os.makedirs(RECEIPT_DIR, exist_ok=True)

# 1. Run commands and capture outputs
commands = {
    "bench_graphlaw.txt": ["cargo", "bench", "-p", "praxis-graphlaw"],
    "bench_root.txt": ["cargo", "bench"],
    "test_graphlaw.txt": ["cargo", "test", "-p", "praxis-graphlaw"],
    "test_e2e.txt": ["cargo", "test", "-p", "ggen", "--test", "graphlaw_e2e"]
}

command_log_entries = []

# Toolchain context
print("Capturing toolchain context...")
rustc_ver = subprocess.run(["rustc", "--version"], cwd=PRAXIS_DIR, capture_output=True, text=True).stdout.strip()
rust_toolchain = ""
with open(os.path.join(PRAXIS_DIR, "rust-toolchain.toml"), "r") as f:
    rust_toolchain = f.read()
uname_a = subprocess.run(["uname", "-a"], capture_output=True, text=True).stdout.strip()

toolchain_context_content = f"=== rustc --version ===\n{rustc_ver}\n\n=== cat rust-toolchain.toml ===\n{rust_toolchain}\n\n=== uname -a ===\n{uname_a}\n"
toolchain_context_path = os.path.join(RAW_OUT_DIR, "toolchain_context.txt")
with open(toolchain_context_path, "w") as f:
    f.write(toolchain_context_content)

print("Toolchain context written.")

for filename, args in commands.items():
    print(f"Running {' '.join(args)}...")
    start_time = time.time()
    
    # We combine stdout and stderr
    result = subprocess.run(args, cwd=PRAXIS_DIR, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    
    end_time = time.time()
    duration = end_time - start_time
    exit_code = result.returncode
    
    output_path = os.path.join(RAW_OUT_DIR, filename)
    with open(output_path, "w") as f:
        f.write(result.stdout)
        
    print(f"Finished {filename} with exit code {exit_code} in {duration:.2f} seconds.")
    
    command_log_entries.append({
        "command": " ".join(args),
        "exit_code": exit_code,
        "duration_seconds": duration,
        "output_file": filename
    })

# Write command log
command_log_content = "Command Log:\n"
for entry in command_log_entries:
    command_log_content += f"\n- Command: {entry['command']}\n  Exit Code: {entry['exit_code']}\n  Duration: {entry['duration_seconds']:.2f} seconds\n  Output File: {entry['output_file']}\n"
    
command_log_path = os.path.join(RAW_OUT_DIR, "command_log.txt")
with open(command_log_path, "w") as f:
    f.write(command_log_content)
    
print("Command log written.")
