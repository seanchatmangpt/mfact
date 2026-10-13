#!/usr/bin/env python3
"""praxis_graphlaw paper-fragment renderer.

Ticket 019, step 2 of the rslab normalization pair (see
rslab/scripts/collect_praxis_graphlaw.py for step 1, which must run first
and produce rslab/receipts/praxis_graphlaw_benchmark_receipt.toml).

Doctrine (rslab/README.md): a paper fragment generated from an rslab
receipt = A. This script renders that A: it reads ONLY the receipt (never
the raw files directly as a numbers source, though it re-hashes them to
catch drift) and emits a LaTeX table under rslab/paper_fragments/, ledgered
in .mfact/artifacts.toml. Every number in the fragment traces to a receipted
file hash; none is hand-typed.

The fragment reports EXTRACTED empirical evidence — test/benchmark counts
observed in one collection pass — never PROVEN or CERTIFIED language; rslab
is not a proof engine (see rslab/README.md doctrine block).

Fails closed if the receipt is missing, malformed, or any receipted raw file
hash no longer matches its on-disk content (ARTIFACT_DRIFT_REFUSED).
"""
import os, re, subprocess, sys

ROOT = os.environ.get('MFACT_ROOT',
                      os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
RECEIPT_PATH = os.path.join(ROOT, 'rslab/receipts/praxis_graphlaw_benchmark_receipt.toml')
OUT_FRAGMENT = os.path.join(ROOT, 'rslab/paper_fragments/praxis_graphlaw_evidence.tex')

TEST_RESULT_RE = re.compile(r'test result: ok\. (\d+) passed; (\d+) failed')
BENCH_LINE_RE = re.compile(r'^test \S+\s+\.\.\. bench:', re.M)       # bencher/libtest harness
DIVAN_LINE_RE = re.compile(r'^╰─ ', re.M)                            # divan harness
CRITERION_LINE_RE = re.compile(r'^\s*time:\s+\[', re.M)              # criterion harness
RUNNING_BENCH_RE = re.compile(r'Running benches/(\S+\.rs)')


def refuse(code, message):
    print(f'REFUSED: {code} — {message}', file=sys.stderr)
    sys.exit(1)


def b3_file(path):
    r = subprocess.run(['b3sum', '--no-names', path], capture_output=True)
    if r.returncode != 0:
        refuse('HASH_TOOL_FAILED', f'b3sum failed on {path}: {r.stderr.decode()}')
    return r.stdout.decode().strip()


def load_receipt():
    if not os.path.exists(RECEIPT_PATH):
        refuse('MISSING_RECEIPT',
               f'{RECEIPT_PATH} not found — run rslab/scripts/collect_praxis_graphlaw.py first')
    try:
        import tomllib
    except ModuleNotFoundError:
        refuse('MISSING_TOML_READER', 'Python >=3.11 (tomllib) is required')
    with open(RECEIPT_PATH, 'rb') as f:
        return tomllib.load(f)


def verify_no_drift(receipt):
    for entry in receipt.get('files', []):
        path = os.path.join(ROOT, entry['path'])
        if not os.path.exists(path):
            refuse('ARTIFACT_DRIFT_REFUSED', f'receipted raw file missing: {entry["path"]}')
        actual = b3_file(path)
        if actual != entry['hash']:
            refuse('ARTIFACT_DRIFT_REFUSED',
                   f'{entry["path"]} hash drift: receipt says {entry["hash"]}, on-disk is {actual}')


def count_tests(path):
    text = open(path).read()
    passed = sum(int(m.group(1)) for m in TEST_RESULT_RE.finditer(text))
    failed = sum(int(m.group(2)) for m in TEST_RESULT_RE.finditer(text))
    return passed, failed


def count_benches(path):
    text = open(path).read()
    measured = (len(BENCH_LINE_RE.findall(text)) + len(DIVAN_LINE_RE.findall(text))
                + len(CRITERION_LINE_RE.findall(text)))
    suites = sorted(set(RUNNING_BENCH_RE.findall(text)))
    return measured, suites


def escape_tex(s):
    return s.replace('_', r'\_').replace('&', r'\&').replace('#', r'\#')


def main():
    receipt = load_receipt()
    verify_no_drift(receipt)

    by_output = {os.path.basename(entry['path']): os.path.join(ROOT, entry['path'])
                 for entry in receipt.get('files', [])}

    test_rows = []
    for name in ('test_graphlaw.txt', 'test_e2e.txt'):
        if name not in by_output:
            refuse('MISSING_RECEIPT', f'receipt has no files[] entry for {name}')
        passed, failed = count_tests(by_output[name])
        test_rows.append((name, passed, failed))

    bench_rows = []
    for name in ('bench_graphlaw.txt', 'bench_root.txt'):
        if name not in by_output:
            refuse('MISSING_RECEIPT', f'receipt has no files[] entry for {name}')
        measured, suites = count_benches(by_output[name])
        bench_rows.append((name, measured, len(suites)))

    commands = receipt.get('commands', [])
    cmd_by_output = {c['outputFile']: c for c in commands if c.get('outputFile')}

    total_passed = sum(p for _, p, _ in test_rows)
    total_failed = sum(f for _, _, f in test_rows)
    total_measured = sum(m for _, m, _ in bench_rows)

    lines = [
        '% AUTO-RENDERED by rslab/scripts/render_paper_fragments.py — do not edit by hand.',
        '% Regenerate: python3 rslab/scripts/collect_praxis_graphlaw.py '
        '&& python3 rslab/scripts/render_paper_fragments.py',
        '% Source: rslab/receipts/praxis_graphlaw_benchmark_receipt.toml (EXTRACTED tier;',
        '% empirical evidence, not a Lean proof — see rslab/README.md doctrine).',
        '\\begin{table}[h!]',
        '\\centering',
        '\\begin{tabular}{lrrr}',
        '\\toprule',
        '\\textbf{Command} & \\textbf{Duration (s)} & \\textbf{Passed} & \\textbf{Failed} \\\\',
        '\\midrule',
    ]
    for name, passed, failed in test_rows:
        cmd = cmd_by_output.get(name, {})
        dur = cmd.get('durationSeconds')
        dur_s = f'{dur:.2f}' if isinstance(dur, (int, float)) else '?'
        lines.append(f'\\texttt{{{escape_tex(cmd.get("command", name))}}} & {dur_s} & {passed} & {failed} \\\\')
    lines += [
        '\\midrule',
        f'\\textbf{{Total}} & & \\textbf{{{total_passed}}} & \\textbf{{{total_failed}}} \\\\',
        '\\bottomrule',
        '\\end{tabular}',
        '\\caption{praxis-graphlaw conformance and end-to-end admission test counts, '
        'extracted from the Ticket~018 raw command output and receipted by '
        '\\texttt{rslab/scripts/collect\\_praxis\\_graphlaw.py} '
        '(commit \\texttt{' + escape_tex(receipt.get('praxis_commit', '')[:12]) + '}). '
        'EXTRACTED-tier empirical evidence, not a Lean proof obligation.}',
        '\\label{tab:rslab-tests}',
        '\\end{table}',
        '',
        '\\begin{table}[h!]',
        '\\centering',
        '\\begin{tabular}{lrr}',
        '\\toprule',
        '\\textbf{Command} & \\textbf{Duration (s)} & \\textbf{Benchmarks measured} \\\\',
        '\\midrule',
    ]
    for name, measured, n_suites in bench_rows:
        cmd = cmd_by_output.get(name, {})
        dur = cmd.get('durationSeconds')
        dur_s = f'{dur:.2f}' if isinstance(dur, (int, float)) else '?'
        lines.append(f'\\texttt{{{escape_tex(cmd.get("command", name))}}} '
                     f'({n_suites} bench file{"s" if n_suites != 1 else ""}) & {dur_s} & {measured} \\\\')
    lines += [
        '\\midrule',
        f'\\textbf{{Total}} & & \\textbf{{{total_measured}}} \\\\',
        '\\bottomrule',
        '\\end{tabular}',
        '\\caption{praxis-graphlaw benchmark suite coverage: per-benchmark output lines '
        'counted per harness (\\texttt{bencher}/libtest \\texttt{bench:} lines, '
        '\\texttt{criterion} \\texttt{time:} blocks, \\texttt{divan} leaf rows); '
        'per-harness timings are not directly comparable, see receipted caveats. '
        'Per-benchmark timing detail lives in the receipted raw output, not reproduced here.}',
        '\\label{tab:rslab-benches}',
        '\\end{table}',
        '',
    ]

    os.makedirs(os.path.dirname(OUT_FRAGMENT), exist_ok=True)
    open(OUT_FRAGMENT, 'w').write('\n'.join(lines))
    print(f'{os.path.relpath(OUT_FRAGMENT, ROOT)}: '
          f'{total_passed} tests passed / {total_failed} failed, '
          f'{total_measured} benchmarks measured')


if __name__ == '__main__':
    main()
