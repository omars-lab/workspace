#!/bin/bash

# Useful since google docs  doesnt take svgs
# https://superuser.com/questions/134679/command-line-application-for-converting-svg-to-png-on-mac-os-x

SVG="${1}"
OUTPUT_FILE=${PWD}/$(basename "${SVG}").png
qlmanage -t -s 1000 -o . "${SVG}"
mv "${OUTPUT_FILE}" "${2}"

