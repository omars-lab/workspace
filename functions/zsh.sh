# ZSH Extentions

if [[ ! -z "$(echo $0 | grep zsh )" ]];
then
  # allow ctrl-r to work with terminal vi-Mode
  bindkey -M viins '^r' history-incremental-search-backward
  bindkey -M vicmd '^r' history-incremental-search-backward
fi
