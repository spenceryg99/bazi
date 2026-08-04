<script setup lang="ts">
import type { Wuxing } from '@/data/types'

const props = defineProps<{
  wuxing: Wuxing
  size?: 'sm' | 'md'
}>()
</script>

<template>
  <span class="badge" :class="[`badge-${props.wuxing}`, props.size === 'sm' ? 'sm' : '']">
    {{ props.wuxing }}
  </span>
</template>

<style scoped>
.badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: var(--r-full);
  font-size: 14px;
  font-weight: 600;
  color: #fff;
}
.sm { width: 22px; height: 22px; font-size: 12px; }
.badge-木 { background: var(--wx-mu); }
.badge-火 { background: var(--wx-huo); }
.badge-土 { background: var(--wx-tu); }
.badge-金 { background: var(--wx-jin); }
.badge-水 { background: var(--wx-shui); }
</style>
