# brew.sh

function brew-list-aws-tap() {
	TAP=amazon/homebrew-amazon
	TAP_PREFIX=$(brew --prefix)/Homebrew/Library/Taps
	( \
		   ls $TAP_PREFIX/$TAP/Formula/*.rb 2>/dev/null \
		|| ls $TAPI_PREFIX/$TAP/*.rb 2>/dev/null \
	) | xargs -I{} basename {} .rbI
}


function uninstall-plugins() {
	code --list-extensions | grep oeid | xargs -n 1 code --uninstall-extension
	brew uninstall workspace

}

function reinstall-plugins() {
	brew update --preinstall
	brew install omars-lab/tap/workspace --with-amazon --debug
	vscode-reinstall-plugins
}
