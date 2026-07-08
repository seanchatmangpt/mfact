#!/usr/bin/env python3
import os
import sys
import subprocess
import json
import re

# Ensure we run in the virtualenv with jsonschema and tomllib
try:
    import jsonschema
    import tomllib
except ImportError:
    # Try to re-execute with pylab/.venv/bin/python3
    root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    venv_python = os.path.join(root, 'pylab', '.venv', 'bin', 'python3')
    if os.path.exists(venv_python) and sys.executable != venv_python:
        os.execv(venv_python, [venv_python] + sys.argv)
    else:
        raise

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RECEIPT_PATH = os.path.join(ROOT, 'rslab/receipts/praxis_graphlaw_benchmark_receipt.toml')
SCHEMA_PATH = os.path.join(ROOT, 'rslab/schemas/benchmark_result.schema.json')
PROCESSED_DIR = os.path.join(ROOT, 'rslab/experiments/praxis_graphlaw/processed')
RESULTS_PATH = os.path.join(PROCESSED_DIR, 'results.json')

def verify_blake3(file_rel_path, expected_hash):
    abs_path = os.path.join(ROOT, file_rel_path)
    if not os.path.exists(abs_path):
        return False
    try:
        res = subprocess.run(['b3sum', '--no-names', abs_path], capture_output=True, text=True, check=True)
        return res.stdout.strip() == expected_hash
    except Exception:
        return False

def main():
    if not os.path.exists(RECEIPT_PATH):
        print("RSLAB_EVIDENCE_MISSING")
        sys.exit(1)
        
    # Read receipt
    with open(RECEIPT_PATH, 'rb') as f:
        try:
            receipt = tomllib.load(f)
        except Exception as e:
            print(f"Failed to parse receipt TOML: {e}", file=sys.stderr)
            sys.exit(1)
            
    # Validate receipt against schema
    if not os.path.exists(SCHEMA_PATH):
        print(f"Schema not found at {SCHEMA_PATH}", file=sys.stderr)
        sys.exit(1)
        
    with open(SCHEMA_PATH, 'r', encoding='utf-8') as f:
        schema = json.load(f)
        
    try:
        jsonschema.validate(instance=receipt, schema=schema)
    except jsonschema.exceptions.ValidationError as e:
        print(f"Receipt validation failed: {e}", file=sys.stderr)
        sys.exit(1)
        
    # Verify hashes
    files = receipt.get('files', [])
    for f_info in files:
        path = f_info.get('path')
        h = f_info.get('hash')
        if not verify_blake3(path, h):
            print("RSLAB_HASH_MISMATCH")
            sys.exit(1)
            
    # Parse metrics dynamically
    raw_dir = os.path.join(ROOT, 'rslab/experiments/praxis_graphlaw/raw')
    bench_graphlaw_path = os.path.join(raw_dir, 'bench_graphlaw.txt')
    bench_root_path = os.path.join(raw_dir, 'bench_root.txt')
    test_graphlaw_path = os.path.join(raw_dir, 'test_graphlaw.txt')
    test_e2e_path = os.path.join(raw_dir, 'test_e2e.txt')
    
    # 1. Parse bencher times from bench_graphlaw.txt
    bencher_metrics = {}
    if os.path.exists(bench_graphlaw_path):
        with open(bench_graphlaw_path, 'r', encoding='utf-8') as f:
            content = f.read()
        for match in re.finditer(r"test\s+(\w+)\s+\.\.\.\s+bench:\s+([\d,]+)\s+ns/iter", content):
            name = match.group(1)
            val = int(match.group(2).replace(',', ''))
            bencher_metrics[name] = {"value": val, "unit": "ns"}
            
    # 2. Parse divan times from bench_graphlaw.txt and bench_root.txt
    divan_metrics = {}
    divan_pattern = re.compile(
        r"(?:├─|╰─|│)\s*(\w+)\s+([\d.]+)\s*(\w+)\s*│\s*([\d.]+)\s*(\w+)\s*│\s*([\d.]+)\s*(\w+)\s*│\s*([\d.]+)\s*(\w+)\s*│\s*(\d+)\s*│\s*(\d+)"
    )
    
    if os.path.exists(bench_graphlaw_path):
        with open(bench_graphlaw_path, 'r', encoding='utf-8') as f:
            content = f.read()
        for match in divan_pattern.finditer(content):
            name = match.group(1)
            divan_metrics[name] = {
                "fastest": float(match.group(2)),
                "fastest_unit": match.group(3),
                "slowest": float(match.group(4)),
                "slowest_unit": match.group(5),
                "median": float(match.group(6)),
                "median_unit": match.group(7),
                "mean": float(match.group(8)),
                "mean_unit": match.group(9),
                "samples": int(match.group(10)),
                "iters": int(match.group(11))
            }
            
    if os.path.exists(bench_root_path):
        with open(bench_root_path, 'r', encoding='utf-8') as f:
            content = f.read()
        for match in divan_pattern.finditer(content):
            name = match.group(1)
            divan_metrics[name] = {
                "fastest": float(match.group(2)),
                "fastest_unit": match.group(3),
                "slowest": float(match.group(4)),
                "slowest_unit": match.group(5),
                "median": float(match.group(6)),
                "median_unit": match.group(7),
                "mean": float(match.group(8)),
                "mean_unit": match.group(9),
                "samples": int(match.group(10)),
                "iters": int(match.group(11))
            }
            
    # 3. Parse criterion times from bench_root.txt
    criterion_metrics = {}
    if os.path.exists(bench_root_path):
        with open(bench_root_path, 'r', encoding='utf-8') as f:
            content = f.read()
        current_bench = None
        for line in content.splitlines():
            bench_match = re.search(r"Benchmarking\s+(\S+)", line)
            if bench_match:
                current_bench = bench_match.group(1)
            time_match = re.search(r"(\S+)?\s*time:\s+\[([\d.]+)\s*(\w+)\s+([\d.]+)\s*(\w+)\s+([\d.]+)\s*(\w+)\]", line)
            if time_match:
                name = time_match.group(1) or current_bench
                if name:
                    criterion_metrics[name] = {
                        "lower": float(time_match.group(2)),
                        "lower_unit": time_match.group(3),
                        "point": float(time_match.group(4)),
                        "point_unit": time_match.group(5),
                        "upper": float(time_match.group(6)),
                        "upper_unit": time_match.group(7)
                    }
                    
    # 4. Parse test outcomes from test_graphlaw.txt and test_e2e.txt
    def parse_test_summary(filepath):
        passed = 0
        failed = 0
        ignored = 0
        if os.path.exists(filepath):
            with open(filepath, 'r', encoding='utf-8') as f:
                for line in f:
                    match = re.search(r"test result: \w+\.\s+(\d+)\s+passed;\s+(\d+)\s+failed;\s+(\d+)\s+ignored", line)
                    if match:
                        passed += int(match.group(1))
                        failed += int(match.group(2))
                        ignored += int(match.group(3))
        return {"passed": passed, "failed": failed, "ignored": ignored}

    test_outcomes = {
        "praxis_graphlaw": parse_test_summary(test_graphlaw_path),
        "e2e": parse_test_summary(test_e2e_path)
    }
    
    # Save results to processed/results.json
    results = {
        "bencher": bencher_metrics,
        "divan": divan_metrics,
        "criterion": criterion_metrics,
        "tests": test_outcomes
    }
    
    os.makedirs(PROCESSED_DIR, exist_ok=True)
    with open(RESULTS_PATH, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2, sort_keys=True)
        
    print(f"Successfully collected praxis_graphlaw benchmarks to {RESULTS_PATH}")

if __name__ == '__main__':
    main()
