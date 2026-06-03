<script>
  import config from './config'
  import { getToken } from '@/utils/auth'

  export default {
    onLaunch: function() {
      this.initApp()
    },
    methods: {
      // 初始化应用
      initApp() {
        // 初始化应用配置
        this.initConfig()
        // 检查用户登录状态
        //#ifdef H5
        this.checkLogin()
        //#endif
      },
      initConfig() {
        this.globalData.config = config
        this.globalData.messageCount = 2
        this.globalData.orderStatus = {
          unpaid: 1,
          pending: 1,
          completed: 2,
          cancelled: 1
        }
      },
      checkLogin() {
        if (!getToken()) {
          this.$tab.reLaunch('/pages/login') 
        }
      }
    }
  }
</script>

<style lang="scss">
  @import 'uview-ui/index.scss';
  @import '@/static/scss/index.scss';
</style>
