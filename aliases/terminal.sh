export DISABLE_AUTO_TITLE="true"

setTerminalText () {
    # Works in bash & zsh
    # $1 is where we want to set the title
    #	=> { 0: both, 1: tab, 2: title}
    local mode=$1 ; shift
    echo -ne "\033]$mode;$@\007"
}
title_terminal () { setTerminalText 2 $@; }
title_both  () { setTerminalText 0 $@; }
title  () { setTerminalText 1 $@; }

function week_prompt(){
  echo "___________________________________"  
  echo "$(date +%FT%T%z)" "y:" "$(date +%Y)" "w:" "$(date +%V)"
}


function bash_title {
   # setup terminal tab title ... only works in bash
   if [ "$1" ]
   then
       unset PROMPT_COMMAND
       echo -ne "\033]0;${*}\007"
   else
       export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
   fi
}
