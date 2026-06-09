/*
 Navicat Premium Data Transfer

 Source Server         : 我的数据库
 Source Server Type    : MySQL
 Source Server Version : 80024 (8.0.24)
 Source Host           : localhost:3306
 Source Schema         : new_energy

 Target Server Type    : MySQL
 Target Server Version : 80024 (8.0.24)
 File Encoding         : 65001

 Date: 09/06/2026 22:20:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (1, 'stad_carbon_ledger', '碳积分流水账（来源可追溯）', NULL, NULL, 'StadCarbonLedger', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'ledger', '碳积分流水账（来源可追溯）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (2, 'stad_carbon_statistics', '碳排放 充电统计表（政府大屏数据）', NULL, NULL, 'StadCarbonStatistics', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'statistics', '碳排放 充电统计（政府大屏数据）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (3, 'stad_charging_order', '充电订单表（含费率时段记录）', NULL, NULL, 'StadChargingOrder', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'order', '充电订单（含费率时段记录）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (4, 'stad_charging_pile', '充电桩表（独立状态监控 实时心跳）', NULL, NULL, 'StadChargingPile', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'pile', '充电桩（独立状态监控 实时心跳）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (5, 'stad_charging_rate', '充电费率组表（区分快慢充）', NULL, NULL, 'StadChargingRate', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'rate', '充电费率组（区分快慢充）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (6, 'stad_charging_rate_period', '充电费率时段表（峰谷平时段）', NULL, NULL, 'StadChargingRatePeriod', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'period', '充电费率时段（峰谷平时段）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (7, 'stad_charging_settlement', '充电结算表（含提现）', NULL, NULL, 'StadChargingSettlement', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'settlement', '充电结算（含提现）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (8, 'stad_charging_station', '充电站表（地图展示 动态容量）', NULL, NULL, 'StadChargingStation', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'station', '充电站（地图展示 动态容量）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (9, 'stad_gov_nev_registration', '新能源车注册统计表（政府）', NULL, NULL, 'StadGovNevRegistration', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'registration', '新能源车注册统计（政府）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (10, 'stad_maintenance_order', '维保订单表（含预约）', NULL, NULL, 'StadMaintenanceOrder', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'order', '维保订单（含预约）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (11, 'stad_maintenance_shop', '维保门店表', NULL, NULL, 'StadMaintenanceShop', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'shop', '维保门店', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (12, 'stad_merchant', '商户表', NULL, NULL, 'StadMerchant', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'merchant', '商户', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (13, 'stad_unified_order', '统一订单表（购车+试驾+以旧换新）', NULL, NULL, 'StadUnifiedOrder', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'order', '统一订单（购车+试驾+以旧换新）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (14, 'stad_user_address', '收货地址表', NULL, NULL, 'StadUserAddress', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'address', '收货地址', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (15, 'stad_user_favorite', '用户收藏表', NULL, NULL, 'StadUserFavorite', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'favorite', '用户收藏', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (16, 'stad_user_feedback', '用户反馈表', NULL, NULL, 'StadUserFeedback', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'feedback', '用户反馈', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (17, 'stad_user_profile', '用户扩展表', NULL, NULL, 'StadUserProfile', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'profile', '用户扩展', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (18, 'stad_vehicle', '车辆基础信息表（含SKU字段）', NULL, NULL, 'StadVehicle', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'vehicle', '车辆基础信息（含SKU字段）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (19, 'stad_vehicle_finance_plan', '金融方案表（全款+分期）', NULL, NULL, 'StadVehicleFinancePlan', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'plan', '金融方案（全款+分期）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:18', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (20, 'stad_vehicle_review', '车辆评价表（单图）', NULL, NULL, 'StadVehicleReview', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'review', '车辆评价（单图）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:18', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (21, 'stad_vehicle_spec', '车辆配置参数表', NULL, NULL, 'StadVehicleSpec', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'spec', '车辆配置参数', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:18', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (22, 'stad_vehicle_used', '二手车信息表（含电池+估价）', NULL, NULL, 'StadVehicleUsed', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'used', '二手车信息（含电池+估价）', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:18', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (23, 'sys_user', '用户信息表', NULL, NULL, 'SysUser', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'user', '用户信息', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-06-06 20:59:18', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 352 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1, 1, 'ledger_id', '明细ID', 'bigint unsigned', 'String', 'ledgerId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (2, 1, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (3, 1, 'record_type', '0=earn获得, 1=spend消耗, 2=exchange兑换, 3=read阅读', 'smallint', 'Long', 'recordType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (4, 1, 'rule_id', '积分规则ID（代码层配置，无外键约束）', 'bigint unsigned', 'String', 'ruleId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5, 1, 'points', '积分变动值（+获得/-消耗）', 'int', 'Long', 'points', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (6, 1, 'balance_after', '变动后余额', 'int', 'Long', 'balanceAfter', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (7, 1, 'source_type', '来源业务类型: 0=charge,1=purchase,2=read,3=checkin,4=exchange,5=admin', 'smallint', 'Long', 'sourceType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (8, 1, 'source_id', '来源业务ID（如充电订单ID、购车订单ID）', 'bigint unsigned', 'String', 'sourceId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (9, 1, 'remark', '备注说明', 'varchar(200)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (10, 1, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (11, 2, 'stat_id', '统计ID', 'bigint unsigned', 'String', 'statId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (12, 2, 'stat_date', '统计日期', 'date', 'Date', 'statDate', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (13, 2, 'city', '城市', 'varchar(20)', 'String', 'city', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (14, 2, 'district', '区县', 'varchar(20)', 'String', 'district', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (15, 2, 'total_charge_stations', '运营充电站数', 'int unsigned', 'String', 'totalChargeStations', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (16, 2, 'total_charge_piles', '运营充电桩总数', 'int unsigned', 'String', 'totalChargePiles', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (17, 2, 'total_charge_orders', '充电订单数', 'int unsigned', 'String', 'totalChargeOrders', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (18, 2, 'total_energy', '总充电量(kWh)', 'decimal(14,2)', 'BigDecimal', 'totalEnergy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (19, 2, 'carbon_reduction', '碳减排量(kg)', 'decimal(14,2)', 'BigDecimal', 'carbonReduction', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (20, 2, 'equivalent_trees', '等效植树量（棵）', 'int unsigned', 'String', 'equivalentTrees', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (21, 2, 'total_nev_count', '在册新能源车数量', 'int unsigned', 'String', 'totalNevCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (22, 2, 'new_nev_count', '本月新增新能源车数量', 'int unsigned', 'String', 'newNevCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (23, 2, 'total_points_issued', '总计发放碳积分', 'int unsigned', 'String', 'totalPointsIssued', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (24, 2, 'total_points_redeemed', '总计兑换碳积分', 'int unsigned', 'String', 'totalPointsRedeemed', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (25, 2, 'stat_data', '扩展数据', 'text', 'String', 'statData', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (26, 2, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (27, 3, 'order_id', '订单ID', 'bigint unsigned', 'String', 'orderId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (28, 3, 'order_no', '订单编号', 'varchar(32)', 'String', 'orderNo', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (29, 3, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (30, 3, 'station_id', '充电站ID', 'bigint unsigned', 'String', 'stationId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (31, 3, 'pile_id', '充电桩ID', 'bigint unsigned', 'String', 'pileId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (32, 3, 'pile_code', '使用桩编码', 'varchar(50)', 'String', 'pileCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (33, 3, 'rate_id', '使用的费率组ID', 'bigint unsigned', 'String', 'rateId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (34, 3, 'rate_period_id', '使用的费率时段ID', 'bigint unsigned', 'String', 'ratePeriodId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (35, 3, 'start_time', '开始时间', 'datetime', 'Date', 'startTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (36, 3, 'end_time', '结束时间', 'datetime', 'Date', 'endTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (37, 3, 'duration', '充电时长(秒)', 'int', 'Long', 'duration', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (38, 3, 'start_soc', '起始SOC(%)', 'decimal(5,2)', 'BigDecimal', 'startSoc', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (39, 3, 'end_soc', '结束SOC(%)', 'decimal(5,2)', 'BigDecimal', 'endSoc', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (40, 3, 'total_energy', '充电电量(kWh)', 'decimal(8,2)', 'BigDecimal', 'totalEnergy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (41, 3, 'energy_price', '电费(元)', 'decimal(8,2)', 'BigDecimal', 'energyPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (42, 3, 'service_price', '服务费(元)', 'decimal(8,2)', 'BigDecimal', 'servicePrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (43, 3, 'discount_amount', '优惠金额(元)', 'decimal(8,2)', 'BigDecimal', 'discountAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (44, 3, 'total_amount', '实付金额(元)', 'decimal(8,2)', 'BigDecimal', 'totalAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (45, 3, 'rate_detail', '费率计算明细', 'text', 'String', 'rateDetail', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 19, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (46, 3, 'order_status', '0=充电中 1=已完成 2=已取消', 'varchar(2)', 'String', 'orderStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 20, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (47, 3, 'pay_status', '0=未支付 1=已支付', 'char(1)', 'String', 'payStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 21, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (48, 3, 'payment_method', '支付方式', 'varchar(20)', 'String', 'paymentMethod', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (49, 3, 'transaction_id', '交易流水号', 'varchar(64)', 'String', 'transactionId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (50, 3, 'carbon_earned', '获得碳积分', 'int', 'Long', 'carbonEarned', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (51, 3, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 25, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (52, 3, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 26, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (53, 4, 'pile_id', '桩ID', 'bigint unsigned', 'String', 'pileId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (54, 4, 'station_id', '所属充电站ID', 'bigint unsigned', 'String', 'stationId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (55, 4, 'pile_code', '桩编码（站内唯一）', 'varchar(50)', 'String', 'pileCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (56, 4, 'pile_type', 'dc=直流快充, ac=交流慢充', 'varchar(20)', 'String', 'pileType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (57, 4, 'access_type', 'public=公用, dedicated=专用, private=自用', 'varchar(10)', 'String', 'accessType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (58, 4, 'power_kw', '额定功率(kW)', 'decimal(6,2)', 'BigDecimal', 'powerKw', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (59, 4, 'connector_type', '接口类型: CCS, CHAdeMO, GB/T, Type2', 'varchar(30)', 'String', 'connectorType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (60, 4, 'pile_status', '0=空闲, 1=充电中 2=离线, 3=故障', 'varchar(2)', 'String', 'pileStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (61, 4, 'current_order_no', '当前充电订单号', 'varchar(32)', 'String', 'currentOrderNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (62, 4, 'current_user_name', '当前充电用户名称（脱敏）', 'varchar(50)', 'String', 'currentUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (63, 4, 'current_start_time', '本次充电开始时间', 'datetime', 'Date', 'currentStartTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (64, 4, 'last_heartbeat', '最后心跳时间', 'datetime', 'Date', 'lastHeartbeat', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (65, 4, 'voltage', '当前电压(V)', 'decimal(6,2)', 'BigDecimal', 'voltage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (66, 4, 'current_a', '当前电流(A)', 'decimal(6,2)', 'BigDecimal', 'currentA', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (67, 4, 'power_now', '当前功率(kW)', 'decimal(6,2)', 'BigDecimal', 'powerNow', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (68, 4, 'energy_total', '总计电量(kWh)', 'decimal(10,2)', 'BigDecimal', 'energyTotal', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (69, 4, 'sort_order', '排序号', 'int', 'Long', 'sortOrder', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (70, 4, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (71, 4, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (72, 5, 'rate_id', '费率组ID', 'bigint unsigned', 'String', 'rateId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (73, 5, 'station_id', '所属充电站ID', 'bigint unsigned', 'String', 'stationId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (74, 5, 'rate_name', '费率名称', 'varchar(50)', 'String', 'rateName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (75, 5, 'pile_type', '适配桩类型 dc=直流快充, ac=交流慢充, all=全部', 'varchar(10)', 'String', 'pileType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (76, 5, 'is_active', '是否启用', 'tinyint(1)', 'Integer', 'isActive', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (77, 5, 'effective_from', '生效时间', 'datetime', 'Date', 'effectiveFrom', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (78, 5, 'effective_to', '失效时间', 'datetime', 'Date', 'effectiveTo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (79, 5, 'description', '费率说明', 'varchar(500)', 'String', 'description', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (80, 5, 'sort_order', '优先级排序', 'int', 'Long', 'sortOrder', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (81, 5, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (82, 5, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (83, 6, 'period_id', '时段ID', 'bigint unsigned', 'String', 'periodId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (84, 6, 'rate_id', '所属费率组ID', 'bigint unsigned', 'String', 'rateId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (85, 6, 'period_name', '时段名称（如峰时/平时/谷时）', 'varchar(30)', 'String', 'periodName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (86, 6, 'start_time', '一天内开始时间', 'time', 'Date', 'startTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (87, 6, 'end_time', '一天内结束时间', 'time', 'Date', 'endTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (88, 6, 'energy_price', '电价(元/kWh)', 'decimal(8,4)', 'BigDecimal', 'energyPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (89, 6, 'service_fee', '服务费(元/kWh)', 'decimal(8,4)', 'BigDecimal', 'serviceFee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (90, 6, 'total_price', '合计单价(元/kWh)', 'decimal(8,4)', 'BigDecimal', 'totalPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (91, 6, 'discount_rate', '折扣率%, 100=无折扣', 'decimal(5,2)', 'BigDecimal', 'discountRate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (92, 6, 'sort_order', '排序号', 'int', 'Long', 'sortOrder', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (93, 6, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (94, 7, 'settlement_id', '结算ID', 'bigint unsigned', 'String', 'settlementId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (95, 7, 'merchant_id', '商户ID', 'bigint unsigned', 'String', 'merchantId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (96, 7, 'settle_date', '结算日期', 'date', 'Date', 'settleDate', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (97, 7, 'total_orders', '订单数', 'int', 'Long', 'totalOrders', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (98, 7, 'total_energy', '总电量(kWh)', 'decimal(10,2)', 'BigDecimal', 'totalEnergy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (99, 7, 'total_amount', '总金额', 'decimal(12,2)', 'BigDecimal', 'totalAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (100, 7, 'platform_commission', '平台佣金', 'decimal(12,2)', 'BigDecimal', 'platformCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (101, 7, 'settle_amount', '结算金额', 'decimal(12,2)', 'BigDecimal', 'settleAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (102, 7, 'status', '0=待结算 1=已结算', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (103, 7, 'settle_time', '结算时间', 'datetime', 'Date', 'settleTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (104, 7, 'withdraw_no', '提现编号', 'varchar(32)', 'String', 'withdrawNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (105, 7, 'withdraw_amount', '提现金额', 'decimal(12,2)', 'BigDecimal', 'withdrawAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (106, 7, 'withdraw_status', '0=待审核 1=已打款 2=已退回', 'varchar(2)', 'String', 'withdrawStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (107, 7, 'withdraw_time', '打款时间', 'datetime', 'Date', 'withdrawTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (108, 7, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (109, 8, 'station_id', '充电站ID', 'bigint unsigned', 'String', 'stationId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (110, 8, 'station_name', '充电站名称', 'varchar(100)', 'String', 'stationName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (111, 8, 'station_code', '编码（唯一）', 'varchar(50)', 'String', 'stationCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (112, 8, 'merchant_id', '运营商户ID', 'bigint unsigned', 'String', 'merchantId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (113, 8, 'province', '省份', 'varchar(20)', 'String', 'province', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (114, 8, 'city', '城市', 'varchar(20)', 'String', 'city', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (115, 8, 'district', '区县', 'varchar(20)', 'String', 'district', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (116, 8, 'address', '详细地址', 'varchar(255)', 'String', 'address', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (117, 8, 'longitude', '经度(GCJ-02)', 'decimal(10,7)', 'BigDecimal', 'longitude', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (118, 8, 'latitude', '纬度(GCJ-02)', 'decimal(10,7)', 'BigDecimal', 'latitude', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (119, 8, 'geo_hash', 'GeoHash（附近搜索加速）', 'varchar(20)', 'String', 'geoHash', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (120, 8, 'marker_icon_url', '自定义地图标记图标URL', 'varchar(255)', 'String', 'markerIconUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (121, 8, 'marker_size', '标记大小: small, medium, large', 'varchar(10)', 'String', 'markerSize', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (122, 8, 'total_piles', '总桩数', 'smallint', 'Long', 'totalPiles', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (123, 8, 'available_piles', '空闲桩数（实时变化）', 'smallint', 'Long', 'availablePiles', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (124, 8, 'occupying_piles', '占用桩数（实时变化）', 'smallint', 'Long', 'occupyingPiles', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (125, 8, 'open_time', '营业开始时间', 'time', 'Date', 'openTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 17, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (126, 8, 'close_time', '营业结束时间', 'time', 'Date', 'closeTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 18, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (127, 8, 'parking_fee', '停车费说明', 'varchar(100)', 'String', 'parkingFee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (128, 8, 'service_phone', '服务电话', 'varchar(20)', 'String', 'servicePhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (129, 8, 'facilities_info', '配套设施说明', 'text', 'String', 'facilitiesInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 21, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (130, 8, 'images', '充电站图片URL，逗号分隔', 'text', 'String', 'images', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 22, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (131, 8, 'is_internal', '是否内部站点', 'smallint', 'Long', 'isInternal', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (132, 8, 'apply_status', '公网申请状态 0=待审,1=通过,2=驳回', 'varchar(2)', 'String', 'applyStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 24, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (133, 8, 'audit_remark', '审核备注', 'varchar(500)', 'String', 'auditRemark', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 25, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (134, 8, 'audit_time', '审核时间', 'datetime', 'Date', 'auditTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 26, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (135, 8, 'business_license', '营业执照URL', 'varchar(255)', 'String', 'businessLicense', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (136, 8, 'site_proof', '场地证明URL', 'varchar(255)', 'String', 'siteProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (137, 8, 'station_status', '0=待审核 1=运营中 2=维护中 3=已停用', 'varchar(2)', 'String', 'stationStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 29, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (138, 8, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 30, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (139, 8, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 31, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (140, 9, 'reg_id', '注册统计ID', 'bigint unsigned', 'String', 'regId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (141, 9, 'stat_date', '统计日期', 'date', 'Date', 'statDate', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (142, 9, 'city', '城市', 'varchar(20)', 'String', 'city', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (143, 9, 'district', '区县', 'varchar(20)', 'String', 'district', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (144, 9, 'new_registrations', '当日新注册数', 'int unsigned', 'String', 'newRegistrations', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (145, 9, 'total_vehicles', '总计保有量', 'int unsigned', 'String', 'totalVehicles', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (146, 9, 'ev_count', '纯电动(BEV)', 'int unsigned', 'String', 'evCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (147, 9, 'phev_count', '插电混动(PHEV)', 'int unsigned', 'String', 'phevCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (148, 9, 'fcev_count', '燃料电池(FCEV)', 'int unsigned', 'String', 'fcevCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (149, 9, 'data_source', '数据来源: system, manual', 'varchar(50)', 'String', 'dataSource', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (150, 9, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (151, 10, 'order_id', '订单ID', 'bigint unsigned', 'String', 'orderId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (152, 10, 'order_no', '订单编号', 'varchar(32)', 'String', 'orderNo', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (153, 10, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (154, 10, 'shop_id', '门店ID', 'bigint unsigned', 'String', 'shopId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (155, 10, 'vehicle_id', '车辆ID', 'bigint unsigned', 'String', 'vehicleId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (156, 10, 'service_item', '服务项目', 'varchar(200)', 'String', 'serviceItem', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (157, 10, 'service_price', '服务价格', 'decimal(10,2)', 'BigDecimal', 'servicePrice', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (158, 10, 'total_amount', '总金额', 'decimal(10,2)', 'BigDecimal', 'totalAmount', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (159, 10, 'paid_amount', '实付金额', 'decimal(10,2)', 'BigDecimal', 'paidAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (160, 10, 'expect_date', '期望日期', 'date', 'Date', 'expectDate', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (161, 10, 'expect_time_slot', 'am/pm', 'varchar(10)', 'String', 'expectTimeSlot', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (162, 10, 'order_status', '0=待确认 1=已确认 2=服务中 3=已完成 4=已取消', 'varchar(2)', 'String', 'orderStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (163, 10, 'cancel_reason', '取消原因', 'varchar(500)', 'String', 'cancelReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (164, 10, 'finish_time', '完成时间', 'datetime', 'Date', 'finishTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (165, 10, 'rating', '评分1-5', 'smallint', 'Long', 'rating', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (166, 10, 'comment_content', '评价内容', 'text', 'String', 'commentContent', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (167, 10, 'pay_status', '0=未支付 1=已支付', 'char(1)', 'String', 'payStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 17, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (168, 10, 'payment_method', '支付方式', 'varchar(20)', 'String', 'paymentMethod', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (169, 10, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (170, 10, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 20, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (171, 11, 'shop_id', '门店ID', 'bigint unsigned', 'String', 'shopId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (172, 11, 'shop_name', '门店名称', 'varchar(100)', 'String', 'shopName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (173, 11, 'merchant_id', '商户ID', 'bigint unsigned', 'String', 'merchantId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (174, 11, 'province', '省份', 'varchar(20)', 'String', 'province', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (175, 11, 'city', '城市', 'varchar(20)', 'String', 'city', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (176, 11, 'district', '区县', 'varchar(20)', 'String', 'district', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (177, 11, 'address', '详细地址', 'varchar(255)', 'String', 'address', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (178, 11, 'longitude', '经度', 'decimal(10,7)', 'BigDecimal', 'longitude', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (179, 11, 'latitude', '纬度', 'decimal(10,7)', 'BigDecimal', 'latitude', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (180, 11, 'contact_name', '联系人', 'varchar(30)', 'String', 'contactName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (181, 11, 'contact_phone', '联系电话', 'varchar(11)', 'String', 'contactPhone', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (182, 11, 'services_info', '服务项目信息', 'text', 'String', 'servicesInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (183, 11, 'rating', '评分', 'decimal(2,1)', 'BigDecimal', 'rating', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (184, 11, 'description', '描述', 'varchar(1000)', 'String', 'description', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (185, 11, 'status', '0=pending,1=active,2=disabled', 'smallint', 'Long', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (186, 11, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (187, 11, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (188, 12, 'merchant_id', '商户ID', 'bigint unsigned', 'String', 'merchantId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (189, 12, 'user_id', '关联登录用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (190, 12, 'merchant_name', '商户名称', 'varchar(100)', 'String', 'merchantName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (191, 12, 'merchant_type', 'dealer=经销商 charger=充电运营商 maintenance=维保商', 'varchar(20)', 'String', 'merchantType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (192, 12, 'contact_name', '联系人', 'varchar(30)', 'String', 'contactName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (193, 12, 'contact_phone', '联系电话', 'varchar(11)', 'String', 'contactPhone', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (194, 12, 'province', '省份', 'varchar(20)', 'String', 'province', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (195, 12, 'city', '城市', 'varchar(20)', 'String', 'city', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (196, 12, 'address', '地址', 'varchar(255)', 'String', 'address', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (197, 12, 'open_time', '营业开始时间', 'time', 'Date', 'openTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (198, 12, 'close_time', '营业结束时间', 'time', 'Date', 'closeTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (199, 12, 'business_license', '营业执照URL', 'varchar(255)', 'String', 'businessLicense', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (200, 12, 'legal_person', '法人', 'varchar(30)', 'String', 'legalPerson', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (201, 12, 'id_card', '法人身份证', 'varchar(18)', 'String', 'idCard', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (202, 12, 'status', '0=待审核 1=已上线 2=已停用', 'varchar(2)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (203, 12, 'audit_remark', '审核备注', 'varchar(500)', 'String', 'auditRemark', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (204, 12, 'audit_time', '审核时间', 'datetime', 'Date', 'auditTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 17, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (205, 12, 'total_income', '总计收入', 'decimal(12,2)', 'BigDecimal', 'totalIncome', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (206, 12, 'settled_amount', '已结算', 'decimal(12,2)', 'BigDecimal', 'settledAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (207, 12, 'pending_amount', '待结算', 'decimal(12,2)', 'BigDecimal', 'pendingAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (208, 12, 'withdrawn_amount', '已提现', 'decimal(12,2)', 'BigDecimal', 'withdrawnAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (209, 12, 'bank_name', '开户行', 'varchar(100)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (210, 12, 'bank_account', '银行账号', 'varchar(50)', 'String', 'bankAccount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (211, 12, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 24, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (212, 12, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 25, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (213, 13, 'order_id', '订单ID', 'bigint unsigned', 'String', 'orderId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (214, 13, 'order_no', '订单编号', 'varchar(32)', 'String', 'orderNo', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (215, 13, 'order_type', 'purchase, test_drive, trade_in', 'varchar(20)', 'String', 'orderType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (216, 13, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (217, 13, 'vehicle_id', '车辆ID', 'bigint unsigned', 'String', 'vehicleId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (218, 13, 'merchant_id', '商户ID', 'bigint unsigned', 'String', 'merchantId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (219, 13, 'contact_name', '联系人', 'varchar(30)', 'String', 'contactName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (220, 13, 'contact_phone', '联系电话', 'varchar(11)', 'String', 'contactPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (221, 13, 'address_id', '收货地址ID', 'bigint unsigned', 'String', 'addressId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (222, 13, 'vehicle_price', '车辆价格', 'decimal(12,2)', 'BigDecimal', 'vehiclePrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (223, 13, 'total_amount', '订单总额', 'decimal(12,2)', 'BigDecimal', 'totalAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (224, 13, 'paid_amount', '已付金额', 'decimal(12,2)', 'BigDecimal', 'paidAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (225, 13, 'payment_method', '支付方式', 'varchar(20)', 'String', 'paymentMethod', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (226, 13, 'insurance_info', '保险信息', 'text', 'String', 'insuranceInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 14, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (227, 13, 'expect_date', '期望日期（试驾）', 'date', 'Date', 'expectDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 15, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (228, 13, 'expect_time_slot', 'am/pm', 'varchar(10)', 'String', 'expectTimeSlot', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (229, 13, 'old_vehicle_id', '旧车ID（以旧换新）', 'bigint unsigned', 'String', 'oldVehicleId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 17, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (230, 13, 'old_valuation', '旧车估价', 'decimal(12,2)', 'BigDecimal', 'oldValuation', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (231, 13, 'new_order_id', '关联新车订单（自引用）', 'bigint unsigned', 'String', 'newOrderId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 19, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (232, 13, 'status', '订单状态', 'varchar(2)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 20, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (233, 13, 'cancel_reason', '取消原因', 'varchar(500)', 'String', 'cancelReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 21, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (234, 13, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (235, 13, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 23, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (236, 14, 'address_id', '地址ID', 'bigint unsigned', 'String', 'addressId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (237, 14, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (238, 14, 'contact_name', '联系人', 'varchar(30)', 'String', 'contactName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (239, 14, 'contact_phone', '联系电话', 'varchar(11)', 'String', 'contactPhone', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (240, 14, 'province', '省份', 'varchar(20)', 'String', 'province', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (241, 14, 'city', '城市', 'varchar(20)', 'String', 'city', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (242, 14, 'district', '区县', 'varchar(20)', 'String', 'district', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (243, 14, 'detail', '详细地址', 'varchar(255)', 'String', 'detail', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (244, 14, 'is_default', '是否默认', 'tinyint(1)', 'Integer', 'isDefault', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (245, 14, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (246, 14, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (247, 15, 'favorite_id', '收藏ID', 'bigint unsigned', 'String', 'favoriteId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (248, 15, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (249, 15, 'target_type', '收藏类型: vehicle, article, station', 'varchar(20)', 'String', 'targetType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (250, 15, 'target_id', '收藏目标ID', 'bigint unsigned', 'String', 'targetId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (251, 15, 'create_time', '收藏时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (252, 16, 'feedback_id', '反馈ID', 'bigint unsigned', 'String', 'feedbackId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (253, 16, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (254, 16, 'content', '反馈内容', 'text', 'String', 'content', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'editor', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (255, 16, 'images', '附图URL，逗号分隔', 'text', 'String', 'images', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (256, 16, 'contact', '联系方式', 'varchar(50)', 'String', 'contact', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (257, 16, 'reply', '管理员回复', 'text', 'String', 'reply', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (258, 16, 'reply_time', '回复时间', 'datetime', 'Date', 'replyTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (259, 16, 'status', '0=待处理 1=已回复', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 8, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (260, 16, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (261, 17, 'profile_id', 'Profile ID', 'bigint unsigned', 'String', 'profileId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (262, 17, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (263, 17, 'id_card', '身份证号', 'varchar(18)', 'String', 'idCard', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (264, 17, 'total_earned', '总计获得碳积分', 'int unsigned', 'String', 'totalEarned', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (265, 17, 'total_spent', '总计使用碳积分', 'int unsigned', 'String', 'totalSpent', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (266, 17, 'balance', '当前碳积分余额', 'int unsigned', 'String', 'balance', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (267, 17, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (268, 18, 'vehicle_id', '车辆ID', 'bigint unsigned', 'String', 'vehicleId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (269, 18, 'vehicle_type', 'new=新车, used=二手车', 'varchar(10)', 'String', 'vehicleType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 2, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (270, 18, 'model_name', '车型名称', 'varchar(100)', 'String', 'modelName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2026-06-06 20:59:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (271, 18, 'title', '展示标题', 'varchar(200)', 'String', 'title', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (272, 18, 'guide_price', '指导价（卖价）', 'decimal(12,2)', 'BigDecimal', 'guidePrice', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (273, 18, 'original_price', '新车落地价', 'decimal(12,2)', 'BigDecimal', 'originalPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (274, 18, 'color', '外观颜色', 'varchar(30)', 'String', 'color', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (275, 18, 'stock', '库存数量', 'int', 'Long', 'stock', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (276, 18, 'merchant_id', '商户ID', 'bigint unsigned', 'String', 'merchantId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (277, 18, 'description', '描述', 'text', 'String', 'description', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 10, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (278, 18, 'tags', '车辆标签（逗号分隔）', 'varchar(500)', 'String', 'tags', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 11, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (279, 18, 'view_count', '浏览量', 'int unsigned', 'String', 'viewCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 12, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (280, 18, 'status', '0=待审核 1=在售,2=已卖,3=下架', 'varchar(2)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 13, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (281, 18, 'publish_time', '发布时间', 'datetime', 'Date', 'publishTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 14, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (282, 18, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (283, 18, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (284, 19, 'plan_id', '方案ID', 'bigint unsigned', 'String', 'planId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (285, 19, 'vehicle_id', '车辆ID', 'bigint unsigned', 'String', 'vehicleId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (286, 19, 'plan_type', 'full=全款, installment=分期', 'varchar(20)', 'String', 'planType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (287, 19, 'plan_name', '方案名称', 'varchar(100)', 'String', 'planName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (288, 19, 'total_price', '全款总价（plan_type=full时）', 'decimal(12,2)', 'BigDecimal', 'totalPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (289, 19, 'down_payment', '首付金额', 'decimal(12,2)', 'BigDecimal', 'downPayment', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (290, 19, 'monthly_payment', '月供金额', 'decimal(10,2)', 'BigDecimal', 'monthlyPayment', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (291, 19, 'months', '分期期数', 'smallint', 'Long', 'months', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (292, 19, 'interest_rate', '年利率(%)', 'decimal(5,2)', 'BigDecimal', 'interestRate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (293, 19, 'total_interest', '总利息', 'decimal(10,2)', 'BigDecimal', 'totalInterest', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (294, 19, 'total_payable', '应还总额', 'decimal(12,2)', 'BigDecimal', 'totalPayable', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (295, 19, 'provider', '金融机构名称', 'varchar(100)', 'String', 'provider', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (296, 19, 'is_active', '是否启用', 'tinyint(1)', 'Integer', 'isActive', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (297, 19, 'sort_order', '排序号', 'int', 'Long', 'sortOrder', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (298, 19, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (299, 19, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (300, 20, 'review_id', '评价ID', 'bigint unsigned', 'String', 'reviewId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (301, 20, 'vehicle_id', '车辆ID', 'bigint unsigned', 'String', 'vehicleId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (302, 20, 'user_id', '用户ID', 'bigint unsigned', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (303, 20, 'order_id', '关联订单ID', 'bigint unsigned', 'String', 'orderId', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (304, 20, 'rating', '评分1-5', 'tinyint', 'Long', 'rating', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (305, 20, 'content', '评价内容', 'text', 'String', 'content', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 6, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (306, 20, 'image_url', '评价图片URL（可空）', 'varchar(255)', 'String', 'imageUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (307, 20, 'is_anonymous', '是否匿名', 'tinyint(1)', 'Integer', 'isAnonymous', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (308, 20, 'status', '0=正常,1=隐藏', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 9, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (309, 20, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (310, 21, 'spec_id', '配置ID', 'bigint unsigned', 'String', 'specId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (311, 21, 'vehicle_id', '车辆ID', 'bigint unsigned', 'String', 'vehicleId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (312, 21, 'range_km', '续航(km)', 'smallint', 'Long', 'rangeKm', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (313, 21, 'battery_capacity', '电池容量(kWh)', 'decimal(5,1)', 'BigDecimal', 'batteryCapacity', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (314, 21, 'charge_time_fast', '快充时间(h)', 'decimal(4,1)', 'BigDecimal', 'chargeTimeFast', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (315, 21, 'charge_time_slow', '慢充时间(h)', 'decimal(4,1)', 'BigDecimal', 'chargeTimeSlow', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (316, 21, 'model_year', '年款', 'smallint', 'Long', 'modelYear', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (317, 21, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (318, 22, 'used_id', '二手车ID', 'bigint unsigned', 'String', 'usedId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (319, 22, 'vehicle_id', '车辆ID', 'bigint unsigned', 'String', 'vehicleId', '0', '0', '1', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (320, 22, 'license_year', '上牌年份', 'smallint', 'Long', 'licenseYear', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (321, 22, 'license_month', '上牌月份', 'tinyint', 'Long', 'licenseMonth', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (322, 22, 'license_city', '上牌城市', 'varchar(50)', 'String', 'licenseCity', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (323, 22, 'mileage', '表显里程(万公里)', 'decimal(8,1)', 'BigDecimal', 'mileage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (324, 22, 'transfer_count', '过户次数', 'tinyint', 'Long', 'transferCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (325, 22, 'battery_soh', '电池健康状态SOH(%)', 'decimal(5,2)', 'BigDecimal', 'batterySoh', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (326, 22, 'battery_cycles', '循环次数', 'int unsigned', 'String', 'batteryCycles', '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (327, 22, 'battery_diagnosis', '评级: excellent/good/fair/poor', 'varchar(20)', 'String', 'batteryDiagnosis', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (328, 22, 'battery_report', '电池报告', 'text', 'String', 'batteryReport', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 11, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (329, 22, 'valuation_price', '估价价格', 'decimal(12,2)', 'BigDecimal', 'valuationPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (330, 22, 'valuation_info', '估价详情', 'text', 'String', 'valuationInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 13, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (331, 22, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (332, 23, 'user_id', '用户ID', 'bigint', 'Long', 'userId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (333, 23, 'dept_id', '部门ID', 'bigint', 'Long', 'deptId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (334, 23, 'user_name', '用户账号', 'varchar(30)', 'String', 'userName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (335, 23, 'nick_name', '用户昵称', 'varchar(30)', 'String', 'nickName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (336, 23, 'user_type', '用户类型（00系统用户）', 'varchar(2)', 'String', 'userType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (337, 23, 'email', '用户邮箱', 'varchar(50)', 'String', 'email', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (338, 23, 'phonenumber', '手机号码', 'varchar(11)', 'String', 'phonenumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (339, 23, 'sex', '用户性别（0男 1女 2未知）', 'char(1)', 'String', 'sex', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (340, 23, 'avatar', '头像地址', 'varchar(100)', 'String', 'avatar', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (341, 23, 'password', '密码', 'varchar(100)', 'String', 'password', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (342, 23, 'status', '账号状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 11, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (343, 23, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (344, 23, 'login_ip', '最后登录IP', 'varchar(128)', 'String', 'loginIp', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (345, 23, 'login_date', '最后登录时间', 'datetime', 'Date', 'loginDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 14, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (346, 23, 'pwd_update_date', '密码最后更新时间', 'datetime', 'Date', 'pwdUpdateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 15, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (347, 23, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 16, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (348, 23, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (349, 23, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 18, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (350, 23, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2026-06-06 20:59:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (351, 23, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 20, 'admin', '2026-06-06 20:59:18', '', NULL);

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`ledger_id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_record_type`(`record_type` ASC) USING BTREE,
  INDEX `idx_source`(`source_type` ASC, `source_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '碳积分流水账（来源可追溯）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_carbon_ledger
-- ----------------------------
INSERT INTO `stad_carbon_ledger` VALUES (1, 2, 0, NULL, 50, 50, 0, 1, '充电订单CO20260515000001 - 碳积分奖励', '2026-05-15 10:45:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (2, 2, 0, NULL, 35, 85, 0, 2, '充电订单CO20260518000002 - 碳积分奖励', '2026-05-18 14:35:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (3, 2, 0, NULL, 10, 95, 2, 1, '阅读文章《新能源车电池保养指南》- 碳积分奖励', '2026-05-19 08:00:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (4, 2, 0, NULL, 20, 115, 3, 1, '每日签到 - 碳积分奖励', '2026-05-20 06:00:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (5, 2, 0, NULL, 50, 165, 1, 1, '购车订单PO20260501000001 - 碳积分奖励', '2026-05-01 10:30:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (6, 2, 0, NULL, 25, 190, 0, 4, '充电订单CO20260525000004 - 碳积分奖励', '2026-05-25 16:30:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (7, 2, 1, NULL, -70, 120, 4, 1, '兑换京东优惠券50元 - 消耗碳积分', '2026-05-26 10:00:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (8, 3, 0, NULL, 50, 50, 0, 3, '充电订单CO20260520000003 - 碳积分奖励', '2026-05-20 09:50:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (9, 3, 0, NULL, 15, 65, 2, 2, '阅读文章《电动汽车冬季续航实测》- 碳积分奖励', '2026-05-22 12:00:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (10, 3, 0, NULL, 20, 85, 3, 2, '每日签到 - 碳积分奖励', '2026-05-23 07:00:00', 'admin', 'admin');
INSERT INTO `stad_carbon_ledger` VALUES (11, 3, 1, NULL, -30, 55, 4, 2, '兑换洗车券一张 - 消耗碳积分', '2026-05-28 15:00:00', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`stat_id`) USING BTREE,
  UNIQUE INDEX `uk_date_city`(`stat_date` ASC, `city` ASC, `district` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '碳排放 充电统计表（政府大屏数据）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_carbon_statistics
-- ----------------------------
INSERT INTO `stad_carbon_statistics` VALUES (1, '2026-05-01', '济南市', '历下区', 1, 8, 320, 6200.00, 4898.00, 272, 4200, 32, 220000, 52000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (2, '2026-05-01', '济南市', '市中区', 1, 6, 280, 5200.50, 4108.40, 228, 2800, 18, 148000, 36000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (3, '2026-05-01', '济南市', '长清区', 1, 4, 180, 3100.20, 2449.16, 136, 1800, 14, 88000, 22000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (4, '2026-05-01', '青岛市', '市南区', 1, 6, 300, 5800.00, 4582.00, 255, 3800, 30, 200000, 48000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (5, '2026-05-01', '青岛市', '黄岛区', 1, 4, 200, 3600.50, 2844.40, 158, 2200, 16, 120000, 28000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (6, '2026-05-01', '青岛市', '即墨区', 1, 4, 160, 2800.80, 2212.63, 123, 1500, 10, 78000, 18000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (7, '2026-05-01', '淄博市', '张店区', 1, 4, 220, 3800.00, 3002.00, 167, 1800, 14, 92000, 22000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (8, '2026-05-01', '枣庄市', '薛城区', 1, 3, 120, 2000.00, 1580.00, 88, 900, 8, 45000, 10000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (9, '2026-05-01', '东营市', '东营区', 1, 3, 130, 2200.00, 1738.00, 97, 800, 6, 40000, 9000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (10, '2026-05-01', '烟台市', '芝罘区', 1, 5, 260, 4800.00, 3792.00, 211, 3200, 22, 168000, 40000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (11, '2026-05-01', '烟台市', '莱山区', 1, 4, 190, 3500.00, 2765.00, 154, 1800, 12, 95000, 22000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (12, '2026-05-01', '潍坊市', '奎文区', 1, 5, 250, 4600.00, 3634.00, 202, 2800, 20, 148000, 36000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (13, '2026-05-01', '潍坊市', '寿光市', 1, 4, 180, 3200.00, 2528.00, 140, 1200, 8, 62000, 15000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (14, '2026-05-01', '济宁市', '任城区', 1, 4, 200, 3600.00, 2844.00, 158, 2200, 16, 115000, 28000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (15, '2026-05-01', '泰安市', '泰山区', 1, 3, 150, 2600.00, 2054.00, 114, 1400, 10, 72000, 18000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (16, '2026-05-01', '威海市', '环翠区', 1, 4, 200, 3600.00, 2844.00, 158, 1600, 12, 85000, 20000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (17, '2026-05-01', '日照市', '东港区', 1, 3, 140, 2400.00, 1896.00, 105, 1000, 8, 52000, 12000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (18, '2026-05-01', '临沂市', '兰山区', 1, 5, 280, 5200.00, 4108.00, 228, 3000, 24, 158000, 38000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (19, '2026-05-01', '临沂市', '沂水县', 1, 3, 120, 2000.00, 1580.00, 88, 900, 6, 46000, 10000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (20, '2026-05-01', '德州市', '德城区', 1, 3, 130, 2200.00, 1738.00, 97, 1100, 8, 56000, 13000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (21, '2026-05-01', '聊城市', '东昌府区', 1, 3, 140, 2400.00, 1896.00, 105, 1200, 10, 60000, 14000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (22, '2026-05-01', '滨州市', '滨城区', 1, 3, 120, 2000.00, 1580.00, 88, 900, 6, 45000, 10000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (23, '2026-05-01', '菏泽市', '牡丹区', 1, 4, 200, 3600.00, 2844.00, 158, 1800, 14, 92000, 22000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (24, '2026-05-01', '济南市', '莱芜区', 1, 3, 110, 1800.00, 1422.00, 79, 800, 6, 40000, 9000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (25, '2026-05-01', '枣庄市', '滕州市', 1, 4, 160, 2800.00, 2212.00, 123, 1200, 10, 60000, 14000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (26, '2026-05-01', '济宁市', '曲阜市', 1, 3, 100, 1600.00, 1264.00, 70, 700, 5, 35000, 8000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (27, '2026-05-01', '济宁市', '邹城市', 1, 4, 170, 3000.00, 2370.00, 132, 1400, 12, 70000, 16000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_carbon_statistics` VALUES (28, '2026-05-01', '青岛市', '平度市', 1, 3, 140, 2400.00, 1896.00, 105, 1000, 8, 50000, 12000, NULL, '2026-06-01 18:41:15', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
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
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电订单表（含费率时段记录）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_charging_order
-- ----------------------------
INSERT INTO `stad_charging_order` VALUES (1, 'CO20260515000001', 2, 1, 1, 'AT-DC-01', 1, 3, '2026-05-15 10:00:00', '2026-05-15 10:45:00', 2700, 25.00, 85.00, 42.50, 29.75, 23.38, 0.00, 53.13, '平时: 1.25元/kWh × 42.5kWh = 53.13元', '1', '1', '微信支付', 'WX20260515104500001', 50, '2026-05-15 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (2, 'CO20260518000002', 2, 1, 2, 'AT-DC-02', 1, 3, '2026-05-18 14:00:00', '2026-05-18 14:35:00', 2100, 30.00, 80.00, 35.00, 24.50, 19.25, 0.00, 43.75, '平时: 1.25元/kWh × 35.0kWh = 43.75元', '1', '1', '支付宝', 'ALI20260518143500002', 35, '2026-05-18 14:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (3, 'CO20260520000003', 3, 2, 10, 'WD-DC-02', 2, 8, '2026-05-20 09:00:00', '2026-05-20 09:50:00', 3000, 20.00, 90.00, 50.00, 35.00, 27.50, 5.00, 57.50, '平时: 1.25元/kWh × 50.0kWh - 优惠5元 = 57.50元', '1', '1', '微信支付', 'WX20260520095000003', 50, '2026-05-20 09:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (4, 'CO20260525000004', 2, 3, 15, 'DXC-DC-01', 4, 12, '2026-05-25 16:00:00', '2026-05-25 16:30:00', 1800, 40.00, 75.00, 25.00, 12.50, 7.50, 0.00, 20.00, '全天: 0.80元/kWh × 25.0kWh = 20.00元', '1', '1', '微信支付', 'WX20260525163000004', 25, '2026-05-25 16:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (5, 'CO20260528000005', 2, 4, 19, 'QD-DC-01', 5, 15, '2026-05-28 11:00:00', '2026-05-28 11:40:00', 2400, 35.00, 85.00, 38.00, 26.60, 20.90, 0.00, 47.50, '平时: 1.25元/kWh × 38.0kWh = 47.50元', '1', '1', '微信支付', 'WX20260528114000005', 38, '2026-05-28 11:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (6, 'CO20260529000006', 3, 7, 33, 'ZB-DC-01', 9, 27, '2026-05-29 15:00:00', '2026-05-29 15:30:00', 1800, 40.00, 80.00, 28.00, 18.20, 12.60, 0.00, 30.80, '平时: 1.10元/kWh × 28.0kWh = 30.80元', '1', '1', '支付宝', 'ALI20260529153000006', 28, '2026-05-29 15:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (7, 'CO20260531000007', 2, 1, 3, 'AT-DC-03', 1, 2, '2026-05-31 08:30:00', NULL, 0, 15.00, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, '0', '0', NULL, NULL, 0, '2026-05-31 08:30:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (8, 'CO20260522000008', 2, 2, 11, 'WD-DC-03', 2, 7, NULL, NULL, 0, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, '2', '0', NULL, NULL, 0, '2026-05-22 12:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (9, 'ORD1780759875568', 6, 3, 15, 'DXC-DC-01', NULL, NULL, '2026-06-06 23:31:15', NULL, 0, NULL, NULL, 36.00, 0.00, 0.00, 0.00, 0.00, NULL, '0', '0', NULL, NULL, 0, '2026-06-06 23:31:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (10, 'ORD1780760666201', 1, 3, 16, 'DXC-DC-02', NULL, NULL, '2026-06-06 23:44:26', NULL, 0, NULL, NULL, 36.00, 0.00, 0.00, 0.00, 0.00, NULL, '0', '0', NULL, NULL, 0, '2026-06-06 23:44:26', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (11, 'ORD1780760995120', 1, 3, 17, 'DXC-AC-01', NULL, NULL, '2026-06-06 23:49:55', NULL, 0, NULL, NULL, 36.00, 0.00, 0.00, 0.00, 0.00, NULL, '0', '0', NULL, NULL, 0, '2026-06-06 23:49:55', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (12, 'ORD1780904799159', 1, 3, 18, 'DXC-AC-02', NULL, NULL, '2026-06-08 15:46:39', NULL, 0, NULL, NULL, 36.00, 0.00, 0.00, 0.00, 0.00, NULL, '0', '0', NULL, NULL, 0, '2026-06-08 15:46:39', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (13, 'CO1780913509182', 1, 2, 9, 'WD-DC-01', 2, 9, '2026-06-08 18:11:49', '2026-06-08 18:16:01', 252, NULL, NULL, 36.00, 41.40, 19.80, 0.00, 61.20, NULL, '1', '1', '微信支付', NULL, 0, '2026-06-08 18:11:49', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (14, 'CO1780914078958', 4, 2, 9, 'WD-DC-01', 2, 9, '2026-06-08 18:21:18', '2026-06-08 18:21:22', 4, NULL, NULL, 36.00, 41.40, 19.80, 0.00, 61.20, NULL, '1', '1', '微信支付', NULL, 0, '2026-06-08 18:21:18', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (15, 'CO1780917482801', 1, 3, 15, 'DXC-DC-01', NULL, NULL, '2026-06-08 19:18:02', '2026-06-08 19:18:07', 5, NULL, NULL, 36.00, 0.00, 0.00, 0.00, 0.00, NULL, '1', '1', '微信支付', NULL, 0, '2026-06-08 19:18:02', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (16, 'CO1780917591852', 1, 3, 15, 'DXC-DC-01', NULL, NULL, '2026-06-08 19:19:51', '2026-06-08 19:19:53', 2, NULL, NULL, 14.40, 0.00, 0.00, 0.00, 0.00, NULL, '1', '0', NULL, NULL, 0, '2026-06-08 19:19:51', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (17, 'CO1780918015500', 1, 3, 15, 'DXC-DC-01', NULL, NULL, '2026-06-08 19:26:55', '2026-06-08 19:27:00', 5, NULL, NULL, 36.00, 0.00, 0.00, 0.00, 0.00, NULL, '1', '0', NULL, NULL, 0, '2026-06-08 19:26:55', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_order` VALUES (18, 'CO1780918490356', 1, 3, 15, 'DXC-DC-01', NULL, NULL, '2026-06-08 19:34:50', '2026-06-08 19:34:55', 5, NULL, NULL, 36.00, 12.60, 19.80, 0.00, 32.40, NULL, '1', '1', '微信支付', NULL, 0, '2026-06-08 19:34:50', 'admin', NULL, 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`pile_id`) USING BTREE,
  INDEX `idx_station_id`(`station_id` ASC) USING BTREE,
  INDEX `idx_pile_status`(`pile_status` ASC) USING BTREE,
  INDEX `idx_last_heartbeat`(`last_heartbeat` ASC) USING BTREE,
  CONSTRAINT `fk_charging_pile_station` FOREIGN KEY (`station_id`) REFERENCES `stad_charging_station` (`station_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电桩表（独立状态监控 实时心跳）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_charging_pile
-- ----------------------------
INSERT INTO `stad_charging_pile` VALUES (1, 1, 'AT-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 15800.50, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (2, 1, 'AT-DC-02', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 14200.30, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (3, 1, 'AT-DC-03', 'dc', 'public', 180.00, 'GB/T', '1', NULL, '张**', '2026-05-31 08:00:00', '2026-05-31 08:45:00', NULL, NULL, NULL, 12800.80, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (4, 1, 'AT-DC-04', 'dc', 'public', 180.00, 'CCS', '1', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 10500.20, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (5, 1, 'AT-AC-01', 'ac', 'public', 7.00, 'Type2', '1', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 3200.10, 5, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (6, 1, 'AT-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2800.50, 6, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (7, 1, 'AT-AC-03', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2500.30, 7, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (8, 1, 'AT-AC-04', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 2200.00, 8, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (9, 2, 'WD-DC-01', 'dc', 'public', 120.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 6800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (10, 2, 'WD-DC-02', 'dc', 'public', 120.00, 'GB/T', '0', NULL, '王**', '2026-05-31 08:20:00', '2026-05-31 08:45:00', NULL, NULL, NULL, 5500.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (11, 2, 'WD-DC-03', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 4200.30, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (12, 2, 'WD-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 1500.00, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (13, 2, 'WD-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:41:00', NULL, NULL, NULL, 1200.50, 5, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (14, 2, 'WD-AC-03', 'ac', 'public', 7.00, 'Type2', '1', NULL, NULL, NULL, '2026-05-31 08:40:00', NULL, NULL, NULL, 900.20, 6, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (15, 3, 'DXC-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 4800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (16, 3, 'DXC-DC-02', 'dc', 'public', 60.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 3500.30, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (17, 3, 'DXC-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 1100.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (18, 3, 'DXC-AC-02', 'ac', 'public', 7.00, 'Type2', '1', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 850.50, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (19, 4, 'QD-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 9200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (20, 4, 'QD-DC-02', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 7800.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (21, 4, 'QD-DC-03', 'dc', 'public', 60.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 5100.30, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (22, 4, 'QD-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2800.00, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (23, 4, 'QD-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2100.50, 5, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (24, 4, 'QD-AC-03', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 1800.20, 6, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (25, 5, 'JST-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 6200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (26, 5, 'JST-DC-02', 'dc', 'public', 60.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 4500.80, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (27, 5, 'JST-AC-01', 'ac', 'public', 7.00, 'Type2', '1', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 1600.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (28, 5, 'JST-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 1200.50, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (29, 6, 'JM-DC-01', 'dc', 'public', 120.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 3800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (30, 6, 'JM-DC-02', 'dc', 'public', 60.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2900.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (31, 6, 'JM-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 900.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (32, 6, 'JM-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 650.50, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (33, 7, 'ZB-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 5200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (34, 7, 'ZB-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 3800.30, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (35, 7, 'ZB-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 1300.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (36, 7, 'ZB-AC-02', 'ac', 'public', 7.00, 'Type2', '1', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 980.50, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (37, 8, 'ZZ-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (38, 8, 'ZZ-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2100.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (39, 8, 'ZZ-AC-01', 'ac', 'public', 7.00, 'Type2', '1', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 750.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (40, 9, 'DY-DC-01', 'dc', 'public', 120.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 3500.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (41, 9, 'DY-DC-02', 'dc', 'public', 60.00, 'GB/T', '1', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2600.80, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (42, 9, 'DY-AC-01', 'ac', 'public', 7.00, 'Type2', '1', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 880.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (43, 10, 'ZF-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 6800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (44, 10, 'ZF-DC-02', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 5500.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (45, 10, 'ZF-DC-03', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 4100.30, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (46, 10, 'ZF-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 1800.00, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (47, 10, 'ZF-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1400.50, 5, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (48, 11, 'LS-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 4200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (49, 11, 'LS-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 3100.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (50, 11, 'LS-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 1100.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (51, 11, 'LS-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 850.20, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (52, 12, 'THC-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 7800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (53, 12, 'THC-DC-02', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 6200.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (54, 12, 'THC-DC-03', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 4800.30, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (55, 12, 'THC-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2200.00, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (56, 12, 'THC-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1800.50, 5, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (57, 13, 'SG-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 3600.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (58, 13, 'SG-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2800.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (59, 13, 'SG-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 950.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (60, 13, 'SG-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 720.30, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (61, 14, 'JI-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 4800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (62, 14, 'JI-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 3500.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (63, 14, 'JI-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 1200.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (64, 14, 'JI-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 880.50, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (65, 15, 'HM-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 3200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (66, 15, 'HM-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2400.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (67, 15, 'HM-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 680.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (68, 16, 'WG-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 4200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (69, 16, 'WG-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 3200.80, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (70, 16, 'WG-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 1100.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (71, 16, 'WG-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 850.50, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (72, 17, 'RZ-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2600.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (73, 17, 'RZ-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1800.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (74, 17, 'RZ-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 520.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (75, 18, 'LY-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 6800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (76, 18, 'LY-DC-02', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 5500.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (77, 18, 'LY-DC-03', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 4100.30, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (78, 18, 'LY-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 1900.00, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (79, 18, 'LY-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1500.50, 5, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (80, 19, 'YS-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 1800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (81, 19, 'YS-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1200.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (82, 19, 'YS-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 420.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (83, 20, 'DZ-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (84, 20, 'DZ-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1600.80, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (85, 20, 'DZ-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 580.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (86, 21, 'LC-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2000.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (87, 21, 'LC-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1500.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (88, 21, 'LC-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 480.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (89, 22, 'BZ-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2400.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (90, 22, 'BZ-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1700.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (91, 22, 'BZ-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 560.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (92, 23, 'HE-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 3200.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (93, 23, 'HE-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2400.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (94, 23, 'HE-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 880.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (95, 23, 'HE-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 650.50, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (96, 24, 'LW-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 1800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (97, 24, 'LW-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1200.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (98, 24, 'LW-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 380.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (99, 25, 'TZ-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2800.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (100, 25, 'TZ-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2100.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (101, 25, 'TZ-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 750.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (102, 25, 'TZ-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 520.00, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (103, 26, 'QF-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 1600.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (104, 26, 'QF-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1100.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (105, 26, 'QF-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 350.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (106, 27, 'ZC-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 3000.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (107, 27, 'ZC-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 2300.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (108, 27, 'ZC-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 820.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (109, 27, 'ZC-AC-02', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:42:00', NULL, NULL, NULL, 580.00, 4, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (110, 28, 'PD-DC-01', 'dc', 'public', 120.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:45:00', NULL, NULL, NULL, 2400.00, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (111, 28, 'PD-DC-02', 'dc', 'public', 60.00, 'GB/T', '0', NULL, NULL, NULL, '2026-05-31 08:44:00', NULL, NULL, NULL, 1800.50, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_pile` VALUES (112, 28, 'PD-AC-01', 'ac', 'public', 7.00, 'Type2', '0', NULL, NULL, NULL, '2026-05-31 08:43:00', NULL, NULL, NULL, 620.00, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`rate_id`) USING BTREE,
  INDEX `fk_charging_rate_station`(`station_id` ASC) USING BTREE,
  CONSTRAINT `fk_charging_rate_station` FOREIGN KEY (`station_id`) REFERENCES `stad_charging_station` (`station_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电费率组表（区分快慢充）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_charging_rate
-- ----------------------------
INSERT INTO `stad_charging_rate` VALUES (1, 1, '奥体中心-快充费率', 'dc', 1, NULL, NULL, '济南奥体中心直流快充费率（全站直流8桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (2, 2, '万达广场-快充费率', 'dc', 1, NULL, NULL, '济南万达广场直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (3, 2, '万达广场-慢充费率', 'ac', 1, NULL, NULL, '济南万达广场交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (4, 3, '大学城-慢充费率', 'ac', 1, NULL, NULL, '济南长清大学城交流慢充费率（全站交流4桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (5, 4, '万象城-快充费率', 'dc', 1, NULL, NULL, '青岛万象城直流快充费率（全站直流6桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (6, 5, '金沙滩-快充费率', 'dc', 1, NULL, NULL, '青岛金沙滩直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (7, 5, '金沙滩-慢充费率', 'ac', 1, NULL, NULL, '青岛金沙滩交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (8, 6, '即墨古城-慢充费率', 'ac', 1, NULL, NULL, '青岛即墨古城交流慢充费率（全站交流4桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (9, 7, '淄博万象汇-快充费率', 'dc', 1, NULL, NULL, '淄博万象汇直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (10, 7, '淄博万象汇-慢充费率', 'ac', 1, NULL, NULL, '淄博万象汇交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (11, 8, '枣庄万达-快充费率', 'dc', 1, NULL, NULL, '枣庄薛城万达直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (12, 8, '枣庄万达-慢充费率', 'ac', 1, NULL, NULL, '枣庄薛城万达交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (13, 9, '东营万达-快充费率', 'dc', 1, NULL, NULL, '东营东城万达直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (14, 9, '东营万达-慢充费率', 'ac', 1, NULL, NULL, '东营东城万达交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (15, 10, '芝罘万达-快充费率', 'dc', 1, NULL, NULL, '烟台芝罘万达直流快充费率（全站直流5桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (16, 11, '莱山五彩城-快充费率', 'dc', 1, NULL, NULL, '烟台莱山五彩城直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (17, 11, '莱山五彩城-慢充费率', 'ac', 1, NULL, NULL, '烟台莱山五彩城交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (18, 12, '泰华城-快充费率', 'dc', 1, NULL, NULL, '潍坊泰华城直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (19, 12, '泰华城-慢充费率', 'ac', 1, NULL, NULL, '潍坊泰华城交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (20, 13, '寿光万达-快充费率', 'dc', 1, NULL, NULL, '寿光万达直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (21, 13, '寿光万达-慢充费率', 'ac', 1, NULL, NULL, '寿光万达交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (22, 14, '济宁万达-快充费率', 'dc', 1, NULL, NULL, '济宁任城万达直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (23, 14, '济宁万达-慢充费率', 'ac', 1, NULL, NULL, '济宁任城万达交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (24, 15, '泰山红门-慢充费率', 'ac', 1, NULL, NULL, '泰安泰山红门交流慢充费率（全站交流3桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (25, 16, '威高广场-快充费率', 'dc', 1, NULL, NULL, '威高广场直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (26, 16, '威高广场-慢充费率', 'ac', 1, NULL, NULL, '威高广场交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (27, 17, '日照万达-慢充费率', 'ac', 1, NULL, NULL, '日照东港万达交流慢充费率（全站交流3桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (28, 18, '临沂万象汇-快充费率', 'dc', 1, NULL, NULL, '临沂万象汇直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (29, 18, '临沂万象汇-慢充费率', 'ac', 1, NULL, NULL, '临沂万象汇交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (30, 19, '沂水-快充费率', 'dc', 1, NULL, NULL, '沂水正阳路直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (31, 19, '沂水-慢充费率', 'ac', 1, NULL, NULL, '沂水正阳路交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (32, 20, '德州万达-快充费率', 'dc', 1, NULL, NULL, '德州德城万达直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (33, 20, '德州万达-慢充费率', 'ac', 1, NULL, NULL, '德州德城万达交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (34, 21, '聊城万达-慢充费率', 'ac', 1, NULL, NULL, '聊城东昌府万达交流慢充费率（全站交流3桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (35, 22, '滨州万达-慢充费率', 'ac', 1, NULL, NULL, '滨州滨城万达交流慢充费率（全站交流3桩）', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (36, 23, '菏泽万达-快充费率', 'dc', 1, NULL, NULL, '菏泽牡丹万达直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (37, 23, '菏泽万达-慢充费率', 'ac', 1, NULL, NULL, '菏泽牡丹万达交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (38, 24, '莱芜红石公园-快充费率', 'dc', 1, NULL, NULL, '济南莱芜红石公园直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (39, 24, '莱芜红石公园-慢充费率', 'ac', 1, NULL, NULL, '济南莱芜红石公园交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (40, 25, '滕州万达-快充费率', 'dc', 1, NULL, NULL, '滕州万达广场直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (41, 25, '滕州万达-慢充费率', 'ac', 1, NULL, NULL, '滕州万达广场交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (42, 26, '曲阜三孔-快充费率', 'dc', 1, NULL, NULL, '曲阜三孔景区直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (43, 26, '曲阜三孔-慢充费率', 'ac', 1, NULL, NULL, '曲阜三孔景区交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (44, 27, '邹城体育公园-快充费率', 'dc', 1, NULL, NULL, '邹城体育公园直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (45, 27, '邹城体育公园-慢充费率', 'ac', 1, NULL, NULL, '邹城体育公园交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (46, 28, '平度万科城-快充费率', 'dc', 1, NULL, NULL, '平度万科城直流快充费率', 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_rate` VALUES (47, 28, '平度万科城-慢充费率', 'ac', 1, NULL, NULL, '平度万科城交流慢充费率', 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`period_id`) USING BTREE,
  INDEX `idx_time_range`(`start_time` ASC, `end_time` ASC) USING BTREE,
  INDEX `fk_charging_rate_period_rate`(`rate_id` ASC) USING BTREE,
  CONSTRAINT `fk_charging_rate_period_rate` FOREIGN KEY (`rate_id`) REFERENCES `stad_charging_rate` (`rate_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 136 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电费率时段表（峰谷平时段）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_charging_rate_period
-- ----------------------------
INSERT INTO `stad_charging_rate_period` VALUES (1, 1, '谷时', '00:00:00', '07:00:00', 0.3500, 0.5500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (2, 1, '峰时', '07:00:00', '09:00:00', 1.1500, 0.5500, 1.7000, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (3, 1, '平时', '09:00:00', '17:00:00', 0.7000, 0.5500, 1.2500, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (4, 1, '峰时', '17:00:00', '21:00:00', 1.1500, 0.5500, 1.7000, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (5, 1, '平时', '21:00:00', '24:00:00', 0.7000, 0.5500, 1.2500, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (6, 2, '谷时', '00:00:00', '07:00:00', 0.3500, 0.5500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (7, 2, '峰时', '07:00:00', '09:00:00', 1.1500, 0.5500, 1.7000, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (8, 2, '平时', '09:00:00', '17:00:00', 0.7000, 0.5500, 1.2500, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (9, 2, '峰时', '17:00:00', '21:00:00', 1.1500, 0.5500, 1.7000, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (10, 2, '平时', '21:00:00', '24:00:00', 0.7000, 0.5500, 1.2500, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (11, 3, '全天', '00:00:00', '24:00:00', 0.6000, 0.4000, 1.0000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (12, 4, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (13, 5, '谷时', '00:00:00', '07:00:00', 0.3500, 0.5500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (14, 5, '峰时', '07:00:00', '09:00:00', 1.1500, 0.5500, 1.7000, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (15, 5, '平时', '09:00:00', '17:00:00', 0.7000, 0.5500, 1.2500, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (16, 5, '峰时', '17:00:00', '21:00:00', 1.1500, 0.5500, 1.7000, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (17, 5, '平时', '21:00:00', '24:00:00', 0.7000, 0.5500, 1.2500, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (18, 6, '谷时', '00:00:00', '07:00:00', 0.3500, 0.5500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (19, 6, '峰时', '07:00:00', '09:00:00', 1.1500, 0.5500, 1.7000, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (20, 6, '平时', '09:00:00', '17:00:00', 0.7000, 0.5500, 1.2500, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (21, 6, '峰时', '17:00:00', '21:00:00', 1.1500, 0.5500, 1.7000, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (22, 6, '平时', '21:00:00', '24:00:00', 0.7000, 0.5500, 1.2500, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (23, 7, '全天', '00:00:00', '24:00:00', 0.6000, 0.4000, 1.0000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (24, 8, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (25, 9, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (26, 9, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (27, 9, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (28, 9, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (29, 9, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (30, 10, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (31, 11, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (32, 11, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (33, 11, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (34, 11, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (35, 11, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (36, 12, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (37, 13, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (38, 13, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (39, 13, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (40, 13, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (41, 13, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (42, 14, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (43, 15, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (44, 15, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (45, 15, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (46, 15, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (47, 15, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (48, 16, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (49, 16, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (50, 16, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (51, 16, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (52, 16, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (53, 17, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (54, 18, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (55, 18, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (56, 18, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (57, 18, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (58, 18, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (59, 19, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (60, 20, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (61, 20, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (62, 20, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (63, 20, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (64, 20, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (65, 21, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (66, 22, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (67, 22, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (68, 22, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (69, 22, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (70, 22, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (71, 23, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (72, 24, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (73, 25, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (74, 25, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (75, 25, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (76, 25, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (77, 25, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (78, 26, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (79, 27, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (80, 28, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (81, 28, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (82, 28, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (83, 28, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (84, 28, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (85, 29, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (86, 30, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (87, 30, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (88, 30, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (89, 30, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (90, 30, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (91, 31, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (92, 32, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (93, 32, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (94, 32, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (95, 32, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (96, 32, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (97, 33, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (98, 34, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (99, 35, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (100, 36, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (101, 36, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (102, 36, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (103, 36, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (104, 36, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (105, 37, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (106, 38, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (107, 38, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (108, 38, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (109, 38, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (110, 38, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (111, 39, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (112, 40, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (113, 40, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (114, 40, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (115, 40, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (116, 40, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (117, 41, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (118, 42, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (119, 42, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (120, 42, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (121, 42, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (122, 42, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (123, 43, '全天', '00:00:00', '24:00:00', 0.5000, 0.3000, 0.8000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (124, 44, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (125, 44, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (126, 44, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (127, 44, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (128, 44, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (129, 45, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (130, 46, '谷时', '00:00:00', '07:00:00', 0.3200, 0.4500, 0.7700, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (131, 46, '峰时', '07:00:00', '09:00:00', 1.0800, 0.4500, 1.5300, 100.00, 2, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (132, 46, '平时', '09:00:00', '17:00:00', 0.6500, 0.4500, 1.1000, 100.00, 3, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (133, 46, '峰时', '17:00:00', '21:00:00', 1.0800, 0.4500, 1.5300, 100.00, 4, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (134, 46, '平时', '21:00:00', '24:00:00', 0.6500, 0.4500, 1.1000, 100.00, 5, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_charging_rate_period` VALUES (135, 47, '全天', '00:00:00', '24:00:00', 0.5500, 0.3500, 0.9000, 100.00, 1, '2026-06-01 18:41:15', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`settlement_id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_date`(`merchant_id` ASC, `settle_date` ASC) USING BTREE,
  CONSTRAINT `fk_charging_settlement_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `stad_merchant` (`merchant_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电结算表（含提现）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_charging_settlement
-- ----------------------------
INSERT INTO `stad_charging_settlement` VALUES (1, 2, '2026-05-15', 45, 850.50, 1280.00, 64.00, 1216.00, '1', '2026-05-16 10:00:00', 'WD20260516000001', 1216.00, '1', '2026-05-17 10:00:00', '2026-05-16 10:00:00', 'admin', 'admin');
INSERT INTO `stad_charging_settlement` VALUES (2, 2, '2026-05-20', 62, 1120.00, 1650.00, 82.50, 1567.50, '1', '2026-05-21 10:00:00', 'WD20260521000002', 1567.50, '1', '2026-05-22 10:00:00', '2026-05-21 10:00:00', 'admin', 'admin');
INSERT INTO `stad_charging_settlement` VALUES (3, 2, '2026-05-30', 85, 1680.00, 2450.00, 122.50, 2327.50, '0', NULL, NULL, NULL, NULL, NULL, '2026-05-30 10:00:00', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`station_id`) USING BTREE,
  UNIQUE INDEX `uk_station_code`(`station_code` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_geo_hash`(`geo_hash` ASC) USING BTREE,
  INDEX `idx_available_piles`(`available_piles` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充电站表（地图展示 动态容量）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_charging_station
-- ----------------------------
INSERT INTO `stad_charging_station` VALUES (1, '济南奥体中心充电站', 'JN-AT-001', 2, '山东省', '济南市', '历下区', '奥体中路2000号奥体中心P1停车场', 117.1097520, 36.6770730, 'wwe3x4', NULL, 'medium', 8, 5, 3, '00:00:00', '23:59:59', '充电免停2小时', '0531-88881001', '卫生间、休息室、免费WiFi、自动售货机', '/static/images/chargeStation/5f9f5475a6cb848c0476e859b7930c2f.jpg,/static/images/chargeStation/OIP-C.webp', 0, '1', '审核通过', '2026-03-01 10:00:00', NULL, NULL, '1', '2026-03-01 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (2, '济南万达广场充电站', 'JN-WD-002', 2, '山东省', '济南市', '市中区', '经四路万达广场B2层停车场', 117.0018560, 36.6632180, 'wwe3mq', NULL, 'medium', 6, 4, 2, '06:00:00', '22:00:00', '充电免停1小时', '0531-88881002', '商场配套（餐饮/卫生间）、WiFi', '/static/images/chargeStation/OIP-C (1).webp,/static/images/chargeStation/OIP-C (10).webp', 0, '1', '审核通过', '2026-03-05 10:00:00', NULL, NULL, '1', '2026-03-05 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (3, '济南长清大学城充电站', 'JN-DXC-003', 2, '山东省', '济南市', '长清区', '大学路1255号长清大学城停车场', 116.8074740, 36.5598260, 'wwdxv4', NULL, 'medium', 4, 2, 2, '00:00:00', '23:59:59', '免费停车', '0531-88881003', '卫生间、休息区', '/static/images/chargeStation/OIP-C (11).webp,/static/images/chargeStation/OIP-C (12).webp', 0, '1', '审核通过', '2026-03-10 10:00:00', NULL, NULL, '1', '2026-03-10 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (4, '青岛万象城充电站', 'QD-WXC-004', 2, '山东省', '青岛市', '市南区', '山东路6号万象城B2层停车场', 120.3800000, 36.0700000, 'wmt6ge', NULL, 'medium', 6, 5, 1, '07:00:00', '23:00:00', '充电免停2小时', '0532-88881004', '商场配套、卫生间、WiFi', '/static/images/chargeStation/OIP-C (13).webp,/static/images/chargeStation/OIP-C (14).webp', 0, '1', '审核通过', '2026-03-15 10:00:00', NULL, NULL, '1', '2026-03-15 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (5, '青岛金沙滩充电站', 'QD-JST-005', 2, '山东省', '青岛市', '黄岛区', '金沙滩路666号景区停车场', 120.2302600, 35.9714000, 'wmt2c0', NULL, 'medium', 4, 2, 2, '08:00:00', '21:00:00', '充电免停1小时', '0532-88881005', '卫生间、自动售货机', '/static/images/chargeStation/OIP-C (15).webp,/static/images/chargeStation/OIP-C (16).webp', 0, '1', '审核通过', '2026-03-20 10:00:00', NULL, NULL, '1', '2026-03-20 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (6, '青岛即墨古城充电站', 'QD-JMGC-006', 2, '山东省', '青岛市', '即墨区', '即墨古城西门停车场', 120.4679390, 36.3884940, 'wmtk9b', NULL, 'medium', 4, 2, 2, '00:00:00', '23:59:59', '免费停车', '0532-88881006', '卫生间、休息区', '/static/images/chargeStation/OIP-C (17).webp,/static/images/chargeStation/OIP-C (18).webp', 0, '1', '审核通过', '2026-03-25 10:00:00', NULL, NULL, '1', '2026-03-25 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (7, '淄博万象汇充电站', 'ZB-WXH-007', 2, '山东省', '淄博市', '张店区', '金晶大道66号万象汇停车场', 118.0600000, 36.8000000, 'wwef8u', NULL, 'medium', 4, 3, 1, '08:00:00', '22:00:00', '充电免停1小时', '0533-88881007', '商场配套、卫生间、WiFi', '/static/images/chargeStation/OIP-C (19).webp,/static/images/chargeStation/OIP-C (2).webp', 0, '1', '审核通过', '2026-04-01 10:00:00', NULL, NULL, '1', '2026-04-01 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (8, '枣庄薛城万达充电站', 'ZZ-WD-008', 2, '山东省', '枣庄市', '薛城区', '永兴路126号万达广场停车场', 117.2630000, 34.7950000, 'wwdkj5', NULL, 'medium', 3, 2, 1, '08:00:00', '21:00:00', '充电免停1小时', '0632-88881008', '卫生间、休息区', '/static/images/chargeStation/OIP-C (20).webp,/static/images/chargeStation/OIP-C (21).webp', 0, '1', '审核通过', '2026-04-05 10:00:00', NULL, NULL, '1', '2026-04-05 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (9, '东营东城万达充电站', 'DY-WD-009', 2, '山东省', '东营市', '东营区', '东三路138号万达广场停车场', 118.6700000, 37.4500000, 'wwh2qp', NULL, 'medium', 3, 0, 3, '08:00:00', '21:00:00', '免费停车', '0546-88881009', '卫生间、休息室', '/static/images/chargeStation/OIP-C (22).webp,/static/images/chargeStation/OIP-C (23).webp', 0, '1', '审核通过', '2026-04-10 10:00:00', NULL, NULL, '1', '2026-04-10 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (10, '烟台芝罘万达充电站', 'YT-ZFWD-010', 2, '山东省', '烟台市', '芝罘区', '西南河路518号万达广场停车场', 121.3900000, 37.5400000, 'wwpmc0', NULL, 'medium', 5, 5, 0, '07:00:00', '22:00:00', '充电免停2小时', '0535-88881010', '商场配套、卫生间、WiFi、休息室', '/static/images/chargeStation/OIP-C (24).webp,/static/images/chargeStation/OIP-C (25).webp', 0, '1', '审核通过', '2026-04-15 10:00:00', NULL, NULL, '1', '2026-04-15 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (11, '烟台莱山五彩城充电站', 'YT-LSWC-011', 2, '山东省', '烟台市', '莱山区', '迎春大街188号五彩城停车场', 121.4500000, 37.4800000, 'wwpsr0', NULL, 'medium', 4, 4, 0, '08:00:00', '21:30:00', '充电免停1小时', '0535-88881011', '卫生间、休息区', '/static/images/chargeStation/OIP-C (26).webp,/static/images/chargeStation/OIP-C (27).webp', 0, '1', '审核通过', '2026-04-20 10:00:00', NULL, NULL, '1', '2026-04-20 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (12, '潍坊泰华城充电站', 'WF-THC-012', 2, '山东省', '潍坊市', '奎文区', '东风东街360号泰华城停车场', 119.1116720, 36.7089840, 'wwet9p', NULL, 'medium', 5, 5, 0, '08:00:00', '22:00:00', '充电免停1小时', '0536-88881012', '商场配套、卫生间、WiFi', '/static/images/chargeStation/OIP-C (28).webp,/static/images/chargeStation/OIP-C (29).webp', 0, '1', '审核通过', '2026-04-25 10:00:00', NULL, NULL, '1', '2026-04-25 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (13, '寿光万达广场充电站', 'SG-WD-013', 2, '山东省', '潍坊市', '寿光市', '圣城街666号万达广场停车场', 118.7717120, 36.8740610, 'wwf8r0', NULL, 'medium', 4, 4, 0, '08:00:00', '21:00:00', '免费停车', '0536-88881013', '卫生间、休息区', '/static/images/chargeStation/OIP-C (3).webp,/static/images/chargeStation/OIP-C (30).webp', 0, '1', '审核通过', '2026-04-28 10:00:00', NULL, NULL, '1', '2026-04-28 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (14, '济宁任城万达充电站', 'JI-WD-014', 2, '山东省', '济宁市', '任城区', '太白楼中路88号万达广场停车场', 116.6038440, 35.4082830, 'wwdq3e', NULL, 'medium', 4, 4, 0, '08:00:00', '22:00:00', '充电免停1小时', '0537-88881014', '商场配套、卫生间、WiFi', '/static/images/chargeStation/OIP-C (31).webp,/static/images/chargeStation/OIP-C (32).webp', 0, '1', '审核通过', '2026-05-01 10:00:00', NULL, NULL, '1', '2026-05-01 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (15, '泰安泰山红门充电站', 'TA-HM-015', 2, '山东省', '泰安市', '泰山区', '红门路98号泰山景区停车场', 117.1278030, 36.2110120, 'wwdw6n', NULL, 'medium', 3, 3, 0, '06:00:00', '22:00:00', '充电免停2小时', '0538-88881015', '卫生间、休息室、自动售货机', '/static/images/chargeStation/OIP-C (33).webp,/static/images/chargeStation/OIP-C (34).webp', 0, '1', '审核通过', '2026-05-05 10:00:00', NULL, NULL, '1', '2026-05-05 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (16, '威高广场充电站', 'WH-WG-016', 2, '山东省', '威海市', '环翠区', '新威路17号威高广场停车场', 122.1231470, 37.5046150, 'wwpv4e', NULL, 'medium', 4, 4, 0, '08:00:00', '22:00:00', '充电免停1小时', '0631-88881016', '商场配套、卫生间、WiFi', '/static/images/chargeStation/OIP-C (35).webp,/static/images/chargeStation/OIP-C (36).webp', 0, '1', '审核通过', '2026-05-10 10:00:00', NULL, NULL, '1', '2026-05-10 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (17, '日照东港万达充电站', 'RZ-WD-017', 2, '山东省', '日照市', '东港区', '山东东路666号万达广场停车场', 119.5270000, 35.4150000, 'wwpy7b', NULL, 'medium', 3, 3, 0, '08:00:00', '21:00:00', '免费停车', '0633-88881017', '卫生间、休息区', '/static/images/chargeStation/OIP-C (37).webp,/static/images/chargeStation/OIP-C (38).webp', 0, '1', '审核通过', '2026-05-12 10:00:00', NULL, NULL, '1', '2026-05-12 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (18, '临沂万象汇充电站', 'LY-WXH-018', 2, '山东省', '临沂市', '兰山区', '解放路188号万象汇停车场', 118.3500000, 35.0600000, 'wwdq5e', NULL, 'medium', 5, 5, 0, '08:00:00', '22:00:00', '充电免停1小时', '0539-88881018', '商场配套、卫生间、WiFi、休息室', '/static/images/chargeStation/OIP-C (39).webp,/static/images/chargeStation/OIP-C (4).webp', 0, '1', '审核通过', '2026-05-15 10:00:00', NULL, NULL, '1', '2026-05-15 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (19, '沂水正阳路充电站', 'YS-ZY-019', 2, '山东省', '临沂市', '沂水县', '正阳路66号沂水停车场', 118.6280000, 35.7900000, 'wwf5np', NULL, 'medium', 3, 3, 0, '00:00:00', '23:59:59', '免费停车', '0539-88881019', '卫生间、休息区', '/static/images/chargeStation/OIP-C (40).webp,/static/images/chargeStation/OIP-C (41).webp', 0, '1', '审核通过', '2026-05-18 10:00:00', NULL, NULL, '1', '2026-05-18 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (20, '德州德城万达充电站', 'DZ-WD-020', 2, '山东省', '德州市', '德城区', '湖滨中大道888号万达广场停车场', 116.3000000, 37.4510000, 'wwh6p2', NULL, 'medium', 3, 3, 0, '08:00:00', '21:00:00', '充电免停1小时', '0534-88881020', '卫生间、休息区', '/static/images/chargeStation/OIP-C (42).webp,/static/images/chargeStation/OIP-C (43).webp', 0, '1', '审核通过', '2026-05-20 10:00:00', NULL, NULL, '1', '2026-05-20 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (21, '聊城东昌府万达充电站', 'LC-WD-021', 2, '山东省', '聊城市', '东昌府区', '东昌东路66号万达广场停车场', 115.9800000, 36.4570000, 'wwdq1n', NULL, 'medium', 3, 3, 0, '08:00:00', '21:00:00', '免费停车', '0635-88881021', '卫生间、休息区', '/static/images/chargeStation/OIP-C (44).webp,/static/images/chargeStation/OIP-C (45).webp', 0, '1', '审核通过', '2026-05-22 10:00:00', NULL, NULL, '1', '2026-05-22 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (22, '滨州滨城万达充电站', 'BZ-WD-022', 2, '山东省', '滨州市', '滨城区', '黄河五路588号万达广场停车场', 117.9700000, 37.3820000, 'wwh4mr', NULL, 'medium', 3, 3, 0, '08:00:00', '21:00:00', '充电免停1小时', '0543-88881022', '卫生间、休息区', '/static/images/chargeStation/OIP-C (46).webp,/static/images/chargeStation/OIP-C (47).webp', 0, '1', '审核通过', '2026-05-25 10:00:00', NULL, NULL, '1', '2026-05-25 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (23, '菏泽牡丹万达充电站', 'HE-WD-023', 2, '山东省', '菏泽市', '牡丹区', '中华路888号万达广场停车场', 115.4400000, 35.2450000, 'wwdq9k', NULL, 'medium', 4, 4, 0, '08:00:00', '22:00:00', '充电免停1小时', '0530-88881023', '商场配套、卫生间、WiFi', '/static/images/chargeStation/OIP-C (48).webp,/static/images/chargeStation/OIP-C (49).webp', 0, '1', '审核通过', '2026-05-28 10:00:00', NULL, NULL, '1', '2026-05-28 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (24, '济南莱芜红石公园充电站', 'JN-LW-024', 2, '山东省', '济南市', '莱芜区', '鲁中东大街108号红石公园停车场', 117.6700000, 36.2000000, 'wwew7q', NULL, 'medium', 3, 3, 0, '00:00:00', '23:59:59', '免费停车', '0531-88881024', '卫生间、休息区', '/static/images/chargeStation/OIP-C (5).webp,/static/images/chargeStation/OIP-C (50).webp', 0, '1', '审核通过', '2026-06-01 10:00:00', NULL, NULL, '1', '2026-06-01 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (25, '滕州万达广场充电站', 'TZ-WD-025', 2, '山东省', '枣庄市', '滕州市', '北辛东路188号万达广场停车场', 117.1700000, 35.0800000, 'wwdkjd', NULL, 'medium', 4, 4, 0, '08:00:00', '22:00:00', '充电免停1小时', '0632-88881025', '商场配套、卫生间、WiFi', '/static/images/chargeStation/OIP-C (6).webp,/static/images/chargeStation/OIP-C (7).webp', 0, '1', '审核通过', '2026-06-03 10:00:00', NULL, NULL, '1', '2026-06-03 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (26, '曲阜三孔景区充电站', 'QF-SK-026', 2, '山东省', '济宁市', '曲阜市', '神道路9号三孔景区停车场', 116.9924950, 35.5910420, 'wwdqn5', NULL, 'medium', 3, 3, 0, '07:00:00', '21:00:00', '充电免停2小时', '0537-88881026', '卫生间、休息室、自动售货机', '/static/images/chargeStation/OIP-C (8).webp,/static/images/chargeStation/OIP-C (9).webp', 0, '1', '审核通过', '2026-06-05 10:00:00', NULL, NULL, '1', '2026-06-05 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (27, '邹城体育公园充电站', 'ZC-TY-027', 2, '山东省', '济宁市', '邹城市', '峄山北路66号体育公园停车场', 117.0000000, 35.4000000, 'wwdq4f', NULL, 'medium', 4, 4, 0, '06:00:00', '22:00:00', '免费停车', '0537-88881027', '卫生间、休息区', '/static/images/chargeStation/下载 (1).webp,/static/images/chargeStation/下载 (2).webp', 0, '1', '审核通过', '2026-06-08 10:00:00', NULL, NULL, '1', '2026-06-08 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_charging_station` VALUES (28, '平度万科城充电站', 'PD-WK-028', 2, '山东省', '青岛市', '平度市', '人民路88号万科城停车场', 119.9600000, 36.7800000, 'wwf6sh', NULL, 'medium', 3, 3, 0, '08:00:00', '21:00:00', '充电免停1小时', '0532-88881028', '卫生间、休息区', '/static/images/chargeStation/下载 (3).webp,/static/images/chargeStation/下载.webp', 0, '1', '审核通过', '2026-06-10 10:00:00', NULL, NULL, '1', '2026-06-10 10:00:00', 'admin', NULL, 'admin');

-- ----------------------------
-- Table structure for stad_coupon
-- ----------------------------
DROP TABLE IF EXISTS `stad_coupon`;
CREATE TABLE `stad_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` int NULL DEFAULT 1 COMMENT '1=满减, 2=折扣, 3=直减',
  `amount` decimal(10, 2) NOT NULL COMMENT '优惠金额/折扣率',
  `min_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '最低消费金额',
  `start_time` datetime NOT NULL COMMENT '生效时间',
  `end_time` datetime NOT NULL COMMENT '失效时间',
  `total_count` int NULL DEFAULT 100 COMMENT '总发行量',
  `per_user_limit` int NULL DEFAULT 1 COMMENT '每人限领',
  `status` int NULL DEFAULT 1 COMMENT '1=启用, 0=停用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_coupon`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_coupon
-- ----------------------------
INSERT INTO `stad_coupon` VALUES (1, 'New User Coupon', 3, 50.00, 0.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 1000, 1, 1, '2026-06-08 22:51:45');
INSERT INTO `stad_coupon` VALUES (2, 'Charge Discount', 1, 10.00, 50.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 500, 3, 1, '2026-06-08 22:51:45');
INSERT INTO `stad_coupon` VALUES (3, 'Car Purchase', 2, 0.95, 100000.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 100, 1, 1, '2026-06-08 22:51:45');
INSERT INTO `stad_coupon` VALUES (4, 'Service Coupon', 3, 30.00, 0.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 200, 2, 1, '2026-06-08 22:51:45');
INSERT INTO `stad_coupon` VALUES (5, 'Weekend Sale', 1, 20.00, 100.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 300, 2, 1, '2026-06-08 22:51:45');
INSERT INTO `stad_coupon` VALUES (6, 'New User Coupon', 3, 50.00, 0.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 1000, 1, 1, '2026-06-08 23:01:20');
INSERT INTO `stad_coupon` VALUES (7, 'Charge Discount', 1, 10.00, 50.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 500, 3, 1, '2026-06-08 23:01:20');
INSERT INTO `stad_coupon` VALUES (8, 'Car Purchase', 2, 0.95, 100000.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 100, 1, 1, '2026-06-08 23:01:20');
INSERT INTO `stad_coupon` VALUES (9, 'Service Coupon', 3, 30.00, 0.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 200, 2, 1, '2026-06-08 23:01:20');
INSERT INTO `stad_coupon` VALUES (10, 'Weekend Sale', 1, 20.00, 100.00, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 300, 2, 1, '2026-06-08 23:01:20');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`reg_id`) USING BTREE,
  UNIQUE INDEX `uk_date_city`(`stat_date` ASC, `city` ASC, `district` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '新能源车注册统计表（政府）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_gov_nev_registration
-- ----------------------------
INSERT INTO `stad_gov_nev_registration` VALUES (1, '2026-05-01', '济南市', '历下区', 32, 4200, 2700, 1420, 80, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (2, '2026-05-01', '济南市', '市中区', 18, 2800, 1850, 920, 30, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (3, '2026-05-01', '济南市', '长清区', 14, 1800, 1180, 600, 20, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (4, '2026-05-01', '青岛市', '市南区', 30, 3800, 2500, 1220, 80, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (5, '2026-05-01', '青岛市', '黄岛区', 16, 2200, 1450, 720, 30, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (6, '2026-05-01', '青岛市', '即墨区', 10, 1500, 980, 510, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (7, '2026-05-01', '淄博市', '张店区', 14, 1800, 1150, 630, 20, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (8, '2026-05-01', '枣庄市', '薛城区', 8, 900, 580, 310, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (9, '2026-05-01', '东营市', '东营区', 6, 800, 520, 270, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (10, '2026-05-01', '烟台市', '芝罘区', 22, 3200, 2100, 1050, 50, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (11, '2026-05-01', '烟台市', '莱山区', 12, 1800, 1200, 580, 20, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (12, '2026-05-01', '潍坊市', '奎文区', 20, 2800, 1850, 920, 30, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (13, '2026-05-01', '潍坊市', '寿光市', 8, 1200, 780, 410, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (14, '2026-05-01', '济宁市', '任城区', 16, 2200, 1400, 780, 20, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (15, '2026-05-01', '泰安市', '泰山区', 10, 1400, 920, 470, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (16, '2026-05-01', '威海市', '环翠区', 12, 1600, 1050, 540, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (17, '2026-05-01', '日照市', '东港区', 8, 1000, 650, 340, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (18, '2026-05-01', '临沂市', '兰山区', 24, 3000, 2000, 970, 30, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (19, '2026-05-01', '临沂市', '沂水县', 6, 900, 580, 310, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (20, '2026-05-01', '德州市', '德城区', 8, 1100, 710, 380, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (21, '2026-05-01', '聊城市', '东昌府区', 10, 1200, 780, 410, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (22, '2026-05-01', '滨州市', '滨城区', 6, 900, 580, 310, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (23, '2026-05-01', '菏泽市', '牡丹区', 14, 1800, 1150, 640, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (24, '2026-05-01', '济南市', '莱芜区', 6, 800, 520, 270, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (25, '2026-05-01', '枣庄市', '滕州市', 10, 1200, 780, 410, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (26, '2026-05-01', '济宁市', '曲阜市', 5, 700, 450, 240, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (27, '2026-05-01', '济宁市', '邹城市', 12, 1400, 920, 470, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_gov_nev_registration` VALUES (28, '2026-05-01', '青岛市', '平度市', 8, 1000, 650, 340, 10, 'system', '2026-06-01 18:41:15', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE,
  INDEX `fk_maintenance_order_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_maintenance_order_shop` FOREIGN KEY (`shop_id`) REFERENCES `stad_maintenance_shop` (`shop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_maintenance_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '维保订单表（含预约）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_maintenance_order
-- ----------------------------
INSERT INTO `stad_maintenance_order` VALUES (1, 'MO20260510000001', 2, 1, 1, '常规保养+电池检测', 580.00, 580.00, 580.00, '2026-05-15', 'am', '3', NULL, '2026-05-15 11:30:00', 5, '服务非常专业，电池检测报告详细，技师耐心解答了充电保养问题，好评！', '1', '微信支付', '2026-05-10 09:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_maintenance_order` VALUES (2, 'MO20260520000002', 3, 2, 2, '空调清洗+轮胎更换', 880.00, 880.00, 0.00, '2026-05-28', 'pm', '1', NULL, NULL, NULL, NULL, '1', NULL, '2026-05-20 14:00:00', 'admin', '2026-06-09 15:03:19', 'admin');
INSERT INTO `stad_maintenance_order` VALUES (3, 'WH20260609114631', 1, 2, 7, '常规保养', 299.00, 299.00, 0.00, '2026-06-11', 'am', '0', NULL, NULL, NULL, NULL, '0', NULL, '2026-06-09 14:45:17', 'admin', NULL, 'admin');
INSERT INTO `stad_maintenance_order` VALUES (4, 'WH20260609802699', 1, 2, 4, '空调清洗', 168.00, 168.00, 0.00, '2026-07-14', 'am', '0', NULL, NULL, NULL, NULL, '0', NULL, '2026-06-09 15:51:54', '', NULL, '');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`shop_id`) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_province_city`(`province` ASC, `city` ASC) USING BTREE,
  INDEX `idx_city_district`(`city` ASC, `district` ASC) USING BTREE,
  CONSTRAINT `fk_maintenance_shop_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `stad_merchant` (`merchant_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '维保门店表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_maintenance_shop
-- ----------------------------
INSERT INTO `stad_maintenance_shop` VALUES (1, '济南鑫维保-经十西路店', 3, '山东省', '济南市', '槐荫区', '经十西路500号鑫源汽车城A区', 116.9200000, 36.6500000, '孙经理', '13500003333', '常规保养、电池检测、空调维修、轮胎更换、钣金喷漆、保险理赔', 4.5, '济南鑫维保旗舰店，专注新能源汽车维修保养，拥有原厂诊断设备和认证技师团队', 1, '2026-03-10 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_maintenance_shop` VALUES (2, '济南鑫维保-工业北路店', 3, '山东省', '济南市', '历城区', '工业北路88号汽车产业园', 117.0800000, 36.7100000, '刘师傅', '13400004444', '常规保养、电池均衡、底盘检修、空调清洗、美容装饰', 4.2, '工业北路分店，交通便利，提供上门取送车服务', 1, '2026-04-01 10:00:00', 'admin', NULL, 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`merchant_id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_type`(`merchant_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_merchant
-- ----------------------------
INSERT INTO `stad_merchant` VALUES (1, 4, '济南鑫源新能源汽车销售有限公司', 'dealer', '王经理', '13700001111', '山东省', '济南市', '历城区工业北路88号', '09:00:00', '18:00:00', '/upload/biz/001.jpg', '王建国', '370112197501011234', '1', '资质审核通过', '2026-01-15 10:00:00', 850000.00, 600000.00, 250000.00, 500000.00, '中国工商银行济南分行', '6222021602001234567', '2026-01-10 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_merchant` VALUES (2, 5, '济南绿能充电运营有限公司', 'charger', '赵经理', '13600002222', '山东省', '济南市', '历下区奥体中路2000号', '00:00:00', '23:59:59', '/upload/biz/002.jpg', '赵志强', '370112198003012345', '1', '充电运营商资质审核通过', '2026-02-20 10:00:00', 320000.00, 280000.00, 40000.00, 250000.00, '中国建设银行济南分行', '6227002234567890123', '2026-02-15 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_merchant` VALUES (3, 6, '济南鑫维保汽车服务有限公司', 'maintenance', '孙经理', '13500003333', '山东省', '济南市', '槐荫区经十西路500号', '08:30:00', '17:30:00', '/upload/biz/003.jpg', '孙大伟', '370112198505053456', '1', '维保商资质审核通过', '2026-03-10 10:00:00', 150000.00, 120000.00, 30000.00, 100000.00, '中国农业银行济南分行', '6228480012345678901', '2026-03-05 10:00:00', 'admin', NULL, 'admin');

-- ----------------------------
-- Table structure for stad_reservation
-- ----------------------------
DROP TABLE IF EXISTS `stad_reservation`;
CREATE TABLE `stad_reservation`  (
  `reservation_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `reservation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约类型: charging, maintenance',
  `business_id` bigint UNSIGNED NOT NULL COMMENT '关联业务ID(充电站ID或门店ID)',
  `business_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预约业务名称',
  `business_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预约业务地址',
  `reservation_date` date NOT NULL COMMENT '预约日期',
  `start_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约开始时间',
  `end_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约结束时间',
  `status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '预约状态: 0=待确认, 1=已确认, 2=已完成, 3=已取消',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预约备注',
  `cancel_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  `confirm_time` datetime NULL DEFAULT NULL COMMENT '确认时间',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`reservation_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_reservation_date`(`reservation_date` ASC) USING BTREE,
  INDEX `idx_business`(`reservation_type` ASC, `business_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_reservation
-- ----------------------------
INSERT INTO `stad_reservation` VALUES (1, 1, 'charging', 1, '国家电网充电站(科技园站)', '科技园区A座地下停车场', '2026-06-08', '10:00', '12:00', '0', '请准时到达', NULL, NULL, NULL, NULL, '2026-06-07 09:30:00', NULL);
INSERT INTO `stad_reservation` VALUES (2, 1, 'maintenance', 1, '新能源汽修服务中心', '科技园区B座1楼', '2026-06-09', '14:00', '16:00', '1', '保养服务', NULL, NULL, '2026-06-07 10:00:00', NULL, '2026-06-06 16:00:00', NULL);

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '统一订单表（购车+试驾+以旧换新）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_unified_order
-- ----------------------------
INSERT INTO `stad_unified_order` VALUES (1, 'PO20260501000001', 'purchase', 2, 1, 1, '张先生', '13800001111', 1, 219800.00, 219800.00, 219800.00, '微信支付', NULL, NULL, NULL, NULL, NULL, NULL, '2', NULL, '2026-05-01 09:00:00', 'admin', '2026-05-01 10:30:00', 'admin');
INSERT INTO `stad_unified_order` VALUES (2, 'PO20260510000002', 'purchase', 3, 2, 1, '李女士', '13900002222', 3, 299900.00, 299900.00, 89970.00, '支付宝', NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, '2026-05-10 11:00:00', 'admin', '2026-05-10 11:30:00', 'admin');
INSERT INTO `stad_unified_order` VALUES (3, 'TDO20260520000001', 'test_drive', 2, 3, 1, '张先生', '13800001111', NULL, NULL, 0.00, 0.00, '—', NULL, '2026-05-25', 'am', NULL, NULL, NULL, '2', NULL, '2026-05-20 14:00:00', 'admin', '2026-05-25 11:00:00', 'admin');
INSERT INTO `stad_unified_order` VALUES (4, 'TDO20260522000002', 'test_drive', 3, 4, 1, '李女士', '13900002222', NULL, NULL, 0.00, 0.00, '—', NULL, '2026-05-28', 'pm', NULL, NULL, NULL, '1', NULL, '2026-05-22 10:00:00', 'admin', '2026-05-22 10:00:00', 'admin');
INSERT INTO `stad_unified_order` VALUES (5, 'TIO20260525000001', 'trade_in', 2, 5, 1, '张先生', '13800001111', 1, 339800.00, 181800.00, 50000.00, '微信支付', NULL, NULL, NULL, 7, 158000.00, NULL, '1', NULL, '2026-05-25 08:00:00', 'admin', '2026-05-25 08:00:00', 'admin');
INSERT INTO `stad_unified_order` VALUES (6, 'PUR202606072155169166', 'purchase', 1, 1, NULL, '好好', '12313124144', NULL, 219800.00, 219800.58, 0.00, 'full', '{\"name\":\"基础保障\",\"desc\":\"交强险+三者200万\",\"price\":5800}', NULL, NULL, NULL, NULL, NULL, '0', NULL, '2026-06-07 21:55:16', 'admin', NULL, 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`address_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收货地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_user_address
-- ----------------------------
INSERT INTO `stad_user_address` VALUES (1, 2, '张先生', '13800001111', '山东省', '济南市', '历下区', '泉城路188号恒隆广场', 1, '2026-04-01 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_user_address` VALUES (2, 2, '张先生', '13800001111', '山东省', '济南市', '长清区', '大学路1255号', 0, '2026-04-10 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_user_address` VALUES (3, 3, '李女士', '13900002222', '山东省', '济南市', '市中区', '经四路万达广场B座', 1, '2026-04-05 10:00:00', 'admin', NULL, 'admin');

-- ----------------------------
-- Table structure for stad_user_coupon
-- ----------------------------
DROP TABLE IF EXISTS `stad_user_coupon`;
CREATE TABLE `stad_user_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `coupon_id` bigint NOT NULL,
  `status` int NULL DEFAULT 1 COMMENT '1=未使用, 2=已使用, 3=已过期',
  `use_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `order_id` bigint NULL DEFAULT NULL COMMENT '使用订单ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id_uc`(`user_id` ASC) USING BTREE,
  INDEX `idx_coupon_id_uc`(`coupon_id` ASC) USING BTREE,
  INDEX `idx_status_uc`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_user_coupon
-- ----------------------------
INSERT INTO `stad_user_coupon` VALUES (1, 1, 1, 1, NULL, NULL, '2026-06-08 22:51:45');
INSERT INTO `stad_user_coupon` VALUES (2, 1, 2, 1, NULL, NULL, '2026-06-08 22:51:45');
INSERT INTO `stad_user_coupon` VALUES (3, 1, 2, 1, NULL, NULL, '2026-06-08 22:51:45');
INSERT INTO `stad_user_coupon` VALUES (4, 1, 4, 2, NULL, NULL, '2026-06-08 22:51:45');
INSERT INTO `stad_user_coupon` VALUES (5, 1, 5, 1, NULL, NULL, '2026-06-08 22:51:45');
INSERT INTO `stad_user_coupon` VALUES (6, 1, 1, 1, NULL, NULL, '2026-06-08 23:01:20');
INSERT INTO `stad_user_coupon` VALUES (7, 1, 2, 1, NULL, NULL, '2026-06-08 23:01:20');
INSERT INTO `stad_user_coupon` VALUES (8, 1, 2, 1, NULL, NULL, '2026-06-08 23:01:20');
INSERT INTO `stad_user_coupon` VALUES (9, 1, 4, 2, NULL, NULL, '2026-06-08 23:01:20');
INSERT INTO `stad_user_coupon` VALUES (10, 1, 5, 1, NULL, NULL, '2026-06-08 23:01:20');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`favorite_id`) USING BTREE,
  UNIQUE INDEX `uk_user_favorite`(`user_id` ASC, `target_type` ASC, `target_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_target`(`target_type` ASC, `target_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_user_favorite
-- ----------------------------
INSERT INTO `stad_user_favorite` VALUES (1, 2, 'vehicle', 1, '2026-05-10 10:00:00', 'admin', 'admin');
INSERT INTO `stad_user_favorite` VALUES (2, 2, 'vehicle', 3, '2026-05-12 14:30:00', 'admin', 'admin');
INSERT INTO `stad_user_favorite` VALUES (3, 2, 'station', 1, '2026-05-15 09:00:00', 'admin', 'admin');
INSERT INTO `stad_user_favorite` VALUES (4, 3, 'vehicle', 2, '2026-05-20 11:00:00', 'admin', 'admin');
INSERT INTO `stad_user_favorite` VALUES (5, 3, 'station', 2, '2026-05-22 16:00:00', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`feedback_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户反馈表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_user_feedback
-- ----------------------------
INSERT INTO `stad_user_feedback` VALUES (1, 2, '希望增加充电站筛选功能，按充电功率排序', NULL, '13800001111', '感谢反馈，我们已在规划中', '2026-05-16 10:00:00', '1', '2026-05-15 08:00:00', 'admin', 'admin');
INSERT INTO `stad_user_feedback` VALUES (2, 3, '二手车详情页面的电池检测报告不够详细', NULL, '13900002222', NULL, NULL, '0', '2026-05-28 14:00:00', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`profile_id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户扩展表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_user_profile
-- ----------------------------
INSERT INTO `stad_user_profile` VALUES (1, 2, '370112199001011234', 190, 70, 120, 'admin', '2026-06-09 15:02:55', 'admin', '2026-06-01 18:41:15');
INSERT INTO `stad_user_profile` VALUES (2, 3, '370112199205052345', 85, 30, 55, 'admin', '2026-06-09 15:02:55', 'admin', '2026-06-01 18:41:15');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`vehicle_id`) USING BTREE,
  INDEX `idx_vehicle_type_status`(`vehicle_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_price`(`guide_price` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆基础信息表（含SKU字段）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_vehicle
-- ----------------------------
INSERT INTO `stad_vehicle` VALUES (1, 'new', '2025款 比亚迪汉 EV 冠军版 715km', '长续航+快充 汉EV冠军版到店', 219800.00, NULL, '冰川蓝', 5, 1, '比亚迪', '长续航,快充,智能驾驶', 1580, '1', '2026-03-01 10:00:00', '2026-03-01 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle` VALUES (2, 'new', '2025款 特斯拉 Model Y 长续航全轮驱动版', 'Model Y焕新版 零首付可提车', 299900.00, NULL, '珍珠白', 3, 1, '特斯拉', '智能驾驶,超大空间', 2340, '1', '2026-03-05 10:00:00', '2026-03-05 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle` VALUES (3, 'new', '2025款 蔚来 ES6 100kWh', '蔚来ES6 换电无忧 终身质保', 386000.00, NULL, '星空灰', 2, 1, '蔚来', '换电,终身质保', 1120, '1', '2026-03-10 10:00:00', '2026-03-10 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle` VALUES (4, 'new', '2025款 小鹏 P7i 702 Max', '小鹏P7i XNGP全场景智驾', 249900.00, NULL, '暗夜黑', 4, 1, '小鹏', 'XNGP智驾,丹拿音响', 980, '1', '2026-03-15 10:00:00', '2026-03-15 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle` VALUES (5, 'new', '2025款 理想 L7 Pro', '理想L7 家庭六座旗舰SUV', 339800.00, NULL, '银色', 2, 1, '理想', '增程式,家庭SUV,空气悬架', 1850, '1', '2026-03-20 10:00:00', '2026-03-20 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle` VALUES (6, 'new', '2025款 五菱宏光MINI EV 马卡龙', '城市代步首选 不到4万开回家', 39800.00, NULL, '柠檬黄', 10, 1, '五菱宏光', '城市代步,经济实惠', 3200, '1', '2026-03-25 10:00:00', '2026-03-25 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle` VALUES (7, 'used', '2022款 比亚迪汉 EV 创世版', '精品二手汉EV 电池健康95%', 158000.00, 239800.00, '白色', 1, 1, '比亚迪', '精品车况,电池健康', 680, '1', '2026-04-01 10:00:00', '2026-04-01 10:00:00', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle` VALUES (8, 'used', '2023款 特斯拉 Model 3 后驱版', '二手Model 3 2.5万公里 准新车', 198000.00, 269900.00, '黑色', 1, 1, '特斯拉', '准新车,FSD', 890, '1', '2026-04-05 10:00:00', '2026-04-05 10:00:00', 'admin', NULL, 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`plan_id`) USING BTREE,
  INDEX `idx_vehicle_id`(`vehicle_id` ASC) USING BTREE,
  INDEX `idx_plan_type`(`plan_type` ASC) USING BTREE,
  CONSTRAINT `fk_finance_plan_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '金融方案表（全款+分期）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_vehicle_finance_plan
-- ----------------------------
INSERT INTO `stad_vehicle_finance_plan` VALUES (1, 1, 'full', '全款购车', 219800.00, NULL, NULL, NULL, NULL, NULL, 219800.00, '比亚迪汽车金融', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (2, 1, 'installment', '36期免息分期', NULL, 65940.00, 4274.00, 36, 0.00, 0.00, 219800.00, '比亚迪汽车金融', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (3, 1, 'installment', '60期低息分期', NULL, 43960.00, 3200.00, 60, 3.50, 25640.00, 245440.00, '中国银行', 1, 3, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (4, 2, 'full', '全款购车', 299900.00, NULL, NULL, NULL, NULL, NULL, 299900.00, '特斯拉金融', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (5, 2, 'installment', '48期标准分期', NULL, 89970.00, 4800.00, 48, 2.99, 16830.00, 316730.00, '招商银行', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (6, 3, 'full', '全款购车', 386000.00, NULL, NULL, NULL, NULL, NULL, 386000.00, '蔚来金融', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (7, 3, 'installment', 'BaaS电池租赁', NULL, 77200.00, 6500.00, 60, 2.50, 32000.00, 418000.00, '蔚来金融', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (8, 4, 'full', '全款购车', 249900.00, NULL, NULL, NULL, NULL, NULL, 249900.00, '小鹏金融', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (9, 4, 'installment', '36期免息分期', NULL, 74970.00, 4858.00, 36, 0.00, 0.00, 249900.00, '小鹏金融', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (10, 5, 'full', '全款购车', 339800.00, NULL, NULL, NULL, NULL, NULL, 339800.00, '理想金融', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (11, 5, 'installment', '48期低息分期', NULL, 101940.00, 5400.00, 48, 2.99, 19260.00, 359060.00, '平安银行', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (12, 6, 'full', '全款购车', 39800.00, NULL, NULL, NULL, NULL, NULL, 39800.00, '五菱金融', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (13, 6, 'installment', '12期免息分期', NULL, 19900.00, 1658.00, 12, 0.00, 0.00, 39800.00, '五菱金融', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (14, 7, 'full', '全款购车', 158000.00, NULL, NULL, NULL, NULL, NULL, 158000.00, '—', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (15, 7, 'installment', '24期分期', NULL, 47400.00, 4980.00, 24, 6.50, 8510.00, 166510.00, '平安银行', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (16, 8, 'full', '全款购车', 198000.00, NULL, NULL, NULL, NULL, NULL, 198000.00, '—', 1, 1, '2026-06-01 18:41:15', 'admin', NULL, 'admin');
INSERT INTO `stad_vehicle_finance_plan` VALUES (17, 8, 'installment', '24期分期', NULL, 59400.00, 6250.00, 24, 6.50, 10690.00, 208690.00, '招商银行', 1, 2, '2026-06-01 18:41:15', 'admin', NULL, 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`review_id`) USING BTREE,
  INDEX `fk_vehicle_review_vehicle`(`vehicle_id` ASC) USING BTREE,
  INDEX `fk_vehicle_review_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_vehicle_review_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆评价表（单图）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_vehicle_review
-- ----------------------------
INSERT INTO `stad_vehicle_review` VALUES (1, 1, 2, 1, 5, '比亚迪汉EV真的不错，续航很实，高速上实际能跑650km左右，刀片电池安全放心，智能驾驶辅助在高速上很好用！', NULL, 0, '0', '2026-05-01 10:00:00', 'admin', 'admin');
INSERT INTO `stad_vehicle_review` VALUES (2, 2, 3, 2, 4, 'Model Y空间真的大，家用完全够了。自动驾驶在市区一般般，但高速很稳。唯一不足是悬挂偏硬。', '/upload/review/rev_001.jpg', 0, '0', '2026-05-10 10:00:00', 'admin', 'admin');
INSERT INTO `stad_vehicle_review` VALUES (3, 6, 2, NULL, 5, '给老婆买的代步车，好停车、充电方便，每天上下班来回15公里，一周充一次电就够了，太省钱了！', NULL, 0, '0', '2026-05-15 10:00:00', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`spec_id`) USING BTREE,
  INDEX `fk_vehicle_spec_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_vehicle_spec_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆配置参数表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_vehicle_spec
-- ----------------------------
INSERT INTO `stad_vehicle_spec` VALUES (1, 1, 715, 85.4, 0.4, 11.5, 2025, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_spec` VALUES (2, 2, 688, 78.4, 0.3, 10.0, 2025, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_spec` VALUES (3, 3, 625, 100.0, 0.5, 14.0, 2025, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_spec` VALUES (4, 4, 702, 86.2, 0.5, 12.0, 2025, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_spec` VALUES (5, 5, 1315, 42.8, NULL, 6.5, 2025, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_spec` VALUES (6, 6, 170, 13.9, NULL, 6.5, 2025, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_spec` VALUES (7, 7, 605, 76.9, 0.5, 11.0, 2022, '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_spec` VALUES (8, 8, 556, 60.0, 0.3, 8.0, 2023, '2026-06-01 18:41:15', 'admin', 'admin');

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`used_id`) USING BTREE,
  INDEX `fk_vehicle_used_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_vehicle_used_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `stad_vehicle` (`vehicle_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '二手车信息表（含电池+估价）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_vehicle_used
-- ----------------------------
INSERT INTO `stad_vehicle_used` VALUES (1, 7, 2022, 6, '济南市', 4.2, 1, 95.00, 180, 'excellent', '电池健康度95%，循环180次，内阻正常，压差3mV，状态优秀', 158000.00, '2022款汉EV创世版，同年份市场均价16万，车况优秀估值15.8万', '2026-06-01 18:41:15', 'admin', 'admin');
INSERT INTO `stad_vehicle_used` VALUES (2, 8, 2023, 3, '青岛市', 2.5, 0, 97.50, 110, 'excellent', '电池健康度97.5%，循环110次，内阻正常，压差2mV，接近新车状态', 198000.00, '2023款Model 3后驱版，准新车，同年份市场均价20万，估值19.8万', '2026-06-01 18:41:15', 'admin', 'admin');

-- ----------------------------
-- Table structure for stad_wallet
-- ----------------------------
DROP TABLE IF EXISTS `stad_wallet`;
CREATE TABLE `stad_wallet`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '余额',
  `total_recharge` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '累计充值',
  `total_withdraw` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '累计提现',
  `freeze_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '冻结金额',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id_wallet`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stad_wallet
-- ----------------------------
INSERT INTO `stad_wallet` VALUES (1, 1, 1600.00, 3801.00, 2201.00, 0.00, '2026-06-08 22:51:45', '2026-06-09 21:12:17');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (9, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', '2026-05-28 18:11:25', '', NULL, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-28 18:11:24', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-05-28 18:11:25', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 437 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-28 18:35:44');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-28 18:35:59');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-28 20:07:42');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码已失效', '2026-05-28 22:45:45');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-28 22:45:49');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-28 23:09:22');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-28 23:15:17');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码已失效', '2026-05-29 00:11:21');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 00:11:25');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 00:46:10');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'TraeCN 1.107.1', 'Windows 10.0', '0', '登录成功', '2026-05-29 01:59:09');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 10:42:47');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码错误', '2026-05-29 11:26:23');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 11:26:26');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 11:44:10');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 13:42:17');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 16:21:17');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 16:57:01');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-29 17:30:09');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-01 20:32:34');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-01 21:13:33');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-01 22:20:38');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '退出成功', '2026-06-01 22:51:33');
INSERT INTO `sys_logininfor` VALUES (123, 'maintainc', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-01 22:51:45');
INSERT INTO `sys_logininfor` VALUES (124, 'maintainc', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '退出成功', '2026-06-01 22:51:50');
INSERT INTO `sys_logininfor` VALUES (125, 'merchantc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码已失效', '2026-06-01 23:01:54');
INSERT INTO `sys_logininfor` VALUES (126, 'merchantc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码错误', '2026-06-01 23:01:55');
INSERT INTO `sys_logininfor` VALUES (127, 'merchantc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '用户不存在/密码错误', '2026-06-01 23:01:58');
INSERT INTO `sys_logininfor` VALUES (128, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-01 23:02:07');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-01 23:29:38');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '退出成功', '2026-06-01 23:29:48');
INSERT INTO `sys_logininfor` VALUES (131, 'merchantc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '用户不存在/密码错误', '2026-06-01 23:29:56');
INSERT INTO `sys_logininfor` VALUES (132, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-01 23:30:08');
INSERT INTO `sys_logininfor` VALUES (133, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '退出成功', '2026-06-01 23:30:20');
INSERT INTO `sys_logininfor` VALUES (134, 'maintainc', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-02 16:52:55');
INSERT INTO `sys_logininfor` VALUES (135, 'maintainc', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '退出成功', '2026-06-02 16:53:07');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-02 16:53:14');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:01:20');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '退出成功', '2026-06-02 17:01:38');
INSERT INTO `sys_logininfor` VALUES (139, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:01:49');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '退出成功', '2026-06-02 17:07:36');
INSERT INTO `sys_logininfor` VALUES (141, 'common', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-02 17:07:39');
INSERT INTO `sys_logininfor` VALUES (142, 'common', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-02 17:07:44');
INSERT INTO `sys_logininfor` VALUES (143, 'common', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-02 17:08:35');
INSERT INTO `sys_logininfor` VALUES (144, 'business', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-02 17:08:48');
INSERT INTO `sys_logininfor` VALUES (145, 'ry', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-02 17:09:07');
INSERT INTO `sys_logininfor` VALUES (146, 'ry', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '退出成功', '2026-06-02 17:09:36');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-02 17:09:41');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-02 17:09:50');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:12:10');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:13:05');
INSERT INTO `sys_logininfor` VALUES (151, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:13:43');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:15:24');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:16:06');
INSERT INTO `sys_logininfor` VALUES (154, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码错误', '2026-06-02 17:16:28');
INSERT INTO `sys_logininfor` VALUES (155, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:16:31');
INSERT INTO `sys_logininfor` VALUES (156, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:17:03');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 17:36:16');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-02 17:40:53');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.8457', 'Windows 10.0', '1', '验证码已失效', '2026-06-02 18:08:10');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-02 19:45:04');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 21:07:18');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 21:15:00');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 21:21:45');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 22:21:06');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 22:34:34');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 22:44:02');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '退出成功', '2026-06-02 22:56:09');
INSERT INTO `sys_logininfor` VALUES (168, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 22:56:19');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-02 23:02:52');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 23:37:49');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 23:45:02');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码错误', '2026-06-02 23:49:57');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 23:50:00');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 23:58:58');
INSERT INTO `sys_logininfor` VALUES (175, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-02 23:59:18');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 00:14:49');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 00:16:06');
INSERT INTO `sys_logininfor` VALUES (178, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 00:16:26');
INSERT INTO `sys_logininfor` VALUES (179, 'merchantc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码错误', '2026-06-03 00:32:45');
INSERT INTO `sys_logininfor` VALUES (180, 'merchantc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '用户不存在/密码错误', '2026-06-03 00:32:48');
INSERT INTO `sys_logininfor` VALUES (181, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 00:32:56');
INSERT INTO `sys_logininfor` VALUES (182, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码错误', '2026-06-03 00:37:55');
INSERT INTO `sys_logininfor` VALUES (183, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 00:37:56');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 00:41:36');
INSERT INTO `sys_logininfor` VALUES (185, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 00:42:23');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-03 01:24:43');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 01:53:07');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:02:51');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:16:19');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:23:34');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码已失效', '2026-06-03 02:35:55');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:35:58');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:42:24');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:53:58');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:54:07');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:58:50');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 02:59:45');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 03:11:06');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 03:12:52');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-03 17:44:40');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 17:48:20');
INSERT INTO `sys_logininfor` VALUES (202, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 17:48:47');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:04:04');
INSERT INTO `sys_logininfor` VALUES (204, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:04:22');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-03 18:13:53');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:36:04');
INSERT INTO `sys_logininfor` VALUES (207, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码已失效', '2026-06-03 18:38:27');
INSERT INTO `sys_logininfor` VALUES (208, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:38:30');
INSERT INTO `sys_logininfor` VALUES (209, 'charge_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '用户不存在/密码错误', '2026-06-03 18:41:29');
INSERT INTO `sys_logininfor` VALUES (210, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:41:40');
INSERT INTO `sys_logininfor` VALUES (211, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:54:09');
INSERT INTO `sys_logininfor` VALUES (212, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:58:51');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 18:59:13');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 19:01:37');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 19:09:12');
INSERT INTO `sys_logininfor` VALUES (216, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 19:13:27');
INSERT INTO `sys_logininfor` VALUES (217, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 19:16:01');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码已失效', '2026-06-03 19:31:42');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 19:31:43');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码已失效', '2026-06-03 22:53:32');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 22:53:34');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 22:55:06');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-03 23:41:15');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码已失效', '2026-06-04 18:32:40');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码已失效', '2026-06-04 18:37:23');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-04 18:37:24');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-04 18:39:26');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-04 18:44:58');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 19:03:28');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-04 19:11:47');
INSERT INTO `sys_logininfor` VALUES (231, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-04 19:12:07');
INSERT INTO `sys_logininfor` VALUES (232, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-04 19:13:11');
INSERT INTO `sys_logininfor` VALUES (233, 'charger_c', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '用户不存在/密码错误', '2026-06-04 19:13:44');
INSERT INTO `sys_logininfor` VALUES (234, 'charger_c', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '用户不存在/密码错误', '2026-06-04 19:13:47');
INSERT INTO `sys_logininfor` VALUES (235, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 19:13:52');
INSERT INTO `sys_logininfor` VALUES (236, 'dealer_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '用户不存在/密码错误', '2026-06-04 19:18:26');
INSERT INTO `sys_logininfor` VALUES (237, 'dealer_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '用户不存在/密码错误', '2026-06-04 19:18:29');
INSERT INTO `sys_logininfor` VALUES (238, 'dealer_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码错误', '2026-06-04 19:18:31');
INSERT INTO `sys_logininfor` VALUES (239, 'dealer_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '用户不存在/密码错误', '2026-06-04 19:18:34');
INSERT INTO `sys_logininfor` VALUES (240, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 19:18:40');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-04 19:41:56');
INSERT INTO `sys_logininfor` VALUES (242, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 20:23:59');
INSERT INTO `sys_logininfor` VALUES (243, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 20:24:28');
INSERT INTO `sys_logininfor` VALUES (244, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 20:24:42');
INSERT INTO `sys_logininfor` VALUES (245, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 20:26:24');
INSERT INTO `sys_logininfor` VALUES (246, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 20:27:35');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 21:06:07');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 21:07:35');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-04 21:42:33');
INSERT INTO `sys_logininfor` VALUES (250, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 21:47:07');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-04 22:36:08');
INSERT INTO `sys_logininfor` VALUES (252, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码已失效', '2026-06-05 21:20:51');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 21:20:53');
INSERT INTO `sys_logininfor` VALUES (254, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码错误', '2026-06-05 21:21:36');
INSERT INTO `sys_logininfor` VALUES (255, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-05 21:21:40');
INSERT INTO `sys_logininfor` VALUES (256, 'charger_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '用户不存在/密码错误', '2026-06-05 21:22:47');
INSERT INTO `sys_logininfor` VALUES (257, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 21:22:55');
INSERT INTO `sys_logininfor` VALUES (258, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 21:28:51');
INSERT INTO `sys_logininfor` VALUES (259, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 21:33:16');
INSERT INTO `sys_logininfor` VALUES (260, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 21:35:56');
INSERT INTO `sys_logininfor` VALUES (261, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 21:50:49');
INSERT INTO `sys_logininfor` VALUES (262, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 21:51:15');
INSERT INTO `sys_logininfor` VALUES (263, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 22:22:52');
INSERT INTO `sys_logininfor` VALUES (264, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 22:24:04');
INSERT INTO `sys_logininfor` VALUES (265, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 22:25:05');
INSERT INTO `sys_logininfor` VALUES (266, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码错误', '2026-06-05 22:46:30');
INSERT INTO `sys_logininfor` VALUES (267, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 22:46:35');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-05 23:46:10');
INSERT INTO `sys_logininfor` VALUES (269, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 00:20:11');
INSERT INTO `sys_logininfor` VALUES (270, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-06 01:41:06');
INSERT INTO `sys_logininfor` VALUES (271, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 01:42:20');
INSERT INTO `sys_logininfor` VALUES (272, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 01:44:01');
INSERT INTO `sys_logininfor` VALUES (273, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 01:44:26');
INSERT INTO `sys_logininfor` VALUES (274, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 01:47:16');
INSERT INTO `sys_logininfor` VALUES (275, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 01:47:49');
INSERT INTO `sys_logininfor` VALUES (276, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 01:51:31');
INSERT INTO `sys_logininfor` VALUES (277, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码已失效', '2026-06-06 02:28:13');
INSERT INTO `sys_logininfor` VALUES (278, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 02:28:15');
INSERT INTO `sys_logininfor` VALUES (279, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 02:30:05');
INSERT INTO `sys_logininfor` VALUES (280, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 02:31:56');
INSERT INTO `sys_logininfor` VALUES (281, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 02:42:07');
INSERT INTO `sys_logininfor` VALUES (282, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-06 03:00:21');
INSERT INTO `sys_logininfor` VALUES (283, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 03:00:38');
INSERT INTO `sys_logininfor` VALUES (284, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 03:14:12');
INSERT INTO `sys_logininfor` VALUES (285, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 03:21:42');
INSERT INTO `sys_logininfor` VALUES (286, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 11:59:00');
INSERT INTO `sys_logininfor` VALUES (287, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 12:00:01');
INSERT INTO `sys_logininfor` VALUES (288, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 12:00:26');
INSERT INTO `sys_logininfor` VALUES (289, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 12:12:33');
INSERT INTO `sys_logininfor` VALUES (290, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 12:13:13');
INSERT INTO `sys_logininfor` VALUES (291, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 12:14:02');
INSERT INTO `sys_logininfor` VALUES (292, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 12:19:00');
INSERT INTO `sys_logininfor` VALUES (293, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 12:25:55');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码已失效', '2026-06-06 12:30:22');
INSERT INTO `sys_logininfor` VALUES (295, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-06 12:30:28');
INSERT INTO `sys_logininfor` VALUES (296, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-06 18:06:33');
INSERT INTO `sys_logininfor` VALUES (297, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 18:24:12');
INSERT INTO `sys_logininfor` VALUES (298, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 18:24:53');
INSERT INTO `sys_logininfor` VALUES (299, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 18:37:56');
INSERT INTO `sys_logininfor` VALUES (300, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 18:53:34');
INSERT INTO `sys_logininfor` VALUES (301, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 19:03:07');
INSERT INTO `sys_logininfor` VALUES (302, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 19:06:38');
INSERT INTO `sys_logininfor` VALUES (303, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码错误', '2026-06-06 19:16:41');
INSERT INTO `sys_logininfor` VALUES (304, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 19:16:45');
INSERT INTO `sys_logininfor` VALUES (305, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 19:47:50');
INSERT INTO `sys_logininfor` VALUES (306, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 19:48:05');
INSERT INTO `sys_logininfor` VALUES (307, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-06-06 19:56:02');
INSERT INTO `sys_logininfor` VALUES (308, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 20:05:34');
INSERT INTO `sys_logininfor` VALUES (309, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 20:14:01');
INSERT INTO `sys_logininfor` VALUES (310, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 20:28:33');
INSERT INTO `sys_logininfor` VALUES (311, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 20:51:52');
INSERT INTO `sys_logininfor` VALUES (312, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 20:53:26');
INSERT INTO `sys_logininfor` VALUES (313, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 21:04:38');
INSERT INTO `sys_logininfor` VALUES (314, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 21:07:25');
INSERT INTO `sys_logininfor` VALUES (315, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 21:13:15');
INSERT INTO `sys_logininfor` VALUES (316, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-06 21:53:41');
INSERT INTO `sys_logininfor` VALUES (317, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-06 21:59:19');
INSERT INTO `sys_logininfor` VALUES (318, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 22:19:59');
INSERT INTO `sys_logininfor` VALUES (319, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 22:41:20');
INSERT INTO `sys_logininfor` VALUES (320, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码已失效', '2026-06-06 23:04:48');
INSERT INTO `sys_logininfor` VALUES (321, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 23:04:53');
INSERT INTO `sys_logininfor` VALUES (322, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 23:33:02');
INSERT INTO `sys_logininfor` VALUES (323, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 23:33:23');
INSERT INTO `sys_logininfor` VALUES (324, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 23:44:11');
INSERT INTO `sys_logininfor` VALUES (325, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-06 23:49:30');
INSERT INTO `sys_logininfor` VALUES (326, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 00:25:11');
INSERT INTO `sys_logininfor` VALUES (327, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 00:32:57');
INSERT INTO `sys_logininfor` VALUES (328, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 00:38:25');
INSERT INTO `sys_logininfor` VALUES (329, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 00:45:40');
INSERT INTO `sys_logininfor` VALUES (330, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 00:51:23');
INSERT INTO `sys_logininfor` VALUES (331, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 00:58:51');
INSERT INTO `sys_logininfor` VALUES (332, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:02:13');
INSERT INTO `sys_logininfor` VALUES (333, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:12:41');
INSERT INTO `sys_logininfor` VALUES (334, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:13:11');
INSERT INTO `sys_logininfor` VALUES (335, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:23:04');
INSERT INTO `sys_logininfor` VALUES (336, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:27:13');
INSERT INTO `sys_logininfor` VALUES (337, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:31:16');
INSERT INTO `sys_logininfor` VALUES (338, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:33:51');
INSERT INTO `sys_logininfor` VALUES (339, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:39:02');
INSERT INTO `sys_logininfor` VALUES (340, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:46:46');
INSERT INTO `sys_logininfor` VALUES (341, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 01:49:53');
INSERT INTO `sys_logininfor` VALUES (342, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '验证码已失效', '2026-06-07 20:45:40');
INSERT INTO `sys_logininfor` VALUES (343, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-07 20:45:40');
INSERT INTO `sys_logininfor` VALUES (344, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 20:46:22');
INSERT INTO `sys_logininfor` VALUES (345, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 21:55:02');
INSERT INTO `sys_logininfor` VALUES (346, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-07 21:55:47');
INSERT INTO `sys_logininfor` VALUES (347, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-07 22:23:57');
INSERT INTO `sys_logininfor` VALUES (348, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 14:59:56');
INSERT INTO `sys_logininfor` VALUES (349, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-08 15:00:39');
INSERT INTO `sys_logininfor` VALUES (350, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 15:11:48');
INSERT INTO `sys_logininfor` VALUES (351, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 15:19:11');
INSERT INTO `sys_logininfor` VALUES (352, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 15:33:35');
INSERT INTO `sys_logininfor` VALUES (353, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 15:35:54');
INSERT INTO `sys_logininfor` VALUES (354, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码已失效', '2026-06-08 15:45:56');
INSERT INTO `sys_logininfor` VALUES (355, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 15:45:59');
INSERT INTO `sys_logininfor` VALUES (356, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 18:09:39');
INSERT INTO `sys_logininfor` VALUES (357, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 18:16:26');
INSERT INTO `sys_logininfor` VALUES (358, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 18:18:43');
INSERT INTO `sys_logininfor` VALUES (359, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 19:17:38');
INSERT INTO `sys_logininfor` VALUES (360, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-08 19:19:08');
INSERT INTO `sys_logininfor` VALUES (361, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 19:32:15');
INSERT INTO `sys_logininfor` VALUES (362, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 19:51:06');
INSERT INTO `sys_logininfor` VALUES (363, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 19:55:10');
INSERT INTO `sys_logininfor` VALUES (364, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 19:59:20');
INSERT INTO `sys_logininfor` VALUES (365, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 20:05:03');
INSERT INTO `sys_logininfor` VALUES (366, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 20:34:25');
INSERT INTO `sys_logininfor` VALUES (367, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 20:44:04');
INSERT INTO `sys_logininfor` VALUES (368, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 20:50:15');
INSERT INTO `sys_logininfor` VALUES (369, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 21:09:51');
INSERT INTO `sys_logininfor` VALUES (370, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 21:24:11');
INSERT INTO `sys_logininfor` VALUES (371, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码已失效', '2026-06-08 21:55:09');
INSERT INTO `sys_logininfor` VALUES (372, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 21:55:15');
INSERT INTO `sys_logininfor` VALUES (373, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 22:10:31');
INSERT INTO `sys_logininfor` VALUES (374, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 22:10:58');
INSERT INTO `sys_logininfor` VALUES (375, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 22:11:10');
INSERT INTO `sys_logininfor` VALUES (376, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 22:15:01');
INSERT INTO `sys_logininfor` VALUES (377, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 22:31:21');
INSERT INTO `sys_logininfor` VALUES (378, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码错误', '2026-06-08 22:31:31');
INSERT INTO `sys_logininfor` VALUES (379, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 22:31:35');
INSERT INTO `sys_logininfor` VALUES (380, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-08 22:36:10');
INSERT INTO `sys_logininfor` VALUES (381, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-09 00:26:33');
INSERT INTO `sys_logininfor` VALUES (382, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-09 00:26:47');
INSERT INTO `sys_logininfor` VALUES (383, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-09 00:27:00');
INSERT INTO `sys_logininfor` VALUES (384, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '1', '验证码错误', '2026-06-09 00:27:13');
INSERT INTO `sys_logininfor` VALUES (385, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-06-09 00:27:18');
INSERT INTO `sys_logininfor` VALUES (386, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-09 00:33:26');
INSERT INTO `sys_logininfor` VALUES (387, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码已失效', '2026-06-09 00:44:46');
INSERT INTO `sys_logininfor` VALUES (388, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 00:44:48');
INSERT INTO `sys_logininfor` VALUES (389, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:12:54');
INSERT INTO `sys_logininfor` VALUES (390, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:15:31');
INSERT INTO `sys_logininfor` VALUES (391, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:15:44');
INSERT INTO `sys_logininfor` VALUES (392, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:16:43');
INSERT INTO `sys_logininfor` VALUES (393, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:17:08');
INSERT INTO `sys_logininfor` VALUES (394, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:18:04');
INSERT INTO `sys_logininfor` VALUES (395, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:20:06');
INSERT INTO `sys_logininfor` VALUES (396, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:20:38');
INSERT INTO `sys_logininfor` VALUES (397, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:21:13');
INSERT INTO `sys_logininfor` VALUES (398, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:28:26');
INSERT INTO `sys_logininfor` VALUES (399, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:29:12');
INSERT INTO `sys_logininfor` VALUES (400, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:29:54');
INSERT INTO `sys_logininfor` VALUES (401, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '1', '验证码错误', '2026-06-09 01:33:56');
INSERT INTO `sys_logininfor` VALUES (402, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:33:59');
INSERT INTO `sys_logininfor` VALUES (403, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:41:37');
INSERT INTO `sys_logininfor` VALUES (404, 'charger_b', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:42:26');
INSERT INTO `sys_logininfor` VALUES (405, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:43:46');
INSERT INTO `sys_logininfor` VALUES (406, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-09 01:45:47');
INSERT INTO `sys_logininfor` VALUES (407, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:56:06');
INSERT INTO `sys_logininfor` VALUES (408, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 01:56:45');
INSERT INTO `sys_logininfor` VALUES (409, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:02:57');
INSERT INTO `sys_logininfor` VALUES (410, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:09:22');
INSERT INTO `sys_logininfor` VALUES (411, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:09:41');
INSERT INTO `sys_logininfor` VALUES (412, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:11:44');
INSERT INTO `sys_logininfor` VALUES (413, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:18:24');
INSERT INTO `sys_logininfor` VALUES (414, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:26:00');
INSERT INTO `sys_logininfor` VALUES (415, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:32:07');
INSERT INTO `sys_logininfor` VALUES (416, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 02:53:13');
INSERT INTO `sys_logininfor` VALUES (417, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-09 14:44:21');
INSERT INTO `sys_logininfor` VALUES (418, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 14:44:48');
INSERT INTO `sys_logininfor` VALUES (419, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 14:46:05');
INSERT INTO `sys_logininfor` VALUES (420, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 15:27:56');
INSERT INTO `sys_logininfor` VALUES (421, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 15:41:26');
INSERT INTO `sys_logininfor` VALUES (422, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 15:42:18');
INSERT INTO `sys_logininfor` VALUES (423, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 15:44:02');
INSERT INTO `sys_logininfor` VALUES (424, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-09 15:52:05');
INSERT INTO `sys_logininfor` VALUES (425, 'maintainc', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 15:52:37');
INSERT INTO `sys_logininfor` VALUES (426, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 15:59:26');
INSERT INTO `sys_logininfor` VALUES (427, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 16:00:26');
INSERT INTO `sys_logininfor` VALUES (428, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 16:06:42');
INSERT INTO `sys_logininfor` VALUES (429, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 18:12:41');
INSERT INTO `sys_logininfor` VALUES (430, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 18:15:47');
INSERT INTO `sys_logininfor` VALUES (431, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 18:18:17');
INSERT INTO `sys_logininfor` VALUES (432, 'dealer_a', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 19:22:51');
INSERT INTO `sys_logininfor` VALUES (433, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 20:01:12');
INSERT INTO `sys_logininfor` VALUES (434, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 20:55:48');
INSERT INTO `sys_logininfor` VALUES (435, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 21:10:50');
INSERT INTO `sys_logininfor` VALUES (436, 'admin', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 17.0.3', '0', '登录成功', '2026-06-09 22:16:53');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2813 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-05-28 18:11:25', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-05-28 18:11:25', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-05-28 18:11:25', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'C', '0', '0', '', 'guide', 'admin', '2026-05-28 18:11:25', 'admin', '2026-06-02 18:19:02', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-05-28 18:11:25', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-05-28 18:11:25', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-05-28 18:11:25', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-05-28 18:11:25', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-05-28 18:11:25', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-05-28 18:11:25', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-05-28 18:11:25', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-05-28 18:11:25', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-05-28 18:11:25', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-05-28 18:11:25', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-05-28 18:11:25', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-05-28 18:11:25', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-05-28 18:11:25', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-05-28 18:11:25', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-05-28 18:11:25', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-05-28 18:11:25', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-05-28 18:11:25', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-05-28 18:11:25', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-05-28 18:11:25', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-05-28 18:11:25', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '新能源数据', 0, 4, 'dataScreen', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-05-28 20:09:00', 'admin', '2026-05-28 23:37:31', '');
INSERT INTO `sys_menu` VALUES (2001, '新能源数据大屏展示', 2000, 1, 'index', 'dataScreen/index', NULL, 'screen', 1, 0, 'C', '0', '0', NULL, 'chart', 'admin', '2026-05-28 23:42:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2100, '维保管理', 0, 5, 'maintenance', NULL, '', '', 1, 0, 'M', '0', '0', '', 'service', 'admin', '2026-06-01 21:20:19', '', NULL, '维保管理目录');
INSERT INTO `sys_menu` VALUES (2101, '维保门店', 2100, 1, 'shop', 'business/maintenance/shop/index', '', '', 1, 0, 'C', '0', '0', 'business:shop:list', 'tool', 'admin', '2026-06-01 21:20:19', '', NULL, '维保门店菜单');
INSERT INTO `sys_menu` VALUES (2102, '门店查询', 2101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2103, '门店新增', 2101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2104, '门店修改', 2101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2105, '门店删除', 2101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '维保订单', 2120, 2, 'morder', 'business/maintenance/order/index', '', '', 1, 0, 'C', '0', '0', 'business:morder:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '维保订单菜单');
INSERT INTO `sys_menu` VALUES (2111, '订单查询', 2110, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '订单新增', 2110, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '订单修改', 2110, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '订单删除', 2110, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '订单管理', 0, 6, 'unified', NULL, '', '', 1, 0, 'M', '0', '0', '', 'order', 'admin', '2026-06-01 21:20:19', '', NULL, '订单管理目录');
INSERT INTO `sys_menu` VALUES (2121, '购车订单', 2120, 1, 'uorder', 'business/unified/order/index', '', '', 1, 0, 'C', '0', '0', 'business:uorder:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '购车订单菜单');
INSERT INTO `sys_menu` VALUES (2122, '订单查询', 2121, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2123, '订单新增', 2121, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2124, '订单修改', 2121, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2125, '订单删除', 2121, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2300, '车辆管理', 0, 7, 'vehicle', NULL, '', '', 1, 0, 'M', '0', '0', '', 'car', 'admin', '2026-06-01 21:20:19', '', NULL, '车辆管理目录');
INSERT INTO `sys_menu` VALUES (2301, '车辆信息', 2300, 1, 'vehicle', 'business/vehicle/index', '', '', 1, 0, 'C', '0', '0', 'business:vehicle:list', 'car', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2302, '车辆查询', 2301, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2303, '车辆新增', 2301, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2304, '车辆修改', 2301, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2305, '车辆删除', 2301, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2311, '车辆规格', 2300, 2, 'spec', 'business/vehiclespec/index', '', '', 1, 0, 'C', '0', '0', 'business:vehiclespec:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2312, '规格查询', 2311, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2313, '规格新增', 2311, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2314, '规格修改', 2311, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2315, '规格删除', 2311, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2321, '金融方案', 2300, 3, 'plan', 'business/financeplan/index', '', '', 1, 0, 'C', '0', '0', 'business:financeplan:list', 'money', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2322, '方案查询', 2321, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2323, '方案新增', 2321, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2324, '方案修改', 2321, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2325, '方案删除', 2321, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2331, '二手车管理', 2300, 4, 'used', 'business/vehicleused/index', '', '', 1, 0, 'C', '0', '0', 'business:vehicleused:list', 'table', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2332, '二手车查询', 2331, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2333, '二手车新增', 2331, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2334, '二手车修改', 2331, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2335, '二手车删除', 2331, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2341, '车辆评价', 2300, 5, 'review', 'business/vehiclereview/index', '', '', 1, 0, 'C', '0', '0', 'business:vehiclereview:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2342, '评价查询', 2341, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2343, '评价新增', 2341, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2344, '评价修改', 2341, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2345, '评价删除', 2341, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2400, '充电管理', 0, 8, 'charging', NULL, '', '', 1, 0, 'M', '0', '0', '', 'table', 'admin', '2026-06-01 21:20:19', '', NULL, '充电管理目录');
INSERT INTO `sys_menu` VALUES (2401, '充电站管理', 2400, 1, 'station', 'business/station/index', '', '', 1, 0, 'C', '0', '0', 'business:station:list', 'tree', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2402, '充电站查询', 2401, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2403, '充电站新增', 2401, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2404, '充电站修改', 2401, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2405, '充电站删除', 2401, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2411, '充电桩管理', 2400, 2, 'pile', 'business/chargingpile/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingpile:list', 'cascader', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2412, '充电桩查询', 2411, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2413, '充电桩新增', 2411, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2414, '充电桩修改', 2411, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2415, '充电桩删除', 2411, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2421, '充电费率', 2400, 3, 'rate', 'business/chargingrate/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingrate:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2422, '费率查询', 2421, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2423, '费率新增', 2421, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2424, '费率修改', 2421, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2425, '费率删除', 2421, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2431, '费率时段', 2400, 4, 'period', 'business/chargingrateperiod/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingrateperiod:list', 'date', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2432, '时段查询', 2431, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2433, '时段新增', 2431, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2434, '时段修改', 2431, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2435, '时段删除', 2431, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2441, '充电结算', 2400, 5, 'settlement', 'business/chargingsettlement/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingsettlement:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2442, '结算查询', 2441, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2443, '结算新增', 2441, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2444, '结算修改', 2441, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2445, '结算删除', 2441, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2451, '充电订单', 2120, 3, 'corder', 'business/order/index', '', '', 1, 0, 'C', '0', '0', 'business:order:list', 'order', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2452, '订单查询', 2451, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2453, '订单新增', 2451, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2454, '订单修改', 2451, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2455, '订单删除', 2451, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2500, '用户中心', 0, 9, 'user', NULL, '', '', 1, 0, 'M', '0', '0', '', 'user', 'admin', '2026-06-01 21:20:19', '', NULL, '用户中心目录');
INSERT INTO `sys_menu` VALUES (2501, '用户档案', 2500, 1, 'profile', 'business/profile/index', '', '', 1, 0, 'C', '0', '0', 'business:profile:list', 'user', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2502, '档案查询', 2501, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2503, '档案新增', 2501, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2504, '档案修改', 2501, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2505, '档案删除', 2501, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2511, '用户收藏', 2500, 2, 'favorite', 'business/favorite/index', '', '', 1, 0, 'C', '0', '0', 'business:favorite:list', 'star', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2512, '收藏查询', 2511, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2513, '收藏新增', 2511, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2514, '收藏修改', 2511, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2515, '收藏删除', 2511, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2521, '用户反馈', 2500, 3, 'feedback', 'business/feedback/index', '', '', 1, 0, 'C', '0', '0', 'business:feedback:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2522, '反馈查询', 2521, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2523, '反馈新增', 2521, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2524, '反馈修改', 2521, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2525, '反馈删除', 2521, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2531, '用户地址', 2500, 4, 'address', 'business/address/index', '', '', 1, 0, 'C', '0', '0', 'business:address:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2532, '地址查询', 2531, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2533, '地址新增', 2531, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2534, '地址修改', 2531, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2535, '地址删除', 2531, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2600, '碳积分管理', 0, 10, 'carbon', NULL, '', '', 1, 0, 'M', '0', '0', '', 'documentation', 'admin', '2026-06-01 21:20:19', '', NULL, '碳积分目录');
INSERT INTO `sys_menu` VALUES (2601, '碳积分流水', 2600, 1, 'ledger', 'business/carbonledger/index', '', '', 1, 0, 'C', '0', '0', 'business:carbonledger:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2602, '流水查询', 2601, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2603, '流水新增', 2601, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2604, '流水修改', 2601, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2605, '流水删除', 2601, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2611, '碳减排统计', 2600, 2, 'stats', 'business/carbonstatistics/index', '', '', 1, 0, 'C', '0', '0', 'business:carbonstatistics:list', 'chart', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2612, '统计查询', 2611, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2613, '统计新增', 2611, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2614, '统计修改', 2611, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2615, '统计删除', 2611, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2700, '政务管理', 0, 11, 'gov', NULL, '', '', 1, 0, 'M', '0', '0', '', 'guide', 'admin', '2026-06-01 21:20:19', '', NULL, '政务管理目录');
INSERT INTO `sys_menu` VALUES (2701, '上牌登记', 2700, 1, 'registration', 'business/govregistration/index', '', '', 1, 0, 'C', '0', '0', 'business:govregistration:list', 'form', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2702, '登记查询', 2701, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2703, '登记新增', 2701, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2704, '登记修改', 2701, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2705, '登记删除', 2701, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2800, '商户管理', 0, 12, 'merchant', NULL, '', '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', '2026-06-01 21:20:19', '', NULL, '商户管理目录');
INSERT INTO `sys_menu` VALUES (2801, '商户列表', 2800, 1, 'merchant', 'business/merchant/index', '', '', 1, 0, 'C', '0', '0', 'business:merchant:list', 'peoples', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2802, '商户查询', 2801, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:query', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2803, '商户新增', 2801, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:add', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2804, '商户修改', 2801, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:edit', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2805, '商户删除', 2801, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:remove', '#', 'admin', '2026-06-01 21:20:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2810, '商户审核', 2800, 2, 'audit', 'business/merchant/audit/index', '', '', 1, 0, 'C', '0', '0', 'business:merchant:audit', 'peoples', 'admin', '2026-06-02 18:02:38', '', NULL, '商户审核菜单');
INSERT INTO `sys_menu` VALUES (2811, '审核查询', 2810, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:audit', '#', 'admin', '2026-06-02 18:02:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2812, '审核操作', 2810, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:audit', '#', 'admin', '2026-06-02 18:02:38', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-05-28 18:11:26', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-05-28 18:11:26', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (3, '若依开源框架介绍', '1', 0x3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE9A1B9E79BAEE4BB8BE7BB8D3C2F7370616E3E3C2F703E3C703E3C666F6E7420636F6C6F723D2223333333333333223E52756F5969E5BC80E6BA90E9A1B9E79BAEE698AFE4B8BAE4BC81E4B89AE794A8E688B7E5AE9AE588B6E79A84E5908EE58FB0E8849AE6898BE69EB6E6A186E69EB6EFBC8CE4B8BAE4BC81E4B89AE68993E980A0E79A84E4B880E7AB99E5BC8FE8A7A3E586B3E696B9E6A188EFBC8CE9998DE4BD8EE4BC81E4B89AE5BC80E58F91E68890E69CACEFBC8CE68F90E58D87E5BC80E58F91E69588E78E87E38082E4B8BBE8A681E58C85E68BACE794A8E688B7E7AEA1E79086E38081E8A792E889B2E7AEA1E79086E38081E983A8E997A8E7AEA1E79086E38081E88F9CE58D95E7AEA1E79086E38081E58F82E695B0E7AEA1E79086E38081E5AD97E585B8E7AEA1E79086E380813C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE5B297E4BD8DE7AEA1E790863C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E5AE9AE697B6E4BBBBE58AA13C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE380813C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE69C8DE58AA1E79B91E68EA7E38081E799BBE5BD95E697A5E5BF97E38081E6938DE4BD9CE697A5E5BF97E38081E4BBA3E7A081E7949FE68890E7AD89E58A9FE883BDE38082E585B6E4B8ADEFBC8CE8BF98E694AFE68C81E5A49AE695B0E68DAEE6BA90E38081E695B0E68DAEE69D83E99990E38081E59BBDE99985E58C96E380815265646973E7BC93E5AD98E38081446F636B6572E983A8E7BDB2E38081E6BB91E58AA8E9AA8CE8AF81E7A081E38081E7ACACE4B889E696B9E8AEA4E8AF81E799BBE5BD95E38081E58886E5B883E5BC8FE4BA8BE58AA1E380813C2F7370616E3E3C666F6E7420636F6C6F723D2223333333333333223EE58886E5B883E5BC8FE69687E4BBB6E5AD98E582A83C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E58886E5BA93E58886E8A1A8E5A484E79086E7AD89E68A80E69CAFE789B9E782B9E380823C2F7370616E3E3C2F703E3C703E3C696D67207372633D2268747470733A2F2F666F727564612E67697465652E636F6D2F696D616765732F313737333933313834383334323433393033322F61346432323331335F313831353039352E706E6722207374796C653D2277696474683A20363470783B223E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE5AE98E7BD91E58F8AE6BC94E7A4BA3C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE5AE98E7BD91E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F72756F79692E7669703C2F613E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E3C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE69687E6A1A3E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F646F632E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F646F632E72756F79692E7669703C2F613E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E4B88DE58886E7A6BBE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F64656D6F2E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F64656D6F2E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E58886E7A6BBE78988E69CACE38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F7675652E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F7675652E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E5BEAEE69C8DE58AA1E78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F636C6F75642E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F636C6F75642E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E7A7BBE58AA8E7ABAFE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F68352E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F68352E72756F79692E7669703C2F613E3C2F703E3C703E3C6272207374796C653D22636F6C6F723A207267622834382C2034392C203531293B20666F6E742D66616D696C793A202671756F743B48656C766574696361204E6575652671756F743B2C2048656C7665746963612C20417269616C2C2073616E732D73657269663B20666F6E742D73697A653A20313270783B223E3C2F703E, '0', 'admin', '2026-05-28 18:11:26', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":100,\"roleKey\":\"business\",\"roleName\":\"商户\",\"roleSort\":3,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 18:47:16', 74);
INSERT INTO `sys_oper_log` VALUES (101, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-05-28 18:47:16\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,4],\"params\":{},\"roleId\":100,\"roleKey\":\"business\",\"roleName\":\"商户\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 18:47:36', 59);
INSERT INTO `sys_oper_log` VALUES (102, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,4],\"params\":{},\"roleId\":101,\"roleKey\":\"charger\",\"roleName\":\"充电运营商\",\"roleSort\":4,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 18:48:07', 103);
INSERT INTO `sys_oper_log` VALUES (103, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,4],\"params\":{},\"roleId\":102,\"roleKey\":\"maintenance\",\"roleName\":\"维保商\",\"roleSort\":5,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 18:48:33', 37);
INSERT INTO `sys_oper_log` VALUES (104, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,4],\"params\":{},\"roleId\":103,\"roleKey\":\"government\",\"roleName\":\"政府\",\"roleSort\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 18:49:04', 43);
INSERT INTO `sys_oper_log` VALUES (105, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-05-28 18:49:04\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,4],\"params\":{},\"roleId\":103,\"roleKey\":\"government\",\"roleName\":\"政府监管\",\"roleSort\":6,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 18:49:18', 33);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新能源数据大屏\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"data-screen\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 20:09:00', 26);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-05-28 20:09:00\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"新能源数据\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"data-screen\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 23:05:13', 35);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-05-28 20:09:00\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"新能源数据\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"dataScreen\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 23:05:47', 22);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-05-28 20:09:00\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"新能源数据\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"/dataScreen\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 23:32:21', 54);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-05-28 20:09:00\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"新能源数据\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"dataScreen\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 23:37:31', 20);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"dataScreen/index\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新能源数据大屏展示\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"index\",\"routeName\":\"DataScreen\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"新增菜单\'新能源数据大屏展示\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-05-28 23:42:01', 38);
INSERT INTO `sys_oper_log` VALUES (112, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"dataScreen/index\",\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新能源数据大屏展示\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"index\",\"routeName\":\"screen\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 23:42:16', 29);
INSERT INTO `sys_oper_log` VALUES (113, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-06-02 18:18:48', 25);
INSERT INTO `sys_oper_log` VALUES (114, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-05-28 18:11:25\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-02 18:19:02', 37);
INSERT INTO `sys_oper_log` VALUES (115, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-06-02 18:19:04', 10);
INSERT INTO `sys_oper_log` VALUES (116, '收货地址管理', 1, 'com.ruoyi.web.controller.business.StadUserAddressController.add()', 'POST', 1, 'admin', '研发部门', '/business/address', '127.0.0.1', '内网IP', '{\"addressId\":4,\"city\":\"3\",\"contactName\":\"2\",\"contactPhone\":\"23\",\"createBy\":\"admin\",\"detail\":\"3\",\"district\":\"3\",\"isDefault\":0,\"params\":{},\"province\":\"3\",\"userId\":4} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-06 18:10:27', 36);
INSERT INTO `sys_oper_log` VALUES (117, '收货地址管理', 3, 'com.ruoyi.web.controller.business.StadUserAddressController.remove()', 'DELETE', 1, 'admin', '研发部门', '/business/address/4', '127.0.0.1', '内网IP', '[4] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-06 18:10:30', 26);
INSERT INTO `sys_oper_log` VALUES (118, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"stad_vehicle_spec,stad_unified_order,stad_user_favorite,stad_user_feedback,stad_user_profile,stad_vehicle_finance_plan,stad_vehicle_review,stad_vehicle_used,stad_carbon_statistics,stad_charging_order,stad_charging_pile,stad_charging_rate,stad_charging_rate_period,stad_charging_settlement,stad_charging_station,stad_gov_nev_registration,stad_maintenance_order,stad_maintenance_shop,stad_merchant,stad_user_address,stad_vehicle,stad_carbon_ledger,sys_user\",\"tplWebType\":\"element-ui\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-06 20:59:18', 568);
INSERT INTO `sys_oper_log` VALUES (119, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/06/06/fb976df9d294453e896598d41620066e.jpg\",\"code\":200}', 0, NULL, '2026-06-06 21:03:14', 159);
INSERT INTO `sys_oper_log` VALUES (120, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'maintainc', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/06/09/4a4ae1b348e44165b70be581e74b7340.jpg\",\"code\":200}', 0, NULL, '2026-06-09 01:42:11', 124);
INSERT INTO `sys_oper_log` VALUES (121, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'charger_b', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/06/09/b6a881ce5f61466da8cb05e4d21e53bd.jpg\",\"code\":200}', 0, NULL, '2026-06-09 01:43:25', 12);
INSERT INTO `sys_oper_log` VALUES (122, '维保订单管理', 2, 'com.ruoyi.web.controller.business.StadMaintenanceOrderController.edit()', 'PUT', 1, 'admin', '研发部门', '/business/maintenance/order', '127.0.0.1', '内网IP', '{\"contactName\":\"刘师傅\",\"contactPhone\":\"13400004444\",\"createTime\":\"2026-05-20 14:00:00\",\"expectDate\":\"2026-05-28 00:00:00\",\"expectTimeSlot\":\"pm\",\"nickName\":\"李车主\",\"orderId\":2,\"orderNo\":\"MO20260520000002\",\"orderStatus\":\"1\",\"paidAmount\":0,\"params\":{},\"payStatus\":\"1\",\"serviceItem\":\"空调清洗+轮胎更换\",\"servicePrice\":880,\"shopAddress\":\"山东省济南市历城区 工业北路88号汽车产业园\",\"shopId\":2,\"shopName\":\"济南鑫维保-工业北路店\",\"totalAmount\":880,\"updateBy\":\"admin\",\"userId\":3,\"vehicleId\":2,\"vehicleName\":\"2025款 特斯拉 Model Y 长续航全轮驱动版\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\r\n### The error may exist in file [D:\\NEV_Life\\NEV_main\\ruoyi-system\\target\\classes\\mapper\\business\\StadMaintenanceOrderMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.StadMaintenanceOrderMapper.updateStadMaintenanceOrder-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update stad_maintenance_order          SET order_no = ?,             user_id = ?,             shop_id = ?,             vehicle_id = ?,             service_item = ?,             service_price = ?,             total_amount = ?,             paid_amount = ?,             expect_date = ?,             expect_time_slot = ?,             order_status = ?,                                                                 pay_status = ?,                          update_by = ?,             update_time = sysdate()          where order_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\n; bad SQL grammar []', '2026-06-09 14:49:01', 153);
INSERT INTO `sys_oper_log` VALUES (123, '维保订单管理', 2, 'com.ruoyi.web.controller.business.StadMaintenanceOrderController.edit()', 'PUT', 1, 'admin', '研发部门', '/business/maintenance/order', '127.0.0.1', '内网IP', '{\"contactName\":\"刘师傅\",\"contactPhone\":\"13400004444\",\"createTime\":\"2026-05-20 14:00:00\",\"expectDate\":\"2026-05-28 00:00:00\",\"expectTimeSlot\":\"pm\",\"nickName\":\"李车主\",\"orderId\":2,\"orderNo\":\"MO20260520000002\",\"orderStatus\":\"1\",\"paidAmount\":0,\"params\":{},\"payStatus\":\"1\",\"serviceItem\":\"空调清洗+轮胎更换\",\"servicePrice\":880,\"shopAddress\":\"山东省济南市历城区 工业北路88号汽车产业园\",\"shopId\":2,\"shopName\":\"济南鑫维保-工业北路店\",\"totalAmount\":880,\"updateBy\":\"admin\",\"userId\":3,\"vehicleId\":2,\"vehicleName\":\"2025款 特斯拉 Model Y 长续航全轮驱动版\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\r\n### The error may exist in file [D:\\NEV_Life\\NEV_main\\ruoyi-system\\target\\classes\\mapper\\business\\StadMaintenanceOrderMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.StadMaintenanceOrderMapper.updateStadMaintenanceOrder-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update stad_maintenance_order          SET order_no = ?,             user_id = ?,             shop_id = ?,             vehicle_id = ?,             service_item = ?,             service_price = ?,             total_amount = ?,             paid_amount = ?,             expect_date = ?,             expect_time_slot = ?,             order_status = ?,                                                                 pay_status = ?,                          update_by = ?,             update_time = sysdate()          where order_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\n; bad SQL grammar []', '2026-06-09 14:49:05', 15);
INSERT INTO `sys_oper_log` VALUES (124, '维保订单管理', 2, 'com.ruoyi.web.controller.business.StadMaintenanceOrderController.edit()', 'PUT', 1, 'admin', '研发部门', '/business/maintenance/order', '127.0.0.1', '内网IP', '{\"contactName\":\"刘师傅\",\"contactPhone\":\"13400004444\",\"createTime\":\"2026-05-20 14:00:00\",\"expectDate\":\"2026-05-28 00:00:00\",\"expectTimeSlot\":\"pm\",\"finishTime\":\"2026-06-09 14:49:10\",\"nickName\":\"李车主\",\"orderId\":2,\"orderNo\":\"MO20260520000002\",\"orderStatus\":\"1\",\"paidAmount\":0,\"params\":{},\"payStatus\":\"1\",\"serviceItem\":\"空调清洗+轮胎更换\",\"servicePrice\":880,\"shopAddress\":\"山东省济南市历城区 工业北路88号汽车产业园\",\"shopId\":2,\"shopName\":\"济南鑫维保-工业北路店\",\"totalAmount\":880,\"updateBy\":\"admin\",\"userId\":3,\"vehicleId\":2,\"vehicleName\":\"2025款 特斯拉 Model Y 长续航全轮驱动版\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\r\n### The error may exist in file [D:\\NEV_Life\\NEV_main\\ruoyi-system\\target\\classes\\mapper\\business\\StadMaintenanceOrderMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.StadMaintenanceOrderMapper.updateStadMaintenanceOrder-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update stad_maintenance_order          SET order_no = ?,             user_id = ?,             shop_id = ?,             vehicle_id = ?,             service_item = ?,             service_price = ?,             total_amount = ?,             paid_amount = ?,             expect_date = ?,             expect_time_slot = ?,             order_status = ?,                          finish_time = ?,                                       pay_status = ?,                          update_by = ?,             update_time = sysdate()          where order_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\n; bad SQL grammar []', '2026-06-09 14:49:12', 6);
INSERT INTO `sys_oper_log` VALUES (125, '维保订单管理', 2, 'com.ruoyi.web.controller.business.StadMaintenanceOrderController.edit()', 'PUT', 1, 'admin', '研发部门', '/business/maintenance/order', '127.0.0.1', '内网IP', '{\"contactName\":\"刘师傅\",\"contactPhone\":\"13400004444\",\"createTime\":\"2026-05-20 14:00:00\",\"expectDate\":\"2026-05-28 00:00:00\",\"expectTimeSlot\":\"pm\",\"finishTime\":\"2026-06-09 14:49:10\",\"nickName\":\"李车主\",\"orderId\":2,\"orderNo\":\"MO20260520000002\",\"orderStatus\":\"1\",\"paidAmount\":0,\"params\":{},\"payStatus\":\"1\",\"serviceItem\":\"空调清洗+轮胎更换\",\"servicePrice\":880,\"shopAddress\":\"山东省济南市历城区 工业北路88号汽车产业园\",\"shopId\":2,\"shopName\":\"济南鑫维保-工业北路店\",\"totalAmount\":880,\"updateBy\":\"admin\",\"userId\":3,\"vehicleId\":2,\"vehicleName\":\"2025款 特斯拉 Model Y 长续航全轮驱动版\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\r\n### The error may exist in file [D:\\NEV_Life\\NEV_main\\ruoyi-system\\target\\classes\\mapper\\business\\StadMaintenanceOrderMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.StadMaintenanceOrderMapper.updateStadMaintenanceOrder-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update stad_maintenance_order          SET order_no = ?,             user_id = ?,             shop_id = ?,             vehicle_id = ?,             service_item = ?,             service_price = ?,             total_amount = ?,             paid_amount = ?,             expect_date = ?,             expect_time_slot = ?,             order_status = ?,                          finish_time = ?,                                       pay_status = ?,                          update_by = ?,             update_time = sysdate()          where order_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\n; bad SQL grammar []', '2026-06-09 14:49:25', 6);
INSERT INTO `sys_oper_log` VALUES (126, '维保订单管理', 2, 'com.ruoyi.web.controller.business.StadMaintenanceOrderController.edit()', 'PUT', 1, 'admin', '研发部门', '/business/maintenance/order', '127.0.0.1', '内网IP', '{\"contactName\":\"刘师傅\",\"contactPhone\":\"13400004444\",\"createTime\":\"2026-05-20 14:00:00\",\"expectDate\":\"2026-05-28 00:00:00\",\"expectTimeSlot\":\"pm\",\"nickName\":\"李车主\",\"orderId\":2,\"orderNo\":\"MO20260520000002\",\"orderStatus\":\"1\",\"paidAmount\":0,\"params\":{},\"payStatus\":\"0\",\"serviceItem\":\"空调清洗+轮胎更换\",\"servicePrice\":880,\"shopAddress\":\"山东省济南市历城区 工业北路88号汽车产业园\",\"shopId\":2,\"shopName\":\"济南鑫维保-工业北路店\",\"totalAmount\":880,\"updateBy\":\"admin\",\"userId\":3,\"vehicleId\":2,\"vehicleName\":\"2025款 特斯拉 Model Y 长续航全轮驱动版\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\r\n### The error may exist in file [D:\\NEV_Life\\NEV_main\\ruoyi-system\\target\\classes\\mapper\\business\\StadMaintenanceOrderMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.StadMaintenanceOrderMapper.updateStadMaintenanceOrder-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update stad_maintenance_order          SET order_no = ?,             user_id = ?,             shop_id = ?,             vehicle_id = ?,             service_item = ?,             service_price = ?,             total_amount = ?,             paid_amount = ?,             expect_date = ?,             expect_time_slot = ?,             order_status = ?,                                                                 pay_status = ?,                          update_by = ?,             update_time = sysdate()          where order_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_by\' in \'field list\'\n; bad SQL grammar []', '2026-06-09 14:49:29', 12);
INSERT INTO `sys_oper_log` VALUES (127, '维保订单管理', 2, 'com.ruoyi.web.controller.business.StadMaintenanceOrderController.edit()', 'PUT', 1, 'admin', '研发部门', '/business/maintenance/order', '127.0.0.1', '内网IP', '{\"contactName\":\"刘师傅\",\"contactPhone\":\"13400004444\",\"createTime\":\"2026-05-20 14:00:00\",\"expectDate\":\"2026-05-28 00:00:00\",\"expectTimeSlot\":\"pm\",\"nickName\":\"李车主\",\"orderId\":2,\"orderNo\":\"MO20260520000002\",\"orderStatus\":\"1\",\"paidAmount\":0,\"params\":{},\"payStatus\":\"1\",\"serviceItem\":\"空调清洗+轮胎更换\",\"servicePrice\":880,\"shopAddress\":\"山东省济南市历城区 工业北路88号汽车产业园\",\"shopId\":2,\"shopName\":\"济南鑫维保-工业北路店\",\"totalAmount\":880,\"updateBy\":\"admin\",\"userId\":3,\"vehicleId\":2,\"vehicleName\":\"2025款 特斯拉 Model Y 长续航全轮驱动版\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-09 15:03:19', 23);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-05-28 18:11:25', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-05-28 18:11:25', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-05-28 18:11:25', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '商户', 'business', 3, '1', 1, 1, '0', '0', 'admin', '2026-05-28 18:47:16', 'admin', '2026-05-28 18:47:36', NULL);
INSERT INTO `sys_role` VALUES (101, '充电运营商', 'charger', 4, '1', 1, 1, '0', '0', 'admin', '2026-05-28 18:48:07', '', NULL, NULL);
INSERT INTO `sys_role` VALUES (102, '维保商', 'maintenance', 5, '1', 1, 1, '0', '0', 'admin', '2026-05-28 18:48:33', '', NULL, NULL);
INSERT INTO `sys_role` VALUES (103, '政府监管', 'government', 6, '1', 1, 1, '0', '0', 'admin', '2026-05-28 18:49:04', 'admin', '2026-05-28 18:49:18', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 2100);
INSERT INTO `sys_role_menu` VALUES (1, 2101);
INSERT INTO `sys_role_menu` VALUES (1, 2102);
INSERT INTO `sys_role_menu` VALUES (1, 2103);
INSERT INTO `sys_role_menu` VALUES (1, 2104);
INSERT INTO `sys_role_menu` VALUES (1, 2105);
INSERT INTO `sys_role_menu` VALUES (1, 2110);
INSERT INTO `sys_role_menu` VALUES (1, 2111);
INSERT INTO `sys_role_menu` VALUES (1, 2112);
INSERT INTO `sys_role_menu` VALUES (1, 2113);
INSERT INTO `sys_role_menu` VALUES (1, 2114);
INSERT INTO `sys_role_menu` VALUES (1, 2120);
INSERT INTO `sys_role_menu` VALUES (1, 2121);
INSERT INTO `sys_role_menu` VALUES (1, 2122);
INSERT INTO `sys_role_menu` VALUES (1, 2123);
INSERT INTO `sys_role_menu` VALUES (1, 2124);
INSERT INTO `sys_role_menu` VALUES (1, 2125);
INSERT INTO `sys_role_menu` VALUES (1, 2300);
INSERT INTO `sys_role_menu` VALUES (1, 2301);
INSERT INTO `sys_role_menu` VALUES (1, 2302);
INSERT INTO `sys_role_menu` VALUES (1, 2303);
INSERT INTO `sys_role_menu` VALUES (1, 2304);
INSERT INTO `sys_role_menu` VALUES (1, 2305);
INSERT INTO `sys_role_menu` VALUES (1, 2311);
INSERT INTO `sys_role_menu` VALUES (1, 2312);
INSERT INTO `sys_role_menu` VALUES (1, 2313);
INSERT INTO `sys_role_menu` VALUES (1, 2314);
INSERT INTO `sys_role_menu` VALUES (1, 2315);
INSERT INTO `sys_role_menu` VALUES (1, 2321);
INSERT INTO `sys_role_menu` VALUES (1, 2322);
INSERT INTO `sys_role_menu` VALUES (1, 2323);
INSERT INTO `sys_role_menu` VALUES (1, 2324);
INSERT INTO `sys_role_menu` VALUES (1, 2325);
INSERT INTO `sys_role_menu` VALUES (1, 2331);
INSERT INTO `sys_role_menu` VALUES (1, 2332);
INSERT INTO `sys_role_menu` VALUES (1, 2333);
INSERT INTO `sys_role_menu` VALUES (1, 2334);
INSERT INTO `sys_role_menu` VALUES (1, 2335);
INSERT INTO `sys_role_menu` VALUES (1, 2341);
INSERT INTO `sys_role_menu` VALUES (1, 2342);
INSERT INTO `sys_role_menu` VALUES (1, 2343);
INSERT INTO `sys_role_menu` VALUES (1, 2344);
INSERT INTO `sys_role_menu` VALUES (1, 2345);
INSERT INTO `sys_role_menu` VALUES (1, 2400);
INSERT INTO `sys_role_menu` VALUES (1, 2401);
INSERT INTO `sys_role_menu` VALUES (1, 2402);
INSERT INTO `sys_role_menu` VALUES (1, 2403);
INSERT INTO `sys_role_menu` VALUES (1, 2404);
INSERT INTO `sys_role_menu` VALUES (1, 2405);
INSERT INTO `sys_role_menu` VALUES (1, 2411);
INSERT INTO `sys_role_menu` VALUES (1, 2412);
INSERT INTO `sys_role_menu` VALUES (1, 2413);
INSERT INTO `sys_role_menu` VALUES (1, 2414);
INSERT INTO `sys_role_menu` VALUES (1, 2415);
INSERT INTO `sys_role_menu` VALUES (1, 2421);
INSERT INTO `sys_role_menu` VALUES (1, 2422);
INSERT INTO `sys_role_menu` VALUES (1, 2423);
INSERT INTO `sys_role_menu` VALUES (1, 2424);
INSERT INTO `sys_role_menu` VALUES (1, 2425);
INSERT INTO `sys_role_menu` VALUES (1, 2431);
INSERT INTO `sys_role_menu` VALUES (1, 2432);
INSERT INTO `sys_role_menu` VALUES (1, 2433);
INSERT INTO `sys_role_menu` VALUES (1, 2434);
INSERT INTO `sys_role_menu` VALUES (1, 2435);
INSERT INTO `sys_role_menu` VALUES (1, 2441);
INSERT INTO `sys_role_menu` VALUES (1, 2442);
INSERT INTO `sys_role_menu` VALUES (1, 2443);
INSERT INTO `sys_role_menu` VALUES (1, 2444);
INSERT INTO `sys_role_menu` VALUES (1, 2445);
INSERT INTO `sys_role_menu` VALUES (1, 2451);
INSERT INTO `sys_role_menu` VALUES (1, 2452);
INSERT INTO `sys_role_menu` VALUES (1, 2453);
INSERT INTO `sys_role_menu` VALUES (1, 2454);
INSERT INTO `sys_role_menu` VALUES (1, 2455);
INSERT INTO `sys_role_menu` VALUES (1, 2500);
INSERT INTO `sys_role_menu` VALUES (1, 2501);
INSERT INTO `sys_role_menu` VALUES (1, 2502);
INSERT INTO `sys_role_menu` VALUES (1, 2503);
INSERT INTO `sys_role_menu` VALUES (1, 2504);
INSERT INTO `sys_role_menu` VALUES (1, 2505);
INSERT INTO `sys_role_menu` VALUES (1, 2511);
INSERT INTO `sys_role_menu` VALUES (1, 2512);
INSERT INTO `sys_role_menu` VALUES (1, 2513);
INSERT INTO `sys_role_menu` VALUES (1, 2514);
INSERT INTO `sys_role_menu` VALUES (1, 2515);
INSERT INTO `sys_role_menu` VALUES (1, 2521);
INSERT INTO `sys_role_menu` VALUES (1, 2522);
INSERT INTO `sys_role_menu` VALUES (1, 2523);
INSERT INTO `sys_role_menu` VALUES (1, 2524);
INSERT INTO `sys_role_menu` VALUES (1, 2525);
INSERT INTO `sys_role_menu` VALUES (1, 2531);
INSERT INTO `sys_role_menu` VALUES (1, 2532);
INSERT INTO `sys_role_menu` VALUES (1, 2533);
INSERT INTO `sys_role_menu` VALUES (1, 2534);
INSERT INTO `sys_role_menu` VALUES (1, 2535);
INSERT INTO `sys_role_menu` VALUES (1, 2600);
INSERT INTO `sys_role_menu` VALUES (1, 2601);
INSERT INTO `sys_role_menu` VALUES (1, 2602);
INSERT INTO `sys_role_menu` VALUES (1, 2603);
INSERT INTO `sys_role_menu` VALUES (1, 2604);
INSERT INTO `sys_role_menu` VALUES (1, 2605);
INSERT INTO `sys_role_menu` VALUES (1, 2611);
INSERT INTO `sys_role_menu` VALUES (1, 2612);
INSERT INTO `sys_role_menu` VALUES (1, 2613);
INSERT INTO `sys_role_menu` VALUES (1, 2614);
INSERT INTO `sys_role_menu` VALUES (1, 2615);
INSERT INTO `sys_role_menu` VALUES (1, 2700);
INSERT INTO `sys_role_menu` VALUES (1, 2701);
INSERT INTO `sys_role_menu` VALUES (1, 2702);
INSERT INTO `sys_role_menu` VALUES (1, 2703);
INSERT INTO `sys_role_menu` VALUES (1, 2704);
INSERT INTO `sys_role_menu` VALUES (1, 2705);
INSERT INTO `sys_role_menu` VALUES (1, 2800);
INSERT INTO `sys_role_menu` VALUES (1, 2801);
INSERT INTO `sys_role_menu` VALUES (1, 2802);
INSERT INTO `sys_role_menu` VALUES (1, 2803);
INSERT INTO `sys_role_menu` VALUES (1, 2804);
INSERT INTO `sys_role_menu` VALUES (1, 2805);
INSERT INTO `sys_role_menu` VALUES (1, 2810);
INSERT INTO `sys_role_menu` VALUES (1, 2811);
INSERT INTO `sys_role_menu` VALUES (1, 2812);
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 1);
INSERT INTO `sys_role_menu` VALUES (100, 2);
INSERT INTO `sys_role_menu` VALUES (100, 3);
INSERT INTO `sys_role_menu` VALUES (100, 4);
INSERT INTO `sys_role_menu` VALUES (100, 100);
INSERT INTO `sys_role_menu` VALUES (100, 101);
INSERT INTO `sys_role_menu` VALUES (100, 102);
INSERT INTO `sys_role_menu` VALUES (100, 103);
INSERT INTO `sys_role_menu` VALUES (100, 104);
INSERT INTO `sys_role_menu` VALUES (100, 105);
INSERT INTO `sys_role_menu` VALUES (100, 106);
INSERT INTO `sys_role_menu` VALUES (100, 107);
INSERT INTO `sys_role_menu` VALUES (100, 108);
INSERT INTO `sys_role_menu` VALUES (100, 109);
INSERT INTO `sys_role_menu` VALUES (100, 110);
INSERT INTO `sys_role_menu` VALUES (100, 111);
INSERT INTO `sys_role_menu` VALUES (100, 112);
INSERT INTO `sys_role_menu` VALUES (100, 113);
INSERT INTO `sys_role_menu` VALUES (100, 114);
INSERT INTO `sys_role_menu` VALUES (100, 115);
INSERT INTO `sys_role_menu` VALUES (100, 116);
INSERT INTO `sys_role_menu` VALUES (100, 117);
INSERT INTO `sys_role_menu` VALUES (100, 500);
INSERT INTO `sys_role_menu` VALUES (100, 501);
INSERT INTO `sys_role_menu` VALUES (100, 1000);
INSERT INTO `sys_role_menu` VALUES (100, 1001);
INSERT INTO `sys_role_menu` VALUES (100, 1002);
INSERT INTO `sys_role_menu` VALUES (100, 1003);
INSERT INTO `sys_role_menu` VALUES (100, 1004);
INSERT INTO `sys_role_menu` VALUES (100, 1005);
INSERT INTO `sys_role_menu` VALUES (100, 1006);
INSERT INTO `sys_role_menu` VALUES (100, 1007);
INSERT INTO `sys_role_menu` VALUES (100, 1008);
INSERT INTO `sys_role_menu` VALUES (100, 1009);
INSERT INTO `sys_role_menu` VALUES (100, 1010);
INSERT INTO `sys_role_menu` VALUES (100, 1011);
INSERT INTO `sys_role_menu` VALUES (100, 1012);
INSERT INTO `sys_role_menu` VALUES (100, 1013);
INSERT INTO `sys_role_menu` VALUES (100, 1014);
INSERT INTO `sys_role_menu` VALUES (100, 1015);
INSERT INTO `sys_role_menu` VALUES (100, 1016);
INSERT INTO `sys_role_menu` VALUES (100, 1017);
INSERT INTO `sys_role_menu` VALUES (100, 1018);
INSERT INTO `sys_role_menu` VALUES (100, 1019);
INSERT INTO `sys_role_menu` VALUES (100, 1020);
INSERT INTO `sys_role_menu` VALUES (100, 1021);
INSERT INTO `sys_role_menu` VALUES (100, 1022);
INSERT INTO `sys_role_menu` VALUES (100, 1023);
INSERT INTO `sys_role_menu` VALUES (100, 1024);
INSERT INTO `sys_role_menu` VALUES (100, 1025);
INSERT INTO `sys_role_menu` VALUES (100, 1026);
INSERT INTO `sys_role_menu` VALUES (100, 1027);
INSERT INTO `sys_role_menu` VALUES (100, 1028);
INSERT INTO `sys_role_menu` VALUES (100, 1029);
INSERT INTO `sys_role_menu` VALUES (100, 1030);
INSERT INTO `sys_role_menu` VALUES (100, 1031);
INSERT INTO `sys_role_menu` VALUES (100, 1032);
INSERT INTO `sys_role_menu` VALUES (100, 1033);
INSERT INTO `sys_role_menu` VALUES (100, 1034);
INSERT INTO `sys_role_menu` VALUES (100, 1035);
INSERT INTO `sys_role_menu` VALUES (100, 1036);
INSERT INTO `sys_role_menu` VALUES (100, 1037);
INSERT INTO `sys_role_menu` VALUES (100, 1038);
INSERT INTO `sys_role_menu` VALUES (100, 1039);
INSERT INTO `sys_role_menu` VALUES (100, 1040);
INSERT INTO `sys_role_menu` VALUES (100, 1041);
INSERT INTO `sys_role_menu` VALUES (100, 1042);
INSERT INTO `sys_role_menu` VALUES (100, 1043);
INSERT INTO `sys_role_menu` VALUES (100, 1044);
INSERT INTO `sys_role_menu` VALUES (100, 1045);
INSERT INTO `sys_role_menu` VALUES (100, 1046);
INSERT INTO `sys_role_menu` VALUES (100, 1047);
INSERT INTO `sys_role_menu` VALUES (100, 1048);
INSERT INTO `sys_role_menu` VALUES (100, 1049);
INSERT INTO `sys_role_menu` VALUES (100, 1050);
INSERT INTO `sys_role_menu` VALUES (100, 1051);
INSERT INTO `sys_role_menu` VALUES (100, 1052);
INSERT INTO `sys_role_menu` VALUES (100, 1053);
INSERT INTO `sys_role_menu` VALUES (100, 1054);
INSERT INTO `sys_role_menu` VALUES (100, 1055);
INSERT INTO `sys_role_menu` VALUES (100, 1056);
INSERT INTO `sys_role_menu` VALUES (100, 1057);
INSERT INTO `sys_role_menu` VALUES (100, 1058);
INSERT INTO `sys_role_menu` VALUES (100, 1059);
INSERT INTO `sys_role_menu` VALUES (100, 1060);
INSERT INTO `sys_role_menu` VALUES (101, 1);
INSERT INTO `sys_role_menu` VALUES (101, 2);
INSERT INTO `sys_role_menu` VALUES (101, 3);
INSERT INTO `sys_role_menu` VALUES (101, 4);
INSERT INTO `sys_role_menu` VALUES (101, 100);
INSERT INTO `sys_role_menu` VALUES (101, 101);
INSERT INTO `sys_role_menu` VALUES (101, 102);
INSERT INTO `sys_role_menu` VALUES (101, 103);
INSERT INTO `sys_role_menu` VALUES (101, 104);
INSERT INTO `sys_role_menu` VALUES (101, 105);
INSERT INTO `sys_role_menu` VALUES (101, 106);
INSERT INTO `sys_role_menu` VALUES (101, 107);
INSERT INTO `sys_role_menu` VALUES (101, 108);
INSERT INTO `sys_role_menu` VALUES (101, 109);
INSERT INTO `sys_role_menu` VALUES (101, 110);
INSERT INTO `sys_role_menu` VALUES (101, 111);
INSERT INTO `sys_role_menu` VALUES (101, 112);
INSERT INTO `sys_role_menu` VALUES (101, 113);
INSERT INTO `sys_role_menu` VALUES (101, 114);
INSERT INTO `sys_role_menu` VALUES (101, 115);
INSERT INTO `sys_role_menu` VALUES (101, 116);
INSERT INTO `sys_role_menu` VALUES (101, 117);
INSERT INTO `sys_role_menu` VALUES (101, 500);
INSERT INTO `sys_role_menu` VALUES (101, 501);
INSERT INTO `sys_role_menu` VALUES (101, 1000);
INSERT INTO `sys_role_menu` VALUES (101, 1001);
INSERT INTO `sys_role_menu` VALUES (101, 1002);
INSERT INTO `sys_role_menu` VALUES (101, 1003);
INSERT INTO `sys_role_menu` VALUES (101, 1004);
INSERT INTO `sys_role_menu` VALUES (101, 1005);
INSERT INTO `sys_role_menu` VALUES (101, 1006);
INSERT INTO `sys_role_menu` VALUES (101, 1007);
INSERT INTO `sys_role_menu` VALUES (101, 1008);
INSERT INTO `sys_role_menu` VALUES (101, 1009);
INSERT INTO `sys_role_menu` VALUES (101, 1010);
INSERT INTO `sys_role_menu` VALUES (101, 1011);
INSERT INTO `sys_role_menu` VALUES (101, 1012);
INSERT INTO `sys_role_menu` VALUES (101, 1013);
INSERT INTO `sys_role_menu` VALUES (101, 1014);
INSERT INTO `sys_role_menu` VALUES (101, 1015);
INSERT INTO `sys_role_menu` VALUES (101, 1016);
INSERT INTO `sys_role_menu` VALUES (101, 1017);
INSERT INTO `sys_role_menu` VALUES (101, 1018);
INSERT INTO `sys_role_menu` VALUES (101, 1019);
INSERT INTO `sys_role_menu` VALUES (101, 1020);
INSERT INTO `sys_role_menu` VALUES (101, 1021);
INSERT INTO `sys_role_menu` VALUES (101, 1022);
INSERT INTO `sys_role_menu` VALUES (101, 1023);
INSERT INTO `sys_role_menu` VALUES (101, 1024);
INSERT INTO `sys_role_menu` VALUES (101, 1025);
INSERT INTO `sys_role_menu` VALUES (101, 1026);
INSERT INTO `sys_role_menu` VALUES (101, 1027);
INSERT INTO `sys_role_menu` VALUES (101, 1028);
INSERT INTO `sys_role_menu` VALUES (101, 1029);
INSERT INTO `sys_role_menu` VALUES (101, 1030);
INSERT INTO `sys_role_menu` VALUES (101, 1031);
INSERT INTO `sys_role_menu` VALUES (101, 1032);
INSERT INTO `sys_role_menu` VALUES (101, 1033);
INSERT INTO `sys_role_menu` VALUES (101, 1034);
INSERT INTO `sys_role_menu` VALUES (101, 1035);
INSERT INTO `sys_role_menu` VALUES (101, 1036);
INSERT INTO `sys_role_menu` VALUES (101, 1037);
INSERT INTO `sys_role_menu` VALUES (101, 1038);
INSERT INTO `sys_role_menu` VALUES (101, 1039);
INSERT INTO `sys_role_menu` VALUES (101, 1040);
INSERT INTO `sys_role_menu` VALUES (101, 1041);
INSERT INTO `sys_role_menu` VALUES (101, 1042);
INSERT INTO `sys_role_menu` VALUES (101, 1043);
INSERT INTO `sys_role_menu` VALUES (101, 1044);
INSERT INTO `sys_role_menu` VALUES (101, 1045);
INSERT INTO `sys_role_menu` VALUES (101, 1046);
INSERT INTO `sys_role_menu` VALUES (101, 1047);
INSERT INTO `sys_role_menu` VALUES (101, 1048);
INSERT INTO `sys_role_menu` VALUES (101, 1049);
INSERT INTO `sys_role_menu` VALUES (101, 1050);
INSERT INTO `sys_role_menu` VALUES (101, 1051);
INSERT INTO `sys_role_menu` VALUES (101, 1052);
INSERT INTO `sys_role_menu` VALUES (101, 1053);
INSERT INTO `sys_role_menu` VALUES (101, 1054);
INSERT INTO `sys_role_menu` VALUES (101, 1055);
INSERT INTO `sys_role_menu` VALUES (101, 1056);
INSERT INTO `sys_role_menu` VALUES (101, 1057);
INSERT INTO `sys_role_menu` VALUES (101, 1058);
INSERT INTO `sys_role_menu` VALUES (101, 1059);
INSERT INTO `sys_role_menu` VALUES (101, 1060);
INSERT INTO `sys_role_menu` VALUES (102, 1);
INSERT INTO `sys_role_menu` VALUES (102, 2);
INSERT INTO `sys_role_menu` VALUES (102, 3);
INSERT INTO `sys_role_menu` VALUES (102, 4);
INSERT INTO `sys_role_menu` VALUES (102, 100);
INSERT INTO `sys_role_menu` VALUES (102, 101);
INSERT INTO `sys_role_menu` VALUES (102, 102);
INSERT INTO `sys_role_menu` VALUES (102, 103);
INSERT INTO `sys_role_menu` VALUES (102, 104);
INSERT INTO `sys_role_menu` VALUES (102, 105);
INSERT INTO `sys_role_menu` VALUES (102, 106);
INSERT INTO `sys_role_menu` VALUES (102, 107);
INSERT INTO `sys_role_menu` VALUES (102, 108);
INSERT INTO `sys_role_menu` VALUES (102, 109);
INSERT INTO `sys_role_menu` VALUES (102, 110);
INSERT INTO `sys_role_menu` VALUES (102, 111);
INSERT INTO `sys_role_menu` VALUES (102, 112);
INSERT INTO `sys_role_menu` VALUES (102, 113);
INSERT INTO `sys_role_menu` VALUES (102, 114);
INSERT INTO `sys_role_menu` VALUES (102, 115);
INSERT INTO `sys_role_menu` VALUES (102, 116);
INSERT INTO `sys_role_menu` VALUES (102, 117);
INSERT INTO `sys_role_menu` VALUES (102, 500);
INSERT INTO `sys_role_menu` VALUES (102, 501);
INSERT INTO `sys_role_menu` VALUES (102, 1000);
INSERT INTO `sys_role_menu` VALUES (102, 1001);
INSERT INTO `sys_role_menu` VALUES (102, 1002);
INSERT INTO `sys_role_menu` VALUES (102, 1003);
INSERT INTO `sys_role_menu` VALUES (102, 1004);
INSERT INTO `sys_role_menu` VALUES (102, 1005);
INSERT INTO `sys_role_menu` VALUES (102, 1006);
INSERT INTO `sys_role_menu` VALUES (102, 1007);
INSERT INTO `sys_role_menu` VALUES (102, 1008);
INSERT INTO `sys_role_menu` VALUES (102, 1009);
INSERT INTO `sys_role_menu` VALUES (102, 1010);
INSERT INTO `sys_role_menu` VALUES (102, 1011);
INSERT INTO `sys_role_menu` VALUES (102, 1012);
INSERT INTO `sys_role_menu` VALUES (102, 1013);
INSERT INTO `sys_role_menu` VALUES (102, 1014);
INSERT INTO `sys_role_menu` VALUES (102, 1015);
INSERT INTO `sys_role_menu` VALUES (102, 1016);
INSERT INTO `sys_role_menu` VALUES (102, 1017);
INSERT INTO `sys_role_menu` VALUES (102, 1018);
INSERT INTO `sys_role_menu` VALUES (102, 1019);
INSERT INTO `sys_role_menu` VALUES (102, 1020);
INSERT INTO `sys_role_menu` VALUES (102, 1021);
INSERT INTO `sys_role_menu` VALUES (102, 1022);
INSERT INTO `sys_role_menu` VALUES (102, 1023);
INSERT INTO `sys_role_menu` VALUES (102, 1024);
INSERT INTO `sys_role_menu` VALUES (102, 1025);
INSERT INTO `sys_role_menu` VALUES (102, 1026);
INSERT INTO `sys_role_menu` VALUES (102, 1027);
INSERT INTO `sys_role_menu` VALUES (102, 1028);
INSERT INTO `sys_role_menu` VALUES (102, 1029);
INSERT INTO `sys_role_menu` VALUES (102, 1030);
INSERT INTO `sys_role_menu` VALUES (102, 1031);
INSERT INTO `sys_role_menu` VALUES (102, 1032);
INSERT INTO `sys_role_menu` VALUES (102, 1033);
INSERT INTO `sys_role_menu` VALUES (102, 1034);
INSERT INTO `sys_role_menu` VALUES (102, 1035);
INSERT INTO `sys_role_menu` VALUES (102, 1036);
INSERT INTO `sys_role_menu` VALUES (102, 1037);
INSERT INTO `sys_role_menu` VALUES (102, 1038);
INSERT INTO `sys_role_menu` VALUES (102, 1039);
INSERT INTO `sys_role_menu` VALUES (102, 1040);
INSERT INTO `sys_role_menu` VALUES (102, 1041);
INSERT INTO `sys_role_menu` VALUES (102, 1042);
INSERT INTO `sys_role_menu` VALUES (102, 1043);
INSERT INTO `sys_role_menu` VALUES (102, 1044);
INSERT INTO `sys_role_menu` VALUES (102, 1045);
INSERT INTO `sys_role_menu` VALUES (102, 1046);
INSERT INTO `sys_role_menu` VALUES (102, 1047);
INSERT INTO `sys_role_menu` VALUES (102, 1048);
INSERT INTO `sys_role_menu` VALUES (102, 1049);
INSERT INTO `sys_role_menu` VALUES (102, 1050);
INSERT INTO `sys_role_menu` VALUES (102, 1051);
INSERT INTO `sys_role_menu` VALUES (102, 1052);
INSERT INTO `sys_role_menu` VALUES (102, 1053);
INSERT INTO `sys_role_menu` VALUES (102, 1054);
INSERT INTO `sys_role_menu` VALUES (102, 1055);
INSERT INTO `sys_role_menu` VALUES (102, 1056);
INSERT INTO `sys_role_menu` VALUES (102, 1057);
INSERT INTO `sys_role_menu` VALUES (102, 1058);
INSERT INTO `sys_role_menu` VALUES (102, 1059);
INSERT INTO `sys_role_menu` VALUES (102, 1060);
INSERT INTO `sys_role_menu` VALUES (103, 1);
INSERT INTO `sys_role_menu` VALUES (103, 2);
INSERT INTO `sys_role_menu` VALUES (103, 3);
INSERT INTO `sys_role_menu` VALUES (103, 4);
INSERT INTO `sys_role_menu` VALUES (103, 100);
INSERT INTO `sys_role_menu` VALUES (103, 101);
INSERT INTO `sys_role_menu` VALUES (103, 102);
INSERT INTO `sys_role_menu` VALUES (103, 103);
INSERT INTO `sys_role_menu` VALUES (103, 104);
INSERT INTO `sys_role_menu` VALUES (103, 105);
INSERT INTO `sys_role_menu` VALUES (103, 106);
INSERT INTO `sys_role_menu` VALUES (103, 107);
INSERT INTO `sys_role_menu` VALUES (103, 108);
INSERT INTO `sys_role_menu` VALUES (103, 109);
INSERT INTO `sys_role_menu` VALUES (103, 110);
INSERT INTO `sys_role_menu` VALUES (103, 111);
INSERT INTO `sys_role_menu` VALUES (103, 112);
INSERT INTO `sys_role_menu` VALUES (103, 113);
INSERT INTO `sys_role_menu` VALUES (103, 114);
INSERT INTO `sys_role_menu` VALUES (103, 115);
INSERT INTO `sys_role_menu` VALUES (103, 116);
INSERT INTO `sys_role_menu` VALUES (103, 117);
INSERT INTO `sys_role_menu` VALUES (103, 500);
INSERT INTO `sys_role_menu` VALUES (103, 501);
INSERT INTO `sys_role_menu` VALUES (103, 1000);
INSERT INTO `sys_role_menu` VALUES (103, 1001);
INSERT INTO `sys_role_menu` VALUES (103, 1002);
INSERT INTO `sys_role_menu` VALUES (103, 1003);
INSERT INTO `sys_role_menu` VALUES (103, 1004);
INSERT INTO `sys_role_menu` VALUES (103, 1005);
INSERT INTO `sys_role_menu` VALUES (103, 1006);
INSERT INTO `sys_role_menu` VALUES (103, 1007);
INSERT INTO `sys_role_menu` VALUES (103, 1008);
INSERT INTO `sys_role_menu` VALUES (103, 1009);
INSERT INTO `sys_role_menu` VALUES (103, 1010);
INSERT INTO `sys_role_menu` VALUES (103, 1011);
INSERT INTO `sys_role_menu` VALUES (103, 1012);
INSERT INTO `sys_role_menu` VALUES (103, 1013);
INSERT INTO `sys_role_menu` VALUES (103, 1014);
INSERT INTO `sys_role_menu` VALUES (103, 1015);
INSERT INTO `sys_role_menu` VALUES (103, 1016);
INSERT INTO `sys_role_menu` VALUES (103, 1017);
INSERT INTO `sys_role_menu` VALUES (103, 1018);
INSERT INTO `sys_role_menu` VALUES (103, 1019);
INSERT INTO `sys_role_menu` VALUES (103, 1020);
INSERT INTO `sys_role_menu` VALUES (103, 1021);
INSERT INTO `sys_role_menu` VALUES (103, 1022);
INSERT INTO `sys_role_menu` VALUES (103, 1023);
INSERT INTO `sys_role_menu` VALUES (103, 1024);
INSERT INTO `sys_role_menu` VALUES (103, 1025);
INSERT INTO `sys_role_menu` VALUES (103, 1026);
INSERT INTO `sys_role_menu` VALUES (103, 1027);
INSERT INTO `sys_role_menu` VALUES (103, 1028);
INSERT INTO `sys_role_menu` VALUES (103, 1029);
INSERT INTO `sys_role_menu` VALUES (103, 1030);
INSERT INTO `sys_role_menu` VALUES (103, 1031);
INSERT INTO `sys_role_menu` VALUES (103, 1032);
INSERT INTO `sys_role_menu` VALUES (103, 1033);
INSERT INTO `sys_role_menu` VALUES (103, 1034);
INSERT INTO `sys_role_menu` VALUES (103, 1035);
INSERT INTO `sys_role_menu` VALUES (103, 1036);
INSERT INTO `sys_role_menu` VALUES (103, 1037);
INSERT INTO `sys_role_menu` VALUES (103, 1038);
INSERT INTO `sys_role_menu` VALUES (103, 1039);
INSERT INTO `sys_role_menu` VALUES (103, 1040);
INSERT INTO `sys_role_menu` VALUES (103, 1041);
INSERT INTO `sys_role_menu` VALUES (103, 1042);
INSERT INTO `sys_role_menu` VALUES (103, 1043);
INSERT INTO `sys_role_menu` VALUES (103, 1044);
INSERT INTO `sys_role_menu` VALUES (103, 1045);
INSERT INTO `sys_role_menu` VALUES (103, 1046);
INSERT INTO `sys_role_menu` VALUES (103, 1047);
INSERT INTO `sys_role_menu` VALUES (103, 1048);
INSERT INTO `sys_role_menu` VALUES (103, 1049);
INSERT INTO `sys_role_menu` VALUES (103, 1050);
INSERT INTO `sys_role_menu` VALUES (103, 1051);
INSERT INTO `sys_role_menu` VALUES (103, 1052);
INSERT INTO `sys_role_menu` VALUES (103, 1053);
INSERT INTO `sys_role_menu` VALUES (103, 1054);
INSERT INTO `sys_role_menu` VALUES (103, 1055);
INSERT INTO `sys_role_menu` VALUES (103, 1056);
INSERT INTO `sys_role_menu` VALUES (103, 1057);
INSERT INTO `sys_role_menu` VALUES (103, 1058);
INSERT INTO `sys_role_menu` VALUES (103, 1059);
INSERT INTO `sys_role_menu` VALUES (103, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '/profile/avatar/2026/06/06/fb976df9d294453e896598d41620066e.jpg', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-09 22:16:52', '2026-05-28 18:11:24', 'admin', '2026-05-28 18:11:24', '', '2026-06-06 21:03:14', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-02 17:09:07', '2026-05-28 18:11:24', 'admin', '2026-05-28 18:11:24', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (3, 103, 'lichezhu', '李车主', '00', 'li@qq.com', '13700000003', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-01 18:41:15', '2026-06-01 18:41:15', 'admin', '2026-06-01 18:41:15', '', NULL, '李车主-普通用户');
INSERT INTO `sys_user` VALUES (4, 103, 'dealer_a', '商户账号A', '00', 'dealera@qq.com', '13700000004', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-09 19:22:52', '2026-06-01 18:41:15', 'admin', '2026-06-01 18:41:15', '', NULL, '经销商');
INSERT INTO `sys_user` VALUES (5, 103, 'charger_b', '商户账号B', '00', 'chargerb@qq.com', '13700000005', '1', '/profile/avatar/2026/06/09/b6a881ce5f61466da8cb05e4d21e53bd.jpg', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-09 01:42:27', '2026-06-01 18:41:15', 'admin', '2026-06-01 18:41:15', '', '2026-06-09 01:43:25', '充电运营商');
INSERT INTO `sys_user` VALUES (6, 103, 'maintainc', '商户账号C', '00', 'maintainc@qq.com', '13700000006', '1', '/profile/avatar/2026/06/09/4a4ae1b348e44165b70be581e74b7340.jpg', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-09 15:52:37', '2026-06-01 18:41:15', 'admin', '2026-06-01 18:41:15', '', '2026-06-09 01:42:11', '维保商');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

SET FOREIGN_KEY_CHECKS = 1;
