# Aliases / Function to help with dealing with dates

DEFAULT_FORMAT='+%Y-%m-%d'

# date -u +"%Y-%m-%dT%H:%M:%SZ"

function utc_now(){
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

function utc_from_seconds(){
  date -u -r ${1} +"%Y-%m-%dT%H:%M:%SZ"
}

function utc_from_miliseconds(){
  utc_from_seconds $(expr ${1} / 1000)
}

function noteplan_date_now(){
  date +"@done(%Y-%m-%d %I:%M %p)"
}

function today() {
  echo $(date -r $(date '+%s') ${1:-${DEFAULT_FORMAT}})
}

function yesterday() {
  echo $(date -r $(expr $(date '+%s') - 86400 ) ${1:-${DEFAULT_FORMAT}})
}

function tomorrow() {
  echo $(date -r $(expr $(date '+%s') - 86400 ) ${1:-${DEFAULT_FORMAT}})
}
