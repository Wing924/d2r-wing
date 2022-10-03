#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/str.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql '
SELECT
    s.id,
    s.Key,
    s.zhTW,
    `set`,
    rarity,
    lvl qlvl
FROM str s
    JOIN (
        SELECT "" `set`, `index`, rarity, lvl
        FROM uniqueitems
        WHERE
            lvl IS NOT NULL
            AND (enabled = 1 OR ladder = 1)
        UNION
        SELECT `set`, `index`, rarity, lvl
        FROM setitems
        WHERE
            lvl IS NOT NULL
    ) a
        ON a.`index` = s.Key
WHERE
    lvl > 0
ORDER BY s.id
    ' \
    origin/data/global/excel/uniqueitems.txt \
    origin/data/global/excel/setitems.txt \
    "$tmpdir/str.tsv" \
