
function chrome-links() {
    chrome-cli list links | sed -E -e 's/^\[([0-9]+):([0-9]+)\] (.*)/\3/g' | sed -E -e 's/^\[([0-9]+)\] (.*)/\2/g' | optionally_filter "${1}"
}