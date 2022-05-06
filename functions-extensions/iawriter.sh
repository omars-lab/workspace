function find_iawriter_files() {
    (cd "${NOTEPLAN_ICLOUD_DIR}" && find_files) | gsed -E 's#^./#NotePlan/#'
    (cd "${DIR_FOR_IA_WRITER_ICLOUD}" && find_files) | gsed -E 's#^./#iCloud/#'
    (cd "${DIR_FOR_IA_WRITER}" && find_files) | gsed -E 's#^./#iA%20Writer/#'
    (cd "${DIR_FOR_HATS}" && find_files) | gsed -E "s#^./#$(basename ${DIR_FOR_HATS})/#"
}