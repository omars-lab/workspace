#!/bin/bash

# ============================================================================
# Comprehensive Dependency Checker
# ============================================================================
# 
# This is a standalone script for manually checking and installing dependencies.
# It provides detailed, colored output showing what's installed, missing, or optional.
#
# Usage:
#   ./setup/check-dependencies.sh           # Check dependencies
#   ./setup/check-dependencies.sh --install # Check and install missing deps
#
# Differences from ensure-deps.sh:
#   - Comprehensive: checks ALL dependencies (required + optional)
#   - Detailed output: colored status for each dependency
#   - Can auto-install: use --install flag to install missing deps
#   - Designed to be executed manually, not sourced
#
# For lightweight runtime checks during shell startup, see ensure-deps.sh
# ============================================================================

# Don't use set -e as we want to continue checking even if some checks fail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track status
MISSING_DEPS=()
OPTIONAL_MISSING=()

# Function to check if a command exists
check_command() {
    local cmd=$1
    local name=${2:-$cmd}
    local optional=${3:-false}
    
    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $name is installed"
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo -e "${YELLOW}⚠${NC} $name is not installed (optional)"
            OPTIONAL_MISSING+=("$name")
        else
            echo -e "${RED}✗${NC} $name is not installed"
            MISSING_DEPS+=("$name")
        fi
        return 1
    fi
}

# Function to check if a directory exists
check_directory() {
    local dir=$1
    local name=${2:-$dir}
    local optional=${3:-false}
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $name directory exists"
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo -e "${YELLOW}⚠${NC} $name directory not found (optional)"
            OPTIONAL_MISSING+=("$name")
        else
            echo -e "${RED}✗${NC} $name directory not found"
            MISSING_DEPS+=("$name")
        fi
        return 1
    fi
}

# Function to check if a file exists
check_file() {
    local file=$1
    local name=${2:-$file}
    local optional=${3:-false}
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $name file exists"
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo -e "${YELLOW}⚠${NC} $name file not found (optional)"
            OPTIONAL_MISSING+=("$name")
        else
            echo -e "${RED}✗${NC} $name file not found"
            MISSING_DEPS+=("$name")
        fi
        return 1
    fi
}

# Function to check if a brew package is installed
check_brew_package() {
    local pkg=$1
    local name=${2:-$pkg}
    local optional=${3:-false}
    
    if command -v brew >/dev/null 2>&1; then
        if brew list "$pkg" >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} $name (brew) is installed"
            return 0
        else
            if [ "$optional" = "true" ]; then
                echo -e "${YELLOW}⚠${NC} $name (brew) is not installed (optional)"
                OPTIONAL_MISSING+=("$name")
            else
                echo -e "${RED}✗${NC} $name (brew) is not installed"
                MISSING_DEPS+=("$name")
            fi
            return 1
        fi
    else
        echo -e "${YELLOW}⚠${NC} Homebrew not installed, cannot check $name"
        if [ "$optional" != "true" ]; then
            MISSING_DEPS+=("$name")
        fi
        return 1
    fi
}

# Function to install missing dependencies (if --install flag is provided)
install_missing() {
    if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
        echo -e "\n${GREEN}All required dependencies are installed!${NC}"
        return 0
    fi
    
    echo -e "\n${YELLOW}Missing required dependencies:${NC}"
    for dep in "${MISSING_DEPS[@]}"; do
        echo "  - $dep"
    done
    
    if [ "$INSTALL_MISSING" = "true" ]; then
        echo -e "\n${YELLOW}Attempting to install missing dependencies...${NC}"
        
        # Install Homebrew if missing
        if ! command -v brew >/dev/null 2>&1; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        # Install brew packages
        for dep in "${MISSING_DEPS[@]}"; do
            case "$dep" in
                "jq")
                    brew install jq
                    ;;
                "autojump")
                    brew install autojump
                    ;;
                "asdf")
                    brew install asdf
                    ;;
                "nvm")
                    brew install nvm
                    ;;
                "python3"|"Python 3")
                    brew install python
                    ;;
                "bc")
                    brew install bc
                    ;;
                *)
                    echo -e "${YELLOW}No auto-installation available for: $dep${NC}"
                    ;;
            esac
        done
    else
        echo -e "\n${YELLOW}Run with --install flag to automatically install missing dependencies${NC}"
        echo -e "Or run: ${GREEN}./setup/check-dependencies.sh --install${NC}"
    fi
}

# Parse arguments
INSTALL_MISSING=false
if [ "$1" = "--install" ]; then
    INSTALL_MISSING=true
fi

echo "Checking workspace dependencies..."
echo "=================================="

# Core system dependencies
echo -e "\n${YELLOW}Core System:${NC}"
check_command "brew" "Homebrew"
check_command "python3" "Python 3"
check_command "bc" "bc (calculator)"
check_command "jq" "jq (JSON processor)"

# Shell and terminal
echo -e "\n${YELLOW}Shell & Terminal:${NC}"
check_directory "${HOME}/.oh-my-zsh" "Oh My Zsh"
check_directory "${HOME}/.oh-my-zsh/custom/plugins/antigen" "Antigen plugin"
check_directory "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions" "zsh-completions plugin"
if command -v brew >/dev/null 2>&1; then
    BREW_PREFIX=$(brew --prefix 2>/dev/null || echo "")
    if [ -n "$BREW_PREFIX" ] && [ -f "$BREW_PREFIX/etc/profile.d/autojump.sh" ]; then
        check_file "$BREW_PREFIX/etc/profile.d/autojump.sh" "Auto Jump" "true"
    else
        check_brew_package "autojump" "Auto Jump" "true"
    fi
else
    echo -e "${YELLOW}⚠${NC} Auto Jump (brew) - Homebrew not installed"
    OPTIONAL_MISSING+=("Auto Jump")
fi
check_command "iterm2_shell_integration.zsh" "iTerm2 integration" "true"

# Version managers
echo -e "\n${YELLOW}Version Managers:${NC}"
check_directory "${HOME}/.asdf" "ASDF" "true" || check_brew_package "asdf" "ASDF" "true"
check_directory "${NVM_DIR:-${HOME}/.nvm}" "NVM" "true" || check_brew_package "nvm" "NVM" "true"

# Python environment
echo -e "\n${YELLOW}Python Environment:${NC}"
# Try to find conda in common locations
CONDA_HOME=""
if [ -n "${DIR_CONDA_HOME:-}" ] && [ -d "${DIR_CONDA_HOME}" ]; then
    CONDA_HOME="${DIR_CONDA_HOME}"
elif [ -d "${HOME}/miniconda3" ]; then
    CONDA_HOME="${HOME}/miniconda3"
elif [ -d "/usr/local/bin/miniconda3" ]; then
    CONDA_HOME="/usr/local/bin/miniconda3"
fi

if [ -n "$CONDA_HOME" ] && [ -d "$CONDA_HOME" ]; then
    check_directory "$CONDA_HOME" "Conda"
    check_file "$CONDA_HOME/bin/conda" "Conda binary"
else
    echo -e "${YELLOW}⚠${NC} Conda directory not found (expected in ~/miniconda3 or /usr/local/bin/miniconda3)"
    OPTIONAL_MISSING+=("Conda")
fi

# Docker
echo -e "\n${YELLOW}Docker:${NC}"
check_command "docker" "Docker" "true"
check_directory "${HOME}/.docker/completions" "Docker completions" "true"

# Optional dependencies
echo -e "\n${YELLOW}Optional:${NC}"
check_directory "${CAREER_WORKSPACE_DIR:-}" "Career workspace" "true"

# Summary
echo -e "\n=================================="
if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
    echo -e "${GREEN}All required dependencies are installed!${NC}"
    if [ ${#OPTIONAL_MISSING[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}Optional dependencies not installed:${NC}"
        for dep in "${OPTIONAL_MISSING[@]}"; do
            echo "  - $dep"
        done
    fi
    exit 0
else
    install_missing
    exit 1
fi
