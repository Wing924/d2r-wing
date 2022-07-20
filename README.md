# d2r-wing

[![Build](https://github.com/Wing924/d2r-wing/actions/workflows/build.yml/badge.svg)](https://github.com/Wing924/d2r-wing/actions/workflows/build.yml)

Diablo II: Resurrected Mods

## 制作原则

- 尽量精简，最大可能接近于原版
  - 对新人友好，如果以后不用Mod了，切回原版区别也不大，不需要二次适应
  - 尽量不修改物品的原版显示颜色，免得五颜六色眼花缭乱，反而不醒目了
  - 装备名字不去修改，哪怕它本身就很长
- 只添加客观的备注信息
  - 一代布丁一代神，有价值/无价值的信息有可能会造成误判
  - 不添加各类吐槽，装备英文名字
  - 不屏蔽主观无用的物品（四大垃圾词缀除外）
- 只添加能提高刷图效率的功能
  - 不添加好看但是对提高刷图效率帮助不大的功能
- 开发方面
  - 尽可能的从txt中解析数据，而不是手动输入数据
  - 个人精力有限，只支持新版本的繁体翻译
    - 文字支持简体

## 版本介绍

本mod有2个版本：标准版与开荒版。
标准版面向通关后的MF时期；开荒版面向通过前的开荒时期。

主要区别

| 特点         | 标准版       | 开荒版         | 注释                                    |
| ------------ | ------------ | -------------- | --------------------------------------- |
| 杂物         | 屏蔽垃圾杂物 | 不屏蔽任何杂物 | 杂物=药水、卷轴、等                     |
| 垃圾词缀装备 | 屏蔽         | 不屏蔽         | 垃圾词缀=劣等的、损坏的、破旧的、粗制的 |
| 小站光柱标记 | 无标记       | 有标记         |                                         |

## 功能介绍

- 物品
  - 符文
    - 添加编号
    - 添加升级配方的备注
    - 使用更便于辨识编号但不失去原有符号的皮肤
    - #15、#20+符文掉落添加光柱特效醒目标识
    - #20+符文添加暗黑3传奇掉落音效（需要添加 `-txt` 命令列参数）
  - 装备
    - 装备属性添加英文缩写方便关联Max变量备注
    - 具有属性数值上下浮动的装备（包括符文之语）添加Max变量备注
    - 无形的或有孔的装备地面上显示成淡红色，方便区分垃圾与装备 **(1.3+)**
  - 装备的底子（包括灰色、白色、蓝色、亮金、橙色、绿色、暗金）
    - 添加品质备注: 普/扩/精
    - 盔甲和盾牌添加负重备注： 轻/中/重
    - 武器添加攻速备注
    - 防具添加最大防御值备注
      - 精英盔甲，圣骑士盾牌
      - 3孔头，4孔盾牌，法师铠甲 **(1.4+)**
    - 添加最大孔数备注（3孔以上）
    - 添加稀有度备注
      - 底材为tc87的装备添加★
      - 底材为tc84的装备添加☆
    - 给一部分能带有单项职业技能(staff mods)的物品添加了`*`标记 **(1.4+)**
      - 3孔的ASN爪
      - 5孔的PAL权杖
      - 2孔的NEC魔杖
      - 4+孔的SOR法杖
      - BAR专用头
      - DRU专用头
      - SOR法球（电棒等）
      - NEC头颅
    - 让精英底材更加显目 **(1.4+)**
    - 特等的底材添加醒目标识
    - 屏蔽四大垃圾词缀的装备 **（仅限标准版, 1.1+）**
      - 劣等的、损坏的、破旧的、粗制的
  - 特殊物品
    - 红门钥匙
      - 添加了`A1`、`A2`、`A5`的备注
      - 使用更便于辨识的皮肤
    - 精华（合成洗点道具的材料）
      - 添加了`A1A2`、`A3`、`A4`、`A5`的备注
    - 維特的腿（牛关钥匙）改为红色
  - 其他有价值的物品
    - 护身符、戒指、珠宝添加★醒目标识
    - 頭环、宝冠、头冠添加☆醒目标识
    - 特大咒符、小型咒符、珠宝掉落添加光柱特效醒目标识
    - 无瑕宝石、完美宝石的名字颜色改成红色
    - 碎裂宝石、瑕疵宝石、方块宝石的名字颜色改为暗红色 **(1.3+)**
    - 给完美和无瑕宝石添加★醒目标识 **(1.4+)**
  - 药水和其他杂物
    - 药水及卷轴的名字缩短成两个字（微、小、中、大、超红/蓝，小/大紫，回城，鉴定等）
    - 改变颜色
      - 全效活力药水（大紫）改为紫色
      - `小/大紫`、`超红/蓝`以外的药水改为灰色（`小紫`、`超红`、`超蓝`保持白色）
      - `弓矢`、`弩箭`、`鑰匙`、`卷轴`改为灰色
    - `金币` 缩写成 `金`
    - 屏蔽垃圾杂物 **（仅限标准版, 1.1+）**
      - 屏蔽：`微红/蓝～大红/蓝`，各种投掷药水，`回城`，`鉴定`，`钥匙`
      - 保留：`大紫`，`超红`，`超蓝`，`解毒`，`弓矢`，`弩箭` *(1.3+开始屏蔽`小紫`，`溶冰`)*
- 地图
  - 地图名字添加了普通/噩梦/地狱三种难度下的地图等级备注
  - 地牢周围120码光柱标记
  - A2任务面板塔拉夏古墓顺序标记
  - 小站周围120码光柱标记 **（仅限开荒版, 1.1+）**
- 其他
  - 给超级暗黑破坏神的提示信息添加数字的进度条
  - 加长的怪物血条样式，避免有些 Boss 血厚，打半天看不到掉血
  - 让凯恩发光，便于识别
  - 调节了掉落物品的背景透明度 **（1.1+）**
    - 物品再也不会被火焰太亮而看不清字了（说的就是你，火炬）
  - 射出的箭均显示为魔法箭，弓马手感更好，还能防止暗箭伤人 **(1.3+)**
  - 巴尔召唤的假巴尔改名为“巴尔(假)”，便于区分真假巴尔 **(1.4+)**

## 底材的注释

```
权冠【精】(60)★ ③
```

| 文字   | 说明               |
| ------ | ------------------ |
| 权冠   | 底材名称           |
| 【精】 | 精英级别的底材     |
| (60)   | 有形的最高防御是60 |
| ★      | 稀有度为tc87的底材 |
| ③      | 最大孔数为3        |

```
统御者铠甲【精】轻(524-e786)☆ ④
```

| 文字       | 说明                                     |
| ---------- | ---------------------------------------- |
| 统御者铠甲 | 底材名称                                 |
| 【精】     | 精英级别的底材                           |
| 轻｜轻甲   |
| (524-e786) | 有形的最高防御是524，无形的最高防御是786 |
| ☆          | 稀有度为tc84的底材                       |
| ④          | 最大孔数为4                              |

```
巨鹰爪|扩〔-30〕 ③*
```

| 文字    | 说明                                                          |
| ------- | ------------------------------------------------------------- |
| 巨鹰爪  | 底材名称                                                      |
| 扩      | 扩展级别的底材                                                |
| 〔-30〕 | 攻速为-30                                                     |
| ③       | 最大孔数为3                                                   |
| *       | 能带有职业单项技能（staff mod）并且有可能做符文之语或成为电棒 |

## 开发

仅支持 `OSX` 或 `Windows + WSL2`。需要使用各种UNIX系的工具。

```bash
cd /path/to/d2r/mods

git clone git@github.com:Wing924/d2r-wing.git wing

# 生成数据
make gen

# 编译成mod
make build

# 生成可直接使用的mod
make publish
```

### 工具

- [Go](https://go.dev/)
- [Make](https://www.gnu.org/software/make/)
- [TextQL](https://github.com/dinedal/textql)
- [jq](https://stedolan.github.io/jq/)
- [spruce](https://github.com/geofffranks/spruce)
