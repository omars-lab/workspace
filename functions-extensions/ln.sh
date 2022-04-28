# Creating my links ... 

## Create Noteplan link ...
### - [ ] auto make noteplan link ...

function noteplan_create_link() {
	# On work mac ... with icloud disabled ...
	ICLOUD_CALENDAR_DIR=~/Library/Mobile\ Documents/iCloud\~co\~noteplan\~NotePlan/Documents/Calendar
	LOCAL_CALENDAR_DIR=~/Library/Mobile\ Documents/iCloud\~co\~noteplan\~NotePlan/Documents/Calendar
	(test \! -L ${CALENDAR_DIR}) && test -d ${ICLOUD_CALENDAR_DIR} && ln -s ${ICLOUD_CALENDAR_DIR} ${CALENDAR_DIR}
	(test \! -L ${CALENDAR_DIR}) && test -d ${LOCAL_CALENDAR_DIR} && ln -s ${LOCAL_CALENDAR_DIR} ${CALENDAR_DIR}
}

function ln-s-dirs() {
    SOURCE_DIR="${1}"
    DEST_LINK="${2}"
    ( \
        test -d "${SOURCE_DIR}" \
        && ! (test -L "${DEST_LINK}" >/dev/null 2>/dev/null) \
    ) && (echo creating link ${DEST_LINK} from "${SOURCE_DIR}") \
      && ln -s "${SOURCE_DIR}" "${DEST_LINK}"
}

ln-s-dirs \
    "${HOME}/Library/Mobile Documents/iCloud~co~noteplan~NotePlan/Documents" \
    "${HOME}/.noteplan"

ln-s-dirs \
    "${HOME}/Library/Containers/co.noteplan.NotePlan/Data/Library/Application Support/co.noteplan.NotePlan/Notes" \
    "${HOME}/.noteplan"
