# Important to note the following env vars set by brew when it runs a sytem command ...

# USER=<user>
# HOME=/private/tmp/sharedspace-20220423-4388-141g4qs/.brew_home
# CURL_HOME=/Users/<user>
# HOMEBREW_CC_LOG_PATH=/Users/<user>/Library/Logs/Homebrew/sharedspace/01.bash
# HOMEBREW_LOGS=/Users/<user>/Library/Logs/Homebrew
# HOMEBREW_CACHE=/Users/<user>/Library/Caches/Homebrew
# HOMEBREW_DEFAULT_LOGS=/Users/<user>/Library/Logs/Homebrew

INSTALL_PREFIX="${1}"
INSTALL_LOGS=${INSTALL_PREFIX}/install.logs

date >> ${INSTALL_LOGS}
whoami >> ${INSTALL_LOGS}
pwd >> ${INSTALL_LOGS}
env >> ${INSTALL_LOGS}
