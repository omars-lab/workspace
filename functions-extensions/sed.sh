# Tools for commno substitutions

function md-unlink() {
  # Remove links from md content ...
  sed 's/\[\([^]]*\)\]([^)]*)/\1/g'
}

# Function / Aliases to help with text processing

function upper() {
  tr '[:lower:]' '[:upper:]'
}

function lower() {
  tr '[:upper:]' '[:lower:]'
}

# https://gist.github.com/jaytaylor/5a90c49e0976aadfe0726a847ce58736
function sed-url-encode() {
  sed \
    -e 's/%/%25/g' \
    -e 's/ /%20/g' \
    -e 's/!/%21/g' \
    -e 's/"/%22/g' \
    -e "s/'/%27/g" \
    -e 's/#/%23/g' \
    -e 's/(/%28/g' \
    -e 's/)/%29/g' \
    -e 's/+/%2b/g' \
    -e 's/:/%3a/g' \
    -e 's/;/%3b/g' \
    -e 's/?/%3f/g' \
    -e 's/@/%40/g' \
    -e 's/\$/%24/g' \
    -e 's/\&/%26/g' \
    -e 's/\*/%2a/g' \
    -e 's/\[/%5b/g' \
    -e 's/\\/%5c/g' \
    -e 's/\]/%5d/g' \
    -e 's/\^/%5e/g' \
    -e 's/_/%5f/g' \
    -e 's/`/%60/g' \
    -e 's/{/%7b/g' \
    -e 's/|/%7c/g' \
    -e 's/}/%7d/g' \
    -e 's/~/%7e/g'
    # -e 's/\//%2f/g' \
    # -e 's/,/%2c/g' \
    # -e 's/-/%2d/g' \
    # -e 's/\./%2e/g' \
}