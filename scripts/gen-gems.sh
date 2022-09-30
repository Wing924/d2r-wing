#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sub='
SELECT id, Key, zhTW
FROM names
UNION
SELECT id, Key, zhTW
FROM nameaffixes'

sql="
SELECT
    s.id,
    s.Key,
    s.zhTW,
    CASE
      WHEN g.name LIKE 'Perfect %' THEN 5
      WHEN g.name LIKE 'Flawless %' THEN 4
      WHEN g.name LIKE 'Flawed %' THEN 2
      WHEN g.name LIKE 'Chipped %' THEN 1
      ELSE 3
    END rank,
    SUBSTR(c.\`input 1\`,9, 1) qty,
    SUBSTR(c.\`input 1\`,2, 2) inRune,
    SUBSTR(c.output, 2, 2) outRune
FROM ($sub) s
    JOIN gems g
      ON g.code = s.Key
    LEFT JOIN cubemain c
      ON s.Key = c.\`input 2\` AND c.output LIKE 'r__'
WHERE
  g.letter IS NULL
ORDER BY s.id
"

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/names.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/item-nameaffixes.json > "$tmpdir/nameaffixes.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    origin/data/global/excel/gems.txt \
    origin/data/global/excel/cubemain.txt \
    "$tmpdir/names.tsv" \
    "$tmpdir/nameaffixes.tsv"
