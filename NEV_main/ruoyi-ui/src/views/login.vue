<template>
  <div class="login">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
      <h3 class="title">新能源汽车全生命周期服务平台</h3>
      <el-form-item prop="username">
        <el-input
          v-model="loginForm.username"
          type="text"
          auto-complete="off"
          placeholder="请输入账号"
        >
          <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input
          v-model="loginForm.password"
          type="password"
          auto-complete="off"
          placeholder="请输入密码"
          @keyup.enter.native="handleLogin"
        >
          <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
        </el-input>
      </el-form-item>
      <el-form-item prop="code" v-if="captchaEnabled" class="code-form-item">
        <el-input
          v-model="loginForm.code"
          auto-complete="off"
          placeholder="验证码"
          class="code-input"
          @keyup.enter.native="handleLogin"
        >
          <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" @click="getCode" class="login-code-img"/>
        </div>
      </el-form-item>
      <el-form-item class="remember-me-item">
        <el-checkbox v-model="loginForm.rememberMe" style="color:#fff;">记住密码</el-checkbox>
      </el-form-item>
      <el-form-item class="login-btn-item">
        <el-button
          :loading="loading"
          size="medium"
          type="primary"
          class="login-btn"
          @click.native.prevent="handleLogin"
        >
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
        <div style="float: right;" v-if="register">
          <router-link class="link-type" :to="'/register'">立即注册</router-link>
        </div>
      </el-form-item>
    </el-form>
    <!--  底部  -->
    <div class="el-login-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'
import defaultSettings from '@/settings'

export default {
  name: "Login",
  data() {
    return {
      title: process.env.VUE_APP_TITLE,
      footerContent: defaultSettings.footerContent,
      codeUrl: "",
      loginForm: {
        username: "admin",
        password: "admin123",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      // 验证码开关
      captchaEnabled: true,
      // 注册开关
      register: false,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCode()
    this.getCookie()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.loginForm.uuid = res.uuid
        }
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 })
            Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
          } else {
            Cookies.remove("username")
            Cookies.remove("password")
            Cookies.remove('rememberMe')
          }
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: this.redirect || "/" }).catch(()=>{})
          }).catch(() => {
            this.loading = false
            if (this.captchaEnabled) {
              this.getCode()
            }
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.login {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url("../assets/images/background1.png");
  background-size: cover;
  position: relative;
}

.login-form {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  max-width: 700px; /* 增加表单最大宽度，确保标题能一行显示 */

  .el-input {
    height: 46px;
    width: 380px;

    input {
      height: 46px;
      background: rgba(255, 255, 255, 0.85) !important;
      border: none !important;
      border-radius: 23px !important;
      color: #333 !important;
      font-size: 14px;
      padding-left: 42px !important;

      &::placeholder {
        color: #999 !important;
      }

      &:focus {
        box-shadow: 0 0 0 2px rgba(80, 200, 220, 0.4) !important;
      }
    }
  }

  .input-icon {
    height: 46px;
    width: 16px;
    margin-left: 8px;
    color: #666;
  }

  .el-form-item {
    margin-bottom: 22px;
    border-bottom: none !important;
    width: 380px;
  }

  .code-form-item {
    display: flex !important; /* 强制使用flex布局 */
    flex-direction: row !important; /* 水平排列 */
    justify-content: space-between !important;
    align-items: center !important;
    width: 380px !important;
    margin-bottom: 22px !important;
  }

  .code-input {
    width: 230px !important;
    margin-bottom: 0 !important; /* 移除输入框底部边距 */
  }

  .remember-me-item {
    width: 380px;
    margin: 0px 0px 25px 0px;
  }

  .login-btn-item {
    width: 380px;
  }
}

.title {
  margin: 0px auto 50px auto;
  text-align: center;
  color: #fff;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
  font-size: 48px; /* 减小字体大小，确保一行显示 */
  font-weight: 600;
  letter-spacing: 4px;
  white-space: nowrap; /* 强制不换行 */
  width: 100%; /* 让标题占满整个表单宽度 */
}

.el-input__inner {
  height: 60px !important;
  line-height: 60px !important;
}

.login-btn {
  width: 380px !important;
  height: 60px !important;
  border-radius: 24px !important;
  border: none !important;
  font-size: 35px !important;
  letter-spacing: 8px !important;
  background: linear-gradient(135deg, #4fd1c5, #38b2ac) !important;
  box-shadow: 0 4px 16px rgba(79, 209, 197, 0.35) !important;
  transition: all 0.3s ease !important;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 24px rgba(79, 209, 197, 0.5) !important;
  }

  &:active {
    transform: translateY(0);
  }
}

.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}

.login-code {
  width: 130px;
  height: 46px;
  display: flex; /* 添加flex布局 */
  align-items: center; /* 垂直居中 */

  img {
    cursor: pointer;
    vertical-align: middle;
    border-radius: 8px;
    width: 100%;
    height: 100%;
  }
}

.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}

.login-code-img {
  height: 46px;
}

::v-deep .el-checkbox__inner {
  background-color: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
}

::v-deep .el-checkbox__label {
  color: rgba(255, 255, 255, 0.9) !important;
}

/* 强制覆盖Element UI的默认样式，确保验证码在同一行 */
::v-deep .code-form-item .el-form-item__content {
  display: flex !important;
  flex-direction: row !important;
  justify-content: space-between !important;
  align-items: center !important;
  width: 100% !important;
  flex-wrap: nowrap !important; /* 禁止换行 */
}
</style>
