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
function isTiangan(i: Tiangan | Dizhi): i is Tiangan {
  return !isDizhi(i)
}
const e = props.item.etymology
const d = isDizhi(props.item) ? props.item : null
const t = isTiangan(props.item) ? props.item : null
</script>

<template>
  <div class="card">
    <!-- 头部：大字 + 基础属性 -->
    <div class="head" :class="`accent-${props.item.wuxing}`">
      <div class="big">{{ props.item.char }}</div>
      <div class="info">
        <div class="py">{{ props.item.pinyin }} · 第{{ props.item.order }}位</div>
        <div class="tags">
          <WuxingBadge :wuxing="props.item.wuxing" />
          <span class="tag">{{ props.item.yinyang }}</span>
          <span v-if="t" class="tag img">{{ t.imagery }}</span>
        </div>
        <div v-if="d" class="tags">
          <span class="tag">{{ d.season }}季</span>
          <span class="tag">生肖{{ d.animal }}</span>
          <span class="tag">{{ d.category }}</span>
          <span class="tag">{{ d.isPure ? '纯' : '不纯' }}</span>
        </div>
        <div v-if="d" class="tags">
          <span class="tag">时辰 {{ d.hour }}</span>
        </div>
      </div>
    </div>

    <!-- 藏干（地支） -->
    <section v-if="d" class="block">
      <h3>藏干</h3>
      <div class="canggan">
        <div v-for="c in d.canggan" :key="c.stem" class="cg-item">
          <span class="cg-stem">{{ c.stem }}</span>
          <WuxingBadge :wuxing="c.wuxing" size="sm" />
          <span class="cg-lv">{{ c.level }}气</span>
        </div>
      </div>
    </section>

    <!-- 说文解字 -->
    <section class="block">
      <h3>说文解字</h3>
      <dl>
        <dt>字形</dt><dd>{{ e.guhu }}</dd>
        <dt>说文</dt><dd class="quote">「{{ e.shuowen }}」</dd>
        <dt>本义</dt><dd>{{ e.benyi }}</dd>
        <dt>为何选用</dt><dd>{{ e.whyChosen }}</dd>
      </dl>
    </section>

    <!-- 记忆钩子 -->
    <section class="block memo" :class="`memo-${props.item.wuxing}`">
      <h3>🧠 记忆</h3>
      <p>{{ props.item.memory }}</p>
    </section>
  </div>
</template>

<style scoped>
.card {
  background: var(--bg-card);
  border-radius: var(--r-lg);
  overflow: hidden;
}
.head {
  display: flex;
  gap: 18px;
  padding: 22px 20px 18px;
  border-bottom: 1px solid var(--border-soft);
}
.big {
  font-size: 64px;
  font-weight: 700;
  line-height: 1;
  flex-shrink: 0;
}
.accent-木 .big { color: var(--wx-mu); }
.accent-火 .big { color: var(--wx-huo); }
.accent-土 .big { color: var(--wx-tu); }
.accent-金 .big { color: var(--wx-jin); }
.accent-水 .big { color: var(--wx-shui); }
.info { flex: 1; display: flex; flex-direction: column; gap: 10px; justify-content: center; }
.py { font-size: 13px; color: var(--text-dim); }
.tags { display: flex; flex-wrap: wrap; gap: 6px; align-items: center; }
.tag {
  font-size: 12px;
  padding: 3px 9px;
  border-radius: var(--r-full);
  background: var(--bg-elev);
  color: var(--text-soft);
  border: 1px solid var(--border-soft);
}
.tag.img { font-size: 11px; }

.block { padding: 16px 20px; border-bottom: 1px solid var(--border-soft); }
.block:last-child { border-bottom: none; }
h3 { font-size: 13px; color: var(--text-dim); margin-bottom: 10px; font-weight: 600; letter-spacing: 0.5px; }

.canggan { display: flex; flex-direction: column; gap: 8px; }
.cg-item { display: flex; align-items: center; gap: 8px; }
.cg-stem { font-size: 20px; font-weight: 600; width: 24px; }
.cg-lv { font-size: 12px; color: var(--text-dim); }

dl { display: grid; grid-template-columns: 64px 1fr; gap: 8px 12px; }
dt { font-size: 12px; color: var(--text-dim); padding-top: 1px; }
dd { font-size: 14px; color: var(--text); line-height: 1.6; }
.quote { color: var(--text-soft); font-style: italic; }

.memo p { font-size: 14px; line-height: 1.7; color: var(--text); }
.memo-木 { background: linear-gradient(180deg, rgba(63,166,106,0.08), transparent); }
.memo-火 { background: linear-gradient(180deg, rgba(224,86,75,0.08), transparent); }
.memo-土 { background: linear-gradient(180deg, rgba(200,154,58,0.08), transparent); }
.memo-金 { background: linear-gradient(180deg, rgba(154,163,173,0.08), transparent); }
.memo-水 { background: linear-gradient(180deg, rgba(59,125,216,0.08), transparent); }
</style>
