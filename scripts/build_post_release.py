#!/usr/bin/env python3
"""Post-release publication-packet builder.

Reads DOWNSTREAM receipts only (manifest, gates, quadrature, standing,
certify/controls logs, paper artifacts, git) and emits the post-release
graph at packs/post-release-pack/ontology.ttl. ggen renders; Lean admits
(ProcInt.Release.PostRelease); the ledger records.

IDENTITY LAW (RECEIPT_RECURSION_REFUSED): this builder must not mutate the
core certified release it reports. It never writes release-manifest.json,
gates.json, or anything the core foldHash covers; it verifies the core
manifest hash is identical before and after its own run and refuses
otherwise. The packet gets its OWN hash, folded over the packet's evidence
inputs (never over outputs that would embed the hash — no self-reference).

Publication is never self-actuated: every packet's publication field is
PENDING_EXTERNAL_ACTUATION regardless of how ALIVE its requirements are.

Modes: --plan  (first pass: skip the arXiv cold-build gate, mark PENDING —
used before the paper fragments exist); default = full run with the gate.
"""
import json, os, re, subprocess, sys, tarfile, tempfile, tomllib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = '/Users/sac/praxis/packs/post-release-pack/ontology.ttl'
PLAN = '--plan' in sys.argv

def b3(data: bytes) -> str:
    return subprocess.run(['b3sum', '--no-names'], input=data,
                          capture_output=True, check=True).stdout.decode().strip()

def b3_file(path):
    return b3(open(path, 'rb').read()) if os.path.exists(path) else None

def refuse(name, msg):
    print(f'refusal: {name} — {msg}')
    sys.exit(2)

def git(*args):
    r = subprocess.run(['git', '-C', ROOT] + list(args), capture_output=True)
    return r.returncode, r.stdout.decode().strip()

# ---- Evidence inputs (downstream receipts only) ----
man_path = os.path.join(ROOT, 'release/release-manifest.json')
core_manifest_hash_before = b3_file(man_path)
man = json.load(open(man_path))
RELEASE = man['release']
CORE_TAG = f'{RELEASE}-procint-certified'
gates = json.load(open(os.path.join(ROOT, 'release/gates.json')))
quad = json.load(open(os.path.join(ROOT, 'release/quadrature.json')))
core_proven = sum(1 for a in man['artifacts'] if a['proven'])
rendered = man['runIdentifier'][:7]

_, tag_commit = git('rev-list', '-n', '1', CORE_TAG)
anc, _ = git('merge-base', '--is-ancestor', man['runIdentifier'], tag_commit or 'HEAD')
tag_gate = 'PASS' if (tag_commit and anc == 0) else 'FAIL'
_, dirty = git('status', '--porcelain')

cert = open(os.path.join(ROOT, 'release/certify.log')).read()
cert_line = re.search(r'certified: (v[\d.]+) \(proven (\d+)/(\d+)', cert)
cert_ok = bool(cert_line and cert_line.group(2) == str(core_proven)
               and cert_line.group(3) == str(len(man['artifacts'])))
ctl = open(os.path.join(ROOT, 'release/quadrature-negative-controls.log')).read()
controls_ok = 'controls: 3 refused correctly, 0 failed to refuse' in ctl

ax = tomllib.load(open(os.path.join(ROOT, '.mfact/arxiv.toml'), 'rb'))['arxiv']
declared = ax['root_files'] + ax['paper_files']
tarball = os.path.join(ROOT, ax['tarball'])
pdf = os.path.join(ROOT, 'paper/main.pdf')
tar_hash, pdf_hash = b3_file(tarball), b3_file(pdf)

# ---- arXiv packet gate (cold build from the tarball, declared == packed) ----
arxiv_status, arxiv_detail = 'PENDING', 'first pass (--plan): fragments not yet rendered'
if not PLAN:
    if not tar_hash:
        refuse('ARXIV_PACKET_REFUSED', 'tarball missing')
    with tarfile.open(tarball) as t:
        packed = sorted(t.getnames())
    if packed != sorted(declared):
        refuse('ARXIV_PACKET_REFUSED',
               f'declared != packed: {sorted(set(declared) ^ set(packed))}')
    with tempfile.TemporaryDirectory(dir=os.environ.get('TMPDIR', '/tmp')) as d:
        subprocess.run(['tar', 'xzf', tarball, '-C', d], check=True)
        leaks = subprocess.run(['grep', '-rl', '/Users/', '--include=*.tex', d],
                               capture_output=True).stdout.decode().strip()
        if leaks:
            refuse('ARXIV_PACKET_REFUSED', f'absolute local paths leak: {leaks}')
        r = subprocess.run(['latexmk', '-pdf', '-interaction=nonstopmode', 'main.tex'],
                           cwd=d, capture_output=True)
        if r.returncode != 0 or not os.path.exists(os.path.join(d, 'main.pdf')):
            refuse('ARXIV_PACKET_REFUSED', 'cold latex build failed in scratch untar')
    arxiv_status, arxiv_detail = 'ALIVE', \
        f'cold build PASS from untarred package ({len(declared)} declared files)'

standin = os.environ.get('MFACT_STANDIN', '')
_ls = subprocess.run(['git', 'ls-remote', '--tags', standin], capture_output=True) \
    if standin else None
standin_has_tag = bool(_ls and _ls.returncode == 0
                       and f'refs/tags/{CORE_TAG}' in _ls.stdout.decode())

# ---- Actuation packets: requirements evaluated, never self-actuated ----
packets = [
    ('github_push', [('repo_clean', dirty == ''), ('tag_exists', bool(tag_commit)),
                     ('tag_descends_from_rendered_commit', tag_gate == 'PASS'),
                     ('standin_has_release_tag', standin_has_tag)]),
    ('arxiv_upload', [('tarball_exists', bool(tar_hash)),
                      ('cold_build_passed', arxiv_status == 'ALIVE'),
                      ('pdf_exists', bool(pdf_hash)), ('certified', cert_ok)]),
    ('github_release', [('certified', cert_ok), ('controls_refused', controls_ok),
                        ('quadrature_pass', quad['results']['standing_quadrature'] == 'PASS'),
                        ('gates_pass', all(gates.values()))]),
]

# ---- Crown research lane: statuses derived from the TTL catalog ----
ttl = open('/Users/sac/praxis/packs/lean-math-pack/ontology.ttl', encoding='utf-8').read()
def decl_status(name):
    m = re.search(r'procint:declName "ProcInt\.' + re.escape(name)
                  + r'"[^.]*?procint:status "([^"]+)"', ttl, re.DOTALL)
    return {'proven': 'PROVEN_SUPPORT', 'stated': 'STATED'}.get(
        m.group(1) if m else '', 'NOT_FORMALIZED')
obligations = [
    ('sound_iff_shortCircuit_live_bounded',
     decl_status('WfNet.sound_iff_shortCircuit_live_bounded_statement'),
     'the crown equivalence itself (van der Aalst 1997, Lemma 8)'),
    ('proper_completion_support', decl_status('WfNet.Sound.reaches_final'),
     'soundness implies the final marking is reachable'),
    ('dead_transition_support', decl_status('WfNet.Sound.enabled_of_transition'),
     'soundness implies every transition can fire'),
    ('unfolding_correctness', decl_status('BranchingProcess.isUnfoldingOf_statement'),
     'branching-process unfolding statement (separate stated lane)'),
]

# ---- Replay + docs lanes (upgraded only by their own gates' reports) ----
rep = os.path.join(ROOT, 'release/replay_report.json')
replay = 'REPLAY_NOT_RUN'
if os.path.exists(rep):
    _r = json.load(open(rep))
    # A replay receipt binds to ITS tag; a prior release's PASS is not ours.
    replay = _r['status'] if _r.get('tag') == CORE_TAG else 'REPLAY_NOT_RUN'
docs_rep = os.path.join(ROOT, 'release/docs_report.json')
docs = json.load(open(docs_rep))['LEAN_HTML_DOCS'] if os.path.exists(docs_rep) else 'PLANNED'

# ---- Packet identity: fold over evidence INPUTS, never over outputs ----
acc = b3(f'mfact-{RELEASE}-postrelease-genesis'.encode())
for h in [man['foldHash'], core_manifest_hash_before, tar_hash or '0'*64,
          pdf_hash or '0'*64, b3_file(os.path.join(ROOT, 'release/quadrature.json')),
          b3(('cert_ok=%s;controls_ok=%s' % (cert_ok, controls_ok)).encode())]:
    acc = b3(acc.encode() + h.encode())

# ---- Emit the post-release graph ----
def esc(s):
    return s.replace('\\', '\\\\').replace('"', '\\"')
L = ['@prefix post: <https://mfact.dev/postrelease#> .',
     '@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .', '',
     'post:Meta a post:MetaNode ;',
     f'  post:releaseId "{man["release"]}" ;',
     f'  post:coreReleaseHash "{man["foldHash"]}" ;',
     f'  post:coreProven {core_proven} ;',
     f'  post:coreTotalDecls {len(man["artifacts"])} ;',
     f'  post:statedCount {len(man["statedNotProven"])} ;',
     f'  post:renderedCommit "{rendered}" ;',
     f'  post:coreTag "{CORE_TAG}" ;',
     f'  post:tagCommit "{tag_commit[:7]}" ;',
     f'  post:tagGate "{tag_gate}" ;',
     f'  post:packetHash "{acc}" ;',
     f'  post:arxivStatus "{arxiv_status}" ;',
     f'  post:arxivDetail "{esc(arxiv_detail)}" ;',
     f'  post:arxivFileCount {len(declared)} ;',
     f'  post:tarballHash "{tar_hash or "MISSING"}" ;',
     f'  post:pdfHash "{pdf_hash or "MISSING"}" ;',
     f'  post:replayStatus "{replay}" ;',
     f'  post:replayStatusTex "{esc(replay.replace("_", chr(92) + "_"))}" ;',
     f'  post:docsLane "{docs}" ;',
     '  post:crownStatus "STATED" ;',
     '  post:publication "PENDING_EXTERNAL_ACTUATION" ;',
     r'  post:publicationTex "PENDING\\_EXTERNAL\\_ACTUATION" ;',
     '  post:postReleaseWitnesses 2 .', '']
for pid, reqs in packets:
    alive = all(met for _, met in reqs)
    L += [f'post:Packet_{pid} a post:Packet ;',
          f'  post:packetId "{pid}" ;',
          f'  post:packetIdTex "{esc(pid.replace("_", chr(92) + "_"))}" ;',
          f'  post:packetStatus "{"ALIVE" if alive else "BLOCKED"}" ;',
          '  post:publication "PENDING_EXTERNAL_ACTUATION" .', '']
    for i, (rname, met) in enumerate(reqs):
        L += [f'post:Req_{pid}_{i} a post:Requirement ;',
              f'  post:reqPacket "{pid}" ;',
              f'  post:reqOrder {i} ;',
              f'  post:reqName "{rname}" ;',
              f'  post:reqMet "{str(met).lower()}" .', '']
for i, (name, status, note) in enumerate(obligations):
    L += [f'post:Obl_{i} a post:Obligation ;',
          f'  post:oblOrder {i} ;',
          f'  post:oblName "{name}" ;',
          f'  post:oblNameTex "{esc(name.replace("_", chr(92) + "_"))}" ;',
          f'  post:oblStatus "{status}" ;',
          f'  post:oblStatusTex "{esc(status.replace("_", chr(92) + "_"))}" ;',
          f'  post:oblNote "{esc(note)}" .', '']
for i, f in enumerate(declared):
    L += [f'post:Ax_{i} a post:ArxivFile ; post:fileOrder {i} ; post:fileName "{f}" .']
L += ['']
for i, (fn, h) in enumerate([('paper/arxiv-submission.tar.gz', tar_hash),
                             ('paper/main.pdf', pdf_hash),
                             ('release/release-manifest.json', core_manifest_hash_before)]):
    L += [f'post:Sum_{i} a post:Checksum ; post:sumOrder {i} ; '
          f'post:sumFile "{fn}" ; post:sumHash "{h or "MISSING"}" .']
for i, cmd in enumerate([
        'git clone <stand-in>/mfact-dryrun.git at tag ' + CORE_TAG,
        'just render && just build (pinned toolchain, lake exe cache get)',
        'just audit && just test',
        'just certify (exit 0 required)',
        'just regen-check (ARTIFACT_DRIFT_REFUSED on any divergence)']):
    tex = (cmd.replace('\\', '').replace('&', '\\&').replace('_', '\\_')
              .replace('<', '\\textless ').replace('>', '\\textgreater '))
    L += [f'post:Step_{i} a post:ReplayStep ; post:stepOrder {i} ; '
          f'post:stepCmd "{esc(cmd)}" ; post:stepCmdTex "{esc(tex)}" .']
open(OUT, 'w').write('\n'.join(L) + '\n')

# ---- RECEIPT_RECURSION guard: core identity untouched by this run ----
if b3_file(man_path) != core_manifest_hash_before:
    refuse('RECEIPT_RECURSION_REFUSED',
           'post-release run mutated the core release manifest')

blocked = [pid for pid, reqs in packets if not all(m for _, m in reqs)]
print(f'post-release graph: {OUT}')
print(f'packet hash: {acc}')
print(f'packets: {", ".join(pid + ("=ALIVE" if pid not in blocked else "=BLOCKED") for pid, _ in packets)}'
      f' | arxiv={arxiv_status} replay={replay} docs={docs} crown=STATED')
if not PLAN and blocked:
    refuse('PUBLICATION_PACKET_BLOCKED', f'unmet requirements in: {blocked}')
