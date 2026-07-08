// 干支刷题 · 类型定义

export type Wuxing = '木' | '火' | '土' | '金' | '水'
export type Yinyang = '阳' | '阴'
export type Season = '春' | '夏' | '秋' | '冬'
export type DizhiCategory = '四正' | '四生' | '四库'
export type CangganLevel = '主' | '中' | '余'

/** 说文解字 */
export interface Etymology {
  guhu: string       // 甲骨文字形描述
  shuowen: string    // 《说文解字》原文
  benyi: string      // 本义
  whyChosen: string  // 为何选用此字命名
}

/** 天干 */
export interface Tiangan {
  char: string
  pinyin: string
  order: number
  yinyang: Yinyang
  wuxing: Wuxing
  imagery: string    // 阳木/阴木之象（大树/花草等）
  etymology: Etymology
  memory: string     // 记忆钩子
}

/** 地支藏干条目 */
export interface CangganItem {
  stem: string
  wuxing: Wuxing
  level: CangganLevel
}

/** 地支 */
export interface Dizhi {
  char: string
  pinyin: string
  order: number
  yinyang: Yinyang
  wuxing: Wuxing
  season: Season
  animal: string     // 生肖
  hour: string       // 时辰
  category: DizhiCategory
  isPure: boolean    // 四正为纯
  canggan: CangganItem[]
  etymology: Etymology
  memory: string
}

/** 题目类型 */
export type QuestionField =
  | 'yinyang'
  | 'wuxing'
  | 'season'
  | 'animal'
  | 'category'
  | 'isPure'
  | 'canggan'
  | 'hour'

/** 一道题 */
export interface Question {
  id: string
  subject: string        // 主体字（如 "甲"）
  subjectType: 'tiangan' | 'dizhi'
  field: QuestionField   | 'advanced'
  fieldLabel: string     // 题目问什么（"阴阳"）
  prompt: string         // 完整题干
  options: string[]      // 选项
  answer: string         // 正确答案
  explanation: string    // 详细讲解
  category?: string      // 进阶题分类标签
}

/** 统计 */
export interface Progress {
  total: number
  correct: number
  byField: Record<string, { total: number; correct: number }>
}
