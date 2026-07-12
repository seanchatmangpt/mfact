## 2026-07-08T01:10:09Z
<USER_REQUEST>
You are a worker agent. Your working directory is /Users/sac/mfact/.agents/worker_step3.
Your task is to implement the Step 3: Ticket 018 praxis-graphlaw Benchmark Import:

1. Run the benchmark and test commands on the `/Users/sac/praxis` workspace and capture their raw stdout/stderr outputs. Save these captured outputs in `/Users/sac/mfact/rslab/experiments/praxis_graphlaw/raw/` with the following names:
   - `bench_graphlaw.txt` (output of `cargo bench -p praxis-graphlaw`)
   - `bench_root.txt` (output of `cargo bench`)
   - `test_graphlaw.txt` (output of `cargo test -p praxis-graphlaw`)
   - `test_e2e.txt` (output of `cargo test -p ggen --test graphlaw_e2e`)
   - `toolchain_context.txt` (captures `rustc --version`, `cat rust-toolchain.toml`, and `uname -a`)
   - `command_log.txt` (records the exact sequence of commands executed, their exit codes, and durations/logs)

Note: For file hashing (b3sum), if the `b3sum` binary is not installed on the system, you can compute the BLAKE3 hash using python:
`python3 -c "import hashlib; print(hashlib.blake3(open('path', 'rb').read()).hexdigest())"`

2. Construct the receipt file `/Users/sac/mfact/rslab/receipts/praxis_graphlaw_benchmark_receipt.toml`:
   - Must contain the required fields: `builder` (e.g. `"ticket_018"`), `experiment_id = "praxis_graphlaw"`, `praxis_commit` (git hash of `/Users/sac/praxis`), `command_log_path`, `command_log_hash`, `files` (array of `{path, hash}` objects for each of the 5 raw files above), `toolchain` (object: `rustc_version`, `toolchain_pin` = `"nightly-2026-04-15"`, `os`), `evidence` (object: `{declared: true, extracted: true}`), and `caveats` (array of strings, detailing the mixed harnesses, lack of profiler tooling, and any build/test issues or warnings encountered).
   - Ensure there is NO wall-clock timestamp in the receipt body.

3. Verify that `/Users/sac/praxis` remains completely clean and unmodified (check with `git status --short`).

4. Validate the generated receipt against `/Users/sac/mfact/rslab/schemas/benchmark_result.schema.json` using Python:
   ```python
   # Script to run/verify
   import json, tomllib
   from jsonschema import validate
   # etc.
   ```
   (Make sure to handle the validation in python and ensure it passes cleanly).

5. Verify that `just regen-check` passes successfully.

6. Commit the new imported raw files, command log, toolchain context, and receipt using `just commit "Ticket 018: praxis-graphlaw Benchmark Import"`.

MANDATORY INTEGRITY WARNING: DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Document your commands, capture logs, and schema verification results in /Users/sac/mfact/.agents/worker_step3/handoff.md and send me a handoff message when done.
</USER_REQUEST>
