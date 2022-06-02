#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings-legacy/item-names.json > "$tmpdir/oldstr.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql '
SELECT
    s.id,
    s.Key,
    o.zhTW old_zhTW,
    s.zhTW,
    category,
    type,
    CASE
        WHEN code = normcode THEN "normal"
        WHEN code = ubercode THEN "exceptional"
        WHEN code = ultracode THEN "elite"
        ELSE ""
    END grade,
    CASE
        WHEN type = "shie" OR type = "tors" OR type = "ashd" THEN
            CASE speed
                WHEN 5 THEN "medium"
                WHEN 10 THEN "heavy"
                ELSE "light"
            END
        ELSE ""
    END weight,
    CASE
        WHEN category = "weap" THEN
            IFNULL(speed, 0)
        ELSE ""
    END speed,
    CASE
        WHEN gemsockets > 0 THEN
            gemsockets
        ELSE
            ""
    END socket,
    max,
    CAST(max * 1.5 AS INT) maxEth,
    level qlvls,
    ((level-1)/3*3 + 3) AS tc
FROM str s
    JOIN oldstr o
        ON o.id = s.id
    JOIN (
        SELECT "armo" category, namestr, code, normcode, ubercode, ultracode, type, maxac max, speed, gemsockets, level
        FROM armor
        UNION
        SELECT "weap" category, namestr, code, normcode, ubercode, ultracode, type, "" max, speed, gemsockets, level
        FROM weapons
    ) a
        ON a.namestr = s.Key
WHERE
    ubercode IS NOT NULL
ORDER BY s.id
    ' \
    origin/data/global/excel/armor.txt \
    origin/data/global/excel/weapons.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/oldstr.tsv"
