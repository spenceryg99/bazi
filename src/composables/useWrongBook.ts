import { ref } from 'vue'
import type { Question } from '@/data/types'

const STORAGE_KEY = 'bazi-wrong-book-v1'

interface WrongRecord {
  questionId: string
  wrongCount: number   // 累计答错次数
  correctStreak: number // 连续答对次数（重做时累计）
  lastField: string
  lastCategory: string
}

const records = ref<WrongRecord[]>(load())

function load(): WrongRecord[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) return JSON.parse(raw)
  } catch {}
  return []
}

function save() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(records.value))
  } catch {}
}

export function useWrongBook() {
  /** 记一次答错 */
  function markWrong(q: Question) {
    const r = records.value.find((x) => x.questionId === q.id)
    if (r) {
      r.wrongCount++
      r.correctStreak = 0
      r.lastField = q.fieldLabel
      r.lastCategory = q.category ?? ''
    } else {
      records.value.push({
        questionId: q.id,
        wrongCount: 1,
        correctStreak: 0,
        lastField: q.fieldLabel,
        lastCategory: q.category ?? '',
      })
    }
    save()
  }

  /** 记一次答对（重做模式才调用） */
  function markCorrect(q: Question) {
    const r = records.value.find((x) => x.questionId === q.id)
    if (!r) return
    r.correctStreak++
    // 连续答对 2 次 → 移出错题本
    if (r.correctStreak >= 2) {
      records.value = records.value.filter((x) => x.questionId !== q.id)
    }
    save()
  }

  /** 错题总数 */
  const count = () => records.value.length

  /** 薄弱分类（错得最多的） */
  const weakCategories = () => {
    const m = new Map<string, number>()
    for (const r of records.value) {
      const key = r.lastCategory || r.lastField || '其他'
      m.set(key, (m.get(key) ?? 0) + 1)
    }
    return [...m.entries()].sort((a, b) => b[1] - a[1])
  }

  function clear() {
    records.value = []
    save()
  }

  return { records, markWrong, markCorrect, count, weakCategories, clear }
}
