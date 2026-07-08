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
