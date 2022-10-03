#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

lvl_mon=''
for ((i=1; i<=25; i++)); do
    if [[ $i -gt 1 ]]; then
        lvl_mon+='UNION'
    fi
    lvl_mon+="
    SELECT
        l.Name,
        m.Id monId
    FROM levels l
        JOIN monstats m ON l.nmon$i = m.Id
    UNION
    SELECT
        l.Name,
        m1.Id monId
    FROM levels l
        JOIN monstats m ON l.nmon$i = m.Id
        JOIN monstats m1 ON m.minion1 = m1.Id
    UNION
    SELECT
        l.Name,
        m2.Id monId
    FROM levels l
        JOIN monstats m ON l.nmon$i = m.Id
        JOIN monstats m2 ON m.minion2 = m2.Id
    "
done
lvl_mon+="
ORDER BY l.Name"

subquery="
SELECT
    l.Name,
    lg.GroupName levelGroup,
    l.LevelName levelName,
    ms.NameStr monster,
    \`MonDen(H)\` monDen,
    (\`MonUMin(H)\` + \`MonUMax(H)\`)/2.0 monUniq,
    COALESCE(ms.demon, ms.lUndead, ms.hUndead, 0) demon_undead,
    IFNULL(ms.\`ResDm(H)\`, 0) DR,
    IFNULL(ms.\`ResMa(H)\`, 0) MR,
    IFNULL(ms.\`ResFi(H)\`, 0) FR,
    IFNULL(ms.\`ResLi(H)\`, 0) LR,
    IFNULL(ms.\`ResCo(H)\`, 0) CR,
    IFNULL(ms.\`ResPo(H)\`, 0) PR
FROM levels l
    JOIN levelgroups lg ON l.LevelGroup = lg.Name
    LEFT JOIN ($lvl_mon) lm ON l.Name = lm.Name
    LEFT JOIN monstats ms ON lm.monId = ms.Id
"

sql="SELECT
    str.id id,
    SUBSTR(s.Name, 5, 1) act,
    levelGroup,
    str.zhTW groupName,
    AVG(monDen) avgMonDen,
    AVG(monUniq) avgMonUniq,
    MAX(FR) maxFR,
    MAX(LR) maxLR,
    MAX(CR) maxCR,
    MAX(PR) maxPR,
    MAX(DR) maxDR,
    MAX(MR) maxMR,
    MIN(demon_undead) demon_undead
FROM ($subquery) s
    JOIN str ON s.levelGroup = str.Key
GROUP BY act, str.id, levelGroup, groupName
ORDER BY act, str.id"

# sql="$subquery"

scripts/json-to-tsv.sh origin/data/local/lng/strings/levels.json > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/monsters.json > "$tmpdir/monsters.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    origin/data/global/excel/levels.txt \
    origin/data/global/excel/levelgroups.txt \
    origin/data/global/excel/monstats.txt \
    origin/data/global/excel/montype.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/monsters.tsv"
