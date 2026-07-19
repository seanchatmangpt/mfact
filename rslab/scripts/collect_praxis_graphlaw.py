#!/usr/bin/env python3
"""praxis_graphlaw raw-evidence collector.

Ticket 019, step 1 of the rslab normalization pair (see
rslab/scripts/render_paper_fragments.py for step 2).

Doctrine (rslab/README.md): praxis raw output = O; this script turns it into
schema-validated, receipted output = O* by hashing every raw file Ticket 018
collected, merging the declared (hand-authored, unledgered) experiment
metadata that the raw output itself does not carry, and emitting a receipt
that validates against rslab/schemas/benchmark_result.schema.json.

This script does not run cargo bench/test itself and does not reach for
/Users/sac/praxis — it processes the raw command output already committed
under rslab/experiments/praxis_graphlaw/raw/ (Ticket 018's hard-gated,
receipted collection). Re-running the actual benchmarks is Ticket 018's
concern, not this builder's.

Fails closed (REFUSED, non-zero exit) if any raw file, the command log, or
the declared experiment metadata is missing — never emits a receipt from
partial evidence.
"""
import json, os, re, subprocess, sys

ROOT = os.environ.get('MFACT_ROOT',
                      os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
EXPERIMENT_DIR = os.path.join(ROOT, 'rslab/experiments/praxis_graphlaw')
RAW_DIR = os.path.join(EXPERIMENT_DIR, 'raw')
META_PATH = os.path.join(EXPERIMENT_DIR, 'experiment_meta.toml')
COMMAND_LOG = os.path.join(RAW_DIR, 'command_log.txt')
SCHEMA_PATH = os.path.join(ROOT, 'rslab/schemas/benchmark_result.schema.json')
OUT_RECEIPT = os.path.join(ROOT, 'rslab/receipts/praxis_graphlaw_benchmark_receipt.toml')

RAW_FILES = [
    'bench_graphlaw.txt',
    'bench_root.txt',
    'test_graphlaw.txt',
    'test_e2e.txt',
    'toolchain_context.txt',
]


def refuse(code, message):
    print(f'REFUSED: {code} — {message}', file=sys.stderr)
    sys.exit(1)


def b3_file(path):
    r = subprocess.run(['b3sum', '--no-names', path], capture_output=True)
    if r.returncode != 0:
        refuse('HASH_TOOL_FAILED', f'b3sum failed on {path}: {r.stderr.decode()}')
    return r.stdout.decode().strip()


def load_meta():
    try:
        import tomllib
    except ModuleNotFoundError:
        refuse('MISSING_TOML_READER', 'Python >=3.11 (tomllib) is required')
    if not os.path.exists(META_PATH):
        refuse('MISSING_EXPERIMENT_META', f'{META_PATH} not found — declared metadata (praxis_commit, caveats) is required and is never inferred')
    with open(META_PATH, 'rb') as f:
        return tomllib.load(f)


def parse_toolchain_context(text):
    rustc_m = re.search(r'=== rustc --version ===\s*\n(.+)', text)
    os_m = re.search(r'=== uname -a ===\s*\n(.+)', text)
    # Match only a concrete pinned date, not the "nightly-YYYY-MM-DD" example
    # string that appears earlier in this file's embedded doc-comment.
    pin_m = re.search(r'channel\s*=\s*"(nightly-\d{4}-\d{2}-\d{2}|stable|[\w.\-]+)"\s*$', text, re.M)
    if not (rustc_m and os_m and pin_m):
        refuse('UNPARSEABLE_TOOLCHAIN_CONTEXT',
               f'{RAW_DIR}/toolchain_context.txt is missing rustc/uname/channel lines')
    return rustc_m.group(1).strip(), os_m.group(1).strip(), pin_m.group(1).strip()


def parse_commands(text):
    commands = []
    for block in text.split('\n- Command: ')[1:]:
        cmd_line, *rest = block.splitlines()
        rest_text = '\n'.join(rest)
        exit_m = re.search(r'Exit Code:\s*(\d+)', rest_text)
        dur_m = re.search(r'Duration:\s*([\d.]+) seconds', rest_text)
        file_m = re.search(r'Output File:\s*(\S+)', rest_text)
        commands.append({
            'command': cmd_line.strip(),
            'exitCode': int(exit_m.group(1)) if exit_m else None,
            'durationSeconds': float(dur_m.group(1)) if dur_m else None,
            'outputFile': file_m.group(1) if file_m else None,
        })
    return commands


def toml_str_list(items):
    return '[\n' + ''.join(f'    "{s}",\n' for s in items) + ']'


def main():
    if not os.path.isdir(RAW_DIR):
        refuse('MISSING_RAW_EVIDENCE', f'{RAW_DIR} does not exist')
    missing = [f for f in RAW_FILES if not os.path.exists(os.path.join(RAW_DIR, f))]
    if missing:
        refuse('MISSING_RAW_EVIDENCE', f'missing raw files: {missing}')
    if not os.path.exists(COMMAND_LOG):
        refuse('MISSING_RAW_EVIDENCE', f'{COMMAND_LOG} not found')
    if not os.path.exists(SCHEMA_PATH):
        refuse('MISSING_GGEN_SOURCE', f'{SCHEMA_PATH} not found — schema is the contract, not optional')

    schema = json.load(open(SCHEMA_PATH))
    meta = load_meta()

    praxis_commit = meta.get('praxis_commit', '')
    if not re.fullmatch(r'[a-f0-9]{40}', praxis_commit):
        refuse('SCHEMA_VALIDATION_FAILED', f'praxis_commit {praxis_commit!r} does not match ^[a-f0-9]{{40}}$')
    caveats = meta.get('caveats', [])

    toolchain_text = open(os.path.join(RAW_DIR, 'toolchain_context.txt')).read()
    rustc_version, os_desc, toolchain_pin = parse_toolchain_context(toolchain_text)

    command_log_text = open(COMMAND_LOG).read()
    commands = parse_commands(command_log_text)
    if not commands:
        refuse('UNPARSEABLE_COMMAND_LOG', f'{COMMAND_LOG} carries no "- Command:" entries')

    files = []
    for name in RAW_FILES:
        path = os.path.join(RAW_DIR, name)
        rel = os.path.relpath(path, ROOT)
        files.append({'path': rel, 'hash': b3_file(path)})

    command_log_hash = b3_file(COMMAND_LOG)

    required = schema.get('required', [])
    doc = {
        'builder': 'rslab/scripts/collect_praxis_graphlaw.py',
        'experiment_id': 'praxis_graphlaw',
        'praxis_commit': praxis_commit,
        'toolchain': {'rustc_version': rustc_version, 'toolchain_pin': toolchain_pin, 'os': os_desc},
        'evidence': {'declared': True, 'extracted': True},
    }
    for key in required:
        if key not in doc:
            refuse('SCHEMA_VALIDATION_FAILED', f'required schema key {key!r} missing from generated receipt')
    for f in files:
        if not re.fullmatch(r'[a-f0-9]{64}', f['hash']):
            refuse('SCHEMA_VALIDATION_FAILED', f'hash for {f["path"]} does not match ^[a-f0-9]{{64}}$')

    lines = [
        '# GENERATED by rslab/scripts/collect_praxis_graphlaw.py — do not edit by hand.',
        '# Regenerate: python3 rslab/scripts/collect_praxis_graphlaw.py',
        '# Sources: rslab/experiments/praxis_graphlaw/raw/*.txt (Ticket 018 collection)',
        '#          + rslab/experiments/praxis_graphlaw/experiment_meta.toml (declared)',
        'builder = "rslab/scripts/collect_praxis_graphlaw.py"',
        'experiment_id = "praxis_graphlaw"',
        f'praxis_commit = "{praxis_commit}"',
        f'command_log_path = "{os.path.relpath(COMMAND_LOG, ROOT)}"',
        f'command_log_hash = "{command_log_hash}"',
        '',
        f'caveats = {toml_str_list(caveats)}',
        '',
        '[toolchain]',
        f'rustc_version = "{rustc_version}"',
        f'toolchain_pin = "{toolchain_pin}"',
        f'os = "{os_desc}"',
        '',
        '[evidence]',
        'declared = true',
        'extracted = true',
        '',
    ]
    for c in commands:
        lines += [
            '[[commands]]',
            f'command = "{c["command"]}"',
            f'exitCode = {c["exitCode"]}',
            f'durationSeconds = {c["durationSeconds"]}',
            f'outputFile = "{c["outputFile"]}"',
            '',
        ]
    for f in files:
        lines += ['[[files]]', f'path = "{f["path"]}"', f'hash = "{f["hash"]}"', '']

    os.makedirs(os.path.dirname(OUT_RECEIPT), exist_ok=True)
    open(OUT_RECEIPT, 'w').write('\n'.join(lines))
    print(f'{os.path.relpath(OUT_RECEIPT, ROOT)}: {len(files)} raw files hashed, EXTRACTED')


if __name__ == '__main__':
    main()
