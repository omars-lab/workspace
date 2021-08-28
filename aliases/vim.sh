
# Install Vim Packages ...
# https://shapeshed.com/vim-packages/

function install_vim_package() {
  REPO=${1}
  PACKAGE=${2}
  test -d ~/.vim/pack/packages/start/${PACKAGE} || \
	( git clone https://github.com/${REPO}/${PACKAGE} ~/.vim/pack/packages/start/${PACKAGE})
}

mkdir -p ~/.vim/pack/packages/
install_vim_package vim-airline vim-airline
install_vim_package preservim nerdtree \
		&& vim -u NONE -c "helptags ~/.vim/pack/packages/start/nerdtree/doc" -c q
install_vim_package nelstrom vim-markdown-folding
install_vim_package tpope vim-commentary
