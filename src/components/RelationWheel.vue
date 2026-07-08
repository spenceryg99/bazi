<script setup lang="ts">
import { ref, computed } from 'vue'
import { RELATIONS } from '@/data/dizhi-relations'
import type { RelationId } from '@/data/dizhi-relations'

// 12地支圆图顺序（顺时针，子上方）
const BRANCHES = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥']

const size = 320
const cx = size / 2
const cy = size / 2
const rBranch = 130   // 地支所在半径
const showRelations = ref<Set<RelationId>>(new Set(RELATIONS.map((r) => r.id)))
const highlight = ref<string | null>(null)

function pos(branch: string) {
  const idx = BRANCHES.indexOf(branch)
  const angle = (idx * 30 - 90) * (Math.PI / 180)
  return { x: cx + rBranch * Math.cos(angle), y: cy + rBranch * Math.sin(angle) }
}

interface Line {
  id: string
  relation: RelationId
  color: string
  name: string
  x1: number; y1: number; x2: number; y2: number
  members: string[]
  curved?: boolean
}

const lines = computed<Line[]>(() => {
  const out: Line[] = []
  for (const r of RELATIONS) {
    if (!showRelations.value.has(r.id)) continue
    for (const p of r.pairs) {
      // 自刑（4字）画三个自环，跳过
      if (p.members.length >= 4) {
        for (const m of p.members) {
          const pt = pos(m)
          out.push({
            id: `${r.id}-self-${m}`, relation: r.id, color: r.color, name: r.name,
            x1: pt.x, y1: pt.y, x2: pt.x, y2: pt.y, members: [m], curved: true,
          })
        }
        continue
      }
      if (p.members.length < 2) continue
      const pts = p.members.map(pos)
      // 两支：直线；三支：折线三角形（用 path）
      if (pts.length === 2) {
        out.push({
          id: `${r.id}-${p.members.join('')}`, relation: r.id, color: r.color, name: r.name,
          x1: pts[0].x, y1: pts[0].y, x2: pts[1].x, y2: pts[1].y, members: p.members,
        })
      } else {
        // 三支合成一条折线，首尾连
        for (let i = 0; i < pts.length; i++) {
          const a = pts[i], b = pts[(i + 1) % pts.length]
          out.push({
            id: `${r.id}-${p.members.join('')}-${i}`, relation: r.id, color: r.color, name: r.name,
            x1: a.x, y1: a.y, x2: b.x, y2: b.y, members: p.members,
          })
        }
      }
    }
  }
  return out
})

function toggleRelation(id: RelationId) {
  if (showRelations.value.has(id)) showRelations.value.delete(id)
  else showRelations.value.add(id)
  // 触发响应
  showRelations.value = new Set(showRelations.value)
}

function lineActive(line: Line) {
  if (!highlight.value) return true
  return line.members.includes(highlight.value)
}

function branchActive(b: string) {
  const h = highlight.value
  if (!h) return true
  // 高亮该支参与的所有关系涉及的支
  return lines.value.some((l) => l.members.includes(h) && l.members.includes(b)) || b === h
}
</script>

<template>
  <div class="wheel-wrap">
    <svg :viewBox="`0 0 ${size} ${size}`" class="wheel">
      <!-- 关系连线 -->
      <g class="lines">
        <template v-for="l in lines" :key="l.id">
          <circle
            v-if="l.curved"
            :cx="l.x1" :cy="l.y1 - 8" r="8" fill="none"
            :stroke="l.color" stroke-width="2" opacity="0.7"
            :class="{ dim: highlight && !lineActive(l) }"
          />
          <line
            v-else
            :x1="l.x1" :y1="l.y1" :x2="l.x2" :y2="l.y2"
            :stroke="l.color" stroke-width="2" stroke-linecap="round"
            opacity="0.55"
            :class="{ dim: highlight && !lineActive(l), pop: highlight && lineActive(l) }"
          />
        </template>
      </g>

      <!-- 12地支节点 -->
      <g class="nodes">
        <g
          v-for="b in BRANCHES"
          :key="b"
          :transform="`translate(${pos(b).x},${pos(b).y})`"
          @click="highlight = highlight === b ? null : b"
          :class="{ dim: highlight && !branchActive(b), hot: highlight === b }"
        >
          <circle r="20" fill="var(--bg-card)" stroke="var(--border)" stroke-width="1.5" />
          <text text-anchor="middle" dy="6" font-size="18" font-weight="600" fill="var(--text)">{{ b }}</text>
        </g>
      </g>
    </svg>

    <!-- 图例 -->
    <div class="legend">
      <button
        v-for="r in RELATIONS"
        :key="r.id"
        class="leg"
        :class="{ off: !showRelations.has(r.id) }"
        :style="{ '--c': r.color }"
        @click="toggleRelation(r.id)"
      >
        <span class="dot"></span>{{ r.name }}
      </button>
    </div>
    <p class="hint">点地支字看它的所有关系 · 点图例开关某类关系</p>
  </div>
</template>

<style scoped>
.wheel-wrap { display: flex; flex-direction: column; align-items: center; gap: 12px; }
.wheel { width: 100%; max-width: 340px; height: auto; }
.lines line, .lines circle { transition: opacity 0.2s; }
.dim { opacity: 0.12 !important; }
.pop { opacity: 1 !important; stroke-width: 3.5; }
.nodes g { cursor: pointer; transition: opacity 0.2s; }
.nodes g.dim { opacity: 0.25; }
.nodes g.hot circle { stroke: var(--accent); stroke-width: 2.5; }

.legend { display: flex; flex-wrap: wrap; gap: 6px; justify-content: center; }
.leg {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 5px 10px; border-radius: var(--r-full);
  background: var(--bg-card); border: 1px solid var(--border-soft);
  font-size: 12px; color: var(--text-soft);
}
.leg.off { opacity: 0.4; }
.dot { width: 8px; height: 8px; border-radius: 50%; background: var(--c); }
.hint { font-size: 11px; color: var(--text-dim); text-align: center; }
</style>
