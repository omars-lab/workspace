#!/bin/bash
# generate-managed-entities.sh
#
# Scans the roles/ directory for files matching "Managing *.md" patterns,
# extracts the entity names, and generates a PlantUML mindmap diagram.
#
# Output:
#   - ManagedEntities.iuml (mindmap content)
#   - ManagedEntities.puml.svg (rendered diagram)
#
# Usage: ./generate-managed-entities.sh
# Requires: puml-to-svg (PlantUML to SVG converter)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

( \
  cd "${DIR}" \
  && cd "$(git rev-parse --show-toplevel)/roles" \
  && find -E . -d 2 -regex '[.]/[^/]+/Mana?ging.*' \
  | sed -E 's_./[^/]+/Managing __' | sed -E 's/(.md)|(.txt)//' \
  | sed 's/^/** /g' \
) > "${DIR}/ManagedEntities.iuml"

puml-to-svg ManagedEntities.puml
