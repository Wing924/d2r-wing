#!/bin/bash

set -eu

COMMON_DIR=build/common

cd "$(git rev-parse --show-toplevel)"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <origin-file>"
  exit 1
fi

origin_file="$1"

file_in_mod="${origin_file#origin/}"

if [[ -f "$COMMON_DIR/$file_in_mod" ]]; then
  cat "$COMMON_DIR/$file_in_mod"
else
  cat "$origin_file"
fi
