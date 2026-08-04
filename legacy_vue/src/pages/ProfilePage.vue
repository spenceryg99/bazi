<script setup lang="ts">
import { ref, computed } from 'vue'
import { useProgress } from '@/composables/useProgress'
import { useWrongBook } from '@/composables/useWrongBook'
import { getAllQuestionPool } from '@/composables/useQuiz'
import { shuffle } from '@/composables/useQuiz'
import QuestionCard from '@/components/QuestionCard.vue'
import type { Question } from '@/data/types'

const { progress, reset } = useProgress()
const { records, markCorrect, markWrong, weakCategories, clear } = useWrongBook()

const rate = computed(() =>
  progress.value.total === 0 ? 0 : Math.round((progress.value.correct / progress.value.total) * 100),
)

const sortedFields = computed(() =>
  Object.entries(progress.value.byField)
    .map(([k, v]) => ({ name: k, ...v, rate: v.total === 0 ? 0 : Math.round((v.correct / v.total) * 100) }))
    .sort((a, b) => a.rate - b.rate),
)

const weak = computed(() => weakCategories().slice(0, 5))

function confirmReset() {
  if (confirm('确定清空所有练习记录？')) reset()
}

// ===== 错题重做 =====
const redoing = ref(false)
const redoQueue = ref<Question[]>([])
const redoIdx = ref(0)
const redoCorrect = ref(0)

function startRedo() {
  const ids = records.value.map((r) => r.questionId)
  const all = getAllQuestionPool()
  let qs = ids.map((id) => all.find((q) => q.id === id)).filter(Boolean) as Question[]
  qs = shuffle(qs).slice(0, 10)
  if (qs.length === 0) return
  redoQueue.value = qs
  redoIdx.value = 0
  redoCorrect.value = 0
  redoing.value = true
}

const redoCurrent = computed(() => redoQueue.value[redoIdx.value] ?? null)

function onRedoAnswered(ok: boolean) {
  if (redoCurrent.value) {
    if (ok) { markCorrect(redoCurrent.value); redoCorrect.value++ }
    else markWrong(redoCurrent.value)
  }
}

function onRedoNext() {
  if (redoIdx.value < redoQueue.value.length - 1) redoIdx.value++
  else redoing.value = false
}
</script>

<template>
  <div class="page">
    <header class="hd">
      <h1>我的练习</h1>
    </header>

    <div class="overview">
      <div class="ring" :style="{ background: `conic-gradient(var(--accent) ${rate}%, var(--bg-elev) 0)` }">
        <div class="ring-inner">
          <div class="pct">{{ rate }}<span>%</span></div>
          <div class="lab">正确率</div>
        </div>
      </div>
      <div class="nums">
        <div><b>{{ progress.total }}</b><span>总题数</span></div>
        <div><b class="ok">{{ progress.correct }}</b><span>答对</span></div>
        <div><b class="no">{{ progress.total - progress.correct }}</b><span>答错</span></div>
      </div>
    </div>

    <!-- 错题本 -->
    <section class="block wrong-book">
      <div class="wb-head">
        <h3>📒 错题本</h3>
        <span class="wb-cnt">{{ records.length }} 题</span>
      </div>
      <div v-if="records.length === 0" class="wb-empty">
        <p>暂无错题</p>
        <p class="hint">答错的题会自动收集到这里</p>
      </div>
      <template v-else>
        <div v-if="weak.length" class="wb-weak">
          <p class="wb-sub">薄弱项：</p>
          <div class="wb-tags">
            <span v-for="[name, n] in weak" :key="name" class="wb-tag">{{ name }} ×{{ n }}</span>
          </div>
        </div>
        <button class="redo-btn" @click="startRedo">重做错题（连对2次移出）</button>
        <button class="clr-btn" @click="clear">清空错题本</button>
      </template>
    </section>

    <!-- 薄弱项详情 -->
    <section v-if="sortedFields.length" class="block">
      <h3>各题型正确率（升序）</h3>
      <div class="fields">
        <div v-for="f in sortedFields" :key="f.name" class="field">
          <div class="fname">{{ f.name }}</div>
          <div class="fbar"><span :style="{ width: f.rate + '%' }" :class="rateColor(f.rate)"></span></div>
          <div class="frate" :class="rateColor(f.rate)">{{ f.rate }}%</div>
        </div>
      </div>
    </section>

    <section v-else class="empty">
      <p>还没有练习记录</p>
      <p class="hint">去「答题」或「挑战」开始吧</p>
    </section>

    <button v-if="progress.total" class="reset" @click="confirmReset">清空练习统计</button>

    <!-- 错题重做弹层 -->
    <transition name="sheet">
      <div v-if="redoing" class="mask" @click.self="redoing = false">
        <div class="sheet">
          <div class="grab" @click="redoing = false"></div>
          <div class="redo-prog">{{ redoIdx + 1 }} / {{ redoQueue.length }}　✓ {{ redoCorrect }}</div>
          <QuestionCard
            v-if="redoCurrent"
            :question="redoCurrent"
            :correct-auto-ms="1800"
            :wrong-auto-ms="0"
            next-label="下一错题 →"
            @answered="onRedoAnswered"
            @next="onRedoNext"
          />
        </div>
      </div>
    </transition>
  </div>
</template>

<script lang="ts">
function rateColor(r: number) {
  return r >= 80 ? 'hi' : r >= 60 ? 'mid' : 'lo'
}
</script>

<style scoped>
.page { padding: 16px; }
.hd { margin-bottom: 18px; }
h1 { font-size: 22px; font-weight: 700; }

.overview {
  display: flex; gap: 16px; align-items: center;
  background: var(--bg-card);
  border-radius: var(--r-lg);
  padding: 20px;
  margin-bottom: 16px;
}
.ring {
  width: 96px; height: 96px;
  border-radius: 50%;
  flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
}
.ring-inner {
  width: 78px; height: 78px;
  border-radius: 50%;
  background: var(--bg-card);
  display: flex; flex-direction: column; align-items: center; justify-content: center;
}
.pct { font-size: 24px; font-weight: 700; color: var(--accent); }
.pct span { font-size: 12px; }
.lab { font-size: 10px; color: var(--text-dim); }
.nums { flex: 1; display: flex; flex-direction: column; gap: 12px; }
.nums div { display: flex; align-items: baseline; gap: 8px; }
.nums b { font-size: 22px; }
.nums span { font-size: 12px; color: var(--text-dim); }
.ok { color: var(--correct); }
.no { color: var(--wrong); }

.block { background: var(--bg-card); border-radius: var(--r-lg); padding: 16px 18px; margin-bottom: 12px; }
h3 { font-size: 13px; color: var(--text-dim); margin-bottom: 14px; }

.wrong-book { border: 1px solid rgba(224,86,75,0.2); }
.wb-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.wb-head h3 { margin: 0; }
.wb-cnt { font-size: 13px; color: var(--wrong); font-weight: 600; }
.wb-empty { text-align: center; padding: 16px 0; color: var(--text-dim); }
.wb-empty p { font-size: 14px; }
.hint { font-size: 11px; margin-top: 4px; }
.wb-weak { margin-bottom: 12px; }
.wb-sub { font-size: 12px; color: var(--text-dim); margin-bottom: 6px; }
.wb-tags { display: flex; flex-wrap: wrap; gap: 6px; }
.wb-tag { font-size: 11px; padding: 3px 8px; border-radius: var(--r-full); background: var(--bg-elev); color: var(--wrong); }
.redo-btn {
  width: 100%; padding: 13px;
  background: var(--wrong); color: #fff;
  border-radius: var(--r-md); font-size: 15px; font-weight: 600;
  margin-bottom: 8px;
}
.redo-btn:active { transform: scale(0.98); }
.clr-btn {
  width: 100%; padding: 10px;
  background: transparent; border: 1px solid var(--border);
  border-radius: var(--r-md); color: var(--text-dim); font-size: 13px;
}

.fields { display: flex; flex-direction: column; gap: 12px; }
.field { display: grid; grid-template-columns: 72px 1fr 44px; gap: 10px; align-items: center; }
.fname { font-size: 12px; color: var(--text-soft); }
.fbar { height: 6px; background: var(--bg-elev); border-radius: 3px; overflow: hidden; }
.fbar span { display: block; height: 100%; }
.fbar .hi { background: var(--correct); }
.fbar .mid { background: var(--wx-tu); }
.fbar .lo { background: var(--wrong); }
.frate { font-size: 12px; text-align: right; }
.frate.hi { color: var(--correct); }
.frate.mid { color: var(--wx-tu); }
.frate.lo { color: var(--wrong); }

.empty { text-align: center; padding: 50px 0; color: var(--text-dim); }
.empty p { font-size: 15px; }

.reset {
  width: 100%; margin-top: 12px;
  padding: 13px;
  background: transparent;
  border: 1px solid var(--border);
  border-radius: var(--r-md);
  color: var(--text-dim);
  font-size: 14px;
}

/* 重做弹层 */
.mask { position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 100; display: flex; align-items: flex-end; }
.sheet { width: 100%; max-height: 90vh; overflow-y: auto; background: var(--bg); border-radius: 24px 24px 0 0; padding: 10px 14px calc(20px + var(--safe-bottom)); }
.grab { width: 38px; height: 4px; background: var(--border); border-radius: 2px; margin: 0 auto 12px; }
.redo-prog { font-size: 13px; color: var(--text-dim); margin-bottom: 14px; text-align: center; }

.sheet-enter-active { transition: transform 0.28s cubic-bezier(0.2,0.8,0.2,1); }
.sheet-enter-from { transform: translateY(100%); }
</style>
