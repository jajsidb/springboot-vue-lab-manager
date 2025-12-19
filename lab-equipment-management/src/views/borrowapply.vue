<template>
  <div class="borrow-apply-container">
    <el-card class="apply-card">
      <template #header>
        <div class="card-header">
          <el-button @click="goBack" icon="ArrowLeft" circle />
          <h2 class="title">借用申请</h2>
        </div>
      </template>
      
      <div v-if="device" class="device-info">
        <img :src="device.image" :alt="device.name" class="device-image" />
        <div class="device-details">
          <h3>{{ device.name }}</h3>
          <p>{{ device.description }}</p>
        </div>
      </div>

      <el-form 
        ref="formRef"
        :model="form"
        :rules="rules"
        label-position="top"
        class="apply-form"
      >
        <el-form-item label="借用时间" required>
          <el-col :span="11">
            <el-form-item prop="startTime">
              <el-date-picker
                v-model="form.startTime"
                type="datetime"
                placeholder="开始时间"
                style="width: 100%"
                :disabled-date="disablePastDates"
              />
            </el-form-item>
          </el-col>
          <el-col :span="2" class="text-center">至</el-col>
          <el-col :span="11">
            <el-form-item prop="endTime">
              <el-date-picker
                v-model="form.endTime"
                type="datetime"
                placeholder="归还时间"
                style="width: 100%"
                :disabled-date="disablePastDates"
              />
            </el-form-item>
          </el-col>
        </el-form-item>

        <el-form-item label="借用用途" prop="purpose">
          <el-input
            v-model="form.purpose"
            type="textarea"
            :rows="4"
            placeholder="请详细描述借用用途（如：用于电子电路实验课程）"
          />
        </el-form-item>

        <el-form-item label="备用联系方式 (可选)" prop="contactInfo">
          <el-input
            v-model="form.contactInfo"
            placeholder="请输入手机号或学号"
            prefix-icon="Phone"
          />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="submitForm(formRef)" class="submit-btn" :loading="loading">
            提交申请
          </el-button>
          <el-button @click="goBack" class="cancel-btn">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useDeviceStore } from '@/stores/device'
import { useBorrowStore } from '@/stores/borrow'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { ArrowLeft, Phone } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const deviceStore = useDeviceStore()
const borrowStore = useBorrowStore()
const userStore = useUserStore()

const deviceId = Number(route.params.id)
const device = computed(() => deviceStore.getDeviceById(deviceId))

const formRef = ref<FormInstance>()
const loading = ref(false)

const form = ref({
  startTime: '',
  endTime: '',
  purpose: '',
  contactInfo: ''
})

const rules = ref<FormRules>({
  startTime: [
    { type: 'date', required: true, message: '请选择开始时间', trigger: 'change' }
  ],
  endTime: [
    { type: 'date', required: true, message: '请选择归还时间', trigger: 'change' }
  ],
  purpose: [
    { required: true, message: '请填写借用用途', trigger: 'blur' },
    { min: 5, message: '用途描述不能少于5个字', trigger: 'blur' }
  ]
})

const disablePastDates = (time: Date) => {
  return time.getTime() < Date.now() - 8.64e7 // Disable dates before today
}

const goBack = () => {
  router.back()
}

const submitForm = async (formEl: FormInstance | undefined) => {
  if (!formEl) return
  
  if (!userStore.isLoggedIn) {
    ElMessage.error('请先登录')
    router.push('/')
    return
  }

  await formEl.validate((valid, fields) => {
    if (valid) {
      if (!device.value) {
        ElMessage.error('设备不存在')
        return
      }

      const start = new Date(form.value.startTime)
      const end = new Date(form.value.endTime)
      
      // Validate end time > start time
      if (end <= start) {
        ElMessage.warning('归还时间必须晚于开始时间')
        return
      }

      // 2. 借用时长限制
      if (device.value.maxDuration) {
        const durationDays = (end.getTime() - start.getTime()) / (1000 * 3600 * 24)
        if (durationDays > device.value.maxDuration) {
          ElMessage.warning(`该设备最大借用时长为 ${device.value.maxDuration} 天`)
          return
        }
      }

      // 1. 借用冲突检测
      if (borrowStore.checkConflict(device.value.id, form.value.startTime, form.value.endTime)) {
        ElMessage.warning('该设备在所选时段已被占用，请选择其他时段')
        return
      }

      loading.value = true
      
      // 模拟API调用延迟
      setTimeout(() => {
        borrowStore.addBorrowRecord({
          userName: userStore.name,
          deviceId: device.value!.id,
          deviceName: device.value!.name,
          startTime: form.value.startTime.toLocaleString(),
          endTime: form.value.endTime.toLocaleString(),
          purpose: form.value.purpose,
          contactInfo: form.value.contactInfo,
          status: 'pending'
        })

        ElMessage.success('申请提交成功，请等待管理员审核')
        router.push('/profile')
        loading.value = false
      }, 500)
    } else {
      console.log('error submit!', fields)
    }
  })
}

onMounted(() => {
  if (!device.value) {
    ElMessage.error('未找到该设备')
    router.push('/devices')
  }
})
</script>

<style scoped>
.borrow-apply-container {
  min-height: 100vh;
  background: #f5f7fa;
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: flex-start;
}

.apply-card {
  width: 100%;
  max-width: 600px;
  margin-top: 20px;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 16px;
}

.title {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
}

.device-info {
  display: flex;
  gap: 20px;
  margin-bottom: 24px;
  padding: 16px;
  background: #f9fafc;
  border-radius: 8px;
}

.device-image {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 8px;
}

.device-details h3 {
  margin: 0 0 8px 0;
  font-size: 18px;
}

.device-details p {
  margin: 0;
  color: #666;
  font-size: 14px;
  line-height: 1.5;
}

.text-center {
  text-align: center;
  line-height: 32px;
}

.submit-btn {
  width: 120px;
}

.cancel-btn {
  width: 120px;
  margin-left: 12px;
}

@media (max-width: 600px) {
  .device-info {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }
}
</style>