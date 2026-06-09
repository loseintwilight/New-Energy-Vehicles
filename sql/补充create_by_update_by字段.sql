-- ============================================================
-- 补充 create_by / update_by 字段
-- 解决 PC 端若依代码生成器修改数据时报错（字段不存在）
-- 所有表的创建人/修改人默认设为超级管理员 'admin'
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 碳积分流水账
ALTER TABLE `stad_carbon_ledger`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 2. 碳排放充电统计表
ALTER TABLE `stad_carbon_statistics`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 3. 充电站表
ALTER TABLE `stad_charging_station`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 4. 充电桩表
ALTER TABLE `stad_charging_pile`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 5. 充电费率组表
ALTER TABLE `stad_charging_rate`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 6. 充电费率时段表
ALTER TABLE `stad_charging_rate_period`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 7. 充电订单表
ALTER TABLE `stad_charging_order`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 8. 商户表
ALTER TABLE `stad_merchant`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 9. 充电结算表
ALTER TABLE `stad_charging_settlement`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 10. 政府新能注册统计表
ALTER TABLE `stad_gov_nev_registration`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 11. 维保门店表
ALTER TABLE `stad_maintenance_shop`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 12. 车辆信息表
ALTER TABLE `stad_vehicle`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 13. 维保订单表（核心表）
ALTER TABLE `stad_maintenance_order`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 14. 收货地址表
ALTER TABLE `stad_user_address`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 15. 统一订单表
ALTER TABLE `stad_unified_order`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 16. 用户收藏表
ALTER TABLE `stad_user_favorite`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 17. 用户反馈表
ALTER TABLE `stad_user_feedback`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 18. 用户扩展表
ALTER TABLE `stad_user_profile`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `balance`,
    ADD COLUMN `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间' AFTER `create_by`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_time`;

-- 19. 车辆金融方案表
ALTER TABLE `stad_vehicle_finance_plan`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `update_time`;

-- 20. 车辆评价表
ALTER TABLE `stad_vehicle_review`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 21. 车辆规格表
ALTER TABLE `stad_vehicle_spec`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- 22. 二手车表
ALTER TABLE `stad_vehicle_used`
    ADD COLUMN `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者' AFTER `create_time`,
    ADD COLUMN `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者' AFTER `create_by`;

-- ============================================================
-- 更新现有数据：所有记录的 create_by / update_by 设为 'admin'
-- ============================================================
UPDATE `stad_carbon_ledger`          SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_carbon_statistics`      SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_charging_station`       SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_charging_pile`          SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_charging_rate`          SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_charging_rate_period`   SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_charging_order`         SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_merchant`               SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_charging_settlement`    SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_gov_nev_registration`   SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_maintenance_shop`       SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_vehicle`                SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_maintenance_order`      SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_user_address`           SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_unified_order`          SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_user_favorite`          SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_user_feedback`          SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_user_profile`           SET `create_by` = 'admin', `create_time` = NOW(), `update_by` = 'admin' WHERE `create_by` IS NULL OR `create_by` = '';
UPDATE `stad_vehicle_finance_plan`   SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_vehicle_review`         SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_vehicle_spec`           SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';
UPDATE `stad_vehicle_used`           SET `create_by` = 'admin', `update_by` = 'admin' WHERE `create_by` = '';

SET FOREIGN_KEY_CHECKS = 1;
