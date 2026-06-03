<template>
  <view class="page-container">
    <view class="wallet-header">
      <view class="balance-card">
        <text class="balance-label">账户余额（元）</text>
        <view class="balance-row">
          <text class="balance-value">{{ balance }}</text>
          <view class="balance-actions">
            <view class="bal-action" @click="handleRecharge">充值</view>
            <view class="bal-action withdraw" @click="handleWithdraw">提现</view>
          </view>
        </view>
      </view>
    </view>

    <view class="section-title">交易记录</view>
    <view class="transaction-list">
      <view v-for="item in transactions" :key="item.id" class="tx-item">
        <view class="tx-icon" :class="item.type === 'income' ? 'tx-income' : 'tx-expense'">
          <uni-icons :type="item.type === 'income' ? 'plus' : 'minus'" size="24" color="#fff"></uni-icons>
        </view>
        <view class="tx-info">
          <text class="tx-title">{{ item.title }}</text>
          <text class="tx-time">{{ item.time }}</text>
        </view>
        <view class="tx-amount" :class="item.type === 'income' ? 'amount-income' : 'amount-expense'">
          {{ item.type === 'income' ? '+' : '-' }}¥{{ item.amount }}
        </view>
      </view>
    </view>

    <view class="empty" v-if="transactions.length === 0">
      <uni-icons type="wallet" size="80" color="#ddd"></uni-icons>
      <text class="empty-text">暂无交易记录</text>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      balance: '50.00',
      transactions: [
        { id: 1, type: 'expense', title: '常规保养服务', time: '2026-06-02 10:30', amount: '299.00' },
        { id: 2, type: 'expense', title: '电池检测 + 空调清洗', time: '2026-06-01 14:20', amount: '367.00' },
        { id: 3, type: 'income', title: '账户充值', time: '2026-05-30 09:15', amount: '500.00' },
        { id: 4, type: 'expense', title: '轮胎更换', time: '2026-05-28 09:15', amount: '2320.00' },
        { id: 5, type: 'income', title: '退款-美容装饰', time: '2026-05-19 15:00', amount: '128.00' },
        { id: 6, type: 'expense', title: '钣金喷漆', time: '2026-05-20 16:00', amount: '350.00' },
        { id: 7, type: 'income', title: '账户充值', time: '2026-05-15 11:00', amount: '2000.00' }
      ]
    }
  },
  methods: {
    handleRecharge() {
      uni.showModal({
        title: '充值',
        content: '请输入充值金额',
        editable: true,
        success: (res) => {
          if (res.confirm && res.content) {
            const amount = parseFloat(res.content)
            if (amount > 0) {
              this.balance = (parseFloat(this.balance) + amount).toFixed(2)
              this.transactions.unshift({
                id: Date.now(),
                type: 'income',
                title: '账户充值',
                time: this.getNow(),
                amount: amount.toFixed(2)
              })
              uni.showToast({ title: '充值成功', icon: 'success' })
            }
          }
        }
      })
    },
    handleWithdraw() {
      uni.showModal({
        title: '提现',
        content: '请输入提现金额（当前余额 ¥' + this.balance + '）',
        editable: true,
        success: (res) => {
          if (res.confirm && res.content) {
            const amount = parseFloat(res.content)
            if (amount > 0 && amount <= parseFloat(this.balance)) {
              this.balance = (parseFloat(this.balance) - amount).toFixed(2)
              this.transactions.unshift({
                id: Date.now(),
                type: 'expense',
                title: '余额提现',
                time: this.getNow(),
                amount: amount.toFixed(2)
              })
              uni.showToast({ title: '提现申请已提交', icon: 'success' })
            } else {
              uni.showToast({ title: '余额不足', icon: 'none' })
            }
          }
        }
      })
    },
    getNow() {
      const d = new Date()
      return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0') + ' ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0')
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.wallet-header {
  padding: 30rpx;
}

.balance-card {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
}

.balance-label {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.8);
}

.balance-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 16rpx;
}

.balance-value {
  font-size: 56rpx;
  font-weight: 700;
  color: #fff;
}

.balance-actions {
  display: flex;
  gap: 16rpx;
}

.bal-action {
  padding: 12rpx 32rpx;
  background-color: rgba(255, 255, 255, 0.25);
  color: #fff;
  font-size: 26rpx;
  border-radius: 30rpx;
}

.bal-action.withdraw {
  background-color: rgba(255, 255, 255, 0.15);
}

.section-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  padding: 0 30rpx 16rpx;
}

.transaction-list {
  padding: 0 30rpx;
}

.tx-item {
  display: flex;
  align-items: center;
  background-color: #fff;
  padding: 24rpx;
  border-radius: 12rpx;
  margin-bottom: 12rpx;
}

.tx-icon {
  width: 60rpx;
  height: 60rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.tx-income {
  background-color: #27ae60;
}

.tx-expense {
  background-color: #ff4757;
}

.tx-info {
  flex: 1;
  margin-left: 20rpx;
}

.tx-title {
  font-size: 28rpx;
  color: #333;
  display: block;
}

.tx-time {
  font-size: 22rpx;
  color: #bbb;
  margin-top: 4rpx;
}

.tx-amount {
  font-size: 30rpx;
  font-weight: 600;
}

.amount-income {
  color: #27ae60;
}

.amount-expense {
  color: #333;
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 120rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
  margin-top: 20rpx;
}
</style>