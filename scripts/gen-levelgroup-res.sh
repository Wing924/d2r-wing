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
        s.id,
        lg.GroupName GroupKey,
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
        LEFT JOIN montype mt ON m.MonType = mt.type
    "
done

subquery+="
ORDER BY act, s.id"

sql="$subquery"
sql="SELECT
    str.id,
    GroupKey,
    str.zhTW GroupName,
    MAX(FR) maxFR,
    MAX(LR) maxLR,
    MAX(CR) maxCR,
    MAX(PR) maxPR,
    MAX(DR) maxDR,
    MAX(MR) maxMR,
    MIN(undead+demon) < 1 not_undead_demon

FROM ($subquery) s
    JOIN str ON s.GroupKey = str.Key
GROUP BY str.id, GroupKey, GroupName
ORDER BY str.id"

patches/12_levelgroup_res/data/global/excel/levelgroups.txt.sh < origin/data/global/excel/levelgroups.txt > "$tmpdir/levelgroups.txt"
scripts/json-to-tsv.sh <(patches/12_levelgroup_res/data/local/lng/strings/levels.json.sh < origin/data/local/lng/strings/levels.json) > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/monsters.json > "$tmpdir/monsters.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    origin/data/global/excel/levels.txt \
    "$tmpdir/levelgroups.txt" \
    origin/data/global/excel/monstats.txt \
    origin/data/global/excel/montype.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/monsters.tsv"
