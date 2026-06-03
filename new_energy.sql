/*
 Navicat Premium Dump SQL

 Source Server         : 我的数据库
 Source Server Type    : MySQL
 Source Server Version : 80024 (8.0.24)
 Source Host           : localhost:3306
 Source Schema         : new_energy

 Target Server Type    : MySQL
 Target Server Version : 80024 (8.0.24)
 File Encoding         : 65001

 Date: 29/05/2026 18:20:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for stad_carbon_ledger
-- ----------------------------
DROP TABLE IF EXISTS `stad_carbon_ledger`;
CREATE TABLE `stad_carbon_ledger`  (
  `ledger_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `record_type` smallint NULL DEFAULT 0 COMMENT '0=earn获得, 1=spend消耗, 2=exchange兑换, 3=read阅读',
  `rule_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '积分规则ID（代码层配置，无外键约束）',
  `points` int NULL DEFAULT 0 COMMENT '积分变动值（+获得/-消耗）',
  `balance_after` int NULL DEFAULT 0 COMMENT '变动后余额',
  `source_type` smallint NULL DEFAULT NULL COMMENT '来源业务类型: 0=charge,1=purchase,2=read,3=checkin,4=exchange,5=admin',
  `source_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '来源业务ID（如充电订单ID、购车订单ID）',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注说明',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`ledger_id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_record_type`(`record_type` ASC) USING BTREE,
  INDEX `idx_source`(`source_type` ASC, `source_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '碳积分流水账（来源可追溯）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_carbon_statistics
-- ----------------------------
DROP TABLE IF EXISTS `stad_carbon_statistics`;
CREATE TABLE `stad_carbon_statistics`  (
  `stat_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '城市',
  `district` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区县',
  `total_charge_stations` int UNSIGNED NULL DEFAULT 0 COMMENT '运营充电站数',
  `total_charge_piles` int UNSIGNED NULL DEFAULT 0 COMMENT '运营充电桩总数',
  `total_charge_orders` int UNSIGNED NULL DEFAULT 0 COMMENT '充电订单数',
  `total_energy` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '总充电量(kWh)',
  `carbon_reduction` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '碳减排量(kg)',
  `equivalent_trees` int UNSIGNED NULL DEFAULT 0 COMMENT '等效植树量（棵）',
  `total_nev_count` int UNSIGNED NULL DEFAULT 0 COMMENT '在册新能源车数量',
  `new_nev_count` int UNSIGNED NULL DEFAULT 0 COMMENT '本月新增新能源车数量',
  `total_points_issued` int UNSIGNED NULL DEFAULT 0 COMMENT '总计发放碳积分',
  `total_points_redeemed` int UNSIGNED NULL DEFAULT 0 COMMENT '总计兑换碳积分',
  `stat_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '扩展数据',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`stat_id`) USING BTREE,
  UNIQUE INDEX `uk_date_city`(`stat_date` ASC, `city` ASC, `district` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '碳排放 充电统计表（政府大屏数据）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_charging_station
-- ----------------------------
DROP TABLE IF EXISTS `stad_charging_station`;
CREATE TABLE `stad_charging_station`  (
  `station_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '充电站ID',
  `station_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '充电站名称',
  `station_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '编码（唯一）',
  `merchant_id` bigint UNSIGNED NOT NULL COMMENT '运营商户ID',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '省份',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '城市',
  `district` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区县',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址',
  `longitude` decimal(10, 7) NOT NULL COMMENT '经度(GCJ-02)',
  `latitude` decimal(10, 7) NOT NULL COMMENT '纬度(GCJ-02)',
  `geo_hash` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'GeoHash（附近搜索加速）',
  `marker_icon_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '自定义地图标记图标URL',
  `marker_size` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'medium' COMMENT '标记大小: small, medium, large',
  `total_piles` smallint NULL DEFAULT 0 COMMENT '总桩数',
  `available_piles` smallint NULL DEFAULT 0 COMMENT '空闲桩数（实时变化）',
  `occupying_piles` smallint NULL DEFAULT 0 COMMENT '占用桩数（实时变化）',
  `open_time` time NULL DEFAULT NULL COMMENT '营业开始时间',
  `close_time` time NULL DEFAULT NULL COMMENT '营业结束时间',
  `parking_fee` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '停车费说明',
  `service_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '服务电话',
  `facilities_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配套设施说明',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '充电站图片URL，逗号分隔',
  `is_internal` smallint NULL DEFAULT 0 COMMENT '是否内部站点',
  `apply_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公网申请状态 0=待审,1=通过,2=驳回',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `business_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照URL',
  `site_proof` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '场地证明URL',
  `station_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '0=待审核 1=运营中 2=维护中 3=已停用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`station_id`) USING BTREE,
  UNIQUE INDEX `uk_station_code`(`station_code` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_geo_hash`(`geo_hash` ASC) USING BTREE,
  INDEX `idx_available_piles`(`available_piles` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电站表（地图展示 动态容量）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_charging_pile
-- ----------------------------
DROP TABLE IF EXISTS `stad_charging_pile`;
CREATE TABLE `stad_charging_pile`  (
  `pile_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '桩ID',
  `station_id` bigint UNSIGNED NOT NULL COMMENT '所属充电站ID',
  `pile_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '桩编码（站内唯一）',
  `pile_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'dc' COMMENT 'dc=直流快充, ac=交流慢充',
  `access_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'public' COMMENT 'public=公用, dedicated=专用, private=自用',
  `power_kw` decimal(6, 2) NOT NULL COMMENT '额定功率(kW)',
  `connector_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '接口类型: CCS, CHAdeMO, GB/T, Type2',
  `pile_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=空闲, 1=充电中 2=离线, 3=故障',
  `current_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '当前充电订单号',
  `current_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '当前充电用户名称（脱敏）',
  `current_start_time` datetime NULL DEFAULT NULL COMMENT '本次充电开始时间',
  `last_heartbeat` datetime NULL DEFAULT NULL COMMENT '最后心跳时间',
  `voltage` decimal(6, 2) NULL DEFAULT NULL COMMENT '当前电压(V)',
  `current_a` decimal(6, 2) NULL DEFAULT NULL COMMENT '当前电流(A)',
  `power_now` decimal(6, 2) NULL DEFAULT NULL COMMENT '当前功率(kW)',
  `energy_total` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总计电量(kWh)',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`pile_id`) USING BTREE,
  INDEX `idx_station_id`(`station_id` ASC) USING BTREE,
  INDEX `idx_pile_status`(`pile_status` ASC) USING BTREE,
  INDEX `idx_last_heartbeat`(`last_heartbeat` ASC) USING BTREE,
  CONSTRAINT `fk_charging_pile_station` FOREIGN KEY (`station_id`) REFERENCES `stad_charging_station` (`station_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电桩表（独立状态监控 实时心跳）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_charging_rate
-- ----------------------------
DROP TABLE IF EXISTS `stad_charging_rate`;
CREATE TABLE `stad_charging_rate`  (
  `rate_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '费率组ID',
  `station_id` bigint UNSIGNED NOT NULL COMMENT '所属充电站ID',
  `rate_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '费率名称',
  `pile_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'all' COMMENT '适配桩类型 dc=直流快充, ac=交流慢充, all=全部',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `effective_from` datetime NULL DEFAULT NULL COMMENT '生效时间',
  `effective_to` datetime NULL DEFAULT NULL COMMENT '失效时间',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '费率说明',
  `sort_order` int NULL DEFAULT 0 COMMENT '优先级排序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`rate_id`) USING BTREE,
  INDEX `fk_charging_rate_station`(`station_id` ASC) USING BTREE,
  CONSTRAINT `fk_charging_rate_station` FOREIGN KEY (`station_id`) REFERENCES `stad_charging_station` (`station_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电费率组表（区分快慢充）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_charging_rate_period
-- ----------------------------
DROP TABLE IF EXISTS `stad_charging_rate_period`;
CREATE TABLE `stad_charging_rate_period`  (
  `period_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '时段ID',
  `rate_id` bigint UNSIGNED NOT NULL COMMENT '所属费率组ID',
  `period_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '时段名称（如峰时/平时/谷时）',
  `start_time` time NOT NULL COMMENT '一天内开始时间',
  `end_time` time NOT NULL COMMENT '一天内结束时间',
  `energy_price` decimal(8, 4) NULL DEFAULT 0.0000 COMMENT '电价(元/kWh)',
  `service_fee` decimal(8, 4) NULL DEFAULT 0.0000 COMMENT '服务费(元/kWh)',
  `total_price` decimal(8, 4) NULL DEFAULT NULL COMMENT '合计单价(元/kWh)',
  `discount_rate` decimal(5, 2) NULL DEFAULT 100.00 COMMENT '折扣率%, 100=无折扣',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`period_id`) USING BTREE,
  INDEX `idx_time_range`(`start_time` ASC, `end_time` ASC) USING BTREE,
  INDEX `fk_charging_rate_period_rate`(`rate_id` ASC) USING BTREE,
  CONSTRAINT `fk_charging_rate_period_rate` FOREIGN KEY (`rate_id`) REFERENCES `stad_charging_rate` (`rate_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电费率时段表（峰谷平时段）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_charging_order
-- ----------------------------
DROP TABLE IF EXISTS `stad_charging_order`;
CREATE TABLE `stad_charging_order`  (
  `order_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `station_id` bigint UNSIGNED NOT NULL COMMENT '充电站ID',
  `pile_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '充电桩ID',
  `pile_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '使用桩编码',
  `rate_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '使用的费率组ID',
  `rate_period_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '使用的费率时段ID',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `duration` int NULL DEFAULT 0 COMMENT '充电时长(秒)',
  `start_soc` decimal(5, 2) NULL DEFAULT NULL COMMENT '起始SOC(%)',
  `end_soc` decimal(5, 2) NULL DEFAULT NULL COMMENT '结束SOC(%)',
  `total_energy` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '充电电量(kWh)',
  `energy_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '电费(元)',
  `service_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '服务费(元)',
  `discount_amount` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '优惠金额(元)',
  `total_amount` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '实付金额(元)',
  `rate_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '费率计算明细',
  `order_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=充电中 1=已完成 2=已取消',
  `pay_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=未支付 1=已支付',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式',
  `transaction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '交易流水号',
  `carbon_earned` int NULL DEFAULT 0 COMMENT '获得碳积分',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_station_id`(`station_id` ASC) USING BTREE,
  INDEX `idx_pile_id`(`pile_id` ASC) USING BTREE,
  INDEX `idx_rate_period_id`(`rate_period_id` ASC) USING BTREE,
  INDEX `fk_charging_order_rate`(`rate_id` ASC) USING BTREE,
  CONSTRAINT `fk_charging_order_period` FOREIGN KEY (`rate_period_id`) REFERENCES `stad_charging_rate_period` (`period_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_charging_order_pile` FOREIGN KEY (`pile_id`) REFERENCES `stad_charging_pile` (`pile_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_charging_order_rate` FOREIGN KEY (`rate_id`) REFERENCES `stad_charging_rate` (`rate_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_charging_order_station` FOREIGN KEY (`station_id`) REFERENCES `stad_charging_station` (`station_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电订单表（含费率时段记录）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_merchant
-- ----------------------------
DROP TABLE IF EXISTS `stad_merchant`;
CREATE TABLE `stad_merchant`  (
  `merchant_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '关联登录用户ID',
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商户名称',
  `merchant_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'dealer=经销商 charger=充电运营商 maintenance=维保商',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '省份',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '城市',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '地址',
  `open_time` time NULL DEFAULT NULL COMMENT '营业开始时间',
  `close_time` time NULL DEFAULT NULL COMMENT '营业结束时间',
  `business_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '营业执照URL',
  `legal_person` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '法人',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '法人身份证',
  `status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=待审核 1=已上线 2=已停用',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `total_income` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '总计收入',
  `settled_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '已结算',
  `pending_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '待结算',
  `withdrawn_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '已提现',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开户行',
  `bank_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '银行账号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`merchant_id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_type`(`merchant_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_charging_settlement
-- ----------------------------
DROP TABLE IF EXISTS `stad_charging_settlement`;
CREATE TABLE `stad_charging_settlement`  (
  `settlement_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '结算ID',
  `merchant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `settle_date` date NOT NULL COMMENT '结算日期',
  `total_orders` int NULL DEFAULT 0 COMMENT '订单数',
  `total_energy` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总电量(kWh)',
  `total_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '总金额',
  `platform_commission` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '平台佣金',
  `settle_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '结算金额',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=待结算 1=已结算',
  `settle_time` datetime NULL DEFAULT NULL COMMENT '结算时间',
  `withdraw_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提现编号',
  `withdraw_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '提现金额',
  `withdraw_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '0=待审核 1=已打款 2=已退回',
  `withdraw_time` datetime NULL DEFAULT NULL COMMENT '打款时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`settlement_id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_date`(`merchant_id` ASC, `settle_date` ASC) USING BTREE,
  CONSTRAINT `fk_charging_settlement_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `stad_merchant` (`merchant_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电结算表（含提现）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_gov_nev_registration
-- ----------------------------
DROP TABLE IF EXISTS `stad_gov_nev_registration`;
CREATE TABLE `stad_gov_nev_registration`  (
  `reg_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '注册统计ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '城市',
  `district` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区县',
  `new_registrations` int UNSIGNED NULL DEFAULT 0 COMMENT '当日新注册数',
  `total_vehicles` int UNSIGNED NULL DEFAULT 0 COMMENT '总计保有量',
  `ev_count` int UNSIGNED NULL DEFAULT 0 COMMENT '纯电动(BEV)',
  `phev_count` int UNSIGNED NULL DEFAULT 0 COMMENT '插电混动(PHEV)',
  `fcev_count` int UNSIGNED NULL DEFAULT 0 COMMENT '燃料电池(FCEV)',
  `data_source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'system' COMMENT '数据来源: system, manual',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`reg_id`) USING BTREE,
  UNIQUE INDEX `uk_date_city`(`stat_date` ASC, `city` ASC, `district` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '新能源车注册统计表（政府）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_maintenance_shop
-- ----------------------------
DROP TABLE IF EXISTS `stad_maintenance_shop`;
CREATE TABLE `stad_maintenance_shop`  (
  `shop_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '门店ID',
  `shop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门店名称',
  `merchant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '省份',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '城市',
  `district` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区县',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址',
  `longitude` decimal(10, 7) NULL DEFAULT 0.0000000 COMMENT '经度',
  `latitude` decimal(10, 7) NULL DEFAULT 0.0000000 COMMENT '纬度',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `services_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '服务项目信息',
  `rating` decimal(2, 1) NULL DEFAULT 0.0 COMMENT '评分',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `status` smallint NULL DEFAULT 0 COMMENT '0=pending,1=active,2=disabled',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_id`) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_province_city`(`province` ASC, `city` ASC) USING BTREE,
  INDEX `idx_city_district`(`city` ASC, `district` ASC) USING BTREE,
  CONSTRAINT `fk_maintenance_shop_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `stad_merchant` (`merchant_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '维保门店表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `stad_vehicle`;
CREATE TABLE `stad_vehicle`  (
  `vehicle_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '车辆ID',
  `vehicle_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'new=新车, used=二手车',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '展示标题',
  `guide_price` decimal(12, 2) NOT NULL COMMENT '指导价（卖价）',
  `original_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '新车落地价',
  `color` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外观颜色',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `merchant_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '商户ID',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆标签（逗号分隔）',
  `view_count` int UNSIGNED NULL DEFAULT 0 COMMENT '浏览量',
  `status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '0=待审核 1=在售,2=已卖,3=下架',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`vehicle_id`) USING BTREE,
  INDEX `idx_vehicle_type_status`(`vehicle_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_price`(`guide_price` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆基础信息表（含SKU字段）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_maintenance_order
-- ----------------------------
DROP TABLE IF EXISTS `stad_maintenance_order`;
CREATE TABLE `stad_maintenance_order`  (
  `order_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `shop_id` bigint UNSIGNED NOT NULL COMMENT '门店ID',
  `vehicle_id` bigint UNSIGNED NOT NULL COMMENT '车辆ID',
  `service_item` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '服务项目',
  `service_price` decimal(10, 2) NOT NULL COMMENT '服务价格',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '总金额',
  `paid_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `expect_date` date NOT NULL COMMENT '期望日期',
  `expect_time_slot` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'am/pm',
  `order_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=待确认 1=已确认 2=服务中 3=已完成 4=已取消',
  `cancel_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `rating` smallint NULL DEFAULT NULL COMMENT '评分1-5',
  `comment_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价内容',
  `pay_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=未支付 1=已支付',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE,
  INDEX `fk_maintenance_order_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_maintenance_order_shop` FOREIGN KEY (`shop_id`) REFERENCES `stad_maintenance_shop` (`shop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_maintenance_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '维保订单表（含预约）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_user_address
-- ----------------------------
DROP TABLE IF EXISTS `stad_user_address`;
CREATE TABLE `stad_user_address`  (
  `address_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '省份',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '城市',
  `district` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区县',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`address_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_unified_order
-- ----------------------------
DROP TABLE IF EXISTS `stad_unified_order`;
CREATE TABLE `stad_unified_order`  (
  `order_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `order_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'purchase, test_drive, trade_in',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `vehicle_id` bigint UNSIGNED NOT NULL COMMENT '车辆ID',
  `merchant_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '商户ID',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `address_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '收货地址ID',
  `vehicle_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '车辆价格',
  `total_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '订单总额',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '已付金额',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式',
  `insurance_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '保险信息',
  `expect_date` date NULL DEFAULT NULL COMMENT '期望日期（试驾）',
  `expect_time_slot` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'am/pm',
  `old_vehicle_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '旧车ID（以旧换新）',
  `old_valuation` decimal(12, 2) NULL DEFAULT NULL COMMENT '旧车估价',
  `new_order_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联新车订单（自引用）',
  `status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '订单状态',
  `cancel_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_vehicle_id`(`vehicle_id` ASC) USING BTREE,
  INDEX `idx_order_type_status`(`order_type` ASC, `status` ASC) USING BTREE,
  INDEX `fk_unified_order_old_vehicle`(`old_vehicle_id` ASC) USING BTREE,
  INDEX `fk_unified_order_merchant`(`merchant_id` ASC) USING BTREE,
  INDEX `fk_unified_order_address`(`address_id` ASC) USING BTREE,
  CONSTRAINT `fk_unified_order_address` FOREIGN KEY (`address_id`) REFERENCES `stad_user_address` (`address_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_unified_order_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `stad_merchant` (`merchant_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_unified_order_old_vehicle` FOREIGN KEY (`old_vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_unified_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '统一订单表（购车+试驾+以旧换新）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `stad_user_favorite`;
CREATE TABLE `stad_user_favorite`  (
  `favorite_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收藏类型: vehicle, article, station',
  `target_id` bigint UNSIGNED NOT NULL COMMENT '收藏目标ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`) USING BTREE,
  UNIQUE INDEX `uk_user_favorite`(`user_id` ASC, `target_type` ASC, `target_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_target`(`target_type` ASC, `target_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_user_feedback
-- ----------------------------
DROP TABLE IF EXISTS `stad_user_feedback`;
CREATE TABLE `stad_user_feedback`  (
  `feedback_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '反馈ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '反馈内容',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '附图URL，逗号分隔',
  `contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系方式',
  `reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '管理员回复',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=待处理 1=已回复',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`feedback_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户反馈表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_user_profile
-- ----------------------------
DROP TABLE IF EXISTS `stad_user_profile`;
CREATE TABLE `stad_user_profile`  (
  `profile_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Profile ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证号',
  `total_earned` int UNSIGNED NULL DEFAULT 0 COMMENT '总计获得碳积分',
  `total_spent` int UNSIGNED NULL DEFAULT 0 COMMENT '总计使用碳积分',
  `balance` int UNSIGNED NULL DEFAULT 0 COMMENT '当前碳积分余额',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`profile_id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户扩展表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_vehicle_finance_plan
-- ----------------------------
DROP TABLE IF EXISTS `stad_vehicle_finance_plan`;
CREATE TABLE `stad_vehicle_finance_plan`  (
  `plan_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '方案ID',
  `vehicle_id` bigint UNSIGNED NOT NULL COMMENT '车辆ID',
  `plan_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'full=全款, installment=分期',
  `plan_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '方案名称',
  `total_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '全款总价（plan_type=full时）',
  `down_payment` decimal(12, 2) NULL DEFAULT NULL COMMENT '首付金额',
  `monthly_payment` decimal(10, 2) NULL DEFAULT NULL COMMENT '月供金额',
  `months` smallint NULL DEFAULT NULL COMMENT '分期期数',
  `interest_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '年利率(%)',
  `total_interest` decimal(10, 2) NULL DEFAULT NULL COMMENT '总利息',
  `total_payable` decimal(12, 2) NULL DEFAULT NULL COMMENT '应还总额',
  `provider` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '金融机构名称',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`plan_id`) USING BTREE,
  INDEX `idx_vehicle_id`(`vehicle_id` ASC) USING BTREE,
  INDEX `idx_plan_type`(`plan_type` ASC) USING BTREE,
  CONSTRAINT `fk_finance_plan_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '金融方案表（全款+分期）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_vehicle_review
-- ----------------------------
DROP TABLE IF EXISTS `stad_vehicle_review`;
CREATE TABLE `stad_vehicle_review`  (
  `review_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `vehicle_id` bigint UNSIGNED NOT NULL COMMENT '车辆ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `order_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联订单ID',
  `rating` tinyint NOT NULL COMMENT '评分1-5',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价内容',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评价图片URL（可空）',
  `is_anonymous` tinyint(1) NULL DEFAULT 0 COMMENT '是否匿名',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0=正常,1=隐藏',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`review_id`) USING BTREE,
  INDEX `fk_vehicle_review_vehicle`(`vehicle_id` ASC) USING BTREE,
  INDEX `fk_vehicle_review_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_vehicle_review_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆评价表（单图）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_vehicle_spec
-- ----------------------------
DROP TABLE IF EXISTS `stad_vehicle_spec`;
CREATE TABLE `stad_vehicle_spec`  (
  `spec_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `vehicle_id` bigint UNSIGNED NOT NULL COMMENT '车辆ID',
  `range_km` smallint NULL DEFAULT NULL COMMENT '续航(km)',
  `battery_capacity` decimal(5, 1) NULL DEFAULT NULL COMMENT '电池容量(kWh)',
  `charge_time_fast` decimal(4, 1) NULL DEFAULT NULL COMMENT '快充时间(h)',
  `charge_time_slow` decimal(4, 1) NULL DEFAULT NULL COMMENT '慢充时间(h)',
  `model_year` smallint NULL DEFAULT NULL COMMENT '年款',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`spec_id`) USING BTREE,
  INDEX `fk_vehicle_spec_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_vehicle_spec_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆配置参数表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for stad_vehicle_used
-- ----------------------------
DROP TABLE IF EXISTS `stad_vehicle_used`;
CREATE TABLE `stad_vehicle_used`  (
  `used_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '二手车ID',
  `vehicle_id` bigint UNSIGNED NOT NULL COMMENT '车辆ID',
  `license_year` smallint NULL DEFAULT NULL COMMENT '上牌年份',
  `license_month` tinyint NULL DEFAULT NULL COMMENT '上牌月份',
  `license_city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上牌城市',
  `mileage` decimal(8, 1) NULL DEFAULT NULL COMMENT '表显里程(万公里)',
  `transfer_count` tinyint NULL DEFAULT 0 COMMENT '过户次数',
  `battery_soh` decimal(5, 2) NULL DEFAULT NULL COMMENT '电池健康状态SOH(%)',
  `battery_cycles` int UNSIGNED NULL DEFAULT NULL COMMENT '循环次数',
  `battery_diagnosis` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评级: excellent/good/fair/poor',
  `battery_report` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '电池报告',
  `valuation_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '估价价格',
  `valuation_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '估价详情',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`used_id`) USING BTREE,
  INDEX `fk_vehicle_used_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_vehicle_used_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '二手车信息表（含电池+估价）' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;