#!/usr/bin/env python3
"""Agent cockpit reporter — READ-ONLY by default.

just status/next/trace/why/doctor call this without --write: nothing on
disk changes, the tree stays clean. Only `--write` (used by just check /
just release) emits .mfact/reports/latest.{json,md}, which are ephemeral
cockpit outputs (gitignored, never ledgered). Certified status lives in
release/FINAL_STATUS.* rendered by the publication packet, not here.

Every value below is read from receipts (standing.env, gates.json,
quadrature.json, artifacts.toml, .ggen-v2/receipt.json, git) — nothing
is asserted."""
import json, os, re, shutil, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def read_env(path):
    kv = {}
    if os.path.exists(path):
        for line in open(path):
            if '=' in line and not line.startswith('#'):
                k, _, v = line.strip().partition('=')
                kv[k] = v
    return kv

def read_json(path):
    try:
        return json.load(open(path))
    except Exception:
        return None

def read_ledger():
    arts, cur = [], None
    p = os.path.join(ROOT, '.mfact/artifacts.toml')
    if not os.path.exists(p):
        return arts
    for line in open(p):
        line = line.strip()
        if line == '[[artifact]]':
            cur = {}
            arts.append(cur)
        elif cur is not None and ' = ' in line:
            k, _, v = line.partition(' = ')
            if v.startswith('['):
                cur[k] = re.findall(r'"([^"]+)"', v)
            else:
                cur[k] = v.strip('"')
    return arts

def git(*args):
    r = subprocess.run(['git', '-C', ROOT] + list(args), capture_output=True)
    return r.returncode, r.stdout.decode().strip()

def gather():
    env = read_env(os.path.join(ROOT, 'release/standing.env'))
    gates = read_json(os.path.join(ROOT, 'release/gates.json')) or {}
    quad = read_json(os.path.join(ROOT, 'release/quadrature.json')) or {}
    man = read_json(os.path.join(ROOT, 'release/release-manifest.json')) or {}
    CORE_TAG = f"{man.get('release', 'unknown')}-procint-certified"
    rendered = man.get('runIdentifier', '')[:7]
    _, tag_commit = git('rev-list', '-n', '1', CORE_TAG)
    anc, _ = git('merge-base', '--is-ancestor', man.get('runIdentifier', 'HEAD'), tag_commit or 'HEAD')
    _, dirty = git('status', '--porcelain')
    non_pass = {k: v for k, v in env.items()
                if v not in ('PASS', 'TRUE', 'FALSE', '0') and not k.endswith('_HASH')
                and k not in ('DECLARATION_SOURCE', 'LEAN_SOURCE_ORIGIN')}
    return {
        'schema': 'mfact.report.v1',
        'core': {
            'release': man.get('release'),
            'coreReleaseHash': man.get('foldHash'),
            'coreProven': sum(1 for a in man.get('artifacts', []) if a.get('proven')),
            'coreTotalDecls': len(man.get('artifacts', [])),
            'statedNotProven': man.get('statedNotProven', []),
            'renderedCommit': rendered,
            'tag': CORE_TAG,
            'tagCommit': tag_commit[:7],
            'renderedCommitIsAncestorOfTag': 'PASS' if anc == 0 else 'FAIL',
        },
        'gates': gates,
        'quadratureResults': quad.get('results', {}),
        'standingEnv': env,
        'nonPassKeys': non_pass,
        'treeClean': dirty == '',
        'ledgeredArtifacts': len(read_ledger()),
    }

def cmd_status(rep):
    c = rep['core']
    print(f"core release      {c['release']}  (tag {c['tag']} @ {c['tagCommit']}, "
          f"rendered from {c['renderedCommit']}, ancestor check {c['renderedCommitIsAncestorOfTag']})")
    print(f"core identity     foldHash {c['coreReleaseHash'][:16]}…  "
          f"decls {c['coreTotalDecls']}  proven {c['coreProven']}  stated {len(c['statedNotProven'])}")
    print(f"gates             " + '  '.join(f"{k}={'PASS' if v else 'FAIL'}" for k, v in rep['gates'].items()))
    r = rep['quadratureResults']
    if r:
        orphans = sum(v for k, v in r.items() if k.startswith('orphan') and isinstance(v, int))
        print(f"quadrature        {r.get('standing_quadrature', '?')}  (orphans {orphans})")
    print(f"tree              {'clean' if rep['treeClean'] else 'DIRTY'}   "
          f"ledgered artifacts {rep['ledgeredArtifacts']}")
    ladder = [k for k in rep['standingEnv'] if k.startswith('PROCINT_')]
    print(f"correctness       " + '  '.join(f"{k.split('_', 1)[1]}={rep['standingEnv'][k]}" for k in ladder))
    for k, v in rep['nonPassKeys'].items():
        print(f"non-PASS          {k}={v}")

def cmd_next(rep):
    for k, v in rep['gates'].items():
        if not v:
            print(f"1. gate {k}=FAIL → just certify (after just manifest); diagnose with just doctor")
            return
    r = rep['quadratureResults']
    for k, v in r.items():
        if k.startswith('orphan') and isinstance(v, int) and v:
            print(f"1. {k}={v} → just standing-quadrature refused; repair catalog/render, re-run")
            return
    if not rep['treeClean']:
        print("1. tree DIRTY → commit source-caused changes, then just regen-check")
        return
    lanes = []
    if rep['standingEnv'].get('WFNET_CROWN_EQUIVALENCE') == 'STATED':
        lanes.append("crown theorem STATED (research lane, research/wfnet/obligations.toml)")
    if 'POST_RELEASE_PACKET' not in rep['standingEnv']:
        lanes.append("publication packet not yet manufactured → just manufacture-post-release")
    if 'LEAN_HTML_DOCS' not in rep['standingEnv']:
        lanes.append("docs lane not attempted → just docs (non-blocking, scratch worktree)")
    if not lanes:
        lanes = ["all gates PASS; external actuation remains PENDING_EXTERNAL_ACTUATION (user-only)"]
    for i, l in enumerate(lanes, 1):
        print(f"{i}. {l}")

def cmd_trace(rep, target):
    led = {a['path']: a for a in read_ledger()}
    rec = read_json(os.path.join(ROOT, '.ggen-v2/receipt.json')) or {}
    pay = rec.get('payload', {})
    a = led.get(target)
    if not a:
        print(f"UNTRACED: {target} is not in .mfact/artifacts.toml (not a ledgered artifact)")
        sys.exit(1)
    print(f"artifact   {target}")
    print(f"producer   {a.get('producer')}")
    if a.get('pack'):
        print(f"pack       {a['pack']}")
    for s in a.get('sources', []):
        print(f"source     {s}")
    print(f"hash       {a.get('content_hash')}")
    if target in pay.get('outputs', {}):
        print(f"receipt    blake3:{pay['outputs'][target]}  (chain {rec.get('record', {}).get('chain_hash_hex', '?')[:16]}…)")
        tmpls = [p for p in pay.get('closure', {}) if p.endswith('.tmpl')]
        print(f"closure    {len(tmpls)} templates + ontology (pack-granular: receipt records the "
              f"pack closure, not per-file template attribution)")

def cmd_why(rep, target):
    led = {a['path']: a for a in read_ledger()}
    a = led.get(target)
    if a:
        print(f"{target} exists because:")
        print(f"1. Its producer is {a.get('producer', '?')}" +
              (f" (pack {a['pack']})" if a.get('pack') else "") + ".")
        for s in a.get('sources', []):
            print(f"2. It is computed from {s}; editing {target} by hand is ARTIFACT_DRIFT_REFUSED.")
        print("3. regen-check re-renders it from source and refuses on drift.")
        return
    quad = read_json(os.path.join(ROOT, 'release/quadrature.json')) or {}
    for c in quad.get('claims', []):
        if target in (c.get('id', ''), c.get('claim', '')):
            print(f"claim {c.get('id')}: {c.get('claim')}")
            print(f"evidence: {c.get('evidence')}")
            return
    print(f"UNKNOWN: {target} is neither a ledgered artifact nor a quadrature claim id")
    sys.exit(1)

def cmd_doctor(rep):
    probes = [
        ('lake (elan shim)', '/Users/sac/.elan/bin/lake'),
        ('b3sum', shutil.which('b3sum')),
        ('latexmk', shutil.which('latexmk')),
        ('just', shutil.which('just')),
    ]
    ok = True
    for name, path in probes:
        present = bool(path) and os.path.exists(path)
        ok &= present
        print(f"{'OK    ' if present else 'MISSING'} {name}  {path or ''}")

    # ggen is resolved via PATH, not a pinned praxis path — it's installed
    # globally with `just install-ggen` (praxis/justfile) from the praxis
    # ggen crate. mfact only depends on the command existing and matching
    # what render/regen-check actually invoke (`ggen`), not on praxis's
    # target/ directory.
    ggen_path = shutil.which('ggen')
    ok &= bool(ggen_path)
    if ggen_path:
        ver = subprocess.run([ggen_path, '--version'], capture_output=True, text=True, timeout=5).stdout.strip()
        print(f"OK     ggen  {ggen_path}  ({ver or 'version unknown'})")
    else:
        print("MISSING ggen  not on PATH — run `just install-ggen` in praxis")

    # procint/mfact toolchain — verify the pinned lean-toolchain is actually
    # installed via elan, not merely that the elan shim binary exists.
    elan = shutil.which('elan') or '/Users/sac/.elan/bin/elan'
    installed = []
    if os.path.exists(elan):
        out = subprocess.run([elan, 'toolchain', 'list'], capture_output=True, text=True, timeout=5).stdout
        installed = [line.split()[0] for line in out.splitlines() if line.strip()]
    for tc_file in ('procint/lean-toolchain', 'mfact/lean-toolchain'):
        p = os.path.join(ROOT, tc_file)
        if not os.path.exists(p):
            continue
        pinned = open(p).read().strip()
        match = pinned in installed
        ok &= match
        print(f"{'OK    ' if match else 'FAIL  '} {tc_file}  pinned={pinned}"
              + ("" if match else f"  NOT INSTALLED (elan toolchain list: {installed})"))

    for f in ('release/release-manifest.json', 'release/gates.json', 'release/standing.env',
              'release/quadrature.json', '.mfact/artifacts.toml', '.ggen-v2/receipt.json'):
        present = os.path.exists(os.path.join(ROOT, f))
        ok &= present
        print(f"{'OK    ' if present else 'MISSING'} {f}")
    c = rep['core']
    print(f"{'OK    ' if c['renderedCommitIsAncestorOfTag'] == 'PASS' else 'FAIL  '} "
          f"tag gate: {c['tag']} @ {c['tagCommit']} descends from rendered commit {c['renderedCommit']}")
    for k, v in rep['gates'].items():
        print(f"{'OK    ' if v else 'FAIL  '} gate {k}")

    # Local pack sources (ggen.toml [packs]) — mfact vendors its own pack
    # ontology/templates under mfact/packs/, resolved via ggen.toml.
    print("--- pack sources ---")
    pack_paths = re.findall(r'^\S+\s*=\s*\{\s*path\s*=\s*"([^"]+)"',
                             open(os.path.join(ROOT, 'ggen.toml')).read(), re.M) \
        if os.path.exists(os.path.join(ROOT, 'ggen.toml')) else []
    for p in pack_paths:
        present = os.path.isdir(p)
        ok &= present
        print(f"{'OK    ' if present else 'MISSING'} pack  {p}")
    lock = os.path.join(ROOT, 'ggen.lock')
    print(f"{'OK    ' if os.path.exists(lock) else 'MISSING'} ggen.lock  {lock}")
    claude = os.path.join(ROOT, 'CLAUDE.md')
    if os.path.exists(claude):
        head = open(claude).read().strip()
        print(f"{'OK    ' if head == '@AGENTS.md' else 'WARN  '} CLAUDE.md is @AGENTS.md import: {head!r}")

    print("--- mechanical reality check ---")
    linter_cmd = [sys.executable, os.path.join(ROOT, 'scripts/rigor_linter.py')]
    try:
        subprocess.check_call(linter_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print("OK     rigor_linter.py  (no surface-level shortcuts)")
    except subprocess.CalledProcessError:
        ok = False
        print("FAIL   rigor_linter.py  (surface-level shortcuts detected! run manually to see violations)")

    if not ok:
        sys.exit(1)

def cmd_theorem_status(rep):
    c = rep['core']
    env = rep['standingEnv']
    print(f"PROVEN_AUDITED: {c['coreProven']}")
    print(f"STATED: {len(c['statedNotProven'])}")
    print(f"TOTAL_DECLS: {c['coreTotalDecls']}")
    for k in ('PROCINT_SEMANTIC_FIXTURES', 'PROCINT_NEGATIVE_FIXTURES',
              'PROCINT_ORACLE_CASES', 'PROCINT_AXIOM_AUDIT',
              'PROCINT_CROSS_SURFACE_CONFORMANCE'):
        if k in env:
            print(f"{k}={env[k]}")
    print(f"WFNET_CROWN_EQUIVALENCE={env.get('WFNET_CROWN_EQUIVALENCE', 'UNKNOWN')}")
    for name in c['statedNotProven']:
        print(f"stated: {name}")
    q = rep['quadratureResults']
    print(f"witness ProcInt.Release.Quadrature: {q.get('standing_quadrature', 'UNKNOWN')}")
    print(f"witness ProcInt.Release.PostRelease: "
          f"{'RENDERED' if os.path.exists(os.path.join(ROOT, 'procint/ProcInt/Release/PostRelease.lean')) else 'ABSENT'}"
          f" (admitted by lake build PostRelease; statuses in release/final_status.json)")

def write_reports(rep):
    d = os.path.join(ROOT, '.mfact/reports')
    os.makedirs(d, exist_ok=True)
    json.dump(rep, open(os.path.join(d, 'latest.json'), 'w'), indent=2)
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        cmd_status(rep)
    open(os.path.join(d, 'latest.md'), 'w').write(
        "# mfact cockpit report (ephemeral — certified status lives in release/)\n\n```\n"
        + buf.getvalue() + "```\n")
    print(f"wrote {d}/latest.json + latest.md (ephemeral, gitignored)")

if __name__ == '__main__':
    args = [a for a in sys.argv[1:] if a != '--write']
    write = '--write' in sys.argv
    cmd = args[0] if args else 'status'
    rep = gather()
    if cmd == 'status':
        cmd_status(rep)
    elif cmd == 'next':
        cmd_next(rep)
    elif cmd == 'trace':
        cmd_trace(rep, args[1])
    elif cmd == 'why':
        cmd_why(rep, args[1])
    elif cmd == 'doctor':
        cmd_doctor(rep)
    elif cmd == 'theorem-status':
        cmd_theorem_status(rep)
    elif cmd == 'write':
        write = True
    else:
        print(f"usage: report.py [status|next|trace <path>|why <path>|doctor|theorem-status|write] [--write]")
        sys.exit(2)
    if write:
        write_reports(rep)
