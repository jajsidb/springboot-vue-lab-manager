import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { request } from '../utils/request'

export const useUserStore = defineStore('user', () => {
  const name = ref<string>('')
  const role = ref<'student' | 'admin'>('student')
  const isLoggedIn = ref<boolean>(false)

  const isAdmin = computed(() => role.value === 'admin')

  const login = async (userName: string, userRole: 'student' | 'admin') => {
    try {
      const res = await request('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ username: userName, password: 'password' })
      })
      
      if (res) {
        name.value = res.username
        role.value = res.role as 'student' | 'admin'
        isLoggedIn.value = true
      }
    } catch (e) {
        try {
            const newUser = await request('/auth/register', {
                method: 'POST',
                body: JSON.stringify({ username: userName, password: 'password', role: userRole })
            })
            name.value = newUser.username
            role.value = newUser.role as 'student' | 'admin'
            isLoggedIn.value = true
        } catch (regError) {
            console.error("Login/Register failed", regError)
        }
    }
  }

  const logout = () => {
    name.value = ''
    role.value = 'student'
    isLoggedIn.value = false
  }

  return {
    name,
    role,
    isLoggedIn,
    isAdmin,
    login,
    logout,
  }
})
