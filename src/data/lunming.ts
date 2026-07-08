// 子平命理两派论命流程对比数据

export interface LunmingStep {
  order: number
  title: string
  detail: string
}

export interface School {
  id: 'geju' | 'wangshuai' | 'tiaohou'
  name: string
  shortName: string
  core: string           // 核心思想
  classics: string       // 经典依据
  yongshenLogic: string  // 用神逻辑
  priority: string       // 优先级
  color: string
  steps: LunmingStep[]
}

// ===== 子平三书 =====
export interface Classic {
  title: string
  author: string
  school: string
  core: string
  role: string           // 比喻（立骨/布血/调温）
}

export const CLASSICS: Classic[] = [
  { title: '《子平真诠》', author: '清·沈孝瞻', school: '格局派', core: '系统论述八正格+外格的成败救应，月令用神（相神）为核心。', role: '立骨' },
  { title: '《滴天髓阐微》', author: '明·京图撰／清·任铁樵注', school: '旺衰派', core: '日主旺衰扶抑、五行流通、用神调平。任铁樵注疏是旺衰派奠基。', role: '布血' },
  { title: '《穷通宝鉴》', author: '清·余春台', school: '调候派', core: '按月令逐日主列调候用神，专讲寒暖燥湿平衡。又名《造化元钥》《栏江网》。', role: '调温' },
]

// ===== 调候用神速查（穷通宝鉴节选，用于学习页+题库）=====
export interface TiaohouItem {
  dm: string         // 日主
  season: string     // 季节/月令
  first: string      // 首用
  second: string     // 次用
  note: string       // 说明
}

export const TIAOHOU_TABLE: TiaohouItem[] = [
  // 甲乙木
  { dm: '甲/乙木', season: '春（寅卯月）', first: '丙火（暖）', second: '癸水（润）', note: '春木旺，需丙火暖展、癸水滋根。木旺不需扶，火泄秀为用。' },
  { dm: '甲/乙木', season: '夏（巳午月）', first: '癸水（润）', second: '丙火', note: '夏木燥渴，先用癸水润根救旱，否则木枯。' },
  { dm: '甲/乙木', season: '秋（申酉月）', first: '丁火（暖）', second: '庚/辛金', note: '秋木凋零，丁火暖之，金克木需制化。' },
  { dm: '甲/乙木', season: '冬（亥子月）', first: '丁火（暖）', second: '庚金', note: '冬木寒冻，先用丁火暖身解冻，否则木不生发。' },
  // 丙丁火
  { dm: '丙/丁火', season: '春', first: '甲/乙木（生扶）', second: '癸水', note: '春火不旺，需木生扶，少量癸水济火。' },
  { dm: '丙/丁火', season: '夏', first: '壬水（制火）', second: '庚金', note: '夏火太烈，急需壬水制火润局，否则火炎土燥。' },
  { dm: '丙/丁火', season: '秋', first: '甲木（生扶）', second: '壬水', note: '秋火渐弱，甲木生扶为主。' },
  { dm: '丙/丁火', season: '冬', first: '甲木（生扶）', second: '丙火', note: '冬火死绝，急需甲木生火，否则火灭。' },
  // 戊己土
  { dm: '戊/己土', season: '春', first: '丙火（暖）', second: '癸水（润）', note: '春土虚，丙火暖实、癸水滋润。' },
  { dm: '戊/己土', season: '夏', first: '壬水（润）', second: '丙火', note: '夏土燥裂，急需壬水润之。' },
  { dm: '戊/己土', season: '秋', first: '丙火（暖）', second: '癸水', note: '秋土渐寒，丙火暖之。' },
  { dm: '戊/己土', season: '冬', first: '丙火（暖）', second: '甲木', note: '冬土冻结，急需丙火暖解冻，甲木疏土。' },
  // 庚辛金
  { dm: '庚/辛金', season: '春', first: '土（生扶）', second: '丙火', note: '春金弱，需土生扶。' },
  { dm: '庚/辛金', season: '夏', first: '壬水（润）', second: '己土', note: '夏金受克，壬水制火护金。' },
  { dm: '庚/辛金', season: '秋', first: '壬水（泄秀）', second: '甲木', note: '秋金旺，壬水泄秀，金白水清。' },
  { dm: '庚/辛金', season: '冬', first: '丙火（暖）', second: '丁火', note: '冬金寒冻，急需丙火暖金，否则金寒不铸。' },
  // 壬癸水
  { dm: '壬/癸水', season: '春', first: '戊土（制水）', second: '丙火', note: '春水泛，戊土制之。' },
  { dm: '壬/癸水', season: '夏', first: '辛金（生源）', second: '壬水', note: '夏水竭，辛金生水。' },
  { dm: '壬/癸水', season: '秋', first: '甲木（泄秀）', second: '戊土', note: '秋水旺，甲木泄秀。' },
  { dm: '壬/癸水', season: '冬', first: '丙火（暖）', second: '戊土', note: '冬水结冰，急需丙火暖化解冻。' },
]

export const SCHOOLS: School[] = [
  {
    id: 'geju',
    name: '格局派',
    shortName: '格局',
    core: '以「月令格局」为命局骨架。格局决定命局主旋律，用神是为成就/保护格局服务的（相神）。',
    classics: '《子平真诠》《渊海子平》',
    yongshenLogic: '护格——保护格局不被破、补足成格条件之神。例：正官格遇伤官破→用印制伤护官。',
    priority: '结构优先：格局成败是命局骨架，骨架定下再论其他。',
    color: '#b85cd1',
    steps: [
      { order: 1, title: '排盘', detail: '排四柱八字 + 排大运 + 配十神、神煞。' },
      { order: 2, title: '定格局', detail: '看月令本气/中余气透干取格。八正格（正官/七杀/正财/偏财/正印/偏印/食神/伤官）或外格（从/化/专旺/建禄）。' },
      { order: 3, title: '论成败救应', detail: '成格=有相神护格；败格=有破格之神；救应=有神救破。判断命局结构是否成立。' },
      { order: 4, title: '定相神（用神）', detail: '相神=成就/保护格局的关键之神。如正官格用印护、七杀格用食制。' },
      { order: 5, title: '大运流年', detail: '行运到相神则发、到破神则败。看运势起伏。' },
      { order: 6, title: '断事', detail: '十神取象断六亲、事业、财运、健康。' },
    ],
  },
  {
    id: 'wangshuai',
    name: '旺衰派',
    shortName: '旺衰',
    core: '以「日主旺衰」为命局根本。日主强需抑、弱需扶，用神是平衡旺衰之神。',
    classics: '《滴天髓》《穷通宝鉴》',
    yongshenLogic: '扶抑——弱用印比扶、旺用官财食伤抑。加调候（寒暖失衡先调）+通关（对峙取中）。',
    priority: '力量优先：日主旺衰是定用神的根本依据。',
    color: '#3fa66a',
    steps: [
      { order: 1, title: '排盘', detail: '排四柱 + 配十神。' },
      { order: 2, title: '判旺衰', detail: '四维评分：得令（月令）+ 得地（通根）+ 得生扶（印比）+ 格局修正 → 身强/中和/身弱/从格。' },
      { order: 3, title: '扶抑取用', detail: '弱→用印比扶；旺→用官财食伤抑；从格→顺势。遇寒暖失衡先用调候，遇对峙用通关。' },
      { order: 4, title: '定喜忌', detail: '用神为药，喜神生用，忌神破用，仇神生忌。' },
      { order: 5, title: '大运流年', detail: '行运到喜用则吉、到忌仇则凶。' },
      { order: 6, title: '断事', detail: '十神取象断各方面。' },
    ],
  },
  {
    id: 'tiaohou',
    name: '调候派',
    shortName: '调候',
    core: '以「寒暖燥湿平衡」为首要。命局过寒需火暖、过燥需水润，调候用神优先于扶抑——体温不正常，谈什么骨架和力量。',
    classics: '《穷通宝鉴》（又名《造化元钥》《栏江网》）',
    yongshenLogic: '调候——按月令查该日主的调候喜用。冬月先暖、夏月先润，寒暖平衡后再论格局旺衰。例：甲木生于子月（冬寒）→ 先用丁火暖身解冻。',
    priority: '寒暖优先：命局过寒/过燥时，调候用神最急。气温失衡，结构再好、力量再足也发挥不出来。',
    color: '#3b7dd8',
    steps: [
      { order: 1, title: '排盘', detail: '排四柱 + 定日主 + 定月令季节。' },
      { order: 2, title: '判寒暖燥湿', detail: '看月令季节+命局五行：冬生水冷金寒、夏生火炎土燥。判断命局"温度"。' },
      { order: 3, title: '查调候用神', detail: '按月令查《穷通宝鉴》该日主的调候喜用。如冬月甲木先用丁火、夏月甲木先用癸水。' },
      { order: 4, title: '兼顾格局旺衰', detail: '调候用神确立后，再论格局成败、旺衰扶抑，综合定终用神。' },
      { order: 5, title: '大运流年', detail: '行运到调候之神则舒畅、到反调候（如寒命行水运）则郁。' },
      { order: 6, title: '断事', detail: '调候得宜则气血通畅、运势舒展。' },
    ],
  },
]

/** 三派对比维度 */
export interface ComparePoint {
  aspect: string
  geju: string
  wangshuai: string
  tiaohou: string
}

export const COMPARE_POINTS: ComparePoint[] = [
  { aspect: '核心', geju: '月令格局（结构）', wangshuai: '日主旺衰（力量）', tiaohou: '寒暖燥湿（温度）' },
  { aspect: '定用神', geju: '相神——护格之神', wangshuai: '扶抑——平衡之神', tiaohou: '调候——寒暖之神' },
  { aspect: '优先级', geju: '先看格局成败', wangshuai: '先判身强身弱', tiaohou: '先看寒暖燥湿' },
  { aspect: '经典', geju: '《子平真诠》', wangshuai: '《滴天髓阐微》', tiaohou: '《穷通宝鉴》' },
  { aspect: '比喻', geju: '立骨（骨架）', wangshuai: '布血（肌肉）', tiaohou: '调温（体温）' },
  { aspect: '同八字结论', geju: '从结构取用', wangshuai: '从平衡取用', tiaohou: '从寒暖取用' },
]

/** 现代融合做法（三派合参） */
export const MODERN_FUSION: string[] = [
  '先扫一眼有无明显格局（成格？破格？）——格局派视角（立骨）',
  '同时判旺衰（身强身弱四维评分）——旺衰派视角（布血）',
  '再看寒暖燥湿——调候派视角（调温）。生于冬月水冷金寒、夏月火炎土燥的，先查《穷通宝鉴》调候用神',
  '取用神时三兼顾：护格局 + 调旺衰 + 调寒暖。三派冲突时，寒暖最急（体温不正常谈其他都白搭），其次护格，再次扶抑',
  '口诀：真诠立骨、滴天布血、宝鉴调温——三书合参方为全功',
  '初学者建议：先掌握旺衰派（清晰可量化），再补格局派（精确取用），最后查调候（寒暖失衡时必查）',
]

/** 学习路径建议 */
export const LEARNING_PATH: { phase: string; content: string }[] = [
  { phase: '基础', content: '天干地支、十神、藏干、地支关系' },
  { phase: '旺衰', content: '四维评分、扶抑取用（旺衰派核心）' },
  { phase: '格局', content: '八正格+外格、成败救应（格局派核心，《子平真诠》）' },
  { phase: '调候', content: '《穷通宝鉴》逐月调候用神' },
  { phase: '断事', content: '十神取象 + 大运流年 + 实战' },
]

/** 经典案例（用于学习页 + 用神题） */
export interface ClassicCase {
  id: string
  title: string
  bazi: string          // 八字
  dayMaster: string
  monthBranch: string
  analysis: string      // 共同分析
  gejuSchool: { geju: string; yongshen: string; reason: string }
  wangshuaiSchool: { strength: string; yongshen: string; reason: string }
  compare: string       // 两派差异点
}

export const CLASSIC_CASES: ClassicCase[] = [
  {
    id: 'case-1',
    title: '七杀格 · 甲木申月',
    bazi: '辛酉 庚申 甲寅 丙寅',
    dayMaster: '甲', monthBranch: '申',
    analysis: '甲木日主，生于申月（秋，木死）。天干庚辛金（官杀）极旺克身。日支寅、时支寅为甲木之根。',
    gejuSchool: {
      geju: '七杀格（月令申，庚金七杀透干）',
      yongshen: '食神（丙火）制杀',
      reason: '七杀格喜食神制杀或印化杀。命局有丙火（食神）透时干，可制庚金七杀，构成「食神制杀」之成格。相神=食神丙火。',
    },
    wangshuaiSchool: {
      strength: '身弱（申月木死、官杀克身重，虽有寅根但被申冲）',
      yongshen: '印（水）化杀生身',
      reason: '身弱需扶。官杀旺克身，最宜用印（水）化杀生身——既泄了杀的凶性，又生扶日主。',
    },
    compare: '格局派用食神（制杀护格），旺衰派用印（化杀扶身）。两者都化解了七杀的威胁，但出发点不同：一个是护格，一个是平衡。',
  },
  {
    id: 'case-2',
    title: '正官格 · 甲木酉月',
    bazi: '癸未 辛酉 甲子 丙寅',
    dayMaster: '甲', monthBranch: '酉',
    analysis: '甲木日主，生于酉月（秋，木死但金旺）。月令酉，辛金正官透月干。日支子（印星）、时支寅（甲木根）。',
    gejuSchool: {
      geju: '正官格（月令酉，辛金正官透干）',
      yongshen: '印（癸水）护官',
      reason: '正官格喜财生印护。命局癸水（正印）透年干，子水（印）坐日支，构成「官印相生」之大贵格。相神=印星癸/子水。',
    },
    wangshuaiSchool: {
      strength: '身弱（酉月木死、官星克身，虽有寅根但远）',
      yongshen: '印（水）生身',
      reason: '身弱需印比扶。印（癸/子水）既生扶日主，又泄官星之气，一举两得。',
    },
    compare: '两派此例殊途同归——都用印。但理由不同：格局派是「护官成贵格」，旺衰派是「扶弱平衡」。结论同，逻辑异。',
  },
]
