# Contains commands oriented towards osx.

alias SPACE_DOCK="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'"

# alias rm='mv $@ ~/.Trash/'

function trash(){
  mv $@ ~/.Trash/
}

function flush_dns_cache(){
  # https://documentation.cpanel.net/display/CKB/How+To+Clear+Your+DNS+Cache#HowToClearYourDNSCache-MacOS10.10.1,10.10.2,and10.10.3
  # sudo discoveryutil mdnsflushcache
  # sudo discoveryutil udnsflushcaches
  sudo killall -HUP mDNSResponder
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

function add_dock_space() {
	# https://www.imore.com/add-space-your-mac-dock
	defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
	killall Dock
}

function _osx(){
  cur=${COMP_WORDS[COMP_CWORD]}
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  case "$prev" in
    osx)
      COMPREPLY=( $( compgen -W "flush_dns_cache show_hidden_files hide_hidden_files add_dock_space" -- $cur ) )
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
    add_dock_space)
      add_dock_space
    ;;
  esac
}

function is_a_mac() {
    uname | grep -q Darwin
}

if (is_a_mac)
then
    # https://apple.stackexchange.com/questions/372032/usr-include-missing-on-macos-catalina-with-xcode-11
    export CPATH=$(xcrun --show-sdk-path)/usr/include
fi

# Make sure complete is a command (that we are actually in bash)
type complete 2>&1 1>/dev/null && complete -F _osx osx
