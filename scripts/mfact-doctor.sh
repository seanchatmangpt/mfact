#!/usr/bin/env bash
set -euo pipefail

FAIL=0
echo "Running MFACT Doctor..."

# 1. Vite node:worker_threads Rollup Crashes
echo "[1/4] Checking Vite configuration for dummyNode.js bypass..."
VITE_CONF=$(find /Users/sac/mfact -name "vite.config.*" 2>/dev/null | head -n 1 || true)
if [ -n "$VITE_CONF" ]; then
    if grep -q "dummyNode.js" "$VITE_CONF"; then
        echo "ERROR: dummyNode.js bypass detected in $VITE_CONF. This might mask missing vector engine logic."
        FAIL=1
    else
        echo "OK: No dummyNode.js bypass found in Vite config."
    fi
else
    echo "WARN: vite.config.ts/js not found."
fi

# 2. Lean 4 Mathlib 4 ReflTransGen Arity Regressions
echo "[2/4] Verifying Lean 4 pinned to v4.31.0..."
if grep -q "v4.31.0" /Users/sac/mfact/lean-toolchain; then
    echo "OK: lean-toolchain is pinned to v4.31.0."
else
    echo "ERROR: lean-toolchain not pinned to v4.31.0."
    FAIL=1
fi

MANIFEST=$(find /Users/sac/mfact -name "lake-manifest.json" 2>/dev/null | head -n 1 || true)
if [ -n "$MANIFEST" ]; then
    echo "OK: lake-manifest.json found at $MANIFEST."
else
    echo "ERROR: lake-manifest.json not found."
    FAIL=1
fi

# 3. Cargo affidavit Unresolved Imports
echo "[3/4] Checking for Cargo E0432 errors involving affidavit or wasm4pm_compat..."
cd /Users/sac/mfact
set +e
CARGO_OUT=$(cargo check --workspace --message-format=json 2>/dev/null)
ERRORS=$(echo "$CARGO_OUT" | grep '"code":{"code":"E0432"' | grep -E 'affidavit|wasm4pm_compat' || true)
set -e
if [ -n "$ERRORS" ]; then
    echo "ERROR: E0432 unresolved imports for affidavit/wasm4pm_compat found."
    FAIL=1
else
    echo "OK: No unresolved imports (E0432) for affidavit/wasm4pm_compat."
fi

# 4. Fake "Math Cosplay" Topological Domains
echo "[4/4] Scanning for Fake 'Math Cosplay' Topological Domains..."
if [ -d "/Users/sac/mfact/research-papers/" ]; then
    SPOOFED_DOMAINS=("terminal_breakdown" "bio_signals" "combinatorial_topology" "floquet_photonic" "hyperdimensional_cognitive" "minimal_measures" "ortac_plus" "pair_correlation" "revops_turbulence" "scalar_dissipation" "signal_criticality" "smfdcca" "sparse_chaos_diagnostic" "star_graphs" "weighted_random_networks")
    
    DOMAIN_FAIL=0
    for DOMAIN in "${SPOOFED_DOMAINS[@]}"; do
        if [ -d "/Users/sac/mfact/research-papers/$DOMAIN" ]; then
            if ! find "/Users/sac/mfact/research-papers/$DOMAIN" -name "Thermo.lean" 2>/dev/null | grep -q .; then
                echo "ERROR: Fake Math Cosplay domain '$DOMAIN' found without a Thermo.lean file."
                DOMAIN_FAIL=1
                FAIL=1
            fi
        fi
    done
    if [ $DOMAIN_FAIL -eq 0 ]; then
        echo "OK: No unverified fake Math Cosplay domains found."
    fi
else
    echo "WARN: /Users/sac/mfact/research-papers/ not found."
fi

if [ $FAIL -eq 1 ]; then
    echo "Diagnostic checks failed."
    exit 1
else
    echo "Diagnostic checks passed."
    exit 0
fi
