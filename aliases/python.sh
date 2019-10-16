function conda_switch(){
  if [ -z "${CONDA_DEFAULT_ENV}" ]; then
    conda deactivate
  fi
  conda activate "${1}"
}
