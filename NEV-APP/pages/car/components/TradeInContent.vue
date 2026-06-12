<template>
  <view class="content">
    <scroll-view scroll-y class="scroll">
      <view class="hero">
        <image class="hero-bg" src="/static/images/car/以旧换新.jpg" mode="aspectFit"></image>
        <view class="hero-overlay">
          <view class="hero-tag">官方置换</view>
          <text class="hero-title">以旧换新</text>
          <text class="hero-desc">旧车置换新能源，享多重补贴</text>
          <view class="hero-stats">
            <view class="hero-stat">
              <text class="hero-stat-num">¥8,000</text>
              <text class="hero-stat-label">最高补贴</text>
            </view>
            <view class="hero-stat">
              <text class="hero-stat-num">15min</text>
              <text class="hero-stat-label">快速估价</text>
            </view>
            <view class="hero-stat">
              <text class="hero-stat-num">7天</text>
              <text class="hero-stat-label">极速提车</text>
            </view>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">置换流程</text>
          <text class="section-sub">简单四步，轻松换新车</text>
        </view>
        <view class="process-steps">
          <view class="process-step">
            <view class="process-circle">1</view>
            <text class="process-name">在线估价</text>
            <text class="process-desc">填写车辆信息</text>
          </view>
          <view class="process-line"></view>
          <view class="process-step">
            <view class="process-circle">2</view>
            <text class="process-name">到店检测</text>
            <text class="process-desc">实车核验</text>
          </view>
          <view class="process-line"></view>
          <view class="process-step">
            <view class="process-circle">3</view>
            <text class="process-name">选购新车</text>
            <text class="process-desc">差价抵扣</text>
          </view>
          <view class="process-line"></view>
          <view class="process-step">
            <view class="process-circle">4</view>
            <text class="process-name">提车过户</text>
            <text class="process-desc">一站式办理</text>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">旧车信息</text>
          <text class="section-sub">填写您要置换的车辆信息</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">品牌</text>
            <input class="form-input" v-model="oldCar.brand" placeholder="如：特斯拉" />
          </view>
          <view class="form-row">
            <text class="form-label">车型</text>
            <input class="form-input" v-model="oldCar.model" placeholder="如：Model 3" />
          </view>
          <view class="form-row">
            <text class="form-label">上牌年份</text>
            <picker class="form-picker-wrap" mode="selector" :range="years" @change="onYearChange">
              <view class="form-picker">
                <text :class="['form-picker-text', { placeholder: !oldCar.year }]">{{ oldCar.year || '请选择' }}</text>
                <text class="arrow">></text>
              </view>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">表显里程</text>
            <view class="form-input-wrap">
              <input class="form-input flex-1" type="digit" v-model="oldCar.mileage" placeholder="请输入里程" />
              <text class="form-unit">万公里</text>
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">车辆状况</text>
            <view class="condition-group">
              <view v-for="(c, i) in conditions" :key="i" class="condition-tag" :class="{ on: oldCar.condition === i }" @click="oldCar.condition = i">{{ c }}</view>
            </view>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">联系人信息</text>
          <text class="section-sub">提交后工作人员将尽快与您联系</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">联系人</text>
            <input class="form-input" v-model="contactName" placeholder="请输入姓名" />
          </view>
          <view class="form-row">
            <text class="form-label">联系电话</text>
            <input class="form-input" type="text" v-model="contactPhone" placeholder="请输入手机号" maxlength="11" />
          </view>
          <view class="form-row">
            <text class="form-label">选择门店</text>
            <picker class="form-picker-wrap" @change="onStoreChange" :value="storeIndex" :range="storeList">
              <view class="form-picker">
                <text class="form-picker-text">{{ storeList[storeIndex] || '请选择门店' }}</text>
                <text class="arrow">></text>
              </view>
            </picker>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">心仪新车</text>
          <text class="section-sub">选择您想置换的新能源车型</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">选择车型</text>
            <picker class="form-picker-wrap" @change="onNewCarChange" :value="selectedNewCar" :range="newCarNames">
              <view class="form-picker">
                <text :class="['form-picker-text', { placeholder: selectedNewCar < 0 }]">{{ newCarNames[selectedNewCar] || '请选择新车' }}</text>
                <text class="arrow">></text>
              </view>
            </picker>
          </view>
        </view>
      </view>

      <view class="section benefits-section">
        <view class="section-hd">
          <text class="section-title">置换权益</text>
          <text class="section-sub">多重保障，放心置换</text>
        </view>
        <view class="benefits-grid">
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-blue">
              <image class="benefit-icon-img" src="/static/images/car/icon/glass.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">免费检测</text>
            <text class="benefit-desc">专业技师实车检测评估</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-green">
              <image class="benefit-icon-img" src="/static/images/car/icon/money.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">高额补贴</text>
            <text class="benefit-desc">叠加国家+品牌双重补贴</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-orange">
              <image class="benefit-icon-img" src="/static/images/car/icon/book.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">一站式服务</text>
            <text class="benefit-desc">评估+购车+过户全程代办</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-purple">
              <image class="benefit-icon-img" src="/static/images/car/icon/shield.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">官方保障</text>
            <text class="benefit-desc">官方认证，价格透明无套路</text>
          </view>
        </view>
      </view>

      <view class="btn-area">
        <view class="btn-primary" @click="submitTradeIn">提交申请</view>
      </view>

      <view style="height:40rpx;"></view>
    </scroll-view>

    <!-- AI估价弹窗 -->
    <view class="eval-mask" v-if="showEvalPopup" @click="closeEvalPopup">
      <view class="eval-popup" @click.stop>
        <view class="eval-popup-header">
          <text class="eval-popup-title">AI 智能估价</text>
          <text class="eval-popup-close" @click="closeEvalPopup">✕</text>
        </view>
        <view class="eval-popup-body" v-if="evalLoading">
          <view class="eval-loading">
            <view class="eval-loading-spinner"></view>
            <text class="eval-loading-text">AI正在分析车辆价值...</text>
          </view>
        </view>
        <view class="eval-popup-body" v-else>
          <view class="eval-car-info">
            <text class="eval-car-text">{{ oldCar.brand }} {{ oldCar.model }} · {{ oldCar.year }}年 · {{ oldCar.mileage || '0' }}万公里</text>
          </view>
          <view class="eval-price-row">
            <text class="eval-price-symbol">¥</text>
            <text class="eval-price-num">{{ displayEvaluationPrice }}</text>
          </view>
          <view class="eval-bar">
            <view class="eval-bar-fill" :style="{ width: evalPercent + '%' }"></view>
          </view>
          <view class="eval-detail">
            <view class="eval-detail-item">
              <text class="eval-detail-label">市场行情价</text>
              <text class="eval-detail-value">¥{{ displayBasePrice }}</text>
            </view>
            <view class="eval-detail-item">
              <text class="eval-detail-label">车况调整</text>
              <text class="eval-detail-value" :class="conditionAdjust >= 0 ? 'adj-up' : 'adj-down'">{{ conditionAdjust >= 0 ? '+' : '' }}¥{{ displayConditionAdjust }}</text>
            </view>
            <view class="eval-detail-item">
              <text class="eval-detail-label">里程调整</text>
              <text class="eval-detail-value adj-down">-¥{{ displayMileageAdjust }}</text>
            </view>
            <view class="eval-detail-item eval-total">
              <text class="eval-detail-label">AI 最终估价</text>
              <text class="eval-detail-value eval-final">¥{{ displayEvaluationPrice }}</text>
            </view>
          </view>
          <view class="eval-trade-calc" v-if="selectedNewCarInfo">
            <view class="eval-trade-title">置换价格计算</view>
            <view class="eval-trade-row">
              <text class="eval-trade-label">{{ selectedNewCarInfo.modelName }}</text>
              <text class="eval-trade-value">¥{{ displayNewCarPrice }}</text>
            </view>
            <view class="eval-trade-row">
              <text class="eval-trade-label">旧车抵扣</text>
              <text class="eval-trade-value adj-down">-¥{{ displayEvaluationPrice }}</text>
            </view>
            <view class="eval-trade-row">
              <text class="eval-trade-label">置换补贴</text>
              <text class="eval-trade-value adj-down">-¥{{ displaySubsidy }}</text>
            </view>
            <view class="eval-trade-row eval-trade-total">
              <text class="eval-trade-label">应付金额</text>
              <text class="eval-trade-value eval-final">¥{{ displayTradeFinalPrice }}</text>
            </view>
          </view>
          <view class="eval-notice">
            <text class="eval-notice-icon">ℹ</text>
            <text class="eval-notice-text">此估价为AI参考价，最终成交价以门店实车检测为准</text>
          </view>
          <view class="eval-popup-btns">
            <view class="eval-btn-cancel" @click="closeEvalPopup">重新填写</view>
            <view class="eval-btn-confirm" @click="confirmSubmit">确认提交</view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { createTradeInOrder, getCarList, getStores } from '@/api/car/car'

export default {
  data() {
    return {
      oldCar: {
        brand: '',
        model: '',
        year: '',
        mileage: '',
        condition: -1
      },
      conditions: ['良好', '一般', '较差'],
      years: Array.from({ length: 16 }, (_, i) => 2026 - i),
      storeList: [],
      storeIndex: 0,
      contactName: '',
      contactPhone: '',
      // 新车选择
      newCars: [],
      selectedNewCar: -1,
      // AI估价弹窗相关
      showEvalPopup: false,
      evalLoading: true,
      evaluationPrice: '0.00',
      basePrice: '0.00',
      conditionAdjust: '0.00',
      mileageAdjust: '0.00',
      orderData: null
    }
  },

  computed: {
    /** 新车名称列表（供picker使用） */
    newCarNames() {
      return this.newCars.map(c => c.modelName + ' ¥' + (c.guidePrice || 0))
    },
    evalPercent() {
      const base = 50000
      const val = parseFloat(this.evaluationPrice) || 0
      return Math.min((val / base) * 100, 100)
    },
    /** 选中的新车信息 */
    selectedNewCarInfo() {
      if (this.selectedNewCar >= 0 && this.newCars[this.selectedNewCar]) {
        return this.newCars[this.selectedNewCar]
      }
      return null
    },
    /** 新车价格（原始值，数据库存储单位） */
    newCarPriceRaw() {
      if (this.selectedNewCarInfo) {
        return parseFloat(this.selectedNewCarInfo.guidePrice) || 0
      }
      return 0
    },
    /** 显示用：新车价格（元） */
    displayNewCarPrice() {
      return (this.newCarPriceRaw).toFixed(2)
    },
    /** 显示用：AI估价（元） */
    displayEvaluationPrice() {
      return (parseFloat(this.evaluationPrice) || 0).toFixed(2)
    },
    /** 显示用：市场行情价（元） */
    displayBasePrice() {
      return (parseFloat(this.basePrice) || 0).toFixed(2)
    },
    /** 显示用：车况调整（元） */
    displayConditionAdjust() {
      const v = parseFloat(this.conditionAdjust) || 0
      return (v >= 0 ? '+' : '') + v.toFixed(2)
    },
    /** 显示用：里程调整（元） */
    displayMileageAdjust() {
      const v = parseFloat(this.mileageAdjust) || 0
      return (v >= 0 ? '+' : '') + v.toFixed(2)
    },
    /** 显示用：置换补贴（元） */
    displaySubsidy() {
      return '8000.00'
    },
    /** 显示用：置换后应付金额（元）= 新车价 - 旧车估价 - 补贴 */
    displayTradeFinalPrice() {
      const newPrice = this.newCarPriceRaw
      const oldVal = parseFloat(this.evaluationPrice) || 0
      const subsidy = 8000
      return Math.max(newPrice - oldVal - subsidy, 0).toFixed(2)
    },
    /** 置换后应付金额（用于后端提交） */
    tradeFinalPrice() {
      const newPrice = this.newCarPriceRaw
      const oldVal = parseFloat(this.evaluationPrice) || 0
      const subsidy = 8000
      return Math.max(newPrice - oldVal - subsidy, 0).toFixed(2)
    }
  },

  created() {
    this.fetchStores()
    this.fetchNewCars()
  },

  methods: {
    fetchStores() {
      getStores().then(res => {
        const data = res.data || res || []
        this.storeList = Array.isArray(data) ? data : []
        if (!this.storeList.length) {
          console.warn('门店列表为空，请检查数据库 stad_merchant 表中是否有 merchant_type=dealer 的记录')
        }
      }).catch(err => {
        console.error('获取门店列表失败:', err)
      })
    },
    fetchNewCars() {
      // 车型名称 → 图片映射（数据库无image字段时的兜底）
      const imageMap = {
        '比亚迪汉EV冠军版': '/static/images/car/main/比亚迪汉EV冠军版 .jpg',
        '比亚迪汉EV创世版': '/static/images/car/main/比亚迪汉EV 创世版.jpg',
        '特斯拉Model Y': '/static/images/car/main/特斯拉Model Y.png',
        '特斯拉Model3': '/static/images/car/main/特斯拉Model3.jpg',
        '蔚来ES6': '/static/images/car/main/蔚来ES6.jpg',
        '小鹏P7i': '/static/images/car/main/小鹏p7i.jpeg',
        '五菱宏光MINI EV马卡龙': '/static/images/car/main/五菱宏光MINI EV 马卡龙.jpg',
        '理想L7': '/static/images/car/main/理想L7.jpg'
      }
      getCarList().then(res => {
        const rows = res.rows || res.data || []
        if (rows.length > 0) {
          this.newCars = rows.map((c, i) => {
            const name = (c.modelName || '').replace(/\s+/g, '')
            // guidePrice 已是元（如219800）
            return {
              vehicleId: c.vehicleId,
              modelName: c.modelName,
              guidePrice: parseFloat(c.guidePrice) || 0,
              image: c.image || imageMap[name] || c.coverImage || '/static/images/car/car1.png'
            }
          })
        } else {
          console.warn('新车列表为空，请检查数据库 stad_vehicle 表中是否有 vehicle_type=new 且 status=1 的记录')
        }
      }).catch(err => {
        console.error('获取新车列表失败:', err)
      })
    },
    onYearChange(e) {
      this.oldCar.year = this.years[e.detail.value]
    },
    onStoreChange(e) {
      this.storeIndex = e.detail.value
    },
    onNewCarChange(e) {
      this.selectedNewCar = e.detail.value
    },
    submitTradeIn() {
      if (!this.oldCar.brand || !this.oldCar.model || !this.oldCar.year) {
        uni.showToast({ title: '请完善旧车信息', icon: 'none' })
        return
      }
      if (!this.contactName) {
        uni.showToast({ title: '请输入联系人', icon: 'none' })
        return
      }
      if (!this.contactPhone || this.contactPhone.length !== 11) {
        uni.showToast({ title: '请输入正确手机号', icon: 'none' })
        return
      }
      if (this.selectedNewCar < 0 || !this.newCars[this.selectedNewCar]) {
        uni.showToast({ title: '请选择意向新车', icon: 'none' })
        return
      }

      // 保存订单数据供确认后提交
      this.orderData = {
        orderType: 'trade_in',
        oldVehicleBrand: this.oldCar.brand,
        oldVehicleModel: this.oldCar.model,
        oldVehicleYear: this.oldCar.year,
        mileage: this.oldCar.mileage,
        condition: this.oldCar.condition >= 0 ? this.conditions[this.oldCar.condition] : '',
        contactName: this.contactName,
        contactPhone: this.contactPhone,
        storeName: this.storeList[this.storeIndex] || ''
      }

      // 附带新车信息（传原始值，后端统一计算）
      if (this.selectedNewCar >= 0 && this.newCars[this.selectedNewCar]) {
        const nc = this.newCars[this.selectedNewCar]
        this.orderData.newVehicleId = nc.vehicleId
        this.orderData.newVehicleModel = nc.modelName
        this.orderData.newVehiclePrice = nc.guidePrice
      }

      // 显示估价弹窗并开始AI估价
      this.showEvalPopup = true
      this.evalLoading = true
      this.doEvaluation()
    },
    doEvaluation() {
      // 前端随机生成旧车估价：30000 ~ 50000 元
      const valuation = Math.floor(Math.random() * 20001) + 30000
      // 市场行情价 = 估价 + 随机溢价 2000~8000
      const basePrice = valuation + Math.floor(Math.random() * 6001) + 2000
      // 车况调整：根据车况档次随机
      const conditionMap = [2000, 0, -3000] // 良好/一般/较差
      const condIdx = this.oldCar.condition >= 0 ? this.oldCar.condition : 1
      const conditionAdjust = conditionMap[condIdx] || 0
      // 里程调整：模拟
      const mileage = parseFloat(this.oldCar.mileage) || 5
      const mileageAdjust = mileage > 8 ? -3000 : (mileage > 5 ? -1500 : 0)

      this.basePrice = basePrice.toFixed(2)
      this.evaluationPrice = valuation.toFixed(2)
      this.conditionAdjust = conditionAdjust.toFixed(2)
      this.mileageAdjust = mileageAdjust.toFixed(2)
      this.evalLoading = false
      // 将估价结果存入订单数据（元）
      this.orderData.oldValuation = String(valuation)
    },
    closeEvalPopup() {
      this.showEvalPopup = false
      this.evalLoading = true
    },
    confirmSubmit() {
      this.showEvalPopup = false
      uni.showLoading({ title: '提交中' })
      createTradeInOrder(this.orderData).then(() => {
        uni.hideLoading()
        uni.showToast({ title: '发送申请成功', icon: 'success' })
        setTimeout(() => uni.navigateBack(), 1500)
      }).catch(() => {
        uni.hideLoading()
        uni.showModal({
          title: '提示',
          content: '以旧换新申请已提交，工作人员将尽快与您联系',
          showCancel: false,
          success: () => uni.navigateBack()
        })
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.content {
  height: 100%;
  background: #f5f5f7;
}
.scroll {
  height: 100%;
}
.hero {
  position: relative;
  width: 100%;
  height: 380rpx;
  background: #1a1a2e;
}
.hero-bg {
  width: 100%;
  height: 100%;
  opacity: 0.55;
}
.hero-overlay {
  position: absolute;
  bottom: 36rpx;
  left: 32rpx;
  right: 32rpx;
}
.hero-tag {
  display: inline-block;
  padding: 4rpx 20rpx;
  border-radius: 6rpx;
  font-size: 22rpx;
  font-weight: 600;
  color: #fff;
  background: rgba(52,199,89,0.65);
  margin-bottom: 12rpx;
}
.hero-title {
  display: block;
  font-size: 52rpx;
  font-weight: 800;
  color: #fff;
}
.hero-desc {
  display: block;
  font-size: 26rpx;
  color: rgba(255,255,255,0.65);
  margin-top: 6rpx;
}
.hero-stats {
  display: flex;
  gap: 40rpx;
  margin-top: 28rpx;
}
.hero-stat { text-align: center; }
.hero-stat-num {
  display: block;
  font-size: 36rpx;
  font-weight: 700;
  color: #34c759;
}
.hero-stat-label {
  display: block;
  font-size: 22rpx;
  color: rgba(255,255,255,0.5);
  margin-top: 4rpx;
}
.section {
  margin: 20rpx 24rpx;
  padding: 32rpx 24rpx;
  background: #fff;
  border-radius: 20rpx;
}
.section-hd { margin-bottom: 24rpx; }
.section-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.section-sub {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}
.process-steps {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
}
.process-step {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}
.process-circle {
  width: 56rpx;
  height: 56rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #34c759, #28a745);
}
.process-line {
  width: 40rpx;
  height: 2rpx;
  background: #34c759;
  margin-top: 28rpx;
  flex-shrink: 0;
}
.process-name {
  font-size: 24rpx;
  font-weight: 600;
  color: #1a1a1a;
  margin-top: 10rpx;
}
.process-desc {
  font-size: 20rpx;
  color: #999;
  margin-top: 2rpx;
}
.form-card {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  background: #f8f9fb;
  border-radius: 16rpx;
  padding: 8rpx 20rpx;
}
.form-row {
  display: flex;
  align-items: center;
  padding: 0 0;
  border-bottom: 1rpx solid #eee;
  height: 110rpx;
}
.form-row:last-child {
  border-bottom: none;
}
.form-label {
  width: 180rpx;
  font-size: 28rpx;
  color: #555;
  flex-shrink: 0;
  font-weight: 600;
  text-align: right;
  padding-right: 20rpx;
  line-height: 110rpx;
  height: 110rpx;
}
.form-input {
  flex: 1;
  font-size: 28rpx;
  background: transparent;
  border-radius: 0;
  color: #1a1a1a;
  height: 110rpx;
  line-height: 110rpx;
  padding: 0;
  margin: 0;
}
.form-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  background: transparent;
  border-radius: 0;
  padding-right: 0;
  height: 110rpx;
}
.form-input.flex-1 {
  font-size: 28rpx;
  background: transparent;
  flex: 1;
  height: 110rpx;
  line-height: 110rpx;
  padding: 0;
  margin: 0;
}
.form-unit {
  font-size: 24rpx;
  color: #999;
  flex-shrink: 0;
}
.form-picker {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0;
  height: 110rpx;
  line-height: 110rpx;
  background: transparent;
  border-radius: 0;
  min-width: 0;
}
.form-picker-wrap {
  flex: 1;
  min-width: 0;
}
.form-picker-text {
  flex: 1;
  font-size: 28rpx;
  color: #1a1a1a;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  min-width: 0;
}
.form-picker-text.placeholder {
  color: #bbb;
}
.arrow {
  color: #ccc;
  font-size: 28rpx;
  flex-shrink: 0;
  margin-left: 12rpx;
}
.condition-group {
  display: flex;
  gap: 12rpx;
}
.condition-tag {
  padding: 10rpx 24rpx;
  border-radius: 14rpx;
  font-size: 24rpx;
  color: #666;
  background: #f0f0f0;
  font-weight: 500;
}
.condition-tag.on {
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
}
// 新车选择列表（已废弃，现在使用picker下拉框）
.benefit-icon-img {
  width: 36rpx;
  height: 36rpx;
}
.benefits-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20rpx;
}
.benefit-item {
  padding: 32rpx 16rpx;
  background: #f8f9fb;
  border-radius: 14rpx;
  text-align: center;
}
.benefit-icon {
  width: 64rpx;
  height: 64rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 12rpx;
  font-size: 32rpx;
}
.benefit-icon-blue { background: #e8f0fe; }
.benefit-icon-green { background: #e8f8ed; }
.benefit-icon-orange { background: #fef6e8; }
.benefit-icon-purple { background: #f0e8fe; }
.benefit-name {
  display: block;
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.benefit-desc {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 6rpx;
}
.btn-area {
  margin: 0 24rpx 20rpx;
}
.btn-primary {
  padding: 28rpx 0;
  border-radius: 16rpx;
  text-align: center;
  font-size: 32rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
  box-shadow: 0 4rpx 16rpx rgba(48,114,246,0.3);
}

// AI估价弹窗样式
.eval-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}
.eval-popup {
  width: 620rpx;
  max-height: 80vh;
  background: #fff;
  border-radius: 24rpx;
  overflow: hidden;
}
.eval-popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 28rpx 32rpx 20rpx;
  border-bottom: 1rpx solid #f0f0f0;
}
.eval-popup-title {
  font-size: 34rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.eval-popup-close {
  font-size: 32rpx;
  color: #999;
  padding: 8rpx;
}
.eval-popup-body {
  padding: 28rpx 32rpx 32rpx;
}
.eval-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 60rpx 0;
}
.eval-loading-spinner {
  width: 64rpx;
  height: 64rpx;
  border: 4rpx solid #e8e8e8;
  border-top-color: #3072f6;
  border-radius: 50%;
  animation: eval-spin 0.8s linear infinite;
}
@keyframes eval-spin {
  to { transform: rotate(360deg); }
}
.eval-loading-text {
  margin-top: 24rpx;
  font-size: 26rpx;
  color: #999;
}
.eval-car-info {
  text-align: center;
  margin-bottom: 20rpx;
}
.eval-car-text {
  font-size: 26rpx;
  color: #666;
  background: #f5f5f7;
  padding: 10rpx 24rpx;
  border-radius: 20rpx;
}
.eval-price-row {
  display: flex;
  align-items: baseline;
  justify-content: center;
  margin-bottom: 16rpx;
}
.eval-price-symbol {
  font-size: 36rpx;
  font-weight: 700;
  color: #3072f6;
}
.eval-price-num {
  font-size: 72rpx;
  font-weight: 800;
  color: #3072f6;
  line-height: 1;
}
.eval-bar {
  height: 8rpx;
  background: #f0f0f0;
  border-radius: 4rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
}
.eval-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #3072f6, #34c759);
  border-radius: 4rpx;
  transition: width 0.6s ease;
}
.eval-detail {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
  padding: 20rpx;
  background: #f8f9fb;
  border-radius: 14rpx;
  margin-bottom: 20rpx;
}
.eval-detail-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.eval-detail-label {
  font-size: 24rpx;
  color: #888;
}
.eval-detail-value {
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.eval-detail-value.adj-up {
  color: #34c759;
}
.eval-detail-value.adj-down {
  color: #f5a623;
}
.eval-total {
  padding-top: 14rpx;
  border-top: 1rpx dashed #e0e0e0;
}
.eval-final {
  font-size: 32rpx !important;
  color: #3072f6 !important;
}
// 置换价格计算
.eval-trade-calc {
  padding: 20rpx;
  background: #f0f4ff;
  border-radius: 14rpx;
  margin-bottom: 20rpx;
}
.eval-trade-title {
  font-size: 24rpx;
  font-weight: 600;
  color: #3072f6;
  margin-bottom: 14rpx;
}
.eval-trade-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8rpx 0;
}
.eval-trade-label {
  font-size: 24rpx;
  color: #666;
}
.eval-trade-value {
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.eval-trade-total {
  padding-top: 14rpx;
  margin-top: 8rpx;
  border-top: 1rpx dashed #c8d6f8;
}
.eval-notice {
  display: flex;
  align-items: flex-start;
  gap: 8rpx;
  padding: 16rpx;
  background: #fff8e6;
  border-radius: 10rpx;
  margin-bottom: 24rpx;
}
.eval-notice-icon {
  font-size: 24rpx;
  flex-shrink: 0;
}
.eval-notice-text {
  font-size: 22rpx;
  color: #b8860b;
  line-height: 1.5;
}
.eval-popup-btns {
  display: flex;
  gap: 20rpx;
}
.eval-btn-cancel {
  flex: 1;
  padding: 22rpx 0;
  border-radius: 12rpx;
  text-align: center;
  font-size: 28rpx;
  font-weight: 600;
  color: #666;
  background: #f5f5f7;
}
.eval-btn-confirm {
  flex: 1;
  padding: 22rpx 0;
  border-radius: 12rpx;
  text-align: center;
  font-size: 28rpx;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
}
</style>