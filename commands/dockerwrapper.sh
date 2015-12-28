# Wraps docker commands for multiple container management
function dockerwrapper(){
    _help_mode_=$(test "$1" = "help")
    _command_=${1:-rm} && $_help_mode_ || echo "Docker Command: $_command_"
    _count_=${2:-"1"} && $_help_mode_ || echo "Commad Count: $_count_"
    _machine_=${DOCKER_MACHINE_NAME:-dev}
    case $_command_ in
        status)
           docker-machine status $_machine_
           ;;
        restart)
           docker-machine stop $_machine_
           docker-machine start $_machine_
            ;;
        env)
            docker-machine status $_machine_ | grep Stopped && dockerwrapper restart
            eval "$(docker-machine env $_machine_)" ;
            ;;
        rm)
            docker ps -aq | head -n $_count_ | xargs -I {} bash -c "docker stop {}; docker rm {}"
            ;;
        rmi)
            docker images -aq | head -n $_count_ | xargs docker rmi
            ;;
        ps)
            docker ps -a
            ;;
        *)
            return 1
            ;;
    esac
    return 0
}
function _dockerwrapper(){
  local cur  # Pointer to current completion word.
  COMPREPLY=() # Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]}
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  case "$prev" in
    rm|rmi)
      total=$( docker ps -a --format "{{.Names}}" | wc | awk '{print $1}' )
      options=$(seq 0 ${total:0})
      COMPREPLY=( $( compgen -W "$options" -- $cur ) )
    ;;
    dockerwrapper)
      COMPREPLY=( $( compgen -W "status restart env rm rmi ps" -- $cur ) )
    ;;
  esac
  return 0
}
complete -F _dockerwrapper dockerwrapper
