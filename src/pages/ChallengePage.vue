<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'
import QuestionCard from '@/components/QuestionCard.vue'
import { getQuestionCount, shuffle, type QuizScope } from '@/composables/useQuiz'
import { useProgress } from '@/composables/useProgress'
import { useWrongBook } from '@/composables/useWrongBook'
import { TIANGAN } from '@/data/tiangan'
import { DIZHI } from '@/data/dizhi'
import { getQuestionPool } from '@/composables/useQuiz'
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

const DURATION = 60
const started = ref(false)
const finished = ref(false)
const timeLeft = ref(DURATION)
const score = ref(0)
const streak = ref(0)
const maxStreak = ref(0)
const answered = ref(0)
const current = ref<Question | null>(null)
let timer: number | undefined

function pickNext() {
  const pool = getQuestionPool(scope.value)
  if (!pool.length) return
  current.value = shuffle(pool)[0]
}

function start() {
  started.value = true
  finished.value = false
  timeLeft.value = DURATION
  score.value = 0
  streak.value = 0
  maxStreak.value = 0
  answered.value = 0
  pickNext()
  timer = window.setInterval(() => {
    timeLeft.value--
    if (timeLeft.value <= 0) end()
  }, 1000)
}

function end() {
  if (timer) clearInterval(timer)
  finished.value = true
  current.value = null
}

function onAnswered(ok: boolean) {
  if (current.value) {
    record(current.value.fieldLabel, ok)
    if (!ok) markWrong(current.value)
  }
  answered.value++
  if (ok) {
    streak.value++
    maxStreak.value = Math.max(maxStreak.value, streak.value)
    score.value += 10 + Math.min(streak.value - 1, 5) * 2 // 连击加分
  } else {
    streak.value = 0
  }
}

function onNext() {
  if (timeLeft.value > 0) pickNext()
}

function backToSetup() {
  started.value = false
  finished.value = false
}

onUnmounted(() => { if (timer) clearInterval(timer) })
</script>

<template>
  <div class="page">
    <!-- 起始 -->
    <div v-if="!started" class="setup">
      <h1>⚡ 60秒挑战</h1>
      <p class="sub">限时 60 秒，连击加倍，看你能答多少</p>

      <div class="scope">
        <div class="opts">
          <button
            v-for="o in scopeOptions"
            :key="o.v"
            :class="{ on: scope === o.v }"
            @click="scope = o.v"
          >{{ o.label }}</button>
        </div>
      </div>
      <button class="go" @click="start">开始挑战</button>
    </div>

    <!-- 进行中 -->
    <div v-else-if="!finished" class="play">
      <div class="hud">
        <div class="time" :class="{ urg: timeLeft <= 10 }">⏱ {{ timeLeft }}s</div>
        <div class="scr">得分 {{ score }}</div>
        <div v-if="streak >= 2" class="combo">🔥 {{ streak }} 连击</div>
      </div>
      <QuestionCard
        v-if="current"
        :question="current"
        :correct-auto-ms="900"
        :wrong-auto-ms="900"
        :show-explanation="false"
        next-label="跳过讲解 →"
        @answered="onAnswered"
        @next="onNext"
      />
    </div>

    <!-- 结算 -->
    <div v-else class="done">
      <div class="big-scr">{{ score }}</div>
      <p class="lbl">最终得分</p>
      <div class="stat">
        <span>答了 {{ answered }} 题</span>
        <span>最高 {{ maxStreak }} 连击</span>
      </div>
      <button class="go" @click="backToSetup">再来一次</button>
    </div>
  </div>
</template>

<style scoped>
.page { padding: 16px; min-height: 100%; }
h1 { font-size: 22px; font-weight: 700; }
.sub { font-size: 13px; color: var(--text-dim); margin-top: 4px; }

.setup { display: flex; flex-direction: column; gap: 22px; padding-top: 24px; }
.opts { display: grid; grid-template-columns: repeat(4, 1fr); gap: 5px; }
.opts button {
  padding: 9px 2px;
  border-radius: var(--r-md);
  background: var(--bg-card);
  border: 1.5px solid var(--border-soft);
  font-size: 12px;
  color: var(--text-soft);
}
.opts button.on { border-color: var(--accent); color: var(--accent); }
.go {
  width: 100%; padding: 16px;
  background: var(--accent); color: #fff;
  border-radius: var(--r-md);
  font-size: 17px; font-weight: 600;
}

.play { display: flex; flex-direction: column; gap: 14px; }
.hud {
  display: flex; align-items: center; gap: 14px;
  font-size: 14px; font-weight: 600;
}
.time { color: var(--text); }
.time.urg { color: var(--wrong); animation: pulse 0.8s infinite; }
@keyframes pulse { 50% { opacity: 0.5; } }
.scr { color: var(--accent); }
.combo { color: var(--wx-huo); margin-left: auto; }

.done { display: flex; flex-direction: column; align-items: center; gap: 8px; padding-top: 70px; }
.big-scr { font-size: 72px; font-weight: 700; color: var(--accent); line-height: 1; }
.lbl { font-size: 14px; color: var(--text-dim); }
.stat { display: flex; gap: 20px; font-size: 13px; color: var(--text-soft); margin: 16px 0 28px; }
</style>
