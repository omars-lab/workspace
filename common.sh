# Contains general Linux/Unix helper functions

# function get_other_user(){
#   users | sed -e "s/$(whoami)//g" -e 's/ *//g'
# }

function get_other_user(){
  USERS=$(dscl . list /Users | grep -v "^_" | grep --color=never eid | tr '\n' ' ')
  # This lists all "logged in" users ... this wont work if I first boot up the mac ...
  # USERS=$(users | sed -e "s/$(whoami)//g" -e 's/ *//g')
  echo ${USERS} | sed -e "s/$(whoami)//g" -e 's/ *//g'
}

function split_and_prefix(){
  echo "${1}" \
    | tr "|" "\n" \
    | xargs printf " ${2} '%s' "
}

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

alias serialnumber=get_uniq_mac_id

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

function extract_functions(){
    echo $(cat $1 | grep -Eo "^(?:function )(\w+)" | grep -Eo "\\w+$" | grep -E "^[a-zA-Z]" | xargs echo -n)
}

function extract_variables(){
    echo $(cat $1 | grep -Eo "^(?:export )(\w+)" | grep -Eo "\w+$")
}

function print_variables(){
    echo $@ | xargs printenv
}

# SILENT=false

# Recusively source all .sh files within a directory
# The first param is the directoy.
# The second param is an expression of files to ignore.
function recursive_source(){
    rdir=$1
    ignore=${2:-"^\s*$"}
    # $SILENT || echo "Recursively Sourcing $rdir, ignoring: $ignore" 1>&2
    # Using Python Time ... since mac date doesnt have microsecond resolution
    TIME_BEFORE=$(python3 -c 'import time; print(time.time())')
    for i in $(ls -c1 $rdir | grep -e ".*[.]sh" | grep -vE "$ignore"); do
        $SILENT || echo Sourcing $rdir/$i;
        source $rdir/$i ;
    done
    TIME_AFTER=$(python3 -c 'import time; print(time.time())')
    # https://unix.stackexchange.com/questions/93029/how-can-i-add-subtract-etc-two-numbers-with-bash
    # DURATION=$(( ${TIME_AFTER} - ${TIME_BEFORE} )) # expr in bash can't deal with decimal places
    DURATION=$(echo "${TIME_AFTER} - ${TIME_BEFORE}" | bc -l )
    $SILENT || echo "Sourced $rdir in ${DURATION}" 1>&2
}


# Re-source the bash profile
# function re-source(){
#     source ~/.bash_profile
# }

function first(){
  # picks the first valid file ... recrsively ...
  if [[ "$#" == "0" ]]; then
    echo "No files/dirs satisfied!" >&2
    return
  fi

  if [[ -f "${1}" ]]
  then
    echo "${1}"
    return
  else 
    echo "File not found: [${1}]" >&2
  fi

  if [[ -d "${1}" ]]; 
  then
    echo "${1}"
    return
  else 
    echo "Dir not found: [${1}]" >&2
  fi

  shift
  first $@
}

if [[ "${DETECTED_SHELL}" = "BASH" ]]
then
    export -f first
    export -f get_other_user
    export -f split_and_prefix
    # export -f get_other_user
    export -f get_uniq_mac_id
    export -f symlink_if_dne
    export -f symlink_by_force
    export -f create_zip_WITH_NAME_relavtive_to_DIR_recrusively
    export -f extract_functions
    export -f extract_variables
    export -f print_variables
    export -f recursive_source
fi
