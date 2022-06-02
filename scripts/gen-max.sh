#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

sql='
SELECT * FROM(
SELECT n.id id, n.zhTW zhTW, u.prop prop, u.par par, u.min min, u.max max
FROM names n
    JOIN (
      SELECT `index`, code, lvl qLvls, prop1 prop, par1 par, min1 min, max1 max FROM uniqueitems WHERE prop1 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop2 prop, par2 par, min2 min, max2 max FROM uniqueitems WHERE prop2 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop3 prop, par3 par, min3 min, max3 max FROM uniqueitems WHERE prop3 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop4 prop, par4 par, min4 min, max4 max FROM uniqueitems WHERE prop4 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop5 prop, par5 par, min5 min, max5 max FROM uniqueitems WHERE prop5 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop6 prop, par6 par, min6 min, max6 max FROM uniqueitems WHERE prop6 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop7 prop, par7 par, min7 min, max7 max FROM uniqueitems WHERE prop7 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop8 prop, par8 par, min8 min, max8 max FROM uniqueitems WHERE prop8 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop9 prop, par9 par, min9 min, max9 max FROM uniqueitems WHERE prop9 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop10 prop, par10 par, min10 min, max10 max FROM uniqueitems WHERE prop10 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop11 prop, par11 par, min11 min, max11 max FROM uniqueitems WHERE prop11 IS NOT NULL
      UNION
      SELECT `index`, code, lvl qLvls, prop12 prop, par12 par, min12 min, max12 max FROM uniqueitems WHERE prop12 IS NOT NULL
    ) u
        ON u.`index` = n.Key
WHERE
  min != max

UNION

SELECT n.id id, n.zhTW zhTW, u.prop prop, u.par par, u.min min, u.max max
FROM item_runes n
    JOIN (
      SELECT Name, T1Code1 prop, T1param1 par, T1min1 min, T1max1 max FROM runes WHERE T1Code1 IS NOT NULL
      UNION
      SELECT Name, T1Code2 prop, T1param2 par, T1min2 min, T1max2 max FROM runes WHERE T1Code2 IS NOT NULL
      UNION
      SELECT Name, T1Code3 prop, T1param3 par, T1min3 min, T1max3 max FROM runes WHERE T1Code3 IS NOT NULL
      UNION
      SELECT Name, T1Code4 prop, T1param4 par, T1min4 min, T1max4 max FROM runes WHERE T1Code4 IS NOT NULL
      UNION
      SELECT Name, T1Code5 prop, T1param5 par, T1min5 min, T1max5 max FROM runes WHERE T1Code5 IS NOT NULL
      UNION
      SELECT Name, T1Code6 prop, T1param6 par, T1min6 min, T1max6 max FROM runes WHERE T1Code6 IS NOT NULL
      UNION
      SELECT Name, T1Code7 prop, T1param7 par, T1min7 min, T1max7 max FROM runes WHERE T1Code7 IS NOT NULL
    ) u
        ON u.Name = n.Key
WHERE
    min != max

ORDER BY id)
WHERE
  prop NOT IN (
    "hit-skill",
    "kill-skill",
    "levelup-skill",
    "gethit-skill",
    "death-skill",
    "charged"
  )
'

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/names.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/item-runes.json > "$tmpdir/item_runes.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header -sql "$sql" \
    origin/data/global/excel/uniqueitems.txt \
    origin/data/global/excel/runes.txt \
    "$tmpdir/names.tsv" \
    "$tmpdir/item_runes.tsv"
