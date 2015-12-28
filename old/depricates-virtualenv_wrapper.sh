# # Facilitates the creation of a cognitive virtual env #
# function _virtualenv_options(){
#   local cur
#   COMPREPLY=()   # Array variable storing the possible completions.
#   cur=${COMP_WORDS[COMP_CWORD]}
#   prev="${COMP_WORDS[COMP_CWORD-1]}"
#   case ${prev} in
#     activate|remove)
#       STUFF=$(find $DIRS_VIRTUAL_ENVS -type d -depth 1 | xargs -I {} basename {})
#       COMPREPLY=( $( compgen -W "$STUFF" -- $cur ) )
#     ;;
#     virtualenv_wrapper)
#       STUFF=$(echo "activate create remove")
#       COMPREPLY=( $( compgen -W "$STUFF" -- $cur ) )
#     ;;
#   esac
#   return 0
# }
# function virtualenv_wrapper(){
#   case ${1:-activate} in
#     activate)
#       cd $DIRS_VIRTUAL_ENVS ;
#       source $2/bin/activate ;
#       cd - ;
#     ;;
#     create)
#       cd $DIRS_VIRTUAL_ENVS ;
#       virtualenv $2 ;
#       cd - ;
#       virtualenv_wrapper activate $2 ;
#       cd $DIRS_COGSCALE/cogscale-python-sdk ;
#       pip install -r requirements.txt ;
#       cd - ;
#     ;;
#     remove)
#       rm -r $DIRS_VIRTUAL_ENVS/$2
#     ;;
#     *)
#       return 1
#     ;;
#   esac
#   return 0
# }
# complete -F _virtualenv_options virtualenv_wrapper
