#!/usr/bin/env python3
"""Correspondence-factory status builder.

Derives verif:status for each verif:CorrespondenceObligation in
packs/lean-math-pack/fragments/verif.ttl from OBSERVED evidence only — never
asserted. Emits:

  1. packs/lean-math-pack/fragments/verif-status.generated.ttl — a builder-
     owned fragment supplying ONLY the verif:status triple per obligation
     (same subject IRI as fragments/verif.ttl, which deliberately does not
     assert verif:status itself). This is the fragment `just render`
     consumes alongside the hand-authored fragments.
  2. release/verif-receipt.json — source hashes (pinned, not live-diffed),
     toolchain versions, per-obligation statuses, and the evidence each
     status rested on. No wall clock.

Status ladder (no rung may be skipped, no silent promotion):
  DECLARED  — always true if the obligation exists in the catalog.
  EXTRACTED — wasm4pm-compat/verify/receipts/pipeline.json exists (charon +
              aeneas ran, exit 0, hashes pinned there).
  STATED    — requires EXTRACTED. The rendered Corr/{corrName}.lean exists
              AND `lake build` of the verify/lean package succeeds (the
              statement elaborates, sorry body permitted).
  PROVEN    — requires STATED. `lake env lean` axiom-print on the specific
              declaration reports no sorryAx.

This script is READ-ONLY with respect to wasm4pm-compat and procint; it only
writes into mfact (the generated fragment + the receipt).
"""
import json, os, re, subprocess, sys
from typing import Any, Dict

ROOT = os.getenv('MFACT_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
VERIF_TTL = os.getenv('VERIF_TTL', os.path.join(ROOT, 'packs/lean-math-pack/fragments/verif.ttl'))
OUT_FRAGMENT = os.getenv('OUT_FRAGMENT', os.path.join(ROOT, 'packs/lean-math-pack/fragments/verif-status.generated.ttl'))
OUT_RECEIPT = os.getenv('OUT_RECEIPT', os.path.join(ROOT, 'release/verif-receipt.json'))

WASM4PM_COMPAT = os.getenv('WASM4PM_COMPAT', '/Users/sac/wasm4pm-compat')
PIPELINE_JSON = os.getenv('PIPELINE_JSON', os.path.join(WASM4PM_COMPAT, 'verify/receipts/pipeline.json'))
LEAN_PKG_DIR = os.getenv('LEAN_PKG_DIR', os.path.join(WASM4PM_COMPAT, 'verify/lean'))
LAKE = os.getenv('LAKE', '/Users/sac/.elan/bin/lake')
CORRESPONDENCE_STATUS_TEX = os.getenv('CORRESPONDENCE_STATUS_TEX', os.path.join(ROOT, 'paper/correspondence_status.tex'))


def b3(data: bytes) -> str:
    return subprocess.run(['b3sum', '--no-names'], input=data,
                          capture_output=True, check=True).stdout.decode().strip()


def b3_file(path):
    return b3(open(path, 'rb').read()) if os.path.exists(path) else None


def parse_obligations(ttl_text):
    """Extract obligation records from the hand-authored verif.ttl by regex
    (mirrors build_post_release.py's decl_status pattern — the ontology is
    the source of truth, not a hand-maintained python list)."""
    obligations = []
    # Split on subject blocks: "verif:Obl_<name> a verif:CorrespondenceObligation ; ... ."
    for block in re.split(r'\n\n(?=verif:Obl_)', ttl_text):
        if 'verif:CorrespondenceObligation' not in block:
            continue
        def field(pred):
            m = re.search(r'verif:' + pred + r'\s+"((?:[^"\\]|\\.)*)"', block)
            return m.group(1) if m else None
        def field_int(pred):
            m = re.search(r'verif:' + pred + r'\s+(\d+)', block)
            return int(m.group(1)) if m else None
        subj_m = re.match(r'(verif:Obl_\S+)', block)
        rec = {
            'subject': subj_m.group(1) if subj_m else None,
            'corrOrder': field_int('corrOrder'),
            'corrName': field('corrName'),
            'rustSymbol': field('rustSymbol'),
            'rustFile': field('rustFile'),
            'leanDecl': field('leanDecl'),
            'aeneasModule': field('aeneasModule'),
            'aeneasDecl': field('aeneasDecl'),
        }
        if rec['corrName']:
            obligations.append(rec)
    return obligations


def lake_build_ok(pkg_dir):
    if not os.path.exists(os.path.join(pkg_dir, 'lakefile.toml')) and \
       not os.path.exists(os.path.join(pkg_dir, 'lakefile.lean')):
        return False, 'no lakefile in verify/lean yet'
    if not os.path.exists(LAKE):
        return False, f'lake binary not found at {LAKE}'
    r = subprocess.run([LAKE, 'build'], cwd=pkg_dir, capture_output=True)
    detail = (r.stdout.decode() + r.stderr.decode())[-2000:]
    detail = re.sub(r'\[\d+/\d+\]', '[XX/XX]', detail)
    lines = detail.splitlines()
    filtered = [line for line in lines if not ('Built ' in line or '✔' in line)]
    detail = '\n'.join(filtered) + '\n' if filtered else ''
    return r.returncode == 0, detail


def sorry_free(pkg_dir, decl_name):
    # decl_name's module path (Wasm4pmVerify.Corr.<corrName>) matches the
    # fully-qualified declaration name for this pack's Corr modules, so the
    # same string imports the module the declaration lives in. Without this
    # import, `#print axioms` runs in a bare Lean environment that has never
    # seen the declaration and fails with "unknown constant" — a distinct
    # failure mode from an actual sorryAx that must not be conflated with one.
    # `--stdin` (not `--run /dev/stdin`) is required: `--run` expects the
    # script to define `main` and exits nonzero without one, even when the
    # `#print axioms` command itself printed correctly — that nonzero exit
    # was being misread as "not sorry-free".
    r = subprocess.run(
        [LAKE, 'env', 'lean', '--stdin'],
        cwd=pkg_dir, capture_output=True,
        input=f'import {decl_name}\n#print axioms {decl_name}\n'.encode())
    if r.returncode != 0:
        return False, (r.stdout.decode() + r.stderr.decode())[-2000:]
    out = r.stdout.decode()
    return 'sorryAx' not in out, out


def derive_status(rec):
    evidence: Dict[str, Any] = {'declared': True, 'extracted': False, 'stated': False, 'proven': False}
    status = 'DECLARED'

    if not os.path.exists(PIPELINE_JSON):
        evidence['reason'] = 'no verify/receipts/pipeline.json — charon/aeneas has not run'
        return status, evidence
    evidence['extracted'] = True
    evidence['pipelineJsonHash'] = b3_file(PIPELINE_JSON)
    status = 'EXTRACTED'

    corr_lean = os.path.join(LEAN_PKG_DIR, 'Wasm4pmVerify/Corr', rec['corrName'] + '.lean')
    if not os.path.exists(corr_lean):
        evidence['reason'] = f'rendered {corr_lean} does not exist yet — run just render'
        return status, evidence
    ok, detail = lake_build_ok(LEAN_PKG_DIR)
    evidence['lakeBuildOk'] = ok
    evidence['lakeBuildDetail'] = detail
    if not ok:
        evidence['reason'] = 'lake build of verify/lean failed or lakefile missing'
        return status, evidence
    evidence['stated'] = True
    status = 'STATED'

    full_decl = f'Wasm4pmVerify.Corr.{rec["corrName"]}'
    no_sorry, axioms_out = sorry_free(LEAN_PKG_DIR, full_decl)
    evidence['axiomPrintOutput'] = axioms_out
    if not no_sorry:
        evidence['reason'] = 'sorryAx present — statement elaborates, proof incomplete'
        return status, evidence
    evidence['proven'] = True
    status = 'PROVEN'
    return status, evidence


def check_proof_status_mismatch(verif_status_path: str, obligations: Any) -> None:
    """Refusal: stored proof status exceeds current evidence level.

    Status ladder (cannot skip rungs): DECLARED < EXTRACTED < STATED < PROVEN.
    Detects regression where previously-higher status claims are no longer
    evidenced.
    """
    if not os.path.exists(verif_status_path):
        return

    # Parse stored statuses from verif-status.generated.ttl
    stored_statuses: Dict[str, str] = {}
    try:
        status_text = open(verif_status_path, encoding='utf-8').read()
        for line in status_text.split('\n'):
            m = re.search(r'(verif:Obl_\S+)\s+verif:status\s+"(\w+)"', line)
            if m:
                stored_statuses[m.group(1)] = m.group(2)
    except IOError:
        return

    if not stored_statuses:
        return

    # Check each obligation: stored status must not exceed current evidence
    for rec in obligations:
        subject = rec['subject']
        if subject not in stored_statuses:
            continue
        stored_status = stored_statuses[subject]

        # Recompute current evidence level
        _, evidence = derive_status(rec)

        # Map evidence dict to evidence level
        if evidence.get('proven'):
            evidence_level = 'PROVEN'
        elif evidence.get('stated'):
            evidence_level = 'STATED'
        elif evidence.get('extracted'):
            evidence_level = 'EXTRACTED'
        else:
            evidence_level = 'DECLARED'

        # Check ladder: stored status must not exceed evidence level
        status_order = {'DECLARED': 0, 'EXTRACTED': 1, 'STATED': 2, 'PROVEN': 3}
        if status_order.get(stored_status, -1) > status_order.get(evidence_level, -1):
            print(f'refusal: PROOF_STATUS_MISMATCH_REFUSED: claimed status {stored_status} unsupported by evidence {evidence_level}')
            sys.exit(2)


def check_aeneas_image_drift(pipeline_json_path: str) -> None:
    """Refusal: aeneas/charon evidence hash mismatch.

    Detects if the intermediate files (charon .llbc) that back the
    correspondence extraction have been modified without re-running
    charon/aeneas.
    """
    if not os.path.exists(pipeline_json_path):
        return

    # Read stored hash from pipeline.json
    try:
        pipeline_data: Dict[str, Any] = json.load(open(pipeline_json_path))
        stored_hash = pipeline_data.get('pipelineJsonHash')
    except (json.JSONDecodeError, IOError):
        return

    if not stored_hash:
        return

    # Find all .llbc files (charon output) in verify directory tree
    verify_base = os.path.dirname(os.path.dirname(pipeline_json_path))
    evidence_files: list = []

    for root, _dirs, files in os.walk(verify_base):
        for fname in sorted(files):
            if fname.endswith('.llbc'):
                evidence_files.append(os.path.join(root, fname))

    # Compute combined hash of all evidence files
    evidence_hashes: list = []
    for fpath in sorted(evidence_files):
        h = b3_file(fpath)
        if h:
            evidence_hashes.append(h)

    # Hash all evidence hashes together
    if evidence_hashes:
        combined = '\n'.join(evidence_hashes).encode()
    else:
        combined = b'none'
    recomputed_hash = b3(combined)

    if recomputed_hash != stored_hash:
        print(f'refusal: AENEAS_IMAGE_DRIFT_REFUSED: pipeline hash mismatch {stored_hash} vs {recomputed_hash}')
        sys.exit(2)


def check_correspondence_dangling(obligations: Any, procint_root: str) -> None:
    """Refusal: leanDecl reference does not exist in Lean source.

    Verifies that each obligation's leanDecl (e.g., Wasm4pmVerify.Corr.Foo)
    has a corresponding declaration in the procint Lean source.
    """
    for rec in obligations:
        lean_decl = rec.get('leanDecl')
        if not lean_decl:
            continue

        # Search in procint directories for the leanDecl
        search_dirs = [
            os.path.join(procint_root, 'procint/ProcInt'),
            os.path.join(procint_root, 'procint/Generated'),
        ]

        found = False
        for search_dir in search_dirs:
            if not os.path.exists(search_dir):
                continue

            try:
                result = subprocess.run(
                    ['grep', '-r', lean_decl, search_dir, '--include=*.lean'],
                    capture_output=True, timeout=10
                )
                if result.returncode == 0:
                    found = True
                    break
            except subprocess.TimeoutExpired:
                continue

        if not found:
            print(f'refusal: CORRESPONDENCE_DANGLING_REFUSED: leanDecl={lean_decl} not found in Lean')
            sys.exit(2)


def _tex_escape(s: str) -> str:
    return (s.replace('\\', r'\textbackslash{}').replace('_', r'\_')
             .replace('&', r'\&').replace('%', r'\%').replace('#', r'\#'))


def render_correspondence_status_tex(results, out_path: str) -> None:
    """Auto-rendered from release/verif-receipt.json — do not edit manually,
    regenerate via `python3 scripts/build_verif.py`. Reports only the status
    ladder position and evidence this script actually computed; never adds
    claims (receipt-chain tamper detection, OCEL metrics, etc.) beyond what
    derive_status() checked."""
    color = {'DECLARED': 'gray', 'EXTRACTED': 'orange', 'STATED': 'orange', 'PROVEN': 'green'}
    rows = []
    for r in results:
        ev = r['evidence']
        reason = ev.get('reason', 'full ladder evidence present (extracted, stated, proven)')
        rows.append(
            f"{_tex_escape(r['corrName'])} & "
            f"\\textcolor{{{color.get(r['status'], 'gray')}}}{{{r['status']}}} & "
            f"{_tex_escape(reason)} \\\\"
        )
    lines = [
        '% AUTO-RENDERED by scripts/build_verif.py — do not edit by hand.',
        '% Regenerate: python3 scripts/build_verif.py',
        '\\begin{table}[h!]',
        '\\centering',
        '\\begin{tabular}{lll}',
        '\\toprule',
        '\\textbf{Obligation} & \\textbf{Status} & \\textbf{Evidence} \\\\',
        '\\midrule',
        *rows,
        '\\bottomrule',
        '\\end{tabular}',
        '\\caption{Correspondence-factory obligation status, computed from '
        'observed charon/aeneas/lake evidence by \\texttt{scripts/build\\_verif.py} '
        '(status ladder: DECLARED $<$ EXTRACTED $<$ STATED $<$ PROVEN; never hand-set '
        'past DECLARED). See release/verif-receipt.json for the full evidence trail.}',
        '\\label{tab:correspondence}',
        '\\end{table}',
        '',
    ]
    open(out_path, 'w').write('\n'.join(lines))


def main():
    if not os.path.exists(VERIF_TTL):
        print(f'refusal: VERIF_CATALOG_MISSING — {VERIF_TTL} does not exist')
        sys.exit(2)
    ttl_text = open(VERIF_TTL, encoding='utf-8').read()
    obligations = parse_obligations(ttl_text)
    if not obligations:
        print('refusal: VERIF_CATALOG_EMPTY — no verif:CorrespondenceObligation entities found')
        sys.exit(2)

    # Run refusal checks BEFORE deriving any status
    check_proof_status_mismatch(OUT_FRAGMENT, obligations)
    check_aeneas_image_drift(PIPELINE_JSON)
    check_correspondence_dangling(obligations, ROOT)

    results = []
    frag_lines = [
        '@prefix verif: <https://mfact.dev/verif#> .', '',
        '# GENERATED by scripts/build_verif.py — DO NOT EDIT BY HAND.',
        '# Supplies ONLY verif:status per obligation (same subject IRIs as the',
        '# hand-authored fragments/verif.ttl, which deliberately omits this',
        '# predicate). Status is derived from observed charon/aeneas/lake',
        '# evidence; see release/verif-receipt.json for the evidence trail.',
        '',
    ]
    for rec in obligations:
        status, evidence = derive_status(rec)
        results.append({**rec, 'status': status, 'evidence': evidence})
        frag_lines.append(f'{rec["subject"]} verif:status "{status}" .')
    frag_lines.append('')
    open(OUT_FRAGMENT, 'w').write('\n'.join(frag_lines))

    rust_hashes = {}
    for rec in obligations:
        p = os.path.join(WASM4PM_COMPAT, rec['rustFile'])
        rust_hashes[rec['rustFile']] = b3_file(p)

    lean_toolchain_verify = None
    tc_path = os.path.join(LEAN_PKG_DIR, 'lean-toolchain')
    if os.path.exists(tc_path):
        lean_toolchain_verify = open(tc_path).read().strip()
    lean_toolchain_procint = None
    ptc_path = os.path.join(ROOT, 'procint/lean-toolchain')
    if os.path.exists(ptc_path):
        lean_toolchain_procint = open(ptc_path).read().strip()

    receipt = {
        'builder': 'scripts/build_verif.py',
        'catalogSource': 'packs/lean-math-pack/fragments/verif.ttl',
        'catalogHash': b3_file(VERIF_TTL),
        'pipelineJsonExists': os.path.exists(PIPELINE_JSON),
        'leanToolchainVerify': lean_toolchain_verify,
        'leanToolchainProcint': lean_toolchain_procint,
        'rustFileHashes': rust_hashes,
        'obligations': results,
    }
    os.makedirs(os.path.dirname(OUT_RECEIPT), exist_ok=True)
    open(OUT_RECEIPT, 'w').write(json.dumps(receipt, indent=2, sort_keys=True) + '\n')

    render_correspondence_status_tex(results, CORRESPONDENCE_STATUS_TEX)

    print(f'verif-status fragment: {OUT_FRAGMENT}')
    print(f'verif receipt: {OUT_RECEIPT}')
    print(f'correspondence status tex: {CORRESPONDENCE_STATUS_TEX}')
    for r in results:
        print(f'  {r["corrName"]}: {r["status"]} ({r["evidence"].get("reason", "full ladder evidence present")})')


if __name__ == '__main__':
    main()
