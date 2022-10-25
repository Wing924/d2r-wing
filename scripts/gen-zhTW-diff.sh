#!/bin/bash

set -eux

if [[ $# -ne 2 ]]; then
    echo "usage: $0 strings-legacy/XXX.json strings/XXX.json"
    exit 1
fi

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap "rm -rf $tmpdir" EXIT

scripts/json-to-tsv.sh "$1" > "$tmpdir/old.tsv"
scripts/json-to-tsv.sh "$2" > "$tmpdir/new.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql '
SELECT
    n.id,
    n.Key,
    o.zhTW old,
    n.zhTW new
FROM old o
    JOIN new n ON o.id = n.id
WHERE
    o.zhTW != n.zhTW
ORDER BY n.id
    ' \
    "$tmpdir/old.tsv" \
    "$tmpdir/new.tsv"
