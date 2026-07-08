import { TIANGAN } from '@/data/tiangan'
import { DIZHI } from '@/data/dizhi'
import {
  WUXING_LIST, SHENG_MAP, KE_MAP, STEM_INFO, getTenGod,
  SEASON_RULES, getSeasonState, TIANGAN_WUHE, WUHE_PRINCIPLE, SANHE_JU, SI_KU,
} from '@/data/advanced'
import type { Question, QuestionField } from '@/data/types'

/** 打乱数组 */
function shuffle<T>(arr: T[]): T[] {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

/** 从选项池中取正确答案 + 3 个干扰项 */
function makeOptions(correct: string, pool: string[]): string[] {
  const distractors = shuffle(pool.filter((x) => x !== correct)).slice(0, 3)
  return shuffle([correct, ...distractors])
}

// ===== 天干 / 地支 属性题生成器 =====

const TIANGAN_FIELDS: { field: QuestionField; label: string; pool: string[]; pick: (t: typeof TIANGAN[number]) => string }[] = [
  { field: 'yinyang', label: '阴阳', pool: ['阳', '阴'], pick: (t) => t.yinyang },
  { field: 'wuxing', label: '五行', pool: [...WUXING_LIST], pick: (t) => t.wuxing },
]

const DIZHI_FIELDS: { field: QuestionField; label: string; pool: string[]; pick: (d: typeof DIZHI[number]) => string }[] = [
  { field: 'yinyang', label: '阴阳', pool: ['阳', '阴'], pick: (d) => d.yinyang },
  { field: 'wuxing', label: '五行', pool: [...WUXING_LIST], pick: (d) => d.wuxing },
  { field: 'season', label: '季节', pool: ['春', '夏', '秋', '冬'], pick: (d) => d.season },
  { field: 'animal', label: '生肖', pool: DIZHI.map((d) => d.animal), pick: (d) => d.animal },
  { field: 'category', label: '类别', pool: ['四正', '四生', '四库'], pick: (d) => d.category },
  { field: 'isPure', label: '是否纯（四正为纯）', pool: ['纯', '不纯'], pick: (d) => (d.isPure ? '纯' : '不纯') },
  {
    field: 'canggan',
    label: '藏干',
    pool: DIZHI.map((d) => d.canggan.map((c) => c.stem).join('')),
    pick: (d) => d.canggan.map((c) => c.stem).join(''),
  },
]

function genTianganQuestions(): Question[] {
  return TIANGAN.flatMap((t) =>
    TIANGAN_FIELDS.map((f) => {
      const correct = f.pick(t)
      return {
        id: `tg-${t.char}-${f.field}`,
        subject: t.char,
        subjectType: 'tiangan' as const,
        field: f.field,
        fieldLabel: f.label,
        prompt: `「${t.char}」（${t.pinyin}）的${f.label}是？`,
        options: makeOptions(correct, f.pool),
        answer: correct,
        explanation: buildTianganExplanation(t, f.field),
      }
    }),
  )
}

function genDizhiQuestions(): Question[] {
  return DIZHI.flatMap((d) =>
    DIZHI_FIELDS.map((f) => {
      const correct = f.pick(d)
      return {
        id: `dz-${d.char}-${f.field}`,
        subject: d.char,
        subjectType: 'dizhi' as const,
        field: f.field,
        fieldLabel: f.label,
        prompt: `「${d.char}」（${d.pinyin}）的${f.label}是？`,
        options: makeOptions(correct, f.pool),
        answer: correct,
        explanation: buildDizhiExplanation(d, f.field),
      }
    }),
  )
}

function buildTianganExplanation(t: typeof TIANGAN[number], field: QuestionField): string {
  const e = t.etymology
  let core = ''
  if (field === 'yinyang') {
    core = `「${t.char}」是第${t.order}位天干，序号${t.order % 2 === 1 ? '奇' : '偶'}→${t.yinyang}。${t.imagery}。`
  } else if (field === 'wuxing') {
    core = `「${t.char}」属${t.wuxing}。${t.imagery}。记忆：${t.memory}`
  }
  return `${core}\n\n【说文】${e.shuowen}\n【字形】${e.guhu}\n【本义】${e.benyi}\n【为何选用】${e.whyChosen}`
}

function buildDizhiExplanation(d: typeof DIZHI[number], field: QuestionField): string {
  const e = d.etymology
  let core = ''
  switch (field) {
    case 'yinyang':
      core = `「${d.char}」序号${d.order}${d.order % 2 === 1 ? '奇(阳)' : '偶(阴)'}。`
      break
    case 'wuxing':
      core = `「${d.char}」属${d.wuxing}。`
      break
    case 'season':
      core = `「${d.char}」属${d.season}季。`
      break
    case 'animal':
      core = `「${d.char}」对应生肖「${d.animal}」。`
      break
    case 'category':
      core = `「${d.char}」属${d.category}（${d.category === '四正' ? '季节巅峰，纯' : d.category === '四生' ? '季节开头，杂' : '季节尾巴，仓库'}）。`
      break
    case 'isPure':
      core = `「${d.char}」${d.isPure ? '是四正，纯（只藏主气一个）' : `是${d.category}，不纯（藏${d.canggan.length}个）`}。`
      break
    case 'canggan':
      core = `「${d.char}」藏干：${d.canggan.map((c) => `${c.stem}(${c.wuxing},${c.level})`).join(' / ')}。`
      break
  }
  return `${core}\n\n【说文】${e.shuowen}\n【字形】${e.guhu}\n【本义】${e.benyi}\n【为何选用】${e.whyChosen}\n【记忆】${d.memory}`
}

// ===== 进阶题生成器 =====

function genAdvancedQuestions(): Question[] {
  const qs: Question[] = []

  // 1. 十神判定
  for (const dm of Object.keys(STEM_INFO)) {
    for (const tg of Object.keys(STEM_INFO)) {
      if (dm === tg) continue
      const answer = getTenGod(dm, tg)
      const pool = ['比肩', '劫财', '正印', '偏印（枭神）', '食神', '伤官', '正财', '偏财', '正官', '七杀（偏官）']
      qs.push({
        id: `ss-${dm}-${tg}`,
        subject: `${dm}→${tg}`,
        subjectType: 'tiangan',
        field: 'advanced',
        fieldLabel: '十神',
        category: '十神判定',
        prompt: `日主「${dm}」见「${tg}」，是十神中的哪一个？`,
        options: makeOptions(answer, pool),
        answer,
        explanation: buildTenGodExplanation(dm, tg, answer),
      })
    }
  }

  // 2. 旺相休囚死（季节 × 五行）
  for (const season of Object.keys(SEASON_RULES)) {
    for (const elem of WUXING_LIST) {
      const answer = getSeasonState(season, elem)
      const pool: string[] = ['旺', '相', '休', '囚', '死']
      qs.push({
        id: `wx-${season}-${elem}`,
        subject: `${season}/${elem}`,
        subjectType: 'dizhi',
        field: 'advanced',
        fieldLabel: '旺相休囚死',
        category: '旺相休囚死',
        prompt: `${season}季，五行「${elem}」处于什么状态？`,
        options: makeOptions(answer, pool),
        answer,
        explanation: buildSeasonExplanation(season, elem, answer),
      })
    }
  }

  // 3. 五行生克
  for (const a of WUXING_LIST) {
    // 我生
    const sheng = SHENG_MAP[a]
    qs.push({
      id: `sk-sheng-${a}`,
      subject: a,
      subjectType: 'tiangan',
      field: 'advanced',
      fieldLabel: '五行相生',
      category: '五行生克',
      prompt: `五行「${a}」生什么？`,
      options: makeOptions(sheng, WUXING_LIST),
      answer: sheng,
      explanation: `${a}生${sheng}。口诀：木生火、火生土、土生金、金生水、水生木。`,
    })
    // 我克
    const ke = KE_MAP[a]
    qs.push({
      id: `sk-ke-${a}`,
      subject: a,
      subjectType: 'tiangan',
      field: 'advanced',
      fieldLabel: '五行相克',
      category: '五行生克',
      prompt: `五行「${a}」克什么？`,
      options: makeOptions(ke, WUXING_LIST),
      answer: ke,
      explanation: `${a}克${ke}。口诀：木克土、土克水、水克火、火克金、金克木。`,
    })
  }

  // 4. 天干五合（化气 + 原理 + 取象 + 配对规律）
  {
    // 引入五合数据（含取象）
    const WUHE = TIANGAN_WUHE
    const PRINCIPLE = WUHE_PRINCIPLE
    const allImagery = WUHE.map((h) => h.imagery)
    const allPairs = WUHE.map((h) => h.pair.join(''))

    for (const h of WUHE) {
      const [a, b] = h.pair
      // 题型A：化气（给两干→问化什么）
      qs.push({
        id: `he-hua-${a}${b}`,
        subject: `${a}${b}`, subjectType: 'tiangan', field: 'advanced', fieldLabel: '天干五合',
        category: '五合 · 化气',
        prompt: `天干「${a}」与「${b}」合，化出什么五行？`,
        options: makeOptions(h.result, WUXING_LIST),
        answer: h.result,
        explanation: `${a}${b}合化${h.result}（${h.imagery}）。\n\n${PRINCIPLE.huaqi}\n\n【原理】${PRINCIPLE.rule}\n${PRINCIPLE.condition}`,
      })
      // 题型B：取象（给两干→问是什么合）
      qs.push({
        id: `he-xiang-${a}${b}`,
        subject: `${a}${b}`, subjectType: 'tiangan', field: 'advanced', fieldLabel: '天干五合',
        category: '五合 · 取象',
        prompt: `天干「${a}」与「${b}」合，古称什么合？`,
        options: makeOptions(h.imagery, allImagery),
        answer: h.imagery,
        explanation: `${a}${b}合 = ${h.imagery}。\n${h.imageryMean}\n\n【应用】${h.apply}`,
      })
      // 题型C：反向（给一干→问合谁）
      qs.push({
        id: `he-rev-${a}`,
        subject: a, subjectType: 'tiangan', field: 'advanced', fieldLabel: '天干五合',
        category: '五合 · 配对',
        prompt: `天干「${a}」与哪个天干相合？`,
        options: makeOptions(b, ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'].filter((x) => x !== b && x !== a)),
        answer: b,
        explanation: `${a}（序数${h.order[0]}）与 ${b}（序数${h.order[1]}）隔五相合 → ${a}${b}合化${h.result}（${h.imagery}）。\n\n${PRINCIPLE.rule}`,
      })
    }

    // 题型D：配对规律（问隔几相合）
    qs.push({
      id: 'he-rule-gap',
      subject: '配对规律', subjectType: 'tiangan', field: 'advanced', fieldLabel: '天干五合',
      category: '五合 · 原理',
      prompt: '天干五合的配对规律是「隔几位相合」？',
      options: makeOptions('隔五位（甲1配己6）', ['隔两位', '隔三位', '隔四位', '隔五位（甲1配己6）']),
      answer: '隔五位（甲1配己6）',
      explanation: `天干五合 = 序数隔五相合：甲1-己6、乙2-庚7、丙3-辛8、丁4-壬9、戊5-癸10。\n\n${PRINCIPLE.why}`,
    })
    // 题型E：化气条件
    qs.push({
      id: 'he-cond',
      subject: '化气条件', subjectType: 'tiangan', field: 'advanced', fieldLabel: '天干五合',
      category: '五合 · 原理',
      prompt: '天干五合要「真化」（化气成功），需要满足什么？',
      options: makeOptions(
        '化神当令 + 两干紧邻 + 无克破',
        ['只要两干出现', '化神当令 + 两干紧邻 + 无克破', '日主身弱', '生于春夏'],
      ),
      answer: '化神当令 + 两干紧邻 + 无克破',
      explanation: `化气三条件：\n①化神当令（生于化出五行之月）\n②两干紧邻（无隔断）\n③无克破（无冲克散合）\n\n三条件全满足方真化，否则「合而不化」只绊住对方令其减力。\n\n${PRINCIPLE.xiji}`,
    })
  }

  // 5. 三合局
  for (const ju of SANHE_JU) {
    const [a, b, c] = ju.branches
    qs.push({
      id: `sanhe-${a}${b}${c}`,
      subject: `${a}${b}${c}`,
      subjectType: 'dizhi',
      field: 'advanced',
      fieldLabel: '三合局',
      category: '三合局',
      prompt: `「${a}＋${b}＋${c}」三合，合成什么局？`,
      options: makeOptions(ju.element, WUXING_LIST),
      answer: ju.element,
      explanation: `${a}${b}${c}合${ju.element}局。四组三合：申子辰合水、亥卯未合木、寅午戌合火、巳酉丑合金。`,
    })
  }

  // 6. 四库
  for (const [ku, elem] of Object.entries(SI_KU)) {
    qs.push({
      id: `ku-${ku}`,
      subject: ku,
      subjectType: 'dizhi',
      field: 'advanced',
      fieldLabel: '四库（墓库）',
      category: '四库',
      prompt: `「${ku}」是什么五行的墓库？`,
      options: makeOptions(elem, WUXING_LIST),
      answer: elem,
      explanation: `${ku}是${elem}库。对应三合局：辰水库(申子辰)、未木库(亥卯未)、戌火库(寅午戌)、丑金库(巳酉丑)。`,
    })
  }

  return qs
}

function buildTenGodExplanation(dm: string, tg: string, answer: string): string {
  const dmInfo = STEM_INFO[dm]
  const tgInfo = STEM_INFO[tg]
  const samePolarity = dmInfo.yinyang === tgInfo.yinyang
  const rel =
    tgInfo.wuxing === dmInfo.wuxing ? '同我'
    : SHENG_MAP[tgInfo.wuxing] === dmInfo.wuxing ? '生我'
    : SHENG_MAP[dmInfo.wuxing] === tgInfo.wuxing ? '我生'
    : KE_MAP[dmInfo.wuxing] === tgInfo.wuxing ? '我克'
    : '克我'
  return `日主${dm}（${dmInfo.yinyang}${dmInfo.wuxing}）见${tg}（${tgInfo.yinyang}${tgInfo.wuxing}）。\n五行关系：${rel}。阴阳${samePolarity ? '同性（偏/七杀/食神/偏财/比肩）' : '异性（正/正官/伤官/正财/劫财）'}。\n→ 十神为「${answer}」。\n\n判定法：先看五行关系定大类(比劫/印/食伤/财/官杀)，再看阴阳同异分正偏——同性为偏，异性为正。`
}

function buildSeasonExplanation(season: string, elem: string, answer: string): string {
  const rule = SEASON_RULES[season]
  const wang = rule['旺']
  return `${season}季${wang}气当令执政。\n五行「${elem}」与执政者${wang}的关系决定状态：\n  · 旺=执政者本人(${wang})\n  · 相=执政所生(${SHENG_MAP[wang as keyof typeof SHENG_MAP]})\n  · 休=生执政者(${Object.entries(SHENG_MAP).find(([,v])=>v===wang)?.[0]})\n  · 囚=克执政者(${Object.entries(KE_MAP).find(([,v])=>v===wang)?.[0]})\n  · 死=执政所克(${KE_MAP[wang as keyof typeof KE_MAP]})\n→ 「${elem}」为「${answer}」。\n口诀：当令者旺、令生者相、生令者休、克令者囚、令克者死。`
}

// ===== 藏干专题（地支藏干单独成范围）=====

// 四生中气的「长生位」对应——气机提前定律
const CHANGSHENG_AT: Record<string, { stem: string; elem: string; bornSeason: string }> = {
  寅: { stem: '丙', elem: '火', bornSeason: '夏' },
  巳: { stem: '庚', elem: '金', bornSeason: '秋' },
  申: { stem: '壬', elem: '水', bornSeason: '冬' },
  亥: { stem: '甲', elem: '木', bornSeason: '春' },
}
// 四库的三合局生命周期：生→旺→墓
const KU_LIFECYCLE: Record<string, { elem: string; born: string; peak: string; store: string }> = {
  辰: { elem: '水', born: '申', peak: '子', store: '辰' },
  未: { elem: '木', born: '亥', peak: '卯', store: '未' },
  戌: { elem: '火', born: '寅', peak: '午', store: '戌' },
  丑: { elem: '金', born: '巳', peak: '酉', store: '丑' },
}

// 藏干规律讲解
function explainCangganRule(d: typeof DIZHI[number]): string {
  const main = d.canggan[0]
  const lines = [`「${d.char}」(${d.category} · ${d.season}季) 藏干：`]
  for (const c of d.canggan) {
    lines.push(`  · ${c.stem}（${c.wuxing}，${c.level}气）`)
  }
  lines.push('')

  if (d.category === '四正') {
    lines.push(`【规律·四正】${d.char}是${d.season}季的巅峰月（帝旺位）。`)
    lines.push(`一股气（${main.wuxing}）独大、纯粹，只藏主气一个${main.stem}。`)
    lines.push(`盛极生阴，所以巅峰位存的是阴干（${main.stem}是阴${main.wuxing}）。`)
  } else if (d.category === '四生') {
    lines.push(`【规律·四生】${d.char}是${d.season}季开头月（始生之地），万物初生、能量杂，藏三个：`)
    lines.push(`  · 主气 ${main.stem}（${main.wuxing}）= 本季节五行。${d.char}属${d.season}，${main.wuxing}当令，阳干= ${main.stem}。`)
    if (d.canggan[1]) {
      const cs = CHANGSHENG_AT[d.char]
      if (cs) {
        lines.push(`  · 中气 ${d.canggan[1].stem}（${d.canggan[1].wuxing}）= ${d.canggan[1].stem}就在${d.char}出生！`)
        lines.push(`    气机提前定律：${cs.elem}气（${cs.bornSeason}天的主气）在${d.char}（${d.season}初）就开始酝酿。`)
        lines.push(`    每股气都在自己季节的「前一季」出生：亥生木、寅生火、巳生金、申生水。`)
      }
    }
    if (d.canggan[2] && d.canggan[2].stem === '戊') {
      lines.push(`  · 余气 戊土 = 土是永远在的基底（土寄四时），四生转换剧烈，留阳土戊。`)
    }
    if (d.canggan.length === 2) {
      lines.push(`  注：${d.char}较特殊，只藏两个（水势太纯，冲走了戊土）。`)
    }
    lines.push(`三层全是阳干——始生=阳，主动生发。`)
  } else {
    // 四库
    const ku = SI_KU[d.char]
    const lc = KU_LIFECYCLE[d.char]
    lines.push(`【规律·四库】${d.char}是${d.season}季尾巴月（墓库/归藏之地），像个仓库：`)
    lines.push(`  · 主气 ${main.stem}（土）= 土主收纳转换，仓库就是土做的。`)
    lines.push(`    ${d.char}是${d.order % 2 === 1 ? '阳支→戊(阳土)' : '阴支→己(阴土)'}。`)
    if (d.canggan[1]) {
      lines.push(`  · 中气 ${d.canggan[1].stem}（${d.canggan[1].wuxing}）= 本季节的余势。`)
      lines.push(`    ${d.char}属${d.season}，${d.season}=${d.canggan[1].wuxing}，木火金水之气正在退场，显阴干。`)
    }
    if (d.canggan[2] && lc) {
      lines.push(`  · 余气 ${d.canggan[2].stem}（${d.canggan[2].wuxing}）= 仓库里存的货。`)
      lines.push(`    ${d.char}是${ku}库。三合局：${lc.born}（生）→ ${lc.peak}（旺）→ ${lc.store}（墓）。`)
      lines.push(`    ${ku}气在${lc.born}出生、${lc.peak}巅峰、走完一生后归藏进${lc.store}。`)
    }
    lines.push(`中气余气全是阴干——归藏=阴，已完成的能量沉淀入库。`)
  }
  lines.push(`\n记忆：${d.memory}`)
  return lines.join('\n')
}

function genCangganQuestions(): Question[] {
  const qs: Question[] = []

  // 主气藏干池
  const mainPool = DIZHI.map((d) => `${d.canggan[0].stem}（${d.canggan[0].wuxing}）`)

  for (const d of DIZHI) {
    const main = d.canggan[0]

    // 题型1：主气（本气）藏干
    const mainAns = `${main.stem}（${main.wuxing}）`
    qs.push({
      id: `cg-main-${d.char}`,
      subject: d.char,
      subjectType: 'dizhi',
      field: 'canggan',
      fieldLabel: '主气藏干',
      category: '藏干 · 主气',
      prompt: `「${d.char}」的主气（本气）藏干是？`,
      options: makeOptions(mainAns, mainPool),
      answer: mainAns,
      explanation: explainCangganRule(d),
    })

    // 题型2：完整藏干
    const fullAns = d.canggan.map((c) => c.stem).join('')
    const fullPool = DIZHI.map((x) => x.canggan.map((c) => c.stem).join(''))
    qs.push({
      id: `cg-full-${d.char}`,
      subject: d.char,
      subjectType: 'dizhi',
      field: 'canggan',
      fieldLabel: '完整藏干',
      category: '藏干 · 完整',
      prompt: `「${d.char}」的完整藏干是？（按主/中/余顺序）`,
      options: makeOptions(fullAns, fullPool),
      answer: fullAns,
      explanation: explainCangganRule(d),
    })

    // 题型3：藏几个天干 + 归类
    const n = d.canggan.length
    const cntAns = `${n}个`
    qs.push({
      id: `cg-cnt-${d.char}`,
      subject: d.char,
      subjectType: 'dizhi',
      field: 'canggan',
      fieldLabel: '藏干个数',
      category: '藏干 · 个数',
      prompt: `「${d.char}」一共藏了几个天干？`,
      options: makeOptions(cntAns, ['1个', '2个', '3个']),
      answer: cntAns,
      explanation: `${d.char}是${d.category}，${d.category === '四正' ? '季节巅峰，纯，只藏1个主气' : d.category === '四生' ? '季节开头，能量杂，藏3个（特殊者藏2个）' : '季节尾巴，仓库，藏3个'}。\n实际藏 ${n} 个：${d.canggan.map((c) => c.stem).join('、')}。\n\n${explainCangganRule(d)}`,
    })
  }

  return qs
}

// ===== 地支关系专题（6类关系 + 8种题型）=====

import { RELATIONS, TRICKY_COMBOS, POWER_ORDER, CASE_EXAMPLES } from '@/data/dizhi-relations'
import type { RelationId } from '@/data/dizhi-relations'

// 通用：关系名选项池
const ALL_RELATION_NAMES = RELATIONS.map((r) => r.name)

// 题型1：配对题（给组合→问是哪种关系）
function genRelationPairQuestions(qs: Question[]) {
  for (const r of RELATIONS) {
    for (const p of r.pairs) {
      // 跳过四字组合（自刑整体）
      if (p.members.length >= 4) continue
      const key = p.members.join('')
      qs.push({
        id: `rel-pair-${r.id}-${key}`,
        subject: key, subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
        category: `${r.name} · 配对`,
        prompt: `「${p.members.join(' + ')}」属于哪种地支关系？`,
        options: makeOptions(r.name, ALL_RELATION_NAMES),
        answer: r.name,
        explanation: buildRelationExplanation(r, p),
      })
    }
  }
}

// 题型2：结果题（六合化气 / 三合三会合成）
function genRelationResultQuestions(qs: Question[]) {
  const pool: string[] = []
  for (const r of RELATIONS) for (const p of r.pairs) if (p.result) pool.push(p.result)
  for (const r of RELATIONS) {
    for (const p of r.pairs) {
      if (!p.result) continue
      qs.push({
        id: `rel-res-${r.id}-${p.members.join('')}`,
        subject: p.members.join(''), subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
        category: `${r.name} · 结果`,
        prompt: `「${p.members.join(' + ')}」${r.name}${r.id === 'liuhe' ? '化' : '成'}什么？`,
        options: makeOptions(p.result, pool),
        answer: p.result,
        explanation: buildRelationExplanation(r, p),
      })
    }
  }
}

// 题型3：缺位题（三合/三会缺一支）
function genRelationMissingQuestions(qs: Question[]) {
  const allBranches = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥']
  for (const r of RELATIONS.filter((x) => x.id === 'sanhe' || x.id === 'sanhui')) {
    for (const p of r.pairs) {
      // 每组生成两题：缺第1位、缺第3位
      for (const missIdx of [0, 2]) {
        const shown = p.members.filter((_, i) => i !== missIdx)
        const missing = p.members[missIdx]
        const prompt = missIdx === 0
          ? `「？ + ${shown.join(' + ')}」缺哪个地支，才能${r.name}${p.result}？`
          : `「${shown.join(' + ')} + ?」缺哪个地支，才能${r.name}${p.result}？`
        qs.push({
          id: `rel-miss-${r.id}-${p.members.join('')}-${missIdx}`,
          subject: p.members.join(''), subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
          category: `${r.name} · 缺位`,
          prompt,
          options: makeOptions(missing, allBranches),
          answer: missing,
          explanation: buildRelationExplanation(r, p),
        })
      }
    }
  }
}

// 题型4：应用断语题
function genRelationApplyQuestions(qs: Question[]) {
  const applyPool = [
    '和睦联结、人缘好',
    '动荡变动、冲突离散',
    '势力合伙、该五行主导',
    '刑伤官非、恩怨纠纷',
    '一方专旺、行业集中',
    '暗伤阻隔、骨肉不和',
    '用神减力（凶）',
    '忌神受制（吉）',
    '配偶人缘好、感情和合',
    '夫妻聚少离多、婚姻动荡',
    '早年离祖、与父母缘薄',
    '子女操心、晚年奔波',
  ]
  const map: Record<RelationId, string> = {
    liuhe: '和睦联结、人缘好',
    liuchong: '动荡变动、冲突离散',
    sanhe: '势力合伙、该五行主导',
    sanxing: '刑伤官非、恩怨纠纷',
    sanhui: '一方专旺、行业集中',
    liuhai: '暗伤阻隔、骨肉不和',
  }
  for (const r of RELATIONS) {
    qs.push({
      id: `rel-app-${r.id}`,
      subject: r.name, subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
      category: `${r.name} · 应用`,
      prompt: `「${r.name}」在八字中主要主什么事？`,
      options: makeOptions(map[r.id], applyPool),
      answer: map[r.id],
      explanation: `${r.summary}\n\n【原理】${r.principle}\n【喜忌】${r.xiji}\n【应用】${map[r.id]}`,
    })
    // 喜忌题
    qs.push({
      id: `rel-xiji-${r.id}`,
      subject: r.name, subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
      category: `${r.name} · 喜忌`,
      prompt: `「${r.name}」作用于忌神时，吉凶如何？`,
      options: makeOptions('忌神受制（吉）', ['忌神受制（吉）', '用神减力（凶）', '无影响', '一定大凶']),
      answer: '忌神受制（吉）',
      explanation: `${r.name}本身无吉凶，看作用于谁：\n· 合/冲/刑/害用神→用神减力（凶）\n· 合/冲/刑/害忌神→忌神受制（吉）\n\n这是初学最需扭转的认知：关系本身无吉凶，喜忌定吉凶。\n\n${r.xiji}`,
    })
  }
  // 分柱位断语（六合/六冲/三刑）
  const duanyuQs = [
    { rel: '六合', pos: '日支', ans: '配偶人缘好、感情和合' },
    { rel: '六合', pos: '时支', ans: '晚年安稳、子女孝顺' },
    { rel: '六冲', pos: '年月柱', ans: '早年离祖、与父母缘薄' },
    { rel: '六冲', pos: '日支', ans: '夫妻聚少离多、婚姻动荡' },
    { rel: '六冲', pos: '时支', ans: '子女外出、晚年奔波' },
    { rel: '三刑', pos: '年月柱', ans: '与上司长辈恩怨' },
    { rel: '三刑', pos: '日时柱', ans: '配偶子女忘恩、感情恩怨' },
  ]
  const duanyuPool = applyPool
  for (const d of duanyuQs) {
    qs.push({
      id: `rel-duanyu-${d.rel}-${d.pos}`,
      subject: `${d.rel}·${d.pos}`, subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
      category: `${d.rel} · 分柱断语`,
      prompt: `${d.rel}出现在${d.pos}，多主什么？`,
      options: makeOptions(d.ans, duanyuPool),
      answer: d.ans,
      explanation: `同一关系落在不同柱（年月日时）含义不同：\n· 年柱=祖上/长辈/早年\n· 月柱=父母/兄弟/青年\n· 日支=配偶/夫妻宫\n· 时柱=子女/晚年\n\n${d.rel}在${d.pos}：${d.ans}`,
    })
  }
}

// 题型5：混淆辨析题
function genRelationTrickyQuestions(qs: Question[]) {
  for (const t of TRICKY_COMBOS) {
    qs.push({
      id: `rel-trick-${t.members.join('')}`,
      subject: t.members.join(''), subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
      category: '关系 · 辨析',
      prompt: `「${t.members.join(' + ')}」最容易混淆，它的正确关系是？`,
      options: makeOptions(t.correct, [t.correct, t.wrong, '六合', '六冲']),
      answer: t.correct,
      explanation: `易错辨析：${t.note}\n\n正确答案：${t.correct}。`,
    })
  }
}

// 题型6：力量比较题
function genRelationPowerQuestions(qs: Question[]) {
  const pairs = [
    { a: '三会局', b: '三合局', ans: '三会局' },
    { a: '三合局', b: '半合', ans: '三合局' },
    { a: '六合(化气)', b: '六合(不化)', ans: '六合(化气)' },
    { a: '六冲', b: '六害', ans: '六冲' },
    { a: '三刑', b: '六害', ans: '三刑' },
    { a: '半合', b: '六合(化气)', ans: '半合' },
  ]
  for (const p of pairs) {
    qs.push({
      id: `rel-pow-${p.a}-${p.b}`,
      subject: '力量比较', subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
      category: '关系 · 力量比较',
      prompt: `「${p.a}」与「${p.b}」相比，哪个力量更大？`,
      options: makeOptions(p.ans, [p.a, p.b]),
      answer: p.ans,
      explanation: `地支关系力量排序（强→弱）：\n${POWER_ORDER}\n\n所以 ${p.a} > ${p.b}。\n断命时力量大的优先看、应事明显。`,
    })
  }
}

// 题型7：单支关系网题
function genRelationNetworkQuestions(qs: Question[]) {
  const allBranches = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥']
  for (const b of allBranches) {
    for (const r of RELATIONS) {
      // 找该地支在该关系中的对象
      for (const p of r.pairs) {
        if (!p.members.includes(b) || p.members.length >= 4) continue
        const partners = p.members.filter((x) => x !== b)
        if (partners.length === 0) continue
        const partner = partners[0]
        qs.push({
          id: `rel-net-${b}-${r.id}`,
          subject: b, subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
          category: '关系 · 单支网络',
          prompt: `「${b}」的${r.name}对象是？`,
          options: makeOptions(partner, allBranches),
          answer: partner,
          explanation: `「${b}」的${r.name}对象是「${partner}」。\n${p.members.join('+')} = ${r.name}${p.result ? '（' + p.result + '）' : ''}。\n\n${p.meaning}`,
        })
        break // 每个地支每个关系只取一题
      }
    }
  }
}

// 题型8：找错判断题
function genRelationJudgeQuestions(qs: Question[]) {
  const stmts = [
    { stmt: '「寅卯辰会东方木」', correct: true, exp: '寅卯辰同属东方春季，三会东方木局，正确。' },
    { stmt: '「巳酉丑会西方金」', correct: false, exp: '错！巳酉丑是三合金局（生旺墓），不是三会。三会西方金是申酉戌。这是最易混的考点。' },
    { stmt: '「申子辰合水局」', correct: true, exp: '申（水长生）+子（水帝旺）+辰（水墓库）=三合水局，正确。' },
    { stmt: '「亥子丑合水局」', correct: false, exp: '错！亥子丑同方位同季=三会北方水，不是三合。三合水局是申子辰。' },
    { stmt: '「寅亥合化木」', correct: true, exp: '寅亥合化木（亥藏甲通寅甲），正确。' },
    { stmt: '「寅亥六冲」', correct: false, exp: '错！寅亥是六合化木。寅申才是六冲（金克木）。' },
    { stmt: '「卯辰六害」', correct: true, exp: '卯辰相害（卯合戌、辰冲戌→害），正确。' },
    { stmt: '「卯戌六害」', correct: false, exp: '错！卯戌是六合化火。卯辰才是六害。' },
    { stmt: '「寅巳申是无恩之刑」', correct: true, exp: '寅巳申循环相刑=无恩之刑，主忘恩负义，正确。' },
    { stmt: '「子卯是恃势之刑」', correct: false, exp: '错！子卯是无礼之刑（子水生卯木太过）。恃势之刑是丑戌未。' },
  ]
  for (const s of stmts) {
    qs.push({
      id: `rel-judge-${s.stmt}`,
      subject: '判断题', subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
      category: '关系 · 找错判断',
      prompt: `${s.stmt}——这句话对吗？`,
      options: ['正确', '错误'],
      answer: s.correct ? '正确' : '错误',
      explanation: s.exp,
    })
  }
}

// 题型9：简化案例题
function genRelationCaseQuestions(qs: Question[]) {
  const cases = [
    { case: '日支卯、月支酉', ans: '夫妻宫被冲，婚姻动荡', exp: CASE_EXAMPLES[0] },
    { case: '寅午戌三支齐全且生于夏月', ans: '合火局成功，火极旺主导命局', exp: CASE_EXAMPLES[1] },
    { case: '年寅、月巳、日申', ans: '寅巳申三刑全，多恩怨纠纷', exp: CASE_EXAMPLES[2] },
    { case: '日支子、时支未', ans: '子未害，家庭暗中不和', exp: CASE_EXAMPLES[3] },
    { case: '申子辰三支齐全', ans: '合水局，水势极旺', exp: CASE_EXAMPLES[4] },
  ]
  const pool = cases.map((c) => c.ans)
  for (const c of cases) {
    qs.push({
      id: `rel-case-${c.case}`,
      subject: '案例', subjectType: 'dizhi', field: 'advanced', fieldLabel: '地支关系',
      category: '关系 · 案例',
      prompt: `某八字「${c.case}」，主什么？`,
      options: makeOptions(c.ans, pool),
      answer: c.ans,
      explanation: c.exp,
    })
  }
}

function buildRelationExplanation(r: typeof RELATIONS[number], p: typeof RELATIONS[number]['pairs'][number]): string {
  const lines = [
    `${p.members.join('+')} = ${r.name}${p.result ? '（' + p.result + '）' : ''}`,
    '',
    `【取象】${p.meaning}`,
    `【原理】${r.principle}`,
    `【力量】${r.power}`,
    `【成立条件】${r.condition}`,
  ]
  if (p.duanyu) {
    lines.push('【分柱断语】')
    if (p.duanyu.nian) lines.push(`  年月：${p.duanyu.nian}`)
    if (p.duanyu.ri) lines.push(`  日支：${p.duanyu.ri}`)
    if (p.duanyu.shi) lines.push(`  时支：${p.duanyu.shi}`)
  }
  lines.push(`【喜忌】${r.xiji}`)
  lines.push(`【口诀】${r.koujue}`)
  return lines.join('\n')
}

function genRelationQuestions(): Question[] {
  const qs: Question[] = []
  genRelationPairQuestions(qs)
  genRelationResultQuestions(qs)
  genRelationMissingQuestions(qs)
  genRelationApplyQuestions(qs)
  genRelationTrickyQuestions(qs)
  genRelationPowerQuestions(qs)
  genRelationNetworkQuestions(qs)
  genRelationJudgeQuestions(qs)
  genRelationCaseQuestions(qs)
  return qs
}

// ===== 论命专题（格局识别 + 用神选取）=====

import {
  ZHENG_GE, WAI_GE, ALL_GE, BRANCH_MAIN_STEM, computeShishenGeju, STEM_YINYANG,
} from '@/data/geju'
import type { Geju } from '@/data/geju'
import { CLASSIC_CASES, TIAOHOU_TABLE } from '@/data/lunming'

const STEM_WX: Record<string, string> = {
  甲:'木',乙:'木',丙:'火',丁:'火',戊:'土',己:'土',庚:'金',辛:'金',壬:'水',癸:'水',
}

// 题型1：格局识别（给日主+月令 → 什么格）
function genGejuIdentifyQuestions(qs: Question[]) {
  const gejuNames = ZHENG_GE.map((g) => g.name)
  const stems = Object.keys(STEM_WX)
  const branches = Object.keys(BRANCH_MAIN_STEM)
  // 为每个日主×月令组合生成
  for (const dm of stems) {
    for (const mb of branches) {
      const main = BRANCH_MAIN_STEM[mb]
      const dmWx = STEM_WX[dm]
      const dmYy = STEM_YINYANG[dm]
      const stemYy = STEM_YINYANG[main.stem]
      const sameYy = dmYy === stemYy
      const { shishen, geju } = computeShishenGeju(dmWx, main.wuxing, sameYy)
      if (geju === '建禄/月劫格') continue  // 比劫月暂跳过
      qs.push({
        id: `geju-id-${dm}-${mb}`,
        subject: `${dm}/${mb}`, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
        category: '格局 · 识别',
        prompt: `日主「${dm}」（${dmWx}），月令「${mb}」，本气「${main.stem}」（${main.wuxing}）透干。是什么格局？`,
        options: makeOptions(geju, gejuNames),
        answer: geju,
        explanation: `${dm}（${dmYy}${dmWx}）生于${mb}月，本气${main.stem}（${stemYy}${main.wuxing}）。\n五行关系：${main.wuxing === dmWx ? '同我(比劫)' : ''}对日主为「${shishen}」。\n月令本气透干 → **${geju}**。\n\n格局判定规则：月令本气对日主的十神关系定格。先看五行关系定大类（官杀/财/印/食伤/比劫），再看阴阳同异分正偏——同性为偏/七杀/食神/比肩，异性为正/正官/伤官/劫财。`,
      })
    }
  }
}

// 题型2：格局成破救（给格局名 → 问破格之神 / 相神）
function genGejuChengPoQuestions(qs: Question[]) {
  const allPo = ALL_GE.map((g) => g.poGe)
  const allXiang = ALL_GE.map((g) => g.xiangShen)
  for (const g of ALL_GE) {
    // 破格之神
    qs.push({
      id: `geju-po-${g.name}`,
      subject: g.name, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '格局 · 破神',
      prompt: `「${g.name}」最怕什么「破格之神」？`,
      options: makeOptions(g.poGe, allPo),
      answer: g.poGe,
      explanation: `${g.name}：${g.meaning}\n\n成格条件：${g.chengGe}\n破格之神：${g.poGe}\n相神（救应）：${g.xiangShen}\n\n格局派核心：成格需相神护，破格需救应。识别破神和相神是格局派断命的灵魂。`,
    })
    // 相神
    qs.push({
      id: `geju-xiang-${g.name}`,
      subject: g.name, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '格局 · 相神',
      prompt: `「${g.name}」的「相神」（成格护格之神）是？`,
      options: makeOptions(g.xiangShen, allXiang),
      answer: g.xiangShen,
      explanation: `${g.name}：${g.meaning}\n\n相神 = ${g.xiangShen}\n\n相神是成就/保护格局的关键。有相神则格成、无相神则格败。格局派定用神的核心就是找相神。`,
    })
  }
}

// 题型3：本气十神 → 格局推导
function genGejuDeriveQuestions(qs: Question[]) {
  const branches = Object.keys(BRANCH_MAIN_STEM)
  for (const mb of branches) {
    const main = BRANCH_MAIN_STEM[mb]
    qs.push({
      id: `geju-bm-${mb}`,
      subject: mb, subjectType: 'dizhi', field: 'advanced', fieldLabel: '论命',
      category: '格局 · 本气',
      prompt: `地支「${mb}」的月令本气藏干是？`,
      options: makeOptions(`${main.stem}（${main.wuxing}）`, branches.map((b) => `${BRANCH_MAIN_STEM[b].stem}（${BRANCH_MAIN_STEM[b].wuxing}）`)),
      answer: `${main.stem}（${main.wuxing}）`,
      explanation: `${mb}的月令本气藏干是${main.stem}（${main.wuxing}）。\n月令本气是格局判定的起点——它对日主的十神关系决定格局。`,
    })
  }
}

// 题型4：外格识别
function genWaiGeQuestions(qs: Question[]) {
  const waiNames = WAI_GE.map((g) => g.name)
  for (const g of WAI_GE) {
    qs.push({
      id: `geju-wai-${g.name}`,
      subject: g.name, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '格局 · 外格',
      prompt: `下列哪种命局属于「${g.name}」？`,
      options: makeOptions(g.monthlyRule, WAI_GE.map((x) => x.monthlyRule)),
      answer: g.monthlyRule,
      explanation: `${g.name}：${g.meaning}\n\n取格：${g.monthlyRule}\n成格：${g.chengGe}\n破格：${g.poGe}\n相神：${g.xiangShen}`,
    })
  }
}

// 题型5：用神选取（给分析问用神）
function genYongshenQuestions(qs: Question[]) {
  // 经典案例题：两派分别取用
  for (const c of CLASSIC_CASES) {
    // 格局派
    qs.push({
      id: `ys-case-${c.id}-geju`,
      subject: c.title, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '用神 · 格局派',
      prompt: `【${c.bazi}】${c.analysis}\n按格局派，相神（用神）应取？`,
      options: makeOptions(c.gejuSchool.yongshen, [c.gejuSchool.yongshen, c.wangshuaiSchool.yongshen, '比劫帮身', '官杀克制']),
      answer: c.gejuSchool.yongshen,
      explanation: `【格局派视角】\n格局：${c.gejuSchool.geju}\n用神：${c.gejuSchool.yongshen}\n理由：${c.gejuSchool.reason}\n\n对比：${c.compare}`,
    })
    // 旺衰派
    qs.push({
      id: `ys-case-${c.id}-ws`,
      subject: c.title, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '用神 · 旺衰派',
      prompt: `【${c.bazi}】${c.analysis}\n按旺衰派，用神应取？`,
      options: makeOptions(c.wangshuaiSchool.yongshen, [c.wangshuaiSchool.yongshen, c.gejuSchool.yongshen, '比劫帮身', '食伤泄秀']),
      answer: c.wangshuaiSchool.yongshen,
      explanation: `【旺衰派视角】\n旺衰：${c.wangshuaiSchool.strength}\n用神：${c.wangshuaiSchool.yongshen}\n理由：${c.wangshuaiSchool.reason}\n\n对比：${c.compare}`,
    })
  }

  // 扶抑原则题
  const fuyi = [
    { cond: '日主身弱', ans: '印星、比劫（扶）' },
    { cond: '日主身旺', ans: '官杀、财星、食伤（抑）' },
    { cond: '生于冬月水金过寒', ans: '火（调候先暖）' },
    { cond: '生于夏月火木过燥', ans: '水（调候先润）' },
    { cond: '金木两行对峙僵持', ans: '水（通关化解）' },
    { cond: '从格（日主极弱无依）', ans: '顺势——克我/我克/我生' },
  ]
  const pool = fuyi.map((f) => f.ans)
  for (const f of fuyi) {
    qs.push({
      id: `ys-fuyi-${f.cond}`,
      subject: '扶抑', subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '用神 · 扶抑原则',
      prompt: `按旺衰派，${f.cond}时，用神应取？`,
      options: makeOptions(f.ans, pool),
      answer: f.ans,
      explanation: `${f.cond} → 用神取${f.ans}。\n\n旺衰派取用三大原则：\n1. 扶抑——弱扶、旺抑\n2. 调候——寒暖燥湿失衡先调（冬用火、夏用水）\n3. 通关——两行对峙取中间五行化解`,
    })
  }

  // 格局相神原则题
  const xiangYuan = [
    { cond: '正官格遇伤官破', ans: '印制伤护官' },
    { cond: '七杀格无制化', ans: '食神制杀 或 印化杀' },
    { cond: '食神格遇枭神夺食', ans: '财制枭护食' },
    { cond: '财格遇比劫夺财', ans: '官制比劫护财' },
    { cond: '正官格财印齐全且官弱', ans: '财生官' },
  ]
  const xpool = xiangYuan.map((x) => x.ans)
  for (const x of xiangYuan) {
    qs.push({
      id: `ys-xiang-${x.cond}`,
      subject: '相神', subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '用神 · 相神原则',
      prompt: `按格局派，${x.cond}，相神应取？`,
      options: makeOptions(x.ans, xpool),
      answer: x.ans,
      explanation: `${x.cond} → 相神取「${x.ans}」。\n\n格局派定用神=找相神。相神是成就/保护格局的关键之神：\n· 官格怕伤官→用印护\n· 杀格需制化→食制或印化\n· 食格怕枭→用财制枭\n· 财格怕比劫→用官制\n· 印格怕财破→用比劫制财`,
    })
  }
}

// 题型6：调候用神题（穷通宝鉴）
function genTiaohouQuestions(qs: Question[]) {
  // 调候原则题
  const thPrinciples = [
    { cond: '命局生于冬月、水冷金寒', ans: '丙/丁火（暖）', reason: '冬月太寒，急需火暖解冻，否则五行僵死。调候优先于扶抑。' },
    { cond: '命局生于夏月、火炎土燥', ans: '壬/癸水（润）', reason: '夏月太燥，急需水润局，否则火炎土焦。调候优先于扶抑。' },
    { cond: '调候用神与扶抑用神冲突时', ans: '调候优先（寒暖最急）', reason: '体温不正常，谈什么骨架和力量。寒暖失衡时调候为第一用神。' },
  ]
  for (const p of thPrinciples) {
    qs.push({
      id: `ys-th-principle-${p.cond.slice(0,4)}`,
      subject: '调候', subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '用神 · 调候',
      prompt: `按调候派（《穷通宝鉴》），${p.cond}，应取什么调候用神？`,
      options: makeOptions(p.ans, thPrinciples.map((x) => x.ans)),
      answer: p.ans,
      explanation: `${p.cond} → ${p.ans}\n${p.reason}\n\n调候派核心：寒暖燥湿平衡优先。生于冬月水冷金寒需火暖、夏月火炎土燥需水润。调候用神查《穷通宝鉴》按月令逐日主列表。`,
    })
  }

  // 调候用神查表题（从 TIAOHOU_TABLE 抽样）
  const thPool = TIAOHOU_TABLE.map((t) => t.first)
  for (const t of TIAOHOU_TABLE) {
    qs.push({
      id: `ys-th-table-${t.dm}-${t.season}`,
      subject: `${t.dm}/${t.season}`, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '用神 · 调候查表',
      prompt: `${t.dm} 生于 ${t.season}，按《穷通宝鉴》调候首用？`,
      options: makeOptions(t.first, thPool),
      answer: t.first,
      explanation: `${t.dm} 生于 ${t.season}：\n首用 ${t.first}，次用 ${t.second}。\n${t.note}\n\n调候派核心：按月令查该日主的调候喜用。寒暖平衡后再论格局旺衰。`,
    })
  }

  // 三书对应题
  const classics = [
    { book: '《子平真诠》', school: '格局派' },
    { book: '《滴天髓阐微》', school: '旺衰派' },
    { book: '《穷通宝鉴》', school: '调候派' },
  ]
  for (const c of classics) {
    qs.push({
      id: `ys-th-book-${c.book}`,
      subject: c.book, subjectType: 'tiangan', field: 'advanced', fieldLabel: '论命',
      category: '用神 · 三书',
      prompt: `${c.book} 是哪一派的代表经典？`,
      options: makeOptions(c.school, classics.map((x) => x.school)),
      answer: c.school,
      explanation: `${c.book} → ${c.school}\n\n子平三书：\n· 《子平真诠》= 格局派（立骨）\n· 《滴天髓阐微》= 旺衰派（布血）\n· 《穷通宝鉴》= 调候派（调温）\n\n口诀：真诠立骨、滴天布血、宝鉴调温。三书合参方为全功。`,
    })
  }
}

function genLunmingQuestions(): Question[] {
  const qs: Question[] = []
  genGejuIdentifyQuestions(qs)
  genGejuChengPoQuestions(qs)
  genGejuDeriveQuestions(qs)
  genWaiGeQuestions(qs)
  genYongshenQuestions(qs)
  genTiaohouQuestions(qs)
  return qs
}

// ===== 姓名学专题（五格剖象法）=====

import { WU_GE, SHULI_81, SANCAI_CONFIGS, STROKE_WUXING, strokeToWuxing, getShuli } from '@/data/xingming'

// 题型1：五格定义题
function genXingmingDefQuestions(qs: Question[]) {
  const pool = ['主运（核心，性格、中年）', '前运（青年、子女）', '后运（晚年、整体）', '副运（人际、外围）', '先天运（祖上、父母）']
  for (const g of WU_GE) {
    qs.push({
      id: `xm-def-${g.name}`,
      subject: g.name, subjectType: 'tiangan', field: 'advanced', fieldLabel: '姓名学',
      category: '姓名学 · 五格定义',
      prompt: `五格里「${g.name}」代表什么运势？`,
      options: makeOptions(g.yun, pool),
      answer: g.yun,
      explanation: `【${g.name}】${g.meaning}\n运势：${g.yun}\n算法：${g.algorithm}\n\n⚠️ 姓名学 ≠ 八字。五格看笔画，八字看生辰，是两个平行系统。`,
    })
  }
}

// 题型2：五格算法题（给笔画数字 → 算某格）
function genXingmingCalcQuestions(qs: Question[]) {
  const cases = [
    { surname: 8, ming1: 13, ming2: 0 },   // 单字名
    { surname: 11, ming1: 3, ming2: 0 },
    { surname: 7, ming1: 14, ming2: 6 },    // 双字名
    { surname: 6, ming1: 10, ming2: 10 },
    { surname: 9, ming1: 12, ming2: 5 },
  ]
  for (let ci = 0; ci < cases.length; ci++) {
    const c = cases[ci]
    const hasM2 = c.ming2 > 0
    const tian = c.surname + 1
    const ren = c.surname + c.ming1
    const di = hasM2 ? c.ming1 + c.ming2 : c.ming1 + 1
    const zong = c.surname + c.ming1 + (hasM2 ? c.ming2 : 0)
    const wai = zong - ren + 1

    const grids = [
      { name: '天格', val: tian },
      { name: '人格', val: ren },
      { name: '地格', val: di },
      { name: '外格', val: wai },
      { name: '总格', val: zong },
    ]
    for (const g of grids) {
      const numPool = [tian, ren, di, wai, zong].filter((n) => n !== g.val)
      qs.push({
        id: `xm-calc-${ci}-${g.name}`,
        subject: g.name, subjectType: 'tiangan', field: 'advanced', fieldLabel: '姓名学',
        category: '姓名学 · 五格算法',
        prompt: `姓${c.surname}画${hasM2 ? `、名第1字${c.ming1}画、第2字${c.ming2}画` : `、名字${c.ming1}画（单字名）`}，${g.name} = ？`,
        options: makeOptions(String(g.val), numPool.map(String)),
        answer: String(g.val),
        explanation: `${g.name} = ${g.val}\n算法：${WU_GE.find((x) => x.name === g.name)?.algorithm}\n\n⚠️ 姓名学 ≠ 八字。`,
      })
    }
  }
}

// 题型3：笔画尾数 → 五行
function genXingmingWuxingQuestions(qs: Question[]) {
  for (const tail of [0,1,2,3,4,5,6,7,8,9]) {
    const wx = STROKE_WUXING[tail]
    const tails = [0,1,2,3,4,5,6,7,8,9].filter((t) => t !== tail)
    qs.push({
      id: `xm-wx-${tail}`,
      subject: `尾数${tail}`, subjectType: 'tiangan', field: 'advanced', fieldLabel: '姓名学',
      category: '姓名学 · 五行对应',
      prompt: `姓名笔画尾数为「${tail}」，对应什么五行？`,
      options: makeOptions(wx, ['木','火','土','金','水']),
      answer: wx,
      explanation: `笔画尾数 ${tail} → 五行 ${wx}\n对应表：1,2木 / 3,4火 / 5,6土 / 7,8金 / 9,0水\n\n这是把五格数字转五行的规则——每个格的数字取尾数定五行，再算三才配置。`,
    })
  }
}

// 题型4：吉凶判断题（给数 → 吉/凶）
function genXingmingLuckQuestions(qs: Question[]) {
  // 抽样一些典型吉数和凶数
  const samples = [
    { num: 1, luck: '吉' }, { num: 4, luck: '凶' }, { num: 6, luck: '吉' },
    { num: 9, luck: '凶' }, { num: 11, luck: '吉' }, { num: 14, luck: '凶' },
    { num: 15, luck: '吉' }, { num: 18, luck: '吉' }, { num: 24, luck: '吉' },
    { num: 34, luck: '凶' }, { num: 81, luck: '吉' }, { num: 80, luck: '凶' },
  ]
  for (const s of samples) {
    qs.push({
      id: `xm-luck-${s.num}`,
      subject: `${s.num}`, subjectType: 'tiangan', field: 'advanced', fieldLabel: '姓名学',
      category: '姓名学 · 吉凶',
      prompt: `数理「${s.num}」是吉还是凶？`,
      options: makeOptions(s.luck, ['吉', '凶', '半吉']),
      answer: s.luck,
      explanation: `数理 ${s.num}：${getShuli(s.num).keyword}（${s.luck}）。\n${getShuli(s.num).meaning}\n\n⚠️ 姓名学 ≠ 八字。五格数理只是名字笔画吉凶，与个人命运关系有争议。`,
    })
  }
}

// 题型5：数理含义题
function genXingmingMeaningQuestions(qs: Question[]) {
  const focuses = [1, 5, 15, 16, 21, 24, 31, 33, 41, 81, 4, 9, 10, 34, 80]
  const pool = SHULI_81.filter((s) => focuses.includes(s.num)).map((s) => s.keyword)
  for (const num of focuses) {
    const s = getShuli(num)
    qs.push({
      id: `xm-mean-${num}`,
      subject: `${num}`, subjectType: 'tiangan', field: 'advanced', fieldLabel: '姓名学',
      category: '姓名学 · 数理含义',
      prompt: `数理「${num}」的含义（关键词）是？`,
      options: makeOptions(s.keyword, pool),
      answer: s.keyword,
      explanation: `${num}：${s.keyword}（${s.luck}）\n${s.meaning}`,
    })
  }
}

// 题型6：三才配置题
function genXingmingSancaiQuestions(qs: Question[]) {
  const pool = ['吉', '凶', '半吉']
  for (const c of SANCAI_CONFIGS) {
    qs.push({
      id: `xm-sc-${c.pattern}`,
      subject: c.pattern, subjectType: 'tiangan', field: 'advanced', fieldLabel: '姓名学',
      category: '姓名学 · 三才',
      prompt: `三才配置「${c.pattern}」是吉是凶？`,
      options: makeOptions(c.luck, pool),
      answer: c.luck,
      explanation: `${c.pattern}：${c.luck}\n${c.meaning}\n\n三才看天格、人格、地格三个数字转成五行后的生克。相生为吉、相克为凶。`,
    })
  }
}

function genXingmingQuestions(): Question[] {
  const qs: Question[] = []
  genXingmingDefQuestions(qs)
  genXingmingCalcQuestions(qs)
  genXingmingWuxingQuestions(qs)
  genXingmingLuckQuestions(qs)
  genXingmingMeaningQuestions(qs)
  genXingmingSancaiQuestions(qs)
  return qs
}

// ===== 统一出题入口 =====

export type QuizScope = 'tiangan' | 'dizhi' | 'canggan' | 'relations' | 'lunming' | 'xingming' | 'advanced' | 'all'

export type RelationFilter = 'all' | RelationId
export type LunmingFilter = 'all' | 'geju' | 'yongshen'

// 关系题按子类筛选
export function getRelationQuestions(filter: RelationFilter): Question[] {
  const all = genRelationQuestions()
  if (filter === 'all') return all
  // 按关系id过滤（category 含关系名）
  const rel = RELATIONS.find((r) => r.id === filter)
  if (!rel) return all
  return all.filter((q) => q.category?.startsWith(rel.name) || q.category?.includes(rel.name))
}

// 论命题按子类筛选
export function getLunmingQuestions(filter: LunmingFilter): Question[] {
  const all = genLunmingQuestions()
  if (filter === 'all') return all
  if (filter === 'geju') return all.filter((q) => q.category?.startsWith('格局'))
  return all.filter((q) => q.category?.startsWith('用神'))
}

const ALL_QUESTIONS: Question[] = [
  ...genTianganQuestions(), ...genDizhiQuestions(),
  ...genCangganQuestions(), ...genRelationQuestions(),
  ...genLunmingQuestions(), ...genXingmingQuestions(),
  ...genAdvancedQuestions(),
]

export function getQuestionPool(scope: QuizScope): Question[] {
  switch (scope) {
    case 'tiangan': return genTianganQuestions()
    case 'dizhi': return genDizhiQuestions()
    case 'canggan': return genCangganQuestions()
    case 'relations': return genRelationQuestions()
    case 'lunming': return genLunmingQuestions()
    case 'xingming': return genXingmingQuestions()
    case 'advanced': return genAdvancedQuestions()
    case 'all': default: return [...ALL_QUESTIONS]
  }
}

export function getRandomQuestions(scope: QuizScope, count: number): Question[] {
  return shuffle(getQuestionPool(scope)).slice(0, count)
}

export function getQuestionCount(scope: QuizScope): number {
  return getQuestionPool(scope).length
}

/** 取全部题目（供错题本按ID查找） */
let _allFlat: Question[] | null = null
export function getAllQuestionPool(): Question[] {
  if (_allFlat) return _allFlat
  _allFlat = [...ALL_QUESTIONS]
  return _allFlat
}

/** 按ID查题 */
export function getQuestionById(id: string): Question | undefined {
  return getAllQuestionPool().find((q) => q.id === id)
}

export { shuffle }
