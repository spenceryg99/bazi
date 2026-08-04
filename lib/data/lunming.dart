class LunmingStep {
  final int order;
  final String title;
  final String detail;
  const LunmingStep(this.order, this.title, this.detail);
}

class School {
  final String id;
  final String name;
  final String shortName;
  final String core;
  final String classics;
  final String yongshenLogic;
  final String priority;
  final int color;
  final List<LunmingStep> steps;
  const School({
    required this.id,
    required this.name,
    required this.shortName,
    required this.core,
    required this.classics,
    required this.yongshenLogic,
    required this.priority,
    required this.color,
    required this.steps,
  });
}

class Classic {
  final String title;
  final String author;
  final String school;
  final String core;
  final String role;
  const Classic(this.title, this.author, this.school, this.core, this.role);
}

const classics = <Classic>[
  Classic('《子平真诠》', '清·沈孝瞻', '格局派', '系统论述八正格+外格的成败救应，月令用神（相神）为核心。', '立骨'),
  Classic('《滴天髓阐微》', '明·京图撰／清·任铁樵注', '旺衰派', '日主旺衰扶抑、五行流通、用神调平。任铁樵注疏是旺衰派奠基。', '布血'),
  Classic('《穷通宝鉴》', '清·余春台', '调候派', '按月令逐日主列调候用神，专讲寒暖燥湿平衡。又名《造化元钥》《栏江网》。', '调温'),
];

class TiaohouItem {
  final String dm;
  final String season;
  final String first;
  final String second;
  final String note;
  const TiaohouItem(this.dm, this.season, this.first, this.second, this.note);
}

const tiaohouTable = <TiaohouItem>[
  TiaohouItem('甲/乙木', '春（寅卯月）', '丙火（暖）', '癸水（润）', '春木旺，需丙火暖展、癸水滋根。木旺不需扶，火泄秀为用。'),
  TiaohouItem('甲/乙木', '夏（巳午月）', '癸水（润）', '丙火', '夏木燥渴，先用癸水润根救旱，否则木枯。'),
  TiaohouItem('甲/乙木', '秋（申酉月）', '丁火（暖）', '庚/辛金', '秋木凋零，丁火暖之，金克木需制化。'),
  TiaohouItem('甲/乙木', '冬（亥子月）', '丁火（暖）', '庚金', '冬木寒冻，先用丁火暖身解冻，否则木不生发。'),
  TiaohouItem('丙/丁火', '春', '甲/乙木（生扶）', '癸水', '春火不旺，需木生扶，少量癸水济火。'),
  TiaohouItem('丙/丁火', '夏', '壬水（制火）', '庚金', '夏火太烈，急需壬水制火润局，否则火炎土燥。'),
  TiaohouItem('丙/丁火', '秋', '甲木（生扶）', '壬水', '秋火渐弱，甲木生扶为主。'),
  TiaohouItem('丙/丁火', '冬', '甲木（生扶）', '丙火', '冬火死绝，急需甲木生火，否则火灭。'),
  TiaohouItem('戊/己土', '春', '丙火（暖）', '癸水（润）', '春土虚，丙火暖实、癸水滋润。'),
  TiaohouItem('戊/己土', '夏', '壬水（润）', '丙火', '夏土燥裂，急需壬水润之。'),
  TiaohouItem('戊/己土', '秋', '丙火（暖）', '癸水', '秋土渐寒，丙火暖之。'),
  TiaohouItem('戊/己土', '冬', '丙火（暖）', '甲木', '冬土冻结，急需丙火暖解冻，甲木疏土。'),
  TiaohouItem('庚/辛金', '春', '土（生扶）', '丙火', '春金弱，需土生扶。'),
  TiaohouItem('庚/辛金', '夏', '壬水（润）', '己土', '夏金受克，壬水制火护金。'),
  TiaohouItem('庚/辛金', '秋', '壬水（泄秀）', '甲木', '秋金旺，壬水泄秀，金白水清。'),
  TiaohouItem('庚/辛金', '冬', '丙火（暖）', '丁火', '冬金寒冻，急需丙火暖金，否则金寒不铸。'),
  TiaohouItem('壬/癸水', '春', '戊土（制水）', '丙火', '春水泛，戊土制之。'),
  TiaohouItem('壬/癸水', '夏', '辛金（生源）', '壬水', '夏水竭，辛金生水。'),
  TiaohouItem('壬/癸水', '秋', '甲木（泄秀）', '戊土', '秋水旺，甲木泄秀。'),
  TiaohouItem('壬/癸水', '冬', '丙火（暖）', '戊土', '冬水结冰，急需丙火暖化解冻。'),
];

const schools = <School>[
  School(
    id: 'geju', name: '格局派', shortName: '格局',
    core: '以「月令格局」为命局骨架。格局决定命局主旋律，用神是为成就/保护格局服务的（相神）。',
    classics: '《子平真诠》《渊海子平》',
    yongshenLogic: '护格——保护格局不被破、补足成格条件之神。例：正官格遇伤官破→用印制伤护官。',
    priority: '结构优先：格局成败是命局骨架，骨架定下再论其他。',
    color: 0xFFB85CD1,
    steps: [
      LunmingStep(1, '排盘', '排四柱八字 + 排大运 + 配十神、神煞。'),
      LunmingStep(2, '定格局', '看月令本气/中余气透干取格。八正格（正官/七杀/正财/偏财/正印/偏印/食神/伤官）或外格（从/化/专旺/建禄）。'),
      LunmingStep(3, '论成败救应', '成格=有相神护格；败格=有破格之神；救应=有神救破。判断命局结构是否成立。'),
      LunmingStep(4, '定相神（用神）', '相神=成就/保护格局的关键之神。如正官格用印护、七杀格用食制。'),
      LunmingStep(5, '大运流年', '行运到相神则发、到破神则败。看运势起伏。'),
      LunmingStep(6, '断事', '十神取象断六亲、事业、财运、健康。'),
    ],
  ),
  School(
    id: 'wangshuai', name: '旺衰派', shortName: '旺衰',
    core: '以「日主旺衰」为命局根本。日主强需抑、弱需扶，用神是平衡旺衰之神。',
    classics: '《滴天髓》《穷通宝鉴》',
    yongshenLogic: '扶抑——弱用印比扶、旺用官财食伤抑。加调候（寒暖失衡先调）+通关（对峙取中）。',
    priority: '力量优先：日主旺衰是定用神的根本依据。',
    color: 0xFF3FA66A,
    steps: [
      LunmingStep(1, '排盘', '排四柱 + 配十神。'),
      LunmingStep(2, '判旺衰', '四维评分：得令（月令）+ 得地（通根）+ 得生扶（印比）+ 格局修正 → 身强/中和/身弱/从格。'),
      LunmingStep(3, '扶抑取用', '弱→用印比扶；旺→用官财食伤抑；从格→顺势。遇寒暖失衡先用调候，遇对峙用通关。'),
      LunmingStep(4, '定喜忌', '用神为药，喜神生用，忌神破用，仇神生忌。'),
      LunmingStep(5, '大运流年', '行运到喜用则吉、到忌仇则凶。'),
      LunmingStep(6, '断事', '十神取象断各方面。'),
    ],
  ),
  School(
    id: 'tiaohou', name: '调候派', shortName: '调候',
    core: '以「寒暖燥湿平衡」为首要。命局过寒需火暖、过燥需水润，调候用神优先于扶抑——体温不正常，谈什么骨架和力量。',
    classics: '《穷通宝鉴》（又名《造化元钥》《栏江网》）',
    yongshenLogic: '调候——按月令查该日主的调候喜用。冬月先暖、夏月先润，寒暖平衡后再论格局旺衰。例：甲木生于子月（冬寒）→ 先用丁火暖身解冻。',
    priority: '寒暖优先：命局过寒/过燥时，调候用神最急。气温失衡，结构再好、力量再足也发挥不出来。',
    color: 0xFF3B7DD8,
    steps: [
      LunmingStep(1, '排盘', '排四柱 + 定日主 + 定月令季节。'),
      LunmingStep(2, '判寒暖燥湿', '看月令季节+命局五行：冬生水冷金寒、夏生火炎土燥。判断命局"温度"。'),
      LunmingStep(3, '查调候用神', '按月令查《穷通宝鉴》该日主的调候喜用。如冬月甲木先用丁火、夏月甲木先用癸水。'),
      LunmingStep(4, '兼顾格局旺衰', '调候用神确立后，再论格局成败、旺衰扶抑，综合定终用神。'),
      LunmingStep(5, '大运流年', '行运到调候之神则舒畅、到反调候（如寒命行水运）则郁。'),
      LunmingStep(6, '断事', '调候得宜则气血通畅、运势舒展。'),
    ],
  ),
];

class ComparePoint {
  final String aspect;
  final String geju;
  final String wangshuai;
  final String tiaohou;
  const ComparePoint(this.aspect, this.geju, this.wangshuai, this.tiaohou);
}

const comparePoints = <ComparePoint>[
  ComparePoint('核心', '月令格局（结构）', '日主旺衰（力量）', '寒暖燥湿（温度）'),
  ComparePoint('定用神', '相神——护格之神', '扶抑——平衡之神', '调候——寒暖之神'),
  ComparePoint('优先级', '先看格局成败', '先判身强身弱', '先看寒暖燥湿'),
  ComparePoint('经典', '《子平真诠》', '《滴天髓阐微》', '《穷通宝鉴》'),
  ComparePoint('比喻', '立骨（骨架）', '布血（肌肉）', '调温（体温）'),
  ComparePoint('同八字结论', '从结构取用', '从平衡取用', '从寒暖取用'),
];

const modernFusion = <String>[
  '先扫一眼有无明显格局（成格？破格？）——格局派视角（立骨）',
  '同时判旺衰（身强身弱四维评分）——旺衰派视角（布血）',
  '再看寒暖燥湿——调候派视角（调温）。生于冬月水冷金寒、夏月火炎土燥的，先查《穷通宝鉴》调候用神',
  '取用神时三兼顾：护格局 + 调旺衰 + 调寒暖。三派冲突时，寒暖最急（体温不正常谈其他都白搭），其次护格，再次扶抑',
  '口诀：真诠立骨、滴天布血、宝鉴调温——三书合参方为全功',
  '初学者建议：先掌握旺衰派（清晰可量化），再补格局派（精确取用），最后查调候（寒暖失衡时必查）',
];

class LearningPathItem {
  final String phase;
  final String content;
  const LearningPathItem(this.phase, this.content);
}

const learningPath = <LearningPathItem>[
  LearningPathItem('基础', '天干地支、十神、藏干、地支关系'),
  LearningPathItem('旺衰', '四维评分、扶抑取用（旺衰派核心）'),
  LearningPathItem('格局', '八正格+外格、成败救应（格局派核心，《子平真诠》）'),
  LearningPathItem('调候', '《穷通宝鉴》逐月调候用神'),
  LearningPathItem('断事', '十神取象 + 大运流年 + 实战'),
];

class ClassicCase {
  final String id;
  final String title;
  final String bazi;
  final String dayMaster;
  final String monthBranch;
  final String analysis;
  final ({String geju, String yongshen, String reason}) gejuSchool;
  final ({String strength, String yongshen, String reason}) wangshuaiSchool;
  final String compare;
  const ClassicCase({
    required this.id,
    required this.title,
    required this.bazi,
    required this.dayMaster,
    required this.monthBranch,
    required this.analysis,
    required this.gejuSchool,
    required this.wangshuaiSchool,
    required this.compare,
  });
}

const classicCases = <ClassicCase>[
  ClassicCase(
    id: 'case-1',
    title: '七杀格 · 甲木申月',
    bazi: '辛酉 庚申 甲寅 丙寅',
    dayMaster: '甲', monthBranch: '申',
    analysis: '甲木日主，生于申月（秋，木死）。天干庚辛金（官杀）极旺克身。日支寅、时支寅为甲木之根。',
    gejuSchool: (
      geju: '七杀格（月令申，庚金七杀透干）',
      yongshen: '食神（丙火）制杀',
      reason: '七杀格喜食神制杀或印化杀。命局有丙火（食神）透时干，可制庚金七杀，构成「食神制杀」之成格。相神=食神丙火。',
    ),
    wangshuaiSchool: (
      strength: '身弱（申月木死、官杀克身重，虽有寅根但被申冲）',
      yongshen: '印（水）化杀生身',
      reason: '身弱需扶。官杀旺克身，最宜用印（水）化杀生身——既泄了杀的凶性，又生扶日主。',
    ),
    compare: '格局派用食神（制杀护格），旺衰派用印（化杀扶身）。两者都化解了七杀的威胁，但出发点不同：一个是护格，一个是平衡。',
  ),
  ClassicCase(
    id: 'case-2',
    title: '正官格 · 甲木酉月',
    bazi: '癸未 辛酉 甲子 丙寅',
    dayMaster: '甲', monthBranch: '酉',
    analysis: '甲木日主，生于酉月（秋，木死但金旺）。月令酉，辛金正官透月干。日支子（印星）、时支寅（甲木根）。',
    gejuSchool: (
      geju: '正官格（月令酉，辛金正官透干）',
      yongshen: '印（癸水）护官',
      reason: '正官格喜财生印护。命局癸水（正印）透年干，子水（印）坐日支，构成「官印相生」之大贵格。相神=印星癸/子水。',
    ),
    wangshuaiSchool: (
      strength: '身弱（酉月木死、官星克身，虽有寅根但远）',
      yongshen: '印（水）生身',
      reason: '身弱需印比扶。印（癸/子水）既生扶日主，又泄官星之气，一举两得。',
    ),
    compare: '两派此例殊途同归——都用印。但理由不同：格局派是「护官成贵格」，旺衰派是「扶弱平衡」。结论同，逻辑异。',
  ),
];
