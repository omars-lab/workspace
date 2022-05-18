# https://stackoverflow.com/questions/4210042/how-to-exclude-a-directory-in-find-command
function find_files() {
    # MAX_DEPTH=${1:-3}
    FIND_DIR=${1:-.}
    find "${FIND_DIR}" \( \
        \( -name '*.Trash' -prune -o -name '.git' -prune -o -name 'node_modules' -prune \) \
        -o \
        -type f \
    \) -and \
    \! \( \
        -name '.git' \
        -o -name '.Trash' \
        -o -name 'node_modules' \
    \)
    # -maxdepth ${MAX_DEPTH}
}

function find_iawriter_files() {
    (cd "${NOTEPLAN_ICLOUD_DIR}" && find_files) | gsed -E 's#^./#NotePlan/#'
    (cd "${DIR_FOR_IA_WRITER_ICLOUD}" && find_files) | gsed -E 's#^./#iCloud/#'
    (cd "${DIR_FOR_IA_WRITER}" && find_files) | gsed -E 's#^./#iA%20Writer/#'
    (cd "${DIR_FOR_HATS}" && find_files) | gsed -E "s#^./#$(basename ${DIR_FOR_HATS})/#"
}

function find_vscode_documents {
    find_files "${DIRS_GIT}/blueprints"
    find_files"${DIRS_GIT}/personalbook"
}

function find_noteplan_documents {
    find_files "${HOME}/.noteplan/"
}