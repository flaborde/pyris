#!/bin/bash
IRIS_URL="https://www.data.gouv.fr/s/resources/contour-des-iris-insee-tout-en-un/20150428-161348/iris-2013-01-01.zip"
IRIS_FILE="${IRISURL##*/}"

set -e

wget "$IRIS_URL"
unzip "$IRIS_FILE" \
rm "$IRIS_FILE"

