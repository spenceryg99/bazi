import type { Wuxing } from './types'

// ===== 五行基础关系 =====
export const WUXING_LIST: Wuxing[] = ['木', '火', '土', '金', '水']

// 相生：key 生 value
export const SHENG_MAP: Record<Wuxing, Wuxing> = {
  木: '火', 火: '土', 土: '金', 金: '水', 水: '木',
}
// 相克：key 克 value
export const KE_MAP: Record<Wuxing, Wuxing> = {
  木: '土', 火: '金', 土: '水', 金: '木', 水: '火',
}

/** 关系名（用于出题/讲解） */
export const RELATION_LABEL: Record<string, string> = {
  same: '同我（比劫）',
  sheng_me: '生我（印星）',
  me_sheng: '我生（食伤）',
  me_ke: '我克（财星）',
  ke_me: '克我（官杀）',
}

/** 给定日主五行与目标五行，返回十神大类及正偏判定所需的阴阳关系 */
export function getRelation(dmElem: Wuxing, targetElem: Wuxing): string {
  if (targetElem === dmElem) return 'same'
  if (SHENG_MAP[targetElem] === dmElem) return 'sheng_me'
  if (SHENG_MAP[dmElem] === targetElem) return 'me_sheng'
  if (KE_MAP[dmElem] === targetElem) return 'me_ke'
  if (KE_MAP[targetElem] === dmElem) return 'ke_me'
  return ''
}

// ===== 天干阴阳 + 五行（用于十神正偏判定） =====
export const STEM_INFO: Record<string, { yinyang: '阳' | '阴'; wuxing: Wuxing }> = {
  甲: { yinyang: '阳', wuxing: '木' }, 乙: { yinyang: '阴', wuxing: '木' },
  丙: { yinyang: '阳', wuxing: '火' }, 丁: { yinyang: '阴', wuxing: '火' },
  戊: { yinyang: '阳', wuxing: '土' }, 己: { yinyang: '阴', wuxing: '土' },
  庚: { yinyang: '阳', wuxing: '金' }, 辛: { yinyang: '阴', wuxing: '金' },
  壬: { yinyang: '阳', wuxing: '水' }, 癸: { yinyang: '阴', wuxing: '水' },
}

/** 完整十神（含正偏）：日主天干 × 目标天干 */
export function getTenGod(dmStem: string, targetStem: string): string {
  const dm = STEM_INFO[dmStem]
  const tg = STEM_INFO[targetStem]
  if (!dm || !tg) return ''
  const rel = getRelation(dm.wuxing, tg.wuxing)
  const samePolarity = dm.yinyang === tg.yinyang // 同阴阳
  switch (rel) {
    case 'same':   return samePolarity ? '比肩' : '劫财'
    case 'sheng_me': return samePolarity ? '偏印（枭神）' : '正印'
    case 'me_sheng': return samePolarity ? '食神' : '伤官'
    case 'me_ke':  return samePolarity ? '偏财' : '正财'
    case 'ke_me':  return samePolarity ? '七杀（偏官）' : '正官'
    default: return ''
  }
}

// ===== 旺相休囚死 =====
export type SeasonState = '旺' | '相' | '休' | '囚' | '死'
export const SEASON_RULES: Record<string, Record<SeasonState, Wuxing>> = {
  春: { 旺: '木', 相: '火', 休: '水', 囚: '金', 死: '土' },
  夏: { 旺: '火', 相: '土', 休: '木', 囚: '水', 死: '金' },
  秋: { 旺: '金', 相: '水', 休: '土', 囚: '火', 死: '木' },
  冬: { 旺: '水', 相: '木', 休: '金', 囚: '土', 死: '火' },
}
/** 给定季节和五行，返回状态 */
export function getSeasonState(season: string, elem: Wuxing): SeasonState {
  const rule = SEASON_RULES[season]
  if (!rule) return '休'
  for (const k of Object.keys(rule) as SeasonState[]) {
    if (rule[k] === elem) return k
  }
  return '休'
}

// ===== 天干五合 =====
export interface WuheItem {
  pair: [string, string]
  result: Wuxing          // 化出五行
  order: [number, number] // 天干序数（甲1乙2…癸10）
  imagery: string         // 取象名（中正之合…）
  imageryMean: string     // 取象含义
  apply: string           // 应用断语
}

export const TIANGAN_WUHE: WuheItem[] = [
  {
    pair: ['甲', '己'], result: '土', order: [1, 6],
    imagery: '中正之合',
    imageryMean: '甲（阳木）+ 己（阴土）。木克土为夫妻之配，主安分守己、中正平和。',
    apply: '命带甲己合：主人端正、循规蹈矩、有信誉。女命得之主贤妻良母。',
  },
  {
    pair: ['乙', '庚'], result: '金', order: [2, 7],
    imagery: '仁义之合',
    imageryMean: '乙（阴木）+ 庚（阳金）。金克木但合，主刚柔并济、恩威并用。',
    apply: '命带乙庚合：主果敢又仁慈、有担当。化金成功则主义气、武职掌权。',
  },
  {
    pair: ['丙', '辛'], result: '水', order: [3, 8],
    imagery: '威制之合',
    imageryMean: '丙（阳火）+ 辛（阴金）。火克金，主威严、肃杀、纪律。',
    apply: '命带丙辛合：主有威严、擅管理、宜军法纪律之职。化水成功则主智谋深沉。',
  },
  {
    pair: ['丁', '壬'], result: '木', order: [4, 9],
    imagery: '淫慝之合',
    imageryMean: '丁（阴火）+ 壬（阳水）。水火交战、阴阳相惑，主感情纠葛、桃花是非。',
    apply: '命带丁壬合：主多情、人缘好但易招桃花是非。女命尤甚，需防感情纠纷。',
  },
  {
    pair: ['戊', '癸'], result: '火', order: [5, 10],
    imagery: '无情之合',
    imageryMean: '戊（阳土）+ 癸（阴水）。土克水、相合无情，主貌合神离、薄情寡义。',
    apply: '命带戊癸合：主夫妻感情薄、貌合神离。化火成功则反主热情，但多生变。',
  },
]

/** 天干五合总原理 */
export const WUHE_PRINCIPLE = {
  rule: '天干序数隔五相合：甲1配己6、乙2配庚7、丙3配辛8、丁4配壬9、戊5配癸10（每对相差5位）。',
  why: '一说源于河图数理——河图一六共宗(水)、二七同道(火)、三八为朋(木)、四九为友(金)、五十同途(土)，天干按序配河图数，隔五相合。一说源于古天文学，甲己之日日月会于特定星宿。',
  huaqi: '化气口诀：甲己化土、乙庚化金、丙辛化水、丁壬化木、戊癸化火。化气成功则该五行增力，命局以化出之五行论。',
  condition: '化气三条件（与地支六合化气类似）：①化神当令（生于化出五行之月）②两干紧邻（无隔断）③无克破（无冲克散合）。三条件全满足方真化，否则「合而不化」，只绊住对方令其减力。',
  xiji: '合本身无吉凶：合用神→绊（用神减力，凶）；合忌神→制（忌神受羁，吉）。化气成功则该五行主导，喜忌看作用于日主。',
}

// ===== 三合局 =====
export const SANHE_JU: { branches: [string, string, string]; element: Wuxing }[] = [
  { branches: ['申', '子', '辰'], element: '水' },
  { branches: ['亥', '卯', '未'], element: '木' },
  { branches: ['寅', '午', '戌'], element: '火' },
  { branches: ['巳', '酉', '丑'], element: '金' },
]

// ===== 四库（墓库）对应 =====
export const SI_KU: Record<string, Wuxing> = {
  辰: '水', // 水库（申子辰）
  未: '木', // 木库（亥卯未）
  戌: '火', // 火库（寅午戌）
  丑: '金', // 金库（巳酉丑）
}

/** 五行配色 */
export const WUXING_COLOR: Record<Wuxing, string> = {
  木: '#3fa66a',
  火: '#e0564b',
  土: '#c89a3a',
  金: '#9aa3ad',
  水: '#3b7dd8',
}
