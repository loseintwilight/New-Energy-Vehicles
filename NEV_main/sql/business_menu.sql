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

-- 3. 维保订单 菜单 (parent_id=2100)
INSERT INTO sys_menu VALUES(2110, '维保订单', 2100, 2, 'order', 'business/maintenance/order/index', '', '', 1, 0, 'C', '0', '0', 'business:morder:list', 'form', 'admin', sysdate(), '', null, '维保订单菜单');
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