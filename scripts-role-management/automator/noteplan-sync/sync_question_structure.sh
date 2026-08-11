#!/bin/bash
# sync_question_structure.sh
#
# Creates a hierarchical symlink structure for NotePlan notes, organizing
# question-based notes into a folder hierarchy without duplicating content.
# The symlinks point to actual NotePlan notes in iCloud.
#
# Prerequisite: A symlink named "noteplan_notes" must exist in the script
# directory pointing to your NotePlan notes folder in iCloud.
#
# Output:
#   - Creates symlink directory structure
#   - Lists unmanaged files (notes not yet in structure)
#
# Usage: ./sync_question_structure.sh
# Requires: noteplan_notes symlink to iCloud NotePlan folder

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# - [x] Figure out best way to check in sym links: https://stackoverflow.com/questions/15465436/git-how-to-handle-symlinks @done(2018-01-04 12:28)
# - [x] Make sure an internal sym link is being used ... and that it is not checked in ... @done(2018-01-04 12:28)
# - [x] Make sure that the existence of this file is checked  @done(2018-01-04 12:30)
# - [ ] Figure out what files are not being tracked in noteplan ...

function _depth_of_folder() {
	if [ "${1}" = "." ];
	then
		echo ${2}
	else 
		# _depth_of_folder "$(dirname "$1")" "$(expr ${2} + 1)"
		_depth_of_folder "$(dirname "$1")" "${2}/.."
	fi
}

function depth_of_folder() {
	_depth_of_folder "${1}" "."
}

function create_symlink_in_DIR_for_FILE_in_noteplan() (
	cd ${DIR}
	DIR_TO_CREATE="${DIR}/${1}/"
	REVERSE_FOLDER_PLACE=$(depth_of_folder "${1}")
	mkdir -p "${DIR_TO_CREATE}"
	test -L "${1}/${2}" || ln -s "${REVERSE_FOLDER_PLACE}/noteplan_notes/${2}" "${DIR_TO_CREATE}/${2}"
)

# With this approach ... the content of the notes is never checked in ... just the sym links ...
# This give noteplan a structure, but it does not version controll the content ...
# This may be good enough ... as I might not care about the history of the content ...
# But I will not be able to compute when a new line was introduced ...

function create_symlink_structure() {
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I expand my education?" "How will I plan my education?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I expand my education?" "What books should I be reading?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I find my purpose?" "What do I know about my purpose?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I find my purpose?" "What questions am I answering?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I find my purpose?" "What questions am I intrigued in answering?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I manage my projects?" "How will I develop my first personal product?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I manage my projects?" "Who are my projects focused on?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I please my wife?" "What should I get Sara for her 23rd birthday?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I please my wife?" "What things can Sara and I do together?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I refine my habits?" "How will I plan my habits?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I refine my habits?" "What are my weekly goals?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I refine my habits?" "What is my daily planning ritual?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I refine my habits?" "What is my weekly planning ritual?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I track myself?" "How will I track myself?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/How will I track myself?" "What personal metrics accuratly represent my productivity?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/What do I need to do eventually?" "What comes next after Saras Immigration here?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?/What do I need to do eventually?" "What do I need to do eventually?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?" "How will I improve myself?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?" "How will I manage my actions?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my actions?" "How will I plan myself?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my expenses?" "How will I plan my cash flow?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my expenses?" "Should I buy coffee cups?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my expenses?" "What are my expenses?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my expenses?" "What are my recurring expenses?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my expenses?" "What car should we buy?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my expenses?" "What furniture should we buy?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my expenses?" "What should I constantly check craigslist for?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my tool box?/What are my planning tools?" "What questions should a plan address?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my tool box?" "How will I replace dropbox?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my tool box?" "How will I use AWS?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my tool box?" "How will I use my flic buttons?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my tool box?" "How will I use my phone?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my tool box?" "How will I use NotePlan?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I manage my tool box?" "What tools do I need?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I organize my notes?" "What thoughts am I having on a continual basis?"
	create_symlink_in_DIR_for_FILE_in_noteplan \
		"How will I organize my notes?" "What tips am I tracking on a continual basis?"
}

function list_unmannaged_files(){
	diff <(find ${DIR} -type l -exec basename {} \; | sort) <(ls ${DIR}/noteplan_notes | sort) | grep -v "^---" | egrep -v "^<.*" | grep -v "^[0-9c0-9]"
}

test -L ${DIR}/noteplan_notes || (echo "Sym Link to NotePlan Notes in iCloud must exist @ ${DIR}/noteplan_notes" && exit 1)
create_symlink_structure

echo "Listing Unmannaged Files: " && list_unmannaged_files