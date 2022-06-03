SELECT
    mx.id               id,
    propIdx,
    mx.Key              Key,
    mx.zhTW             itemName,
    IFNULL(bn.zhTW, "") baseName,
    IFNULL(a.minac, 0)  minDef,
    IFNULL(a.maxac, 0)  maxDef,
    `*Tooltip`          propName,
    prop,
    par,
    CASE `min` WHEN "" THEN 0 ELSE `min` END `min`,
    CASE `max` WHEN "" THEN 0 ELSE `max` END `max`
FROM (
        -- uniq items
        SELECT n.id id,propIdx, n.Key, n.zhTW zhTW, code base, u.prop prop, u.par par, u.min `min`, u.max `max`
        FROM item_names n
            JOIN (
                SELECT DISTINCT 0 propIdx, `index`, code, lvl qLvls, "" prop, "" par, 0 `min`, 0 `max` FROM uniqueitems
                UNION
                SELECT 1 propIdx, `index`, code, lvl qLvls, prop1 prop, par1 par, min1 `min`, max1 `max` FROM uniqueitems WHERE prop1 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 2 propIdx, `index`, code, lvl qLvls, prop2 prop, par2 par, min2 `min`, max2 `max` FROM uniqueitems WHERE prop2 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 3 propIdx, `index`, code, lvl qLvls, prop3 prop, par3 par, min3 `min`, max3 `max` FROM uniqueitems WHERE prop3 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 4 propIdx, `index`, code, lvl qLvls, prop4 prop, par4 par, min4 `min`, max4 `max` FROM uniqueitems WHERE prop4 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 5 propIdx, `index`, code, lvl qLvls, prop5 prop, par5 par, min5 `min`, max5 `max` FROM uniqueitems WHERE prop5 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 6 propIdx, `index`, code, lvl qLvls, prop6 prop, par6 par, min6 `min`, max6 `max` FROM uniqueitems WHERE prop6 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 7 propIdx, `index`, code, lvl qLvls, prop7 prop, par7 par, min7 `min`, max7 `max` FROM uniqueitems WHERE prop7 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 8 propIdx, `index`, code, lvl qLvls, prop8 prop, par8 par, min8 `min`, max8 `max` FROM uniqueitems WHERE prop8 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 9 propIdx, `index`, code, lvl qLvls, prop9 prop, par9 par, min9 `min`, max9 `max` FROM uniqueitems WHERE prop9 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 10 propIdx, `index`, code, lvl qLvls, prop10 prop, par10 par, min10 `min`, max10 `max` FROM uniqueitems WHERE prop10 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 11 propIdx, `index`, code, lvl qLvls, prop11 prop, par11 par, min11 `min`, max11 `max` FROM uniqueitems WHERE prop11 IS NOT NULL AND `min` != `max`
                UNION
                SELECT 12 propIdx, `index`, code, lvl qLvls, prop12 prop, par12 par, min12 `min`, max12 `max` FROM uniqueitems WHERE prop12 IS NOT NULL AND `min` != `max`
            ) u
                ON u.`index` = n.Key
        UNION
        -- set items
        SELECT n.id id, propIdx, n.Key, n.zhTW zhTW, item base, u.prop prop, u.par par, u.min `min`, u.max `max`
        FROM item_names n
            JOIN (
                SELECT 1 propIdx, `index`, item, lvl qLvls, prop1 prop, par1 par, min1 `min`, max1 `max` FROM setitems WHERE prop1 IS NOT NULL
                UNION
                SELECT 2 propIdx, `index`, item, lvl qLvls, prop2 prop, par2 par, min2 `min`, max2 `max` FROM setitems WHERE prop2 IS NOT NULL
                UNION
                SELECT 3 propIdx, `index`, item, lvl qLvls, prop3 prop, par3 par, min3 `min`, max3 `max` FROM setitems WHERE prop3 IS NOT NULL
                UNION
                SELECT 4 propIdx, `index`, item, lvl qLvls, prop4 prop, par4 par, min4 `min`, max4 `max` FROM setitems WHERE prop4 IS NOT NULL
                UNION
                SELECT 5 propIdx, `index`, item, lvl qLvls, prop5 prop, par5 par, min5 `min`, max5 `max` FROM setitems WHERE prop5 IS NOT NULL
                UNION
                SELECT 6 propIdx, `index`, item, lvl qLvls, prop6 prop, par6 par, min6 `min`, max6 `max` FROM setitems WHERE prop6 IS NOT NULL
                UNION
                SELECT 7 propIdx, `index`, item, lvl qLvls, prop7 prop, par7 par, min7 `min`, max7 `max` FROM setitems WHERE prop7 IS NOT NULL
                UNION
                SELECT 8 propIdx, `index`, item, lvl qLvls, prop8 prop, par8 par, min8 `min`, max8 `max` FROM setitems WHERE prop8 IS NOT NULL
                UNION
                SELECT 9 propIdx, `index`, item, lvl qLvls, prop9 prop, par9 par, min9 `min`, max9 `max` FROM setitems WHERE prop9 IS NOT NULL
            ) u
        ON u.`index` = n.Key
        UNION
        -- rune word
        SELECT n.id id, propIdx, n.Key, n.zhTW zhTW, "" base, u.prop prop, u.par par, u.min `min`, u.max `max`
        FROM item_runes n
            JOIN (
                SELECT 1 propIdx, NAME, T1Code1 prop, T1param1 par, T1min1 `min`, T1max1 `max` FROM runes WHERE T1Code1 IS NOT NULL
                UNION
                SELECT 2 propIdx, NAME, T1Code2 prop, T1param2 par, T1min2 `min`, T1max2 `max` FROM runes WHERE T1Code2 IS NOT NULL
                UNION
                SELECT 3 propIdx, NAME, T1Code3 prop, T1param3 par, T1min3 `min`, T1max3 `max` FROM runes WHERE T1Code3 IS NOT NULL
                UNION
                SELECT 4 propIdx, NAME, T1Code4 prop, T1param4 par, T1min4 `min`, T1max4 `max` FROM runes WHERE T1Code4 IS NOT NULL
                UNION
                SELECT 5 propIdx, NAME, T1Code5 prop, T1param5 par, T1min5 `min`, T1max5 `max` FROM runes WHERE T1Code5 IS NOT NULL
                UNION
                SELECT 6 propIdx, NAME, T1Code6 prop, T1param6 par, T1min6 `min`, T1max6 `max` FROM runes WHERE T1Code6 IS NOT NULL
                UNION
                SELECT 7 propIdx, NAME, T1Code7 prop, T1param7 par, T1min7 `min`, T1max7 `max` FROM runes WHERE T1Code7 IS NOT NULL
            ) u
        ON u.Name = n.Key
    ) mx
        JOIN properties p
            ON mx.prop = p.code
        LEFT JOIN armor a
            ON mx.base = a.code AND a.code != ""
        LEFT JOIN item_names bn
            ON a.code = bn.Key
WHERE
    (`min` != `max` OR `minac` != `maxac`)
    AND
    prop NOT IN (
    "att-skill"
    , "charged"
    , "death-skill"
    , "dmg-cold"
    , "dmg-elem"
    , "dmg-fire"
    , "dmg-ltng"
    , "dmg-pois"
    , "dmg-mag"
    , "dmg-norm"
    , "gethit-skill"
    , "hit-skill"
    , "kill-skill"
    , "levelup-skill"
    )
ORDER BY id, propIdx

