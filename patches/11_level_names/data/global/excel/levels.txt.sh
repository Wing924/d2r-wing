#!/bin/sh

awk -F"\t" '
function add_prefix(idx, prefix,  i) {
    for (i = 1; i < idx; i++) {
        printf("%s\t", $i);
    }
    printf("%s%s", prefix, $idx);
    for (i = idx+1; i <= NF; i++) {
        printf("\t%s", $i);
    }
    printf("\n");
}

/^Act 2 - Sewer 1 [AB]/ {
    add_prefix(167, "act2 ")
    next
}

/^Act 3 - Sewer [12]/ {
    add_prefix(167, "act3 ")
    next
}

/^Act 1 - Tristram/ {
    add_prefix(167, "act1 ")
    next
}

/^Act 5 - Pandemonium Finale/ {
    add_prefix(167, "act5 ")
    next
}

{
    print $0
}
'
