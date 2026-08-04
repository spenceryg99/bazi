import { ref } from 'vue'
import type { Progress } from '@/data/types'

const STORAGE_KEY = 'bazi-progress-v1'

const progress = ref<Progress>(load())

function load(): Progress {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) return JSON.parse(raw)
  } catch {}
  return { total: 0, correct: 0, byField: {} }
}

function save() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(progress.value))
  } catch {}
}

export function useProgress() {
  function record(field: string, isCorrect: boolean) {
    progress.value.total++
    if (isCorrect) progress.value.correct++
    const f = (progress.value.byField[field] ??= { total: 0, correct: 0 })
    f.total++
    if (isCorrect) f.correct++
    save()
  }

  function reset() {
    progress.value = { total: 0, correct: 0, byField: {} }
    save()
  }

  return { progress, record, reset }
}
