import os
import re

base_dir = "/Users/sac/mfact/research-papers"
papers = [d for d in os.listdir(base_dir) if os.path.isdir(os.path.join(base_dir, d)) and not d.startswith('.')]

for paper in papers:
    ttl_path = os.path.join(base_dir, paper, "ontology.ttl")
    if not os.path.exists(ttl_path):
        continue
        
    with open(ttl_path, 'r') as f:
        content = f.read()
        
    def replacer(match):
        target = match.group(1)
        
        target_found = False
        target_name = target.split('.')[-1]
        
        for root, dirs, files in os.walk(os.path.join(base_dir, paper)):
            if '.lake' in root:
                continue
            for file in files:
                if not file.endswith(".lean"):
                    continue
                with open(os.path.join(root, file), 'r') as lf:
                    lean_code = lf.read()
                
                clean_lean = re.sub(r'/-.*?-/|--.*?\n', '', lean_code, flags=re.DOTALL)
                
                if re.search(r'\bsorry\b', clean_lean):
                    continue
                    
                if target_name + ".lean" == file:
                    if 'theorem ' in clean_lean or 'def ' in clean_lean or 'lemma ' in clean_lean:
                        target_found = True
                        break
                else:
                    if re.search(r'\b(theorem|lemma|def|abbrev)\s+' + re.escape(target_name) + r'\b', clean_lean):
                        target_found = True
                        break
        
        new_val = '"true"' if target_found else '"false"'
        return f'ggen:isMathematicallyAdmitted {new_val} ;\n    ggen:leanProofTarget "{target}"'

    new_content = re.sub(
        r'ggen:isMathematicallyAdmitted\s+"(?:true|false)"\s*;\s*ggen:leanProofTarget\s+"([^"]+)"',
        replacer,
        content
    )
    
    if new_content != content:
        with open(ttl_path, 'w') as f:
            f.write(new_content)
        print(f"Aligned {ttl_path}")

print("Alignment complete.")
