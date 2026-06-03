-- ============================================================
-- 维保管理 & 购车订单 菜单权限 SQL
-- 基于 sys_menu 表，menu_type: M=目录 C=菜单 F=按钮
-- 使用 menu_id >= 2100 避免与已有菜单冲突
-- ============================================================

-- 1. 维保管理 一级目录 (parent_id=0)
INSERT INTO sys_menu VALUES(2100, '维保管理', 0, 5, 'maintenance', null, '', '', 1, 0, 'M', '0', '0', '', 'service', 'admin', sysdate(), '', null, '维保管理目录');

-- 2. 维保门店 菜单 (parent_id=2100)
INSERT INTO sys_menu VALUES(2101, '维保门店', 2100, 1, 'shop', 'business/maintenance/shop/index', '', '', 1, 0, 'C', '0', '0', 'business:shop:list', 'tool', 'admin', sysdate(), '', null, '维保门店菜单');
-- 维保门店 按钮权限
INSERT INTO sys_menu VALUES(2102, '门店查询', 2101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:query',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2103, '门店新增', 2101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:add',    '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2104, '门店修改', 2101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:edit',   '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2105, '门店删除', 2101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:shop:remove', '#', 'admin', sysdate(), '', null, '');

-- 3. 维保订单 菜单 (parent_id=2120 订单管理)
INSERT INTO sys_menu VALUES(2110, '维保订单', 2120, 2, 'order', 'business/maintenance/order/index', '', '', 1, 0, 'C', '0', '0', 'business:morder:list', 'form', 'admin', sysdate(), '', null, '维保订单菜单');
-- 维保订单 按钮权限
INSERT INTO sys_menu VALUES(2111, '订单查询', 2110, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:query',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2112, '订单新增', 2110, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:add',    '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2113, '订单修改', 2110, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:edit',   '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2114, '订单删除', 2110, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:morder:remove', '#', 'admin', sysdate(), '', null, '');

-- 4. 购车订单 菜单 (parent_id=0，作为一级菜单"订单管理"的子菜单，或独立。这里挂在"维保管理"同级，也可挂到已有"充电订单"的父级下)
-- 如果没有已有的订单管理目录，创建独立的购车订单菜单
-- 这里先创建为一级目录
INSERT INTO sys_menu VALUES(2120, '订单管理', 0, 6, 'unified', null, '', '', 1, 0, 'M', '0', '0', '', 'order', 'admin', sysdate(), '', null, '订单管理目录');
INSERT INTO sys_menu VALUES(2121, '购车订单', 2120, 1, 'order', 'business/unified/order/index', '', '', 1, 0, 'C', '0', '0', 'business:uorder:list', 'form', 'admin', sysdate(), '', null, '购车订单菜单');
-- 购车订单 按钮权限
INSERT INTO sys_menu VALUES(2122, '订单查询', 2121, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:query',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2123, '订单新增', 2121, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:add',    '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2124, '订单修改', 2121, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:edit',   '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2125, '订单删除', 2121, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:uorder:remove', '#', 'admin', sysdate(), '', null, '');

-- ============================================================
-- 车辆管理 & 充电管理 & 用户中心 & 碳积分/政务 菜单权限 SQL
-- menu_id >= 2300, 按模块隔离
-- ============================================================

-- ==================== 车辆管理 ====================
INSERT INTO sys_menu VALUES(2300, '车辆管理', 0, 7, 'vehicle', null, '', '', 1, 0, 'M', '0', '0', '', 'car', 'admin', sysdate(), '', null, '车辆管理目录');

INSERT INTO sys_menu VALUES(2301, '车辆信息', 2300, 1, 'vehicle', 'business/vehicle/index', '', '', 1, 0, 'C', '0', '0', 'business:vehicle:list', 'car', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2302, '车辆查询', 2301, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2303, '车辆新增', 2301, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2304, '车辆修改', 2301, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2305, '车辆删除', 2301, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicle:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2311, '车辆规格', 2300, 2, 'spec', 'business/vehiclespec/index', '', '', 1, 0, 'C', '0', '0', 'business:vehiclespec:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2312, '规格查询', 2311, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2313, '规格新增', 2311, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2314, '规格修改', 2311, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2315, '规格删除', 2311, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclespec:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2321, '金融方案', 2300, 3, 'plan', 'business/financeplan/index', '', '', 1, 0, 'C', '0', '0', 'business:financeplan:list', 'money', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2322, '方案查询', 2321, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2323, '方案新增', 2321, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2324, '方案修改', 2321, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2325, '方案删除', 2321, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:financeplan:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2331, '二手车管理', 2300, 4, 'used', 'business/vehicleused/index', '', '', 1, 0, 'C', '0', '0', 'business:vehicleused:list', 'table', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2332, '二手车查询', 2331, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2333, '二手车新增', 2331, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2334, '二手车修改', 2331, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2335, '二手车删除', 2331, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehicleused:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2341, '车辆评价', 2300, 5, 'review', 'business/vehiclereview/index', '', '', 1, 0, 'C', '0', '0', 'business:vehiclereview:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2342, '评价查询', 2341, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2343, '评价新增', 2341, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2344, '评价修改', 2341, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2345, '评价删除', 2341, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:vehiclereview:remove', '#', 'admin', sysdate(), '', null, '');

-- ==================== 充电管理 ====================
INSERT INTO sys_menu VALUES(2400, '充电管理', 0, 8, 'charging', null, '', '', 1, 0, 'M', '0', '0', '', 'table', 'admin', sysdate(), '', null, '充电管理目录');

INSERT INTO sys_menu VALUES(2401, '充电站管理', 2400, 1, 'station', 'business/station/index', '', '', 1, 0, 'C', '0', '0', 'business:station:list', 'tree', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2402, '充电站查询', 2401, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2403, '充电站新增', 2401, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2404, '充电站修改', 2401, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2405, '充电站删除', 2401, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:station:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2411, '充电桩管理', 2400, 2, 'pile', 'business/chargingpile/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingpile:list', 'cascader', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2412, '充电桩查询', 2411, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2413, '充电桩新增', 2411, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2414, '充电桩修改', 2411, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2415, '充电桩删除', 2411, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingpile:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2421, '充电费率', 2400, 3, 'rate', 'business/chargingrate/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingrate:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2422, '费率查询', 2421, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2423, '费率新增', 2421, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2424, '费率修改', 2421, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2425, '费率删除', 2421, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrate:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2431, '费率时段', 2400, 4, 'period', 'business/chargingrateperiod/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingrateperiod:list', 'date', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2432, '时段查询', 2431, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2433, '时段新增', 2431, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2434, '时段修改', 2431, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2435, '时段删除', 2431, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingrateperiod:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2441, '充电结算', 2400, 5, 'settlement', 'business/chargingsettlement/index', '', '', 1, 0, 'C', '0', '0', 'business:chargingsettlement:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2442, '结算查询', 2441, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2443, '结算新增', 2441, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2444, '结算修改', 2441, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2445, '结算删除', 2441, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:chargingsettlement:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2451, '充电订单', 2120, 3, 'order', 'business/order/index', '', '', 1, 0, 'C', '0', '0', 'business:order:list', 'order', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2452, '订单查询', 2451, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2453, '订单新增', 2451, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2454, '订单修改', 2451, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2455, '订单删除', 2451, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:order:remove', '#', 'admin', sysdate(), '', null, '');

-- ==================== 用户中心 ====================
INSERT INTO sys_menu VALUES(2500, '用户中心', 0, 9, 'user', null, '', '', 1, 0, 'M', '0', '0', '', 'user', 'admin', sysdate(), '', null, '用户中心目录');

INSERT INTO sys_menu VALUES(2501, '用户档案', 2500, 1, 'profile', 'business/profile/index', '', '', 1, 0, 'C', '0', '0', 'business:profile:list', 'user', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2502, '档案查询', 2501, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2503, '档案新增', 2501, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2504, '档案修改', 2501, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2505, '档案删除', 2501, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:profile:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2511, '用户收藏', 2500, 2, 'favorite', 'business/favorite/index', '', '', 1, 0, 'C', '0', '0', 'business:favorite:list', 'star', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2512, '收藏查询', 2511, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2513, '收藏新增', 2511, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2514, '收藏修改', 2511, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2515, '收藏删除', 2511, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:favorite:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2521, '用户反馈', 2500, 3, 'feedback', 'business/feedback/index', '', '', 1, 0, 'C', '0', '0', 'business:feedback:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2522, '反馈查询', 2521, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2523, '反馈新增', 2521, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2524, '反馈修改', 2521, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2525, '反馈删除', 2521, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:feedback:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2531, '用户地址', 2500, 4, 'address', 'business/address/index', '', '', 1, 0, 'C', '0', '0', 'business:address:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2532, '地址查询', 2531, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2533, '地址新增', 2531, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2534, '地址修改', 2531, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2535, '地址删除', 2531, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:address:remove', '#', 'admin', sysdate(), '', null, '');

-- ==================== 碳积分管理 ====================
INSERT INTO sys_menu VALUES(2600, '碳积分管理', 0, 10, 'carbon', null, '', '', 1, 0, 'M', '0', '0', '', 'documentation', 'admin', sysdate(), '', null, '碳积分目录');

INSERT INTO sys_menu VALUES(2601, '碳积分流水', 2600, 1, 'ledger', 'business/carbonledger/index', '', '', 1, 0, 'C', '0', '0', 'business:carbonledger:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2602, '流水查询', 2601, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2603, '流水新增', 2601, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2604, '流水修改', 2601, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2605, '流水删除', 2601, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonledger:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2611, '碳减排统计', 2600, 2, 'stats', 'business/carbonstatistics/index', '', '', 1, 0, 'C', '0', '0', 'business:carbonstatistics:list', 'chart', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2612, '统计查询', 2611, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2613, '统计新增', 2611, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2614, '统计修改', 2611, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2615, '统计删除', 2611, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:carbonstatistics:remove', '#', 'admin', sysdate(), '', null, '');

-- ==================== 政务管理 ====================
INSERT INTO sys_menu VALUES(2700, '政务管理', 0, 11, 'gov', null, '', '', 1, 0, 'M', '0', '0', '', 'guide', 'admin', sysdate(), '', null, '政务管理目录');

INSERT INTO sys_menu VALUES(2701, '上牌登记', 2700, 1, 'registration', 'business/govregistration/index', '', '', 1, 0, 'C', '0', '0', 'business:govregistration:list', 'form', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2702, '登记查询', 2701, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2703, '登记新增', 2701, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2704, '登记修改', 2701, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2705, '登记删除', 2701, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:govregistration:remove', '#', 'admin', sysdate(), '', null, '');

-- ==================== 商户管理 ====================
INSERT INTO sys_menu VALUES(2800, '商户管理', 0, 12, 'merchant', null, '', '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', sysdate(), '', null, '商户管理目录');

INSERT INTO sys_menu VALUES(2801, '商户列表', 2800, 1, 'merchant', 'business/merchant/index', '', '', 1, 0, 'C', '0', '0', 'business:merchant:list', 'peoples', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2802, '商户查询', 2801, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2803, '商户新增', 2801, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2804, '商户修改', 2801, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2805, '商户删除', 2801, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'business:merchant:remove', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES(2810, '商户审核', 2800, 2, 'audit', 'business/merchant/audit/index', '', '', 1, 0, 'C', '0', '0', 'business:merchant:audit', 'peoples', 'admin', sysdate(), '', null, '商户审核菜单');
INSERT INTO sys_menu VALUES(2811, '审核查询', 2810, 1, '', '',  '', '', 1, 0, 'F', '0', '0', 'business:merchant:audit',        '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES(2812, '审核操作', 2810, 2, '', '',  '', '', 1, 0, 'F', '0', '0', 'business:merchant:audit',        '#', 'admin', sysdate(), '', null, '');

-- ============================================================
-- 将新菜单分配给 admin 角色 (role_key='admin')
-- 自动查找 admin 角色的 role_id 并建立关联
-- ============================================================
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT r.role_id, m.menu_id
FROM sys_role r, sys_menu m
WHERE r.role_key = 'admin'
  AND m.menu_id BETWEEN 2100 AND 2812
  AND NOT EXISTS (
    SELECT 1 FROM sys_role_menu rm
    WHERE rm.role_id = r.role_id AND rm.menu_id = m.menu_id
  );