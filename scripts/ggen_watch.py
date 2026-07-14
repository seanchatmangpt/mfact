import os
import sys
import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class GgenHandler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        self.last_run = 0

    def on_any_event(self, event):
        if event.is_directory:
            return
        if not event.src_path.endswith('.ttl'):
            return
        if "verif-status.generated.ttl" in event.src_path:
            return
        
        now = time.time()
        if now - self.last_run < 1.0:
            return
        self.last_run = now

        print(f"\n[Watcher] Detected change in: {event.src_path}")
        print("[Watcher] Running: just render && just compile-wasm")
        try:
            subprocess.run(["just", "render"], check=True)
            subprocess.run(["just", "compile-wasm"], check=True)
            print("[Watcher] Rebuild successful!\n")
        except subprocess.CalledProcessError as e:
            print(f"[Watcher] Error during rebuild: {e}\n")

def main():
    path_to_watch = os.path.abspath("packs/lean-math-pack/fragments")
    schema_path = os.path.abspath("ontology")

    print("Starting ggen watch daemon...")
    print(f"Watching: {path_to_watch} and {schema_path}")

    event_handler = GgenHandler()
    observer = Observer()
    observer.schedule(event_handler, path_to_watch, recursive=True)
    observer.schedule(event_handler, schema_path, recursive=True)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

if __name__ == "__main__":
    main()
