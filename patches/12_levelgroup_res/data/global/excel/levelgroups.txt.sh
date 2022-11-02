#!/bin/sh

awk -F"\t" -v OFS="\t" '
/^Act/ {
    sub(/\r$/, "")
    print $1, $2, $3, "act" substr($1, 5, 2) $4 " LG"
    next
}
{
    print $0
}
'
