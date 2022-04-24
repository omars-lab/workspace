# Git Aliases
alias gs='git status'
alias ga='git add'
alias gaall='git add'
alias gp='git pull'
alias gc='git commit -am'
alias gd='git diff'
alias gl='git log'

function wip () {
  git add --all
  git commit -m "WIP"
}

function pullpush() {
    git pull
    git push origin $(git rev-parse --abbrev-ref HEAD)
}

function git-commits(){
  git --no-pager log --pretty="format:%H	%aI	%s"
}