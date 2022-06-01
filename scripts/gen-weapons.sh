#!/bin/sh

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
    IFNULL(speed, 0) speed,
    gemsockets socket
FROM weapons w
    JOIN str s ON w.namestr = s.Key
WHERE
    ubercode IS NOT NULL
ORDER BY s.id
    ' \
    origin/data/global/excel/weapons.txt \
    "$tmpdir/str.tsv"
