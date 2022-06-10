#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql="$(cat tools/cmd/gen-max/select-max.sql)"

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/item_names.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/item-runes.json > "$tmpdir/item_runes.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    origin/data/global/excel/armor.txt \
	origin/data/global/excel/uniqueitems.txt \
	origin/data/global/excel/setitems.txt \
	origin/data/global/excel/runes.txt \
	origin/data/global/excel/properties.txt \
    "$tmpdir/item_names.tsv" \
    "$tmpdir/item_runes.tsv"
