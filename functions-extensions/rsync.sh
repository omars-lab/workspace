function rsync-git-repo() (
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

# Example ...
# function rsync-git-repos-personal() {
# 	rsync-git-repo personal-laptop scripts /Users/omareid/workplace/git/work-scripts
# }
