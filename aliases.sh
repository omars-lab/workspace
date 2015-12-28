# A collection of useful aliases

# Docker
alias dps='docker ps -a'
alias drm='docker rm'
alias drmi='docker rmi'
alias drun='docker run'

# Sublime Shortcut. Depends on the installation of sublime.
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

# Ease directory traversal. Shouldnt need to go up more than 5 dirs
alias .1='push ../'
alias .2='.1; .1;'
alias .3='.2; .1;'
alias .4='.3; .1;'
alias .5='.4; .1;'

alias p='pushd'
alias o='popd'

alias START_INFLUX='influxd -config /usr/local/etc/influxdb.conf'

alias go_git='p $DIRS_GITHUB'
alias go_env='p $DIRS_ENVIRONMENT'
alias go_play='p $DIRS_PLAGROUND'
alias go_katkuti='p /Users/oeid/Dropbox/Apps/KISSr'

alias gs='git status'
alias ga='git add'
alias gaall='git add'
alias gp='git pull'
alias gc='git commit -am'
alias gd='git diff'
alias gl='git log'
