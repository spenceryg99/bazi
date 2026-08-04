<script setup lang="ts">
import { ref } from 'vue'
import { ZHENQUAN_CHAPTERS } from '@/data/zhenquan'

const volumes = [1, 2, 3, 4, 5] as const
const volLabels: Record<number, string> = {
  1: '卷一·基础原理',
  2: '卷二·用神体系',
  3: '卷三·杂气·墓库·吉凶神',
  4: '卷四·六亲与行运',
  5: '卷五·格局分论',
}
const activeVol = ref(1)
const expandedCh = ref<string | null>(null)

const chaptersInVol = (v: number) => ZHENQUAN_CHAPTERS.filter((c) => c.volume === v)

function toggleCh(id: string) {
  expandedCh.value = expandedCh.value === id ? null : id
}
</script>

<template>
  <div class="page">
    <header class="hd">
      <h1>子平真诠 <span class="sub-title">白话文精解</span></h1>
      <p class="sub">清·沈孝瞻 原著　|　逐句白话翻译·注解</p>
      <p class="desc">本书以《子平真诠》原著为底本，逐句翻译为白话文，关键术语注解，是学习格局派命理入门必读</p>
    </header>

    <!-- 卷 tab -->
    <div class="vol-tabs">
      <button
        v-for="v in volumes"
        :key="v"
        :class="{ on: activeVol === v }"
        @click="activeVol = v"
      ><span class="vol-num">{{ ['', '一', '二', '三', '四', '五'][v] }}</span><span class="vol-label">{{ volLabels[v].slice(2) }}</span></button>
    </div>

    <!-- 本章卷的章节列表 -->
    <div class="ch-list">
      <div
        v-for="ch in chaptersInVol(activeVol)"
        :key="ch.id"
        class="ch-card"
        :class="{ open: expandedCh === ch.id }"
        @click="toggleCh(ch.id)"
      >
        <div class="ch-head">
          <div class="ch-title">{{ ch.title }}</div>
          <div class="ch-arrow">{{ expandedCh === ch.id ? '▾' : '▸' }}</div>
        </div>
        <div v-if="expandedCh === ch.id" class="ch-body">
          <p class="ch-summary">{{ ch.summary }}</p>
          <div class="ch-core">
            <span class="lab">核心</span>
            <p>{{ ch.coreIdea }}</p>
          </div>
          <div class="ch-concepts">
            <div v-for="(cpt, i) in ch.concepts" :key="i" class="cpt">
              <span class="cpt-term">{{ cpt.term }}</span>
              <span class="cpt-def">{{ cpt.def }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page { padding: 16px; min-height: 100%; }
.hd { margin-bottom: 20px; }
h1 { font-size: 22px; font-weight: 700; letter-spacing: 1px; }
.sub-title { font-size: 16px; color: var(--text-dim); font-weight: 400; }
.sub { font-size: 13px; color: var(--text-dim); margin-top: 4px; }
.desc { font-size: 13px; color: var(--text-soft); margin-top: 8px; line-height: 1.5; background: var(--bg-card); padding: 12px; border-radius: var(--r-sm); }

.vol-tabs { display: flex; gap: 6px; margin-bottom: 16px; overflow-x: auto; padding-bottom: 4px; }
.vol-tabs button {
  flex: 1; min-width: 0;
  display: flex; flex-direction: column; align-items: center; gap: 2px;
  padding: 10px 8px;
  border-radius: var(--r-md);
  background: var(--bg-card);
  border: 1.5px solid var(--border-soft);
  font-size: 11px;
  color: var(--text-dim);
  transition: all 0.15s;
  white-space: nowrap;
}
.vol-tabs button.on {
  border-color: var(--accent);
  color: var(--accent);
  background: rgba(184, 141, 255, 0.08);
}
.vol-num { font-size: 15px; font-weight: 700; }

.ch-list { display: flex; flex-direction: column; gap: 8px; }
.ch-card {
  background: var(--bg-card);
  border: 1px solid var(--border-soft);
  border-radius: var(--r-md);
  cursor: pointer;
  transition: border-color 0.15s;
}
.ch-card.open { border-color: var(--accent); }
.ch-head {
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px;
}
.ch-title { font-size: 14px; font-weight: 600; color: var(--text); }
.ch-arrow { font-size: 14px; color: var(--text-dim); transition: transform 0.2s; }

.ch-body { padding: 0 14px 14px; border-top: 1px solid var(--border-soft); padding-top: 12px; }
.ch-summary { font-size: 13px; color: var(--text-soft); line-height: 1.6; margin-bottom: 12px; }
.ch-core {
  background: rgba(184, 141, 255, 0.06);
  border-left: 3px solid var(--accent);
  padding: 10px 12px;
  border-radius: 0 var(--r-sm) var(--r-sm) 0;
  margin-bottom: 12px;
}
.ch-core .lab {
  font-size: 11px; font-weight: 700; color: var(--accent);
  text-transform: uppercase; letter-spacing: 1px;
  display: block; margin-bottom: 4px;
}
.ch-core p { font-size: 13px; color: var(--text); line-height: 1.6; }
.ch-concepts { display: flex; flex-direction: column; gap: 8px; }
.cpt {
  display: flex; flex-direction: column; gap: 2px;
  padding: 8px 10px;
  background: var(--bg-elev);
  border-radius: var(--r-sm);
}
.cpt-term { font-size: 12px; font-weight: 700; color: var(--accent); }
.cpt-def { font-size: 12px; color: var(--text-soft); line-height: 1.5; }
</style>
