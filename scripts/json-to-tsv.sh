#!/bin/bash

# convert JSON string file to TSV

if [[ $# -ne 1 ]]; then
    echo "usage: $0 /path/to/json"
    exit 1
fi

echo "id	Key	enUS	zhTW	deDE	esES	frFR	itIT	koKR	plPL	esMX	jaJP	ptBR	ruRU	zhCN"
jq -r '.[] | [.id, .Key, .enUS, .zhTW, .deDE, .esES, .frFR, .itIT, .koKR, .plPL, .esMX, .jaJP, .ptBR, .ruRU, .zhCN] | @csv' "$1" | sed 's/,/\t/g'
