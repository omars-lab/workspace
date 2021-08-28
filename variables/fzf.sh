
# - [ ] Move over configs somewhere else!
# Fuzzy Config ...
# FZF_IGNORE_PATTERNS='*.pyc|*.class|*.iml|*.DS_Store'
# FZF_IGNORE_PATTERNS=$(split_and_prefix "${FZF_IGNORE_PATTERNS}" "--ignore")
# FZF_IGNORE_DIRS=".git|target|.idea|.atom|.bash_sessions|.cache|.config|Music|Pictures|google-drive-c12e"
# FZF_IGNORE_DIRS=$(split_and_prefix "${FZF_IGNORE_DIRS}" "--ignore-dir")
# export FZF_DEFAULT_COMMAND="ag --hidden ${FZF_IGNORE_PATTERNS} ${FZF_IGNORE_DIRS} -g '' "

# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r
export FZF_CTRL_R_OPTS='--sort --exact'
# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-t
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
