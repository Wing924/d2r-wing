#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

subquery=''

for i in $(seq 1 25); do
    if [[ $i -gt 1 ]]; then
        subquery+='UNION'
    fi
    subquery+="
    SELECT
        SUBSTR(l.Name, 5, 1) act,
        lgs.id id,
        lg.GroupName GroupKey,
        lgs.zhTW GroupName,
        s.zhTW lvlName,
        mn.zhTW monName,
        ifnull(mt.type, '') || ',' || ifnull(mt.equiv1, '') || ',' || ifnull(mt.equiv2, '') LIKE '%undead%' undead,
        ifnull(mt.type, '') || ',' || ifnull(mt.equiv1, '') || ',' || ifnull(mt.equiv2, '') LIKE '%demon%' demon,
        coalesce(m.\`ResDm(H)\`, 0) DR,
        coalesce(m.\`ResMa(H)\`, 0) MR,
        coalesce(m.\`ResFi(H)\`, 0) FR,
        coalesce(m.\`ResLi(H)\`, 0) LR,
        coalesce(m.\`ResCo(H)\`, 0) CR,
        coalesce(m.\`ResPo(H)\`, 0) PR
    FROM levels l
        JOIN str s ON l.LevelName = s.Key
        JOIN monstats m ON l.nmon$i = m.Id
        JOIN monsters mn ON m.NameStr = mn.Key
        JOIN levelgroups lg ON l.LevelGroup = lg.Name
        JOIN str lgs ON lg.GroupName = lgs.Key
        LEFT JOIN montype mt ON m.MonType = mt.type
    "
done

subquery+="
ORDER BY act, id"

# sql="$subquery"
sql="SELECT
    act,
    id,
    GroupKey,
    GroupName,
    MAX(FR) maxFR,
    MAX(LR) maxLR,
    MAX(CR) maxCR,
    MAX(PR) maxPR,
    MAX(DR) maxDR,
    MAX(MR) maxMR,
    MIN(undead+demon) < 1 not_undead_demon

FROM ($subquery)
GROUP BY act, id, GroupKey, GroupName"

# sql="SELECT
#     act,
#     lvlname,
#     MIN(undead + demon) > 0 'undead + daemon',
#     MAX(MR) '魔法抗性',
#     MAX(DR) '物理抗性',
#     MAX(FR) '火系抗性',
#     MAX(LR) '电系抗性',
#     MAX(CR) '冰系抗性',
#     MAX(PR) '毒系抗性',

#     MAX(LR) < 100 '电标AMA',
#     MAX(DR) < 100 '物理弓AMA',
#     MAX(FR) < 100 '火弓AMA',
#     MAX(CR) < 100 '冰弓AMA',
#     MIN(undead + demon) > 0 '天拳PAL',
#     MAX(MR) < 100 '锤子PAL',
#     MAX(CR) < 100 '纯冰SOR',
#     MAX(FR) < 100 '纯火SOR',
#     MAX(LR) < 100 '纯电SOR',
#     MAX(MR) < 100 '骨系NEC',
#     MAX(PR) < 100 '毒系NEC'
# FROM ($subquery)
# GROUP BY id, act, lvlname
# ORDER BY act, lvlname
# "

# echo "$sql"

scripts/json-to-tsv.sh origin/data/local/lng/strings/levels.json > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/monsters.json > "$tmpdir/monsters.tsv"
# echo "$TZ" > "$tmpdir/tz.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    origin/data/global/excel/levels.txt \
    origin/data/global/excel/levelgroups.txt \
    origin/data/global/excel/monstats.txt \
    origin/data/global/excel/montype.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/monsters.tsv"
