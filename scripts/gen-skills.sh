#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql='
SELECT
    s.id,
    s.Key,
    s.enUS,
    s.zhTW
FROM str s
WHERE
    (
        s.Key like "skillname%"
        OR
        s.Key like "skillsname%"
    )
    AND s.Key NOT IN (
        "skillname0",
        "skillname1",
        "skillname2",
        "skillname3",
        "skillname4",
        "skillname5",
        "skillname217",
        "skillname218",
        "skillname219",
        "skillname220"
    )
ORDER BY s.id
'

scripts/json-to-tsv.sh origin/data/local/lng/strings/skills.json > "$tmpdir/str.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    origin/data/global/excel/skills.txt \
    origin/data/global/excel/skilldesc.txt \
    "$tmpdir/str.tsv"
