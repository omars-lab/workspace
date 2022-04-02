# Function / Aliases to help with text processing

function upper() {
  tr '[:lower:]' '[:upper:]'
}

function lower() {
  tr '[:upper:]' '[:lower:]'
}
