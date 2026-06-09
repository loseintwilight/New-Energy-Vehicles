<template>
  <view class="page-container">

    <!-- 余额卡片 -->
    <view class="balance-section">
      <view class="balance-card">
        <view class="card-bg"></view>
        <view class="card-content">
          <view class="balance-header">
            <text class="balance-label">账户余额</text>
            <text class="balance-unit">元</text>
          </view>
          <view class="balance-amount">
            <text class="amount-symbol">¥</text>
            <text class="amount-value">{{ formattedBalance }}</text>
          </view>
          <view class="balance-actions">
            <view class="action-btn primary" @click="handleRecharge">
              <uni-icons type="info" size="24" color="#fff"></uni-icons>
              <text>充值</text>
            </view>
            <view class="action-btn secondary" @click="handleWithdraw">
              <uni-icons type="list" size="24" color="#fff"></uni-icons>
              <text>提现</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 统计数据 -->
      <view class="stats-row">
        <view class="stat-item">
          <text class="stat-value">{{ formattedRecharge }}</text>
          <text class="stat-label">累计充值</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-value">{{ formattedWithdraw }}</text>
          <text class="stat-label">累计提现</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-value">{{ formattedFreeze }}</text>
          <text class="stat-label">冻结金额</text>
        </view>
      </view>
    </view>

    <!-- 交易记录 -->
    <view class="section">
      <view class="section-header">
        <text class="section-title">交易记录</text>
        <text class="section-more" v-if="transactions.length > 0">查看全部</text>
      </view>

      <view class="transaction-list" v-if="transactions.length > 0">
        <view 
          v-for="item in transactions" 
          :key="item.id" 
          class="tx-item"
          @click="showTransactionDetail(item)"
        >
          <view class="tx-icon-wrap">
            <view class="tx-icon" :class="item.type === 'income' ? 'income' : 'expense'">
              <uni-icons :type="item.type === 'income' ? 'info' : 'location'" size="24" color="#fff"></uni-icons>
            </view>
          </view>
          <view class="tx-content">
            <view class="tx-header">
              <text class="tx-title">{{ item.title }}</text>
              <text class="tx-amount" :class="item.type === 'income' ? 'income' : 'expense'">
                {{ item.type === 'income' ? '+' : '-' }}¥{{ item.amount }}
              </text>
            </view>
            <text class="tx-time">{{ item.time }}</text>
          </view>
          <view class="tx-arrow">
            <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
          </view>
        </view>
      </view>

      <view class="empty-state" v-else>
        <view class="empty-icon">
          <uni-icons type="info" size="80" color="#e0e0e0"></uni-icons>
        </view>
        <text class="empty-text">暂无交易记录</text>
        <text class="empty-hint">充值或消费后将在这里显示</text>
      </view>
    </view>

    <!-- 充值弹窗 -->
    <view class="modal-overlay" v-if="showRechargeModal" @click="closeRechargeModal">
      <view class="modal-content" @click.stop>
        <view class="modal-header">
          <text class="modal-title">充值</text>
          <view class="modal-close" @click="closeRechargeModal">
            <uni-icons type="info" size="28" color="#999"></uni-icons>
          </view>
        </view>
        <view class="modal-body">
          <view class="recharge-amounts">
            <view 
              v-for="amount in quickAmounts" 
              :key="amount"
              class="amount-option"
              :class="{ active: rechargeAmount === amount }"
              @click="rechargeAmount = amount"
            >
              ¥{{ amount }}
            </view>
          </view>
          <view class="custom-amount">
            <text class="label">自定义金额</text>
            <view class="input-wrap">
              <text class="input-prefix">¥</text>
              <input 
                type="digit" 
                v-model="customAmount" 
                placeholder="请输入金额"
                class="amount-input"
                @input="onCustomAmountInput"
              />
            </view>
          </view>
        </view>
        <view class="modal-footer">
          <view 
            class="confirm-btn" 
            :class="{ disabled: !canRecharge }"
            @click="confirmRecharge"
          >
            确认充值 ¥{{ rechargeAmount }}
          </view>
        </view>
      </view>
    </view>

    <!-- 提现弹窗 -->
    <view class="modal-overlay" v-if="showWithdrawModal" @click="closeWithdrawModal">
      <view class="modal-content" @click.stop>
        <view class="modal-header">
          <text class="modal-title">提现</text>
          <view class="modal-close" @click="closeWithdrawModal">
            <uni-icons type="info" size="28" color="#999"></uni-icons>
          </view>
        </view>
        <view class="modal-body">
          <view class="withdraw-info">
            <text class="info-label">可提现余额</text>
            <text class="info-value">¥{{ balance }}</text>
          </view>
          <view class="custom-amount">
            <text class="label">提现金额</text>
            <view class="input-wrap">
              <text class="input-prefix">¥</text>
              <input 
                type="digit" 
                v-model="withdrawAmount" 
                placeholder="请输入金额"
                class="amount-input"
              />
            </view>
          </view>
          <view class="withdraw-fee">
            <text class="fee-label">手续费</text>
            <text class="fee-value">¥0.00</text>
          </view>
        </view>
        <view class="modal-footer">
          <view 
            class="confirm-btn" 
            :class="{ disabled: !canWithdraw }"
            @click="confirmWithdraw"
          >
            确认提现
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { getWalletInfo, recharge, withdraw } from '@/api/mine/wallet'

export default {
  data() {
    return {
      balance: '0.00',
      totalRecharge: '0.00',
      totalWithdraw: '0.00',
      freezeAmount: '0.00',
      transactions: [],
      loading: false,
      
      // 充值弹窗
      showRechargeModal: false,
      rechargeAmount: 0,
      customAmount: '',
      quickAmounts: [100, 200, 500, 1000],
      
      // 提现弹窗
      showWithdrawModal: false,
      withdrawAmount: ''
    }
  },
  computed: {
    formattedBalance() {
      return parseFloat(this.balance).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
    },
    formattedRecharge() {
      return '¥' + parseFloat(this.totalRecharge).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
    },
    formattedWithdraw() {
      return '¥' + parseFloat(this.totalWithdraw).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
    },
    formattedFreeze() {
      return '¥' + parseFloat(this.freezeAmount).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
    },
    canRecharge() {
      return this.rechargeAmount > 0
    },
    canWithdraw() {
      const amount = parseFloat(this.withdrawAmount)
      const bal = parseFloat(this.balance)
      return amount > 0 && amount <= bal
    }
  },
  onLoad() {
    this.loadWalletInfo()
  },
  onShow() {
    this.loadWalletInfo()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    async loadWalletInfo() {
      this.loading = true
      try {
        const res = await getWalletInfo()
        if (res && (res.code === 200 || res.code === 0)) {
          const data = res.data || res
          this.balance = (data.balance || 0).toFixed(2)
          this.totalRecharge = (data.totalRecharge || 0).toFixed(2)
          this.totalWithdraw = (data.totalWithdraw || 0).toFixed(2)
          this.freezeAmount = (data.freezeAmount || 0).toFixed(2)
          
          // 生成模拟交易记录
          this.generateMockTransactions()
        }
      } catch (e) {
        console.error('加载钱包信息失败', e)
        uni.showToast({ title: '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    generateMockTransactions() {
      // 如果没有真实交易记录，生成模拟数据
      if (parseFloat(this.totalRecharge) > 0 || parseFloat(this.totalWithdraw) > 0) {
        this.transactions = [
          {
            id: 1,
            type: 'income',
            title: '账户充值',
            amount: '200.00',
            time: '2025-06-08 14:30:00'
          },
          {
            id: 2,
            type: 'expense',
            title: '充电消费',
            amount: '15.50',
            time: '2025-06-08 10:20:00'
          },
          {
            id: 3,
            type: 'income',
            title: '账户充值',
            amount: '500.00',
            time: '2025-06-07 16:45:00'
          },
          {
            id: 4,
            type: 'expense',
            title: '购车订金',
            amount: '1000.00',
            time: '2025-06-05 09:00:00'
          }
        ]
      }
    },
    handleRecharge() {
      this.showRechargeModal = true
      this.rechargeAmount = 0
      this.customAmount = ''
    },
    closeRechargeModal() {
      this.showRechargeModal = false
    },
    onCustomAmountInput() {
      const val = parseFloat(this.customAmount)
      this.rechargeAmount = isNaN(val) ? 0 : val
    },
    async confirmRecharge() {
      if (!this.canRecharge) return
      
      try {
        await recharge({ amount: this.rechargeAmount })
        this.balance = (parseFloat(this.balance) + this.rechargeAmount).toFixed(2)
        this.totalRecharge = (parseFloat(this.totalRecharge) + this.rechargeAmount).toFixed(2)
        
        this.transactions.unshift({
          id: Date.now(),
          type: 'income',
          title: '账户充值',
          amount: this.rechargeAmount.toFixed(2),
          time: this.getNow()
        })
        
        uni.showToast({ title: '充值成功', icon: 'success' })
        this.closeRechargeModal()
      } catch (e) {
        uni.showToast({ title: '充值失败', icon: 'none' })
      }
    },
    handleWithdraw() {
      this.showWithdrawModal = true
      this.withdrawAmount = ''
    },
    closeWithdrawModal() {
      this.showWithdrawModal = false
    },
    async confirmWithdraw() {
      if (!this.canWithdraw) return
      
      try {
        await withdraw({ amount: parseFloat(this.withdrawAmount) })
        const amount = parseFloat(this.withdrawAmount)
        this.balance = (parseFloat(this.balance) - amount).toFixed(2)
        this.totalWithdraw = (parseFloat(this.totalWithdraw) + amount).toFixed(2)
        
        this.transactions.unshift({
          id: Date.now(),
          type: 'expense',
          title: '提现',
          amount: amount.toFixed(2),
          time: this.getNow()
        })
        
        uni.showToast({ title: '提现成功', icon: 'success' })
        this.closeWithdrawModal()
      } catch (e) {
        uni.showToast({ title: e.message || '提现失败', icon: 'none' })
      }
    },
    showTransactionDetail(item) {
      uni.showToast({
        title: `${item.title}: ¥${item.amount}`,
        icon: 'none',
        duration: 2000
      })
    },
    getNow() {
      const d = new Date()
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}:${String(d.getSeconds()).padStart(2, '0')}`
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.balance-section {
  padding: 30rpx;
}

.balance-card {
  position: relative;
  border-radius: 24rpx;
  overflow: hidden;
  padding: 40rpx;
  background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 50%, #3b82f6 100%);
}

.card-bg {
  position: absolute;
  top: -50%;
  right: -20%;
  width: 200rpx;
  height: 200rpx;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
}

.card-content {
  position: relative;
  z-index: 1;
}

.balance-header {
  display: flex;
  align-items: center;
  gap: 8rpx;
  margin-bottom: 16rpx;
}

.balance-label {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.8);
}

.balance-unit {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.6);
}

.balance-amount {
  display: flex;
  align-items: baseline;
  margin-bottom: 30rpx;
}

.amount-symbol {
  font-size: 36rpx;
  font-weight: 600;
  color: #fff;
  margin-right: 8rpx;
}

.amount-value {
  font-size: 64rpx;
  font-weight: 700;
  color: #fff;
}

.balance-actions {
  display: flex;
  gap: 20rpx;
}

.action-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  padding: 20rpx;
  border-radius: 16rpx;
  font-size: 28rpx;
  color: #fff;
}

.action-btn.primary {
  background-color: rgba(255, 255, 255, 0.25);
}

.action-btn.secondary {
  background-color: rgba(255, 255, 255, 0.15);
}

.stats-row {
  display: flex;
  align-items: center;
  justify-content: space-around;
  background-color: #fff;
  margin-top: -20rpx;
  border-radius: 16rpx;
  padding: 30rpx 20rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.stat-value {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
}

.stat-label {
  font-size: 22rpx;
  color: #999;
  margin-top: 8rpx;
}

.stat-divider {
  width: 1rpx;
  height: 40rpx;
  background-color: #eee;
}

.section {
  padding: 0 30rpx 30rpx;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
}

.section-more {
  font-size: 26rpx;
  color: #666;
}

.transaction-list {
  background-color: #fff;
  border-radius: 16rpx;
  overflow: hidden;
}

.tx-item {
  display: flex;
  align-items: center;
  padding: 24rpx;
  border-bottom: 1rpx solid #f5f5f5;
}

.tx-item:last-child {
  border-bottom: none;
}

.tx-icon-wrap {
  flex-shrink: 0;
}

.tx-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.tx-icon.income {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.tx-icon.expense {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
}

.tx-content {
  flex: 1;
  margin-left: 20rpx;
  overflow: hidden;
}

.tx-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.tx-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.tx-amount {
  font-size: 30rpx;
  font-weight: 600;
}

.tx-amount.income {
  color: #10b981;
}

.tx-amount.expense {
  color: #ef4444;
}

.tx-time {
  font-size: 24rpx;
  color: #999;
  margin-top: 8rpx;
  display: block;
}

.tx-arrow {
  flex-shrink: 0;
  margin-left: 16rpx;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 40rpx;
  background-color: #fff;
  border-radius: 16rpx;
}

.empty-icon {
  margin-bottom: 24rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 8rpx;
}

.empty-hint {
  font-size: 24rpx;
  color: #ccc;
}

/* 弹窗样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: flex-end;
  z-index: 1000;
}

.modal-content {
  width: 100%;
  background-color: #fff;
  border-radius: 24rpx 24rpx 0 0;
  padding: 30rpx;
  padding-bottom: calc(30rpx + env(safe-area-inset-bottom));
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 30rpx;
}

.modal-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #333;
}

.modal-close {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-body {
  margin-bottom: 30rpx;
}

.recharge-amounts {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.amount-option {
  padding: 20rpx 40rpx;
  background-color: #f5f6f7;
  border-radius: 40rpx;
  font-size: 28rpx;
  color: #333;
}

.amount-option.active {
  background-color: #2563eb;
  color: #fff;
}

.custom-amount {
  margin-bottom: 20rpx;
}

.custom-amount .label {
  font-size: 26rpx;
  color: #666;
  margin-bottom: 16rpx;
  display: block;
}

.input-wrap {
  display: flex;
  align-items: center;
  padding: 20rpx 24rpx;
  background-color: #f5f6f7;
  border-radius: 12rpx;
}

.input-prefix {
  font-size: 32rpx;
  color: #333;
  margin-right: 8rpx;
}

.amount-input {
  flex: 1;
  font-size: 32rpx;
  color: #333;
}

.withdraw-info {
  display: flex;
  justify-content: space-between;
  padding: 20rpx 24rpx;
  background-color: #f0fdf4;
  border-radius: 12rpx;
  margin-bottom: 30rpx;
}

.info-label {
  font-size: 26rpx;
  color: #34d399;
}

.info-value {
  font-size: 28rpx;
  font-weight: 600;
  color: #10b981;
}

.withdraw-fee {
  display: flex;
  justify-content: space-between;
  padding: 16rpx 0;
  border-top: 1rpx dashed #eee;
}

.fee-label {
  font-size: 26rpx;
  color: #999;
}

.fee-value {
  font-size: 26rpx;
  color: #999;
}

.modal-footer {
  .confirm-btn {
    width: 100%;
    padding: 24rpx;
    background-color: #2563eb;
    color: #fff;
    font-size: 32rpx;
    font-weight: 500;
    border-radius: 16rpx;
    text-align: center;
  }

  .confirm-btn.disabled {
    background-color: #ccc;
  }
}
</style>