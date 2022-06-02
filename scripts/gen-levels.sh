#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

scripts/json-to-tsv.sh origin/data/local/lng/strings/levels.json > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings-legacy/levels.json > "$tmpdir/oldstr.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql '
SELECT DISTINCT
    s.id,
    s.Key,
    o.zhTW old_zhTW,
    s.zhTW,
    MonLvlEx normal,
    `MonLvlEx(N)` nightmare,
    `MonLvlEx(H)` hell
FROM levels l
    JOIN str s ON l.`*StringName` = s.Key
    JOIN oldstr o ON o.id = s.id
WHERE
    `MonLvlEx(H)` != ""
ORDER BY s.id
    ' \
    origin/data/global/excel/levels.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/oldstr.tsv"
