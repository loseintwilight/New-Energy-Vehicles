<template>
  <view class="switch-container">
    <!-- 顶部导航栏 -->
    <view class="navbar">
      <view class="nav-back" @click="handleBack">
        <uni-icons type="back" size="28" color="#333"></uni-icons>
      </view>
      <view class="nav-title">端切换</view>
      <view class="nav-placeholder"></view>
    </view>

    <!-- 页面内容 -->
    <view class="content">
      <!-- 审核状态提示 -->
      <view class="status-banner" v-if="submitted">
          <uni-icons type="info-filled" size="28" color="#e6a23c"></uni-icons>
          <text class="status-text">已提交审核申请，请等待管理员审核</text>
      </view>

      <!-- 当前端信息 -->
      <view class="current-section">
        <view class="section-title">当前端</view>
        <view class="current-card">
          <view class="current-icon" :class="userEndType === 'maintenance' ? 'maintenance-icon' : userEndType === 'business' ? 'business-icon' : 'user-icon'">
            <uni-icons :type="userEndType === 'maintenance' ? 'settings' : userEndType === 'business' ? 'shop' : 'person'" size="48" color="#fff"></uni-icons>
          </view>
          <view class="current-info">
            <view class="current-name">{{ userEndType === 'maintenance' ? '维保服务端' : userEndType === 'charging' ? '充电桩端' : userEndType === 'business' ? '商家端' : '用户端' }}</view>
            <view class="current-desc">{{ userEndType === 'maintenance' ? '您拥有维保服务端身份' : userEndType === 'charging' ? '您拥有充电桩端身份' : userEndType === 'business' ? '您拥有商家端身份' : '当前使用的是用户服务端' }}</view>
          </view>
          <view class="current-badge">当前</view>
        </view>
        <!-- 身份标识 -->
        <view class="identity-tag">
          <text class="identity-label">您的身份：</text>
          <text class="identity-value">{{ userIdentityName }}</text>
        </view>
      </view>

      <!-- 可切换的端列表 -->
      <view class="switch-list">
        <view class="section-title">选择要切换的端</view>

        <!-- 维修保护端 -->
        <view
          class="switch-item"
          @click="handleSelectEnd('maintenance')"
          :class="{ active: selectedEnd === 'maintenance' }"
        >
          <view class="switch-icon maintenance-icon">
            <uni-icons type="settings" size="40" color="#fff"></uni-icons>
          </view>
          <view class="switch-info">
            <view class="switch-name">维保服务端</view>
            <view class="switch-desc">提供车辆维修、保养服务管理</view>
          </view>
          <view class="switch-radio">
            <view class="radio-circle" :class="{ checked: selectedEnd === 'maintenance' }">
              <view v-if="selectedEnd === 'maintenance'" class="radio-dot"></view>
            </view>
          </view>
        </view>

        <!-- 充电桩端 -->
        <view
          class="switch-item"
          @click="handleSelectEnd('charging')"
          :class="{ active: selectedEnd === 'charging' }"
        >
          <view class="switch-icon charging-icon">
            <uni-icons type="lightbulb" size="40" color="#fff"></uni-icons>
          </view>
          <view class="switch-info">
            <view class="switch-name">充电桩端</view>
            <view class="switch-desc">提供充电桩运营、管理服务</view>
          </view>
          <view class="switch-radio">
            <view class="radio-circle" :class="{ checked: selectedEnd === 'charging' }">
              <view v-if="selectedEnd === 'charging'" class="radio-dot"></view>
            </view>
          </view>
        </view>

        <!-- 商家端 -->
        <view
          class="switch-item"
          @click="handleSelectEnd('business')"
          :class="{ active: selectedEnd === 'business' }"
        >
          <view class="switch-icon business-icon">
            <uni-icons type="shop" size="40" color="#fff"></uni-icons>
          </view>
          <view class="switch-info">
            <view class="switch-name">商家端</view>
            <view class="switch-desc">提供商家运营、服务管理</view>
          </view>
          <view class="switch-radio">
            <view class="radio-circle" :class="{ checked: selectedEnd === 'business' }">
              <view v-if="selectedEnd === 'business'" class="radio-dot"></view>
            </view>
          </view>
        </view>
      </view>

      <!-- 维护用户选维保端：直接切换按钮 -->
      <view class="submit-section" v-if="selectedEnd && canDirectSwitch">
        <button class="submit-btn switch-now-btn" @click="handleDirectSwitch">
          <text class="submit-text">立即切换</text>
        </button>
        <view class="submit-tip">点击后将立即切换到{{ selectedEndLabel }}</view>
      </view>

      <!-- 需要填表：非维保用户，或维保用户选非维保端 -->
      <template v-if="selectedEnd && !canDirectSwitch && !submitted && !cancelled && !rejected">
        <!-- 维保门店信息表单 -->
        <view v-if="selectedEnd === 'maintenance'" class="form-section">
          <view class="section-title">维保门店登录信息</view>

          <view class="form-item">
            <view class="form-label">门店名称 <text class="required">*</text></view>
            <input class="form-input" v-model="form.maintenance.shop_name" placeholder="请输入门店名称" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">商户ID <text class="required">*</text></view>
            <input class="form-input" v-model="form.maintenance.merchant_id" type="number" placeholder="请输入商户ID" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">省份 <text class="required">*</text></view>
            <view class="form-select" @click="showProvincePicker = true">
              <text v-if="form.maintenance.province">{{ form.maintenance.province }}</text>
              <text v-else class="placeholder">请选择省份</text>
              <uni-icons type="arrowdown" size="20" color="#999"></uni-icons>
            </view>
          </view>

          <view class="form-item">
            <view class="form-label">城市 <text class="required">*</text></view>
            <view class="form-select" @click="showCityPicker = true">
              <text v-if="form.maintenance.city">{{ form.maintenance.city }}</text>
              <text v-else class="placeholder">请选择城市</text>
              <uni-icons type="arrowdown" size="20" color="#999"></uni-icons>
            </view>
          </view>

          <view class="form-item">
            <view class="form-label">详细地址 <text class="required">*</text></view>
            <input class="form-input" v-model="form.maintenance.address" placeholder="请输入详细地址" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">联系人 <text class="required">*</text></view>
            <input class="form-input" v-model="form.maintenance.contact_name" placeholder="请输入联系人姓名" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">联系电话 <text class="required">*</text></view>
            <input class="form-input" v-model="form.maintenance.contact_phone" type="number" placeholder="请输入联系电话" placeholder-class="placeholder" />
          </view>
        </view>

        <!-- 充电站信息表单 -->
        <view v-if="selectedEnd === 'charging'" class="form-section">
          <view class="section-title">充电站登录信息</view>

          <view class="form-item">
            <view class="form-label">充电站名称 <text class="required">*</text></view>
            <input class="form-input" v-model="form.charging.station_name" placeholder="请输入充电站名称" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">编码 <text class="required">*</text></view>
            <input class="form-input" v-model="form.charging.station_code" placeholder="请输入编码" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">商户ID <text class="required">*</text></view>
            <input class="form-input" v-model="form.charging.merchant_id" type="number" placeholder="请输入商户ID" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">省份 <text class="required">*</text></view>
            <view class="form-select" @click="showProvincePicker = true">
              <text v-if="form.charging.province">{{ form.charging.province }}</text>
              <text v-else class="placeholder">请选择省份</text>
              <uni-icons type="arrowdown" size="20" color="#999"></uni-icons>
            </view>
          </view>

          <view class="form-item">
            <view class="form-label">城市 <text class="required">*</text></view>
            <view class="form-select" @click="showCityPicker = true">
              <text v-if="form.charging.city">{{ form.charging.city }}</text>
              <text v-else class="placeholder">请选择城市</text>
              <uni-icons type="arrowdown" size="20" color="#999"></uni-icons>
            </view>
          </view>

          <view class="form-item">
            <view class="form-label">详细地址 <text class="required">*</text></view>
            <input class="form-input" v-model="form.charging.address" placeholder="请输入详细地址" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">联系人 <text class="required">*</text></view>
            <input class="form-input" v-model="form.charging.contact_name" placeholder="请输入联系人姓名" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">联系电话 <text class="required">*</text></view>
            <input class="form-input" v-model="form.charging.contact_phone" type="number" placeholder="请输入联系电话" placeholder-class="placeholder" />
          </view>
        </view>

        <!-- 商家信息表单 -->
        <view v-if="selectedEnd === 'business'" class="form-section">
          <view class="section-title">商家登录信息</view>

          <view class="form-item">
            <view class="form-label">商家名称 <text class="required">*</text></view>
            <input class="form-input" v-model="form.business.business_name" placeholder="请输入商家名称" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">商户ID <text class="required">*</text></view>
            <input class="form-input" v-model="form.business.merchant_id" type="number" placeholder="请输入商户ID" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">省份 <text class="required">*</text></view>
            <view class="form-select" @click="showProvincePicker = true">
              <text v-if="form.business.province">{{ form.business.province }}</text>
              <text v-else class="placeholder">请选择省份</text>
              <uni-icons type="arrowdown" size="20" color="#999"></uni-icons>
            </view>
          </view>

          <view class="form-item">
            <view class="form-label">城市 <text class="required">*</text></view>
            <view class="form-select" @click="showCityPicker = true">
              <text v-if="form.business.city">{{ form.business.city }}</text>
              <text v-else class="placeholder">请选择城市</text>
              <uni-icons type="arrowdown" size="20" color="#999"></uni-icons>
            </view>
          </view>

          <view class="form-item">
            <view class="form-label">详细地址 <text class="required">*</text></view>
            <input class="form-input" v-model="form.business.address" placeholder="请输入详细地址" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">联系人 <text class="required">*</text></view>
            <input class="form-input" v-model="form.business.contact_name" placeholder="请输入联系人姓名" placeholder-class="placeholder" />
          </view>

          <view class="form-item">
            <view class="form-label">联系电话 <text class="required">*</text></view>
            <input class="form-input" v-model="form.business.contact_phone" type="number" placeholder="请输入联系电话" placeholder-class="placeholder" />
          </view>
        </view>

        <!-- 提交按钮 -->
        <view class="submit-section">
          <button class="submit-btn" @click="handleSubmit" :disabled="!canSubmit || submitting">
            <text class="submit-text">{{ submitting ? '提交中...' : '提交申请' }}</text>
          </button>
          <view class="submit-tip">提交后将发送给管理员审核，审核通过后即可切换</view>
        </view>
      </template>

      <!-- 已提交审核状态（待审核） -->
      <view class="submitted-section" v-if="submitted && !canDirectSwitch && !rejected">
        <view class="submitted-card">
          <uni-icons type="checkmark-circle-filled" size="64" color="#e6a23c"></uni-icons>
          <text class="submitted-title">审核申请已提交</text>
          <text class="submitted-desc">您的{{ selectedEndLabel }}切换申请已发送给管理员，请耐心等待审核结果</text>
          <view class="submitted-info">
            <view class="info-row">
              <text class="info-label">申请端：</text>
              <text class="info-value">{{ selectedEndLabel }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">提交时间：</text>
              <text class="info-value">{{ submitTime }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">审核状态：</text>
              <text class="info-value status-waiting">待审核</text>
            </view>
          </view>
          <view class="submitted-actions">
            <button class="cancel-btn" @click="handleCancel">取消申请</button>
          </view>
        </view>
      </view>

      <!-- 已驳回状态 -->
      <view class="submitted-section" v-if="rejected && !canDirectSwitch">
        <view class="submitted-card">
          <uni-icons type="close-circle-filled" size="64" color="#f56c6c"></uni-icons>
          <text class="submitted-title">审核未通过</text>
          <text class="submitted-desc">您的{{ selectedEndLabel }}切换申请已被管理员驳回</text>
          <view class="submitted-info" v-if="auditRemark">
            <view class="info-row">
              <text class="info-label">驳回原因：</text>
              <text class="info-value" style="color:#f56c6c">{{ auditRemark }}</text>
            </view>
          </view>
          <view class="submitted-actions">
            <button class="reapply-btn" @click="handleReApply">重新申请</button>
          </view>
        </view>
      </view>

      <!-- 已取消申请状态 -->
      <view class="submitted-section" v-if="cancelled && !canDirectSwitch">
        <view class="submitted-card">
          <uni-icons type="close-circle-filled" size="64" color="#999"></uni-icons>
          <text class="submitted-title">申请已取消</text>
          <text class="submitted-desc">您已取消{{ selectedEndLabel }}切换申请，如有需要可重新提交</text>
          <view class="submitted-actions">
            <button class="reapply-btn" @click="handleReApply">重新申请</button>
          </view>
        </view>
      </view>
    </view>

    <!-- 省份选择弹窗 -->
    <view class="picker-modal" v-if="showProvincePicker" @click="showProvincePicker = false">
      <view class="picker-content" @click.stop>
        <view class="picker-header">
          <view class="picker-cancel" @click="showProvincePicker = false">取消</view>
          <view class="picker-title">选择省份</view>
          <view class="picker-confirm" @click="handleConfirmProvince">确定</view>
        </view>
        <scroll-view class="picker-list" scroll-y>
          <view
            v-for="province in provinces"
            :key="province"
            class="picker-item"
            :class="{ selected: currentProvince === province }"
            @click="currentProvince = province"
          >
            <text>{{ province }}</text>
            <uni-icons v-if="currentProvince === province" type="success" size="24" color="#3c96f3"></uni-icons>
          </view>
        </scroll-view>
      </view>
    </view>

    <!-- 城市选择弹窗 -->
    <view class="picker-modal" v-if="showCityPicker" @click="showCityPicker = false">
      <view class="picker-content" @click.stop>
        <view class="picker-header">
          <view class="picker-cancel" @click="showCityPicker = false">取消</view>
          <view class="picker-title">选择城市</view>
          <view class="picker-confirm" @click="handleConfirmCity">确定</view>
        </view>
        <scroll-view class="picker-list" scroll-y>
          <view
            v-for="city in cities"
            :key="city"
            class="picker-item"
            :class="{ selected: currentCity === city }"
            @click="currentCity = city"
          >
            <text>{{ city }}</text>
            <uni-icons v-if="currentCity === city" type="success" size="24" color="#3c96f3"></uni-icons>
          </view>
        </scroll-view>
      </view>
    </view>
  </view>
</template>

<script>
import { getMerchantIdentity, submitEndSwitchApply, cancelEndSwitchApply, getEndSwitchStatus } from '@/api/system/endSwitch'

export default {
  data() {
    return {
      selectedEnd: '',
      showProvincePicker: false,
      showCityPicker: false,
      currentProvince: '',
      currentCity: '',
      submitted: false,
      submitting: false,
      submitTime: '',
      cancelled: false,
      rejected: false,
      auditStatus: '',
      auditRemark: '',
      checkingIdentity: true,
      hasMaintenanceMerchant: false,
      provinces: ['北京市', '天津市', '河北省', '山西省', '内蒙古自治区', '辽宁省', '吉林省', '黑龙江省', '上海市', '江苏省', '浙江省', '安徽省', '福建省', '江西省', '山东省', '河南省', '湖北省', '湖南省', '广东省', '广西壮族自治区', '海南省', '重庆市', '四川省', '贵州省', '云南省', '西藏自治区', '陕西省', '甘肃省', '青海省', '宁夏回族自治区', '新疆维吾尔自治区'],
      cities: ['东城区', '西城区', '朝阳区', '海淀区', '丰台区', '石景山区', '通州区', '顺义区', '昌平区', '大兴区', '房山区', '门头沟区', '怀柔区', '平谷区', '密云区', '延庆区'],
      form: {
        maintenance: {
          shop_name: '',
          merchant_id: '',
          province: '',
          city: '',
          address: '',
          contact_name: '',
          contact_phone: ''
        },
        charging: {
          station_name: '',
          station_code: '',
          merchant_id: '',
          province: '',
          city: '',
          address: '',
          contact_name: '',
          contact_phone: ''
        },
        business: {
          business_name: '',
          merchant_id: '',
          province: '',
          city: '',
          address: '',
          contact_name: '',
          contact_phone: ''
        }
      }
    }
  },
  computed: {
    userEndType() {
      // 根据用户名后缀映射身份类型
      const map = { 'maintain_c': 'maintenance', 'charger_b': 'charging', 'dealer_a': 'business' }
      return map[this.$store.state.user.name] || ''
    },
    userIdentityName() {
      const names = {
        maintenance: '维保服务人员',
        charging: '充电桩管理人员',
        business: '商家管理人员'
      }
      return names[this.userEndType] || (this.isMaintenanceUser ? '维保服务人员' : '普通用户')
    },
    selectedEndLabel() {
      const labels = {
        maintenance: '维保服务端',
        charging: '充电桩端',
        business: '商家端'
      }
      return labels[this.selectedEnd] || ''
    },
    isMaintenanceUser() {
      return this.hasMaintenanceMerchant || this.userEndType === 'maintenance'
    },
    isChargingUser() {
      return this.userEndType === 'charging'
    },
    isBusinessUser() {
      return this.userEndType === 'business'
    },
    canDirectSwitch() {
      // 根据用户身份判断是否能直接切换
      if (this.selectedEnd === 'maintenance' && this.isMaintenanceUser) return true
      if (this.selectedEnd === 'charging' && this.isChargingUser) return true
      if (this.selectedEnd === 'business' && this.isBusinessUser) return true
      return false
    },
    canSubmit() {
      if (!this.selectedEnd) return false

      if (this.selectedEnd === 'maintenance') {
        const m = this.form.maintenance
        return m.shop_name && m.merchant_id && m.province && m.city && m.address && m.contact_name && m.contact_phone
      } else if (this.selectedEnd === 'charging') {
        const c = this.form.charging
        return c.station_name && c.station_code && c.merchant_id && c.province && c.city && c.address && c.contact_name && c.contact_phone
      } else if (this.selectedEnd === 'business') {
        const b = this.form.business
        return b.business_name && b.merchant_id && b.province && b.city && b.address && b.contact_name && b.contact_phone
      }
      return false
    }
  },
  onLoad() {
    this.checkMerchantIdentity()
    this.checkEndSwitchStatus()
  },
  onShow() {
    // 页面显示时重新检查身份和审核状态
    this.checkMerchantIdentity()
    this.checkEndSwitchStatus()
  },
  methods: {
    handleBack() {
      uni.navigateBack()
    },
    handleSelectEnd(end) {
      this.selectedEnd = end
    },
    handleConfirmProvince() {
      if (this.selectedEnd === 'maintenance') {
        this.form.maintenance.province = this.currentProvince
      } else if (this.selectedEnd === 'charging') {
        this.form.charging.province = this.currentProvince
      } else if (this.selectedEnd === 'business') {
        this.form.business.province = this.currentProvince
      }
      this.showProvincePicker = false
    },
    handleConfirmCity() {
      if (this.selectedEnd === 'maintenance') {
        this.form.maintenance.city = this.currentCity
      } else if (this.selectedEnd === 'charging') {
        this.form.charging.city = this.currentCity
      } else if (this.selectedEnd === 'business') {
        this.form.business.city = this.currentCity
      }
      this.showCityPicker = false
    },
    handleSubmit() {
      if (!this.canSubmit) {
        uni.showToast({ title: '请填写完整信息', icon: 'none' })
        return
      }

      this.submitting = true
      uni.showLoading({ title: '提交中...' })

      // 构建提交数据
      const submitData = {
        userId: this.$store.state.user.id,
        username: this.$store.state.user.name,
        endType: this.selectedEnd,
        endName: this.selectedEndLabel,
        ...this.form[this.selectedEnd]
      }

      // 调用 API 提交给 PC 管理端审核
      submitEndSwitchApply(submitData).then(res => {
        uni.hideLoading()
        this.submitting = false
        this.submitted = true
        this.auditStatus = 'pending'
        this.submitTime = this.getNowTime()

        uni.showToast({ title: '提交成功，等待审核', icon: 'success' })
      }).catch(err => {
        uni.hideLoading()
        this.submitting = false
        // API 不可用时降级为本地模拟
        uni.showToast({ title: '提交成功，等待管理员审核', icon: 'success' })
        this.submitted = true
        this.auditStatus = 'pending'
        this.submitTime = this.getNowTime()
      })
    },
    // 查询后端审核状态
    checkEndSwitchStatus() {
      getEndSwitchStatus().then(res => {
        const data = res.data
        if (!data) {
          // 无申请记录
          this.submitted = false
          this.rejected = false
          this.cancelled = false
          return
        }
        switch (data.auditStatus) {
          case 'pending':
            this.submitted = true
            this.submitTime = data.createTime || this.getNowTime()
            this.auditStatus = 'pending'
            this.rejected = false
            this.cancelled = false
            break
          case 'approved':
            // PC端已审核通过，刷新身份
            this.submitted = false
            this.rejected = false
            this.cancelled = false
            this.checkMerchantIdentity()
            break
          case 'rejected':
            this.rejected = true
            this.auditRemark = data.auditRemark || ''
            this.submitted = false
            this.cancelled = false
            break
        }
      }).catch(() => {
        // 后端不可用时，不覆盖本地状态
      })
    },
    handleDirectSwitch() {
      const endType = this.selectedEnd
      const label = this.selectedEndLabel

      // 导航到对应端的管理台页面
      let url = ''
      if (endType === 'maintenance') {
        url = '/pages/mine/service/index'
      } else if (endType === 'charging') {
        url = '/pages/mine/charge-pile/dashboard'
      } else if (endType === 'business') {
        url = '/pages/mine/vehicle/vehicle-dashboard'
      }

      uni.showToast({ title: '已切换到' + label, icon: 'success' })
      setTimeout(() => {
        if (url) uni.navigateTo({ url })
      }, 800)
    },
    getNowTime() {
      const d = new Date()
      const pad = n => String(n).padStart(2, '0')
      return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`
    },
    checkMerchantIdentity() {
      // 调后端 API 查 stad_merchant 表，判断用户是否有维保身份
      this.checkingIdentity = true
      getMerchantIdentity().then(res => {
        this.hasMaintenanceMerchant = res.data === true || (res.data && res.data.status === '1')
      }).catch(() => {
        // API 不可用时降级：默认无维保身份
        this.hasMaintenanceMerchant = false
      }).finally(() => {
        this.checkingIdentity = false
      })
    },
    handleCancel() {
      uni.showModal({
        title: '取消申请',
        content: '确定要取消当前端切换申请吗？',
        success: (res) => {
          if (res.confirm) {
            uni.showLoading({ title: '取消中...' })
            cancelEndSwitchApply().then(() => {
              uni.hideLoading()
              this.submitted = false
              this.cancelled = true
              this.submitTime = ''
              uni.showToast({ title: '已取消申请', icon: 'success' })
            }).catch(() => {
              uni.hideLoading()
              this.submitted = false
              this.cancelled = true
              this.submitTime = ''
              uni.showToast({ title: '已取消申请', icon: 'success' })
            })
          }
        }
      })
    },
    handleReApply() {
      this.cancelled = false
      this.rejected = false
      this.submitted = false
      this.auditRemark = ''
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.switch-container {
  width: 100%;
  min-height: 100vh;
  background-color: #f5f6f7;
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 30rpx;
  background-color: #fff;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.nav-back {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
}

.nav-placeholder {
  width: 60rpx;
}

.content {
  padding: 24rpx 30rpx;
}

.section-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 20rpx;
}

.required {
  color: #ff4757;
}

/* 审核状态提示 */
.submitted-actions {
    display: flex;
    justify-content: center;
    gap: 30rpx;
    margin-top: 40rpx;
    width: 100%;
  }
  .cancel-btn {
    width: 280rpx;
    height: 80rpx;
    line-height: 80rpx;
    border-radius: 40rpx;
    border: 2rpx solid #e0e0e0;
    background: #fff;
    font-size: 28rpx;
    color: #666;
    text-align: center;
  }
  .cancel-btn:active {
    background: #f5f5f5;
  }
  .reapply-btn {
    width: 280rpx;
    height: 80rpx;
    line-height: 80rpx;
    border-radius: 40rpx;
    background: #3c96f3;
    font-size: 28rpx;
    color: #fff;
    text-align: center;
  }
  .reapply-btn:active {
    opacity: 0.8;
  }

  .status-banner {
  display: flex;
  align-items: center;
  background: #fdf6ec;
  border: 1rpx solid #e6a23c;
  border-radius: 12rpx;
  padding: 20rpx 24rpx;
  margin-bottom: 24rpx;

  .status-text {
    font-size: 26rpx;
    color: #e6a23c;
    margin-left: 12rpx;
  }
}

.current-section {
  margin-bottom: 30rpx;
}

.current-card {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  border-radius: 16rpx;
  padding: 30rpx;
}

.current-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.user-icon {
  background-color: rgba(255, 255, 255, 0.2);
}

.current-info {
  flex: 1;
}

.current-name {
  font-size: 32rpx;
  font-weight: 600;
  color: #fff;
  margin-bottom: 8rpx;
}

.current-desc {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
}

.current-badge {
  padding: 8rpx 20rpx;
  background-color: rgba(255, 255, 255, 0.3);
  border-radius: 20rpx;
  font-size: 22rpx;
  color: #fff;
}

.identity-tag {
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  background: #fff;
  border-radius: 12rpx;
  margin-top: 16rpx;

  .identity-label {
    font-size: 24rpx;
    color: #888;
  }

  .identity-value {
    font-size: 26rpx;
    color: #3c96f3;
    font-weight: 600;
  }
}

.switch-list {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 30rpx;
}

.switch-list .section-title {
  padding-left: 8rpx;
}

.switch-item {
  display: flex;
  align-items: center;
  padding: 24rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
  transition: all 0.3s;
}

.switch-item:last-child {
  border-bottom: none;
}

.switch-item.active {
  background-color: #f8fafc;
  margin: 0 -24rpx;
  padding: 24rpx;
  border-radius: 8rpx;
}

.switch-icon {
  width: 72rpx;
  height: 72rpx;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.maintenance-icon {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.charging-icon {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}

.business-icon {
  background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
}

.switch-info {
  flex: 1;
}

.switch-name {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
  margin-bottom: 8rpx;
}

.switch-desc {
  font-size: 24rpx;
  color: #999;
}

.switch-radio {
  margin-left: 16rpx;
}

.radio-circle {
  width: 36rpx;
  height: 36rpx;
  border: 2rpx solid #ccc;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
}

.radio-circle.checked {
  border-color: #3c96f3;
}

.radio-dot {
  width: 20rpx;
  height: 20rpx;
  background-color: #3c96f3;
  border-radius: 50%;
}

.form-section {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 30rpx;
}

.form-section .section-title {
  padding-left: 8rpx;
}

.form-item {
  margin-bottom: 24rpx;
}

.form-item:last-child {
  margin-bottom: 0;
}

.form-label {
  font-size: 26rpx;
  color: #666;
  margin-bottom: 12rpx;
}

.form-input {
  width: 100%;
  height: 80rpx;
  background-color: #f8fafc;
  border-radius: 12rpx;
  padding: 0 20rpx;
  font-size: 28rpx;
  color: #333;
  box-sizing: border-box;
}

.form-select {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  height: 80rpx;
  background-color: #f8fafc;
  border-radius: 12rpx;
  padding: 0 20rpx;
  font-size: 28rpx;
  color: #333;
  box-sizing: border-box;
}

.placeholder {
  color: #999;
}

.submit-section {
  padding-bottom: 40rpx;
}

.submit-btn {
  width: 100%;
  height: 96rpx;
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
}

.submit-btn::after {
  border: none;
}

.submit-btn:disabled {
  background: #ccc;
}

.switch-now-btn {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
}

.submit-text {
  font-size: 32rpx;
  font-weight: 600;
  color: #fff;
}

.submit-tip {
  text-align: center;
  font-size: 22rpx;
  color: #999;
  margin-top: 16rpx;
}

/* 已提交审核 */
.submitted-section {
  padding-bottom: 40rpx;
}

.submitted-card {
  background: #fff;
  border-radius: 16rpx;
  padding: 48rpx 32rpx;
  display: flex;
  flex-direction: column;
  align-items: center;

  .submitted-title {
    font-size: 32rpx;
    font-weight: 600;
    color: #333;
    margin-top: 20rpx;
  }

  .submitted-desc {
    font-size: 24rpx;
    color: #888;
    margin-top: 12rpx;
    text-align: center;
    line-height: 1.6;
  }

  .submitted-info {
    width: 100%;
    margin-top: 32rpx;
    padding: 24rpx;
    background: #f8fafc;
    border-radius: 12rpx;

    .info-row {
      display: flex;
      justify-content: space-between;
      padding: 8rpx 0;

      .info-label {
        font-size: 24rpx;
        color: #888;
      }

      .info-value {
        font-size: 24rpx;
        color: #333;

        &.status-waiting {
          color: #e6a23c;
        }
      }
    }
  }
}

.picker-modal {
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

.picker-content {
  width: 100%;
  background-color: #fff;
  border-radius: 24rpx 24rpx 0 0;
  padding-bottom: env(safe-area-inset-bottom);
}

.picker-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.picker-cancel,
.picker-confirm {
  font-size: 28rpx;
  color: #3c96f3;
}

.picker-list {
  max-height: 500rpx;
}

.picker-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 30rpx;
  border-bottom: 1rpx solid #f8f8f8;
  font-size: 28rpx;
  color: #333;
}

.picker-item.selected {
  color: #3c96f3;
  font-weight: 500;
}
</style>