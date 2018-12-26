# Removing output from an ipython notebook ...
function ipython_clear_notebook_output() {
  cat ${1} | jq '. as $orig | [ $orig | .cells | .[] | .outputs |= [] ] as $cells | $orig.cells = $cells'
}

function current_site_packages_dir(){
  python -c 'import site; print(site.getsitepackages()[0])'
}
