#  Helper Function to deploy code into a container
function image_builder(){
  _help_mode_=$(test $1 == help)
  _action_=${1:-attach} && $_help_mode_ || echo "Container Action: $_action_" | grep -v "help"
  _name_=${2:-cognitive_sdk} && $_help_mode_ || echo "Container Name: $_name_"
  _code_=${DIRS_COGSCALE}/${3:-cogscale-python-sdk} && $_help_mode_ || echo "Code Dir: $_name_"
  case $_action_ in
      attach)
          docker attach $_name_;
          ;;
      build)
          docker build -t $_name_ $_code_/ ;
          ;;
      create)
          docker run -itd -v $_code_/:/code -P --name $_name_ $_name_ ;
          ;;
      remove)
          docker stop $_name_ ;
          docker rm $_name_ ;
          ;;
      *)
          return 1
          ;;
  esac
  return 0
}
function _image_builder(){
  local cur  # Pointer to current completion word.
  COMPREPLY=() # Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]}
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  case "$prev" in
    attach|remove)
      containers=$( docker ps -a --format "{{.Names}}" | wc | awk '{print $1}' )
      containers=$(echo $containers | grep -Ev '^0$')
      COMPREPLY=( $( compgen -W "$containers" -- $cur ) )
    ;;
    create)
      images=$(docker images | grep latest | cut -f 1 -d ' ' | xargs -I {} echo -n "{} ")
      COMPREPLY=( $( compgen -W "$images" -- $cur ) )
    ;;
    image_builder)
      COMPREPLY=( $( compgen -W "attach remove create build" -- $cur ) )
    ;;
  esac
  return 0
}

# Make sure complete is a command (that we are actually in bash)
type complete 2>&1 1>/dev/null && complete -F _image_builder image_builder
