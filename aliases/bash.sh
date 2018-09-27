DEFAULT_FORMAT='+%Y-%m-%d'

function today() {
  echo $(date -r $(date '+%s') ${1:-${DEFAULT_FORMAT}})
}

function yesterday() {
  echo $(date -r $(expr $(date '+%s') - 86400 ) ${1:-${DEFAULT_FORMAT}})
}

function tomorrow() {
  echo $(date -r $(expr $(date '+%s') - 86400 ) ${1:-${DEFAULT_FORMAT}})
}

function cd(){
  # Smarter CD ...
  # If no path specified ... cd ...
  if [ -z "$@" ];
  then
    # echo just cd-ing
    builtin cd ${@}
  else
    # If full path ... cd ...
    if [[ $(eval echo "$@") = /* ]];
    then
      # echo just cd-ing
      builtin cd ${@}
    else
      # If relative path ...
      # Jump only if relative dir doesnt exist locally
      if [ ! -d "$@" ];
      then
        # echo jumping
        j $@
      else
        # echo just cd-ing
        builtin cd ${@}
      fi
    fi
  fi
}
