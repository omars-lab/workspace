
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

# main bash profile 
    # source brew loader from within brew package .. if it exsts 
    # source brew loader from cloned repo if it exists ...

recursive_source ${CURRENT_DIR}/functions-completion
recursive_source ${CURRENT_DIR}/functions-extensions
recursive_source ${CURRENT_DIR}/functions-shortcuts
recursive_source ${CURRENT_DIR}/functions-tools