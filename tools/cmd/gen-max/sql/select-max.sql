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

CREATE TABLE equip_ac
(
    itemKey,
    minAC,
    maxAC,
    fixedDef
);

-- insert minac/maxac
INSERT INTO equip_ac(itemKey, minAC, maxAC, fixedDef)
SELECT eq.itemKey, ar.minac, ar.maxac, FALSE fixedDef
FROM equips eq
         JOIN armor ar ON eq.baseCode = ar.code
WHERE eq.baseCode != "";

-- make items with EDef
UPDATE equip_ac
SET fixedDef = TRUE
WHERE itemKey IN (SELECT DISTINCT eq.itemKey
                  FROM equips eq
                           JOIN armor ar ON eq.baseCode = ar.code
                           JOIN equip_props ep ON eq.itemKey = ep.itemKey
                  WHERE eq.baseCode != ""
                    AND (minAC = maxAC OR prop = 'ac%'));

-- select var props
SELECT n.id, n.zhTW, bn.zhTW, ep.*
FROM equips eq
         LEFT JOIN (SELECT * FROM item_names UNION SELECT * FROM item_runes) n ON eq.itemKey = n.Key
         LEFT JOIN item_names bn ON eq.baseCode = bn.Key
         JOIN equip_props ep ON eq.itemKey = ep.itemKey
WHERE minValue != maxValue
  AND prop NOT IN ('charged', 'dmg-cold', 'dmg-elem', 'dmg-fire', 'dmg-ltng', 'dmg-pois', 'dmg-mag', 'dmg-norm')
  AND NOT (prop LIKE '%-skill' AND CAST(maxValue AS INT) > 0);

CREATE TABLE gen_max
(
    id,
    zhTW
);

INSERT INTO gen_max
SELECT DISTINCT *
FROM (SELECT DISTINCT n.id, n.zhTW
      FROM equips eq
               LEFT JOIN (SELECT * FROM item_names UNION SELECT * FROM item_runes) n ON eq.itemKey = n.Key
               LEFT JOIN item_names bn ON eq.baseCode = bn.Key
               JOIN equip_props ep ON eq.itemKey = ep.itemKey
      WHERE minValue != maxValue
        AND prop NOT IN ('charged', 'dmg-cold', 'dmg-elem', 'dmg-fire', 'dmg-ltng', 'dmg-pois', 'dmg-mag', 'dmg-norm')
        AND NOT (prop LIKE '%-skill' AND CAST(maxValue AS INT) > 0)
      UNION
      SELECT n.id, n.zhTW
      FROM equip_ac eq
               JOIN item_names n ON eq.itemKey = n.Key
      WHERE fixedDef = FALSE);

SELECT n.id, n.zhTW, ep.*
FROM equips eq
         LEFT JOIN (SELECT * FROM item_names UNION SELECT * FROM item_runes) n ON eq.itemKey = n.Key
         LEFT JOIN item_names bn ON eq.baseCode = bn.Key
         JOIN equip_props ep ON eq.itemKey = ep.itemKey
WHERE
    minValue != maxValue
  AND prop NOT IN ('charged', 'dmg-cold', 'dmg-elem', 'dmg-fire', 'dmg-ltng', 'dmg-pois', 'dmg-mag', 'dmg-norm')
  AND NOT (prop LIKE '%-skill' AND CAST(maxValue AS INT) > 0);

-- SELECT n.id, n.zhTW, bn.zhTW, ar.minac, ar.maxac, eq.*
-- FROM equips eq
--          JOIN (SELECT *
--                FROM item_names
--                UNION
--                SELECT *
--                FROM item_runes) n ON eq.itemKey = n.Key
--          LEFT JOIN item_names bn ON eq.baseCode = bn.Key
--          LEFT JOIN armor ar ON eq.baseCode = ar.code
