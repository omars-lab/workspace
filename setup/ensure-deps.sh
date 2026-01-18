#!/bin/bash

# ============================================================================
# Lightweight Runtime Dependency Checker
# ============================================================================
# 
# This script is designed to be SOURCED in loaders (e.g., loader-personal.sh)
# to provide non-blocking warnings about missing critical dependencies during
# shell startup.
#
# Usage:
#   source setup/ensure-deps.sh
#
# Differences from check-dependencies.sh:
#   - Minimal: only checks critical dependencies (python3, bc, jq, brew)
#   - Silent: only warns if critical deps are missing
#   - Non-blocking: doesn't exit, just warns (safe for shell startup)
#   - Fast: minimal overhead for runtime checks
#   - Designed to be sourced, not executed
#
# For comprehensive dependency checking/installation, see check-dependencies.sh
# ============================================================================

# Function to check if a command exists (silent)
check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a brew package is installed (silent)
check_brew() {
    check_cmd brew && brew list "$1" >/dev/null 2>&1
}

# Check critical dependencies that would cause failures
# Only warn about missing critical deps, don't fail

if ! check_cmd python3; then
    echo "Warning: python3 not found. Some functions may not work." >&2
fi

if ! check_cmd bc; then
    echo "Warning: bc not found. Duration calculations may fail." >&2
fi

if ! check_cmd jq; then
    echo "Warning: jq not found. Conda environment checks may fail." >&2
fi

# Check for brew (needed for many things)
if ! check_cmd brew; then
    echo "Warning: Homebrew not found. Many features will not work." >&2
fi
