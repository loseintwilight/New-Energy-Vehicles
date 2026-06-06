-- ============================================================
-- 充电站经纬度数据修正脚本
-- 说明：更新 stad_charging_station 表中各充电站的经纬度坐标
--       坐标系统：GCJ-02（火星坐标系），与国内主流地图一致
-- 使用方法：直接运行此脚本即可
-- ============================================================

-- 1. 济南奥体中心充电站
UPDATE `stad_charging_station`
SET `longitude` = 117.109752, `latitude` = 36.677073, `geo_hash` = 'wwe3x4'
WHERE `station_id` = 1;

-- 2. 济南万达广场充电站
UPDATE `stad_charging_station`
SET `longitude` = 117.001856, `latitude` = 36.663218, `geo_hash` = 'wwe3mq'
WHERE `station_id` = 2;

-- 3. 济南长清大学城充电站
UPDATE `stad_charging_station`
SET `longitude` = 116.807474, `latitude` = 36.559826, `geo_hash` = 'wwdxv4'
WHERE `station_id` = 3;

-- 4. 青岛万象城充电站
UPDATE `stad_charging_station`
SET `longitude` = 120.380000, `latitude` = 36.070000, `geo_hash` = 'wmt6ge'
WHERE `station_id` = 4;

-- 5. 青岛金沙滩充电站
UPDATE `stad_charging_station`
SET `longitude` = 120.230260, `latitude` = 35.971400, `geo_hash` = 'wmt2c0'
WHERE `station_id` = 5;

-- 6. 青岛即墨古城充电站
UPDATE `stad_charging_station`
SET `longitude` = 120.467939, `latitude` = 36.388494, `geo_hash` = 'wmtk9b'
WHERE `station_id` = 6;

-- 7. 淄博万象汇充电站
UPDATE `stad_charging_station`
SET `longitude` = 118.060000, `latitude` = 36.800000, `geo_hash` = 'wwef8u'
WHERE `station_id` = 7;

-- 8. 枣庄薛城万达充电站
UPDATE `stad_charging_station`
SET `longitude` = 117.263000, `latitude` = 34.795000, `geo_hash` = 'wwdkj5'
WHERE `station_id` = 8;

-- 9. 东营东城万达充电站
UPDATE `stad_charging_station`
SET `longitude` = 118.670000, `latitude` = 37.450000, `geo_hash` = 'wwh2qp'
WHERE `station_id` = 9;

-- 10. 烟台芝罘万达充电站
UPDATE `stad_charging_station`
SET `longitude` = 121.390000, `latitude` = 37.540000, `geo_hash` = 'wwpmc0'
WHERE `station_id` = 10;

-- 11. 烟台莱山五彩城充电站
UPDATE `stad_charging_station`
SET `longitude` = 121.450000, `latitude` = 37.480000, `geo_hash` = 'wwpsr0'
WHERE `station_id` = 11;

-- 12. 潍坊泰华城充电站
UPDATE `stad_charging_station`
SET `longitude` = 119.111672, `latitude` = 36.708984, `geo_hash` = 'wwet9p'
WHERE `station_id` = 12;

-- 13. 寿光万达广场充电站
UPDATE `stad_charging_station`
SET `longitude` = 118.771712, `latitude` = 36.874061, `geo_hash` = 'wwf8r0'
WHERE `station_id` = 13;

-- 14. 济宁任城万达充电站
UPDATE `stad_charging_station`
SET `longitude` = 116.603844, `latitude` = 35.408283, `geo_hash` = 'wwdq3e'
WHERE `station_id` = 14;

-- 15. 泰安泰山红门充电站
UPDATE `stad_charging_station`
SET `longitude` = 117.127803, `latitude` = 36.211012, `geo_hash` = 'wwdw6n'
WHERE `station_id` = 15;

-- 16. 威高广场充电站
UPDATE `stad_charging_station`
SET `longitude` = 122.123147, `latitude` = 37.504615, `geo_hash` = 'wwpv4e'
WHERE `station_id` = 16;

-- 17. 临沂万象汇充电站
UPDATE `stad_charging_station`
SET `longitude` = 118.350000, `latitude` = 35.060000, `geo_hash` = 'wwdq5e'
WHERE `station_id` = 18;

-- 18. 曲阜三孔景区充电站
UPDATE `stad_charging_station`
SET `longitude` = 116.992495, `latitude` = 35.591042, `geo_hash` = 'wwdqn5'
WHERE `station_id` = 26;