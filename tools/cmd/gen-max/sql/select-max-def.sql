CREATE TABLE max_ac
(
    id,
    itemKey,
    zhTW,
    maxDEF
);

INSERT INTO max_ac
SELECT id, Key, zhTW, maxDEF
FROM (SELECT e.itemKey,
--        CASE
--            WHEN acp.prop != "" THEN
--                ar.maxac + 1
--            ELSE
--                ar.maxac
--            END                maxBaseAC,
--        acp.minValue           minED,
--        acp.maxValue           maxED,
--        ac.minValue            minDEF,
--        ac.maxValue            maxDEF,
             IIF(acp.prop IS NOT NULL, (ar.maxac + 1) * (100 + IFNULL(acp.maxValue, 0)) / 100, ar.minac) +
             IFNULL(ac.minValue, 0) minDEF,
             IIF(acp.prop IS NOT NULL, (ar.maxac + 1) * (100 + IFNULL(acp.maxValue, 0)) / 100, ar.maxac) +
             IFNULL(ac.maxValue, 0) maxDEF
      FROM equips e
               JOIN armor ar ON e.baseCode = ar.code
               LEFT JOIN equip_props ac ON e.itemKey = ac.itemKey AND ac.prop = 'ac'
               LEFT JOIN equip_props acp ON e.itemKey = acp.itemKey AND acp.prop = 'ac%'
      WHERE e.baseCode != "") t
         JOIN item_names i ON t.itemKey = i.Key
WHERE t.minDEF != t.maxDEF;

SELECT m.id, m.zhTW, max, ma.maxDEF
FROM item_max m
         LEFT JOIN max_ac ma ON CAST(m.id AS INT) = ma.id
WHERE m.max LIKE '%防禦%';

SELECT m.id, m.zhTW, max, ma.maxDEF
FROM max_ac ma
         LEFT JOIN item_max m ON CAST(m.id AS INT) = ma.id
WHERE m.max LIKE '%防禦%';