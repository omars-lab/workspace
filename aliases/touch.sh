function touch-image() {
  COLOR="${COLOR:-transparent}"
  IMAGE_PATH="${1:-${COLOR}.png}"
  CANVAS_SIZE="${CANVAS_SIZE:-1000}"
  echo "Creating image with name:${IMAGE_PATH}, color:${COLOR}, and size :${CANVAS_SIZE}"
  # https://stackoverflow.com/questions/39504522/create-blank-image-in-imagemagick
  convert -size ${CANVAS_SIZE}x${CANVAS_SIZE} xc:${COLOR} "${IMAGE_PATH}"
  open -a Preview "${IMAGE_PATH}"
}

function touch-makefile() {
  echo 'SHELL := /bin/bash'
  echo 'MAKEFILE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))'
}
