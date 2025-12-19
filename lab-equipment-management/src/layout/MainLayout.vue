<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useBorrowStore } from '@/stores/borrow'
import {
  Monitor,
  List,
  User,
  Setting,
  Check,
  Expand,
  Fold,
  SwitchButton
} from '@element-plus/icons-vue'

const userStore = useUserStore()
const borrowStore = useBorrowStore()
const router = useRouter()
const route = useRoute()

const isCollapse = ref(false)
const asideWidth = computed(() => isCollapse.value ? '64px' : '240px')

const activeMenu = computed(() => {
  if (route.path.startsWith('/borrow/')) {
    return '/devices'
  }
  return route.path
})

const pendingCount = computed(() => borrowStore.getPendingApprovals().length)

const handleLogout = () => {
  userStore.logout()
  router.push('/')
}

const checkScreenSize = () => {
  const width = window.innerWidth
  if (width < 768) {
    isCollapse.value = true
  } else {
    isCollapse.value = false
  }
}

onMounted(() => {
  checkScreenSize()
  window.addEventListener('resize', checkScreenSize)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkScreenSize)
})

const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}
</script>

<template>
  <el-container class="layout-container">
    <el-aside :width="asideWidth" class="aside">
      <div class="logo-container">
        <el-icon class="logo-icon"><Monitor /></el-icon>
        <transition name="fade">
          <span v-show="!isCollapse" class="logo-text">设备管理系统</span>
        </transition>
      </div>
      
      <el-menu
        :default-active="activeMenu"
        class="el-menu-vertical"
        :collapse="isCollapse"
        background-color="#fff"
        text-color="#606266"
        active-text-color="#1890ff"
        router
      >
        <!-- 公共菜单 -->
        <el-menu-item index="/devices">
          <el-icon><List /></el-icon>
          <template #title>设备列表</template>
        </el-menu-item>

        <!-- 学生菜单 -->
        <el-menu-item v-if="!userStore.isAdmin" index="/profile">
          <el-icon><User /></el-icon>
          <template #title>我的借用</template>
        </el-menu-item>

        <!-- 管理员菜单 -->
        <template v-if="userStore.isAdmin">
          <el-menu-item index="/admin/devices">
            <el-icon><Setting /></el-icon>
            <template #title>设备管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/approvals">
            <el-icon><Check /></el-icon>
            <template #title>
              <span>借用审核</span>
              <el-tag 
                v-if="pendingCount > 0 && !isCollapse" 
                type="danger" 
                effect="dark" 
                size="small" 
                round
                style="margin-left: 8px; height: 18px; line-height: 16px; padding: 0 6px;"
              >
                {{ pendingCount }}
              </el-tag>
            </template>
          </el-menu-item>
        </template>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="header">
        <div class="header-left">
          <el-icon 
            class="collapse-btn" 
            @click="toggleCollapse"
          >
            <component :is="isCollapse ? Expand : Fold" />
          </el-icon>
        </div>
        
        <div class="header-right">
          <div class="user-info">
            <span class="user-role">{{ userStore.isAdmin ? '管理员' : '学生' }}</span>
            <span class="user-name">{{ userStore.name }}</span>
          </div>
          <el-button 
            type="danger" 
            circle 
            plain 
            size="small"
            @click="handleLogout"
          >
            <el-icon><SwitchButton /></el-icon>
          </el-button>
        </div>
      </el-header>

      <el-main class="main">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<style scoped>
.layout-container {
  height: 100vh;
  width: 100vw;
  overflow: hidden;
}

.aside {
  background-color: #fff;
  border-right: 1px solid #e6e6e6;
  transition: width 0.3s ease-in-out;
  display: flex;
  flex-direction: column;
  box-shadow: 2px 0 8px 0 rgba(29, 35, 41, 0.05);
  z-index: 10;
}

.logo-container {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 10px;
  border-bottom: 1px solid #f0f0f0;
  overflow: hidden;
}

.logo-icon {
  font-size: 24px;
  color: #1890ff;
  margin-right: 8px;
}

.logo-text {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  white-space: nowrap;
}

.el-menu-vertical {
  border-right: none;
  flex: 1;
}

.header {
  background-color: #fff;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  height: 60px;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  z-index: 9;
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
  color: #606266;
  transition: color 0.3s;
}

.collapse-btn:hover {
  color: #1890ff;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  line-height: 1.2;
}

.user-name {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}

.user-role {
  font-size: 12px;
  color: #909399;
}

.main {
  background-color: #f5f7fa;
  padding: 20px;
  overflow-y: auto;
}

/* Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Mobile responsiveness adjustments */
@media (max-width: 768px) {
  .logo-text {
    display: none;
  }
  
  .user-role {
    display: none;
  }
}
</style>
