
function conda-switch(){
  if [ -z "${CONDA_DEFAULT_ENV}" ]; then
    conda deactivate
  fi
  conda activate "${1}"
}

function pip-versions(){
  local PACKAGE=${1}
  pip install "${PACKAGE}==" 2>&1 | grep "${PACKAGE}" \
    | grep -E -o '([0-9]+.)?[0-9]+.[0-9]+([-a-zA-Z]+[0-9]+)?' | sort -r
}

function pip-package-latest-versions(){
  pip install ${1}== 2>&1 | egrep -o '[0-9]+.[0-9]+.[0-9]+([ab]|dev|rc)([0-9]+)?'
}


function python-dir-site-packages(){
  # Get the current site packages dir ...
  python -c 'import site; print(site.getsitepackages()[0])'
}


function ipython-clear-notebook-output() {
    # Removing output from an ipython notebook ...
  cat ${1} | jq '. as $orig | [ $orig | .cells | .[] | .outputs |= [] ] as $cells | $orig.cells = $cells'
}
