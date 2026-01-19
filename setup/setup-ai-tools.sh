#!/bin/bash

# Setup script for AI CLI tools
# Ensures all AI tools are properly configured (MCP tools, endpoints, prompts repo, etc.)

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WORKSPACE_DIR="$(dirname "${DIR}")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Status tracking
ISSUES=0
WARNINGS=0

echo "=== AI Tools Configuration Setup ==="
echo ""

# Function to create timestamped backup before modifying config
backup_config_file() {
    local config_file="$1"
    
    if [ ! -f "${config_file}" ]; then
        return 0  # File doesn't exist, nothing to backup
    fi
    
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="${config_file}.backup.${timestamp}"
    
    cp "${config_file}" "${backup_file}" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Created backup: ${backup_file}"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} Failed to create backup for ${config_file}"
        return 1
    fi
}

# Function to safely modify JSON config with backup
modify_json_config() {
    local config_file="$1"
    local jq_expression="$2"
    local description="$3"
    
    if [ ! -f "${config_file}" ]; then
        echo -e "${RED}✗${NC} Config file not found: ${config_file}"
        return 1
    fi
    
    # Create backup before modifying
    backup_config_file "${config_file}"
    
    # Create temporary file for modification
    local temp_file=$(mktemp)
    jq "${jq_expression}" "${config_file}" > "${temp_file}" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        mv "${temp_file}" "${config_file}"
        echo -e "${GREEN}✓${NC} Updated ${description}"
        return 0
    else
        rm -f "${temp_file}"
        echo -e "${RED}✗${NC} Failed to update ${description}"
        return 1
    fi
}

# Function to check if command exists
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is not installed"
        ((ISSUES++))
        return 1
    fi
}

# Function to check if file/directory exists
check_path() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}✓${NC} $2 exists: $1"
        return 0
    else
        echo -e "${RED}✗${NC} $2 not found: $1"
        ((ISSUES++))
        return 1
    fi
}

# Function to check JSON config
check_json_config() {
    local config_file="$1"
    local key="$2"
    local description="$3"
    
    if [ -f "${config_file}" ]; then
        if jq -e ".${key}" "${config_file}" >/dev/null 2>&1; then
            local value=$(jq -r ".${key}" "${config_file}" 2>/dev/null)
            if [ -n "${value}" ] && [ "${value}" != "null" ]; then
                echo -e "${GREEN}✓${NC} ${description}: ${value}"
                return 0
            else
                echo -e "${YELLOW}⚠${NC} ${description} is empty or null"
                ((WARNINGS++))
                return 1
            fi
        else
            echo -e "${YELLOW}⚠${NC} ${description} not found in ${config_file}"
            ((WARNINGS++))
            return 1
        fi
    else
        echo -e "${RED}✗${NC} Config file not found: ${config_file}"
        ((ISSUES++))
        return 1
    fi
}

echo "## Checking CLI Tools Installation"
echo ""

# Check npm-based tools
check_command "npm"
if [ $? -eq 0 ]; then
    echo "  Checking npm global packages..."
    
    # Check @google/gemini-cli
    if npm list -g @google/gemini-cli >/dev/null 2>&1; then
        echo -e "    ${GREEN}✓${NC} @google/gemini-cli is installed"
    else
        echo -e "    ${RED}✗${NC} @google/gemini-cli is not installed"
        echo "    Run: npm install -g @google/gemini-cli"
        ((ISSUES++))
    fi
    
    # Check @anthropic-ai/claude-code
    if npm list -g @anthropic-ai/claude-code >/dev/null 2>&1; then
        echo -e "    ${GREEN}✓${NC} @anthropic-ai/claude-code is installed"
    else
        echo -e "    ${RED}✗${NC} @anthropic-ai/claude-code is not installed"
        echo "    Run: npm install -g @anthropic-ai/claude-code"
        ((ISSUES++))
    fi
    
    # Check @musistudio/claude-code-router
    if npm list -g @musistudio/claude-code-router >/dev/null 2>&1; then
        echo -e "    ${GREEN}✓${NC} @musistudio/claude-code-router is installed"
    else
        echo -e "    ${RED}✗${NC} @musistudio/claude-code-router is not installed"
        echo "    Run: npm install -g @musistudio/claude-code-router"
        ((ISSUES++))
    fi
fi

# Check ollama
check_command "ollama"

# Check LM Studio (via PATH)
if command -v lms >/dev/null 2>&1 || [ -d "${HOME}/.lmstudio" ]; then
    echo -e "${GREEN}✓${NC} LM Studio is available"
else
    echo -e "${YELLOW}⚠${NC} LM Studio not found (optional)"
    ((WARNINGS++))
fi

echo ""
echo "## Checking Configuration Files"
echo ""

# Check Claude configuration
check_path "${HOME}/.claude" "Claude config directory"
if [ -f "${HOME}/.claude/settings.json" ]; then
    check_json_config "${HOME}/.claude/settings.json" ".enabledPlugins" "Claude plugins"
fi

# Check Claude Code Router configuration
check_path "${HOME}/.claude-code-router/config.json" "Claude Code Router config"
if [ -f "${HOME}/.claude-code-router/config.json" ]; then
    echo "  Checking Claude Code Router providers..."
    if jq -e '.Providers' "${HOME}/.claude-code-router/config.json" >/dev/null 2>&1; then
        local provider_count=$(jq '.Providers | length' "${HOME}/.claude-code-router/config.json" 2>/dev/null)
        if [ "${provider_count}" -gt 0 ]; then
            echo -e "    ${GREEN}✓${NC} Found ${provider_count} provider(s)"
            # Check for ollama endpoint
            if jq -e '.Providers[] | select(.name == "ollama")' "${HOME}/.claude-code-router/config.json" >/dev/null 2>&1; then
                local ollama_url=$(jq -r '.Providers[] | select(.name == "ollama") | .api_base_url' "${HOME}/.claude-code-router/config.json" 2>/dev/null)
                if [ -n "${ollama_url}" ] && [ "${ollama_url}" != "null" ]; then
                    echo -e "      ${GREEN}✓${NC} Ollama endpoint configured: ${ollama_url}"
                else
                    echo -e "      ${YELLOW}⚠${NC} Ollama endpoint not configured"
                    ((WARNINGS++))
                fi
            else
                echo -e "      ${YELLOW}⚠${NC} Ollama provider not found"
                ((WARNINGS++))
            fi
        else
            echo -e "    ${YELLOW}⚠${NC} No providers configured"
            ((WARNINGS++))
        fi
    fi
fi

# Check Gemini configuration
check_path "${HOME}/.gemini" "Gemini config directory"

# Check Cursor configuration
check_path "${HOME}/.cursor" "Cursor config directory"

# Check Codex configuration
check_path "${HOME}/.codex" "Codex config directory"
if [ -f "${HOME}/.codex/config.toml" ]; then
    echo -e "${GREEN}✓${NC} Codex config.toml exists"
    # Check if prompts repo is configured
    if grep -q "prompts" "${HOME}/.codex/config.toml" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Prompts configuration found in config.toml"
    else
        echo -e "  ${YELLOW}⚠${NC} Prompts configuration not found"
        ((WARNINGS++))
    fi
fi

echo ""
echo "## Checking Prompts Repository"
echo ""

# Check if prompts directory exists and is a git repo
if [ -d "${HOME}/.codex/prompts" ]; then
    echo -e "${GREEN}✓${NC} Prompts directory exists: ${HOME}/.codex/prompts"
    if [ -d "${HOME}/.codex/prompts/.git" ]; then
        echo -e "  ${GREEN}✓${NC} Prompts directory is a git repository"
        # Check git status
        if git -C "${HOME}/.codex/prompts" diff --quiet 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} Prompts repo is clean"
        else
            echo -e "  ${YELLOW}⚠${NC} Prompts repo has uncommitted changes"
            ((WARNINGS++))
        fi
    else
        echo -e "  ${YELLOW}⚠${NC} Prompts directory is not a git repository"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}✗${NC} Prompts directory not found: ${HOME}/.codex/prompts"
    ((ISSUES++))
fi

echo ""
echo "## Checking MCP Tools Configuration"
echo ""

# Check for MCP configurations in Claude
if [ -d "${HOME}/.claude/plugins" ]; then
    local mcp_count=$(find "${HOME}/.claude/plugins" -name "*.mcp.json" 2>/dev/null | wc -l | tr -d ' ')
    if [ "${mcp_count}" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Found ${mcp_count} MCP configuration file(s)"
    else
        echo -e "${YELLOW}⚠${NC} No MCP configuration files found"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} Claude plugins directory not found"
    ((WARNINGS++))
fi

# Check for MCP server configurations (common locations)
MCP_CONFIG_LOCATIONS=(
    "${HOME}/.config/mcp"
    "${HOME}/Library/Application Support/mcp"
    "${HOME}/.mcp"
)

FOUND_MCP=false
for location in "${MCP_CONFIG_LOCATIONS[@]}"; do
    if [ -d "${location}" ]; then
        echo -e "${GREEN}✓${NC} MCP config directory found: ${location}"
        FOUND_MCP=true
        break
    fi
done

if [ "${FOUND_MCP}" = false ]; then
    echo -e "${YELLOW}⚠${NC} No MCP configuration directory found in common locations"
    ((WARNINGS++))
fi

echo ""
echo "## Checking Endpoints"
echo ""

# Check Ollama endpoint
if command -v ollama >/dev/null 2>&1; then
    if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Ollama is running on localhost:11434"
        local models=$(ollama list 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
        if [ "${models}" -gt 0 ]; then
            echo -e "  ${GREEN}✓${NC} Found ${models} model(s) installed"
        else
            echo -e "  ${YELLOW}⚠${NC} No models installed"
            ((WARNINGS++))
        fi
    else
        echo -e "${YELLOW}⚠${NC} Ollama is not running or not accessible on localhost:11434"
        ((WARNINGS++))
    fi
fi

# Check LM Studio endpoint (common port)
if curl -s http://localhost:1234/v1/models >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} LM Studio endpoint is accessible on localhost:1234"
else
    echo -e "${YELLOW}⚠${NC} LM Studio endpoint not accessible on localhost:1234 (optional)"
    ((WARNINGS++))
fi

echo ""
echo "## Configuration Backup"
echo ""
echo "Note: When modifying configuration files, timestamped backups are created"
echo "automatically with the format: <config-file>.backup.YYYYMMDD_HHMMSS"
echo ""

echo ""
echo "## Summary"
echo ""

if [ ${ISSUES} -eq 0 ] && [ ${WARNINGS} -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    exit 0
elif [ ${ISSUES} -eq 0 ]; then
    echo -e "${YELLOW}⚠ Configuration complete with ${WARNINGS} warning(s)${NC}"
    exit 0
else
    echo -e "${RED}✗ Found ${ISSUES} issue(s) and ${WARNINGS} warning(s)${NC}"
    exit 1
fi
