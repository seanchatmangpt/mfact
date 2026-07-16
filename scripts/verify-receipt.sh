#!/usr/bin/env bash

# Robust error handling: see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Generate a timestamped receipt of a verification run (build + lint).
#
# This script runs `lake build <target>` and `lake exe lint-style --procint Mathlib.Init`,
# captures their output and exit codes, and writes a receipt file to `.verif-toolchain/receipts/`
# as evidence that the checks were run. The receipt includes git state, timestamps, and the
# exact commands run, so it can be cited in ALIVE/PARTIAL_ALIVE/BLOCKED standing claims.
#
# Usage:
#   scripts/verify-receipt.sh [LAKE_TARGET]
#
# Example:
#   scripts/verify-receipt.sh                # builds ProcInt (default)
#   scripts/verify-receipt.sh procint        # builds procint
#   scripts/verify-receipt.sh all            # builds all
#
# Output: Writes to `.verif-toolchain/receipts/receipt-<timestamp>.txt`
#         Exits 0 if both build and lint succeeded; 1 if either failed.

LAKE_TARGET="${1:-all}"
RECEIPT_DIR=".verif-toolchain/receipts"
TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
RECEIPT_FILE="${RECEIPT_DIR}/receipt-${TIMESTAMP}.txt"

# Ensure receipt directory exists
mkdir -p "${RECEIPT_DIR}"

# Capture state
GIT_HEAD=$(git rev-parse HEAD 2>/dev/null || echo "DETACHED")
GIT_DIRTY=$(if git status --porcelain | grep -q . 2>/dev/null; then echo "DIRTY"; else echo "CLEAN"; fi)

# Temporary files for capturing output
BUILD_OUT=$(mktemp)
LINT_OUT=$(mktemp)
FINAL_EXIT=0
trap "rm -f ${BUILD_OUT} ${LINT_OUT}" EXIT

# Run build (only if a non-default target was requested)
if [ "${LAKE_TARGET}" != "all" ]; then
  echo ">>> Running: lake build ${LAKE_TARGET}" | tee -a "${RECEIPT_FILE}"
  BUILD_EXIT=0
  lake build "${LAKE_TARGET}" > "${BUILD_OUT}" 2>&1 || BUILD_EXIT=$?
  cat "${BUILD_OUT}" >> "${RECEIPT_FILE}"
else
  echo ">>> Running: cd procint && lake build ProcInt" | tee -a "${RECEIPT_FILE}"
  BUILD_EXIT=0
  (cd procint && lake build ProcInt > "${BUILD_OUT}" 2>&1) || BUILD_EXIT=$?
  cat "${BUILD_OUT}" >> "${RECEIPT_FILE}"
fi

# Run lint
echo "" | tee -a "${RECEIPT_FILE}"
echo ">>> Running: lake exe lint-style --procint Mathlib.Init" | tee -a "${RECEIPT_FILE}"
LINT_EXIT=0
lake exe lint-style --procint Mathlib.Init > "${LINT_OUT}" 2>&1 || LINT_EXIT=$?
cat "${LINT_OUT}" >> "${RECEIPT_FILE}"

# Write receipt header and summary
{
  echo ""
  echo "=== RECEIPT SUMMARY ==="
  echo "Timestamp: ${TIMESTAMP}"
  echo "Git HEAD: ${GIT_HEAD}"
  echo "Git Status: ${GIT_DIRTY}"
  echo "Lake target: ${LAKE_TARGET}"
  echo "Build exit code: ${BUILD_EXIT}"
  echo "Lint exit code: ${LINT_EXIT}"

  if [ "${BUILD_EXIT}" -eq 0 ] && [ "${LINT_EXIT}" -eq 0 ]; then
    echo "Overall: PASS"
    FINAL_EXIT=0
  else
    echo "Overall: FAIL"
    FINAL_EXIT=1
  fi
} | tee -a "${RECEIPT_FILE}"

# Print receipt path for reference
echo ""
echo "Receipt written to: ${RECEIPT_FILE}"
echo ""

exit "${FINAL_EXIT}"
