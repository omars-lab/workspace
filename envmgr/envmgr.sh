export ENVS_CONFIG_FILE=$DIRS_ENVIRONMENT/envmgr/config.json

# Prints a list of all the different envs configured
function all_envs(){
  cat $ENVS_CONFIG_FILE | jq '.[] | .ENV_ID' | xargs -I {} echo -n "{} "
}

# Gets a JSON file, cats it, finds the dict where ENV_ID = $1 and returns a list of all keys in the json
function keys(){
  cat $ENVS_CONFIG_FILE | jq --arg SELECTION "$1" -c '.[] | select(.ENV_ID==$SELECTION) | keys | .[] | tostring ' | xargs echo
}

# Gets a JSON file, cats it, finds the dict where ENV_ID = $1 and extravts the value of the specified key in $2
function value(){
  # echo $1 $2
  cat $ENVS_CONFIG_FILE | jq --arg SELECTION "$1" --arg VALUE "$2" -c '.[] | select(.ENV_ID==$SELECTION) | .[$VALUE] ' | xargs echo
}

# Gets all the keys in an envirement and lists their current value
function list_env(){
  SELECTION=$1
  for key in $(keys $1); do
    value=$(eval "echo $(echo "\$$key")")
    eval "echo $key=$value"
  done
}

# gets all the keys and values for the specified env and sets them
function set_env(){
  selection=$1
  for key in $(keys $1); do
    eval "$SILENT || echo Setting: $key=\"$(value $selection $key)\""
    eval "export $key=\"$(value $selection $key)\""
  done
}

# gets all the keys and values for the specified env and unsets them
function unset_env(){
  selection=$1
  for key in $(keys $1); do
    eval "$SILENT || echo Unsetting: $key=\"$(value $selection $key)\""
    eval "unset $key"
  done
}

function envmgr(){
  command=$1; _environment=$2;
  case "$command" in
    list)
      list_env $_environment
    ;;
    delete)
      unset_env $_environment
    ;;
    use)
      set_env $_environment
    ;;
  esac
}
function _envmgr(){
  local cur  # Pointer to current completion word.
  COMPREPLY=() # Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]}
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  case "$prev" in
    list|delete|use)
      COMPREPLY=( $( compgen -W "$(all_envs)" -- $cur ) )
    ;;
    envmgr)
      COMPREPLY=( $( compgen -W "list delete use" -- $cur ) )
    ;;
  esac
  return 0
}

# Make sure complete is a command (that we are actually in bash)
type complete 2>&1 1>/dev/null && complete -F _envmgr envmgr

# all_envs omarstest
# keys omarstest
# values omartest

alias viconfig="vi $ENVS_CONFIG_FILE"
