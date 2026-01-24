
# When my workspace is installed through brew ... 
# ... it will append a line into both the bash profile and zsh profile to source this file in its brew location ...
# If the brew loader doesn not exist in the brew location ... it should default to the normal location ...

# Not going to set dir ... differs for zsh and bash ... assuming sourcer of this script cds and sources from the right place ...
# _DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# function get-plugin-dir() {
#     # $(brew --prefix)/Cellar/PersonalSpace/
#     # (py3) ➜  functions-tools git:(main) ✗ brew info workspace --json | jq -r --arg prefix $(brew --prefix workspace) '"\($prefix)/\(.[0].linked_keg)"'
#     # /usr/local/opt/workspace
#     brew --prefix sharedspace
#     # returns /usr/local/opt/<plugin> which is linked to  ../Cellar/<plugin>/0.1
# }

# BREW_LOADER_INSTALLED=$(get-plugin-dir)/loader-brew.sh

# if (test -f $(get-plugin-dir)/loader-brew.sh);
# then
#     source ${BREW_LOADER_INSTALLED}
# else

# fi

source ${CURRENT_DIR}/common.sh

# _loader_msg is now defined in common.sh (sourced above)
# This script uses the unified _loader_msg function from common.sh

# Use loader_checkpoint if available (from common.sh), otherwise use _loader_msg
if type loader_checkpoint >/dev/null 2>&1; then
    LOADER_MSG_START="loader_checkpoint"
    LOADER_MSG_DONE="loader_checkpoint_done"
else
    LOADER_MSG_START="_loader_msg start"
    LOADER_MSG_DONE="_loader_msg done"
fi

# main bash profile 
    # source brew loader from within brew package .. if it exsts 
    # source brew loader from cloned repo if it exists ...

_loader_msg "start" "📦" "Loading completion functions"
recursive_source ${CURRENT_DIR}/functions-completion 2>/dev/null
_loader_msg "done" "📦" "Loading completion functions"

_loader_msg "start" "🔌" "Loading extension functions"
recursive_source ${CURRENT_DIR}/functions-extensions 2>/dev/null
_loader_msg "done" "🔌" "Loading extension functions"

_loader_msg "start" "⌨️" "Loading shortcuts"
recursive_source ${CURRENT_DIR}/functions-shortcuts 2>/dev/null
_loader_msg "done" "⌨️" "Loading shortcuts"

_loader_msg "start" "🛠️" "Loading tool functions"
recursive_source ${CURRENT_DIR}/functions-tools 2>/dev/null
_loader_msg "done" "🛠️" "Loading tool functions"