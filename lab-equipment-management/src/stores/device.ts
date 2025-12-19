import { defineStore } from 'pinia'
import { ref } from 'vue'
import { request } from '../utils/request'

export interface Device {
  id: number
  name: string
  image: string
  status: 'available' | 'borrowed'
  type: 'optical' | 'electronic' | 'consumable' | 'other'
  maxDuration?: number
  description: string
  createTime: string
}

export const useDeviceStore = defineStore('device', () => {
  const devices = ref<Device[]>([])

  const fetchDevices = async () => {
    try {
      const data = await request('/devices')
      if (Array.isArray(data)) {
        devices.value = data
      }
    } catch (error) {
      console.error('Failed to fetch devices:', error)
    }
  }

  const addDevice = async (device: Omit<Device, 'id' | 'createTime'>) => {
    try {
      const newDevice = await request('/devices', {
        method: 'POST',
        body: JSON.stringify(device)
      })
      devices.value.push(newDevice)
    } catch (error) {
      console.error('Failed to add device:', error)
    }
  }

  const updateDevice = async (id: number, updates: Partial<Device>) => {
    try {
      const device = devices.value.find(d => d.id === id)
      if (device) {
        const updatedData = { ...device, ...updates }
        const result = await request(`/devices/${id}`, {
          method: 'PUT',
          body: JSON.stringify(updatedData)
        })
        const index = devices.value.findIndex(d => d.id === id)
        if (index !== -1) {
          devices.value[index] = result
        }
      }
    } catch (error) {
      console.error('Failed to update device:', error)
    }
  }

  const deleteDevice = async (id: number) => {
    try {
      await request(`/devices/${id}`, { method: 'DELETE' })
      const index = devices.value.findIndex(d => d.id === id)
      if (index !== -1) {
        devices.value.splice(index, 1)
      }
    } catch (error) {
      console.error('Failed to delete device:', error)
    }
  }

  const getDeviceById = (id: number) => {
    return devices.value.find(d => d.id === id)
  }

  const getAvailableDevices = () => {
    return devices.value.filter(d => d.status === 'available')
  }

  // Initialize
  fetchDevices()

  return {
    devices,
    fetchDevices,
    addDevice,
    updateDevice,
    deleteDevice,
    getDeviceById,
    getAvailableDevices,
  }
})
