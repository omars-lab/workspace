# Contains commands oriented towards osx.

alias SPACE_DOCK="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'"

# alias rm='mv $@ ~/.Trash/'

function trash(){
  mv $@ ~/.Trash/
}

function flush_dns_cache(){
  sudo discoveryutil mdnsflushcache;
  sudo discoveryutil udnsflushcaches;
  say flushed
}

function show_hidden_files(){
  sudo chflags nohidden /usr
  defaults write com.apple.finder AppleShowAllFiles YES;
  killall Finder;
}

function hide_hidden_files(){
  sudo chflags hidden /usr
  defaults write com.apple.finder AppleShowAllFiles NO;
  killall Finder;
}

function _osx(){
  cur=${COMP_WORDS[COMP_CWORD]}
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  case "$prev" in
    osx)
      COMPREPLY=( $( compgen -W "flush_dns_cache show_hidden_files hide_hidden_files" -- $cur ) )
    ;;
    *)
      return 1
    ;;
  esac
  return 0
}
function osx(){
  case $1 in
    flush_dns_cache)
      flush_dns_cache
    ;;
    show_hidden_files)
      show_hidden_files
    ;;
    hide_hidden_files)
      hide_hidden_files
    ;;
  esac
}
complete -F _osx osx
