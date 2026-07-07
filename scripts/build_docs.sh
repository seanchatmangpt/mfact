#!/usr/bin/env bash
# doc-gen4 lane — bounded, honest. Builds HTML API docs for ProcInt via the
# nested docbuild/ subproject. Writes release/docs_report.json with
# LEAN_HTML_DOCS = PASS / BLOCKED / IN_PROGRESS; never blocks the release.
set -u
ROOT=/Users/sac/mfact
DOCBUILD="$ROOT/procint/docbuild"
LAKE=/Users/sac/.elan/bin/lake
REPORT="$ROOT/release/docs_report.json"
BUDGET="${DOCS_BUDGET_SECS:-10800}"

write_report() { # status detail
  python3 -c "import json,sys; json.dump({'schema':'mfact.docs_report.v1','LEAN_HTML_DOCS':sys.argv[1],'detail':sys.argv[2]}, open('$REPORT','w'), indent=2)" "$1" "$2"
  echo "docs: $1 — $2"
}

write_report IN_PROGRESS "doc-gen4 v4.31.0 update + ProcInt:docs build running"
cd "$DOCBUILD" || { write_report BLOCKED "docbuild/ missing"; exit 0; }

start=$(date +%s)
LOG="$ROOT/release/docs_build.log"
{
  # No git remote by dry-run doctrine; link sources as local files.
  export DOCGEN_SRC=file
  MATHLIB_NO_CACHE_ON_UPDATE=1 "$LAKE" update doc-gen4 &&
  "$LAKE" build ProcInt:docs
} > "$LOG" 2>&1 &
pid=$!
while kill -0 "$pid" 2>/dev/null; do
  now=$(date +%s)
  if [ $((now - start)) -gt "$BUDGET" ]; then
    kill "$pid" 2>/dev/null
    write_report BLOCKED "budget ${BUDGET}s exceeded (doc pass over the Mathlib closure is multi-hour); partial log at release/docs_build.log"
    exit 0
  fi
  sleep 30
done
if wait "$pid" && [ -d "$DOCBUILD/.lake/build/doc" ]; then
  n=$(find "$DOCBUILD/.lake/build/doc" -name '*.html' | wc -l | tr -d ' ')
  write_report PASS "ProcInt:docs built: $n HTML pages at procint/docbuild/.lake/build/doc"
else
  write_report BLOCKED "doc-gen4 build failed: $(tail -2 "$LOG" | tr '\n' ' ' | head -c 200)"
fi
