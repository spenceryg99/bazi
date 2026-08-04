<script setup lang="ts">
import { ref } from 'vue'
import { SCHOOLS, COMPARE_POINTS, MODERN_FUSION, LEARNING_PATH, CLASSIC_CASES, CLASSICS, TIAOHOU_TABLE } from '@/data/lunming'
import { ZHENG_GE, WAI_GE } from '@/data/geju'
import type { Geju } from '@/data/geju'

const activeCase = ref(0)
const expandedGe = ref<string | null>(null)
</script>

<template>
  <div class="page">
    <header class="hd">
      <h1>子平论命流程</h1>
      <p class="sub">格局派 · 旺衰派 · 调候派 · 三书合参</p>
    </header>

    <!-- 子平三书 -->
    <section class="block">
      <h3>📕 子平三书</h3>
      <div class="classics">
        <div v-for="c in CLASSICS" :key="c.title" class="classic-card">
          <div class="cl-title">{{ c.title }}</div>
          <div class="cl-author">{{ c.author }}</div>
          <div class="cl-school">{{ c.school }}</div>
          <p class="cl-core">{{ c.core }}</p>
          <div class="cl-role">「{{ c.role }}」</div>
        </div>
      </div>
    </section>

    <!-- 三派核心思想对比 -->
    <section class="schools">
      <div v-for="s in SCHOOLS" :key="s.id" class="school-card" :style="{ '--c': s.color }">
        <h2>{{ s.name }}</h2>
        <p class="core">{{ s.core }}</p>
        <div class="meta">
          <span>📕 {{ s.classics }}</span>
        </div>
        <div class="meta-row">
          <b>用神：</b><span>{{ s.yongshenLogic }}</span>
        </div>
      </div>
    </section>

    <!-- 流程对比 -->
    <section class="block">
      <h3>六步流程对比（三派）</h3>
      <div class="flow-compare">
        <div v-for="s in SCHOOLS" :key="s.id" class="flow-col" :style="{ '--c': s.color }">
          <div class="flow-head">{{ s.shortName }}派</div>
          <div v-for="step in s.steps" :key="step.order" class="flow-step">
            <div class="step-num" :style="{ background: s.color }">{{ step.order }}</div>
            <div class="step-body">
              <div class="step-title">{{ step.title }}</div>
              <div class="step-detail">{{ step.detail }}</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 差异点 -->
    <section class="block">
      <h3>三派差异</h3>
      <div class="compare-tbl">
        <div class="cmp-row cmp-head">
          <span>维度</span><span>格局派</span><span>旺衰派</span><span>调候派</span>
        </div>
        <div v-for="(c, i) in COMPARE_POINTS" :key="i" class="cmp-row">
          <span class="cmp-aspect">{{ c.aspect }}</span>
          <span class="cmp-geju">{{ c.geju }}</span>
          <span class="cmp-ws">{{ c.wangshuai }}</span>
          <span class="cmp-th">{{ c.tiaohou }}</span>
        </div>
      </div>
    </section>

    <!-- 调候用神速查 -->
    <section class="block">
      <h3>🌡️ 调候用神速查（《穷通宝鉴》节选）</h3>
      <p class="hint">按日主×季节查调候喜用，寒暖失衡时优先查此表</p>
      <div class="th-list">
        <div v-for="(t, i) in TIAOHOU_TABLE" :key="i" class="th-item">
          <div class="th-head">
            <span class="th-dm">{{ t.dm }}</span>
            <span class="th-season">{{ t.season }}</span>
          </div>
          <div class="th-use"><b>首用：</b>{{ t.first }}　<b>次用：</b>{{ t.second }}</div>
          <p class="th-note">{{ t.note }}</p>
        </div>
      </div>
    </section>

    <!-- 经典案例 -->
    <section class="block">
      <h3>经典案例 · 两派分别取用</h3>
      <div class="case-tabs">
        <button
          v-for="(c, i) in CLASSIC_CASES"
          :key="c.id"
          :class="{ on: activeCase === i }"
          @click="activeCase = i"
        >{{ c.title }}</button>
      </div>
      <div v-if="CLASSIC_CASES[activeCase]" class="case-body">
        <div class="case-bazi">{{ CLASSIC_CASES[activeCase].bazi }}</div>
        <p class="case-ana">{{ CLASSIC_CASES[activeCase].analysis }}</p>
        <div class="case-school g">
          <h4 :style="{ color: SCHOOLS[0].color }">格局派</h4>
          <p><b>格局：</b>{{ CLASSIC_CASES[activeCase].gejuSchool.geju }}</p>
          <p><b>用神：</b>{{ CLASSIC_CASES[activeCase].gejuSchool.yongshen }}</p>
          <p class="reason">{{ CLASSIC_CASES[activeCase].gejuSchool.reason }}</p>
        </div>
        <div class="case-school w">
          <h4 :style="{ color: SCHOOLS[1].color }">旺衰派</h4>
          <p><b>旺衰：</b>{{ CLASSIC_CASES[activeCase].wangshuaiSchool.strength }}</p>
          <p><b>用神：</b>{{ CLASSIC_CASES[activeCase].wangshuaiSchool.yongshen }}</p>
          <p class="reason">{{ CLASSIC_CASES[activeCase].wangshuaiSchool.reason }}</p>
        </div>
        <div class="case-cmp">
          <b>差异：</b>{{ CLASSIC_CASES[activeCase].compare }}
        </div>
      </div>
    </section>

    <!-- 现代融合 -->
    <section class="block">
      <h3>现代融合做法</h3>
      <ol class="fusion">
        <li v-for="(f, i) in MODERN_FUSION" :key="i">{{ f }}</li>
      </ol>
    </section>

    <!-- 学习路径 -->
    <section class="block">
      <h3>学习路径建议</h3>
      <div class="path">
        <div v-for="(p, i) in LEARNING_PATH" :key="i" class="path-step">
          <span class="path-idx">{{ i + 1 }}</span>
          <div>
            <b>{{ p.phase }}</b>
            <p>{{ p.content }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 八正格速查 -->
    <section class="block">
      <h3>八正格速查（点格名看详情）</h3>
      <div class="ge-list">
        <div v-for="g in [...ZHENG_GE, ...WAI_GE]" :key="g.name" class="ge-item" :style="{ '--c': g.category === '正格' ? '#b85cd1' : '#3b7dd8' }">
          <div class="ge-head" @click="expandedGe = expandedGe === g.name ? null : g.name">
            <span class="ge-name">{{ g.name }}</span>
            <span class="ge-cat">{{ g.category }}</span>
            <span class="ge-arrow" :class="{ open: expandedGe === g.name }">›</span>
          </div>
          <transition name="expand">
            <div v-if="expandedGe === g.name" class="ge-body">
              <p><b>取格：</b>{{ g.monthlyRule }}</p>
              <p><b>成格：</b>{{ g.chengGe }}</p>
              <p><b>破格：</b>{{ g.poGe }}</p>
              <p><b>相神：</b>{{ g.xiangShen }}</p>
              <p><b>含义：</b>{{ g.meaning }}</p>
            </div>
          </transition>
        </div>
      </div>
    </section>

    <div style="height: 12px;"></div>
  </div>
</template>

<style scoped>
.page { padding: 16px; }
.hd { margin-bottom: 16px; }
h1 { font-size: 22px; font-weight: 700; }
.sub { font-size: 13px; color: var(--text-dim); margin-top: 4px; }

.schools { display: flex; flex-direction: column; gap: 10px; margin-bottom: 14px; }
.school-card {
  background: var(--bg-card); border-radius: var(--r-md);
  padding: 14px 16px; border-left: 4px solid var(--c);
}
.school-card h2 { font-size: 16px; color: var(--c); margin-bottom: 6px; }
.core { font-size: 13px; color: var(--text-soft); line-height: 1.6; margin-bottom: 8px; }
.meta { font-size: 12px; color: var(--text-dim); margin-bottom: 6px; }
.meta-row { font-size: 12px; color: var(--text-soft); line-height: 1.6; }
.meta-row b { color: var(--text); }

.block { background: var(--bg-card); border-radius: var(--r-md); padding: 16px; margin-bottom: 12px; }
h3 { font-size: 13px; color: var(--text-dim); margin-bottom: 12px; font-weight: 600; }

.flow-compare { display: grid; grid-template-columns: repeat(3, 1fr); gap: 6px; }
.flow-col { display: flex; flex-direction: column; gap: 6px; }
.flow-head { text-align: center; font-size: 13px; font-weight: 600; color: var(--c); padding: 4px 0; border-bottom: 1px solid var(--c); margin-bottom: 4px; }
.flow-step { display: flex; gap: 6px; }
.step-num { width: 18px; height: 18px; border-radius: 50%; color: #fff; font-size: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-top: 2px; }
.step-title { font-size: 12px; font-weight: 600; }
.step-detail { font-size: 10px; color: var(--text-dim); line-height: 1.4; margin-top: 2px; }

.compare-tbl { display: flex; flex-direction: column; gap: 4px; }
.cmp-row { display: grid; grid-template-columns: 52px 1fr 1fr 1fr; gap: 5px; padding: 6px; font-size: 11px; background: var(--bg-elev); border-radius: 6px; }
.cmp-head { background: transparent; font-weight: 600; color: var(--text-dim); font-size: 10px; }
.cmp-aspect { color: var(--text); font-weight: 600; }
.cmp-geju { color: #b85cd1; }
.cmp-ws { color: #3fa66a; }
.cmp-th { color: #3b7dd8; }

.classics { display: flex; flex-direction: column; gap: 8px; }
.classic-card { padding: 12px; background: var(--bg-elev); border-radius: var(--r-sm); border-left: 3px solid var(--accent); }
.cl-title { font-size: 15px; font-weight: 700; color: var(--accent); }
.cl-author { font-size: 11px; color: var(--text-dim); margin-top: 2px; }
.cl-school { display: inline-block; font-size: 10px; padding: 1px 7px; border-radius: var(--r-full); background: var(--bg-card); color: var(--text-soft); margin-top: 4px; }
.cl-core { font-size: 12px; color: var(--text-soft); line-height: 1.5; margin-top: 6px; }
.cl-role { font-size: 13px; font-weight: 600; color: var(--wx-tu); margin-top: 4px; }

.th-list { display: flex; flex-direction: column; gap: 6px; }
.th-item { padding: 9px 11px; background: var(--bg-elev); border-radius: var(--r-sm); border-left: 3px solid #3b7dd8; }
.th-head { display: flex; gap: 8px; align-items: baseline; }
.th-dm { font-size: 13px; font-weight: 600; }
.th-season { font-size: 11px; color: var(--text-dim); }
.th-use { font-size: 12px; color: var(--text); margin-top: 3px; }
.th-use b { color: var(--text-soft); }
.th-note { font-size: 11px; color: var(--text-dim); margin-top: 3px; line-height: 1.4; }

.case-tabs { display: flex; gap: 6px; margin-bottom: 12px; flex-wrap: wrap; }
.case-tabs button { padding: 6px 11px; border-radius: var(--r-full); background: var(--bg-elev); border: 1px solid var(--border-soft); font-size: 12px; color: var(--text-soft); }
.case-tabs button.on { background: var(--accent); color: #fff; border-color: var(--accent); }
.case-body { display: flex; flex-direction: column; gap: 10px; }
.case-bazi { font-size: 18px; font-weight: 700; text-align: center; padding: 10px; background: var(--bg-elev); border-radius: var(--r-sm); letter-spacing: 2px; }
.case-ana { font-size: 12px; color: var(--text-soft); line-height: 1.6; }
.case-school { padding: 10px; border-radius: var(--r-sm); background: var(--bg-elev); border-left: 3px solid; }
.case-school.g { border-color: #b85cd1; }
.case-school.w { border-color: #3fa66a; }
.case-school h4 { font-size: 13px; margin-bottom: 6px; }
.case-school p { font-size: 12px; color: var(--text-soft); line-height: 1.6; }
.reason { color: var(--text-dim); font-style: italic; margin-top: 4px; }
.case-cmp { font-size: 12px; color: var(--text); padding: 8px 10px; background: rgba(184,141,255,0.1); border-radius: var(--r-sm); line-height: 1.6; }

.fusion { padding-left: 20px; display: flex; flex-direction: column; gap: 6px; }
.fusion li { font-size: 13px; color: var(--text-soft); line-height: 1.6; }

.path { display: flex; flex-direction: column; gap: 10px; }
.path-step { display: flex; gap: 10px; align-items: flex-start; }
.path-idx { width: 22px; height: 22px; border-radius: 50%; background: var(--accent); color: #fff; font-size: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.path-step b { font-size: 13px; color: var(--text); }
.path-step p { font-size: 12px; color: var(--text-dim); margin-top: 2px; }

.ge-list { display: flex; flex-direction: column; gap: 6px; }
.ge-item { background: var(--bg-elev); border-radius: var(--r-sm); border-left: 3px solid var(--c); overflow: hidden; }
.ge-head { display: flex; align-items: center; gap: 8px; padding: 10px 12px; cursor: pointer; }
.ge-name { font-size: 14px; font-weight: 600; }
.ge-cat { font-size: 10px; padding: 1px 6px; border-radius: var(--r-full); background: var(--c); color: #fff; }
.ge-arrow { margin-left: auto; color: var(--text-dim); transition: transform 0.2s; }
.ge-arrow.open { transform: rotate(90deg); }
.ge-body { padding: 0 12px 12px; }
.ge-body p { font-size: 12px; color: var(--text-soft); line-height: 1.6; margin-bottom: 4px; }
.ge-body b { color: var(--text); }

.expand-enter-active, .expand-leave-active { transition: all 0.25s; overflow: hidden; }
.expand-enter-from, .expand-leave-to { opacity: 0; max-height: 0; }
.expand-enter-to, .expand-leave-from { opacity: 1; max-height: 600px; }
</style>
