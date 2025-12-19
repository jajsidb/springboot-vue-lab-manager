import { defineStore } from 'pinia'
import { ref } from 'vue'
import { request } from '../utils/request'

export interface BorrowRecord {
  id: number
  userName: string
  deviceId: number
  deviceName: string
  startTime: string
  endTime: string
  purpose: string
  contactInfo?: string
  status: 'pending' | 'approved' | 'rejected' | 'returned' | 'return_pending'
  createTime: string
}

export const useBorrowStore = defineStore('borrow', () => {
  const borrowRecords = ref<BorrowRecord[]>([])

  const fetchRecords = async () => {
    try {
      const data = await request('/borrow')
      if (Array.isArray(data)) {
        borrowRecords.value = data
      }
    } catch (error) {
      console.error('Failed to fetch records:', error)
    }
  }

  const addBorrowRecord = async (record: Omit<BorrowRecord, 'id' | 'createTime'>) => {
    try {
      const newRecord = await request('/borrow/apply', {
        method: 'POST',
        body: JSON.stringify(record)
      })
      borrowRecords.value.push(newRecord)
    } catch (error) {
      console.error('Failed to add record:', error)
      throw error
    }
  }

  const getUserBorrowRecords = (userName: string) => {
    return borrowRecords.value.filter(r => r.userName === userName)
  }

  const updateBorrowStatus = async (id: number, status: BorrowRecord['status']) => {
    try {
      const updatedRecord = await request(`/borrow/status/${id}`, {
        method: 'POST',
        body: status
      })
      const index = borrowRecords.value.findIndex(r => r.id === id)
      if (index !== -1) {
        borrowRecords.value[index] = updatedRecord
      }
    } catch (error) {
      console.error('Failed to update status:', error)
    }
  }

  const getPendingApprovals = () => {
    return borrowRecords.value.filter(r => r.status === 'pending' || r.status === 'return_pending')
  }

  const checkConflict = async (deviceId: number, startTime: string, endTime: string) => {
    const start = new Date(startTime).getTime()
    const end = new Date(endTime).getTime()
    
    return borrowRecords.value.some(record => {
      if (record.deviceId !== deviceId) return false
      if (record.status === 'rejected' || record.status === 'returned') return false
      
      const recordStart = new Date(record.startTime).getTime()
      const recordEnd = new Date(record.endTime).getTime()
      
      return (start < recordEnd && end > recordStart)
    })
  }

  // Init
  fetchRecords()

  return {
    borrowRecords,
    fetchRecords,
    addBorrowRecord,
    getUserBorrowRecords,
    updateBorrowStatus,
    getPendingApprovals,
    checkConflict,
  }
})
