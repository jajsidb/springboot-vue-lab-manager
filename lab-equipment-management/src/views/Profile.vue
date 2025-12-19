<template>
  <div class="profile-container">
    <div class="main-content">
      <el-card class="records-card">
        <template #header>
          <div class="card-header">
            <h3>我的借用记录</h3>
          </div>
        </template>

        <div v-if="myRecords.length > 0" class="records-timeline">
          <el-timeline>
            <el-timeline-item
              v-for="record in myRecords"
              :key="record.id"
              :timestamp="record.createTime"
              placement="top"
              :type="getStatusType(record.status)"
            >
              <el-card class="record-item">
                <div class="record-header">
                  <h4>{{ record.deviceName }}</h4>
                  <el-tag :type="getStatusType(record.status)">
                    {{ getStatusText(record.status) }}
                  </el-tag>
                </div>
                
                <div class="record-body">
                  <p><strong>借用时间：</strong>{{ formatDate(record.startTime) }} 至 {{ formatDate(record.endTime) }}</p>
                  <p><strong>用途：</strong>{{ record.purpose }}</p>
                </div>

                <div class="record-footer" v-if="record.status === 'approved'">
                  <el-button 
                    type="success" 
                    size="small" 
                    @click="returnDevice(record)"
                  >
                    归还设备
                  </el-button>
                </div>
              </el-card>
            </el-timeline-item>
          </el-timeline>
        </div>

        <el-empty 
          v-else 
          description="暂无借用记录" 
        >
          <el-button type="primary" @click="goToDevices">去借用设备</el-button>
        </el-empty>
      </el-card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useBorrowStore, type BorrowRecord } from '@/stores/borrow'
import { useDeviceStore } from '@/stores/device'
import { ElMessage, ElMessageBox } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const borrowStore = useBorrowStore()
const deviceStore = useDeviceStore()

onMounted(() => {
  borrowStore.fetchRecords()
})

const myRecords = computed(() => {
  // Sort by createTime descending
  return borrowStore.getUserBorrowRecords(userStore.name).sort((a, b) => {
    return new Date(b.createTime).getTime() - new Date(a.createTime).getTime()
  })
})

const getStatusType = (status: BorrowRecord['status']) => {
  const map: Record<string, 'primary' | 'success' | 'warning' | 'danger' | 'info'> = {
    pending: 'warning',
    return_pending: 'warning',
    approved: 'primary',
    returned: 'success',
    rejected: 'danger'
  }
  return map[status] || 'info'
}

const getStatusText = (status: BorrowRecord['status']) => {
  const map: Record<string, string> = {
    pending: '待审核',
    return_pending: '归还审核中',
    approved: '使用中',
    returned: '已归还',
    rejected: '已拒绝'
  }
  return map[status] || status
}

const formatDate = (dateStr: string) => {
  // Simple formatting, can be improved with date-fns or dayjs
  return new Date(dateStr).toLocaleString()
}

const goToDevices = () => {
  router.push('/devices')
}

const returnDevice = (record: BorrowRecord) => {
  ElMessageBox.confirm(
    '确定要申请归还该设备吗？',
    '归还申请',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'info',
    }
  )
    .then(() => {
      borrowStore.updateBorrowStatus(record.id, 'return_pending')
      ElMessage.success('归还申请已提交，请等待管理员确认')
    })
    .catch(() => {})
}
</script>

<style scoped>
.profile-container {
  /* Padding handled by MainLayout */
}

.main-content {
  max-width: 800px;
  margin: 0 auto;
}

.records-card {
  min-height: 400px;
}

.record-item {
  margin-bottom: 8px;
}

.record-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.record-header h4 {
  margin: 0;
  font-size: 16px;
  color: #333;
}

.record-body p {
  margin: 4px 0;
  color: #666;
  font-size: 14px;
}

.record-footer {
  margin-top: 12px;
  text-align: right;
}

@media (max-width: 768px) {
  .main-content {
    padding: 0;
  }
}
</style>
