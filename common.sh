# Contains general Linux/Unix helper functions

# ============================================================================
# Visual Feedback Functions for Loaders
# ============================================================================

# Enable visual feedback by default (set SHOW_LOADER_PROGRESS=false to disable)
SHOW_LOADER_PROGRESS=${SHOW_LOADER_PROGRESS:-true}

# Emoji and symbols
CHECKMARK="✓"
SPINNER_CHARS="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
SPINNER_INDEX=0

# ============================================================================
# Terminal Capability Detection
# ============================================================================

# Only run terminal detection once (common.sh may be sourced multiple times)
# Check if detection has already been done
if [[ -z "${COMMON_TERMINAL_DETECTED:-}" ]]; then
    # Detect if we're in a terminal (not piped/redirected)
    # Note: Check stdout first, then stderr (stderr might be redirected during sourcing)
    IS_TERMINAL=false
    if [[ -t 1 ]]; then
        # If stdout is a terminal, we're in a terminal (even if stderr is redirected)
        IS_TERMINAL=true
    elif [[ -t 2 ]]; then
        # Fallback: check stderr if stdout check failed
        IS_TERMINAL=true
    fi

    # Detect if running over SSH
    IS_SSH=false
    if [[ -n "${SSH_CLIENT}" ]] || [[ -n "${SSH_TTY}" ]] || [[ -n "${SSH_CONNECTION}" ]]; then
        IS_SSH=true
    fi

    # Detect color support (check if terminal supports at least 8 colors)
    # Check TERM first - it's more reliable than -t checks (which can fail if stderr is redirected)
    SUPPORTS_COLORS=false
    if [[ -n "${TERM:-}" ]] && [[ "${TERM}" != "dumb" ]]; then
        # First, check TERM variable for common color-capable terminals (fastest check)
        case "${TERM}" in
            xterm*|screen*|tmux*|rxvt*|ansi|*color*)
                SUPPORTS_COLORS=true
                ;;
            linux|vt100*)
                SUPPORTS_COLORS=false
                ;;
            *)
                # If TERM doesn't give us a clear answer, try tput (if available)
                if command -v tput >/dev/null 2>&1; then
                    COLORS=$(tput colors 2>/dev/null || echo "0")
                    if [[ "${COLORS}" =~ ^[0-9]+$ ]] && [[ "${COLORS}" -ge 8 ]]; then
                        SUPPORTS_COLORS=true
                    fi
                elif [[ "${IS_TERMINAL}" == "true" ]]; then
                    # If we're in a terminal but tput isn't available, assume colors
                    SUPPORTS_COLORS=true
                fi
                ;;
        esac
    elif [[ "${IS_TERMINAL}" == "true" ]]; then
        # TERM not set but we're in a terminal - try tput
        if command -v tput >/dev/null 2>&1; then
            COLORS=$(tput colors 2>/dev/null || echo "0")
            if [[ "${COLORS}" =~ ^[0-9]+$ ]] && [[ "${COLORS}" -ge 8 ]]; then
                SUPPORTS_COLORS=true
            fi
        else
            # Last resort: assume colors if we're in a terminal
            SUPPORTS_COLORS=true
        fi
    fi

    # Detect emoji support (most modern terminals support emojis, but some don't)
    # Use SUPPORTS_COLORS as the indicator (more reliable than IS_TERMINAL)
    SUPPORTS_EMOJIS=false
    if [[ "${SUPPORTS_COLORS}" == "true" ]]; then
        # Most color terminals support emojis, but check for known problematic ones
        case "${TERM:-}" in
            linux|vt100*|dumb)
                SUPPORTS_EMOJIS=false
                ;;
            *)
                # Assume emoji support for modern terminals
                SUPPORTS_EMOJIS=true
                ;;
        esac
        # Disable emojis over SSH if NO_COLOR is set (common convention)
        if [[ "${IS_SSH}" == "true" ]] && [[ -n "${NO_COLOR}" ]]; then
            SUPPORTS_EMOJIS=false
        fi
    fi
    
    # Mark detection as complete
    export COMMON_TERMINAL_DETECTED=true
fi

# Set colors based on terminal capabilities
if [[ "${SUPPORTS_COLORS}" == "true" ]]; then
    COLOR_RESET="\033[0m"
    COLOR_GREEN="\033[0;32m"
    COLOR_YELLOW="\033[1;33m"
    COLOR_BLUE="\033[0;34m"
    COLOR_CYAN="\033[0;36m"
    COLOR_GRAY="\033[0;90m"
else
    COLOR_RESET=""
    COLOR_GREEN=""
    COLOR_YELLOW=""
    COLOR_BLUE=""
    COLOR_CYAN=""
    COLOR_GRAY=""
fi

# Export detection variables for use in other scripts
export IS_TERMINAL
export IS_SSH
export SUPPORTS_COLORS
export SUPPORTS_EMOJIS

# Function to show a checkpoint (loading state)
loader_checkpoint() {
    local emoji=$1
    local message=$2
    if [[ "${SHOW_LOADER_PROGRESS}" == "true" ]]; then
        local display_emoji="${emoji}"
        [[ "${SUPPORTS_EMOJIS}" != "true" ]] && display_emoji=""
        echo -ne "${COLOR_CYAN}${display_emoji}${display_emoji:+ }${COLOR_RESET}${COLOR_GRAY}${message}...${COLOR_RESET}" >&2
    fi
}

# Function to show a checkpoint with spinner
loader_checkpoint_spinner() {
    local emoji=$1
    local message=$2
    if [[ "${SHOW_LOADER_PROGRESS}" == "true" ]]; then
        local spinner_char=${SPINNER_CHARS:$((SPINNER_INDEX % 10)):1}
        SPINNER_INDEX=$((SPINNER_INDEX + 1))
        echo -ne "\r${COLOR_CYAN}${spinner_char}${COLOR_RESET} ${COLOR_GRAY}${emoji} ${message}...${COLOR_RESET}" >&2
    fi
}

# Function to mark a checkpoint as complete
loader_checkpoint_done() {
    local emoji=$1
    local message=$2
    if [[ "${SHOW_LOADER_PROGRESS}" == "true" ]]; then
        local display_emoji="${emoji}"
        [[ "${SUPPORTS_EMOJIS}" != "true" ]] && display_emoji=""
        local checkmark="${CHECKMARK}"
        [[ "${SUPPORTS_COLORS}" != "true" ]] && checkmark="OK"
        # Clear the line first (carriage return + clear to end of line), then print the done message
        # Add tab after emoji for alignment
        printf "\r\033[K" >&2
        echo -ne "${COLOR_GREEN}${checkmark}${COLOR_RESET} ${COLOR_GREEN}${display_emoji}${display_emoji:+ }\t${COLOR_RESET}${COLOR_GREEN}${message}${COLOR_RESET}\n" >&2
    fi
}

# Function to mark a checkpoint as skipped
loader_checkpoint_skip() {
    local emoji=$1
    local message=$2
    if [[ "${SHOW_LOADER_PROGRESS}" == "true" ]]; then
        local display_emoji="${emoji}"
        [[ "${SUPPORTS_EMOJIS}" != "true" ]] && display_emoji=""
        local skip_marker="⊘"
        [[ "${SUPPORTS_COLORS}" != "true" ]] && skip_marker="SKIP"
        echo -ne "\r\033[K${COLOR_GRAY}${skip_marker}${COLOR_RESET} ${COLOR_GRAY}${display_emoji}${display_emoji:+ }${COLOR_RESET}${COLOR_GRAY}${message} (skipped)${COLOR_RESET}\n" >&2
    fi
}

# Function to show an error checkpoint
loader_checkpoint_error() {
    local emoji=$1
    local message=$2
    if [[ "${SHOW_LOADER_PROGRESS}" == "true" ]]; then
        local display_emoji="${emoji}"
        [[ "${SUPPORTS_EMOJIS}" != "true" ]] && display_emoji=""
        local warning_marker="⚠️"
        [[ "${SUPPORTS_EMOJIS}" != "true" ]] && warning_marker="WARN"
        echo -ne "\r\033[K${COLOR_YELLOW}${warning_marker}${COLOR_RESET}${COLOR_YELLOW}${warning_marker:+ }${display_emoji}${display_emoji:+ }${COLOR_RESET}${COLOR_YELLOW}${message} (warning)${COLOR_RESET}\n" >&2
    fi
}

# ============================================================================
# Unified Loader Message Functions
# ============================================================================

# Unified loader message function (replaces _loader_msg and _loader_msg_simple)
# Note: 'status' is read-only in zsh, so we use 'msg_type' instead
_loader_msg() {
    local msg_type=$1
    local emoji=$2
    local message=$3
    
    if [[ "${SHOW_LOADER_PROGRESS:-true}" != "true" ]]; then
        return
    fi
    
    # Use terminal detection from common.sh (already set up at this point)
    local display_emoji="${emoji}"
    [[ "${SUPPORTS_EMOJIS}" != "true" ]] && display_emoji=""
    
    case "${msg_type}" in
        "start")
            if [[ "${SUPPORTS_COLORS}" == "true" ]]; then
                echo -ne "${COLOR_CYAN}${display_emoji}${display_emoji:+ }${COLOR_RESET}${COLOR_GRAY}${message}...${COLOR_RESET}" >&2
            else
                echo -ne "[*] ${message}..." >&2
            fi
            ;;
        "done")
            local checkmark="${CHECKMARK}"
            [[ "${SUPPORTS_COLORS}" != "true" ]] && checkmark="OK"
            # Clear the line first (carriage return + clear to end of line), then print the done message
            # Use both \r and \033[K for maximum compatibility
            # Add tab after emoji for alignment
            if [[ "${SUPPORTS_COLORS}" == "true" ]]; then
                printf "\r\033[K" >&2
                echo -ne "${COLOR_GREEN}${checkmark}${COLOR_RESET} ${COLOR_GREEN}${display_emoji}${display_emoji:+ }\t${COLOR_RESET}${COLOR_GREEN}${message}${COLOR_RESET}\n" >&2
            else
                printf "\r\033[K" >&2
                echo -ne "[${checkmark}] ${display_emoji}${display_emoji:+ }\t${message}\n" >&2
            fi
            ;;
        "skip")
            local skip_marker="⊘"
            [[ "${SUPPORTS_COLORS}" != "true" ]] && skip_marker="SKIP"
            # Clear the line first, then print the skip message
            if [[ "${SUPPORTS_COLORS}" == "true" ]]; then
                printf "\r\033[K" >&2
                echo -ne "${COLOR_GRAY}${skip_marker}${COLOR_RESET} ${COLOR_GRAY}${display_emoji}${display_emoji:+ }${COLOR_RESET}${COLOR_GRAY}${message} (skipped)${COLOR_RESET}\n" >&2
            else
                printf "\r\033[K" >&2
                echo -ne "[${skip_marker}] ${display_emoji}${display_emoji:+ }${message} (skipped)\n" >&2
            fi
            ;;
        "error")
            local warning_marker="⚠️"
            [[ "${SUPPORTS_EMOJIS}" != "true" ]] && warning_marker="WARN"
            # Clear the line first, then print the error message
            if [[ "${SUPPORTS_COLORS}" == "true" ]]; then
                printf "\r\033[K" >&2
                echo -ne "${COLOR_YELLOW}${warning_marker}${COLOR_RESET}${COLOR_YELLOW}${warning_marker:+ }${display_emoji}${display_emoji:+ }${COLOR_RESET}${COLOR_YELLOW}${message} (warning)${COLOR_RESET}\n" >&2
            else
                printf "\r\033[K" >&2
                echo -ne "[${warning_marker}] ${display_emoji}${display_emoji:+ }${message} (warning)\n" >&2
            fi
            ;;
    esac
}

# Alias for _loader_msg with simpler name (for use in zshrc and other scripts)
# This is the same function, just a more convenient name
_loader_msg_simple() {
    _loader_msg "$@"
}

# Function to wrap a command with checkpoint feedback
loader_wrap() {
    local emoji=$1
    local message=$2
    shift 2
    local cmd="$@"
    
    loader_checkpoint "${emoji}" "${message}"
    if eval "$cmd" 2>/dev/null; then
        loader_checkpoint_done "${emoji}" "${message}"
        return 0
    else
        loader_checkpoint_error "${emoji}" "${message}"
        return 1
    fi
}

# ============================================================================

# function get_other_user(){
#   users | sed -e "s/$(whoami)//g" -e 's/ *//g'
# }

function secret() {
	PASSWORD="${1}"
	/usr/bin/security find-generic-password -l ${PASSWORD} 2>/dev/null >/dev/null || echo "Not found: ${PASSWORD}" >&2
	bash -c "/usr/bin/sudo /usr/bin/security find-generic-password -l ${PASSWORD} -w | tr -d '\n' | pbcopy"
}

function lpass-get-note() {
	# SECRET_NAME=${1}
	# GROUP_ID=${2:-automation}
	# SECRET_ID=$(lpass ls automation | grep "${SECRET_NAME}" | egrep -o -E 'id: ([0-9]+)' | sed 's/id: //g')
	# lpass show -j automation/chatgpt-apikey
	SECRET_ID=${1:?Secret Id Required}
	echo "Secret ID: ${SECRET_ID}" >&2
	lpass show -j ${SECRET_ID} | jq -r '.[]|.note'
}

function get_other_user(){
  USERS=$(dscl . list /Users | grep -v "^_" | grep --color=never eid | tr '\n' ' ')
  # This lists all "logged in" users ... this wont work if I first boot up the mac ...
  # USERS=$(users | sed -e "s/$(whoami)//g" -e 's/ *//g')
  echo ${USERS} | sed -e "s/$(whoami)//g" -e 's/ *//g'
}

function split_and_prefix(){
  echo "${1}" \
    | tr "|" "\n" \
    | xargs printf " ${2} '%s' "
}

function create_zip_WITH_NAME_relavtive_to_DIR_recrusively()(
    # Make dir zip is supposed to be in ...
    DIR_OF_ZIP=$(dirname "${1}")
    mkdir -p "${DIR_OF_ZIP}"

    # CD into dir outside of the one we are about to zip ... and zip ...
    DIR_TO_CD=$(dirname "${2}")
    NAME_OF_DIR_TO_ZIP=$(basename "${2}")
    pushd "${DIR_TO_CD}" 1>/dev/null
    zip -r --exclude='*.DS_Store*' --exclude='*.Trash*' --exclude='*.icloud*' "${1}" "${NAME_OF_DIR_TO_ZIP}"
    popd 1>/dev/null
)

function get_uniq_mac_id(){
  # Get the Mac Address ...
  # ifconfig en0 ether | grep ether | sed 's/.*ether /mac-address-/g' | sed 's/ *//g'
  # Get Serial address of the mac
  system_profiler SPHardwareDataType | grep 'Serial Number' | sed 's/[^:]*://g' | sed 's/ *//g'
}

alias serialnumber=get_uniq_mac_id

function symlink_if_dne(){
    test -L "${2}" || ( \
        ln -s "${1}" "${2}" \
    )
}

function symlink_by_force(){
    echo "Removing ${2:?ARG 2 Required} by force"
    test -L "${2}" && unlink "${2}"
    test -f "${2}" && rm "${2}"
    test -d "${2}" && rm -rf "${2}"
    ln -s "${1}" "${2}"
}

function extract_functions(){
    echo $(cat $1 | grep -Eo "^(?:function )(\w+)" | grep -Eo "\\w+$" | grep -E "^[a-zA-Z]" | xargs echo -n)
}

function extract_variables(){
    echo $(cat $1 | grep -Eo "^(?:export )(\w+)" | grep -Eo "\w+$")
}

function print_variables(){
    echo $@ | xargs printenv
}

# SILENT=false

# Recusively source all .sh files within a directory
# The first param is the directoy.
# The second param is an expression of files to ignore.
function recursive_source(){
    rdir=$1
    ignore=${2:-"^\s*$"}
    # $SILENT || echo "Recursively Sourcing $rdir, ignoring: $ignore" 1>&2
    # Using Python Time ... since mac date doesnt have microsecond resolution
    TIME_BEFORE=$(python3 -c 'import time; print(time.time())')
    for i in $(ls -c1 $rdir | grep -e ".*[.]sh" | grep -vE "$ignore"); do
        $SILENT || echo Sourcing $rdir/$i;
        source $rdir/$i ;
    done
    TIME_AFTER=$(python3 -c 'import time; print(time.time())')
    # https://unix.stackexchange.com/questions/93029/how-can-i-add-subtract-etc-two-numbers-with-bash
    # DURATION=$(( ${TIME_AFTER} - ${TIME_BEFORE} )) # expr in bash can't deal with decimal places
    DURATION=$(echo "${TIME_AFTER} - ${TIME_BEFORE}" | bc -l )
    $SILENT || echo "Sourced $rdir in ${DURATION}" 1>&2
}


# Re-source the bash profile
# function re-source(){
#     source ~/.bash_profile
# }

function first(){
  # picks the first valid file ... recrsively ...
  # Set SILENT_FIRST=true to suppress error messages
  local silent=${SILENT_FIRST:-true}
  
  if [[ "$#" == "0" ]]; then
    [[ "$silent" != "true" ]] && echo "No files/dirs satisfied!" >&2
    return
  fi

  if [[ -f "${1}" ]]
  then
    echo "${1}"
    return
  else 
    [[ "$silent" != "true" ]] && echo "File not found: [${1}]" >&2
  fi

  if [[ -d "${1}" ]]; 
  then
    echo "${1}"
    return
  else 
    [[ "$silent" != "true" ]] && echo "Dir not found: [${1}]" >&2
  fi

  shift
  first $@
}

if [[ "${DETECTED_SHELL}" = "BASH" ]]
then
    export -f first
    export -f get_other_user
    export -f split_and_prefix
    # export -f get_other_user
    export -f get_uniq_mac_id
    export -f symlink_if_dne
    export -f symlink_by_force
    export -f create_zip_WITH_NAME_relavtive_to_DIR_recrusively
    export -f extract_functions
    export -f extract_variables
    export -f print_variables
    export -f recursive_source
fi
