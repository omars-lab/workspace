#!/bin/bash

# Analysis script for AI tool usage
# Analyzes usage patterns, lists prompts, and provides insights

set -e

# Check bash version for associative array support
if [ "${BASH_VERSION%%.*}" -lt 4 ]; then
    # Use alternative approach for older bash
    USE_ASSOC_ARRAYS=false
else
    USE_ASSOC_ARRAYS=true
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WORKSPACE_DIR="$(dirname "${DIR}")"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo "=== AI Tools Usage Analysis ==="
echo ""

# Function to create a bar chart
# Usage: bar_chart "label1:value1" "label2:value2" ...
bar_chart() {
    local max_width=50
    local max_value=0
    local labels=()
    local values=()
    
    # Parse input and find max value
    for item in "$@"; do
        local label="${item%%:*}"
        local value="${item##*:}"
        labels+=("${label}")
        values+=("${value}")
        if [ "${value}" -gt "${max_value}" ]; then
            max_value=${value}
        fi
    done
    
    # Draw chart
    for i in "${!labels[@]}"; do
        local label="${labels[$i]}"
        local value="${values[$i]}"
        local bar_width=0
        if [ "${max_value}" -gt 0 ]; then
            bar_width=$((value * max_width / max_value))
        fi
        
        # Create bar
        local bar=""
        for ((j=0; j<bar_width; j++)); do
            bar="${bar}█"
        done
        
        printf "  %-20s │%s %d\n" "${label}" "${bar}" "${value}"
    done
}

# Function to create a sparkline
# Usage: sparkline value1 value2 value3 ...
sparkline() {
    local values=("$@")
    local max=0
    local min=999999
    
    # Find min and max
    for val in "${values[@]}"; do
        if [ "${val}" -gt "${max}" ]; then
            max=${val}
        fi
        if [ "${val}" -lt "${min}" ]; then
            min=${val}
        fi
    done
    
    local range=$((max - min))
    if [ "${range}" -eq 0 ]; then
        range=1
    fi
    
    # Create sparkline
    local spark=""
    for val in "${values[@]}"; do
        local height=$(((val - min) * 8 / range))
        case ${height} in
            0) spark="${spark}▁" ;;
            1) spark="${spark}▂" ;;
            2) spark="${spark}▃" ;;
            3) spark="${spark}▄" ;;
            4) spark="${spark}▅" ;;
            5) spark="${spark}▆" ;;
            6) spark="${spark}▇" ;;
            *) spark="${spark}█" ;;
        esac
    done
    
    echo "  ${spark}"
}

# Function to create activity heatmap (7-day view)
# Usage: activity_heatmap "date1:count1" "date2:count2" ...
activity_heatmap() {
    local max_value=0
    local data=()
    
    # Parse and find max
    for item in "$@"; do
        local date="${item%%:*}"
        local count="${item##*:}"
        data+=("${date}:${count}")
        if [ "${count}" -gt "${max_value}" ]; then
            max_value=${count}
        fi
    done
    
    echo "  Activity Heatmap (last 7 days):"
    for item in "${data[@]}"; do
        local date="${item%%:*}"
        local count="${item##*:}"
        local intensity=""
        
        if [ "${max_value}" -eq 0 ]; then
            intensity="░"
        elif [ "${count}" -eq 0 ]; then
            intensity="░"
        elif [ $((count * 4 / max_value)) -eq 0 ]; then
            intensity="░"
        elif [ $((count * 4 / max_value)) -eq 1 ]; then
            intensity="▒"
        elif [ $((count * 4 / max_value)) -eq 2 ]; then
            intensity="▓"
        else
            intensity="█"
        fi
        
        printf "    %s %s %d\n" "${date}" "${intensity}" "${count}"
    done
}

# Function to create distribution chart
# Usage: distribution_chart "category1:count1" "category2:count2" ...
distribution_chart() {
    local total=0
    local items=()
    
    # Calculate total
    for item in "$@"; do
        local count="${item##*:}"
        total=$((total + count))
        items+=("${item}")
    done
    
    if [ "${total}" -eq 0 ]; then
        echo "  No data to display"
        return
    fi
    
    echo "  Distribution:"
    for item in "${items[@]}"; do
        local label="${item%%:*}"
        local count="${item##*:}"
        local percentage=$((count * 100 / total))
        local bar_length=$((percentage / 2))
        
        local bar=""
        for ((i=0; i<bar_length; i++)); do
            bar="${bar}━"
        done
        
        printf "    %-20s %s %d%% (%d)\n" "${label}" "${bar}" "${percentage}" "${count}"
    done
}

# Function to create calendar heatmap
# Usage: calendar_heatmap "tool_name" "YYYY-MM-DD:count" "YYYY-MM-DD:count" ...
calendar_heatmap() {
    local tool_name="$1"
    shift
    local data=()
    local max_value=0
    
    # Parse input and find max value
    for item in "$@"; do
        if [ -z "${item}" ]; then
            continue
        fi
        local date="${item%%:*}"
        local count="${item##*:}"
        if [ -n "${date}" ] && [ -n "${count}" ]; then
            data+=("${date}:${count}")
            if [ "${count}" -gt "${max_value}" ]; then
                max_value=${count}
            fi
        fi
    done
    
    if [ ${#data[@]} -eq 0 ]; then
        echo "  No data available for ${tool_name}"
        return
    fi
    
    # Create a map of date -> count (compatible with bash 3+)
    # Store as space-separated string: "date1:count1 date2:count2 ..."
    local date_map_data=""
    for item in "${data[@]}"; do
        local date="${item%%:*}"
        local count="${item##*:}"
        date_map_data="${date_map_data}${date}:${count} "
    done
    
    # Helper function to get intensity for a date
    get_intensity() {
        local search_date="$1"
        local count=0
        
        # Look up count for date
        for item in ${date_map_data}; do
            local date="${item%%:*}"
            local item_count="${item##*:}"
            if [ "${date}" = "${search_date}" ]; then
                count=${item_count}
                break
            fi
        done
        
        # Calculate intensity
        if [ "${max_value}" -eq 0 ]; then
            echo " "
        elif [ "${count}" -eq 0 ]; then
            echo " "
        elif [ $((count * 4 / max_value)) -eq 0 ]; then
            echo "░"
        elif [ $((count * 4 / max_value)) -eq 1 ]; then
            echo "▒"
        elif [ $((count * 4 / max_value)) -eq 2 ]; then
            echo "▓"
        else
            echo "█"
        fi
    }
    
    # Get current month and year
    local current_month=$(date +%m | sed 's/^0//')
    local current_year=$(date +%Y)
    
    # Get previous month if we're early in the month (to show last 30 days)
    local current_day=$(date +%d | sed 's/^0//')
    
    # Show previous month if we're in first week
    local show_prev_month=false
    if [ "${current_day}" -le 7 ]; then
        show_prev_month=true
        if [ "${current_month}" -eq 1 ]; then
            local prev_month=12
            local prev_year=$((current_year - 1))
        else
            local prev_month=$((current_month - 1))
            local prev_year=${current_year}
        fi
    fi
    
    echo ""
    echo "  ${tool_name} - Calendar Heatmap"
    echo ""
    
    # Process calendar month and overlay heatmap
    # Pass date_map_data and max_value to avoid subshell scope issues
    process_calendar_month() {
        local month="$1"
        local year="$2"
        local map_data="$3"  # date_map_data passed as parameter
        local max_val="$4"   # max_value passed as parameter
        local cal_output=$(cal ${month} ${year} 2>/dev/null)
        
        if [ -z "${cal_output}" ]; then
            return
        fi
        
        # Print month header
        echo "    $(echo "${cal_output}" | head -1)"
        echo "    $(echo "${cal_output}" | head -2 | tail -1)"
        
        # Process week lines - extract and process without subshell
        local week_lines=$(echo "${cal_output}" | tail -n +3)
        
        # Convert to array-like processing by using eval or direct processing
        # Process line by line using printf to avoid subshell
        echo "${week_lines}" | {
            while IFS= read -r week_line; do
                if [ -z "${week_line}" ]; then
                    continue
                fi
                
                # Replace day numbers with intensity indicators
                printf "    "
                for day in ${week_line}; do
                    # Check if it's a number (day of month)
                    if echo "${day}" | grep -qE '^[0-9]+$'; then
                        # Format day with leading zero if needed
                        local day_str=$(printf "%02d" "${day}")
                        local date_str="${year}-$(printf "%02d" "${month}")-${day_str}"
                        
                        # Look up count for date - map_data and max_val are passed as params
                        local count=0
                        for item in ${map_data}; do
                            local date="${item%%:*}"
                            local item_count="${item##*:}"
                            if [ "${date}" = "${date_str}" ]; then
                                count=${item_count}
                                break
                            fi
                        done
                        
                        # Calculate intensity
                        local intensity=""
                        if [ "${max_val}" -eq 0 ]; then
                            intensity=" "
                        elif [ "${count}" -eq 0 ]; then
                            intensity=" "
                        elif [ $((count * 4 / max_val)) -eq 0 ]; then
                            intensity="░"
                        elif [ $((count * 4 / max_val)) -eq 1 ]; then
                            intensity="▒"
                        elif [ $((count * 4 / max_val)) -eq 2 ]; then
                            intensity="▓"
                        else
                            intensity="█"
                        fi
                        
                        # Replace with intensity, maintaining spacing
                        printf "%-3s" "${intensity}"
                    else
                        # Keep spacing for alignment
                        printf "%-3s" " "
                    fi
                done
                echo ""
            done
        }
    }
    
    # Show previous month if needed
    if [ "${show_prev_month}" = true ]; then
        process_calendar_month "${prev_month}" "${prev_year}" "${date_map_data}" "${max_value}"
        echo ""
    fi
    
    # Show current month using cal command
    process_calendar_month "${current_month}" "${current_year}" "${date_map_data}" "${max_value}"
    
    echo ""
    echo "    Legend:  ░ Low  ▒ Medium  ▓ High  █ Very High"
    echo ""
}

# Function to analyze Claude history
analyze_claude_history() {
    local history_file="${HOME}/.claude/history.jsonl"
    
    if [ ! -f "${history_file}" ]; then
        echo -e "${YELLOW}⚠ Claude history file not found: ${history_file}${NC}"
        return
    fi
    
    echo "## Claude Usage"
    echo ""
    
    local total_conversations=$(wc -l < "${history_file}" | tr -d ' ')
    echo -e "${BLUE}Total conversations:${NC} ${total_conversations}"
    
    if [ "${total_conversations}" -gt 0 ]; then
        # Convert timestamp (milliseconds) to dates and extract
        # Claude uses timestamp in milliseconds, need to convert to date
        local temp_dates=$(mktemp)
        
        # Process each line and convert timestamp to date
        while IFS= read -r line; do
            if [ -z "${line}" ]; then
                continue
            fi
            # Extract timestamp and convert from milliseconds to date
            local timestamp=$(echo "${line}" | jq -r '.timestamp // empty' 2>/dev/null)
            if [ -n "${timestamp}" ] && [ "${timestamp}" != "null" ] && [ "${timestamp}" != "" ]; then
                # Convert milliseconds to seconds and then to date
                local seconds=$((timestamp / 1000))
                # Use date command to convert
                if date -r ${seconds} +%Y-%m-%d >/dev/null 2>&1; then
                    # macOS
                    date -r ${seconds} +%Y-%m-%d
                else
                    # Linux
                    date -d "@${seconds}" +%Y-%m-%d
                fi
            fi
        done < "${history_file}" > "${temp_dates}"
        
        # Extract dates and count by day for charts
        echo ""
        echo "### Activity Chart (last 7 days)"
        local activity_data=$(sort "${temp_dates}" | uniq -c | tail -7 | \
            awk '{printf "%s:%d\n", $2, $1}' 2>/dev/null)
        
        if [ -n "${activity_data}" ] && [ -s "${temp_dates}" ]; then
            # Create activity heatmap
            local dates=()
            local counts=()
            while IFS=: read -r date count; do
                dates+=("${date}")
                counts+=("${count}")
            done <<< "${activity_data}"
            
            # Create sparkline
            sparkline "${counts[@]}"
            
            # Create activity heatmap
            activity_heatmap $(echo "${activity_data}" | tr '\n' ' ')
        else
            echo "  (Unable to parse dates)"
        fi
        
        # Create calendar heatmap for Claude Code
        local all_dates=$(sort "${temp_dates}" | uniq -c | \
            awk '{printf "%s:%d ", $2, $1}' 2>/dev/null)
        
        if [ -n "${all_dates}" ] && [ -s "${temp_dates}" ]; then
            calendar_heatmap "Claude Code" ${all_dates}
        fi
        
        rm -f "${temp_dates}"
        
        # Extract prompt displays (Claude uses "display" field, not "title")
        echo ""
        echo "### Recent Prompts"
        local recent_prompts=$(jq -r '.display // "Untitled"' "${history_file}" 2>/dev/null | \
            head -10)
        
        if [ -n "${recent_prompts}" ]; then
            echo "${recent_prompts}" | while IFS= read -r prompt; do
                # Truncate long prompts
                if [ ${#prompt} -gt 60 ]; then
                    prompt="${prompt:0:57}..."
                fi
                if [ -z "${prompt}" ] || [ "${prompt}" = "null" ]; then
                    prompt="Untitled"
                fi
                echo "  - ${prompt}"
            done
        else
            echo "  (Unable to extract prompts)"
        fi
    fi
}

# Function to analyze Codex prompts
analyze_codex_prompts() {
    local prompts_dir="${HOME}/.codex/prompts"
    
    if [ ! -d "${prompts_dir}" ]; then
        echo -e "${YELLOW}⚠ Codex prompts directory not found: ${prompts_dir}${NC}"
        return
    fi
    
    echo ""
    echo "## Codex Prompts Repository"
    echo ""
    
    local total_prompts=$(find "${prompts_dir}" -type f -name "*.md" -o -name "*.txt" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${BLUE}Total prompt files:${NC} ${total_prompts}"
    
    if [ "${total_prompts}" -gt 0 ]; then
        echo ""
        echo "### Prompt Categories Distribution"
        
        # Collect category data
        local category_data=""
        find "${prompts_dir}" -type d -mindepth 1 -maxdepth 1 ! -name ".git" 2>/dev/null | \
            while read -r dir; do
                local category=$(basename "${dir}")
                local count=$(find "${dir}" -type f \( -name "*.md" -o -name "*.txt" \) 2>/dev/null | wc -l | tr -d ' ')
                if [ "${count}" -gt 0 ]; then
                    echo "${category}:${count}"
                fi
            done > /tmp/category_data.$$
        
        if [ -s /tmp/category_data.$$ ]; then
            distribution_chart $(cat /tmp/category_data.$$ | tr '\n' ' ')
            rm -f /tmp/category_data.$$
        fi
        
        # Create calendar heatmap for Codex prompts (by modification date)
        echo ""
        echo "### Codex Prompts - Calendar Heatmap"
        local prompt_dates=$(find "${prompts_dir}" -type f \( -name "*.md" -o -name "*.txt" \) ! -path "*/.git/*" 2>/dev/null | \
            xargs stat -f "%Sm %N" -t "%Y-%m-%d" 2>/dev/null | \
            awk '{print $1}' | sort | uniq -c | \
            awk '{printf "%s:%d ", $2, $1}' 2>/dev/null)
        
        if [ -n "${prompt_dates}" ]; then
            calendar_heatmap "Codex Prompts" ${prompt_dates}
        fi
        
        echo ""
        echo "### Recent Prompts (by modification time)"
        find "${prompts_dir}" -type f \( -name "*.md" -o -name "*.txt" \) ! -path "*/.git/*" 2>/dev/null | \
            xargs ls -t 2>/dev/null | head -10 | \
            while read -r file; do
                local rel_path="${file#${prompts_dir}/}"
                local mod_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "${file}" 2>/dev/null || stat -c "%y" "${file}" 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1)
                echo "  - ${rel_path} (${mod_time})"
            done
    fi
    
    # Check git status if it's a repo
    if [ -d "${prompts_dir}/.git" ]; then
        echo ""
        echo "### Git Repository Status"
        local branch=$(git -C "${prompts_dir}" branch --show-current 2>/dev/null || echo "unknown")
        local commits=$(git -C "${prompts_dir}" rev-list --count HEAD 2>/dev/null || echo "0")
        local uncommitted=$(git -C "${prompts_dir}" status --short 2>/dev/null | wc -l | tr -d ' ')
        
        echo -e "  Branch: ${branch}"
        echo -e "  Commits: ${commits}"
        if [ "${uncommitted}" -gt 0 ]; then
            echo -e "  ${YELLOW}Uncommitted changes: ${uncommitted} file(s)${NC}"
        else
            echo -e "  ${GREEN}No uncommitted changes${NC}"
        fi
    fi
}

# Function to analyze Claude Code Router usage
analyze_claude_code_router() {
    local config_file="${HOME}/.claude-code-router/config.json"
    local log_file="${HOME}/.claude-code-router/claude-code-router.log"
    
    echo ""
    echo "## Claude Code Router"
    echo ""
    
    if [ -f "${config_file}" ]; then
        echo "### Configuration"
        local providers=$(jq -r '.Providers[]?.name // empty' "${config_file}" 2>/dev/null | tr '\n' ', ' | sed 's/,$//')
        if [ -n "${providers}" ]; then
            echo -e "  ${BLUE}Providers:${NC} ${providers}"
        fi
        
        local port=$(jq -r '.PORT // empty' "${config_file}" 2>/dev/null)
        if [ -n "${port}" ] && [ "${port}" != "null" ]; then
            echo -e "  ${BLUE}Port:${NC} ${port}"
        fi
    else
        echo -e "  ${YELLOW}⚠ Config file not found${NC}"
    fi
    
    if [ -f "${log_file}" ]; then
        echo ""
        echo "### Recent Activity (from logs)"
        local log_lines=$(wc -l < "${log_file}" | tr -d ' ')
        echo -e "  ${BLUE}Total log entries:${NC} ${log_lines}"
        
        if [ "${log_lines}" -gt 0 ]; then
            echo ""
            echo "  Last 5 log entries:"
            tail -5 "${log_file}" | sed 's/^/    /'
        fi
    fi
}

# Function to analyze Gemini usage
analyze_gemini() {
    local gemini_dir="${HOME}/.gemini"
    
    if [ ! -d "${gemini_dir}" ]; then
        return
    fi
    
    echo ""
    echo "## Gemini Usage"
    echo ""
    
    # Look for history or cache files
    local history_files=$(find "${gemini_dir}" -name "*history*" -o -name "*cache*" 2>/dev/null | head -5)
    if [ -n "${history_files}" ]; then
        echo "  Found history/cache files:"
        echo "${history_files}" | sed 's/^/    /'
        
        # Try to extract dates from history files
        local gemini_dates=""
        for hist_file in ${history_files}; do
            if [ -f "${hist_file}" ]; then
                # Try to extract dates (various formats)
                local dates=$(grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}" "${hist_file}" 2>/dev/null | \
                    sort | uniq -c | awk '{printf "%s:%d ", $2, $1}' 2>/dev/null)
                if [ -n "${dates}" ]; then
                    gemini_dates="${gemini_dates} ${dates}"
                fi
            fi
        done
        
        if [ -n "${gemini_dates}" ]; then
            calendar_heatmap "Gemini" ${gemini_dates}
        fi
    else
        echo -e "  ${YELLOW}No history files found${NC}"
    fi
}

# Function to analyze Cursor usage
analyze_cursor() {
    local cursor_dir="${HOME}/.cursor"
    
    if [ ! -d "${cursor_dir}" ]; then
        return
    fi
    
    echo ""
    echo "## Cursor Usage"
    echo ""
    
    # Check for chat history
    local chat_dirs=$(find "${cursor_dir}" -type d -name "*chat*" 2>/dev/null | head -5)
    if [ -n "${chat_dirs}" ]; then
        echo "  Chat directories found:"
        echo "${chat_dirs}" | sed 's/^/    /'
        
        # Count chat files
        local chat_count=$(find "${cursor_dir}" -type f -name "*.json" -path "*/chat*" 2>/dev/null | wc -l | tr -d ' ')
        if [ "${chat_count}" -gt 0 ]; then
            echo -e "  ${BLUE}Total chat files:${NC} ${chat_count}"
            
            # Extract dates from chat files (by modification time)
            local cursor_dates=$(find "${cursor_dir}" -type f -name "*.json" -path "*/chat*" 2>/dev/null | \
                xargs stat -f "%Sm %N" -t "%Y-%m-%d" 2>/dev/null | \
                awk '{print $1}' | sort | uniq -c | \
                awk '{printf "%s:%d ", $2, $1}' 2>/dev/null)
            
            if [ -n "${cursor_dates}" ]; then
                calendar_heatmap "Cursor" ${cursor_dates}
            fi
        fi
    else
        echo -e "  ${YELLOW}No chat directories found${NC}"
    fi
}

# Function to analyze Ollama usage
analyze_ollama() {
    echo ""
    echo "## Ollama Models"
    echo ""
    
    if ! command -v ollama >/dev/null 2>&1; then
        echo -e "  ${YELLOW}⚠ Ollama not installed${NC}"
        return
    fi
    
    # Check if ollama is running
    if ! curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        echo -e "  ${YELLOW}⚠ Ollama is not running${NC}"
        return
    fi
    
    local models=$(ollama list 2>/dev/null | tail -n +2)
    if [ -n "${models}" ]; then
        local model_count=$(echo "${models}" | wc -l | tr -d ' ')
        echo -e "  ${BLUE}Installed models:${NC} ${model_count}"
        echo ""
        
        # Create a simple list with visual indicator
        echo "${models}" | awk '{
            model = $1
            size = $2
            # Create visual indicator based on model name length
            indicator = ""
            for (i = 0; i < length(model) % 10; i++) {
                indicator = indicator "●"
            }
            printf "    %-30s %s\n", model, indicator
        }'
    else
        echo -e "  ${YELLOW}No models installed${NC}"
    fi
}

# Function to provide summary statistics
print_summary() {
    echo ""
    echo "## Summary Statistics"
    echo ""
    
    # Count total prompts across all tools
    local total_prompts=0
    
    if [ -d "${HOME}/.codex/prompts" ]; then
        local codex_prompts=$(find "${HOME}/.codex/prompts" -type f \( -name "*.md" -o -name "*.txt" \) ! -path "*/.git/*" 2>/dev/null | wc -l | tr -d ' ')
        total_prompts=$((total_prompts + codex_prompts))
    fi
    
    # Count conversations
    local claude_conversations=0
    if [ -f "${HOME}/.claude/history.jsonl" ]; then
        claude_conversations=$(wc -l < "${HOME}/.claude/history.jsonl" | tr -d ' ')
    fi
    
    # Count installed models
    local ollama_models=0
    if command -v ollama >/dev/null 2>&1 && curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        ollama_models=$(ollama list 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
    fi
    
    # Create summary bar chart
    echo "  Usage Overview:"
    bar_chart \
        "Prompts:${total_prompts}" \
        "Conversations:${claude_conversations}" \
        "Ollama Models:${ollama_models}"
}

# Run all analyses
analyze_claude_history
analyze_codex_prompts
analyze_claude_code_router
analyze_gemini
analyze_cursor
analyze_ollama
print_summary

echo ""
echo "=== Analysis Complete ==="
