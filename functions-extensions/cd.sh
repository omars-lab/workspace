# Aliases to help with switching dirs ...

# Ease directory traversal. Shouldnt need to go up more than 5 dirs
alias .1='push ../'
alias .2='.1; .1;'
alias .3='.2; .1;'
alias .4='.3; .1;'
alias .5='.4; .1;'

alias p='pushd'
alias o='popd'

# For git every directory ... create a cd alias to cd into the dir ...
for d in $(ls -1 ${DIRS_GIT})
do
  eval "alias cd-${d}='cd ${DIRS_GIT}/${d}'"
done 

alias plugins='cd /Users/oeid/workplace/scripts/sh-plugins'

# Navigation
function ..() {
	cd ..
}

# function cd(){
#   # Smarter CD ...
#   # If no path specified ... cd ...
#   if [ -z "$@" ];
#   then
#     # echo just cd-ing
#     builtin cd ${@}
#   else
#     if [[ $(eval echo "$@") = - ]];
#     then
#       builtin cd ${@}
#     else
#       # If full path ... cd ...
#       if [[ $(eval echo "$@") = /* ]];
#       then
#         # echo just cd-ing
#         builtin cd ${@}
#       else
#         # If relative path ...
#         # Jump only if relative dir doesnt exist locally
#         if [ ! -d "$@" ];
#         then
#           # echo jumping
#           j $@
#         else
#           # echo just cd-ing
#           builtin cd ${@}
#         fi
#       fi
#     fi
#   fi
# }
