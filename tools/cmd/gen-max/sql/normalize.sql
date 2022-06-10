CREATE TABLE equips(itemKey, category, itemName,  baseCode);

INSERT INTO equips(itemKey, category, itemName,  baseCode)
SELECT DISTINCT `index` itemKey, 'uniq' category, `index` itemName, code baseCode FROM uniqueitems WHERE code != "" AND enabled = "1";

INSERT INTO equips(itemKey, category, itemName,  baseCode)
SELECT DISTINCT `index` itemKey, 'set' category, `index` itemName, item baseCode FROM setitems WHERE item != "";

INSERT INTO equips(itemKey, category, itemName,  baseCode)
SELECT DISTINCT `Name` itemKey, 'rw' category, `*Rune Name` itemName,  '' baseCode FROM runes WHERE complete = "1";

CREATE TABLE equip_props(itemKey, idx, prop, param, minValue, maxValue);

INSERT INTO equip_props(itemKey, idx, prop, param, minValue, maxValue)
      SELECT `index` itemKey, 1  idx, prop1  prop, par1  param, min1  minValue, max1  maxValue FROM uniqueitems WHERE prop1  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 2  idx, prop2  prop, par2  param, min2  minValue, max2  maxValue FROM uniqueitems WHERE prop2  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 3  idx, prop3  prop, par3  param, min3  minValue, max3  maxValue FROM uniqueitems WHERE prop3  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 4  idx, prop4  prop, par4  param, min4  minValue, max4  maxValue FROM uniqueitems WHERE prop4  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 5  idx, prop5  prop, par5  param, min5  minValue, max5  maxValue FROM uniqueitems WHERE prop5  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 6  idx, prop6  prop, par6  param, min6  minValue, max6  maxValue FROM uniqueitems WHERE prop6  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 7  idx, prop7  prop, par7  param, min7  minValue, max7  maxValue FROM uniqueitems WHERE prop7  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 8  idx, prop8  prop, par8  param, min8  minValue, max8  maxValue FROM uniqueitems WHERE prop8  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 9  idx, prop9  prop, par9  param, min9  minValue, max9  maxValue FROM uniqueitems WHERE prop9  != "" AND enabled = "1"
UNION SELECT `index` itemKey, 10 idx, prop10 prop, par10 param, min10 minValue, max10 maxValue FROM uniqueitems WHERE prop10 != "" AND enabled = "1"
UNION SELECT `index` itemKey, 11 idx, prop11 prop, par11 param, min11 minValue, max11 maxValue FROM uniqueitems WHERE prop11 != "" AND enabled = "1"
UNION SELECT `index` itemKey, 12 idx, prop12 prop, par12 param, min12 minValue, max12 maxValue FROM uniqueitems WHERE prop12 != "" AND enabled = "1";

INSERT INTO equip_props(itemKey, idx, prop, param, minValue, maxValue)
      SELECT `index` itemKey, 1 idx,  prop1   prop, par1   param, min1   minValue, max1   maxValue FROM setitems WHERE prop1   != ""
UNION SELECT `index` itemKey, 2 idx,  prop2   prop, par2   param, min2   minValue, max2   maxValue FROM setitems WHERE prop2   != ""
UNION SELECT `index` itemKey, 3 idx,  prop3   prop, par3   param, min3   minValue, max3   maxValue FROM setitems WHERE prop3   != ""
UNION SELECT `index` itemKey, 4 idx,  prop4   prop, par4   param, min4   minValue, max4   maxValue FROM setitems WHERE prop4   != ""
UNION SELECT `index` itemKey, 5 idx,  prop5   prop, par5   param, min5   minValue, max5   maxValue FROM setitems WHERE prop5   != ""
UNION SELECT `index` itemKey, 6 idx,  prop6   prop, par6   param, min6   minValue, max6   maxValue FROM setitems WHERE prop6   != ""
UNION SELECT `index` itemKey, 7 idx,  prop7   prop, par7   param, min7   minValue, max7   maxValue FROM setitems WHERE prop7   != ""
UNION SELECT `index` itemKey, 8 idx,  prop8   prop, par8   param, min8   minValue, max8   maxValue FROM setitems WHERE prop8   != ""
UNION SELECT `index` itemKey, 9 idx,  prop9   prop, par9   param, min9   minValue, max9   maxValue FROM setitems WHERE prop9   != ""
UNION SELECT `index` itemKey, -1 idx, aprop1a prop, apar1a param, amin1a minValue, amax1a maxValue FROM setitems WHERE aprop1a != ""
UNION SELECT `index` itemKey, -1 idx, aprop2a prop, apar2a param, amin2a minValue, amax2a maxValue FROM setitems WHERE aprop2a != ""
UNION SELECT `index` itemKey, -1 idx, aprop3a prop, apar3a param, amin3a minValue, amax3a maxValue FROM setitems WHERE aprop3a != ""
UNION SELECT `index` itemKey, -1 idx, aprop4a prop, apar4a param, amin4a minValue, amax4a maxValue FROM setitems WHERE aprop4a != ""
UNION SELECT `index` itemKey, -1 idx, aprop5a prop, apar5a param, amin5a minValue, amax5a maxValue FROM setitems WHERE aprop5a != ""
UNION SELECT `index` itemKey, -1 idx, aprop1b prop, apar1b param, amin1b minValue, amax1b maxValue FROM setitems WHERE aprop1b != ""
UNION SELECT `index` itemKey, -1 idx, aprop2b prop, apar2b param, amin2b minValue, amax2b maxValue FROM setitems WHERE aprop2b != ""
UNION SELECT `index` itemKey, -1 idx, aprop3b prop, apar3b param, amin3b minValue, amax3b maxValue FROM setitems WHERE aprop3b != ""
UNION SELECT `index` itemKey, -1 idx, aprop4b prop, apar4b param, amin4b minValue, amax4b maxValue FROM setitems WHERE aprop4b != ""
UNION SELECT `index` itemKey, -1 idx, aprop5b prop, apar5b param, amin5b minValue, amax5b maxValue FROM setitems WHERE aprop5b != "";

INSERT INTO equip_props(itemKey, idx, prop, param, minValue, maxValue)
      SELECT `Name` itemKey, 1 idx, T1Code1 prop, T1param1 `param`, T1min1 minVlaue, T1max1 maxValue FROM runes WHERE complete = "1" AND T1Code1 != ""
UNION SELECT `Name` itemKey, 2 idx, T1Code2 prop, T1param2 `param`, T1min2 minVlaue, T1max2 maxValue FROM runes WHERE complete = "1" AND T1Code2 != ""
UNION SELECT `Name` itemKey, 3 idx, T1Code3 prop, T1param3 `param`, T1min3 minVlaue, T1max3 maxValue FROM runes WHERE complete = "1" AND T1Code3 != ""
UNION SELECT `Name` itemKey, 4 idx, T1Code4 prop, T1param4 `param`, T1min4 minVlaue, T1max4 maxValue FROM runes WHERE complete = "1" AND T1Code4 != ""
UNION SELECT `Name` itemKey, 5 idx, T1Code5 prop, T1param5 `param`, T1min5 minVlaue, T1max5 maxValue FROM runes WHERE complete = "1" AND T1Code5 != ""
UNION SELECT `Name` itemKey, 6 idx, T1Code6 prop, T1param6 `param`, T1min6 minVlaue, T1max6 maxValue FROM runes WHERE complete = "1" AND T1Code6 != ""
UNION SELECT `Name` itemKey, 7 idx, T1Code7 prop, T1param7 `param`, T1min7 minVlaue, T1max7 maxValue FROM runes WHERE complete = "1" AND T1Code7 != "";
