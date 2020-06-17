function open:chrome-tab() {
  open -na "Google Chrome" --args --new-tab "${1}"
}

function open:chrome-tab-with-git-repo() {
  (git config --get remote.origin.url | grep github) &&
    open:chrome-tab-with-github-repo || open:chrome-tab-with-bitbucket-repo
}

function open:chrome-tab-with-github-repo() {
  local REPO_URL=$(git config --get remote.origin.url \
      | sed 's#git@github.com:#https://github.com/#g' \
      | sed "s#.git\$#/tree/$(git rev-parse --abbrev-ref HEAD)#g" \
  )
  echo "Opening Github Repo: ${REPO_URL}"
  open:chrome-tab "${REPO_URL}"
}

function open:chrome-tab-with-bitbucket-repo() {
  local REPO_URL=$(git config --get remote.origin.url \
      | sed 's#git@bitbucket.org:#https://bitbucket.org/#g' \
      | sed "s#.git\$#/src/$(git rev-parse --abbrev-ref HEAD)#g" \
  )
  echo "Opening Bitbucket Repo: ${REPO_URL}"
  open:chrome-tab "${REPO_URL}"
}
