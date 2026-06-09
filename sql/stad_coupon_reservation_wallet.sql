-- =============================================
-- 优惠券、预约、钱包 表结构 + 初始数据
-- 来源：new_energy(4).sql
-- =============================================

-- ----------------------------
-- Table: stad_coupon (优惠券定义)
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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
-- Table: stad_user_coupon (用户领取的优惠券)
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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
-- Table: stad_reservation (预约记录)
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
-- Table: stad_wallet (用户钱包)
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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stad_wallet
-- ----------------------------
INSERT INTO `stad_wallet` VALUES (1, 1, 1300.00, 3301.00, 2001.00, 0.00, '2026-06-08 22:51:45', '2026-06-09 01:54:55');