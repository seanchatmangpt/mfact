import json
import os
import re

manifest_path = "/Users/sac/mfact/procint/lake-manifest.json"
packages_dir = "/Users/sac/mfact/procint/.lake/packages"

with open(manifest_path, 'r') as f:
    manifest = json.load(f)

for package in manifest.get('packages', []):
    if package.get('type') == 'git':
        name = package.get('name')
        url = package.get('url')
        config_path = os.path.join(packages_dir, name, '.git', 'config')
        if os.path.exists(config_path):
            with open(config_path, 'r') as cf:
                content = cf.read()
            # Replace url = ... with url = {url}
            new_content = re.sub(r'url\s*=\s*.*', f'url = {url}', content)
            with open(config_path, 'w') as cf:
                cf.write(new_content)
            print(f"Updated config for {name} to URL: {url}")
        else:
            print(f"No config found for {name} at {config_path}")
