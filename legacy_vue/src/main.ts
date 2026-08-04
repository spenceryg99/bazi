import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import './styles/tokens.css'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'study', component: () => import('@/pages/StudyPage.vue') },
    { path: '/relations', name: 'relations', component: () => import('@/pages/RelationsPage.vue') },
    { path: '/lunming', name: 'lunming', component: () => import('@/pages/LunmingPage.vue') },
    { path: '/zhenquan', name: 'zhenquan', component: () => import('@/pages/ZhenquanPage.vue') },
    { path: '/xingming', name: 'xingming', component: () => import('@/pages/XingmingPage.vue') },
    { path: '/quiz', name: 'quiz', component: () => import('@/pages/QuizPage.vue') },
    { path: '/challenge', name: 'challenge', component: () => import('@/pages/ChallengePage.vue') },
    { path: '/profile', name: 'profile', component: () => import('@/pages/ProfilePage.vue') },
    { path: '/:pathMatch(.*)*', redirect: '/' },
  ],
})

createApp(App).use(router).mount('#app')
