

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
