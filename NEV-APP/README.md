# NEV-Life

基于 uni-app 开发的新能源汽车生活服务平台，支持 H5、小程序、Android 和 iOS 多端运行。

## 项目简介

NEV-Life 是一款专注于新能源汽车领域的移动端应用，提供充电服务、选车资讯等便捷功能。项目基于 RuoYi-App 移动框架开发，采用 Vue 2 + Vuex 技术栈。

## 核心功能

- **首页** — 应用入口，内容展示
- **充电服务** — 附近充电站查询、充电记录、充电套餐等服务
- **选车** — 新能源车型浏览与筛选
- **我的** — 个人中心、编辑资料、修改头像、密码修改、应用设置等

## 技术栈

| 技术 | 说明 | 版本 |
|------|------|------|
| [RuoYi-App](https://gitee.com/y_project/RuoYi-App) | 移动端开发框架 | v1.2.0 |
| [uni-app](https://uniapp.dcloud.net.cn/) | 跨平台应用框架 | Vue 2 版 |
| Vue | 前端 MVVM 框架 | 2.x |
| Vuex | 状态管理模式 | 2.x |
| [uni-ui](https://github.com/dcloudio/uni-ui) | 全端兼容 UI 组件库 | - |
| [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) | 配套后端框架 | 3.x |
| Scss | CSS 预处理 | - |
| uni-request | 网络请求封装 | - |

### 内置 uni-ui 组件

项目集成了丰富的 uni-ui 组件库，包括：`uni-badge`、`uni-card`、`uni-calendar`、`uni-collapse`、`uni-data-picker`、`uni-datetime-picker`、`uni-easyinput`、`uni-forms`、`uni-grid`、`uni-icons`、`uni-list`、`uni-nav-bar`、`uni-popup`、`uni-rate`、`uni-search-bar`、`uni-swipe-action`、`uni-tag` 等 40+ 组件。

### 前后端对接

- 后端可对接 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue)（SpringBoot + Vue 版）
- 或 [RuoYi-Cloud](https://github.com/yangzongzhuan/RuoYi-Cloud)（SpringCloud 微服务版）
- API 请求统一封装，已实现登录、注册、验证码、用户信息等接口对接

## 项目结构

```
NEV-APP
├─ api                    # 接口请求
│  ├─ login.js            # 登录相关接口
│  └─ system              # 系统模块接口
├─ components             # 公共组件
├─ pages                  # 页面文件
│  ├─ index.vue           # 首页
│  ├─ login.vue           # 登录
│  ├─ register.vue        # 注册
│  ├─ charge/index.vue    # 充电服务
│  ├─ car/index.vue       # 选车
│  ├─ mine/               # 我的模块
│  │  ├─ index.vue        # 个人中心
│  │  ├─ avatar/          # 修改头像
│  │  ├─ info/            # 个人信息
│  │  ├─ pwd/             # 修改密码
│  │  ├─ setting/         # 应用设置
│  │  ├─ help/            # 常见问题
│  │  └─ about/           # 关于我们
│  └─ common/             # 通用页面
├─ plugins                # 插件（页签操作、认证、弹窗）
├─ static                 # 静态资源
│  ├─ images              # 图片
│  ├─ scss                # 全局样式
│  └─ font                # 图标字体
├─ store                  # Vuex 状态管理
├─ utils                  # 工具函数
├─ pages.json             # 页面路由与 tabBar 配置
├─ config.js              # 应用全局配置
├─ manifest.json          # 应用配置（多端）
├─ permission.js          # 登录拦截权限控制
└─ main.js                # 应用入口
```

## 快速开始

```bash
# 安装依赖
npm install

# 启动 H5 开发服务
npm run dev:h5

# 启动微信小程序开发
npm run dev:mp-weixin

# 打包 H5
npm run build:h5
```

## 配置说明

应用配置在 `config.js` 中：

```js
baseUrl: 'https://vue.ruoyi.vip/prod-api'  // 后端接口地址
```

## 多端支持

- H5：`npm run dev:h5`
- 微信小程序：`npm run dev:mp-weixin`
- App（Android/iOS）：使用 HBuilderX 运行到手机或模拟器

## 登录账户

开发环境可使用演示账户进行登录测试。

## 参考资料

- [uni-app 官方文档](https://uniapp.dcloud.net.cn/)
- [uni-ui 组件库](https://uniapp.dcloud.net.cn/component/uni-ui/)
- [Vue 2 文档](https://v2.cn.vuejs.org/)