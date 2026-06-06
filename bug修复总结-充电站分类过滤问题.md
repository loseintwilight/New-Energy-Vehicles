# 充电站分类标签过滤 Bug 修复总结

## 问题描述

点击「免费停车」「快充优先」「慢充优先」「空闲优先」等分类标签时，列表没有正确显示过滤后的结果。虽然分类标签样式切换了、Toast 弹出了，但列表内容没有变化或显示错误。

## 根因分析

### 问题一：`rawStationList` 只在刷新路径下赋值

`fetchStationList` 方法中有两个分支：

- **`isRefresh = true`**（下拉刷新、切换城市等）：执行 `this.rawStationList = list` ✅
- **`isRefresh = false`**（页面首次加载、滚动加载更多）：只执行 `this.stationList = [...this.stationList, ...list]` ❌ **没有更新 `rawStationList`**

页面首次加载走的是 `fetchStationList()`（不带参数），所以 `rawStationList` 始终为空数组 `[]`。

### 问题二：`onFilterChange` 重新请求 API 导致竞态

原来的 `onFilterChange` 逻辑是：

```
设置 activeFilter → 清空 stationList → 调用 fetchStationList(true) 重新请求 API
```

而 `fetchStationList` 内部又执行 `applySort(applyFilter(list))`，依赖 `this.activeFilter`。虽然最终能拿到正确数据，但**多了一次无谓的 API 请求**，且如果 `rawStationList` 为空，切换标签后列表会被清空。

### 问题三：免费停车条件 `===` 精度不够

原条件 `s.parkInfo === '免费停车'` 是严格等于，但如果后端返回的字符串带前后空格（如 `" 免费停车"`），则无法匹配。

## 修复方案

### 修复 1：所有路径都保存 `rawStationList`

```javascript
// fetchStationList 中：
if (isRefresh) {
  this.rawStationList = list            // ✅ 刷新时
  ...
} else {
  this.rawStationList = [...this.rawStationList, ...list]  // ✅ 首次加载/翻页也保存
  this.stationList = [...this.stationList, ...list]
}
```

### 修复 2：`onFilterChange` 改为纯本地过滤 + 竞态防护

```javascript
onFilterChange(item) {
  this.activeFilter = item.key
  // 数据还没加载完成时，仅记录分类，API 返回后会自行过滤
  if (this.rawStationList.length === 0) return
  const filtered = this.applyFilter([...this.rawStationList])  // 直接过滤本地数据
  const sorted = this.applySort(filtered)                       // 排序
  this.stationList = sorted
  this.buildMarkers(this.stationList)                           // 更新地图标记
}
```

### 修复 2b：非刷新路径也应用活跃分类过滤

首次加载或翻页时（非 `isRefresh` 路径），如果已有活跃的分类标签，也对最终结果应用过滤：

```javascript
} else {
  this.rawStationList = [...this.rawStationList, ...list]
  // 如果有激活的分类过滤，对增量数据也应用过滤
  if (this.activeFilter !== 'distance') {
    this.stationList = this.applySort(this.applyFilter([...this.rawStationList]))
  } else {
    this.stationList = [...this.stationList, ...list]
  }
}
```

**解决竞态问题**：如果用户在 API 返回前快速点击了分类标签，`onFilterChange` 仅记录 `activeFilter` 后立即返回。API 响应到达后，`else` 分支检测到已有活跃分类，自动对完整数据执行过滤 → 用户看到正确结果。

### 修复 3：免费停车条件加 `trim()`

```javascript
// 之前
s => s.parkInfo === '免费停车'

// 之后
s => s.parkInfo && s.parkInfo.trim() === '免费停车'
```

### 修复 4：后端同步简化（仅精确匹配）

```java
// StationServiceImpl.java
boolean isFreePark = "免费停车".equals(parkFee);
item.setFreeParkTime(isFreePark ? 2 : 0);
```

去掉了之前对 `null`、`""`、`"0"`、`"免费"` 的宽松判断，只认数据库 `parking_fee` 精确等于 `"免费停车"` 的站点。

## 涉及文件

| 文件 | 改动 |
|------|------|
| `NEV-APP/pages/charge/index.vue` | 新增 `rawStationList`、`onFilterChange` 改为本地过滤、`freePark` 条件加 `trim()`、清除 debug 日志 |
| `NEV_main/.../StationServiceImpl.java` | 免费停车判断简化为精确 `equals("免费停车")` |

## 验证结果

修复后点击「免费停车」分类标签：
- Toast 提示"免费停车"
- 列表只显示 **数据库 `parking_fee` 精确等于 `"免费停车"` 的站点**
- 其他站点不再混入结果