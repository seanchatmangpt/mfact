import json, re, glob, os
def step(num, desc, cond, errors=None):
    if not cond:
        print(f"[{num}/7] {desc}{'.'*(40-len(desc))}FAIL")
        return False
    print(f"[{num}/7] {desc}{'.'*(40-len(desc))}PASS")
    return True

text = open('packs/lean-math-pack/ontology.ttl', encoding='utf-8').read()
ttl_proven, ttl_stated = [], []
for b in text.split('\n\n'):
    if re.search(r'a procint:Decl\s*;', b):
        n = re.search(r'procint:declName "([^"]+)"', b)
        s = re.search(r'procint:status "([^"]+)"', b)
        a = re.search(r'procint:auditMsg "([^"]*)"', b)
        if n and s:
            if s.group(1) == 'proven' and a: ttl_proven.append(n.group(1))
            if s.group(1) == 'stated': ttl_stated.append(n.group(1))

man = json.load(open('release/release-manifest.json'))
man_proven = sorted(a['name'] for a in man['artifacts'] if a['proven'])
man_gap = sorted(set(ttl_proven) ^ set(man_proven))
stated_ok = sorted(man['statedNotProven']) == sorted(ttl_stated)
untraced = [a['name'] for a in man['artifacts'] if a['proven'] and
            not any(e['kind'] == 'axiomAudit' and e['subject'] == a['name']
                    for e in man['evidence'])]
ok4 = step(4, 'Reading release manifest', not man_gap and not untraced and stated_ok)
print("man_gap:", man_gap, "untraced:", untraced, "stated_ok:", stated_ok)
