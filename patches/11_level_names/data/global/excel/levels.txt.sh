#!/bin/sh

awk -F"\t" '
function replace_field(idx, str,  i) {
    for (i = 1; i < idx; i++) {
        printf("%s\t", $i);
    }
    printf(str);
    for (i = idx+1; i < NF; i++) {
        printf("\t%s", $i);
    }
    printf("\n");
}
{
    switch ($1) {
    case "Act 2 - Sewer 1 A":
        replace_field(167, "act2 Sewers Level 1");
        break;
    case "Act 2 - Sewer 1 B":
        replace_field(167, "act2 Sewers Level 2");
        break;
    case "Act 3 - Sewer 1":
        replace_field(167, "act3 Sewers Level 1");
        break;
    case "Act 3 - Sewer 2":
        replace_field(167, "act3 Sewers Level 2");
        break;

    case "Act 1 - Tristram":
        replace_field(167, "act1 Tristram");
        break;
    case "Act 5 - Pandemonium Finale":
        replace_field(167, "act5 Tristram");
        break;

    default:
        print $0
    }
}
'
