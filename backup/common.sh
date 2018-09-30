#!/bin/bash

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

export -f get_uniq_mac_id
export -f symlink_if_dne
export -f symlink_by_force
export -f create_zip_WITH_NAME_relavtive_to_DIR_recrusively
