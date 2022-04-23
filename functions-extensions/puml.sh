#!/bin/bash

function puml-diagrams() {
	cd "${SCRIPT_DIR}/../tools/mindmap" && npm run-script encode
}

