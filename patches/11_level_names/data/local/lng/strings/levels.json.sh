#!/bin/bash

set -eu

NEW_KEYS=(
  2 "Sewers Level 1"
  3 "Sewers Level 1"
  2 "Sewers Level 2"
  3 "Sewers Level 2"
  1 "Tristram"
  5 "Tristram"
)

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

levels_json="$tmpdir/levels.json"
new_keys_json="$tmpdir/new_keys.json"

cat > "$levels_json"

for i in $(seq 0 2 ${#NEW_KEYS[*]}); do
  act="${NEW_KEYS[$i]}"
  key="${NEW_KEYS[$(($i + 1))]}"
  cat "$levels_json" | jq ".[] | select(.Key == \"$key\") | (.Key |= \"act$act \" + .) | (.id |= 1${act}0000 + .)"
done | jq -s > "$new_keys_json"

cat "$levels_json" "$new_keys_json" | jq '.[]' | jq -s
