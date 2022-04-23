function sync-git-repo() (
	# Assuming repo in workplace ...
	SERVER=${1}
	REPO_NAME=${2}
	DEST_DIR=${3}
	ssh ${SERVER} mkdir -p ${DEST_DIR}
	cd ${HOME}/workplace
	# todo ... auto inspect the gitignore and ignore accordingly ...
	rsync \
		--recursive \
		--update \
		--executability \
		--times \
		--compress \
		--exclude '*.DS_Store' \
		--exclude '*/node_modules/*' \
		--exclude '*/__pycache__/*' \
		--stats \
		--progress \
		--rsh=ssh \
		${REPO_NAME}/ ${SERVER}:${DEST_DIR}
		# --dry-run \
)

function sync-git-repos() {
	sync-git-repo cloud-workstation scripts /home/oeid/workplace/scripts
	sync-git-repo cloud-workstation RAMPOpsTools /home/oeid/workplace/RAMPOpsTools
	sync-git-repo cloud-workstation RMBOpsTools /home/oeid/workplace/RMBOpsTools
}

function sync-git-repos-personal() {
	sync-git-repo personal-laptop scripts /Users/omareid/workplace/git/work-scripts
}
