#!/bin/sh

awk -F"\t" -v OFS="\t" '
/^Act/ {
    print $1, $2, $3, "act" substr($1, 5, 2) sub(/\r$/, "", $4) " LG"
    next
}
{
    print $0
}
'
