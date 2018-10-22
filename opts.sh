
if [ -n "$ZSH_VERSION" ]; then
  export HISTFILE="$HOME/.zsh_history"
  export HISTSIZE=10000000
  export SAVEHIST=10000000

  setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
  setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
  setopt SHARE_HISTORY             # Share history between all sessions.
  setopt HIST_VERIFY
elif [ -n "$BASH_VERSION" ]; then
  echo No Bash Options Set ...
else
  exit 1
fi
