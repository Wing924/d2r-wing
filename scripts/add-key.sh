#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

tsvfile="$1"

cat "$tsvfile" > "$tmpdir/tsv.txt"
scripts/json-to-tsv.sh "origin/data/local/lng/strings/levels.json" > "$tmpdir/levels.tsv"
scripts/json-to-tsv.sh "origin/data/local/lng/strings/item-nameaffixes.json" > "$tmpdir/nameaffixes.tsv"
scripts/json-to-tsv.sh "origin/data/local/lng/strings/ui.json" > "$tmpdir/ui.tsv"
scripts/json-to-tsv.sh "origin/data/local/lng/strings/monsters.json" > "$tmpdir/monsters.tsv"

sql='SELECT
    t.id,s.Key,	t.zhTW,	prefix,	newName,	suffix
FROM tsv t
    LEFT JOIN (
        SELECT * FROM levels
        UNION
        SELECT * FROM nameaffixes
        UNION
        SELECT * FROM ui
        UNION
        SELECT * FROM monsters
    ) s ON t.id = s.id
'

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    "$tmpdir/tsv.txt" \
    "$tmpdir/levels.tsv" \
    "$tmpdir/nameaffixes.tsv" \
    "$tmpdir/ui.tsv" \
    "$tmpdir/monsters.tsv"
