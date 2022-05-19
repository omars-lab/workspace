# Sourcing Completions ...

# If being sourced in bash ...
if [[ -n "$BASH_VERSION" && "${BASH_SOURCE[0]}" != "${0}" ]]
then 

  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
  complete -C '/usr/local/bin/aws_completer' aws

  [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

fi 
