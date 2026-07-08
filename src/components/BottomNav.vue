<script setup lang="ts">
import { RouterLink } from 'vue-router'

const tabs = [
  { to: '/', label: '学习', icon: '📖' },
  { to: '/quiz', label: '答题', icon: '✍️' },
  { to: '/challenge', label: '挑战', icon: '⚡' },
  { to: '/profile', label: '我的', icon: '📊' },
]
</script>

<template>
  <nav class="nav">
    <RouterLink
      v-for="t in tabs"
      :key="t.to"
      :to="t.to"
      class="tab"
      active-class="active"
      :exact-active-class="t.to === '/' ? 'active' : ''"
    >
      <span class="icon">{{ t.icon }}</span>
      <span class="label">{{ t.label }}</span>
    </RouterLink>
  </nav>
</template>

<style scoped>
.nav {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: calc(62px + var(--safe-bottom));
  padding-bottom: var(--safe-bottom);
  display: flex;
  background: rgba(13, 13, 16, 0.92);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-top: 1px solid var(--border-soft);
  z-index: 50;
}
.tab {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 3px;
  text-decoration: none;
  color: var(--text-dim);
  transition: color 0.15s;
}
.tab.active { color: var(--accent); }
.icon { font-size: 20px; line-height: 1; }
.label { font-size: 11px; font-weight: 500; }
</style>
