# -------------- SSH ------------------------

function start_agent(){
    $SILENT || echo "Starting new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

# Determine if a new agent needs to be started
ps -aef | grep '/usr/bin/ssh-agent' | grep -v grep 1>/dev/null || start_agent


function load_work_keys() {
    # Drop all keys
    ssh-add -D
    # Load appropriate ssh keys
    $SILENT || echo $SSH_KEYS
    for key in $(echo $SSH_KEYS | tr ':' '\n'); do
        $SILENT || echo "Adding: $key"
        /usr/bin/ssh-add $key
    done
}

function load_personal_keys() {
    # Drop all keys
    ssh-add -D
    # Load appropriate ssh keys
    $SILENT || echo $PERSONAL_SSH_KEYS
    for key in $(echo $PERSONAL_SSH_KEYS | tr ':' '\n'); do
        $SILENT || echo "Adding: $key"
        /usr/bin/ssh-add $key
    done
}

# load_work_keys
