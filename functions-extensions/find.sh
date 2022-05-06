# https://stackoverflow.com/questions/4210042/how-to-exclude-a-directory-in-find-command
function find_files() {
    MAX_DEPTH=${1:-3}
    find . \( \
                   -type d -name '*.Trash' -prune \
                -o -type d -name '*.git' -prune \
                -o -type d -name '*node_modules' -prune \
                -o -type f -name '*.DS_Store' -prune \
            \) \
            -o -type f -maxdepth ${MAX_DEPTH}
}