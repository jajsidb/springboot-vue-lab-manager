import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '../views/HomePage.vue'
import DeviceList from '../views/DeviceList.vue'
import BorrowApply from '../views/borrowapply.vue'
import Profile from '../views/Profile.vue'
import AdminDevices from '../views/admin/AdminDevices.vue'
import AdminApprovals from '../views/admin/AdminApprovals.vue'
import MainLayout from '../layout/MainLayout.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomePage,
    },
    {
      path: '/',
      component: MainLayout,
      children: [
        {
          path: 'devices',
          name: 'devices',
          component: DeviceList,
        },
        {
          path: 'borrow/:id',
          name: 'borrow',
          component: BorrowApply,
        },
        {
          path: 'profile',
          name: 'profile',
          component: Profile,
        },
        {
          path: 'admin/devices',
          name: 'admin-devices',
          component: AdminDevices,
        },
        {
          path: 'admin/approvals',
          name: 'admin-approvals',
          component: AdminApprovals,
        },
      ]
    }
  ],
})

export default router
