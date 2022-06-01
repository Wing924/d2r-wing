#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

if [[ $# -ne 3 ]]; then
    echo "usage $0 /path/to/origin /path/to/patch /path/to/output"
    exit 1
fi

origin_dir="$1"
patch_dir="$2"
out_dir="$3"
