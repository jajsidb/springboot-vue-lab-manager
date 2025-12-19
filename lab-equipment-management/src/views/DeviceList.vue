<template>
  <div class="device-list-container">
    <div class="filter-section">
      <el-space wrap :size="20">
        <el-input
          v-model="searchQuery"
          placeholder="搜索设备名称或描述"
          prefix-icon="Search"
          style="width: 250px"
          clearable
        />
        
        <el-select v-model="typeFilter" placeholder="设备类型" style="width: 150px" clearable>
          <el-option label="所有类型" value="" />
          <el-option label="光学仪器" value="optical" />
          <el-option label="电子设备" value="electronic" />
          <el-option label="耗材" value="consumable" />
          <el-option label="其他" value="other" />
        </el-select>

        <el-radio-group v-model="statusFilter">
          <el-radio-button label="all">全部状态</el-radio-button>
          <el-radio-button label="available">可借用</el-radio-button>
          <el-radio-button label="borrowed">已借出</el-radio-button>
        </el-radio-group>
      </el-space>
    </div>

    <div class="device-grid">
      <el-card 
        v-for="device in filteredDevices" 
        :key="device.id"
        class="device-card"
        shadow="hover"
      >
        <div class="device-image">
          <img :src="device.image" :alt="device.name" />
        </div>
        
        <div class="device-info">
          <h3 class="device-name">{{ device.name }}</h3>
          <p class="device-description">{{ device.description }}</p>
          
          <div class="device-status">
            <el-tag 
              :type="device.status === 'available' ? 'success' : 'danger'"
              size="large"
            >
              <el-icon size="12">
                <component :is="device.status === 'available' ? CircleCheck : CircleClose" />
              </el-icon>
              {{ device.status === 'available' ? '可借用' : '已借出' }}
            </el-tag>
          </div>
          
          <div class="device-actions">
            <el-button 
              type="primary" 
              @click="borrowDevice(device)"
              :disabled="device.status !== 'available'"
              size="large"
              class="borrow-btn"
            >
              申请借用
            </el-button>
          </div>
        </div>
      </el-card>
    </div>

    <el-empty 
      v-if="filteredDevices.length === 0"
      description="暂无设备数据"
      :image-size="200"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useDeviceStore } from '@/stores/device'
import { ElMessage } from 'element-plus'
import { CircleCheck, CircleClose, Search } from '@element-plus/icons-vue'

const router = useRouter()
const deviceStore = useDeviceStore()

onMounted(() => {
  deviceStore.fetchDevices()
})

const statusFilter = ref<'all' | 'available' | 'borrowed'>('all')
const typeFilter = ref('')
const searchQuery = ref('')

const filteredDevices = computed(() => {
  return deviceStore.devices.filter(d => {
    // Status Filter
    if (statusFilter.value !== 'all' && d.status !== statusFilter.value) {
      return false
    }
    
    // Type Filter
    if (typeFilter.value && d.type !== typeFilter.value) {
      return false
    }
    
    // Search Filter
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase()
      return d.name.toLowerCase().includes(query) || 
             d.description.toLowerCase().includes(query) ||
             String(d.id).includes(query)
    }
    
    return true
  })
})

const borrowDevice = (device: any) => {
  if (device.status !== 'available') {
    ElMessage.warning('该设备暂不可借用')
    return
  }
  
  router.push(`/borrow/${device.id}`)
}
</script>

<style scoped>
.device-list-container {
  /* Padding is handled by MainLayout */
}

.filter-section {
  margin-bottom: 24px;
  display: flex;
  justify-content: center;
}

.device-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
  margin-bottom: 24px;
}

.device-card {
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  border: none;
  background: white;
}

.device-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
}

.device-image {
  width: 100%;
  height: 200px;
  overflow: hidden;
  border-radius: 8px;
  margin-bottom: 16px;
  position: relative;
}

.device-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.device-card:hover .device-image img {
  transform: scale(1.05);
}

.device-info {
  padding: 0 8px;
}

.device-name {
  font-size: 18px;
  font-weight: 600;
  margin: 0 0 8px 0;
  color: #303133;
}

.device-description {
  font-size: 14px;
  color: #606266;
  margin: 0 0 16px 0;
  line-height: 1.5;
  height: 42px; /* Limit to 2 lines */
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.device-status {
  margin-bottom: 16px;
  display: flex;
  align-items: center;
}

.device-actions {
  text-align: center;
}

.borrow-btn {
  width: 100%;
  border-radius: 8px;
}

@media (max-width: 768px) {
  .device-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }
}
</style>
