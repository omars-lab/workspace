DEFAULT_FORMAT='+%Y-%m-%d'

function today() {
  echo $(date -r $(date '+%s') ${1:-${DEFAULT_FORMAT}})
}

function yesterday() {
  echo $(date -r $(expr $(date '+%s') - 86400 ) ${1:-${DEFAULT_FORMAT}})
}

function tomorrow() {
  echo $(date -r $(expr $(date '+%s') - 86400 ) ${1:-${DEFAULT_FORMAT}})
}
