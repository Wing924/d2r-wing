-- SELECT i.id       AS          id,
--        category,
--        idx,
--        mx.itemKey AS          Key,
--        i.zhTW                 itemName,
--        IFNULL(bn.zhTW, "")    baseName,
--        IFNULL(a.minac, 0)     minAC,
--        IFNULL(a.maxac, 0)     maxAC,
--        IFNULL(`*Tooltip`, "") propName,
--        prop,
--        param,
--        minValue,
--        maxValue
-- FROM equip mx
--          LEFT JOIN (SELECT id, Key, zhTW FROM item_names UNION SELECT id, Key, zhTW FROM item_runes) i ON mx.itemKey = i.Key
--          LEFT JOIN properties p ON mx.prop = p.code
--          LEFT JOIN armor a ON mx.baseCode = a.code AND a.code != ""
--          LEFT JOIN item_names bn ON a.code = bn.Key
-- WHERE
-- prop NOT IN ( "charged",  "dmg-cold", "dmg-elem", "dmg-fire", "dmg-ltng", "dmg-pois", "dmg-mag", "dmg-norm" )
-- AND
-- NOT (prop IN ("att-skill", "death-skill", "gethit-skill", "hit-skill", "kill-skill", "levelup-skill") AND CAST(maxValue AS INT) > 0)
-- ORDER BY id, idx

SELECT
FROM equips eq
    LEFT JOIN item_names bn ON eq.baseCode = bn.Key
