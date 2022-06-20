#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

if [[ $# -ne 3 ]]; then
    echo "usage $0 /path/to/config.yml /path/to/origin /path/to/output"
    exit 1
fi

config_file="$1"
origin_dir="$2"
out_dir="$3"

for patch_dir in $(spruce json "$config_file" | jq -rc '.patches[]'); do
  scripts/build-patch.sh "$origin_dir" "$patch_dir" "$out_dir" || exit 1
done
