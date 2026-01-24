#!/bin/zsh

# loader-personal.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

# Load common.sh FIRST - it provides _loader_msg and terminal detection
# common.sh is self-contained and doesn't depend on anything from this file
source ${CURRENT_DIR}/common.sh 2>/dev/null

# Ensure ~/.claude/skills symlink exists
if [ ! -L ~/.claude/skills ]; then
    _loader_msg "start" "🔗" "Creating ~/.claude/skills symlink"
    WORKSPACE_SKILLS_DIR="${CURRENT_DIR}/.claude/skills"
    if [ -d "${WORKSPACE_SKILLS_DIR}" ]; then
        mkdir -p ~/.claude 2>/dev/null
        # Backup existing file/directory if it exists and is not a symlink
        if [ -e ~/.claude/skills ] && [ ! -L ~/.claude/skills ]; then
            mkdir -p ~/.claude/.backup 2>/dev/null
            mv ~/.claude/skills ~/.claude/.backup/skills.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
        fi
        ln -sf "${WORKSPACE_SKILLS_DIR}" ~/.claude/skills 2>/dev/null && \
            _loader_msg "done" "🔗" "Creating ~/.claude/skills symlink" || \
            _loader_msg "skip" "🔗" "Creating ~/.claude/skills symlink"
    else
        _loader_msg "skip" "🔗" "Creating ~/.claude/skills symlink"
    fi
fi

# Ensure ~/.claude/settings.json symlink exists
if [ ! -L ~/.claude/settings.json ]; then
    _loader_msg "start" "🔗" "Creating ~/.claude/settings.json symlink"
    WORKSPACE_SETTINGS_FILE="${CURRENT_DIR}/.claude/settings.json"
    if [ -f "${WORKSPACE_SETTINGS_FILE}" ]; then
        mkdir -p ~/.claude 2>/dev/null
        # Backup existing file if it exists and is not a symlink
        if [ -e ~/.claude/settings.json ] && [ ! -L ~/.claude/settings.json ]; then
            mkdir -p ~/.claude/.backup 2>/dev/null
            mv ~/.claude/settings.json ~/.claude/.backup/settings.json.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
        fi
        ln -sf "${WORKSPACE_SETTINGS_FILE}" ~/.claude/settings.json 2>/dev/null && \
            _loader_msg "done" "🔗" "Creating ~/.claude/settings.json symlink" || \
            _loader_msg "skip" "🔗" "Creating ~/.claude/settings.json symlink"
    else
        _loader_msg "skip" "🔗" "Creating ~/.claude/settings.json symlink"
    fi
fi

# Ensure ~/.claude/scripts symlink exists
if [ ! -L ~/.claude/scripts ]; then
    _loader_msg "start" "🔗" "Creating ~/.claude/scripts symlink"
    WORKSPACE_SCRIPTS_DIR="${CURRENT_DIR}/.claude/scripts"
    if [ -d "${WORKSPACE_SCRIPTS_DIR}" ]; then
        mkdir -p ~/.claude 2>/dev/null
        # Backup existing directory if it exists and is not a symlink
        if [ -e ~/.claude/scripts ] && [ ! -L ~/.claude/scripts ]; then
            mkdir -p ~/.claude/.backup 2>/dev/null
            mv ~/.claude/scripts ~/.claude/.backup/scripts.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
        fi
        ln -sf "${WORKSPACE_SCRIPTS_DIR}" ~/.claude/scripts 2>/dev/null && \
            _loader_msg "done" "🔗" "Creating ~/.claude/scripts symlink" || \
            _loader_msg "skip" "🔗" "Creating ~/.claude/scripts symlink"
    else
        _loader_msg "skip" "🔗" "Creating ~/.claude/scripts symlink"
    fi
fi

_loader_msg "start" "🔧" "Setting up Homebrew tap"
which brew >/dev/null 2>&1 && ( ( brew tap 2>/dev/null | grep -q omars-lab) || brew tap omars-lab/tap >/dev/null 2>&1 )
_loader_msg "done" "🔧" "Setting up Homebrew tap"

# Check dependencies by default (set CHECK_DEPS=false to disable)
# This only warns, doesn't fail, so it's safe to enable by default
if [ "${CHECK_DEPS:-true}" != "false" ]; then
    _loader_msg "start" "🔍" "Checking dependencies"
    source ${CURRENT_DIR}/setup/ensure-deps.sh 2>/dev/null || true
    _loader_msg "done" "🔍" "Checking dependencies"
fi

# eval "$(cat ${CURRENT_DIR}/variables.sh)"
_loader_msg "start" "📝" "Loading variables"
source ${CURRENT_DIR}/loader-variables.sh 2>/dev/null
_loader_msg "done" "📝" "Loading variables"

# common.sh already loaded at the top - no need to load again

_loader_msg "start" "🌍" "Loading environment manager"
source ${CURRENT_DIR}/envmgr/envmgr.sh 2>/dev/null && _loader_msg "done" "🌍" "Loading environment manager" || _loader_msg "skip" "🌍" "Loading environment manager"

_loader_msg "start" "🔗" "Loading IFTTT functions"
source ${CURRENT_DIR}/ifttt/maker.sh 2>/dev/null
source ${CURRENT_DIR}/ifttt/functions.sh 2>/dev/null
_loader_msg "done" "🔗" "Loading IFTTT functions"

_loader_msg "start" "🎨" "Loading theme"
source ${CURRENT_DIR}/themes/theme.sh 2>/dev/null && _loader_msg "done" "🎨" "Loading theme" || _loader_msg "skip" "🎨" "Loading theme"

_loader_msg "start" "📝" "Reloading variables"
source ${CURRENT_DIR}/loader-variables.sh 2>/dev/null
_loader_msg "done" "📝" "Reloading variables"

_loader_msg "start" "⚡" "Loading personal functions"
recursive_source ${CURRENT_DIR}/functions-personal 2>/dev/null
_loader_msg "done" "⚡" "Loading personal functions"
