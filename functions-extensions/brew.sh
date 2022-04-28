# brew.sh

function brew-list-aws-tap() {
	TAP=amazon/homebrew-amazon
	TAP_PREFIX=$(brew --prefix)/Homebrew/Library/Taps
	( \
		   ls $TAP_PREFIX/$TAP/Formula/*.rb 2>/dev/null \
		|| ls $TAPI_PREFIX/$TAP/*.rb 2>/dev/null \
	) | xargs -I{} basename {} .rbI
}

function brew-uninstall-plugins() {
	code --list-extensions | grep oeid | xargs -n 1 code --uninstall-extension
	brew uninstall workspace
	brew uninstall sharedspace

}

function brew-install-plugins() {
	brew update --preinstall
	brew install omars-lab/tap/workspace --with-amazon --debug
	brew install sharedspace
	vscode-reinstall-plugins
	sharedworkspace-installer.sh
}

function brew-reinstall-plugins() {
	brew-uninstall-plugins	
	brew-install-plugins
}
