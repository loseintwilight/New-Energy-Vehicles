-- =============================================
-- 为所有充电站分配封面图片（每个站2张，逗号分隔）
-- 按 station_id 顺序依次分配
-- 图片来源：NEV-APP/static/images/chargeStation/
-- =============================================

SET @row_num = 0;

UPDATE stad_charging_station s
JOIN (
  SELECT station_id, @row_num := @row_num + 1 AS rn
  FROM stad_charging_station
  ORDER BY station_id
) t ON s.station_id = t.station_id
SET s.images = CASE t.rn
  WHEN 1  THEN '/static/images/chargeStation/5f9f5475a6cb848c0476e859b7930c2f.jpg,/static/images/chargeStation/OIP-C.webp'
  WHEN 2  THEN '/static/images/chargeStation/OIP-C (1).webp,/static/images/chargeStation/OIP-C (10).webp'
  WHEN 3  THEN '/static/images/chargeStation/OIP-C (11).webp,/static/images/chargeStation/OIP-C (12).webp'
  WHEN 4  THEN '/static/images/chargeStation/OIP-C (13).webp,/static/images/chargeStation/OIP-C (14).webp'
  WHEN 5  THEN '/static/images/chargeStation/OIP-C (15).webp,/static/images/chargeStation/OIP-C (16).webp'
  WHEN 6  THEN '/static/images/chargeStation/OIP-C (17).webp,/static/images/chargeStation/OIP-C (18).webp'
  WHEN 7  THEN '/static/images/chargeStation/OIP-C (19).webp,/static/images/chargeStation/OIP-C (2).webp'
  WHEN 8  THEN '/static/images/chargeStation/OIP-C (20).webp,/static/images/chargeStation/OIP-C (21).webp'
  WHEN 9  THEN '/static/images/chargeStation/OIP-C (22).webp,/static/images/chargeStation/OIP-C (23).webp'
  WHEN 10 THEN '/static/images/chargeStation/OIP-C (24).webp,/static/images/chargeStation/OIP-C (25).webp'
  WHEN 11 THEN '/static/images/chargeStation/OIP-C (26).webp,/static/images/chargeStation/OIP-C (27).webp'
  WHEN 12 THEN '/static/images/chargeStation/OIP-C (28).webp,/static/images/chargeStation/OIP-C (29).webp'
  WHEN 13 THEN '/static/images/chargeStation/OIP-C (3).webp,/static/images/chargeStation/OIP-C (30).webp'
  WHEN 14 THEN '/static/images/chargeStation/OIP-C (31).webp,/static/images/chargeStation/OIP-C (32).webp'
  WHEN 15 THEN '/static/images/chargeStation/OIP-C (33).webp,/static/images/chargeStation/OIP-C (34).webp'
  WHEN 16 THEN '/static/images/chargeStation/OIP-C (35).webp,/static/images/chargeStation/OIP-C (36).webp'
  WHEN 17 THEN '/static/images/chargeStation/OIP-C (37).webp,/static/images/chargeStation/OIP-C (38).webp'
  WHEN 18 THEN '/static/images/chargeStation/OIP-C (39).webp,/static/images/chargeStation/OIP-C (4).webp'
  WHEN 19 THEN '/static/images/chargeStation/OIP-C (40).webp,/static/images/chargeStation/OIP-C (41).webp'
  WHEN 20 THEN '/static/images/chargeStation/OIP-C (42).webp,/static/images/chargeStation/OIP-C (43).webp'
  WHEN 21 THEN '/static/images/chargeStation/OIP-C (44).webp,/static/images/chargeStation/OIP-C (45).webp'
  WHEN 22 THEN '/static/images/chargeStation/OIP-C (46).webp,/static/images/chargeStation/OIP-C (47).webp'
  WHEN 23 THEN '/static/images/chargeStation/OIP-C (48).webp,/static/images/chargeStation/OIP-C (49).webp'
  WHEN 24 THEN '/static/images/chargeStation/OIP-C (5).webp,/static/images/chargeStation/OIP-C (50).webp'
  WHEN 25 THEN '/static/images/chargeStation/OIP-C (6).webp,/static/images/chargeStation/OIP-C (7).webp'
  WHEN 26 THEN '/static/images/chargeStation/OIP-C (8).webp,/static/images/chargeStation/OIP-C (9).webp'
  WHEN 27 THEN '/static/images/chargeStation/下载 (1).webp,/static/images/chargeStation/下载 (2).webp'
  WHEN 28 THEN '/static/images/chargeStation/下载 (3).webp,/static/images/chargeStation/下载.webp'
END;