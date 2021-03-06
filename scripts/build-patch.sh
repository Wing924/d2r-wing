#!/bin/bash

set -eu

std_json=build/bin/std-json

cd "$(git rev-parse --show-toplevel)"

if [[ $# -ne 3 ]]; then
    echo "usage $0 /path/to/origin /path/to/patch /path/to/output"
    exit 1
fi

DIFF=diff
if command -v colordiff &>/dev/null; then
echo 'found colordiff'
  DIFF=colordiff
fi

if [[ ! -f $std_json ]]; then
  make $std_json
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

origin_dir="$1"
patch_dir="$2"
out_dir="$3"

apply_exec() {
  local origin patch dst
  origin="$1"
  patch="$2"
  dst="$3"
  dst_new="$dst.new"

  "$patch" < "$origin" > "$dst_new"
  mv "$dst_new" "$dst"
}

apply_spruce() {
  local origin patch dst
  origin="$1"
  patch="$2"
  dst="$3"
  dst_new="$dst.new"

  std_origin="$tmpdir/origin.json"
  $std_json < "$origin" > "$std_origin"
  spruce merge "$std_origin" "$patch" | spruce json | jq > "$dst_new"
  mv "$dst_new" "$dst"
}

apply_copy() {
  local src dst
  src="$1"
  dst="$2"
  dst_new="$dst.new"

  cp "$src" "$dst_new"
  mv "$dst_new" "$dst"
}

while IFS= read -r -d '' patch_file; do
  filepath="${patch_file#$patch_dir/}"
  filepath="${filepath%.sh}"
  if [[ "$filepath" == *.spruce.json ]]; then
    filepath="${filepath%.spruce.json}.json"
  fi
  origin_file="$origin_dir/$filepath"
  dst_file="$out_dir/$filepath"
  if [[ -f "$dst_file" ]]; then
    origin_file="$dst_file"
  fi
  mkdir -p "$(dirname "$dst_file")"

  echo ">>> $origin_file + $patch_file -> $dst_file"
  case "$patch_file" in
  *.sh)
    apply_exec "$origin_file" "$patch_file" "$dst_file"
    ;;
  *.spruce.json)
    apply_spruce "$origin_file" "$patch_file" "$dst_file"
    ;;
  *)
    apply_copy "$patch_file" "$dst_file"
  esac

  case "$patch_file" in
  *.spruce.json)
    std_origin="$tmpdir/origin.json"
    $std_json < "$origin_file" > "$std_origin"
    spruce diff "$std_origin" "$dst_file" || :
    ;;
  *.json|*.txt|*.sh)
    $DIFF --strip-trailing-cr -u "$origin_file" "$dst_file" || :
  esac
done < <(find "$patch_dir/data" -type f -print0)
