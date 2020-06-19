
function github_url() {
  MODE=${1:-tree}
  git config --get remote.origin.url \
      | sed 's#git@github.com:#https://github.com/#g' \
      | sed "s#.git\$#/tree/$(git rev-parse --abbrev-ref HEAD)#g" \
}

function bitbucket_url() {
  git config --get remote.origin.url \
      | sed 's#git@bitbucket.org:#https://bitbucket.org/#g' \
      | sed "s#.git\$#/src/$(git rev-parse --abbrev-ref HEAD)#g" \
}

function open:chrome-tab() {
  open -na "Google Chrome" --args --new-tab "${1}"
}
DEFAULT_BROWSER=open:chrome-tab
alias browser="${DEFAULT_BROWSER}"

function open:git-repo-in-browser-tab() {
  (git config --get remote.origin.url | grep github) &&
    open:github-repo-in-browser-tab || open:bitbucket-repo-in-browser-tab
}
alias git-repo='open:git-repo-in-browser-tab'

function open:github-repo-in-browser-tab() {
  local REPO_URL=$(github_url)
  echo "Opening Github Repo: ${REPO_URL}"
  ${BROWSER:-${DEFAULT_BROWSER}} "${REPO_URL}"
}
alias github-repo='open:github-repo-in-browser-tab'

function open:bitbucket-repo-in-browser-tab() {
  local REPO_URL=$(bitbucket_url)
  echo "Opening Bitbucket Repo: ${REPO_URL}"
  ${BROWSER:-${DEFAULT_BROWSER}} "${REPO_URL}"
}
alias bitbucket-repo='open:bitbucket-repo-in-browser-tab'

function open:git-file-in-browser-tab() {
  local FILE="${1}"
  (git config --get remote.origin.url | grep github) \
    && ( open:github-file-in-browser-tab "${FILE}" ) \
    || ( open:bitbucket-file-in-browser-tab "${FILE}" )
}
alias git-file='open:git-file-in-browser-tab'

function open:github-file-in-browser-tab() {
  local RELATIVE_FILE=$(git ls-files --full-name "${1}")
  local REPO_URL=$(github_url "blob")
  echo "Opening File ${RELATIVE_FILE} Github Repo: ${REPO_URL}"
  local URL=${REPO_URL}/${RELATIVE_FILE}
  ${BROWSER:-${DEFAULT_BROWSER}} "${URL}"
}
alias github-file='open:github-file-in-browser-tab'

function open:bitbucket-file-in-browser-tab() {
  local RELATIVE_FILE=$(git ls-files --full-name "${1}")
  local REPO_URL=$(bitbucket_url)
  echo "Opening File ${RELATIVE_FILE} BitBucket Repo: ${REPO_URL}"
  local URL=${REPO_URL}/${RELATIVE_FILE}
  ${BROWSER:-${DEFAULT_BROWSER}} "${URL}"
}
alias bitbucket-file='open:bitbucket-file-in-browser-tab'
