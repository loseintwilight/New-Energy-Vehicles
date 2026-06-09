CREATE TABLE IF NOT EXISTS stad_wallet (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0,
    total_recharge DECIMAL(10,2) DEFAULT 0,
    total_withdraw DECIMAL(10,2) DEFAULT 0,
    freeze_amount DECIMAL(10,2) DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id_wallet (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS stad_coupon (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type INT DEFAULT 1,
    amount DECIMAL(10,2) NOT NULL,
    min_amount DECIMAL(10,2) DEFAULT 0,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    total_count INT DEFAULT 100,
    per_user_limit INT DEFAULT 1,
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status_coupon (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS stad_user_coupon (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    status INT DEFAULT 1,
    use_time DATETIME NULL,
    order_id BIGINT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id_uc (user_id),
    INDEX idx_coupon_id_uc (coupon_id),
    INDEX idx_status_uc (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO stad_wallet (user_id, balance, total_recharge, total_withdraw, freeze_amount) SELECT 1, 1000.00, 2000.00, 1000.00, 0.00 WHERE NOT EXISTS (SELECT 1 FROM stad_wallet WHERE user_id = 1);

INSERT INTO stad_coupon (name, type, amount, min_amount, start_time, end_time, total_count, per_user_limit, status) VALUES ('New User Coupon', 3, 50.00, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 1000, 1, 1);
INSERT INTO stad_coupon (name, type, amount, min_amount, start_time, end_time, total_count, per_user_limit, status) VALUES ('Charge Discount', 1, 10.00, 50, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 500, 3, 1);
INSERT INTO stad_coupon (name, type, amount, min_amount, start_time, end_time, total_count, per_user_limit, status) VALUES ('Car Purchase', 2, 0.95, 100000, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 100, 1, 1);
INSERT INTO stad_coupon (name, type, amount, min_amount, start_time, end_time, total_count, per_user_limit, status) VALUES ('Service Coupon', 3, 30.00, 0, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 200, 2, 1);
INSERT INTO stad_coupon (name, type, amount, min_amount, start_time, end_time, total_count, per_user_limit, status) VALUES ('Weekend Sale', 1, 20.00, 100, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 300, 2, 1);

INSERT INTO stad_user_coupon (user_id, coupon_id, status) VALUES (1, 1, 1);
INSERT INTO stad_user_coupon (user_id, coupon_id, status) VALUES (1, 2, 1);
INSERT INTO stad_user_coupon (user_id, coupon_id, status) VALUES (1, 2, 1);
INSERT INTO stad_user_coupon (user_id, coupon_id, status) VALUES (1, 4, 2);
INSERT INTO stad_user_coupon (user_id, coupon_id, status) VALUES (1, 5, 1);