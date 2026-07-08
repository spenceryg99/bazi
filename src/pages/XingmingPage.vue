<script setup lang="ts">
import { ref, computed } from 'vue'
import {
  WU_GE, SHULI_81, SANCAI_CONFIGS, CONTROVERSY, RELATION_TO_BAZI,
  strokeToWuxing, getShuli,
} from '@/data/xingming'

// ===== 五格计算器 =====
const surnameStroke = ref(11)   // 默认张=11
const ming1Stroke = ref(3)      // 三=3
const ming2Stroke = ref(0)      // 单字名=0

const calc = computed(() => {
  const s = surnameStroke.value
  const m1 = ming1Stroke.value
  const m2 = ming2Stroke.value
  const hasM2 = m2 > 0

  const tianGe = s + 1
  const renGe = s + m1
  const diGe = hasM2 ? m1 + m2 : m1 + 1
  const zongGe = s + m1 + (hasM2 ? m2 : 0)
  const waiGe = zongGe - renGe + 1

  const grids = [
    { name: '天格', num: tianGe, ...buildGrid(tianGe) },
    { name: '人格', num: renGe, ...buildGrid(renGe) },
    { name: '地格', num: diGe, ...buildGrid(diGe) },
    { name: '外格', num: waiGe, ...buildGrid(waiGe) },
    { name: '总格', num: zongGe, ...buildGrid(zongGe) },
  ]

  // 三才：天/人/地 五行
  const sancai = `${strokeToWuxing(tianGe)}→${strokeToWuxing(renGe)}→${strokeToWuxing(diGe)}`
  const sancaiMatch = matchSancai(strokeToWuxing(tianGe), strokeToWuxing(renGe), strokeToWuxing(diGe))

  return { grids, sancai, sancaiLuck: sancaiMatch }
})

function buildGrid(num: number) {
  const s = getShuli(num)
  return { wx: strokeToWuxing(num), luck: s.luck, keyword: s.keyword, meaning: s.meaning }
}

function matchSancai(a: string, b: string, c: string): string {
  // 查配置表
  const pat = `${a}→${b}→${c}`
  const found = SANCAI_CONFIGS.find((x) => x.pattern === pat)
  if (found) return found.luck
  // 简单判断：五行相同为吉（比和），相生为吉，否则中性/凶
  const SHENG: Record<string,string> = { 木:'火',火:'土',土:'金',金:'水',水:'木' }
  const KE: Record<string,string> = { 木:'土',土:'水',水:'火',火:'金',金:'木' }
  const r1 = a === b ? '比' : SHENG[a] === b ? '生' : KE[a] === b ? '克' : ''
  const r2 = b === c ? '比' : SHENG[b] === c ? '生' : KE[b] === c ? '克' : ''
  if (r1 === '克' && r2 === '克') return '凶'
  if (r1 === '生' && r2 === '生') return '吉'
  return '半吉'
}

function luckColor(l: string) {
  return l === '吉' ? 'g' : l === '凶' ? 'x' : 'b'
}
</script>

<template>
  <div class="page">
    <header class="hd">
      <h1>姓名学 · 五格剖象法</h1>
      <p class="sub">熊崎式姓名数理 · 注意：≠ 八字命理</p>
    </header>

    <!-- 置顶提示 -->
    <div class="warn">
      ⚠️ <b>姓名学 ≠ 八字命理</b>。五格剖象法是日本熊崎健翁 1928 年发明的<b>姓名数理体系</b>，看的是"名字笔画吉凶"；八字看的是"出生时间"。两者是平行系统，正统命理界对五格评价有争议（详见底部）。
    </div>

    <!-- 五格定义 -->
    <section class="block">
      <h3>五格定义</h3>
      <div v-for="g in WU_GE" :key="g.name" class="ge-def">
        <div class="ge-name">{{ g.name }}<span class="ge-yun">{{ g.yun }}</span></div>
        <p class="ge-mean">{{ g.meaning }}</p>
        <p class="ge-algo"><b>算法：</b>{{ g.algorithm }}</p>
      </div>
    </section>

    <!-- 五格计算器 -->
    <section class="block calc-block">
      <h3>🧮 五格计算器</h3>
      <p class="hint">输入康熙繁体笔画（单字名第二字填0）</p>
      <div class="calc-input">
        <label>姓笔画<input type="number" v-model.number="surnameStroke" min="1" max="30" /></label>
        <label>名第1字<input type="number" v-model.number="ming1Stroke" min="1" max="30" /></label>
        <label>名第2字<input type="number" v-model.number="ming2Stroke" min="0" max="30" /></label>
      </div>

      <div class="calc-result">
        <div v-for="g in calc.grids" :key="g.name" class="calc-grid" :class="`wx-${g.wx}`">
          <div class="cg-name">{{ g.name }}</div>
          <div class="cg-num">{{ g.num }}</div>
          <div class="cg-wx">五行 {{ g.wx }}</div>
          <div class="cg-luck" :class="luckColor(g.luck)">{{ g.luck }}</div>
          <div class="cg-key">{{ g.keyword }}</div>
        </div>
      </div>
      <div class="sancai">
        <b>三才配置：</b>{{ calc.sancai }}
        <span class="cg-luck" :class="luckColor(calc.sancaiLuck)">{{ calc.sancaiLuck }}</span>
      </div>
      <p class="hint">注：康熙繁体笔画为准，如「张」11画（弓7+长4 繁体）、「氵」算4画（水）。</p>
    </section>

    <!-- 81数理表 -->
    <section class="block">
      <h3>81 数理吉凶表</h3>
      <div class="shuli-list">
        <div v-for="s in SHULI_81" :key="s.num" class="shuli-item" :class="luckColor(s.luck)">
          <div class="sl-num">{{ s.num }}</div>
          <div class="sl-body">
            <div class="sl-head"><span class="sl-key">{{ s.keyword }}</span><span class="sl-luck">{{ s.luck }}</span></div>
            <div class="sl-mean">{{ s.meaning }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- 三才配置 -->
    <section class="block">
      <h3>三才配置（天/人/地五行组合）</h3>
      <div v-for="c in SANCAI_CONFIGS" :key="c.pattern" class="sc-item" :class="luckColor(c.luck)">
        <span class="sc-pat">{{ c.pattern }}</span>
        <span class="cg-luck" :class="luckColor(c.luck)">{{ c.luck }}</span>
        <p class="sc-mean">{{ c.meaning }}</p>
      </div>
    </section>

    <!-- 与八字的关系 -->
    <section class="block">
      <h3>与八字的关系</h3>
      <p class="relation">{{ RELATION_TO_BAZI }}</p>
    </section>

    <!-- 争议 -->
    <section class="block warn-block">
      <h3>⚠️ 争议与边界</h3>
      <ul class="controversy">
        <li v-for="(c, i) in CONTROVERSY" :key="i">{{ c }}</li>
      </ul>
    </section>

    <div style="height: 12px;"></div>
  </div>
</template>

<style scoped>
.page { padding: 16px; }
.hd { margin-bottom: 12px; }
h1 { font-size: 22px; font-weight: 700; }
.sub { font-size: 13px; color: var(--text-dim); margin-top: 4px; }

.warn {
  background: rgba(224,86,75,0.12);
  border: 1px solid rgba(224,86,75,0.3);
  border-radius: var(--r-md);
  padding: 12px 14px;
  font-size: 12px; line-height: 1.6;
  color: var(--text-soft);
  margin-bottom: 14px;
}
.warn b { color: var(--wrong); }

.block { background: var(--bg-card); border-radius: var(--r-md); padding: 16px; margin-bottom: 12px; }
h3 { font-size: 13px; color: var(--text-dim); margin-bottom: 12px; font-weight: 600; }
.hint { font-size: 11px; color: var(--text-dim); margin: 6px 0; }

.ge-def { padding: 10px; background: var(--bg-elev); border-radius: var(--r-sm); margin-bottom: 8px; }
.ge-name { font-size: 15px; font-weight: 600; }
.ge-yun { font-size: 11px; color: var(--accent); margin-left: 8px; padding: 1px 6px; border-radius: var(--r-full); background: var(--bg-card); }
.ge-mean { font-size: 12px; color: var(--text-soft); margin-top: 4px; line-height: 1.5; }
.ge-algo { font-size: 12px; color: var(--text-dim); margin-top: 4px; }
.ge-algo b { color: var(--text); }

.calc-input { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 8px; margin-bottom: 12px; }
.calc-input label { display: flex; flex-direction: column; gap: 4px; font-size: 11px; color: var(--text-dim); }
.calc-input input {
  background: var(--bg-elev); border: 1px solid var(--border-soft); border-radius: var(--r-sm);
  padding: 8px; color: var(--text); font-size: 16px; font-weight: 600; text-align: center;
}

.calc-result { display: grid; grid-template-columns: repeat(5, 1fr); gap: 6px; margin-bottom: 10px; }
.calc-grid { background: var(--bg-elev); border-radius: var(--r-sm); padding: 8px 4px; text-align: center; border-top: 3px solid; }
.calc-grid.wx-木 { border-top-color: var(--wx-mu); }
.calc-grid.wx-火 { border-top-color: var(--wx-huo); }
.calc-grid.wx-土 { border-top-color: var(--wx-tu); }
.calc-grid.wx-金 { border-top-color: var(--wx-jin); }
.calc-grid.wx-水 { border-top-color: var(--wx-shui); }
.cg-name { font-size: 11px; color: var(--text-dim); }
.cg-num { font-size: 20px; font-weight: 700; margin: 2px 0; }
.cg-wx { font-size: 10px; color: var(--text-soft); }
.cg-luck { font-size: 11px; font-weight: 600; margin-top: 2px; }
.cg-luck.g { color: var(--correct); }
.cg-luck.x { color: var(--wrong); }
.cg-luck.b { color: var(--wx-tu); }
.cg-key { font-size: 10px; color: var(--text-dim); margin-top: 2px; }

.sancai { font-size: 13px; color: var(--text); padding: 10px; background: var(--bg-elev); border-radius: var(--r-sm); }
.sancai b { color: var(--text); }

.shuli-list { display: flex; flex-direction: column; gap: 5px; max-height: 480px; overflow-y: auto; }
.shuli-item { display: flex; gap: 10px; padding: 7px 9px; background: var(--bg-elev); border-radius: var(--r-sm); border-left: 3px solid; }
.shuli-item.g { border-left-color: var(--correct); }
.shuli-item.x { border-left-color: var(--wrong); }
.shuli-item.b { border-left-color: var(--wx-tu); }
.sl-num { font-size: 16px; font-weight: 700; width: 28px; flex-shrink: 0; color: var(--text); }
.sl-body { flex: 1; }
.sl-head { display: flex; justify-content: space-between; align-items: center; }
.sl-key { font-size: 12px; font-weight: 600; color: var(--text); }
.sl-luck { font-size: 10px; padding: 1px 6px; border-radius: var(--r-full); }
.sl-luck.g, .shuli-item.g .sl-luck { background: rgba(63,166,106,0.2); color: var(--correct); }
.sl-mean { font-size: 11px; color: var(--text-dim); margin-top: 2px; line-height: 1.4; }

.sc-item { padding: 9px; background: var(--bg-elev); border-radius: var(--r-sm); margin-bottom: 6px; border-left: 3px solid; }
.sc-item.g { border-left-color: var(--correct); }
.sc-item.x { border-left-color: var(--wrong); }
.sc-item.b { border-left-color: var(--wx-tu); }
.sc-pat { font-size: 14px; font-weight: 600; }
.sc-item .cg-luck { display: inline-block; margin-left: 8px; }
.sc-mean { font-size: 11px; color: var(--text-dim); margin-top: 3px; line-height: 1.5; }

.relation { font-size: 13px; color: var(--text-soft); line-height: 1.7; }

.warn-block { border: 1px solid rgba(224,86,75,0.2); }
.controversy { padding-left: 18px; display: flex; flex-direction: column; gap: 6px; }
.controversy li { font-size: 12px; color: var(--text-soft); line-height: 1.6; }
</style>
