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

if [[ ! -z "$(echo $0 | grep zsh )" ]];
then
  # allow ctrl-r to work with terminal vi-Mode
  bindkey -M viins '^r' history-incremental-search-backward
  bindkey -M vicmd '^r' history-incremental-search-backward
fi
