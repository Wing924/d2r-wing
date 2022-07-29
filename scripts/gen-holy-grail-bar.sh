#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

scripts/json-to-tsv.sh origin/data/local/lng/strings/item-names.json > "$tmpdir/item_names.tsv"

sql='
SELECT
    name.id ID,
    equip.cat "分类",
    name.zhTW "物品名称",
    base.zhTW "底材名称",
    name.enUS "物品名称（英文）",
    base.enUS "底材名称(英文)",
    CASE
        WHEN base_info.code = normcode THEN "普通"
        WHEN base_info.code = ubercode THEN "扩展"
        WHEN base_info.code = ultracode THEN "精英"
        ELSE ""
    END 底材级别,
    equip.lvl "物品等级",
    base_info.level "底材等级",
    ROUND(equip.rarity * 1.0 / total_rarity, 5) `稀有度%`,
    "" "已获得",
    "" "备注"
FROM
    (
        SELECT "暗金" cat, `index`, code, rarity, lvl
        FROM uniqueitems
        WHERE
            lvl IS NOT NULL AND enabled = 1
        UNION
        SELECT "套装" cat, `index`, item code, rarity, lvl
        FROM setitems
        WHERE
            lvl IS NOT NULL
    ) equip
    JOIN item_names name ON equip.`index` = name.Key
    JOIN item_names base ON equip.code = base.Key
    LEFT JOIN (
        SELECT code, level, normcode, ubercode, ultracode
        FROM weapons
        UNION
        SELECT code, level, normcode, ubercode, ultracode
        FROM armor
        UNION
        SELECT code, level, "" normcode, "" ubercode, "" ultracode
        FROM misc
    ) base_info ON equip.code = base_info.code
    JOIN (
        SELECT cat, code, SUM(rarity) total_rarity
        FROM (
            SELECT "暗金" cat, `index`, code, rarity
            FROM uniqueitems
            WHERE
                lvl IS NOT NULL AND enabled = 1
            UNION
            SELECT "套装" cat, `index`, item code, rarity
            FROM setitems
            WHERE
                lvl IS NOT NULL
        ) r
        GROUP BY cat, code
    ) r
        ON equip.code = r.code AND equip.cat = r.cat
WHERE
    equip.lvl > 0
ORDER BY "底材等级" DESC, "物品等级" DESC, name.zhTW
'

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    origin/data/global/excel/armor.txt \
    origin/data/global/excel/misc.txt \
    origin/data/global/excel/uniqueitems.txt \
    origin/data/global/excel/setitems.txt \
    origin/data/global/excel/weapons.txt \
    "$tmpdir/item_names.tsv" \
    resources/generated/zhTW-diff/item-names.tsv
