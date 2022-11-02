#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql='
SELECT * FROM (
    SELECT
        n.id,
        n.Key,
        n.ZhTW,
        a.category,
        a.type,
        MIN(gemsockets, invwidth*invheight) socket
    FROM names n
        JOIN (
            SELECT "armo" category, namestr, code, normcode, ubercode, ultracode, type, maxac max, speed, gemsockets, invwidth, invheight, level
            FROM armor
            UNION
            SELECT "weap" category, namestr, code, normcode, ubercode, ultracode, type, "" max, speed, gemsockets, invwidth, invheight, level
            FROM weapons
        ) a
            ON a.namestr = n.Key
    WHERE
        gemsockets > 0
    )
WHERE
     (type = "h2h2" AND socket = 3) -- asn 爪
  OR (type = "scep" AND socket = 5) -- pal 权杖
  OR (type = "wand" AND socket = 2) -- nec 魔杖
  OR (type = "staf" AND socket >= 4) -- sor 法杖
  OR type IN (
    "phlm", -- bar 头 (3s)
    "pelt", -- dru 头 (3s)
    "orb", -- sor 法球 (电棒)
    "head" -- nec 头颅 (2s)
  )
ORDER BY category, type, id
'

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/names.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    origin/data/global/excel/armor.txt \
    origin/data/global/excel/weapons.txt \
    "$tmpdir/names.tsv"
