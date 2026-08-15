#!/bin/bash
# generate-learning-objectives.sh
#
# Scans the roles/ directory for files matching "Learn(ing) about *.md" patterns,
# extracts the learning objectives, and generates a PlantUML mindmap diagram
# with clickable iA Writer links.
#
# Output:
#   - LearningObjectives.iuml (mindmap content)
#   - LearningObjectives.puml.svg (rendered diagram)
#   - debug-links.txt (intermediate link list for debugging)
#
# Usage: ./generate-learning-objectives.sh
# Requires: puml-to-svg, html-encode

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Limit nesting ... to roles|vocation roles/<role>/Learn about ...
		# if its a dir ... then link to the overview ...
		# Otherwise, link to the file ..

function extract_learning_link() {
    FILE="${1}"
    TITLE=$(echo "${FILE}" | sed -E 's_.*[/]Learn(ing)? about __' | sed -E 's/(.md)|(.txt)//')
    HTML_FILE=$(echo "${FILE}" | html-encode)
    LINK="ia-writer://open?path=/Locations/personalbook/${HTML_FILE}"
    echo "[[ ${LINK} {Learning about ${TITLE}} ${TITLE} ]]"
}

export -f extract_learning_link

( \
  cd "${DIR}" \
  && cd "$(git rev-parse --show-toplevel)" \
  && find -E roles -type f -regex ".*[/]Learn(ing)? about .*"  -exec bash -c 'extract_learning_link "{}"' \; \
  | tee "${DIR}/debug-links.txt" \
  | sed 's/^/** /g' \
) > "${DIR}/LearningObjectives.iuml"

puml-to-svg LearningObjectives.puml
