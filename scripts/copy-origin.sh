#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "usage $0 /path/to/src /path/to/dst"
    exit 1
fi

SRC="$1"
DST="$2"

if [[ $SRC != */ ]]; then
    SRC+=/
fi

if [[ $DST != */ ]]; then
    DST+=/
fi

while IFS= read -r file; do
    relativeFile="${file##$DST}"
    cp -v "$SRC$relativeFile" "$file"
done < <(find "$DST" -type f)
