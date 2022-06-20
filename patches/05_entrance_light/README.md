# 给入口添加光柱

## 入口和文件的对照表

| ACT | 入口/用处                 | 文件名                                                    |
| --- | ------------------------- | --------------------------------------------------------- |
| A2  | 秘法神殿-召唤者           | `data/hd/objects/env_pillars/arcane_tome.json`            |
| A2  | 七个古墓-插杖点           | `data/hd/objects/env_pillars/seven_tombs_receptacle.json` |
| A1  | 乱石旷野-崔斯特姆（红门） | `data/hd/objects/env_stone/stone_alpha.json`              |
| A1  | 地下墓穴(通往安达利尔)    | `data/hd/roomtiles/act_1_catacombs_down.json`             |
| A1  | 洞穴/地穴->第二层         | `data/hd/roomtiles/act_1_cave_down.json`                  |
| A1  | 埋骨坟地-墓地             | `data/hd/roomtiles/act_1_crypt_down.json`                 |
| A1  | 监牢(军营下去)            | `data/hd/roomtiles/act_1_jail_down.json`                  |
| A1  | 监牢(通往内侧回廊)        | `data/hd/roomtiles/act_1_jail_up.json`                    |
| A1  | 遗忘之塔->上楼            | `data/hd/roomtiles/act_1_tower_to_crypt.json`             |
| A1  | 野外->洞穴/地穴           | `data/hd/roomtiles/act_1_wilderness_to_cave_cliff_l.json` |
| A1  | 野外->洞穴/地穴           | `data/hd/roomtiles/act_1_wilderness_to_cave_cliff_r.json` |
| A1  | 野外->洞穴/地穴           | `data/hd/roomtiles/act_1_wilderness_to_cave_floor_l.json` |
| A1  | 野外->洞穴/地穴           | `data/hd/roomtiles/act_1_wilderness_to_cave_floor_r.json` |
| A1  | 黑色荒地-遗忘之塔         | `data/hd/roomtiles/act_1_wilderness_to_tower.json`        |
| A2  | 遥远绿洲-虫洞             | `data/hd/roomtiles/act_2_desert_to_lair.json`             |
| A2  | 遗忘都市-古代通道         | `data/hd/roomtiles/act_2_desert_to_sewer_trap.json`       |
| A2  | 野外->古墓                | `data/hd/roomtiles/act_2_desert_to_tomb_l_1.json`         |
| A2  | 野外->古墓                | `data/hd/roomtiles/act_2_desert_to_tomb_l_2.json`         |
| A2  | 野外->古墓                | `data/hd/roomtiles/act_2_desert_to_tomb_r_1.json`         |
| A2  | 野外->古墓                | `data/hd/roomtiles/act_2_desert_to_tomb_r_2.json`         |
| A2  | 野外->蝮蛇神殿            | `data/hd/roomtiles/act_2_desert_to_tomb_viper.json`       |
| A2  | 虫洞->下楼                | `data/hd/roomtiles/act_2_lair_down.json`                  |
| A2  | 下水道->下楼              | `data/hd/roomtiles/act_2_sewer_down.json`                 |
| A2  | 古墓->下楼                | `data/hd/roomtiles/act_2_tomb_down.json`                  |
| A3  |                           | `data/hd/roomtiles/act_3_jungle_to_dungeon_fort.json`     |
| A3  |                           | `data/hd/roomtiles/act_3_jungle_to_dungeon_hole.json`     |
| A3  |                           | `data/hd/roomtiles/act_3_jungle_to_spider.json`           |
| A3  |                           | `data/hd/roomtiles/act_3_kurast_to_temple.json`           |
| A3  |                           | `data/hd/roomtiles/act_3_mephisto_down_l.json`            |
| A3  |                           | `data/hd/roomtiles/act_3_mephisto_down_r.json`            |
| A3  |                           | `data/hd/roomtiles/act_3_sewer_down.json`                 |
| A4  |                           | `data/hd/roomtiles/act_4_mesa_to_lava.json`               |
| A5  |                           | `data/hd/roomtiles/act_5_baal_temple_down_l.json`         |
| A5  |                           | `data/hd/roomtiles/act_5_baal_temple_down_r.json`         |
| A5  |                           | `data/hd/roomtiles/act_5_barricade_down_wall_l.json`      |
| A5  |                           | `data/hd/roomtiles/act_5_barricade_down_wall_r.json`      |
| A5  |                           | `data/hd/roomtiles/act_5_ice_caves_down_floor.json`       |
| A5  |                           | `data/hd/roomtiles/act_5_ice_caves_down_l.json`           |
| A5  |                           | `data/hd/roomtiles/act_5_ice_caves_down_r.json`           |
| A5  |                           | `data/hd/roomtiles/act_5_temple_down.json`                |
| A5  |                           | `data/hd/roomtiles/act_5_temple_entrance.json`            |
