// 姓名学 · 五格剖象法（熊崎式）
// 注意：这是独立的姓名数理体系，≠ 八字命理

export type Luck = '吉' | '凶' | '半吉'

export interface WuGe {
  name: string
  meaning: string       // 含义
  algorithm: string     // 算法（单姓）
  yun: string           // 运势
}

export const WU_GE: WuGe[] = [
  { name: '天格', meaning: '祖上、父母、早年。先天注定不可改，对个人影响较弱。', algorithm: '姓氏笔画 + 1', yun: '先天运（参考）' },
  { name: '人格', meaning: '主运，命局核心。代表性格、中年运势、能力。', algorithm: '姓氏笔画 + 名字首字笔画', yun: '主运（核心）' },
  { name: '地格', meaning: '前运。代表青年、子女、下属。', algorithm: '名字笔画之和 + 1（单字名）；多字名取名字笔画和', yun: '前运' },
  { name: '外格', meaning: '副运。代表社交、外围人际、贵人。', algorithm: '总格 - 人格 + 1（单姓单名恒为2）', yun: '副运' },
  { name: '总格', meaning: '后运。代表晚年、整体归宿。', algorithm: '所有字笔画之和', yun: '后运（整体）' },
]

/** 笔画尾数 → 五行 */
export const STROKE_WUXING: Record<number, string> = {
  1: '木', 2: '木', 3: '火', 4: '火', 5: '土',
  6: '土', 7: '金', 8: '金', 9: '水', 0: '水',
}

/** 笔画数 → 五行（取尾数） */
export function strokeToWuxing(n: number): string {
  return STROKE_WUXING[n % 10]
}

// ===== 81 数理吉凶表（全 81 条）=====
export interface Shuli {
  num: number
  luck: Luck
  keyword: string    // 关键词
  meaning: string    // 含义
}

export const SHULI_81: Shuli[] = [
  { num: 1, luck: '吉', keyword: '万物开泰', meaning: '万事万物起始之数，主独立权威、首领之相。' },
  { num: 2, luck: '凶', keyword: '两仪之数', meaning: '动摇不安、一荣一枯，主分离破败、内外不和。' },
  { num: 3, luck: '吉', keyword: '三才之数', meaning: '天地人三才具备，主福禄双全、进取如意。' },
  { num: 4, luck: '凶', keyword: '分离破败', meaning: '分离之象，主孤独、破灭、家道中落。' },
  { num: 5, luck: '吉', keyword: '种竹成林', meaning: '福禄长寿，主富贵荣华、福泽绵长。' },
  { num: 6, luck: '吉', keyword: '六爻之数', meaning: '吉人天相，主安稳、天德贵人相助。' },
  { num: 7, luck: '吉', keyword: '七政之数', meaning: '精悍权威，主刚毅果断、独立自营。' },
  { num: 8, luck: '吉', keyword: '八卦之数', meaning: '意志坚强，主勤奋、功成名就。' },
  { num: 9, luck: '凶', keyword: '破舟进海', meaning: '破败之象，主多灾多难、家破人散。' },
  { num: 10, luck: '凶', keyword: '零暗万事', meaning: '终局黑暗，主一事无成、孤独终老。' },
  { num: 11, luck: '吉', keyword: '稳健吉顺', meaning: '稳如泰山，主成家立业、顺风顺水。' },
  { num: 12, luck: '凶', keyword: '薄弱无力', meaning: '无力薄弱，主孤寡、易生挫折。' },
  { num: 13, luck: '吉', keyword: '春日牡丹', meaning: '智谋出众，主才华横溢、博得名利。' },
  { num: 14, luck: '凶', keyword: '破兆浮沉', meaning: '破兆浮沉，主孤独、离别、亲情缘薄。' },
  { num: 15, luck: '吉', keyword: '福寿双全', meaning: '福寿圆满，主富贵、长寿、立业兴家。' },
  { num: 16, luck: '吉', keyword: '厚重载德', meaning: '贵人相助，主大业成就、富贵双全。' },
  { num: 17, luck: '吉', keyword: '刚毅果断', meaning: '突破万难，主刚毅、功成名就。' },
  { num: 18, luck: '吉', keyword: '铁镜重磨', meaning: '有志竟成，主意志坚强、终成大器。' },
  { num: 19, luck: '凶', keyword: '多遮风雨', meaning: '遮云蔽月，主多灾、病弱、辛苦。' },
  { num: 20, luck: '凶', keyword: '屋下藏金', meaning: '破灭衰败，主家道衰、短寿、破财。' },
  { num: 21, luck: '吉', keyword: '明月光照', meaning: '光华灿灿，主独立权威、首领之格。' },
  { num: 22, luck: '凶', keyword: '秋草逢霜', meaning: '百事不如意，主挫折、中途夭折。' },
  { num: 23, luck: '吉', keyword: '壮丽果敢', meaning: '旭日东升，主气势旺盛、大业成就。' },
  { num: 24, luck: '吉', keyword: '家门余庆', meaning: '金钱丰盈，主家门富贵、子孙荫庇。' },
  { num: 25, luck: '吉', keyword: '英俊刚毅', meaning: '资性英敏，主才能出众、性格刚毅。' },
  { num: 26, luck: '凶', keyword: '变怪奇异', meaning: '波澜起伏，主波折、英雄气短。' },
  { num: 27, luck: '凶', keyword: '欲望无止', meaning: '欲望太强，主自大、多灾、半途中折。' },
  { num: 28, luck: '凶', keyword: '阔水浮萍', meaning: '豪杰气概，主遭难、孤独、配偶不利。' },
  { num: 29, luck: '吉', keyword: '泉舟顺展', meaning: '智谋优秀，主财力归命、归顺大吉。' },
  { num: 30, luck: '凶', keyword: '浮沉不定', meaning: '绝死逢生，主浮沉、多变、不得安宁。' },
  { num: 31, luck: '吉', keyword: '春日花开', meaning: '智勇得志，主富贵、心性健全、大吉。' },
  { num: 32, luck: '吉', keyword: '宝马金鞍', meaning: '侥幸多望，主贵人提携、财源广进。' },
  { num: 33, luck: '吉', keyword: '升天之火', meaning: '旭日升天，主权威旺盛、刚毅果断。' },
  { num: 34, luck: '凶', keyword: '破家破业', meaning: '破家破业，主灾难频生、家业凋零。' },
  { num: 35, luck: '吉', keyword: '高楼望月', meaning: '温和平静，主优雅、稳健、有余裕。' },
  { num: 36, luck: '凶', keyword: '波澜重叠', meaning: '波澜重叠，主辛苦、漂浮、英雄无用武。' },
  { num: 37, luck: '吉', keyword: '猛虎出林', meaning: '权威显达，主独立、单枪匹马成大业。' },
  { num: 38, luck: '半吉', keyword: '磨铁成针', meaning: '意志薄弱，主努力可成、半好半坏。' },
  { num: 39, luck: '吉', keyword: '富贵繁荣', meaning: '富贵至极，主平安、福寿绵长。' },
  { num: 40, luck: '凶', keyword: '退安享福', meaning: '退安享福，主盛极转衰、宜退守。' },
  { num: 41, luck: '吉', keyword: '德望高大', meaning: '纯阳独秀，主德望、名利双收、大吉。' },
  { num: 42, luck: '凶', keyword: '寒蝉在柳', meaning: '十事不成，主博学多能但难成大事。' },
  { num: 43, luck: '凶', keyword: '散财破产', meaning: '散财之象，主破财、事业难成。' },
  { num: 44, luck: '凶', keyword: '烦闷懊恼', meaning: '破家亡身，主家破、身危、多愁。' },
  { num: 45, luck: '吉', keyword: '顺风挂帆', meaning: '新生泰然，主顺风得意、大业成就。' },
  { num: 46, luck: '凶', keyword: '载宝沉舟', meaning: '破船载宝，主破财、载难、中途受挫。' },
  { num: 47, luck: '吉', keyword: '点铁成金', meaning: '开花结果，主权威、富贵、开花结实。' },
  { num: 48, luck: '吉', keyword: '青松立鹤', meaning: '智谋兼备，主德望、功名、青史留名。' },
  { num: 49, luck: '凶', keyword: '吉凶难分', meaning: '吉凶参半，主先吉后凶、转赋变动。' },
  { num: 50, luck: '凶', keyword: '吉凶互见', meaning: '一成一败，主成败起伏、晚景凄凉。' },
  { num: 51, luck: '半吉', keyword: '一盛一衰', meaning: '盛衰参半，主浮沉、需靠自力。' },
  { num: 52, luck: '吉', keyword: '眼望星辰', meaning: '先见之明，主眼光远大、大业成就。' },
  { num: 53, luck: '凶', keyword: '忧愁困苦', meaning: '内忧外患，主多愁、多苦、难发展。' },
  { num: 54, luck: '凶', keyword: '多难悲运', meaning: '难成之象，主难成、辛苦、家庭破裂。' },
  { num: 55, luck: '凶', keyword: '外美内苦', meaning: '外祥内苦，主外表光鲜内里愁苦。' },
  { num: 56, luck: '凶', keyword: '浪里孤舟', meaning: '浪里孤舟，主漂浮、无依、晚景凄凉。' },
  { num: 57, luck: '吉', keyword: '寒雪青松', meaning: '寒松青翠，主努力达成、寒门贵子。' },
  { num: 58, luck: '半吉', keyword: '晚行遇福', meaning: '先苦后甘，主晚景好转、晚福绵长。' },
  { num: 59, luck: '凶', keyword: '寒蝉悲啼', meaning: '无能无谋，主毫无作为、意气消沉。' },
  { num: 60, luck: '凶', keyword: '无谋之人', meaning: '黑暗无光，主无谋、破败、孤苦。' },
  { num: 61, luck: '吉', keyword: '名利双收', meaning: '名利双收，主荣耀、富贵、昌隆。' },
  { num: 62, luck: '凶', keyword: '衰败孤独', meaning: '衰败孤独，主孤独、衰败、无成。' },
  { num: 63, luck: '吉', keyword: '万物化育', meaning: '万物育化，主富贵、繁荣、舟归平岸。' },
  { num: 64, luck: '凶', keyword: '骨肉分离', meaning: '骨肉分离，主离散、家破、孤独。' },
  { num: 65, luck: '吉', keyword: '富贵至极', meaning: '富贵长寿，主大富贵、福寿绵长。' },
  { num: 66, luck: '凶', keyword: '暗黑浮沉', meaning: '暗黑浮沉，主浮沉、多变、愁苦。' },
  { num: 67, luck: '吉', keyword: '通达畅旺', meaning: '长命富贵，主事业通达、财禄丰厚。' },
  { num: 68, luck: '吉', keyword: '兴旺立业', meaning: '智慧兴起，主立业、智慧、家业兴旺。' },
  { num: 69, luck: '凶', keyword: '非业破运', meaning: '非业破运，主破败、家散、坐立不定。' },
  { num: 70, luck: '凶', keyword: '废颓不振', meaning: '废颓家运，主家运衰、凄凉、无聊。' },
  { num: 71, luck: '半吉', keyword: '劳神费力', meaning: '劳碌无功，主劳碌、半成半败。' },
  { num: 72, luck: '凶', keyword: '先甘后苦', meaning: '先甘后苦，主先甜后苦、晚景凄惨。' },
  { num: 73, luck: '半吉', keyword: '忧心劳神', meaning: '志高力微，主心比天高、命比纸薄。' },
  { num: 74, luck: '凶', keyword: '秋叶落寞', meaning: '无能孤独，主无能、孤独、家业荒废。' },
  { num: 75, luck: '半吉', keyword: '退守安静', meaning: '退守可安，主退则吉、进则凶。' },
  { num: 76, luck: '凶', keyword: '倾覆离散', meaning: '倾覆离散，主破家、离散、大凶。' },
  { num: 77, luck: '半吉', keyword: '先苦后甘', meaning: '前凶后吉，主前半生苦、后半生好转。' },
  { num: 78, luck: '凶', keyword: '晚景不遇', meaning: '晚景不遇，主晚景萧条、壮志难酬。' },
  { num: 79, luck: '凶', keyword: '挽回乏力', meaning: '挽回乏力，主身衰、家败、无能为力。' },
  { num: 80, luck: '凶', keyword: '凶星入命', meaning: '最凶之数，主家破人亡、凶灾横祸。' },
  { num: 81, luck: '吉', keyword: '万物回春', meaning: '最吉之数，主还本归元、大吉大利。' },
]

/** 查某数吉凶 */
export function getShuli(n: number): Shuli {
  const num = ((n - 1) % 80) + 1  // 超过81取余（81以上回到1）
  return SHULI_81.find((s) => s.num === num) ?? SHULI_81[0]
}

// ===== 三才配置（天/人/地五行组合）=====
export interface SancaiConfig {
  pattern: string       // '木火土'
  luck: Luck
  meaning: string
}

// 常见配置（连续相生为大吉、连续相克为大凶）
export const SANCAI_CONFIGS: SancaiConfig[] = [
  // 大吉（连续相生）
  { pattern: '木→火→土', luck: '吉', meaning: '木生火、火生土，三才连续相生，大吉。主顺遂、福泽绵长。' },
  { pattern: '火→土→金', luck: '吉', meaning: '火生土、土生金，连续相生，大吉。主稳健、名利双收。' },
  { pattern: '土→金→水', luck: '吉', meaning: '土生金、金生水，连续相生，大吉。主智慧、财源广进。' },
  { pattern: '金→水→木', luck: '吉', meaning: '金生水、水生木，连续相生，大吉。主进取、生机勃勃。' },
  { pattern: '水→木→火', luck: '吉', meaning: '水生木、木生火，连续相生，大吉。主发展、事业兴旺。' },
  // 大凶（连续相克）
  { pattern: '水→火→金', luck: '凶', meaning: '水克火、火克金，连续相克，大凶。主多病、是非、动荡。' },
  { pattern: '火→金→木', luck: '凶', meaning: '火克金、金克木，连续相克，大凶。主破败、刑伤。' },
  { pattern: '木→土→水', luck: '凶', meaning: '木克土、土克水，连续相克，凶。主家庭不和、事业受阻。' },
  { pattern: '金→木→土', luck: '凶', meaning: '金克木、木克土，连续相克，凶。主孤克、骨肉缘薄。' },
]

// ===== 争议与边界说明 =====
export const CONTROVERSY: string[] = [
  '起源：日本熊崎健翁 1928 年发明，非中国古典传承。中国古代有数理思想，但五格剖象法是近代成型体系。',
  '只看笔画，不看字义字音：「死」「病」等字若笔画凑成吉数，按五格也算好名——明显不合理。',
  '脱离个人八字：完全不考虑命主的生辰喜忌，名字好坏与八字无关。',
  '同音不同字差异大：「张三」和「张叁」笔画不同，吉凶结论却差很多。',
  '正统命理界评价：多作「软参考」使用，不作核心依据。起名公司流行是因为它好算、好卖、能标准化。',
  '正确用法：八字定喜用（决定补什么五行）→ 选字满足八字 → 同时算五格尽量让核心格（人格/地格/总格）落吉数。八字为里，五格为表。',
]

/** 与八字的关系 */
export const RELATION_TO_BAZI: string =
  '八字看「生辰」定喜用五行（决定名字该补什么），五格看「名字笔画」断数理吉凶。两者是平行系统：八字是"该补什么"，五格是"名字数字好不好看"。现代起名常两者并用——以八字喜用为先，五格作软约束。'
