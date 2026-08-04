<script setup lang="ts">
import { ref, computed } from 'vue'
import { RouterLink } from 'vue-router'
import { TIANGAN } from '@/data/tiangan'
import { DIZHI } from '@/data/dizhi'
import CharGrid from '@/components/CharGrid.vue'
import CharCard from '@/components/CharCard.vue'
import type { Tiangan, Dizhi } from '@/data/types'

type Sel = { kind: 'tiangan'; item: Tiangan } | { kind: 'dizhi'; item: Dizhi } | null
const sel = ref<Sel>(null)

const tab = ref<'all' | 'tiangan' | 'dizhi'>('all')

const all = computed(() => {
  if (tab.value === 'tiangan') return TIANGAN.map((i) => ({ kind: 'tiangan' as const, item: i }))
  if (tab.value === 'dizhi') return DIZHI.map((i) => ({ kind: 'dizhi' as const, item: i }))
  return [
    ...TIANGAN.map((i) => ({ kind: 'tiangan' as const, item: i })),
    ...DIZHI.map((i) => ({ kind: 'dizhi' as const, item: i })),
  ]
})

function pick(kind: 'tiangan' | 'dizhi', item: Tiangan | Dizhi) {
  sel.value = kind === 'tiangan' ? { kind, item: item as Tiangan } : { kind, item: item as Dizhi }
}
</script>

<template>
  <div class="page">
    <header class="hd">
      <h1>天干地支 · 释义</h1>
      <p class="sub">点任一字查看完整释义（说文解字 / 本义 / 记忆法）</p>
    </header>

    <!-- 入口卡片 -->
    <div class="entries">
      <RouterLink to="/relations" class="entry entry-rel">
        <div class="entry-l">
          <span class="entry-t">地支六大关系</span>
          <span class="entry-s">六合·六冲·三合·三刑·三会·六害（含圆图）</span>
        </div>
        <span class="entry-arrow">›</span>
      </RouterLink>
      <RouterLink to="/lunming" class="entry entry-lm">
        <div class="entry-l">
          <span class="entry-t">子平论命流程</span>
          <span class="entry-s">格局派 vs 旺衰派 · 标准次序 + 八正格</span>
        </div>
        <span class="entry-arrow">›</span>
      </RouterLink>
      <RouterLink to="/xingming" class="entry entry-xm">
        <div class="entry-l">
          <span class="entry-t">姓名学 · 五格剖象法</span>
          <span class="entry-s">五格 + 81数理 + 计算器（≠八字）</span>
        </div>
        <span class="entry-arrow">›</span>
      </RouterLink>
    </div>

    <div class="tabs">
      <button :class="{ on: tab === 'all' }" @click="tab = 'all'">全部 22</button>
      <button :class="{ on: tab === 'tiangan' }" @click="tab = 'tiangan'">天干 10</button>
      <button :class="{ on: tab === 'dizhi' }" @click="tab = 'dizhi'">地支 12</button>
    </div>

    <div class="grid">
      <div v-for="(g, i) in all" :key="g.item.char + i" @click="pick(g.kind, g.item)">
        <CharGrid :item="g.item" :kind="g.kind" />
      </div>
    </div>

    <!-- 详情弹层 -->
    <transition name="sheet">
      <div v-if="sel" class="mask" @click.self="sel = null">
        <div class="sheet">
          <div class="grab" @click="sel = null"></div>
          <CharCard :item="sel.item" :kind="sel.kind" />
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.page { padding: 16px 16px 20px; }
.hd { margin-bottom: 16px; }
h1 { font-size: 22px; font-weight: 700; }
.sub { font-size: 13px; color: var(--text-dim); margin-top: 4px; }

.tabs { display: flex; gap: 8px; margin-bottom: 16px; }
.tabs button {
  flex: 1;
  padding: 9px;
  border-radius: var(--r-full);
  background: var(--bg-card);
  font-size: 13px;
  color: var(--text-soft);
  border: 1px solid var(--border-soft);
}
.tabs button.on { background: var(--accent); color: #fff; border-color: var(--accent); }

.grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
}

.rel-entry {
  display: flex; align-items: center; justify-content: space-between;
  background: linear-gradient(135deg, rgba(184,141,255,0.15), rgba(59,125,216,0.1));
  border: 1px solid rgba(184,141,255,0.3);
  border-radius: var(--r-md);
  padding: 14px 16px;
  margin-bottom: 16px;
  text-decoration: none;
}
.rel-entry-l { display: flex; flex-direction: column; gap: 3px; }
.rel-entry-t { font-size: 16px; font-weight: 600; color: var(--accent); }
.rel-entry-s { font-size: 11px; color: var(--text-dim); }
.rel-arrow { font-size: 22px; color: var(--accent); }

.entries { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
.entry {
  display: flex; align-items: center; justify-content: space-between;
  border-radius: var(--r-md);
  padding: 13px 16px;
  text-decoration: none;
}
.entry-rel { background: linear-gradient(135deg, rgba(184,141,255,0.15), rgba(59,125,216,0.1)); border: 1px solid rgba(184,141,255,0.3); }
.entry-lm { background: linear-gradient(135deg, rgba(184,92,209,0.15), rgba(63,166,106,0.1)); border: 1px solid rgba(184,92,209,0.3); }
.entry-xm { background: linear-gradient(135deg, rgba(200,154,58,0.15), rgba(154,163,173,0.1)); border: 1px solid rgba(200,154,58,0.3); }
.entry-l { display: flex; flex-direction: column; gap: 3px; }
.entry-t { font-size: 15px; font-weight: 600; color: var(--text); }
.entry-s { font-size: 11px; color: var(--text-dim); }
.entry-arrow { font-size: 22px; color: var(--accent); }

.mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.55);
  z-index: 100;
  display: flex;
  align-items: flex-end;
}
.sheet {
  width: 100%;
  max-height: 88vh;
  overflow-y: auto;
  background: var(--bg);
  border-radius: 24px 24px 0 0;
  padding: 10px 14px calc(20px + var(--safe-bottom));
}
.grab {
  width: 38px; height: 4px;
  background: var(--border);
  border-radius: 2px;
  margin: 0 auto 12px;
}

.sheet-enter-active { transition: transform 0.28s cubic-bezier(0.2,0.8,0.2,1); }
.sheet-enter-from { transform: translateY(100%); }
</style>
