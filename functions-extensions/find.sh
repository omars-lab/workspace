# https://stackoverflow.com/questions/4210042/how-to-exclude-a-directory-in-find-command
function find_files() {
    MAX_DEPTH=${1:-3}
    find . \( \
        \( -name '*.Trash' -prune -o -name '.git' -prune -o -name 'node_modules' -prune \) \
        -o \
        -type f \
    \) -and \
    \! \( \
        -name '.git' \
        -o -name '.Trash' \
        -o -name 'node_modules' \
    \) \
    -maxdepth ${MAX_DEPTH}
}