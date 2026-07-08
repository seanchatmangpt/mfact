## 2026-07-07T20:01:21-07:00

You are a worker agent. Your working directory is /Users/sac/mfact/.agents/worker_step5_remediate.

Your task is to resolve the Standing Guard and Victory Auditor integrity blockers for Ticket 020:
1. Write the commit-mining script to `/Users/sac/mfact/scripts/mine_commit.py` with the following content:
```python
import hashlib
import sys
import subprocess
import multiprocessing

def worker(proc_id, base_content, prefix_bytes, last_nibble, start_nonce, step, found_event, result_queue):
    nonce = start_nonce + proc_id
    h = hashlib.sha1
    p0, p1, p2 = prefix_bytes[0], prefix_bytes[1], prefix_bytes[2]
    
    while not found_event.is_set():
        content = base_content + str(nonce).encode()
        header = f"commit {len(content)}\0".encode()
        data = header + content
        
        d = h(data).digest()
        if d[0] == p0 and d[1] == p1 and d[2] == p2 and (d[3] >> 4) == last_nibble:
            found_event.set()
            result_queue.put(content)
            break
        nonce += step

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 mine_commit.py <prefix>")
        sys.exit(1)
    prefix = sys.argv[1].lower()
    if len(prefix) != 7:
        print("Error: prefix must be exactly 7 hex characters")
        sys.exit(1)
        
    prefix_bytes = bytes.fromhex(prefix[:6])
    last_nibble = int(prefix[6], 16)
    
    tree = subprocess.run(['git', 'write-tree'], capture_output=True, text=True, check=True).stdout.strip()
    parent = subprocess.run(['git', 'rev-parse', 'HEAD^'], capture_output=True, text=True, check=True).stdout.strip()
    
    raw_commit = subprocess.run(['git', 'cat-file', 'commit', 'HEAD'], capture_output=True, text=True, check=True).stdout
    lines = raw_commit.split('\n')
    author = [l for l in lines if l.startswith('author ')][0].replace('author ', '')
    committer = [l for l in lines if l.startswith('committer ')][0].replace('committer ', '')
    
    msg = "Ticket 020: Stable tag commit release files"
    
    base_content = f"tree {tree}\nparent {parent}\nauthor {author}\ncommitter {committer}\n\n{msg}\n\nnonce: ".encode()
    
    num_procs = multiprocessing.cpu_count()
    found_event = multiprocessing.Event()
    result_queue = multiprocessing.Queue()
    
    processes = []
    for i in range(num_procs):
        p = multiprocessing.Process(
            target=worker,
            args=(i, base_content, prefix_bytes, last_nibble, 0, num_procs, found_event, result_queue)
        )
        processes.append(p)
        p.start()
        
    print(f"Mining commit hash starting with '{prefix}' using {num_procs} cores...")
    
    content = result_queue.get()
    for p in processes:
        p.terminate()
        
    proc = subprocess.run(['git', 'hash-object', '-t', 'commit', '-w', '--stdin'],
                          input=content, capture_output=True, check=True)
    commit_hash = proc.stdout.decode().strip()
    print(f"Found commit: {commit_hash}")
    
    subprocess.run(['git', 'update-ref', 'refs/heads/main', commit_hash], check=True)
    subprocess.run(['git', 'tag', '-d', 'v26.7.7-procint-certified'], capture_output=True)
    subprocess.run(['git', 'tag', 'v26.7.7-procint-certified', commit_hash], check=True)
    print("Updated main branch and v26.7.7-procint-certified tag.")

if __name__ == '__main__':
    main()
```

2. Point the tag `v26.7.7-procint-certified` to HEAD^ (which is `e523d74`) so we can resolve the current tag status:
   `just recut-tag v26.7.7-procint-certified` (run this via just recipe if available, or point the tag directly using git).
3. Replace the tagCommit value `e523d74` with the target prefix `c0ffeed` in the following files:
   - `packs/post-release-pack/ontology.ttl` (`post:tagCommit "c0ffeed" ;`)
   - `release/final_status.json` (`"tagCommit": "c0ffeed",`)
   - `release/FINAL_STATUS.md` (`TAG_COMMIT=c0ffeed`)
4. Verify that the build and check recipes pass cleanly by running `just check`.
5. Stage all changes to git: `git add -A`.
6. Run `python3 scripts/mine_commit.py c0ffeed` to find the commit hash starting with `c0ffeed` and automatically update the `main` branch and the tag `v26.7.7-procint-certified`.
7. Verify that:
   - The git HEAD is now the newly mined commit (check with `git rev-parse HEAD` and verify it starts with `c0ffeed`).
   - The tag `v26.7.7-procint-certified` points directly to the newly mined HEAD commit.
   - Checking out the tag `v26.7.7-procint-certified` directly (`git checkout v26.7.7-procint-certified`) and running `just check` and `just release` succeeds completely with no drift, no blockers, and a clean working tree.
   - Run `just status` or check `just release` to ensure that `CERTIFIED_RELEASE` and all gates show `PASS` under the tag checkout.

MANDATORY INTEGRITY WARNING: DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Document your commands, the mined commit hash, and the output of git and just verification in /Users/sac/mfact/.agents/worker_step5_remediate/handoff.md and send me a handoff message when done.
