
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

function open:chrome-tab-with-git-repo() {
  (git config --get remote.origin.url | grep github) &&
    open:chrome-tab-with-github-repo || open:chrome-tab-with-bitbucket-repo
}

function open:chrome-tab-with-github-repo() {
  local REPO_URL=$(github_url)
  echo "Opening Github Repo: ${REPO_URL}"
  open:chrome-tab "${REPO_URL}"
}

function open:chrome-tab-with-bitbucket-repo() {
  local REPO_URL=$(bitbucket_url)
  echo "Opening Bitbucket Repo: ${REPO_URL}"
  open:chrome-tab "${REPO_URL}"
}

function open:chrome-tab-with-file-in-git-repo() {
  local FILE="${1}"
  (git config --get remote.origin.url | grep github) \
    && ( open:chrome-tab-with-file-in-github-repo "${FILE}" ) \
    || ( open:chrome-tab-with-file-in-bitbucket-repo "${FILE}" )
}

function open:chrome-tab-with-file-in-github-repo() {
  local RELATIVE_FILE=$(git ls-files --full-name "${1}")
  local REPO_URL=$(github_url "blob")
  echo "Opening File ${RELATIVE_FILE} Github Repo: ${REPO_URL}"
  local URL=${REPO_URL}/${RELATIVE_FILE}
  open:chrome-tab "${URL}"
}

function open:chrome-tab-with-file-in-bitbucket-repo() {
  local RELATIVE_FILE=$(git ls-files --full-name "${1}")
  local REPO_URL=$(bitbucket_url)
  echo "Opening File ${RELATIVE_FILE} BitBucket Repo: ${REPO_URL}"
  local URL=${REPO_URL}/${RELATIVE_FILE}
  open:chrome-tab "${URL}"
}
