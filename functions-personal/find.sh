# Utilities to help find other files / dirs ...

function find_personalbook_dir() {
  # Utilities to help find dirs relevant to other dirs
    find ${DIRS_WORKSPACE} -name personalbook -type l -maxdepth 2 \
    && find ${DIRS_WORKSPACE} -name personalbook -type d -maxdepth 2 \
    | head -n 1
}