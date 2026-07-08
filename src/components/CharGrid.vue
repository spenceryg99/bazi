<script setup lang="ts">
import type { Tiangan, Dizhi } from '@/data/types'
import WuxingBadge from './WuxingBadge.vue'

const props = defineProps<{
  item: Tiangan | Dizhi
  kind: 'tiangan' | 'dizhi'
}>()

function isDizhi(i: Tiangan | Dizhi): i is Dizhi {
  return (i as Dizhi).animal !== undefined
}
</script>

<template>
  <div class="tile" :class="`wx-border-${props.item.wuxing}`">
    <div class="char">{{ props.item.char }}</div>
    <div class="meta">
      <WuxingBadge :wuxing="props.item.wuxing" size="sm" />
      <span class="yy">{{ props.item.yinyang }}</span>
    </div>
    <div v-if="isDizhi(props.item)" class="animal">{{ props.item.animal }}</div>
  </div>
</template>

<style scoped>
.tile {
  background: var(--bg-card);
  border-radius: var(--r-md);
  border: 1px solid var(--border-soft);
  padding: 14px 8px 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  transition: transform 0.1s, background 0.15s;
}
.tile:active { transform: scale(0.96); background: var(--bg-card-hover); }
.char { font-size: 30px; font-weight: 600; line-height: 1; }
.meta { display: flex; align-items: center; gap: 5px; }
.yy { font-size: 11px; color: var(--text-dim); }
.animal { font-size: 13px; color: var(--text-soft); }

.wx-border-木 { border-top: 3px solid var(--wx-mu); }
.wx-border-火 { border-top: 3px solid var(--wx-huo); }
.wx-border-土 { border-top: 3px solid var(--wx-tu); }
.wx-border-金 { border-top: 3px solid var(--wx-jin); }
.wx-border-水 { border-top: 3px solid var(--wx-shui); }
</style>
