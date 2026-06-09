CREATE TABLE IF NOT EXISTS stad_user_profile (
    profile_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    nick_name VARCHAR(50),
    id_card VARCHAR(20),
    total_earned INT DEFAULT 0,
    total_spent INT DEFAULT 0,
    balance INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS stad_carbon_ledger (
    ledger_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    record_type TINYINT DEFAULT 0,
    rule_id BIGINT,
    points INT DEFAULT 0,
    balance_after INT DEFAULT 0,
    source_type TINYINT DEFAULT 0,
    source_id BIGINT,
    remark VARCHAR(200),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO stad_user_profile (user_id, nick_name, total_earned, total_spent, balance) 
SELECT 1, 'admin', 5000, 2320, 2680 
WHERE NOT EXISTS (SELECT 1 FROM stad_user_profile WHERE user_id = 1);

INSERT INTO stad_carbon_ledger (user_id, record_type, points, balance_after, source_type, remark) VALUES
(1, 0, 500, 500, 1, '新用户注册'),
(1, 0, 10, 510, 0, '充电获得'),
(1, 0, 5, 515, 3, '每日签到'),
(1, 0, 10, 525, 0, '充电获得'),
(1, 0, 1000, 1525, 1, '购车奖励'),
(1, 0, 5, 1530, 3, '每日签到'),
(1, 1, 200, 1330, 2, '积分兑换'),
(1, 0, 2, 1332, 2, '阅读获得'),
(1, 0, 10, 1342, 0, '充电获得'),
(1, 0, 5, 1347, 3, '每日签到'),
(1, 0, 1500, 2847, 1, '购车奖励'),
(1, 0, 5, 2852, 3, '每日签到'),
(1, 0, 10, 2862, 0, '充电获得'),
(1, 0, 5, 2867, 3, '每日签到'),
(1, 1, 187, 2680, 2, '积分兑换');
