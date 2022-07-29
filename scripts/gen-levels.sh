#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql='
SELECT DISTINCT
    s.id,
    s.Key,
    o.zhTW old_zhTW,
    s.zhTW,
    MonLvlEx normal,
    `MonLvlEx(N)` nightmare,
    `MonLvlEx(H)` hell
FROM levels l
    JOIN str s ON l.`*StringName` = s.Key OR l.`*StringName` = s.enUS
    JOIN oldstr o ON o.id = s.id
WHERE
    `MonLvlEx(H)` != ""
    AND l.`*StringName` != "Sewers Level 1"
    AND l.`*StringName` != "Sewers Level 2"
    AND l.`*StringName` != "Tristram"
ORDER BY s.id
'

scripts/json-to-tsv.sh origin/data/local/lng/strings/levels.json > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings-legacy/levels.json > "$tmpdir/oldstr.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    origin/data/global/excel/levels.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/oldstr.tsv"
