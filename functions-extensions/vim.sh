
# Install Vim Packages ...
# https://shapeshed.com/vim-packages/

function install_vim_package() {
  REPO=${1}
  PACKAGE=${2}
  test -d ~/.vim/pack/packages/start/${PACKAGE} || \
	( git clone https://github.com/${REPO}/${PACKAGE}.git ~/.vim/pack/packages/start/${PACKAGE})
}

function install_vim_plugins() {
  mkdir -p ~/.vim/pack/packages/
  install_vim_package vim-airline vim-airline
  install_vim_package nelstrom vim-markdown-folding
  install_vim_package tpope vim-commentary
  install_vim_package preservim nerdtree \
      && vim -u NONE -c "helptags ~/.vim/pack/packages/start/nerdtree/doc" -c q
}

function vi:personalbook(){
  (cd "$(find_personalbook_dir)" ; fvi)
}

function vi:noteplan(){
  (cd "${NOTEPLAN_ICLOUD_DIR}/Calendar" ; fvi)
}

function vi:noteplan-notes(){
  (cd "${NOTEPLAN_ICLOUD_DIR}/Notes" ; fvi)
}

# Shortcuts to quickly edit vim files ...
function edit-overrides() {
  vi "${DIRS_WORKSPACE}/git/environment/overrides/$(get_uniq_mac_id)/variables.sh"
}

export -f edit-overrides
