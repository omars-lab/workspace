# A collection of useful aliases

alias apm="/Applications/Atom.app/Contents/Resources/app/apm/bin/apm"
alias atom="/Applications/Atom.app/Contents/Resources/app/atom"

# Custom File Editors
alias editcontainers="vi ${DIRS_ENVIRONMENT}/commands/containers.sh"
alias containers="cat ${DIRS_ENVIRONMENT}/commands/containers.sh"
alias editenvs="vi ${DIRS_ENVIRONMENT}/envmgr/config.json"
alias envs="cat ${DIRS_ENVIRONMENT}/envmgr/config.json"
alias editbookmarks="vi ${DIRS_ENVIRONMENT}/bookmarks.sh"
alias bookmarks="cat ${DIRS_ENVIRONMENT}/bookmarks.sh"
alias editaliases="vi ${DIRS_ENVIRONMENT}/aliases.sh"

# Ease directory traversal. Shouldnt need to go up more than 5 dirs
alias .1='push ../'
alias .2='.1; .1;'
alias .3='.2; .1;'
alias .4='.3; .1;'
alias .5='.4; .1;'

alias p='pushd'
alias o='popd'

# Makes a file Executable
alias x='chmod +x'

# Make Tree display root nodes ...
alias tre='tree -C -L 1'

function peek() {
  grep -rl "${1}" . | fzf --preview "grep -b3 -a3 ${1} {}"
}
