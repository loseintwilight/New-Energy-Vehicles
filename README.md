# NEV_Life（新能源汽车生活平台）

一个面向新能源汽车生态的综合服务平台，覆盖用户端、商家端、充电运营商、维保商、政府监管等多端业务。

---

## 项目结构

```
NEV_Life/
├── NEV-APP/                # 移动端（uni-app：H5 + 小程序）
│   ├── pages/              # 页面（含 mine/、business/、charging/ 等）
│   ├── api/                # 接口请求封装
│   ├── store/              # Vuex 状态管理
│   ├── utils/              # 工具类（上传、请求等）
│   └── config/             # 环境配置
│
├── NEV_main/               # 后台管理端（RuoYi-Vue 框架）
│   ├── ruoyi-admin/        # 启动模块 + Controller
│   ├── ruoyi-system/       # 业务模块（Mapper / Service / Domain）
│   ├── ruoyi-common/       # 公共组件（配置、工具、Minio 等）
│   ├── ruoyi-framework/    # 框架核心
│   └── ruoyi-ui/           # 前端页面（Vue + Element）
│
├── sql/                    # 数据库脚本
│   └── new_energy.sql      # 主库脚本（含 gen_table、stad_* 业务表）
│
├── nginx/                  # 反向代理配置
├── deploy.sh               # 部署脚本
├── docker-compose.yml      # 容器编排
├── Dockerfile              # 镜像构建
└── .env                    # 环境变量
```

## 核心业务模块

| 模块 | 表前缀 | 说明 |
|------|--------|------|
| 车辆 | `stad_vehicle*` | 车辆基础信息、配置参数、金融方案、二手车、评价 |
| 充电 | `stad_charging_*` | 充电站、充电桩、订单、费率、结算 |
| 维保 | `stad_maintenance_*` | 维保门店、订单、预约 |
| 订单 | `stad_unified_order` | 统一订单（购车 + 试驾 + 以旧换新） |
| 商户 | `stad_merchant` | 经销商/充电商/维保商统一管理（按类型区分） |
| 用户 | `stad_user_*` | 用户扩展、地址、收藏、反馈 |
| 碳积分 | `stad_carbon_*` | 碳积分流水 + 减排统计（政府大屏） |
| 政务 | `stad_gov_nev_registration` | 新能源车上牌登记 |

## 角色身份

- `user` — 普通用户
- `dealer` — 经销商（dealer）
- `charger` — 充电运营商
- `maintenance` — 维保商
- `gov` — 政府监管

> 一个用户可通过"端切换"申请多个身份，每种身份独立审核、独立记录。

## 技术栈

- **后端**：Spring Boot 2.x + MyBatis + MySQL 8 + Redis + Minio
- **后台前端**：Vue 2 + Element UI（基于 RuoYi-Vue）
- **移动端**：uni-app / Vue（多端：H5、微信小程序、App）
- **部署**：Docker + Docker Compose + Nginx

## 本地开发

### 1. 数据库初始化

```bash
# 导入主库脚本
mysql -u root -p < sql/new_energy.sql
```

### 2. 启动后端

```bash
cd NEV_main
mvn clean install -DskipTests
# 启动 ruoyi-admin 模块的主类
```

默认账号：`admin / admin123`

### 3. 启动后台前端

```bash
cd NEV_main/ruoyi-ui
npm install
npm run dev
# 访问 http://localhost:80
```

### 4. 启动移动端

```bash
cd NEV-APP
npm install
# H5
npm run dev:h5
# 微信小程序
npm run dev:mp-weixin
```

## Docker 部署

```bash
# 一键启动（含 MySQL、Redis、Minio、后端、前端）
docker-compose up -d
```

## 文档

- 数据库变更记录请查看 `sql/` 目录
- 业务流程图位于 `docs/`（按模块拆分）
- 接口文档：启动后端后访问 `/swagger-ui.html`

## License

仅供学习与团队内部使用。
