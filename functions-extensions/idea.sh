
alias intellij='/usr/local/bin/idea'

# Apps 
function intellij() {
	open -a "IntelliJ IDEA.app" $@
}

function pycharm(){
  open -a "PyCharm CE" $@
}
