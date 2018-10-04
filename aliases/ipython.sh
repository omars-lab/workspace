# Removing output from an ipython notebook ...
function ipython_clear_notebook_output() {
  cat ${1} | jq '. as $orig | [ $orig | .cells | .[] | .outputs |= [] ] as $cells | $orig.cells = $cells'
}
