# iCloud Specific Settings
# The location of icloud files on my local machine
  export ICLOUD_ROOT=$(echo ${HOME}'/Library/Mobile Documents')

# The email that is associated with my icloud ...

# - [-] Ensure this email file is created if it doesnt exist ...
#   export ICLOUD_EMAIL=${ICLOUD_EMAIL:-$(cat "${ICLOUD_ROOT}/email.txt")}
  # echo Using iCloud Email: ${ICLOUD_EMAIL:?ICLOUD EMAIL Required} 1>&2

# The location of the directory I will backup icloud too ...
  export ICLOUD_BACKUP_DIR="${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_EMAIL}"

# Personal iCloud Email
  export ICLOUD_PERSONAL_EMAIL=omar_eid21@yahoo.com

# Work iCloud Email
  export ICLOUD_WORK_EMAIL=redacted