CREATE TABLE equips(itemKey, category, itemName,  baseCode);
CREATE TABLE equip_props(itemKey, prop, param, minValue, maxValue);

INSERT INTO equips(itemKey, category, itemName,  baseCode)
SELECT DISTINCT `index` itemKey, 'uniq' category, `index` itemName, code baseCode FROM uniqueitems WHERE code != "" AND enabled = "1";

INSERT INTO equips(itemKey, category, itemName,  baseCode)
SELECT DISTINCT `index` itemKey, 'set' category, `index` itemName, item baseCode FROM setitems WHERE item != "";

INSERT INTO equips(itemKey, category, itemName,  baseCode)
SELECT DISTINCT `Name` itemKey, 'rw' category, `*Rune Name` itemName,  '' baseCode FROM runes WHERE complete = "1";

INSERT INTO equip_props(itemKey, prop, param, minValue, maxValue)
      SELECT `index` itemKey, prop1  prop, par1  param, min1  minValue, max1  maxValue FROM uniqueitems WHERE prop1  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop2  prop, par2  param, min2  minValue, max2  maxValue FROM uniqueitems WHERE prop2  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop3  prop, par3  param, min3  minValue, max3  maxValue FROM uniqueitems WHERE prop3  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop4  prop, par4  param, min4  minValue, max4  maxValue FROM uniqueitems WHERE prop4  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop5  prop, par5  param, min5  minValue, max5  maxValue FROM uniqueitems WHERE prop5  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop6  prop, par6  param, min6  minValue, max6  maxValue FROM uniqueitems WHERE prop6  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop7  prop, par7  param, min7  minValue, max7  maxValue FROM uniqueitems WHERE prop7  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop8  prop, par8  param, min8  minValue, max8  maxValue FROM uniqueitems WHERE prop8  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop9  prop, par9  param, min9  minValue, max9  maxValue FROM uniqueitems WHERE prop9  != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop10 prop, par10 param, min10 minValue, max10 maxValue FROM uniqueitems WHERE prop10 != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop11 prop, par11 param, min11 minValue, max11 maxValue FROM uniqueitems WHERE prop11 != "" AND enabled = "1"
UNION SELECT `index` itemKey, prop12 prop, par12 param, min12 minValue, max12 maxValue FROM uniqueitems WHERE prop12 != "" AND enabled = "1";

INSERT INTO equip_props(itemKey, prop, param, minValue, maxValue)
      SELECT `index` itemKey, prop1   prop, par1   param, min1   minValue, max1   maxValue FROM setitems WHERE prop1   != ""
UNION SELECT `index` itemKey, prop2   prop, par2   param, min2   minValue, max2   maxValue FROM setitems WHERE prop2   != ""
UNION SELECT `index` itemKey, prop3   prop, par3   param, min3   minValue, max3   maxValue FROM setitems WHERE prop3   != ""
UNION SELECT `index` itemKey, prop4   prop, par4   param, min4   minValue, max4   maxValue FROM setitems WHERE prop4   != ""
UNION SELECT `index` itemKey, prop5   prop, par5   param, min5   minValue, max5   maxValue FROM setitems WHERE prop5   != ""
UNION SELECT `index` itemKey, prop6   prop, par6   param, min6   minValue, max6   maxValue FROM setitems WHERE prop6   != ""
UNION SELECT `index` itemKey, prop7   prop, par7   param, min7   minValue, max7   maxValue FROM setitems WHERE prop7   != ""
UNION SELECT `index` itemKey, prop8   prop, par8   param, min8   minValue, max8   maxValue FROM setitems WHERE prop8   != ""
UNION SELECT `index` itemKey, prop9   prop, par9   param, min9   minValue, max9   maxValue FROM setitems WHERE prop9   != ""
UNION SELECT `index` itemKey, aprop1a prop, apar1a param, amin1a minValue, amax1a maxValue FROM setitems WHERE aprop1a != ""
UNION SELECT `index` itemKey, aprop2a prop, apar2a param, amin2a minValue, amax2a maxValue FROM setitems WHERE aprop2a != ""
UNION SELECT `index` itemKey, aprop3a prop, apar3a param, amin3a minValue, amax3a maxValue FROM setitems WHERE aprop3a != ""
UNION SELECT `index` itemKey, aprop4a prop, apar4a param, amin4a minValue, amax4a maxValue FROM setitems WHERE aprop4a != ""
UNION SELECT `index` itemKey, aprop5a prop, apar5a param, amin5a minValue, amax5a maxValue FROM setitems WHERE aprop5a != ""
UNION SELECT `index` itemKey, aprop1b prop, apar1b param, amin1b minValue, amax1b maxValue FROM setitems WHERE aprop1b != ""
UNION SELECT `index` itemKey, aprop2b prop, apar2b param, amin2b minValue, amax2b maxValue FROM setitems WHERE aprop2b != ""
UNION SELECT `index` itemKey, aprop3b prop, apar3b param, amin3b minValue, amax3b maxValue FROM setitems WHERE aprop3b != ""
UNION SELECT `index` itemKey, aprop4b prop, apar4b param, amin4b minValue, amax4b maxValue FROM setitems WHERE aprop4b != ""
UNION SELECT `index` itemKey, aprop5b prop, apar5b param, amin5b minValue, amax5b maxValue FROM setitems WHERE aprop5b != "";

INSERT INTO equip_props(itemKey, prop, param, minValue, maxValue)
      SELECT `NAME` itemKey, T1Code1 prop, T1param1 param, T1min1 minVlaue, T1max1 maxValue FROM runes WHERE complete = "1" AND T1Code1 != ""
UNION SELECT `NAME` itemKey, T1Code2 prop, T1param2 param, T1min2 minVlaue, T1max2 maxValue FROM runes WHERE complete = "1" AND T1Code2 != ""
UNION SELECT `NAME` itemKey, T1Code3 prop, T1param3 param, T1min3 minVlaue, T1max3 maxValue FROM runes WHERE complete = "1" AND T1Code3 != ""
UNION SELECT `NAME` itemKey, T1Code4 prop, T1param4 param, T1min4 minVlaue, T1max4 maxValue FROM runes WHERE complete = "1" AND T1Code4 != ""
UNION SELECT `NAME` itemKey, T1Code5 prop, T1param5 param, T1min5 minVlaue, T1max5 maxValue FROM runes WHERE complete = "1" AND T1Code5 != ""
UNION SELECT `NAME` itemKey, T1Code6 prop, T1param6 param, T1min6 minVlaue, T1max6 maxValue FROM runes WHERE complete = "1" AND T1Code6 != ""
UNION SELECT `NAME` itemKey, T1Code7 prop, T1param7 param, T1min7 minVlaue, T1max7 maxValue FROM runes WHERE complete = "1" AND T1Code7 != "";
--
-- -- uniq
-- SELECT DISTINCT 'uniq' category, 0 idx,  `index` itemName, `index` itemKey, code baseCode, "" prop, "" param, 0 minValue, 0 maxValue FROM uniqueitems WHERE code != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 1 idx,  `index` itemName, `index` itemKey, code baseCode, prop1 prop, par1 param, min1 minValue, max1 maxValue FROM uniqueitems WHERE prop1 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 2 idx,  `index` itemName, `index` itemKey, code baseCode, prop2 prop, par2 param, min2 minValue, max2 maxValue FROM uniqueitems WHERE prop2 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 3 idx,  `index` itemName, `index` itemKey, code baseCode, prop3 prop, par3 param, min3 minValue, max3 maxValue FROM uniqueitems WHERE prop3 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 4 idx,  `index` itemName, `index` itemKey, code baseCode, prop4 prop, par4 param, min4 minValue, max4 maxValue FROM uniqueitems WHERE prop4 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 5 idx,  `index` itemName, `index` itemKey, code baseCode, prop5 prop, par5 param, min5 minValue, max5 maxValue FROM uniqueitems WHERE prop5 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 6 idx,  `index` itemName, `index` itemKey, code baseCode, prop6 prop, par6 param, min6 minValue, max6 maxValue FROM uniqueitems WHERE prop6 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 7 idx,  `index` itemName, `index` itemKey, code baseCode, prop7 prop, par7 param, min7 minValue, max7 maxValue FROM uniqueitems WHERE prop7 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 8 idx,  `index` itemName, `index` itemKey, code baseCode, prop8 prop, par8 param, min8 minValue, max8 maxValue FROM uniqueitems WHERE prop8 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 9 idx,  `index` itemName, `index` itemKey, code baseCode, prop9 prop, par9 param, min9 minValue, max9 maxValue FROM uniqueitems WHERE prop9 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 10 idx, `index` itemName, `index` itemKey, code baseCode, prop10 prop, par10 param, min10 minValue, max10 maxValue FROM uniqueitems WHERE prop10 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 11 idx, `index` itemName, `index` itemKey, code baseCode, prop11 prop, par11 param, min11 minValue, max11 maxValue FROM uniqueitems WHERE prop11 != "" AND enabled = "1"
-- UNION SELECT    'uniq' category, 12 idx, `index` itemName, `index` itemKey, code baseCode, prop12 prop, par12 param, min12 minValue, max12 maxValue FROM uniqueitems WHERE prop12 != "" AND enabled = "1"
-- -- set
-- UNION
-- SELECT DISTINCT 'set' category, 0 idx, `index` itemName, `index` itemKey, item baseCode, "" prop, "" param, 0 minValue, 0 maxValue FROM setitems WHERE item != ""
-- UNION SELECT    'set' category, 1 idx, `index` itemName, `index` itemKey, item baseCode, prop1 prop, par1 param, min1 minValue, max1 maxValue FROM setitems WHERE prop1 != ""
-- UNION SELECT    'set' category, 2 idx, `index` itemName, `index` itemKey, item baseCode, prop2 prop, par2 param, min2 minValue, max2 maxValue FROM setitems WHERE prop2 != ""
-- UNION SELECT    'set' category, 3 idx, `index` itemName, `index` itemKey, item baseCode, prop3 prop, par3 param, min3 minValue, max3 maxValue FROM setitems WHERE prop3 != ""
-- UNION SELECT    'set' category, 4 idx, `index` itemName, `index` itemKey, item baseCode, prop4 prop, par4 param, min4 minValue, max4 maxValue FROM setitems WHERE prop4 != ""
-- UNION SELECT    'set' category, 5 idx, `index` itemName, `index` itemKey, item baseCode, prop5 prop, par5 param, min5 minValue, max5 maxValue FROM setitems WHERE prop5 != ""
-- UNION SELECT    'set' category, 6 idx, `index` itemName, `index` itemKey, item baseCode, prop6 prop, par6 param, min6 minValue, max6 maxValue FROM setitems WHERE prop6 != ""
-- UNION SELECT    'set' category, 7 idx, `index` itemName, `index` itemKey, item baseCode, prop7 prop, par7 param, min7 minValue, max7 maxValue FROM setitems WHERE prop7 != ""
-- UNION SELECT    'set' category, 8 idx, `index` itemName, `index` itemKey, item baseCode, prop8 prop, par8 param, min8 minValue, max8 maxValue FROM setitems WHERE prop8 != ""
-- UNION SELECT    'set' category, 9 idx, `index` itemName, `index` itemKey, item baseCode, prop9 prop, par9 param, min9 minValue, max9 maxValue FROM setitems WHERE prop9 != ""
-- -- rune word
-- UNION SELECT 'rw' category, 1 idx,`*Rune Name` itemName, `NAME` itemKey, '' baseCode, T1Code1 prop, T1param1 param, T1min1 minVlaue, T1max1 maxValue FROM runes WHERE complete = "1" AND T1Code1 != ""
-- UNION SELECT 'rw' category, 2 idx,`*Rune Name` itemName, `NAME` itemKey, '' baseCode, T1Code2 prop, T1param2 param, T1min2 minVlaue, T1max2 maxValue FROM runes WHERE complete = "1" AND T1Code2 != ""
-- UNION SELECT 'rw' category, 3 idx,`*Rune Name` itemName, `NAME` itemKey, '' baseCode, T1Code3 prop, T1param3 param, T1min3 minVlaue, T1max3 maxValue FROM runes WHERE complete = "1" AND T1Code3 != ""
-- UNION SELECT 'rw' category, 4 idx,`*Rune Name` itemName, `NAME` itemKey, '' baseCode, T1Code4 prop, T1param4 param, T1min4 minVlaue, T1max4 maxValue FROM runes WHERE complete = "1" AND T1Code4 != ""
-- UNION SELECT 'rw' category, 5 idx,`*Rune Name` itemName, `NAME` itemKey, '' baseCode, T1Code5 prop, T1param5 param, T1min5 minVlaue, T1max5 maxValue FROM runes WHERE complete = "1" AND T1Code5 != ""
-- UNION SELECT 'rw' category, 6 idx,`*Rune Name` itemName, `NAME` itemKey, '' baseCode, T1Code6 prop, T1param6 param, T1min6 minVlaue, T1max6 maxValue FROM runes WHERE complete = "1" AND T1Code6 != ""
-- UNION SELECT 'rw' category, 7 idx,`*Rune Name` itemName, `NAME` itemKey, '' baseCode, T1Code7 prop, T1param7 param, T1min7 minVlaue, T1max7 maxValue FROM runes WHERE complete = "1" AND T1Code7 != ""
