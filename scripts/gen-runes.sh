#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql='
SELECT
    CASE
      WHEN s.Key GLOB "r??" THEN
        "item name"
      ELSE
        "in socket"
    END category,
    s.Key,
    s.id,
    o.zhTW old_zhTW,
    s.zhTW,
    RTRIM(s.enUS, " Rune") enName,
    CAST(SUBSTR(s.Key, 2, 2) AS INT) num,
    SUBSTR(c.`input 1`,-1,1) recipeQty,
    i.zhTW recipeGem
FROM str s
    JOIN oldstr o
      ON o.id = s.id
    LEFT JOIN cubemain c
      ON s.Key = SUBSTR(c.`input 1`, 1,3)
    LEFT JOIN (
      SELECT id, Key, zhTW FROM names
      UNION
      SELECT id, Key, zhTW FROM nameaffixes
    ) i
      ON c.`input 2` = i.Key
WHERE
    s.Key GLOB "r[0-9][0-9]*"
ORDER BY category, s.Key
'

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-runes.json > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings-legacy/item-runes.json > "$tmpdir/oldstr.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/names.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/item-nameaffixes.json > "$tmpdir/nameaffixes.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    origin/data/global/excel/cubemain.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/oldstr.tsv" \
    "$tmpdir/names.tsv" \
    "$tmpdir/nameaffixes.tsv"
