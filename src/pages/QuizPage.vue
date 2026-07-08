<script setup lang="ts">
import { ref, computed } from 'vue'
import QuestionCard from '@/components/QuestionCard.vue'
import { getRandomQuestions, getQuestionCount, getRelationQuestions, getLunmingQuestions, type QuizScope, type RelationFilter, type LunmingFilter } from '@/composables/useQuiz'
import { useProgress } from '@/composables/useProgress'
import { useWrongBook } from '@/composables/useWrongBook'
import { RELATIONS } from '@/data/dizhi-relations'
import type { Question } from '@/data/types'

const { record } = useProgress()
const { markWrong } = useWrongBook()

const scope = ref<QuizScope>('all')
const scopeOptions: { v: QuizScope; label: string }[] = [
  { v: 'all', label: '全部' },
  { v: 'tiangan', label: '天干' },
  { v: 'dizhi', label: '地支' },
  { v: 'canggan', label: '藏干' },
  { v: 'relations', label: '关系' },
  { v: 'lunming', label: '论命' },
  { v: 'xingming', label: '姓名学' },
  { v: 'advanced', label: '进阶' },
]

// 关系子筛选
const relFilter = ref<RelationFilter>('all')
const relFilterOptions = [
  { v: 'all' as const, label: '全部' },
  ...RELATIONS.map((r) => ({ v: r.id as RelationFilter, label: r.shortName })),
]
// 论命子筛选
const lmFilter = ref<LunmingFilter>('all')
const lmFilterOptions = [
  { v: 'all' as const, label: '全部' },
  { v: 'geju' as const, label: '格局' },
  { v: 'yongshen' as const, label: '用神' },
]

const started = ref(false)
const queue = ref<Question[]>([])
const idx = ref(0)
const correctCount = ref(0)
const finished = ref(false)

const current = computed(() => queue.value[idx.value] ?? null)
const total = computed(() => queue.value.length)

function start() {
  let pool: Question[]
  if (scope.value === 'relations') {
    pool = getRelationQuestions(relFilter.value)
  } else if (scope.value === 'lunming') {
    pool = getLunmingQuestions(lmFilter.value)
  } else {
    pool = getRandomQuestions(scope.value, 10)
  }
  // 不足10则全取
  queue.value = pool.length > 10 ? pool.slice(0, 10) : pool
  // 打乱
  queue.value = [...queue.value].sort(() => Math.random() - 0.5)
  idx.value = 0
  correctCount.value = 0
  finished.value = false
  started.value = true
}

function onAnswered(ok: boolean) {
  if (current.value) {
    record(current.value.fieldLabel, ok)
    if (!ok) markWrong(current.value)
  }
  if (ok) correctCount.value++
}

function onNext() {
  if (idx.value < total.value - 1) {
    idx.value++
  } else {
    finished.value = true
  }
}

function onPrev() {
  if (idx.value > 0) idx.value--
}

function again() {
  started.value = false
  finished.value = false
}
</script>

<template>
  <div class="page">
    <!-- 起始选择 -->
    <div v-if="!started" class="setup">
      <h1>答题训练</h1>
      <p class="sub">每轮 10 题，答错附详细讲解</p>

      <div class="scope">
        <p class="lab">选择范围</p>
        <div class="opts">
          <button
            v-for="o in scopeOptions"
            :key="o.v"
            :class="{ on: scope === o.v }"
            @click="scope = o.v"
          ><span>{{ o.label }}</span><span class="cnt">{{
            o.v === 'relations' ? getRelationQuestions(relFilter).length
            : o.v === 'lunming' ? getLunmingQuestions(lmFilter).length
            : getQuestionCount(o.v)
          }}</span></button>
        </div>
        <!-- 关系子筛选 -->
        <div v-if="scope === 'relations'" class="sub-filter">
          <button
            v-for="o in relFilterOptions"
            :key="o.v"
            :class="{ on: relFilter === o.v }"
            @click="relFilter = o.v"
          >{{ o.label }}</button>
        </div>
        <!-- 论命子筛选 -->
        <div v-if="scope === 'lunming'" class="sub-filter">
          <button
            v-for="o in lmFilterOptions"
            :key="o.v"
            :class="{ on: lmFilter === o.v }"
            @click="lmFilter = o.v"
          >{{ o.label }}</button>
        </div>
      </div>

      <button class="go" @click="start">开始答题</button>
    </div>

    <!-- 答题中 -->
    <div v-else-if="!finished" class="play">
      <div class="prog">
        <div class="bar"><span :style="{ width: ((idx + 1) / total) * 100 + '%' }"></span></div>
        <div class="prog-row">
          <button class="nav-btn" :disabled="idx === 0" @click="onPrev">← 上一题</button>
          <span class="num">{{ idx + 1 }} / {{ total }}　✓ {{ correctCount }}</span>
          <button class="nav-btn" :disabled="idx === total - 1" @click="onNext">下一题 →</button>
        </div>
      </div>
      <QuestionCard
        v-if="current"
        :question="current"
        :correct-auto-ms="2200"
        :wrong-auto-ms="0"
        next-label="看完讲解，下一题 →"
        @answered="onAnswered"
        @next="onNext"
      />
    </div>

    <!-- 结算 -->
    <div v-else class="done">
      <div class="score">{{ correctCount }} / {{ total }}</div>
      <p class="verdict">
        {{ correctCount === total ? '💯 全对！地基已稳' :
           correctCount >= total * 0.8 ? '👍 不错，再练几轮' :
           correctCount >= total * 0.6 ? '💪 及格，继续巩固' :
           '📖 多翻学习模式，回头再战' }}
      </p>
      <div class="btns">
        <button class="go" @click="start">再来一轮</button>
        <button class="ghost" @click="again">换范围</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page { padding: 16px; min-height: 100%; }
h1 { font-size: 22px; font-weight: 700; }
.sub { font-size: 13px; color: var(--text-dim); margin-top: 4px; }

.setup { display: flex; flex-direction: column; gap: 24px; padding-top: 20px; }
.scope .lab { font-size: 13px; color: var(--text-dim); margin-bottom: 10px; }
.opts { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
.opts button {
  padding: 14px;
  border-radius: var(--r-md);
  background: var(--bg-card);
  border: 1.5px solid var(--border-soft);
  font-size: 15px;
  color: var(--text-soft);
  display: flex; flex-direction: column; align-items: center; gap: 2px;
}
.opts button.on { border-color: var(--accent); color: var(--accent); }
.cnt { font-size: 11px; color: var(--text-dim); }

.sub-filter { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 10px; }
.sub-filter button {
  padding: 6px 11px;
  border-radius: var(--r-full);
  background: var(--bg-elev);
  border: 1px solid var(--border-soft);
  font-size: 12px;
  color: var(--text-soft);
}
.sub-filter button.on { background: var(--accent); color: #fff; border-color: var(--accent); }

.go {
  width: 100%;
  padding: 16px;
  background: var(--accent);
  color: #fff;
  border-radius: var(--r-md);
  font-size: 17px;
  font-weight: 600;
}
.go:active { transform: scale(0.98); }

.play { display: flex; flex-direction: column; gap: 16px; }
.prog { display: flex; flex-direction: column; gap: 8px; }
.bar { height: 4px; background: var(--bg-card); border-radius: 2px; overflow: hidden; }
.bar span { display: block; height: 100%; background: var(--accent); transition: width 0.3s; }
.prog-row { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
.num { font-size: 12px; color: var(--text-dim); }
.nav-btn {
  padding: 7px 12px;
  border-radius: var(--r-full);
  background: var(--bg-card);
  border: 1px solid var(--border-soft);
  font-size: 12px;
  color: var(--text-soft);
}
.nav-btn:active:not(:disabled) { transform: scale(0.96); }
.nav-btn:disabled { opacity: 0.35; }

.done { display: flex; flex-direction: column; align-items: center; gap: 14px; padding-top: 60px; }
.score { font-size: 56px; font-weight: 700; color: var(--accent); }
.verdict { font-size: 15px; color: var(--text-soft); text-align: center; }
.btns { display: flex; flex-direction: column; gap: 10px; width: 100%; margin-top: 16px; }
.ghost {
  width: 100%; padding: 14px;
  background: var(--bg-card);
  color: var(--text-soft);
  border-radius: var(--r-md);
  font-size: 15px;
  border: 1px solid var(--border-soft);
}
</style>
