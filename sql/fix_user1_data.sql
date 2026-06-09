-- ============================================
-- 修复 user=1 碳积分档案 + 流水数据
-- 适用于新能生活小程序
-- ============================================

-- 1. 给 user=1 (admin) 补充碳积分个人档案
INSERT INTO `stad_user_profile` (`profile_id`, `user_id`, `id_card`, `total_earned`, `total_spent`, `balance`, `create_by`, `create_time`, `update_by`, `update_time`)
VALUES (3, 1, NULL, 150, 30, 120, 'admin', NOW(), 'admin', NOW())
ON DUPLICATE KEY UPDATE
    `total_earned` = VALUES(`total_earned`),
    `total_spent` = VALUES(`total_spent`),
    `balance` = VALUES(`balance`);

-- 2. 给 user=1 补充碳积分流水记录
-- 充电完成获得积分（关联充电订单 order_id=13, 已完成, carbon_earned=0 但补充积分）
INSERT INTO `stad_carbon_ledger` (`ledger_id`, `user_id`, `record_type`, `rule_id`, `points`, `balance_after`, `source_type`, `source_id`, `remark`, `create_time`, `create_by`, `update_by`)
VALUES
(12, 1, 0, NULL, 50, 50, 0, 13, '充电订单CO1780913509182 - 碳积分奖励', '2026-06-08 18:16:01', 'admin', 'admin'),
(13, 1, 0, NULL, 30, 80, 0, 18, '充电订单CO1780918490356 - 碳积分奖励', '2026-06-08 19:34:55', 'admin', 'admin'),
(14, 1, 0, NULL, 20, 100, 3, 1, '每日签到 - 碳积分奖励', '2026-06-09 08:00:00', 'admin', 'admin'),
(15, 1, 0, NULL, 50, 150, 1, 6, '购车订单PUR202606072155169166 - 碳积分奖励', '2026-06-07 21:55:16', 'admin', 'admin'),
(16, 1, 1, NULL, -30, 120, 4, 1, '兑换充电优惠券 - 消耗碳积分', '2026-06-09 10:00:00', 'admin', 'admin');

-- 3. 更新 AUTO_INCREMENT（防止未来插入冲突）
ALTER TABLE `stad_user_profile` AUTO_INCREMENT = 4;
ALTER TABLE `stad_carbon_ledger` AUTO_INCREMENT = 17;