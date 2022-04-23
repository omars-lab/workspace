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
