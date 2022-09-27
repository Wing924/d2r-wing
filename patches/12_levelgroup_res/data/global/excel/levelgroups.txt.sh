#!/bin/sh

awk -F"\t" '
/^Act/ {
    OFS="\t"
    print $1, $2, $3, "act" substr($1, 5, 2) $4 " LG"
    next
}
{
    print $0
}
'
