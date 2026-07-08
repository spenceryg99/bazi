<script setup lang="ts">
import { ref, computed, watch, onUnmounted } from 'vue'
import type { Question } from '@/data/types'

const props = withDefaults(defineProps<{
  question: Question
  correctAutoMs?: number   // 答对自动跳延迟；0=手动
  wrongAutoMs?: number     // 答错自动跳延迟；0=手动（看完解释手动跳）
  showExplanation?: boolean
  nextLabel?: string
}>(), {
  correctAutoMs: 0,
  wrongAutoMs: 0,
  showExplanation: true,
  nextLabel: '下一题 →',
})

const emit = defineEmits<{
  answered: [isCorrect: boolean]
  next: []
}>()

const selected = ref<string | null>(null)
const answered = ref(false)
let timer: number | undefined

const isCorrect = computed(() => selected.value === props.question.answer)

// 当前答题路径是否手动（延迟为 0 → 需要显示按钮）
const isManual = computed(() =>
  answered.value && ((isCorrect.value ? props.correctAutoMs : props.wrongAutoMs) === 0),
)

// 题目切换 → 重置状态 + 清定时器
watch(() => props.question, () => {
  if (timer) { clearTimeout(timer); timer = undefined }
  selected.value = null
  answered.value = false
})

function choose(opt: string) {
  if (answered.value) return
  selected.value = opt
  answered.value = true
  emit('answered', isCorrect.value)
  // 答对走 correctAutoMs，答错走 wrongAutoMs；为 0 则手动
  const delay = isCorrect.value ? props.correctAutoMs : props.wrongAutoMs
  if (delay > 0) {
    timer = window.setTimeout(() => doNext(), delay)
  }
}

function doNext() {
  if (timer) { clearTimeout(timer); timer = undefined }
  selected.value = null
  answered.value = false
  emit('next')
}

onUnmounted(() => { if (timer) clearTimeout(timer) })

function optClass(opt: string) {
  if (!answered.value) return ''
  if (opt === props.question.answer) return 'correct'
  if (opt === selected.value) return 'wrong'
  return 'fade'
}
</script>

<template>
  <div class="q">
    <div class="prompt">
      <div class="subj">{{ props.question.subject }}</div>
      <div class="ask">{{ props.question.prompt }}</div>
      <div v-if="props.question.category" class="cat">{{ props.question.category }}</div>
    </div>

    <div class="opts">
      <button
        v-for="opt in props.question.options"
        :key="opt"
        class="opt"
        :class="optClass(opt)"
        @click="choose(opt)"
      >
        <span class="txt">{{ opt }}</span>
        <span v-if="answered && opt === props.question.answer" class="mark">✓</span>
        <span v-else-if="answered && opt === selected" class="mark">✗</span>
      </button>
    </div>

    <transition name="exp">
      <div v-if="answered" class="exp">
        <div class="exp-head" :class="isCorrect ? 'ok' : 'no'">
          {{ isCorrect ? '✓ 答对了' : '✗ 正确答案：' + props.question.answer }}
        </div>
        <!-- 详细讲解（答题模式显示，挑战模式精简） -->
        <pre v-if="props.showExplanation" class="exp-body">{{ props.question.explanation }}</pre>
        <p v-else class="exp-hint">{{ !isManual ? '自动跳转中…' : '' }}</p>
        <button v-if="isManual" class="next-btn" @click="doNext">{{ props.nextLabel }}</button>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.q { display: flex; flex-direction: column; gap: 18px; }
.prompt {
  background: var(--bg-card);
  border-radius: var(--r-lg);
  padding: 22px 20px;
}
.subj { font-size: 15px; color: var(--text-dim); margin-bottom: 8px; }
.ask { font-size: 19px; font-weight: 600; line-height: 1.5; }
.cat { margin-top: 10px; font-size: 11px; color: var(--accent); }

.opts { display: flex; flex-direction: column; gap: 10px; }
.opt {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 18px;
  background: var(--bg-card);
  border: 1.5px solid var(--border-soft);
  border-radius: var(--r-md);
  font-size: 17px;
  transition: all 0.15s;
}
.opt:active { transform: scale(0.98); }
.opt.correct { border-color: var(--correct); background: rgba(63,166,106,0.12); }
.opt.wrong { border-color: var(--wrong); background: rgba(224,86,75,0.12); }
.opt.fade { opacity: 0.4; }
.mark { font-size: 18px; font-weight: 700; }
.opt.correct .mark { color: var(--correct); }
.opt.wrong .mark { color: var(--wrong); }

.exp { background: var(--bg-card); border-radius: var(--r-lg); padding: 16px 18px; }
.exp-head { font-size: 15px; font-weight: 600; margin-bottom: 10px; }
.exp-head.ok { color: var(--correct); }
.exp-head.no { color: var(--wrong); }
.exp-body {
  font-family: var(--font);
  font-size: 13.5px;
  line-height: 1.7;
  color: var(--text-soft);
  white-space: pre-wrap;
  word-break: break-word;
}
.exp-hint { font-size: 12px; color: var(--text-dim); }
.next-btn {
  margin-top: 14px;
  width: 100%;
  padding: 14px;
  background: var(--accent);
  color: #fff;
  border-radius: var(--r-md);
  font-size: 16px;
  font-weight: 600;
}
.next-btn:active { transform: scale(0.98); }

.exp-enter-active { transition: all 0.25s ease; }
.exp-enter-from { opacity: 0; transform: translateY(10px); }
</style>
