<template>
  <div class="admin-approvals-container">
    <div class="main-content">
      <el-tabs v-model="activeTab" class="approval-tabs">
        <el-tab-pane label="借用审核" name="pending">
          <el-table :data="pendingRecords" style="width: 100%" border stripe>
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="userName" label="申请人" width="100" />
            <el-table-column prop="deviceName" label="设备名称" width="150" />
            <el-table-column label="借用时间" width="300">
              <template #default="scope">
                {{ formatDate(scope.row.startTime) }} - {{ formatDate(scope.row.endTime) }}
              </template>
            </el-table-column>
            <el-table-column prop="purpose" label="用途" />
            <el-table-column prop="contactInfo" label="联系方式" width="120" />
            <el-table-column label="操作" width="200" fixed="right">
              <template #default="scope">
                <el-button 
                  size="small" 
                  type="success" 
                  @click="handleApprove(scope.row)"
                >
                  同意
                </el-button>
                <el-button 
                  size="small" 
                  type="danger" 
                  @click="handleReject(scope.row)"
                >
                  拒绝
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <el-empty v-if="pendingRecords.length === 0" description="暂无借用申请" />
        </el-tab-pane>

        <el-tab-pane label="归还审核" name="return_pending">
          <el-table :data="returnPendingRecords" style="width: 100%" border stripe>
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="userName" label="申请人" width="100" />
            <el-table-column prop="deviceName" label="设备名称" width="150" />
            <el-table-column label="借用时间" width="300">
              <template #default="scope">
                {{ formatDate(scope.row.startTime) }} - {{ formatDate(scope.row.endTime) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200" fixed="right">
              <template #default="scope">
                <el-button 
                  size="small" 
                  type="success" 
                  @click="handleReturnConfirm(scope.row)"
                >
                  确认归还
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <el-empty v-if="returnPendingRecords.length === 0" description="暂无归还申请" />
        </el-tab-pane>
        
        <el-tab-pane label="借出中" name="approved">
          <el-table :data="approvedRecords" style="width: 100%" border stripe>
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="userName" label="借用人" width="100" />
            <el-table-column prop="deviceName" label="设备名称" width="150" />
            <el-table-column label="借用时间" width="300">
              <template #default="scope">
                {{ formatDate(scope.row.startTime) }} - {{ formatDate(scope.row.endTime) }}
              </template>
            </el-table-column>
            <el-table-column prop="purpose" label="用途" />
            <el-table-column label="操作" width="150" fixed="right">
              <template #default="scope">
                <el-button 
                  size="small" 
                  type="primary" 
                  @click="handleReturn(scope.row)"
                >
                  标记归还
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        
        <el-tab-pane label="历史记录" name="history">
          <el-table :data="historyRecords" style="width: 100%" border stripe>
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="userName" label="申请人" width="100" />
            <el-table-column prop="deviceName" label="设备名称" width="150" />
            <el-table-column label="状态" width="100">
              <template #default="scope">
                <el-tag :type="getStatusType(scope.row.status)">
                  {{ getStatusText(scope.row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="purpose" label="用途" />
            <el-table-column prop="createTime" label="申请时间" width="180" />
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useBorrowStore, type BorrowRecord } from '@/stores/borrow'
import { useDeviceStore } from '@/stores/device'
import { ElMessage, ElMessageBox } from 'element-plus'

const router = useRouter()
const borrowStore = useBorrowStore()
const deviceStore = useDeviceStore()

onMounted(() => {
  borrowStore.fetchRecords()
})

const activeTab = ref('pending')

const pendingRecords = computed(() => {
  return borrowStore.borrowRecords.filter(r => r.status === 'pending')
})

const returnPendingRecords = computed(() => {
  return borrowStore.borrowRecords.filter(r => r.status === 'return_pending')
})

const approvedRecords = computed(() => {
  return borrowStore.borrowRecords.filter(r => r.status === 'approved')
})

const historyRecords = computed(() => {
  return borrowStore.borrowRecords.filter(r => ['returned', 'rejected'].includes(r.status))
    .sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
})

const formatDate = (dateStr: string) => {
  return new Date(dateStr).toLocaleString()
}

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

const handleApprove = (record: BorrowRecord) => {
  const device = deviceStore.getDeviceById(record.deviceId)
  if (!device) {
    ElMessage.error('设备不存在')
    return
  }
  
  if (device.status !== 'available') {
    ElMessage.warning('该设备当前已被借出或不可用')
    return
  }

  ElMessageBox.confirm(
    `确定同意 "${record.userName}" 借用 "${record.deviceName}" 吗？`,
    '审核确认',
    {
      confirmButtonText: '同意',
      cancelButtonText: '取消',
      type: 'success',
    }
  ).then(() => {
    // Update borrow record
    borrowStore.updateBorrowStatus(record.id, 'approved')
    // Update device status
    deviceStore.updateDevice(record.deviceId, { status: 'borrowed' })
    
    ElMessage.success('已同意申请')
  })
}

const handleReject = (record: BorrowRecord) => {
  ElMessageBox.prompt('请输入拒绝理由', '拒绝申请', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
  }).then(({ value }) => {
    borrowStore.updateBorrowStatus(record.id, 'rejected')
    ElMessage.info('已拒绝申请')
  }).catch(() => {
    // Cancelled
  })
}

const handleReturnConfirm = (record: BorrowRecord) => {
  ElMessageBox.confirm(
    `确认同意 "${record.userName}" 的归还申请吗？`,
    '归还确认',
    {
      confirmButtonText: '确认归还',
      cancelButtonText: '取消',
      type: 'success',
    }
  ).then(() => {
    borrowStore.updateBorrowStatus(record.id, 'returned')
    deviceStore.updateDevice(record.deviceId, { status: 'available' })
    ElMessage.success('已确认归还')
  })
}

const handleReturn = (record: BorrowRecord) => {
  ElMessageBox.confirm(
    `确认 "${record.deviceName}" 已归还？`,
    '归还确认',
    {
      confirmButtonText: '确认归还',
      cancelButtonText: '取消',
      type: 'warning',
    }
  ).then(() => {
    borrowStore.updateBorrowStatus(record.id, 'returned')
    deviceStore.updateDevice(record.deviceId, { status: 'available' })
    ElMessage.success('已标记为归还')
  })
}
</script>

<style scoped>
.admin-approvals-container {
  /* Padding handled by MainLayout */
}

.main-content {
  /* Padding handled by MainLayout */
}

.approval-tabs {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}
</style>
