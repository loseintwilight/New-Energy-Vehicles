-- 每个订单菜单需要唯一的 path，避免路由冲突
UPDATE sys_menu SET path = 'uorder' WHERE menu_id = 2121;  -- 购车订单
UPDATE sys_menu SET path = 'morder' WHERE menu_id = 2110;  -- 维保订单
UPDATE sys_menu SET path = 'corder' WHERE menu_id = 2451;  -- 充电订单