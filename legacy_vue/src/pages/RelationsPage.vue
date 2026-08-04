<script setup lang="ts">
import { ref } from 'vue'
import { RELATIONS, POWER_ORDER } from '@/data/dizhi-relations'
import type { Relation } from '@/data/dizhi-relations'
import RelationWheel from '@/components/RelationWheel.vue'

const expanded = ref<string | null>(null)
function toggle(id: string) {
  expanded.value = expanded.value === id ? null : id
}
</script>

<template>
  <div class="page">
    <header class="hd">
      <h1>地支六大关系</h1>
      <p class="sub">六合 · 六冲 · 三合 · 三刑 · 三会 · 六害</p>
    </header>

    <!-- 圆图 -->
    <section class="block wheel-block">
      <h3>关系圆图</h3>
      <RelationWheel />
    </section>

    <!-- 力量排序 -->
    <section class="block">
      <h3>力量层级（强 → 弱）</h3>
      <p class="power">{{ POWER_ORDER }}</p>
      <p class="note">断命时力量大者优先看、应事明显。</p>
    </section>

    <!-- 6 类关系表 -->
    <section
      v-for="r in RELATIONS"
      :key="r.id"
      class="block rel-block"
    >
      <div class="rel-head" :style="{ borderLeftColor: r.color }" @click="toggle(r.id)">
        <div>
          <span class="rel-name">{{ r.name }}</span>
          <span class="rel-summary">{{ r.summary }}</span>
        </div>
        <span class="arrow" :class="{ open: expanded === r.id }">›</span>
      </div>

      <transition name="expand">
        <div v-if="expanded === r.id" class="rel-body">
          <dl>
            <dt>原理</dt><dd>{{ r.principle }}</dd>
            <dt>力量</dt><dd>{{ r.power }}</dd>
            <dt>成立条件</dt><dd>{{ r.condition }}</dd>
            <dt v-if="r.variants">变体</dt><dd v-if="r.variants">{{ r.variants }}</dd>
            <dt>喜忌</dt><dd>{{ r.xiji }}</dd>
            <dt>口诀</dt><dd class="kou">{{ r.koujue }}</dd>
          </dl>

          <h4>配对明细</h4>
          <div v-for="(p, i) in r.pairs" :key="i" class="pair">
            <div class="pair-head">
              <span class="pair-mem">{{ p.members.join(' + ') }}</span>
              <span v-if="p.result" class="pair-res">{{ r.id === 'liuhe' ? '化' : '成' }}{{ p.result }}</span>
            </div>
            <p class="pair-mean">{{ p.meaning }}</p>
            <div v-if="p.duanyu" class="pair-duan">
              <div v-if="p.duanyu.nian"><b>年月：</b>{{ p.duanyu.nian }}</div>
              <div v-if="p.duanyu.ri"><b>日支：</b>{{ p.duanyu.ri }}</div>
              <div v-if="p.duanyu.shi"><b>时支：</b>{{ p.duanyu.shi }}</div>
            </div>
          </div>
        </div>
      </transition>
    </section>

    <div style="height: 12px;"></div>
  </div>
</template>

<style scoped>
.page { padding: 16px; }
.hd { margin-bottom: 16px; }
h1 { font-size: 22px; font-weight: 700; }
.sub { font-size: 13px; color: var(--text-dim); margin-top: 4px; }

.block {
  background: var(--bg-card);
  border-radius: var(--r-md);
  padding: 16px;
  margin-bottom: 12px;
}
h3 { font-size: 13px; color: var(--text-dim); margin-bottom: 10px; font-weight: 600; }
.power { font-size: 14px; color: var(--accent); font-weight: 500; line-height: 1.6; }
.note { font-size: 12px; color: var(--text-dim); margin-top: 6px; }
.wheel-block { display: flex; flex-direction: column; align-items: stretch; }

.rel-head {
  display: flex; align-items: center; justify-content: space-between;
  border-left: 4px solid; padding-left: 12px;
  cursor: pointer;
}
.rel-name { font-size: 17px; font-weight: 600; margin-right: 8px; }
.rel-summary { font-size: 12px; color: var(--text-dim); }
.arrow { font-size: 20px; color: var(--text-dim); transition: transform 0.2s; }
.arrow.open { transform: rotate(90deg); }

.rel-body { padding-top: 14px; }
dl { display: grid; grid-template-columns: 64px 1fr; gap: 8px 12px; margin-bottom: 14px; }
dt { font-size: 12px; color: var(--text-dim); padding-top: 1px; }
dd { font-size: 13px; color: var(--text); line-height: 1.6; }
.kou { color: var(--accent); }

h4 { font-size: 13px; color: var(--text-dim); margin-bottom: 10px; }
.pair {
  padding: 10px; background: var(--bg-elev);
  border-radius: var(--r-sm); margin-bottom: 8px;
}
.pair-head { display: flex; align-items: center; gap: 8px; margin-bottom: 4px; }
.pair-mem { font-size: 15px; font-weight: 600; }
.pair-res { font-size: 11px; padding: 2px 7px; border-radius: var(--r-full); background: var(--accent); color: #fff; }
.pair-mean { font-size: 13px; color: var(--text-soft); line-height: 1.6; }
.pair-duan { margin-top: 6px; font-size: 12px; color: var(--text-dim); display: flex; flex-direction: column; gap: 3px; }
.pair-duan b { color: var(--text-soft); }

.expand-enter-active, .expand-leave-active { transition: all 0.25s ease; overflow: hidden; }
.expand-enter-from, .expand-leave-to { opacity: 0; max-height: 0; }
.expand-enter-to, .expand-leave-from { opacity: 1; max-height: 2000px; }
</style>
