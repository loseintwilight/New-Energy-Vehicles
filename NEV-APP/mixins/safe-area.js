const systemInfo = uni.getSystemInfoSync()
const pxRatio = 750 / systemInfo.windowWidth

let menuButton = null
try {
  menuButton = uni.getMenuButtonBoundingClientRect ? uni.getMenuButtonBoundingClientRect() : null
} catch (e) {}

export default {
  data() {
    return {
      statusBarHeight: systemInfo.statusBarHeight || 20,
      safeBottom: systemInfo.safeAreaInsets?.bottom || systemInfo.safeArea?.bottom || 0,
      navBarHeight: (systemInfo.statusBarHeight || 20) + 44,
      menuButtonInfo: menuButton || {
        top: systemInfo.statusBarHeight || 20,
        right: systemInfo.windowWidth - 8,
        height: 32,
        width: 87
      }
    }
  },
  computed: {
    capsuleRight() {
      return this.menuButtonInfo.right || (systemInfo.windowWidth - 8)
    },
    capsuleTop() {
      return this.menuButtonInfo.top || (systemInfo.statusBarHeight || 20)
    },
    headerSafePadding() {
      const top = this.menuButtonInfo.top || this.statusBarHeight
      const buttonH = this.menuButtonInfo.height || 32
      return top + buttonH + 8
    }
  },
  methods: {
    rpx2px(rpx) {
      return rpx / pxRatio
    },
    px2rpx(px) {
      return px * pxRatio
    }
  }
}