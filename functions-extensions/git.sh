# Git Aliases
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