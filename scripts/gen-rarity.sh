#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/str.tsv"

sql='
SELECT
    a.cat,
    ws.zhTW,
    s.zhTW,
    lvl,
    ROUND(a.rarity * 100.0 / total_rarity, 1) `rarity%`
FROM str s
    JOIN (
        SELECT "uniq" cat, `index`, code, rarity, lvl
        FROM uniqueitems
        WHERE
            lvl IS NOT NULL AND enabled = 1
        UNION
        SELECT "setitem" cat, `index`, item code, rarity, lvl
        FROM setitems
        WHERE
            lvl IS NOT NULL
    ) a
        ON a.`index` = s.Key
    JOIN (
        SELECT cat, code, SUM(rarity) total_rarity
        FROM (
            SELECT "uniq" cat, `index`, code, rarity
            FROM uniqueitems
            WHERE
                lvl IS NOT NULL AND enabled = 1
            UNION
            SELECT "setitem" cat, `index`, item code, rarity
            FROM setitems
            WHERE
                lvl IS NOT NULL
        ) r
        GROUP BY cat, code
    ) r
        ON a.code = r.code AND a.cat = r.cat
    LEFT JOIN weapons w ON a.code = w.code
    LEFT JOIN armor ar ON a.code = ar.code
    LEFT JOIN misc m ON a.code = m.code
    JOIN str ws ON ws.Key = w.namestr OR ws.Key = ar.namestr OR ws.Key = m.namestr
WHERE
    a.rarity != total_rarity
ORDER BY a.cat, a.code, `rarity%`, lvl DESC
'

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    origin/data/global/excel/armor.txt \
    origin/data/global/excel/misc.txt \
    origin/data/global/excel/uniqueitems.txt \
    origin/data/global/excel/setitems.txt \
    origin/data/global/excel/weapons.txt \
    "$tmpdir/str.tsv" \
