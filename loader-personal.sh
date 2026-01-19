#!/bin/zsh

# loader-personal.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

# Load common.sh FIRST - it provides _loader_msg and terminal detection
# common.sh is self-contained and doesn't depend on anything from this file
source ${CURRENT_DIR}/common.sh 2>/dev/null

_loader_msg "start" "🔧" "Setting up Homebrew tap"
which brew >/dev/null 2>&1 && ( ( brew tap 2>/dev/null | grep -q omars-lab) || brew tap omars-lab/tap >/dev/null 2>&1 )
_loader_msg "done" "🔧" "Homebrew tap"

# Check dependencies by default (set CHECK_DEPS=false to disable)
# This only warns, doesn't fail, so it's safe to enable by default
if [ "${CHECK_DEPS:-true}" != "false" ]; then
    _loader_msg "start" "🔍" "Checking dependencies"
    source ${CURRENT_DIR}/setup/ensure-deps.sh 2>/dev/null || true
    _loader_msg "done" "🔍" "Dependencies checked"
fi

# eval "$(cat ${CURRENT_DIR}/variables.sh)"
_loader_msg "start" "📝" "Loading variables"
source ${CURRENT_DIR}/loader-variables.sh 2>/dev/null
_loader_msg "done" "📝" "Variables loaded"

# common.sh already loaded at the top - no need to load again

_loader_msg "start" "🌍" "Loading environment manager"
source ${CURRENT_DIR}/envmgr/envmgr.sh 2>/dev/null && _loader_msg "done" "🌍" "Environment manager" || _loader_msg "skip" "🌍" "Environment manager"

_loader_msg "start" "🔗" "Loading IFTTT functions"
source ${CURRENT_DIR}/ifttt/maker.sh 2>/dev/null
source ${CURRENT_DIR}/ifttt/functions.sh 2>/dev/null
_loader_msg "done" "🔗" "IFTTT functions"

_loader_msg "start" "🎨" "Loading theme"
source ${CURRENT_DIR}/themes/theme.sh 2>/dev/null && _loader_msg "done" "🎨" "Theme" || _loader_msg "skip" "🎨" "Theme"

_loader_msg "start" "📝" "Reloading variables"
source ${CURRENT_DIR}/loader-variables.sh 2>/dev/null
_loader_msg "done" "📝" "Variables reloaded"

_loader_msg "start" "⚡" "Loading personal functions"
recursive_source ${CURRENT_DIR}/functions-personal 2>/dev/null
_loader_msg "done" "⚡" "Personal functions"
