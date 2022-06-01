#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap "rm -rf $tmpdir" EXIT

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/str.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql '
SELECT
    s.id,
    zhTW,
    CASE
        WHEN code = normcode THEN "普"
        WHEN code = ubercode THEN "擴"
        ELSE "精"
    END grade,
    CASE
        WHEN type = "shie" OR type = "tors" OR type = "ashd" THEN
            CASE speed
                WHEN 5 THEN "中"
                WHEN 10 THEN "重"
                ELSE "輕"
            END
        ELSE ""
    END weight,
    gemsockets socket
FROM armor a
    JOIN str s ON a.namestr = s.Key
ORDER BY s.id
    ' \
    origin/data/global/excel/armor.txt \
    "$tmpdir/str.tsv"
