#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap "rm -rf $tmpdir" EXIT

scripts/json-to-tsv.sh origin/data/local/lng/strings/levels.json > "$tmpdir/str.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql '
SELECT s.id, zhTW, MonLvl normal, `MonLvlEx(N)` nightmare, `MonLvlEx(H)` hell
FROM levels l
    JOIN str s ON l.`*StringName` = s.Key
WHERE
    `MonLvlEx(H)` != ""
ORDER BY s.id
    ' \
    origin/data/global/excel/levels.txt \
    "$tmpdir/str.tsv"
