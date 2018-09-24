#!/bin/bash

function get_uniq_mac_id(){
  # Get the Mac Address ...
  # ifconfig en0 ether | grep ether | sed 's/.*ether /mac-address-/g' | sed 's/ *//g'
  # Get Serial address of the mac
  system_profiler SPHardwareDataType | grep 'Serial Number' | sed 's/[^:]*://g' | sed 's/ *//g'
}
export -f get_uniq_mac_id