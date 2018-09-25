#!/bin/bash

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