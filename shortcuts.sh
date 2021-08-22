#!/bin/bash

function touch-sh() {
  test -f ${1:?First arg must be path of sh file to create.} || { 
    echo '#!/bin/bash' > "${1}" ; \
    echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" >/dev/null 2>&1 && pwd )"' >> "${1}" ; \
    chmod +x "${1}" ; \
  }
}

function git-commits(){
  git --no-pager log --pretty="format:%H	%aI	%s"
}

function password-set() {
  # https://www.netmeister.org/blog/keychain-passwords.html#:~:text=To%20add%20a%20secret%20to,line%20utility%20security(1).&text=After%20clicking%20'Add'%2C%20your,available%20in%20the%20login%20keychain.
  PASS=$(cat)
  security add-generic-password -a ${USER} -s ${1} -w "${PASS}" -U
}

function password-get() {
  security find-generic-password -a ${USER} -s ${1} -w
}

function jira-jwt() {
  # https://developer.atlassian.com/cloud/jira/platform/basic-auth-for-rest-apis/?_ga=2.181259236.250092388.1591889586-1424938611.1580437836
  echo -n ${USER}@cognitivescale.atlassian.net:$(password-get JIRA_API_TOKEN) | base64

}
function jira-curl() {
  # https://confluence.atlassian.com/cloud/api-tokens-938839638.html
  URL=${1}
  shift
  curl https://cognitivescale.atlassian.net/${URL} \
    --user "${USER}@cognitivescale.atlassian.net:$(password-get JIRA_API_TOKEN)" \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic $(jira-jwt)" \
    $@
}

function jira-curl-jql() {
  # https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/
  # https://developer.atlassian.com/cloud/jira/platform/rest/v2/#api-rest-api-2-issue-picker-get
  # https://developer.atlassian.com/cloud/jira/platform/rest/v2/#api-rest-api-2-jql-match-post
  # Need ouath scope ...
    # https://developer.atlassian.com/cloud/jira/platform/rest/v2/#api-rest-api-2-jql-match-post
  # Match - only to see if issues are matched by jql ...
  jira-curl rest/api/2/jql/match $@
}
