#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql='
SELECT
    s.id,
    s.Key,
    s.zhTW
FROM sets r
    JOIN str s
      ON s.Key = r.name
ORDER BY s.id
'

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/str.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    origin/data/global/excel/sets.txt \
    "$tmpdir/str.tsv"
