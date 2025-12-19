<template>
  <div class="home-container">
    <FluidBackground />
    
    <!-- Role Switcher (Webpage Top Right) -->
    <div class="role-switcher">
      <el-radio-group v-model="loginForm.role" size="small" class="glass-radio-small">
        <el-radio-button label="student">学生</el-radio-button>
        <el-radio-button label="admin">管理员</el-radio-button>
      </el-radio-group>
    </div>

    <div class="content-wrapper">
      <div class="login-card">
        <!-- Decorative liquid elements -->
        <div class="liquid-shape shape-1"></div>
        <div class="liquid-shape shape-2"></div>
        
        <div class="card-content split-layout">
          <!-- Left Side: Logo & System Name -->
          <div class="left-panel">
            <div class="logo-section">
              <div class="logo-ring">
                <div class="logo">
                  <el-icon size="50" color="#fff"><Monitor /></el-icon>
                </div>
              </div>
              <h1 class="title">实验室<br>设备管理</h1>
              <p class="subtitle">智能 · 高效 · 便捷</p>
            </div>
          </div>

          <!-- Right Side: Login Form -->
          <div class="right-panel">
            <h2 class="login-title">欢迎登录</h2>
            <el-form :model="loginForm" class="login-form">
              <el-form-item>
                <el-input
                  v-model="loginForm.name"
                  placeholder="请输入您的姓名"
                  size="large"
                  prefix-icon="User"
                  class="glass-input"
                />
              </el-form-item>

              <el-form-item>
                <el-input
                  v-model="loginForm.password"
                  type="password"
                  placeholder="请输入密码（任意非空）"
                  size="large"
                  prefix-icon="Lock"
                  show-password
                  class="glass-input"
                />
              </el-form-item>
              
              <el-form-item>
                <el-button
                  type="primary"
                  size="large"
                  class="login-btn glass-button"
                  @click="handleLogin"
                  :loading="loading"
                >
                  <span>进入系统</span>
                  <el-icon class="el-icon--right"><ArrowRight /></el-icon>
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import FluidBackground from '@/components/FluidBackground.vue'
import { Monitor, User, ArrowRight, Lock } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()

const loginForm = ref({
  name: '',
  password: '',
  role: 'student' as 'student' | 'admin'
})

const loading = ref(false)

const handleLogin = () => {
  if (!loginForm.value.name.trim()) {
    ElMessage.warning('请输入姓名')
    return
  }
  
  if (!loginForm.value.password.trim()) {
    ElMessage.warning('请输入密码')
    return
  }
  
  loading.value = true
  
  // 模拟登录延迟
  setTimeout(() => {
    userStore.login(loginForm.value.name, loginForm.value.role)
    ElMessage.success('登录成功！')
    
    // 根据角色跳转
    if (loginForm.value.role === 'admin') {
      router.push('/admin/devices')
    } else {
      router.push('/devices')
    }
    
    loading.value = false
  }, 800)
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.content-wrapper {
  position: relative;
  z-index: 10;
  padding: 20px;
  perspective: 1000px;
}

.login-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 40px;
  width: 100%;
  max-width: 800px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
  position: relative;
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  animation: cardFloat 6s ease-in-out infinite;
}

.role-switcher {
  position: fixed;
  top: 30px;
  right: 40px;
  z-index: 100;
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.split-layout {
  display: flex;
  align-items: center;
  gap: 40px;
}

.left-panel {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  border-right: 1px solid rgba(255, 255, 255, 0.2);
  padding-right: 40px;
}

.right-panel {
  flex: 1;
  padding-left: 10px;
}

.login-title {
  color: #fff;
  margin-bottom: 25px;
  font-size: 22px;
  font-weight: 500;
  letter-spacing: 1px;
}

.glass-radio-small {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 20px;
  padding: 2px;
}

:deep(.glass-radio-small .el-radio-button__inner) {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  border-radius: 18px;
  padding: 5px 15px;
  font-size: 12px;
  box-shadow: none !important;
}

:deep(.glass-radio-small .el-radio-button__original-radio:checked + .el-radio-button__inner) {
  background: rgba(255, 255, 255, 0.3);
  color: #fff;
}

.login-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

/* Liquid Shapes */
.liquid-shape {
  position: absolute;
  background: linear-gradient(45deg, rgba(255, 255, 255, 0.4), rgba(255, 255, 255, 0.1));
  border-radius: 50%;
  filter: blur(10px);
  z-index: 0;
}

.shape-1 {
  width: 150px;
  height: 150px;
  top: -50px;
  right: -50px;
  animation: liquidMorph 8s ease-in-out infinite;
}

.shape-2 {
  width: 120px;
  height: 120px;
  bottom: -40px;
  left: -40px;
  background: linear-gradient(45deg, rgba(78, 205, 196, 0.4), rgba(255, 255, 255, 0.1));
  animation: liquidMorph 10s ease-in-out infinite reverse;
}

.card-content {
  position: relative;
  z-index: 1;
}

.logo-section {
  text-align: center;
  margin-bottom: 40px;
}

.logo-ring {
  width: 80px;
  height: 80px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  margin: 0 auto 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  animation: pulse 3s infinite;
}

.title {
  font-size: 28px;
  font-weight: 700;
  color: #fff;
  margin: 0 0 8px 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  letter-spacing: 1px;
}

.subtitle {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  margin: 0;
  font-weight: 300;
  letter-spacing: 2px;
}

/* Form Styles */
.login-form {
  width: 100%;
}

:deep(.glass-input .el-input__wrapper) {
  background: rgba(255, 255, 255, 0.1);
  box-shadow: none;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 8px 15px;
  transition: all 0.3s ease;
}

:deep(.glass-input .el-input__wrapper:hover),
:deep(.glass-input .el-input__wrapper.is-focus) {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
  box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
}

:deep(.glass-input .el-input__inner) {
  color: #fff;
  height: 40px;
  font-size: 16px;
}

:deep(.glass-input .el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.6);
}

:deep(.glass-input .el-icon) {
  color: rgba(255, 255, 255, 0.8);
}

/* Radio Group */
.glass-radio {
  width: 100%;
  display: flex;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 12px;
  padding: 4px;
}

:deep(.glass-radio .el-radio-button) {
  flex: 1;
}

:deep(.glass-radio .el-radio-button__inner) {
  width: 100%;
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  border-radius: 8px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 15px;
  box-shadow: none !important;
  transition: all 0.3s ease;
}

:deep(.glass-radio .el-radio-button__original-radio:checked + .el-radio-button__inner) {
  background: rgba(255, 255, 255, 0.25);
  color: #fff;
  font-weight: 600;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1) !important;
}

/* Button */
.glass-button {
  width: 100%;
  height: 50px;
  border-radius: 12px;
  background: linear-gradient(45deg, #4facfe 0%, #00f2fe 100%);
  border: none;
  font-size: 18px;
  font-weight: 600;
  letter-spacing: 1px;
  margin-top: 10px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.glass-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(79, 172, 254, 0.4);
}

.glass-button:active {
  transform: translateY(0);
}

.glass-button::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  transition: 0.5s;
}

.glass-button:hover::after {
  left: 100%;
}

/* Animations */
@keyframes cardFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

@keyframes liquidMorph {
  0% { border-radius: 60% 40% 30% 70%/60% 30% 70% 40%; }
  50% { border-radius: 30% 60% 70% 40%/50% 60% 30% 60%; }
  100% { border-radius: 60% 40% 30% 70%/60% 30% 70% 40%; }
}

@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.4); }
  70% { box-shadow: 0 0 0 10px rgba(255, 255, 255, 0); }
  100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0); }
}

@media (max-width: 768px) {
  .login-card {
    padding: 30px 20px;
    margin: 20px;
    max-width: 420px;
  }
  
  .split-layout {
    flex-direction: column;
    gap: 20px;
  }

  .left-panel {
    border-right: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    padding-right: 0;
    padding-bottom: 20px;
    width: 100%;
  }

  .right-panel {
    padding-left: 0;
    width: 100%;
  }
  
  .title {
    font-size: 24px;
  }
  
  .role-switcher {
    top: 15px;
    right: 15px;
  }
}
</style>