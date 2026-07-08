import type { Dizhi } from './types'

// 十二地支：万物年循环的12帧（叠生肖+时辰+藏干）
// 寅卯木 · 巳午火 · 申酉金 · 亥子水 · 辰戌丑未土
export const DIZHI: Dizhi[] = [
  {
    char: '子', pinyin: 'zǐ', order: 1, yinyang: '阳', wuxing: '水',
    season: '冬', animal: '鼠', hour: '23:00–01:00',
    category: '四正', isPure: true,
    canggan: [{ stem: '癸', wuxing: '水', level: '主' }],
    etymology: {
      guhu: '甲骨文像婴儿——大脑袋、挥动小手脚，或襁褓之形',
      shuowen: '十一月，阳气动，万物滋。',
      benyi: '婴儿。引申子嗣、种子、滋生。',
      whyChosen: '子=滋。十一月（冬至）一阳初动，万物如婴儿在地下滋生。子时=半夜，正是一日阳气初生之刻。',
    },
    memory: '子=滋（滋生）/ 孩子。冬至半夜，种子在地下偷偷动了。鼠夜半最活跃、繁殖爆表=生机启动。',
  },
  {
    char: '丑', pinyin: 'chǒu', order: 2, yinyang: '阴', wuxing: '土',
    season: '冬', animal: '牛', hour: '01:00–03:00',
    category: '四库', isPure: false,
    canggan: [
      { stem: '己', wuxing: '土', level: '主' },
      { stem: '癸', wuxing: '水', level: '中' },
      { stem: '辛', wuxing: '金', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像一只手（手指弯曲抓握）——丑是"扭/手"本字',
      shuowen: '纽也。象手之形。',
      benyi: '手扭动。通"纽"（系结）、"扭"。',
      whyChosen: '十二月嫩芽在土里"扭着劲"想出来却还没出，像手被捆、纽结难解。冬之尾，土主转换，属阴。',
    },
    memory: '丑=扭/纽。嫩芽在土里扭着挣扎，想出没出。牛反刍犁地，憋着闷劲。冬尾=金库（巳酉丑合金）。',
  },
  {
    char: '寅', pinyin: 'yín', order: 3, yinyang: '阳', wuxing: '木',
    season: '春', animal: '虎', hour: '03:00–05:00',
    category: '四生', isPure: false,
    canggan: [
      { stem: '甲', wuxing: '木', level: '主' },
      { stem: '丙', wuxing: '火', level: '中' },
      { stem: '戊', wuxing: '土', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像箭矢射出，或人弯腰向前引行',
      shuowen: '正月阳气动，去黄泉，欲上出。',
      benyi: '通"引、演"，引出、导引。',
      whyChosen: '正月阳气终于被"引"出地面，万物破土。寅是岁之首、春之始。破土冲劲属阳。',
    },
    memory: '寅=引（引出）。春天阳气被引出地面，万物破土。虎的凶猛冲劲=破土生发。岁首从寅起。',
  },
  {
    char: '卯', pinyin: 'mǎo', order: 4, yinyang: '阴', wuxing: '木',
    season: '春', animal: '兔', hour: '05:00–07:00',
    category: '四正', isPure: true,
    canggan: [{ stem: '乙', wuxing: '木', level: '主' }],
    etymology: {
      guhu: '甲骨文像两扇打开的门——卯即门枢、开门之象',
      shuowen: '冒也。象开门之形。故二月为天门。',
      benyi: '通"冒"（冒出）、开门。',
      whyChosen: '二月万物"冒"地而出，像开门一样打开。卯时=日出，开门出门。木气纯正居仲春，柔顺属阴。',
    },
    memory: '卯=冒/开门。二月万物冒地而出，日出开门。兔繁殖快、活泼=成片冒出。纯木，只藏乙。',
  },
  {
    char: '辰', pinyin: 'chén', order: 5, yinyang: '阳', wuxing: '土',
    season: '春', animal: '龙', hour: '07:00–09:00',
    category: '四库', isPure: false,
    canggan: [
      { stem: '戊', wuxing: '土', level: '主' },
      { stem: '乙', wuxing: '木', level: '中' },
      { stem: '癸', wuxing: '水', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像大蛤蜊（蜃），或手持农具',
      shuowen: '震也。三月阳气动，雷电震，民农时也。',
      benyi: '震动；农时。通"蜃"。',
      whyChosen: '三月春雷震动，万物惊醒振动着猛长；也是农事开始。春之尾，土主转换，刚动属阳。',
    },
    memory: '辰=震（春雷）/ 农时。春雷一响万物振动猛长。龙行云布雨润物。春尾=水库（申子辰合水）。',
  },
  {
    char: '巳', pinyin: 'sì', order: 6, yinyang: '阴', wuxing: '火',
    season: '夏', animal: '蛇', hour: '09:00–11:00',
    category: '四生', isPure: false,
    canggan: [
      { stem: '丙', wuxing: '火', level: '主' },
      { stem: '庚', wuxing: '金', level: '中' },
      { stem: '戊', wuxing: '土', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像胎儿（盘曲的婴形），也像蛇盘曲',
      shuowen: '已也。四月阳气已出，阴气已藏，万物见，成文章。',
      benyi: '通"已"（已经），胎儿已成。',
      whyChosen: '四月阳气尽出，万物如胎儿已成形。夏初，火气渐盛，柔顺成形属阴。',
    },
    memory: '巳=已（已经）。注意开口己(天干)、半口已、闭口巳(地支)。蛇盘曲如胎、蜕皮蜕变。',
  },
  {
    char: '午', pinyin: 'wǔ', order: 7, yinyang: '阳', wuxing: '火',
    season: '夏', animal: '马', hour: '11:00–13:00',
    category: '四正', isPure: true,
    canggan: [
      { stem: '丁', wuxing: '火', level: '主' },
      { stem: '己', wuxing: '土', level: '中' },
    ],
    etymology: {
      guhu: '甲骨文像舂米的杵（午=杵本字），或交叉线条',
      shuowen: '啎也。五月阴气午逆阳，冒地而出。',
      benyi: '通"啎/忤"（抵触、交错）。阴阳相交抵触。',
      whyChosen: '五月阳气到顶、阴气始生，是阴阳交战、阳极转阴的转折。午时=正午，日中阳极。火气纯正刚烈属阳。',
    },
    memory: '午=忤（阴阳交战）。阳气到顶转阴的转折点。正午烈日。马奔腾刚烈。纯火(带己土，火生土)。',
  },
  {
    char: '未', pinyin: 'wèi', order: 8, yinyang: '阴', wuxing: '土',
    season: '夏', animal: '羊', hour: '13:00–15:00',
    category: '四库', isPure: false,
    canggan: [
      { stem: '己', wuxing: '土', level: '主' },
      { stem: '丁', wuxing: '火', level: '中' },
      { stem: '乙', wuxing: '木', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像树木枝叶重重（木上加枝叶），有"还未全成"之意',
      shuowen: '味也。六月滋味也。象木重枝叶也。',
      benyi: '通"味"（滋味）；也有"未然"（还没）之义。',
      whyChosen: '六月万物渐熟有滋味，但"还未"完全成熟——过渡中的将熟未熟。夏之尾，土主转换，柔顺属阴。',
    },
    memory: '未=味（滋味）/ 还没。将熟未熟的过渡。羊吃成熟草、温顺。夏尾=木库（亥卯未合木）。',
  },
  {
    char: '申', pinyin: 'shēn', order: 9, yinyang: '阳', wuxing: '金',
    season: '秋', animal: '猴', hour: '15:00–17:00',
    category: '四生', isPure: false,
    canggan: [
      { stem: '庚', wuxing: '金', level: '主' },
      { stem: '壬', wuxing: '水', level: '中' },
      { stem: '戊', wuxing: '土', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像闪电（曲折电光）——申是"电/神"本字',
      shuowen: '神也。七月阴气成，体自申束。',
      benyi: '闪电（通"电、神"）。引申伸展（申=伸）。',
      whyChosen: '七月万物身体"伸"展到极点、完全长成定型。秋初，金气始肃，伸展至满属阳。',
    },
    memory: '申=伸（伸展）/ 电。万物身体完全长成。猴身手舒展灵巧。秋初金气始起。',
  },
  {
    char: '酉', pinyin: 'yǒu', order: 10, yinyang: '阴', wuxing: '金',
    season: '秋', animal: '鸡', hour: '17:00–19:00',
    category: '四正', isPure: true,
    canggan: [{ stem: '辛', wuxing: '金', level: '主' }],
    etymology: {
      guhu: '甲骨文像酒坛子（窄颈鼓腹的器皿）',
      shuowen: '就也。八月黍成，可为酎酒。',
      benyi: '酒器。通"就"（成就、成熟）。',
      whyChosen: '八月黍米成熟可以酿酒，万物成熟饱满如酒。酉时=日落，收获归家。金气纯正，柔秀属阴。',
    },
    memory: '酉=就/酒。八月庄稼成熟酿酒，日落归家收工。鸡归巢。纯金，只藏辛。',
  },
  {
    char: '戌', pinyin: 'xū', order: 11, yinyang: '阳', wuxing: '土',
    season: '秋', animal: '狗', hour: '19:00–21:00',
    category: '四库', isPure: false,
    canggan: [
      { stem: '戊', wuxing: '土', level: '主' },
      { stem: '辛', wuxing: '金', level: '中' },
      { stem: '丁', wuxing: '火', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像宽刃戈斧（与戊形近但有别），兵器带肃杀气',
      shuowen: '灭也。九月阳气微，万物毕成，阳下入地。',
      benyi: '通"灭"（衰灭）。',
      whyChosen: '九月阳气下沉入地，万物凋零衰灭。秋之尾，土主转换，肃杀归地属阳。',
    },
    memory: '戌=灭（衰灭）。读"虚"——别和戊(物)混，戌中横、戊中空。秋尾万物凋零。狗守夜。=火库(寅午戌合火)。',
  },
  {
    char: '亥', pinyin: 'hài', order: 12, yinyang: '阴', wuxing: '水',
    season: '冬', animal: '猪', hour: '21:00–23:00',
    category: '四生', isPure: false,
    canggan: [
      { stem: '壬', wuxing: '水', level: '主' },
      { stem: '甲', wuxing: '木', level: '余' },
    ],
    etymology: {
      guhu: '甲骨文像猪（豕），或像草根（荄）',
      shuowen: '荄也。十月微阳起，接盛阴。',
      benyi: '通"荄"（草根、归藏）；也通"豕"（猪）。',
      whyChosen: '十月万物归藏于根核，能量封进种子——亥=藏、归核。亥时=夜深，年终归藏之极。柔静属阴。',
    },
    memory: '亥=荄(草根)/藏/豕(猪)。年终万物归藏入库，种子藏根核。猪肥满储脂=储藏最足。',
  },
]
