<template>
  <div class="admin-devices-container">
    <div class="main-content">
      <div class="action-bar">
        <el-button type="primary" icon="Plus" @click="openDialog('add')">
          添加设备
        </el-button>
      </div>

      <el-table :data="deviceStore.devices" style="width: 100%" border stripe>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="图片" width="100">
          <template #default="scope">
            <el-image 
              style="width: 60px; height: 60px"
              :src="scope.row.image"
              :preview-src-list="[scope.row.image]"
              fit="cover"
            />
          </template>
        </el-table-column>
        <el-table-column prop="name" label="设备名称" width="180" />
        <el-table-column prop="description" label="描述" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 'available' ? 'success' : 'danger'">
              {{ scope.row.status === 'available' ? '空闲' : '已借出' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button size="small" @click="openDialog('edit', scope.row)">
              编辑
            </el-button>
            <el-button 
              size="small" 
              type="danger" 
              @click="handleDelete(scope.row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 添加/编辑设备弹窗 -->
      <el-dialog
        v-model="dialogVisible"
        :title="dialogType === 'add' ? '添加设备' : '编辑设备'"
        width="500px"
      >
        <el-form :model="form" label-width="80px">
          <el-form-item label="名称">
            <el-input v-model="form.name" />
          </el-form-item>
          <el-form-item label="描述">
            <el-input v-model="form.description" type="textarea" />
          </el-form-item>
          <el-form-item label="图片URL">
            <el-input v-model="form.image" placeholder="请输入图片URL" />
          </el-form-item>
        </el-form>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="dialogVisible = false">取消</el-button>
            <el-button type="primary" @click="handleSubmit">
              确定
            </el-button>
          </span>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useDeviceStore, type Device } from '@/stores/device'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

const deviceStore = useDeviceStore()

onMounted(() => {
  deviceStore.fetchDevices()
})

const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const currentId = ref<number | null>(null)

const form = ref({
  name: '',
  description: '',
  image: ''
})

const openDialog = (type: 'add' | 'edit', row?: Device) => {
  dialogType.value = type
  if (type === 'edit' && row) {
    currentId.value = row.id
    form.value = {
      name: row.name,
      description: row.description,
      image: row.image
    }
  } else {
    currentId.value = null
    form.value = {
      name: '',
      description: '',
      image: 'https://trae-api-sg.mchost.guru/api/ide/v1/text_to_image?prompt=Laboratory%20equipment%20placeholder%20white%20background&image_size=square'
    }
  }
  dialogVisible.value = true
}

const handleSubmit = () => {
  if (!form.value.name) {
    ElMessage.warning('请输入设备名称')
    return
  }

  if (dialogType.value === 'add') {
    deviceStore.addDevice({
      name: form.value.name,
      description: form.value.description,
      image: form.value.image,
      status: 'available'
    })
    ElMessage.success('添加成功')
  } else if (dialogType.value === 'edit' && currentId.value) {
    deviceStore.updateDevice(currentId.value, {
      name: form.value.name,
      description: form.value.description,
      image: form.value.image
    })
    ElMessage.success('更新成功')
  }
  
  dialogVisible.value = false
}

const handleDelete = (row: Device) => {
  ElMessageBox.confirm(
    `确定要删除设备 "${row.name}" 吗？`,
    '删除确认',
    {
      confirmButtonText: '删除',
      cancelButtonText: '取消',
      type: 'warning',
    }
  ).then(() => {
    deviceStore.deleteDevice(row.id)
    ElMessage.success('删除成功')
  })
}
</script>

<style scoped>
.admin-devices-container {
  /* Padding handled by MainLayout */
}

.main-content {
  /* Padding handled by MainLayout */
}

.action-bar {
  margin-bottom: 24px;
}
</style>
