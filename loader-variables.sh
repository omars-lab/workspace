# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------

# if [ -n "$ZSH_VERSION" ]; then
#   CURRENT_DIR=${0:a:h}
# elif [ -n "$BASH_VERSION" ]; then
#   CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# else
#    exit 1
# fi

source ${CURRENT_DIR}/common.sh >/dev/null
source ${CURRENT_DIR}/variables/icloud.sh
source ${CURRENT_DIR}/variables/hardware.sh
source ${CURRENT_DIR}/variables/dirs.sh
source ${CURRENT_DIR}/variables/fzf.sh
source ${CURRENT_DIR}/variables/ssh.sh
source ${CURRENT_DIR}/variables/apps.sh
source ${CURRENT_DIR}/variables/aws.sh
source ${CURRENT_DIR}/variables/opts.sh
# Intentionally setting variables last
source ${CURRENT_DIR}/variables/path.sh
source ${CURRENT_DIR}/overrides/$(get_uniq_mac_id)/variables.sh