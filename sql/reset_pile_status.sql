-- ============================================
-- 修复充电桩状态 + 同步充电站表
-- ============================================

-- 1. 查看当前所有充电中的桩
SELECT pile_id, station_id, pile_code, pile_status, current_order_no
FROM stad_charging_pile
WHERE pile_status = '1';

-- 2. 将所有充电中但无有效订单的桩恢复为空闲
UPDATE stad_charging_pile
SET pile_status = '0', current_order_no = NULL
WHERE pile_status = '1';

-- 3. ⭐ 根据实际pile_status重新计算充电站表的可用/占用桩数
UPDATE stad_charging_station s
JOIN (
  SELECT
    station_id,
    SUM(CASE WHEN pile_status='0' THEN 1 ELSE 0 END) AS free,
    SUM(CASE WHEN pile_status='1' THEN 1 ELSE 0 END) AS occupied
  FROM stad_charging_pile
  GROUP BY station_id
) p ON s.station_id = p.station_id
SET s.available_piles = p.free,
    s.occupying_piles = p.occupied;

-- 4. 验证结果
SELECT s.station_id, s.station_name, s.total_piles,
       s.available_piles, s.occupying_piles
FROM stad_charging_station s
ORDER BY s.station_id;
