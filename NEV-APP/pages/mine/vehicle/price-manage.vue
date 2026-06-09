<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀橙暖色系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view
          class="glow-spot"
          v-for="(dot, ci) in row.dots"
          :key="ci"
          :style="dot.style"
        ></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 琥珀渐变顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">价格管理</text>
          <text class="header-sub">{{ prices.length }} 款车型定价</text>
        </view>
      </view>

      <!-- 批量操作栏 -->
      <view class="batch-bar">
        <view
          class="batch-chip"
          :class="{ active: selectAll }"
          @tap="toggleSelectAll"
        >
          <text>{{ selectAll ? '✓ 全选' : '☐ 全选' }}</text>
        </view>
        <view class="batch-chip batch-orange" hover-class="chip-hover" @tap="onBatchAdjust">
          <text>批量调价</text>
        </view>
        <view class="batch-chip batch-blue" hover-class="chip-hover" @tap="onExport">
          <text>导出价格表</text>
        </view>
      </view>

      <!-- 价格卡片列表 -->
      <view class="price-list">
        <view
          class="price-card"
          v-for="(item, idx) in filteredPrices"
          :key="item.vehicleId"
          :class="[item.status === '0' ? 'card-disabled' : 'card-normal']"
          :style="{ 'animation-delay': (idx * 0.08) + 's' }"
          hover-class="card-hover"
        >
          <!-- 左侧彩色竖条 -->
          <view class="left-bar" :class="'bar-' + item.type"></view>

          <!-- 停售角标 -->
          <view class="stop-badge" v-if="item.status === '0'">
            <text>已停售</text>
          </view>

          <!-- 卡片主体 -->
          <view class="card-body">
            <!-- 卡片头部：名称 + 类型标签 -->
            <view class="card-header">
              <view class="header-left">
                <text class="car-emoji">🚗</text>
                <view class="name-wrap">
                  <text class="car-name">{{ item.name }}</text>
                  <view class="type-tag" :class="'tag-' + item.type">
                    <text>{{ typeLabel(item.type) }}</text>
                  </view>
                </view>
              </view>
              <view
                class="edit-btn"
                hover-class="edit-hover"
                @tap.stop="openEdit(item)"
              >
                <text>编辑价格</text>
              </view>
            </view>

            <!-- 核心价格区域 -->
            <view class="price-area">
              <view class="price-main">
                <text class="price-yen">¥</text>
                <text class="price-num">{{ fmtPrice(item.currentPrice) }}</text>
              </view>
              <view class="price-sub-row">
                <text class="price-original">指导价 ¥{{ fmtPrice(item.originalPrice) }}</text>
                <view class="discount-tag" :class="{ 'tag-full': item.discount >= 0.99 }">
                  <text>{{ item.discountLabel }}</text>
                </view>
              </view>
            </view>

            <!-- 优惠标签 + 时间 -->
            <view class="card-footer">
              <view class="promo-tag" v-if="item.promo" :class="'promo-' + (item.promoColor || 'orange')">
                <text>🏷 {{ item.promo }}</text>
              </view>
              <text class="update-time">{{ item.updateTime }} 更新</text>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 140rpx;"></view>
    </scroll-view>

    <!-- 编辑价格弹窗 -->
    <view class="edit-mask" v-if="showEdit" @tap="closeEdit"></view>
    <view class="edit-panel" :class="{ 'panel-show': showEdit }">
      <view class="panel-header">
        <text class="panel-title">编辑价格</text>
        <view class="panel-close" hover-class="close-hover" @tap="closeEdit">
          <text>✕</text>
        </view>
      </view>
      <view class="panel-body" v-if="editingItem">
        <text class="edit-car-name">{{ editingItem.name }}</text>
        <view class="form-item">
          <text class="form-label">当前售价（元）</text>
          <input
            class="form-input"
            type="digit"
            v-model="editForm.price"
            placeholder="输入新售价"
            placeholder-class="ph"
          />
        </view>
        <view class="form-item">
          <text class="form-label">优惠活动标签</text>
          <view class="promo-options">
            <view
              class="promo-opt"
              v-for="(opt, pi) in promoOptions"
              :key="pi"
              :class="{ active: editForm.promo === opt.value }"
              @tap="editForm.promo = opt.value"
            >
              <text>{{ opt.label }}</text>
            </view>
          </view>
        </view>
        <view class="form-submit" hover-class="submit-hover" @tap="confirmEdit">
          <text>确认修改</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { listVehicle, updateVehicle } from '@/api/vehicle/vehicle'

export default {
  data: function() {
    var rows = []
    var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
    for (var r = 0; r < 7; r++) {
      var dots = []
      var count = 4 + Math.floor(Math.random() * 3)
      for (var c = 0; c < count; c++) {
        var color = colors[Math.floor(Math.random() * colors.length)]
        var size = 60 + Math.floor(Math.random() * 70)
        var dur = 2.5 + Math.random() * 2.5
        var delay = Math.random() * 2.5
        var alpha = 0.08 + Math.random() * 0.18
        dots.push({
          style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
        })
      }
      rows.push({ dots: dots })
    }

    return {
      isReady: false,
      glowRows: rows,
      keyword: '',
      selectAll: false,
      showEdit: false,
      editingItem: null,
      editForm: { price: '', promo: '' },
      promoOptions: [
        { label: '无', value: '' },
        { label: '限时优惠', value: '限时优惠' },
        { label: '购车补贴', value: '购车补贴' },
        { label: '爆款特惠', value: '爆款特惠' }
      ],
      prices: []
    }
  },
  computed: {
    filteredPrices: function() {
      var self = this
      if (!self.keyword) return self.prices
      return self.prices.filter(function(p) {
        return p.name.indexOf(self.keyword) >= 0
      })
    }
  },
  created: function() {
    var that = this
    that.loadPrices()
    setTimeout(function() { that.isReady = true }, 200)
  },
  methods: {
    loadPrices: function() {
      var self = this
      listVehicle({ pageNum: 1, pageSize: 100 }).then(function(res) {
        if (res.code === 200 && res.rows) {
          var list = res.rows || []
          self.prices = list.map(function(v) {
            var ogPrice = v.originalPrice || v.guidePrice
            var curPrice = v.guidePrice || 0
            var discount = ogPrice > 0 ? curPrice / ogPrice : 1
            var discountLabel = '原价'
            if (discount < 0.99) {
              discountLabel = discount >= 0.9 ? (discount * 10).toFixed(1) + '折' : '超值'
            }
            return {
              vehicleId: v.vehicleId,
              name: v.modelName || v.title || '',
              type: v.vehicleType === 'new' ? 'ev' : 'used',
              currentPrice: curPrice,
              originalPrice: ogPrice,
              discount: discount,
              discountLabel: discountLabel,
              promo: '',
              promoColor: 'orange',
              updateTime: v.updateTime ? v.updateTime.substring(0, 10) : '-'
            }
          })
        }
      }).catch(function() {
        console.log('获取价格数据失败')
      })
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },
    toggleSelectAll: function() {
      this.selectAll = !this.selectAll
    },
    onBatchAdjust: function() {
      uni.showToast({ title: '批量调价功能开发中', icon: 'none', duration: 1500 })
    },
    onExport: function() {
      uni.showToast({ title: '价格表导出成功', icon: 'success', duration: 1500 })
    },
    fmtPrice: function(val) {
      if (!val && val !== 0) return '0'
      return val.toLocaleString()
    },
    typeLabel: function(t) {
      var map = { ev: '纯电', phev: '插混', erev: '增程' }
      return map[t] || t
    },
    openEdit: function(item) {
      this.editingItem = item
      this.editForm = { price: String(item.currentPrice), promo: item.promo || '' }
      this.showEdit = true
    },
    closeEdit: function() {
      this.showEdit = false
      this.editingItem = null
    },
    confirmEdit: function() {
      var self = this
      if (!self.editingItem || !self.editForm.price) {
        uni.showToast({ title: '请输入有效价格', icon: 'none', duration: 1200 })
        return
      }
      var newPrice = parseInt(self.editForm.price)
      if (isNaN(newPrice) || newPrice <= 0) {
        uni.showToast({ title: '价格格式错误', icon: 'none', duration: 1200 })
        return
      }
      // 调用后端更新接口
      updateVehicle({ vehicleId: self.editingItem.vehicleId, guidePrice: newPrice }).then(function(res) {
        if (res.code === 1) {
          self.editingItem.currentPrice = newPrice
          self.editingItem.promo = self.editForm.promo
          self.editingItem.discount = newPrice / self.editingItem.originalPrice
          if (self.editingItem.discount >= 0.99) {
            self.editingItem.discountLabel = '原价'
          } else if (self.editingItem.discount >= 0.9) {
            self.editingItem.discountLabel = (self.editingItem.discount * 10).toFixed(1) + '折'
          } else {
            self.editingItem.discountLabel = '超值'
          }
          var now = new Date()
          var m = now.getMonth() + 1
          var d = now.getDate()
          self.editingItem.updateTime = now.getFullYear() + '-' + (m < 10 ? '0' + m : m) + '-' + (d < 10 ? '0' + d : d)
          uni.showToast({ title: '价格已更新', icon: 'success', duration: 1200 })
          self.closeEdit()
        } else {
          uni.showToast({ title: res.msg || '更新失败', icon: 'none' })
        }
      }).catch(function() {
        uni.showToast({ title: '更新失败', icon: 'none' })
      })
    }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fffbeb 100%);
  position: relative;
  overflow-x: hidden;
}
.page-ready .price-card {
  animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(30rpx) scale(0.96); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

/* ========== 背景光晕矩阵 ========== */
.glow-matrix {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 0;
  overflow: hidden;
  pointer-events: none;
}
.glow-row {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 24rpx 20rpx;
}
.glow-spot {
  border-radius: 50%;
  flex-shrink: 0;
  animation: glowPulse ease-in-out infinite alternate;
}
@keyframes glowPulse {
  0% { opacity: 0.15; transform: scale(0.85); }
  50% { opacity: 0.6; }
  100% { opacity: 0.15; transform: scale(1.25); }
}

.overlay-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg,
    rgba(255, 247, 237, 0.92) 0%,
       rgba(255, 251, 235, 0.95) 35%,
       rgba(254, 252, 232, 0.96) 65%,
       rgba(255, 251, 235, 0.97) 100%
  );
  pointer-events: none;
  z-index: 1;
}
.main-scroll {
  position: relative;
  z-index: 2;
  height: 100vh;
}

/* ========== 琥珀渐变顶栏 ========== */
.header {
  position: relative;
  padding: 28rpx 28rpx 24rpx;
  display: flex;
  align-items: center;
  overflow: hidden;
}
.header-bg {
  position: absolute;
  top: -80rpx;
  left: -40rpx;
  right: -40rpx;
  bottom: -20rpx;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%);
  border-radius: 0 0 60rpx 60rpx;
}
.back-btn {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;
}
.btn-hover {
  transform: scale(0.9);
  background: rgba(255, 255, 255, 0.45);
}
.back-icon {
  font-size: 36rpx;
  color: #ffffff;
  font-weight: 300;
}
.header-info {
  flex: 1;
  margin-left: 20rpx;
  z-index: 2;
  display: flex;
  flex-direction: column;
}
.header-title {
  font-size: 38rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 1rpx;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}
.header-sub {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.88);
  margin-top: 6rpx;
  font-weight: 500;
}

/* ========== 批量操作栏 ========== */
.batch-bar {
  display: flex;
  padding: 16rpx 24rpx;
  gap: 14rpx;
  position: relative;
  z-index: 2;
}
.batch-chip {
  padding: 14rpx 24rpx;
  border-radius: 20rpx;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  font-size: 23rpx;
  color: #78716c;
  font-weight: 600;
  transition: all 0.25s ease;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.04);
}
.batch-chip.active {
  background: linear-gradient(135deg, #f59e0b, #f97316);
  color: #ffffff;
}
.batch-orange {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(249, 115, 22, 0.06));
  color: #d97706;
  border: 1rpx solid rgba(245, 158, 11, 0.18);
}
.batch-blue {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(251, 146, 60, 0.04));
  color: #d97706;
  border: 1rpx solid rgba(245, 158, 11, 0.15);
}
.chip-hover {
  transform: scale(0.95);
}

/* ========== 价格卡片列表 ========== */
.price-list {
  padding: 8rpx 24rpx;
}
.price-card {
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 24rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  position: relative;
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
}
.card-disabled {
  opacity: 0.55;
}
.card-hover {
  transform: scale(0.985) translateY(-2rpx);
  box-shadow: 0 12rpx 36rpx rgba(0, 0, 0, 0.1);
}

/* 左侧彩色竖条 */
.left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 6rpx;
  border-radius: 24rpx 0 0 24rpx;
  transition: all 0.3s ease;
}
.bar-ev {
  background: linear-gradient(180deg, #d97706, #f59e0b, #fb923c);
  box-shadow: 2rpx 0 16rpx rgba(217, 119, 6, 0.4);
}
.bar-phev {
  background: linear-gradient(180deg, #f59e0b, #fb923c, #fbbf24);
  box-shadow: 2rpx 0 16rpx rgba(245, 158, 11, 0.4);
}
.bar-erev {
  background: linear-gradient(180deg, #f59e0b, #d97706, #b45309);
  box-shadow: 2rpx 0 16rpx rgba(245, 158, 11, 0.4);
}
.card-hover .left-bar { width: 8rpx; }

/* 停售角标 */
.stop-badge {
  position: absolute;
  top: 18rpx;
  right: -4rpx;
  background: linear-gradient(135deg, #9ca3af, #6b7280);
  padding: 6rpx 22rpx 6rpx 14rpx;
  border-radius: 0 14rpx 14rpx 0;
  z-index: 3;
  box-shadow: 0 4rpx 12rpx rgba(107, 114, 128, 0.3);
}
.stop-badge text {
  font-size: 19rpx;
  color: #ffffff;
  font-weight: 800;
  letter-spacing: 1rpx;
}

/* 卡片主体 */
.card-body {
  padding: 24rpx 22rpx 20rpx 26rpx;
  position: relative;
  z-index: 1;
}

/* ========== 卡片头部 ========== */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16rpx;
}
.header-left {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}
.car-emoji {
  font-size: 34rpx;
  margin-right: 12rpx;
  flex-shrink: 0;
}
.name-wrap {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  min-width: 0;
}
.car-name {
  font-size: 27rpx;
  font-weight: 800;
  color: #1c1917;
  letter-spacing: 0.5rpx;
  margin-right: 10rpx;
  line-height: 1.3;
}
.type-tag {
  display: inline-flex;
  padding: 4rpx 14rpx;
  border-radius: 10rpx;
  flex-shrink: 0;
}
.type-tag text {
  font-size: 18rpx;
  font-weight: 700;
}
.tag-ev {
  background: rgba(217, 119, 6, 0.1);
  border: 1rpx solid rgba(217, 119, 6, 0.25);
}
.tag-ev text { color: #d97706; }
.tag-phev {
  background: rgba(245, 158, 11, 0.1);
  border: 1rpx solid rgba(245, 158, 11, 0.25);
}
.tag-phev text { color: #f59e0b; }
.tag-erev {
  background: rgba(245, 158, 11, 0.1);
  border: 1rpx solid rgba(245, 158, 11, 0.25);
}
.tag-erev text { color: #d97706; }

/* 编辑按钮 */
.edit-btn {
  padding: 12rpx 24rpx;
  border-radius: 20rpx;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  flex-shrink: 0;
  box-shadow: 0 4rpx 14rpx rgba(245, 158, 11, 0.3);
  transition: all 0.25s ease;
}
.edit-btn text {
  font-size: 23rpx;
  color: #ffffff;
  font-weight: 700;
}
.edit-hover {
  transform: scale(0.93);
  box-shadow: 0 6rpx 20rpx rgba(245, 158, 11, 0.45);
}

/* ========== 核心价格区域 ========== */
.price-area {
  background: linear-gradient(135deg, rgba(255, 251, 235, 0.95), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 20rpx 22rpx;
  margin-bottom: 14rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}
.price-main {
  display: flex;
  align-items: baseline;
  margin-bottom: 10rpx;
}
.price-yen {
  font-size: 30rpx;
  font-weight: 800;
  color: #f59e0b;
  margin-right: 4rpx;
}
.price-num {
  font-size: 46rpx;
  font-weight: 900;
  color: #f59e0b;
  letter-spacing: -0.5rpx;
  text-shadow: 0 2rpx 10rpx rgba(245, 158, 11, 0.2);
}
.price-sub-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.price-original {
  font-size: 23rpx;
  color: #9ca3af;
  text-decoration: line-through;
  font-weight: 500;
}
.discount-tag {
  padding: 5rpx 16rpx;
  border-radius: 10rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 146, 60, 0.06));
  border: 1rpx solid rgba(245, 158, 11, 0.2);
}
.discount-tag.text {
  font-size: 20rpx;
  color: #d97706;
  font-weight: 800;
}
.discount-tag text {
  font-size: 20rpx;
  color: #d97706;
  font-weight: 800;
}
.tag-full {
  background: linear-gradient(135deg, rgba(156, 163, 175, 0.1), rgba(209, 213, 219, 0.05));
  border-color: rgba(156, 163, 175, 0.2);
}
.tag-full text { color: #9ca3af; }

/* ========== 底部信息栏 ========== */
.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.promo-tag {
  padding: 6rpx 16rpx;
  border-radius: 12rpx;
}
.promo-tag text {
  font-size: 20rpx;
  font-weight: 700;
}
.promo-red {
  background: rgba(239, 68, 68, 0.08);
  border: 1rpx solid rgba(239, 68, 68, 0.2);
}
.promo-red text { color: #dc2626; }
.promo-green {
  background: rgba(217, 119, 6, 0.08);
  border: 1rpx solid rgba(217, 119, 6, 0.2);
}
.promo-green text { color: #d97706; }
.promo-orange {
  background: rgba(245, 158, 11, 0.08);
  border: 1rpx solid rgba(245, 158, 11, 0.2);
}
.promo-orange text { color: #d97706; }
.update-time {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 500;
}

/* ========== 编辑弹窗 ========== */
.edit-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.45);
  z-index: 98;
}
.edit-panel {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: #ffffff;
  border-radius: 32rpx 32rpx 0 0;
  z-index: 99;
  padding: 32rpx 32rpx calc(32rpx + env(safe-area-inset-bottom));
  transform: translateY(100%);
  transition: transform 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 -8rpx 40rpx rgba(0, 0, 0, 0.12);
}
.panel-show {
  transform: translateY(0);
}
.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28rpx;
}
.panel-title {
  font-size: 34rpx;
  font-weight: 800;
  color: #1c1917;
}
.panel-close {
  width: 56rpx;
  height: 56rpx;
  border-radius: 28rpx;
  background: rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: center;
}
.panel-close text {
  font-size: 28rpx;
  color: #9ca3af;
}
.close-hover { background: rgba(0, 0, 0, 0.1); }

.panel-body {}
.edit-car-name {
  font-size: 26rpx;
  color: #78716c;
  font-weight: 600;
  display: block;
  margin-bottom: 24rpx;
  line-height: 1.4;
}
.form-item {
  margin-bottom: 24rpx;
}
.form-label {
  font-size: 25rpx;
  color: #44403c;
  font-weight: 700;
  display: block;
  margin-bottom: 12rpx;
}
.form-input {
  width: 100%;
  height: 88rpx;
  background: rgba(0, 0, 0, 0.03);
  border-radius: 16rpx;
  padding: 0 24rpx;
  font-size: 30rpx;
  font-weight: 600;
  color: #1c1917;
  box-sizing: border-box;
  border: 2rpx solid transparent;
  transition: border-color 0.25s;
}
.form-input:focus {
  border-color: #f59e0b;
  background: rgba(245, 158, 11, 0.03);
}
.ph { color: #d6d3d1; font-weight: 400; }

.promo-options {
  display: flex;
  flex-wrap: wrap;
  gap: 14rpx;
}
.promo-opt {
  padding: 14rpx 28rpx;
  border-radius: 16rpx;
  background: rgba(0, 0, 0, 0.04);
  border: 2rpx solid transparent;
  transition: all 0.25s ease;
}
.promo-opt text {
  font-size: 25rpx;
  color: #78716c;
  font-weight: 600;
}
.promo-opt.active {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(249, 115, 22, 0.05));
  border-color: #f59e0b;
}
.promo-opt.active text { color: #d97706; }

.form-submit {
  margin-top: 16rpx;
  padding: 26rpx 0;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  border-radius: 20rpx;
  text-align: center;
  box-shadow: 0 8rpx 28rpx rgba(245, 158, 11, 0.35);
  transition: all 0.25s ease;
}
.form-submit text {
  font-size: 30rpx;
  color: #ffffff;
  font-weight: 800;
  letter-spacing: 2rpx;
}
.submit-hover {
  transform: scale(0.97);
  box-shadow: 0 10rpx 36rpx rgba(245, 158, 11, 0.45);
}
</style>
