#!/usr/bin/env python3
import os
import sys
import json

# Ensure we run in the virtualenv with tomllib
try:
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
RESULTS_PATH = os.path.join(ROOT, 'rslab/experiments/praxis_graphlaw/processed/results.json')
OUT_DIR = os.path.join(ROOT, 'rslab/paper_fragments')

def tex_escape(s: str) -> str:
    return (s.replace('\\', r'\textbackslash{}')
             .replace('_', r'\_')
             .replace('&', r'\&')
             .replace('%', r'\%')
             .replace('#', r'\#')
             .replace('µ', r'$\mu$'))

def main():
    if not os.path.exists(RECEIPT_PATH) or not os.path.exists(RESULTS_PATH):
        print("RSLAB_EVIDENCE_MISSING")
        sys.exit(1)
        
    with open(RECEIPT_PATH, 'rb') as f:
        try:
            receipt = tomllib.load(f)
        except Exception as e:
            print(f"Failed to parse receipt TOML: {e}", file=sys.stderr)
            sys.exit(1)
            
    with open(RESULTS_PATH, 'r', encoding='utf-8') as f:
        try:
            results = json.load(f)
        except Exception as e:
            print(f"Failed to parse results JSON: {e}", file=sys.stderr)
            sys.exit(1)
            
    os.makedirs(OUT_DIR, exist_ok=True)
    
    # 1. Render rslab_praxis_graphlaw_summary.tex
    summary_path = os.path.join(OUT_DIR, 'rslab_praxis_graphlaw_summary.tex')
    
    # Extract headline metrics
    # test_transitive_rule
    trans_rule = results.get('bencher', {}).get('test_transitive_rule', {})
    trans_rule_val = trans_rule.get('value')
    trans_rule_unit = trans_rule.get('unit', 'ns')
    trans_rule_str = f"{trans_rule_val:,} {trans_rule_unit}" if trans_rule_val is not None else "N/A"
    
    # graphlaw_materialize_delta
    mat_delta = results.get('divan', {}).get('graphlaw_materialize_delta', {})
    mat_delta_mean = mat_delta.get('mean')
    mat_delta_unit = mat_delta.get('mean_unit', 'µs')
    mat_delta_str = f"{mat_delta_mean:.1f} {tex_escape(mat_delta_unit)}" if mat_delta_mean is not None else "N/A"
    
    # receipt_validate/1000
    rec_val = results.get('criterion', {}).get('receipt_validate/1000', {})
    rec_val_point = rec_val.get('point')
    rec_val_unit = rec_val.get('point_unit', 'ms')
    rec_val_str = f"{rec_val_point:.4f} {rec_val_unit}" if rec_val_point is not None else "N/A"
    
    summary_content = f"""% AUTO-RENDERED by rslab/scripts/render_paper_fragments.py — do not edit by hand.
This section summarizes the empirical benchmark evidence collected for the \\texttt{{praxis-graphlaw}} engine. The suite evaluates query performance, rule materialization latency, incremental delta processing, and cryptographic receipt validation. The headline metrics are presented in Table~\\ref{{tab:praxis_graphlaw_headline}}.

\\begin{{table}}[h!]
\\centering
\\begin{{tabular}}{{llr}}
\\toprule
\\textbf{{Benchmark Target}} & \\textbf{{Harness}} & \\textbf{{Measured Value}} \\\\
\\midrule
\\texttt{{test\\_transitive\\_rule}} & bencher & {trans_rule_str} \\\\
\\texttt{{graphlaw\\_materialize\\_delta}} (mean) & divan & {mat_delta_str} \\\\
\\texttt{{receipt\\_validate/1000}} (point) & criterion & {rec_val_str} \\\\
\\bottomrule
\\end{{tabular}}
\\caption{{Headline empirical metrics for the praxis-graphlaw release.}}
\\label{{tab:praxis_graphlaw_headline}}
\\end{{table}}
"""
    with open(summary_path, 'w', encoding='utf-8') as f:
        f.write(summary_content)
        
    # 2. Render rslab_praxis_graphlaw_benchmarks.tex
    benchmarks_path = os.path.join(OUT_DIR, 'rslab_praxis_graphlaw_benchmarks.tex')
    
    # Bencher table rows
    bencher_rows = []
    bencher_data = results.get('bencher', {})
    for name in sorted(bencher_data.keys()):
        val = bencher_data[name].get('value')
        unit = bencher_data[name].get('unit', 'ns')
        val_str = f"{val:,} {unit}" if val is not None else "N/A"
        bencher_rows.append(f"\\texttt{{{tex_escape(name)}}} & {val_str} \\\\")
        
    # Divan table rows
    divan_rows = []
    divan_data = results.get('divan', {})
    for name in sorted(divan_data.keys()):
        d = divan_data[name]
        fastest = f"{d.get('fastest'):.2f} {tex_escape(d.get('fastest_unit', 'ns'))}"
        slowest = f"{d.get('slowest'):.2f} {tex_escape(d.get('slowest_unit', 'ns'))}"
        median = f"{d.get('median'):.2f} {tex_escape(d.get('median_unit', 'ns'))}"
        mean = f"{d.get('mean'):.2f} {tex_escape(d.get('mean_unit', 'ns'))}"
        samples = str(d.get('samples'))
        divan_rows.append(f"\\texttt{{{tex_escape(name)}}} & {fastest} & {slowest} & {median} & {mean} & {samples} \\\\")
        
    # Criterion table rows
    criterion_rows = []
    criterion_data = results.get('criterion', {})
    for name in sorted(criterion_data.keys()):
        c = criterion_data[name]
        lower = f"{c.get('lower'):.4f} {tex_escape(c.get('lower_unit', 'ns'))}"
        point = f"{c.get('point'):.4f} {tex_escape(c.get('point_unit', 'ns'))}"
        upper = f"{c.get('upper'):.4f} {tex_escape(c.get('upper_unit', 'ns'))}"
        criterion_rows.append(f"\\texttt{{{tex_escape(name)}}} & {lower} & {point} & {upper} \\\\")
        
    benchmarks_content = f"""% AUTO-RENDERED by rslab/scripts/render_paper_fragments.py — do not edit by hand.
\\subsubsection{{Micro-Benchmarks (Bencher)}}
\\begin{{table}}[h!]
\\centering
\\small
\\begin{{tabular}}{{lr}}
\\toprule
\\textbf{{Benchmark Name}} & \\textbf{{Value}} \\\\
\\midrule
{chr(10).join(bencher_rows)}
\\bottomrule
\\end{{tabular}}
\\caption{{Bencher micro-benchmarks for praxis-graphlaw.}}
\\label{{tab:praxis_bencher}}
\\end{{table}}

\\subsubsection{{Crate-Level \\& Control-Layer Benchmarks (Divan)}}
\\begin{{table}}[h!]
\\centering
\\small
\\begin{{tabular}}{{lrrrrr}}
\\toprule
\\textbf{{Benchmark Name}} & \\textbf{{Fastest}} & \\textbf{{Slowest}} & \\textbf{{Median}} & \\textbf{{Mean}} & \\textbf{{Samples}} \\\\
\\midrule
{chr(10).join(divan_rows)}
\\bottomrule
\\end{{tabular}}
\\caption{{Divan micro-benchmarks for praxis-graphlaw.}}
\\label{{tab:praxis_divan}}
\\end{{table}}

\\subsubsection{{System-Level \\& Protocol Benchmarks (Criterion)}}
\\begin{{table}}[h!]
\\centering
\\small
\\begin{{tabular}}{{lrrr}}
\\toprule
\\textbf{{Benchmark Name}} & \\textbf{{Lower}} & \\textbf{{Point Estimate}} & \\textbf{{Upper}} \\\\
\\midrule
{chr(10).join(criterion_rows)}
\\bottomrule
\\end{{tabular}}
\\caption{{Criterion benchmark results for the release.}}
\\label{{tab:praxis_criterion}}
\\end{{table}}
"""
    with open(benchmarks_path, 'w', encoding='utf-8') as f:
        f.write(benchmarks_content)
        
    # 3. Render rslab_praxis_graphlaw_profiles.tex
    profiles_path = os.path.join(OUT_DIR, 'rslab_praxis_graphlaw_profiles.tex')
    profiles_content = """% AUTO-RENDERED by rslab/scripts/render_paper_fragments.py — do not edit by hand.
Profiling evidence was not collected because no profiler tooling exists in the praxis workspace as of this release.
"""
    with open(profiles_path, 'w', encoding='utf-8') as f:
        f.write(profiles_content)
        
    # 4. Render rslab_readiness.tex
    readiness_path = os.path.join(OUT_DIR, 'rslab_readiness.tex')
    readiness_content = """% AUTO-RENDERED by rslab/scripts/render_paper_fragments.py — do not edit by hand.
Throughput measured; latency percentiles not yet collected; profiling not yet available.
"""
    with open(readiness_path, 'w', encoding='utf-8') as f:
        f.write(readiness_content)
        
    print("Successfully rendered all four paper fragments in rslab/paper_fragments/")

if __name__ == '__main__':
    main()
