// 八字格局知识库（八正格 + 外格）
// 依据：《子平真诠》《渊海子平》正宗格局派

export type GejuCategory = '正格' | '外格'

export interface Geju {
  name: string             // '正官格'
  category: GejuCategory
  shishen: string          // 对应十神大类
  // 月令取法：月支本气对日主的十神关系决定
  monthlyRule: string      // 取格规则
  exampleDayMaster: string // 例：甲木日主
  exampleMonth: string     // 例：酉月
  exampleStem: string      // 例：辛金透
  chengGe: string          // 成格条件（喜配）
  poGe: string             // 破格之神
  xiangShen: string        // 相神（救应之神）
  meaning: string          // 格局含义/性格基调
}

// ===== 八正格 =====
export const ZHENG_GE: Geju[] = [
  {
    name: '正官格', category: '正格', shishen: '正官',
    monthlyRule: '月令本气为「正官」（克我之异性天干透出）。如甲木日主生于酉月，辛金本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '酉', exampleStem: '辛金',
    chengGe: '喜财生官、印护官。财是官之源，印是官之盾。',
    poGe: '伤官（克破正官）、七杀混杂（官杀同现）。',
    xiangShen: '遇伤官破→用印制伤护官；遇杀混→合杀留官或食制杀。',
    meaning: '守规矩、有责任感、宜公职管理。正官为贵气之神，主名誉地位。',
  },
  {
    name: '七杀格', category: '正格', shishen: '七杀（偏官）',
    monthlyRule: '月令本气为「七杀」（克我之同性天干透出）。如甲木日主生于申月，庚金本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '申', exampleStem: '庚金',
    chengGe: '喜食神制杀、印化杀、羊刃驾杀。杀需制化方为我用。',
    poGe: '财党杀（财生杀使杀更凶猛无制）。',
    xiangShen: '食神制杀（猛将型）或 印星化杀生身（智囊型）。',
    meaning: '有魄力、爱冒险、武职掌权。七杀为权柄之神，制化得宜则大权在握。',
  },
  {
    name: '正财格', category: '正格', shishen: '正财',
    monthlyRule: '月令本气为「正财」（我克之异性天干透出）。如甲木日主生于丑/未月，己土本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '丑/未', exampleStem: '己土',
    chengGe: '喜食伤生财、官星护财。财要源源、要守护。',
    poGe: '比劫夺财（兄弟同行争财产）。',
    xiangShen: '官星制比劫护财。',
    meaning: '务实稳重、重利益、勤勉致富。正财为正当之财、薪俸之财。',
  },
  {
    name: '偏财格', category: '正格', shishen: '偏财',
    monthlyRule: '月令本气为「偏财」（我克之同性天干透出）。如甲木日主生于辰/戌月，戊土本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '辰/戌', exampleStem: '戊土',
    chengGe: '喜食伤生、官星护。',
    poGe: '比劫夺财。',
    xiangShen: '官制比劫。',
    meaning: '慷慨大方、善经营、横财机遇。偏财为流动之财、投机之财、众人 trafic。',
  },
  {
    name: '正印格', category: '正格', shishen: '正印',
    monthlyRule: '月令本气为「正印」（生我之异性天干透出）。如甲木日主生于子月，癸水本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '子', exampleStem: '癸水',
    chengGe: '喜官杀生印（官印相生为大贵之格）。',
    poGe: '财破印（财克印，断学问之源）。',
    xiangShen: '比劫制财护印。',
    meaning: '仁慈重学、有庇护、文职教育。正印为慈母之神、学问之神。',
  },
  {
    name: '偏印格', category: '正格', shishen: '偏印（枭神）',
    monthlyRule: '月令本气为「偏印」（生我之同性天干透出）。如甲木日主生于亥月，壬水本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '亥', exampleStem: '壬水',
    chengGe: '喜官杀生印。偏印较枭，需有制方安。',
    poGe: '财破印、枭神夺食（偏印克食神，断食禄）。',
    xiangShen: '财星制枭（偏印喜财制方为福）。',
    meaning: '聪明孤傲、多学少成、有偏门技艺。偏印为孤克之神、怪才之神。',
  },
  {
    name: '食神格', category: '正格', shishen: '食神',
    monthlyRule: '月令本气为「食神」（我生之同性天干透出）。如甲木日主生于巳月，丙火本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '巳', exampleStem: '丙火',
    chengGe: '喜财护食（食神生财，源远流长）。',
    poGe: '枭神夺食（偏印克食神）、官杀克食。',
    xiangShen: '财星制枭护食。',
    meaning: '温和有才、享福厚禄、文艺餐饮。食神为福寿之神、衣食之神。',
  },
  {
    name: '伤官格', category: '正格', shishen: '伤官',
    monthlyRule: '月令本气为「伤官」（我生之异性天干透出）。如甲木日主生于午月，丁火本气透干。',
    exampleDayMaster: '甲木', exampleMonth: '午', exampleStem: '丁火',
    chengGe: '喜财化伤（伤官生财）、印制伤（伤官配印）。',
    poGe: '官星来冲（伤官见官，大凶，古云「伤官见官，为祸百端」）。',
    xiangShen: '财化伤 或 印制伤。',
    meaning: '聪明锋芒、叛逆创新、技艺专长。伤官为才智之神、但也主傲物犯上。',
  },
]

// ===== 外格（特殊格局）=====
export const WAI_GE: Geju[] = [
  {
    name: '从财格', category: '外格', shishen: '从',
    monthlyRule: '日主极弱无根无印，满盘财星成势，月令又为财 → 顺财之势。',
    exampleDayMaster: '任一日主', exampleMonth: '财月', exampleStem: '财星透',
    chengGe: '财星纯粹无破、无印比帮扶日主。',
    poGe: '见比劫印星助身（破从，反成身弱财多）。',
    xiangShen: '食伤生财、财旺。',
    meaning: '从财主富。顺命局最强之势，弃命从财，反主大富。',
  },
  {
    name: '从杀格', category: '外格', shishen: '从',
    monthlyRule: '日主极弱无根，满盘官杀成势，月令为官杀 → 顺杀之势。',
    exampleDayMaster: '任一日主', exampleMonth: '官杀月', exampleStem: '官杀透',
    chengGe: '官杀纯粹无食伤制、无印比助身。',
    poGe: '见食制杀或印化杀或比劫帮身（破从）。',
    xiangShen: '财党杀（财生杀使势更纯）。',
    meaning: '从杀主权贵。弃命从杀，反主大权、武职。',
  },
  {
    name: '从儿格', category: '外格', shishen: '从',
    monthlyRule: '日主极弱无根，满盘食伤成势 → 顺食伤之势（儿=我所生）。',
    exampleDayMaster: '任一日主', exampleMonth: '食伤月', exampleStem: '食伤透',
    chengGe: '食伤纯粹有财化（食伤生财），无印制。',
    poGe: '见印（印克食伤破从）。',
    xiangShen: '财星化食伤。',
    meaning: '从儿主才艺成名。顺食伤才智之势。',
  },
  {
    name: '化气格', category: '外格', shishen: '化',
    monthlyRule: '日干与月干（或时干）天干五合，且化神当令、日主无根 → 整局化成另一五行论命。',
    exampleDayMaster: '甲木合己土', exampleMonth: '辰戌丑未（土月）', exampleStem: '己土化',
    chengGe: '化神当令、日主失令无根、无克破（无官杀混）。',
    poGe: '见克破之神（化神被克）或日主有根（不化）。',
    xiangShen: '化神之生扶（生助化神之五行）。',
    meaning: '化气格主大格局、转型之命。化成之五行主导一生。',
  },
  {
    name: '专旺格（曲直格）', category: '外格', shishen: '专旺',
    monthlyRule: '满盘木气成势（甲乙寅卯辰/亥卯未全），日主为木，一行独旺不可逆。',
    exampleDayMaster: '甲/乙木', exampleMonth: '寅/卯', exampleStem: '木众',
    chengGe: '木势纯粹无金克破、有水生扶。',
    poGe: '见金克木（破专旺，反成群比争财）。',
    xiangShen: '水生木（顺势生扶）、火泄木（顺势泄秀）。',
    meaning: '曲直格主仁寿、刚直。一行专旺，顺势则吉，逆之则凶。',
  },
  {
    name: '建禄格', category: '外格', shishen: '比劫',
    monthlyRule: '月令为日主之「禄」（临官位）。如甲木日主生于寅月（甲木临官在寅）。',
    exampleDayMaster: '甲木', exampleMonth: '寅', exampleStem: '甲木',
    chengGe: '需有财官食伤成配，否则「建禄不富」。',
    poGe: '比劫过旺无财官食伤泄化。',
    xiangShen: '官制、财耗、食伤泄秀。',
    meaning: '建禄格主自立、兄弟多。需别处成格方主富贵。',
  },
]

export const ALL_GE: Geju[] = [...ZHENG_GE, ...WAI_GE]

/** 月支本气对应表（用于格局推导题） */
export const BRANCH_MAIN_STEM: Record<string, { stem: string; wuxing: string }> = {
  子: { stem: '癸', wuxing: '水' }, 丑: { stem: '己', wuxing: '土' },
  寅: { stem: '甲', wuxing: '木' }, 卯: { stem: '乙', wuxing: '木' },
  辰: { stem: '戊', wuxing: '土' }, 巳: { stem: '丙', wuxing: '火' },
  午: { stem: '丁', wuxing: '火' }, 未: { stem: '己', wuxing: '土' },
  申: { stem: '庚', wuxing: '金' }, 酉: { stem: '辛', wuxing: '金' },
  戌: { stem: '戊', wuxing: '土' }, 亥: { stem: '壬', wuxing: '水' },
}

/** 给定日主五行+月支本气五行+阴阳是否同 → 十神+格局名 */
export function computeShishenGeju(
  dmWx: string, tgWx: string, sameYy: boolean,
): { shishen: string; geju: string } {
  // Imported at runtime from advanced.ts via caller — using local refs for standalone data module
  const SHENG: Record<string, string> = { 木: '火', 火: '土', 土: '金', 金: '水', 水: '木' }
  const KE: Record<string, string> = { 木: '土', 土: '水', 水: '火', 火: '金', 金: '木' }

  let rel: string
  if (tgWx === dmWx) rel = '比劫'
  else if (SHENG[tgWx] === dmWx) rel = '印'
  else if (SHENG[dmWx] === tgWx) rel = '食伤'
  else if (KE[dmWx] === tgWx) rel = '财'
  else rel = '官杀'

  if (rel === '官杀') return { shishen: sameYy ? '七杀' : '正官', geju: sameYy ? '七杀格' : '正官格' }
  if (rel === '财')    return { shishen: sameYy ? '偏财' : '正财', geju: sameYy ? '偏财格' : '正财格' }
  if (rel === '印')    return { shishen: sameYy ? '偏印' : '正印', geju: sameYy ? '偏印格' : '正印格' }
  if (rel === '食伤')  return { shishen: sameYy ? '食神' : '伤官', geju: sameYy ? '食神格' : '伤官格' }
  return { shishen: sameYy ? '比肩' : '劫财', geju: '建禄/月劫格' }
}

/** 天干阴阳表 */
export const STEM_YINYANG: Record<string, string> = {
  甲: '阳', 乙: '阴', 丙: '阳', 丁: '阴', 戊: '阳', 己: '阴',
  庚: '阳', 辛: '阴', 壬: '阳', 癸: '阴',
}

