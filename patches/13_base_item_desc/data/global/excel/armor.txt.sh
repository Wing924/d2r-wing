#!/bin/sh

awk -F"\t" -v OFS="\t" '
$1 == "name" {
    print substr($0, 0, length($0)-1), "spelldesc", "spelldescstr", "spelldescstr2"
    next
}
$1 == "Expansion" {
    print substr($0, 0, length($0)-1), "", "", ""
    next
}
{
    print substr($0, 0, length($0)-1), 1, "base_info_" $19, ""
    next
}
'
