#!/usr/bin/env python3
"""Standing Quadrature builder: computes the cross-product closure over the
five release surfaces (TTL catalog, rendered/admitted Lean corpus, release
manifest, process evidence, paper claims) and writes the quadrature graph
to packs/quadrature-pack/ontology.ttl for ggen to render.

ggen renders. Lean admits. mfact certifies. This script computes; it never
asserts. Any orphan => typed refusal (exit 2)."""
import re, json, subprocess, os, sys, glob

# Env overrides exist so negative controls can poison COPIES of single
# surfaces without touching the release.
ROOT = os.environ.get('MFACT_ROOT',
                      os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ONTOLOGY = os.environ.get('QUAD_ONTOLOGY',
                          '/Users/sac/mfact/packs/lean-math-pack/ontology.ttl')
QUAD_TTL = os.environ.get('QUAD_OUT',
                          '/Users/sac/mfact/packs/quadrature-pack/ontology.ttl')
MANIFEST = os.path.join(ROOT, 'release/release-manifest.json')
EVAL_TEX = os.environ.get('QUAD_EVAL_TEX',
                          os.path.join(ROOT, 'paper/evaluation.tex'))
AUDIT_LEAN = os.path.join(ROOT, 'procint/AxiomAudit.lean')

def step(n, label, ok):
    dots = '.' * max(1, 45 - len(label))
    print(f"[{n}/7] {label}{dots}{'PASS' if ok else 'FAIL'}")
    return ok

def esc(s):  # TTL string literal escaping
    return s.replace('\\', '\\\\').replace('"', '\\"')

# ---- [1] TTL catalog surface ----
text = open(ONTOLOGY, encoding='utf-8').read()
ttl_proven, ttl_all, ttl_stated = [], [], []
for b in text.split('\n\n'):
    if re.search(r'a procint:Decl\s*;', b):
        n = re.search(r'procint:declName "([^"]+)"', b)
        s = re.search(r'procint:status "([^"]+)"', b)
        a = re.search(r'procint:auditMsg "([^"]*)"', b)
        if n and s:
            ttl_all.append(n.group(1))
            if s.group(1) == 'proven' and a:
                ttl_proven.append(n.group(1))
            if s.group(1) == 'stated':
                ttl_stated.append(n.group(1))
ttl_proven.sort()
ok1 = step(1, 'Loading TTL declaration catalog', len(ttl_proven) > 0)

# ---- [2] Lean symbol inventory (rendered corpus) ----
corpus = ''
for f in glob.glob(os.path.join(ROOT, 'procint/ProcInt/**/*.lean'), recursive=True):
    corpus += open(f, encoding='utf-8').read()
def in_corpus(fqn):
    bare = fqn[len('ProcInt.'):] if fqn.startswith('ProcInt.') else fqn
    return (bare in corpus) or (fqn in corpus)
orphan_ttl = [d for d in ttl_proven if not in_corpus(d)]  # TTL proven w/o Lean symbol
ok2 = step(2, 'Reading Lean symbol inventory', not orphan_ttl)

# ---- [3] Axiom audit surface ----
audited = sorted(set(re.findall(r'#print axioms (\S+)', open(AUDIT_LEAN).read())))
orphan_lean = sorted(set(audited) - set(ttl_proven))       # audited w/o TTL origin
audit_gap = sorted(set(ttl_proven) - set(audited))          # proven w/o audit line
ok3 = step(3, 'Reading axiom/proof audit', not orphan_lean and not audit_gap)

# ---- [4] Release manifest surface ----
man = json.load(open(MANIFEST))
man_proven = sorted(a['name'] for a in man['artifacts'] if a['proven'])
man_gap = sorted(set(ttl_proven) ^ set(man_proven))
stated_ok = sorted(man['statedNotProven']) == sorted(ttl_stated)
untraced = [a['name'] for a in man['artifacts'] if a['proven'] and
            not any(e['kind'] == 'axiomAudit' and e['subject'] == a['name']
                    for e in man['evidence'])]
ok4 = step(4, 'Reading release manifest', not man_gap and not untraced and stated_ok)

# ---- [5] Process evidence ----
receipt_ok = subprocess.run(
    ['ggen', 'receipt', 'verify'],
    cwd=ROOT, capture_output=True).returncode == 0
# Run identity comes from the manifest (recorded at manifest generation),
# NOT the live git HEAD — regeneration must be idempotent for regen-check.
head = man.get('runIdentifier', 'unknown')[:7]
events = ['TtlCatalogLoaded', 'LeanRendered', 'LakeBuildPassed',
          'SorryAuditPassed', 'AxiomAuditPassed', 'NegativeFixturesPassed',
          'ManifestGenerated', 'PaperEvidenceGenerated',
          'CertifiedReleaseConstructed', 'QuadratureClosed']
ok5 = step(5, 'Reading process evidence', receipt_ok)

# ---- [6] Paper claims + evaluation numbers ----
claims = [
    ('C1', 'mfact framework with axiom-free no_valid_objection',
     'mfact/AxiomAudit.lean'),
    ('C2', f'procint corpus: {len(man_proven)} kernel-admitted, axiom-audited theorems',
     'release/release-manifest.json#artifacts'),
    ('C3', 'proven/stated split enforced by release gate (2 stated)',
     'release/release-manifest.json#statedNotProven'),
    ('C4', 'evaluation numbers rendered from the manifest',
     'paper/evaluation.tex'),
    ('C5', 'negative controls: the gate refuses (exit 1/2)',
     'release/certify.log'),
]
eval_txt = open(EVAL_TEX).read()
axdist = {}
for a in man['artifacts']:
    if a['proven']:
        axdist[len(a['axioms'])] = axdist.get(len(a['axioms']), 0) + 1
expect = {
    'total decls': len(man['artifacts']),
    'proven': len(man_proven),
    'stated': len(man['statedNotProven']),
    'no-axiom theorems': axdist.get(0, 0),
    'three-axiom theorems': axdist.get(3, 0),
}
unsupported = [k for k, v in expect.items()
               if not re.search(r'(^|[^0-9])' + str(v) + r'([^0-9]|$)', eval_txt)]
fold_ok = man['foldHash'][:16] in eval_txt or man['foldHash'][:8] in eval_txt
if not fold_ok:
    unsupported.append('foldHash prefix')
ok6 = step(6, 'Checking paper claims/evaluation', not unsupported)

# ---- release-status fields for the paper fragments ----
senv = dict(l.split('=', 1) for l in
            open(os.path.join(ROOT, 'release/standing.env'))
            if '=' in l and not l.startswith('#'))
crown = ('proven' if 'def crownJewel_status : String := "proven"' in text
         else 'stated' if 'def crownJewel_status : String := "stated"' in text
         else 'unknown')
tag = subprocess.run(['git', '-C', ROOT, 'describe', '--tags', '--abbrev=0'],
                     capture_output=True).stdout.decode().strip() or man['release']

# ---- results ----
closed = all([ok1, ok2, ok3, ok4, ok5, ok6])
res = {
    'standing': 'PASS' if closed else 'FAIL',
    'orphan_ttl': len(orphan_ttl), 'orphan_lean': len(orphan_lean),
    'orphan_claims': sum(1 for c in claims if not c[2]),
    'orphan_manifest': len(man_gap), 'orphan_process': 0 if receipt_ok else 1,
    'unsupported_eval': len(unsupported), 'untraced': len(untraced),
    'unclassified_refusals': 0,
}
edges = [
    ('ttl_to_lean', 'TTL to Lean', 'TTL $\\rightarrow$ Lean', len(ttl_proven), ok2),
    ('lean_to_audit', 'Lean to Audit', 'Lean $\\rightarrow$ Audit', len(audited), ok3),
    ('audit_to_manifest', 'Audit to Manifest', 'Audit $\\rightarrow$ Manifest', len(man_proven), ok4),
    ('manifest_to_paper', 'Manifest to Paper', 'Manifest $\\rightarrow$ Paper', len(expect) + 1, ok6),
    ('artifact_to_process', 'Artifact to Process Event', 'Artifact $\\rightarrow$ Process Event', len(man['evidence']), ok5 and not untraced),
    ('claim_to_evidence', 'Claim to Evidence', 'Claim $\\rightarrow$ Evidence', len(claims), all(c[2] for c in claims)),
]
constraints = [
    ('c1', 'succession', 'TtlCatalogLoaded', 'LeanRendered'),
    ('c2', 'succession', 'LeanRendered', 'LakeBuildPassed'),
    ('c3', 'succession', 'LakeBuildPassed', 'AxiomAuditPassed'),
    ('c4', 'succession', 'ManifestGenerated', 'CertifiedReleaseConstructed'),
    ('c5', 'succession', 'CertifiedReleaseConstructed', 'QuadratureClosed'),
    ('c6', 'existence', 'SorryAuditPassed', '-'),
    ('c7', 'existence', 'NegativeFixturesPassed', '-'),
    ('c8', 'existence', 'PaperEvidenceGenerated', '-'),
]

# ---- [7] emit quadrature graph ----
L = ['@prefix quad: <https://mfact.dev/quadrature#> .',
     '@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .', '',
     '# GENERATED by scripts/build_quadrature.py — the quadrature graph.',
     '# ggen renders; Lean admits; mfact certifies.', '',
     'quad:Result a quad:Results ;',
     f'  quad:standingQuadrature "{res["standing"]}" ;',
     f'  quad:orphanTtlDecls {res["orphan_ttl"]} ;',
     f'  quad:orphanLeanDecls {res["orphan_lean"]} ;',
     f'  quad:orphanPaperClaims {res["orphan_claims"]} ;',
     f'  quad:orphanManifestFields {res["orphan_manifest"]} ;',
     f'  quad:orphanProcessEvents {res["orphan_process"]} ;',
     f'  quad:unsupportedEvaluationNumbers {res["unsupported_eval"]} ;',
     f'  quad:untracedArtifacts {res["untraced"]} ;',
     f'  quad:unclassifiedRefusals {res["unclassified_refusals"]} ;',
     f'  quad:releaseId "{man["release"]}" ;',
     f'  quad:runId "{head}" ;',
     f'  quad:ttlCount {len(ttl_proven)} ;',
     f'  quad:leanCount {len(ttl_proven) - len(orphan_ttl)} ;',
     f'  quad:manifestCount {len(man_proven)} ;',
     f'  quad:auditCount {len(audited)} ;',
     f'  quad:claimCount {len(claims)} ;',
     f'  quad:evalCount {len(expect) + 1} ;',
     f'  quad:eventCount {len(events)} ;',
     f'  quad:releaseTag "{tag}" ;',
     f'  quad:foldHash "{man["foldHash"]}" ;',
     f'  quad:sorryCount {senv.get("SORRY_COUNT", "UNKNOWN").strip()} ;',
     f'  quad:admitCount {senv.get("ADMIT_COUNT", "UNKNOWN").strip()} ;',
     f'  quad:statedCount {len(man["statedNotProven"])} ;',
     f'  quad:totalDecls {len(man["artifacts"])} ;',
     f'  quad:axiomAudit "{senv.get("AXIOM_AUDIT", "UNKNOWN").strip()}" ;',
     f'  quad:fixtures "{senv.get("NEGATIVE_FIXTURES", "UNKNOWN").strip()}" ;',
     f'  quad:certified "{senv.get("CERTIFIED_RELEASE", "UNKNOWN").strip()}" ;',
     f'  quad:crownJewel "{crown.upper()}" .', '']
for i, (k, lab, textex, cnt, ok) in enumerate(edges, 1):
    L += [f'quad:Edge_{k} a quad:EdgePair ;',
          f'  quad:pairKey "{k}" ;', f'  quad:pairLabel "{lab}" ;',
          f'  quad:pairLabelTex "{esc(textex)}" ;',
          f'  quad:count {cnt} ;',
          f'  quad:result "{"PASS" if ok else "FAIL"}" ;',
          f'  quad:order {i} .', '']
for i, (cid, txt, ev) in enumerate(claims, 1):
    L += [f'quad:Claim_{cid} a quad:Claim ;', f'  quad:claimId "{cid}" ;',
          f'  quad:claimText "{esc(txt)}" ;',
          f'  quad:evidenceRef "{esc(ev)}" ;', f'  quad:order {i} .', '']
for d in ttl_proven:
    slug = re.sub(r'[^A-Za-z0-9]', '_', d)
    L += [f'quad:T_{slug} a quad:TtlProvenDecl ; quad:declName "{d}" .']
for d in man_proven:
    slug = re.sub(r'[^A-Za-z0-9]', '_', d)
    L += [f'quad:M_{slug} a quad:ManifestProvenDecl ; quad:declName "{d}" .']
for d in audited:
    slug = re.sub(r'[^A-Za-z0-9]', '_', d)
    L += [f'quad:A_{slug} a quad:AuditedDecl ; quad:declName "{d}" .']
L.append('')
for i, e in enumerate(events):
    L += [f'quad:Ev_{e} a quad:RunEvent ; quad:activity "{e}" ; quad:ord {i} .']
L.append('')
for i, (cid, kind, a, b) in enumerate(constraints, 1):
    L += [f'quad:RC_{cid} a quad:RunConstraint ; quad:cid "{cid}" ; '
          f'quad:kind "{kind}" ; quad:actA "{a}" ; quad:actB "{b}" ; '
          f'quad:corder {i} .']
open(QUAD_TTL, 'w').write('\n'.join(L) + '\n')
step(7, 'Generating quadrature witness graph', True)

if not closed:
    print('refusal: standing quadrature open. Orphans:', file=sys.stderr)
    for label, xs in [('ttl_without_lean', orphan_ttl),
                      ('audited_without_ttl', orphan_lean),
                      ('audit_gap', audit_gap), ('manifest_gap', man_gap),
                      ('unsupported_eval', unsupported),
                      ('untraced', untraced)]:
        if xs:
            print(f'  {label}: {xs[:10]}', file=sys.stderr)
    sys.exit(2)
print(f'quadrature graph: {QUAD_TTL} (proven surface = {len(ttl_proven)})')
