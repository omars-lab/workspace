#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${CURRENT_DIR}/../common.sh

# The following explain how this thing works ...
#   - http://www.launchd.info/

# - [x] Make shared dir for clipboard ...
# - Important to consider when choosing a shared folder ... https://superuser.com/questions/187071/in-macos-how-often-is-tmp-deleted
SHARED_PASTE2_DIR="/Users/Shared/$(get_other_user)/clipboard"
mkdir -p ${SHARED_PASTE2_DIR}

# Install Paste2 Plist
PATH_OF_PASTE2_PLIST="${CURRENT_DIR}/../configs/mac/LaunchAgents/paste2-login-loader.plist"
PATH_OF_PASTE2_EXEC="${CURRENT_DIR}/paste2-loader.sh"
SHARED_PASTE2_EXEC="/Users/Shared/paste2-loader.sh"
PATH_OF_FINAL_PLIST="${HOME}/Library/LaunchAgents/$(basename ${PATH_OF_PASTE2_PLIST})"

cp "${PATH_OF_PASTE2_EXEC}" "${SHARED_PASTE2_EXEC}"
chmod +x "${SHARED_PASTE2_EXEC}"
sudo chown root "${SHARED_PASTE2_EXEC}"

sed \
  -e "s^EXECUTABLE_PATH^${SHARED_PASTE2_EXEC}^g" \
  -e "s^CLIPBOARD_DIRECTORY^${SHARED_PASTE2_DIR}^g" \
  "${PATH_OF_PASTE2_PLIST}" \
  | tee ${PATH_OF_FINAL_PLIST}

# - [x] Unload previously installed script
test -f ${PATH_OF_PASTE2_PLIST} && launchctl unload ${PATH_OF_PASTE2_PLIST}
launchctl load ${PATH_OF_PASTE2_PLIST}

launchctl list | grep paste2
