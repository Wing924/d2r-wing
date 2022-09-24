#!/bin/bash

set -eu

cd "$(git rev-parse --show-toplevel)"

tmpdir="$(mktemp -d)"
trap 'rm -rf $tmpdir' EXIT

TZ=$'
act\tname
Act 1\t鮮血荒地
Act 1\t邪惡洞窟
Act 1\t冰冷之原
Act 1\t洞穴第一層
Act 1\t洞穴第二層  洞穴
Act 1\t埋骨之地
Act 1\t墓地
Act 1\t大陵墓
Act 1\t黑暗森林
Act 1\t高塔地牢第一層
Act 1\t高塔地牢第二層
Act 1\t高塔地牢第三層
Act 1\t高塔地牢第四層
Act 1\t高塔地牢第五層
Act 1\t地穴第一層
Act 1\t地穴第二層
Act 1\t監牢第一層
Act 1\t監牢第二層
Act 1\t監牢第三層
Act 1\t大教堂
Act 1\t地下墓穴第一層
Act 1\t地下墓穴第二層
Act 1\t地下墓穴第三層
Act 1\t地下墓穴第四層
Act 1\t崔斯特姆
Act 1\t秘密乳牛關
Act 2\t下水道第一層
Act 2\t下水道第二層
Act 2\t下水道第三層
Act 2\t碎石荒地
Act 2\t古老石墓第一層
Act 2\t古老石墓第二層
Act 2\t乾土高地
Act 2\t死亡之殿第一層
Act 2\t死亡之殿第二層
Act 2\t死亡之殿第三層
Act 2\t遙遠的綠洲
Act 2\t失落古城
Act 2\t群蛇峽谷
Act 2\t利爪蛇魔神殿第一層
Act 2\t利爪蛇魔神殿第二層
Act 2\t秘法聖殿
Act 2\t塔拉夏的古墓
Act 3\t蜘蛛森林
Act 3\t蜘蛛巢穴
Act 3\t剝皮叢林
Act 3\t剝皮地牢第一層
Act 3\t剝皮地牢第二層
Act 3\t剝皮地牢第三層
Act 3\t庫拉斯特市集
Act 3\t廢棄的寺院
Act 3\t廢棄的聖殿
Act 3\t下水道第一層
Act 3\t下水道第二層
Act 3\t崔凡克
Act 3\t憎恨囚牢第一層
Act 3\t憎恨囚牢第二層
Act 3\t憎恨囚牢第三層
Act 4\t外圍荒原
Act 4\t絕望平原
Act 4\t罪罰之城
Act 4\t火焰之河
Act 4\t混沌魔殿
Act 5\t血腥丘陵
Act 5\t冰凍高地
Act 5\t冰河小徑
Act 5\t水晶通道
Act 5\t冰凍之河
Act 5\t亞瑞特高原
Act 5\t尼拉塞克的神殿
Act 5\t怨慟之廳
Act 5\t苦痛之廳
Act 5\t沃特之廳
Act 5\t先祖之路
Act 5\t冰窖
Act 5\t世界之石要塞第一層
Act 5\t世界之石要塞第二層
Act 5\t世界之石要塞第三層
Act 5\t毀滅王座
'

subquery=''

for i in $(seq 1 25); do
    if [[ $i -gt 1 ]]; then
        subquery+='UNION'
    fi
    subquery+="
    SELECT
        s.id id,
        SUBSTR(l.Name, 0, 6) act,
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
        JOIN tz ON s.zhTW = tz.name AND SUBSTR(l.Name, 0, 6) = tz.act
        JOIN monstats m ON l.nmon$i = m.Id
        JOIN monsters mn ON m.NameStr = mn.Key
        LEFT JOIN montype mt ON m.MonType = mt.type
    "
done

subquery+="
ORDER BY act, lvlName"

sql="SELECT
    act,
    lvlname,
    MIN(undead + demon) > 0 'undead + daemon',
    MAX(MR) '魔法抗性',
    MAX(DR) '物理抗性',
    MAX(FR) '火系抗性',
    MAX(LR) '电系抗性',
    MAX(CR) '冰系抗性',
    MAX(PR) '毒系抗性',

    MAX(LR) < 100 '电标AMA',
    MAX(DR) < 100 '物理弓AMA',
    MAX(FR) < 100 '火弓AMA',
    MAX(CR) < 100 '冰弓AMA',
    MIN(undead + demon) > 0 '天拳PAL',
    MAX(MR) < 100 '锤子PAL',
    MAX(CR) < 100 '纯冰SOR',
    MAX(FR) < 100 '纯火SOR',
    MAX(LR) < 100 '纯电SOR',
    MAX(MR) < 100 '骨系NEC',
    MAX(PR) < 100 '毒系NEC'
FROM ($subquery)
GROUP BY id, act, lvlname
ORDER BY act, lvlname
"

# echo "$sql"

scripts/json-to-tsv.sh origin/data/local/lng/strings/levels.json > "$tmpdir/str.tsv"
scripts/json-to-tsv.sh origin/data/local/lng/strings/monsters.json > "$tmpdir/monsters.tsv"
echo "$TZ" > "$tmpdir/tz.tsv"

textql -header -dlm=tab -output-dlm=tab -output-header \
    -sql "$sql" \
    origin/data/global/excel/levels.txt \
    origin/data/global/excel/monstats.txt \
    origin/data/global/excel/montype.txt \
    "$tmpdir/str.tsv" \
    "$tmpdir/monsters.tsv" \
    "$tmpdir/tz.tsv"
