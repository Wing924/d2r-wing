#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql='
SELECT DISTINCT
    s.id,
    s.Key,
    l.Name,
    s.zhTW,
    MonLvlEx normal,
    `MonLvlEx(N)` nightmare,
    `MonLvlEx(H)` hell
FROM levels l
    LEFT JOIN str s ON l.LevelName = s.Key
WHERE
    `MonLvlEx(H)` != ""
ORDER BY s.id
'

patches/11_level_names/data/global/excel/levels.txt.sh < origin/data/global/excel/levels.txt > "$tmpdir/levels.txt"
build/bin/jsonpatch origin/data/local/lng/strings/levels.json patches/11_level_names/data/local/lng/strings/levels.jsonpatch.json > "$tmpdir/levels.json"
scripts/json-to-tsv.sh "$tmpdir/levels.json" > "$tmpdir/str.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    "$tmpdir/levels.txt" \
    "$tmpdir/str.tsv"
