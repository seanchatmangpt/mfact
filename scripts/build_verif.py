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

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VERIF_TTL = os.path.join(ROOT, 'packs/lean-math-pack/fragments/verif.ttl')
OUT_FRAGMENT = os.path.join(ROOT, 'packs/lean-math-pack/fragments/verif-status.generated.ttl')
OUT_RECEIPT = os.path.join(ROOT, 'release/verif-receipt.json')

WASM4PM_COMPAT = '/Users/sac/wasm4pm-compat'
PIPELINE_JSON = os.path.join(WASM4PM_COMPAT, 'verify/receipts/pipeline.json')
LEAN_PKG_DIR = os.path.join(WASM4PM_COMPAT, 'verify/lean')
LAKE = '/Users/sac/.elan/bin/lake'


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
    return r.returncode == 0, (r.stdout.decode() + r.stderr.decode())[-2000:]


def sorry_free(pkg_dir, decl_name):
    r = subprocess.run(
        [LAKE, 'env', 'lean', '--run', '/dev/stdin'],
        cwd=pkg_dir, capture_output=True,
        input=f'#print axioms {decl_name}\n'.encode())
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


def main():
    if not os.path.exists(VERIF_TTL):
        print(f'refusal: VERIF_CATALOG_MISSING — {VERIF_TTL} does not exist')
        sys.exit(2)
    ttl_text = open(VERIF_TTL, encoding='utf-8').read()
    obligations = parse_obligations(ttl_text)
    if not obligations:
        print('refusal: VERIF_CATALOG_EMPTY — no verif:CorrespondenceObligation entities found')
        sys.exit(2)

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

    print(f'verif-status fragment: {OUT_FRAGMENT}')
    print(f'verif receipt: {OUT_RECEIPT}')
    for r in results:
        print(f'  {r["corrName"]}: {r["status"]} ({r["evidence"].get("reason", "full ladder evidence present")})')


if __name__ == '__main__':
    main()
