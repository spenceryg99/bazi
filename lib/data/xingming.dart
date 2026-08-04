enum Luck { ji, xiong, banJI }

extension LuckX on Luck {
  String get label => switch (this) {
        Luck.ji => '吉',
        Luck.xiong => '凶',
        Luck.banJI => '半吉',
      };
}

class WuGe {
  final String name;
  final String meaning;
  final String algorithm;
  final String yun;
  const WuGe(this.name, this.meaning, this.algorithm, this.yun);
}

const wuGe = <WuGe>[
  WuGe('天格', '祖上、父母、早年。先天注定不可改，对个人影响较弱。', '姓氏笔画 + 1', '先天运（参考）'),
  WuGe('人格', '主运，命局核心。代表性格、中年运势、能力。', '姓氏笔画 + 名字首字笔画', '主运（核心）'),
  WuGe('地格', '前运。代表青年、子女、下属。', '名字笔画之和 + 1（单字名）；多字名取名字笔画和', '前运'),
  WuGe('外格', '副运。代表社交、外围人际、贵人。', '总格 - 人格 + 1（单姓单名恒为2）', '副运'),
  WuGe('总格', '后运。代表晚年、整体归宿。', '所有字笔画之和', '后运（整体）'),
];

const strokeWuxing = <int, String>{
  1: '木', 2: '木', 3: '火', 4: '火', 5: '土',
  6: '土', 7: '金', 8: '金', 9: '水', 0: '水',
};

String strokeToWuxing(int n) => strokeWuxing[n % 10]!;

class Shuli {
  final int num;
  final Luck luck;
  final String keyword;
  final String meaning;
  const Shuli(this.num, this.luck, this.keyword, this.meaning);
}

const shuli81 = <Shuli>[
  Shuli(1, Luck.ji, '万物开泰', '万事万物起始之数，主独立权威、首领之相。'),
  Shuli(2, Luck.xiong, '两仪之数', '动摇不安、一荣一枯，主分离破败、内外不和。'),
  Shuli(3, Luck.ji, '三才之数', '天地人三才具备，主福禄双全、进取如意。'),
  Shuli(4, Luck.xiong, '分离破败', '分离之象，主孤独、破灭、家道中落。'),
  Shuli(5, Luck.ji, '种竹成林', '福禄长寿，主富贵荣华、福泽绵长。'),
  Shuli(6, Luck.ji, '六爻之数', '吉人天相，主安稳、天德贵人相助。'),
  Shuli(7, Luck.ji, '七政之数', '精悍权威，主刚毅果断、独立自营。'),
  Shuli(8, Luck.ji, '八卦之数', '意志坚强，主勤奋、功成名就。'),
  Shuli(9, Luck.xiong, '破舟进海', '破败之象，主多灾多难、家破人散。'),
  Shuli(10, Luck.xiong, '零暗万事', '终局黑暗，主一事无成、孤独终老。'),
  Shuli(11, Luck.ji, '稳健吉顺', '稳如泰山，主成家立业、顺风顺水。'),
  Shuli(12, Luck.xiong, '薄弱无力', '无力薄弱，主孤寡、易生挫折。'),
  Shuli(13, Luck.ji, '春日牡丹', '智谋出众，主才华横溢、博得名利。'),
  Shuli(14, Luck.xiong, '破兆浮沉', '破兆浮沉，主孤独、离别、亲情缘薄。'),
  Shuli(15, Luck.ji, '福寿双全', '福寿圆满，主富贵、长寿、立业兴家。'),
  Shuli(16, Luck.ji, '厚重载德', '贵人相助，主大业成就、富贵双全。'),
  Shuli(17, Luck.ji, '刚毅果断', '突破万难，主刚毅、功成名就。'),
  Shuli(18, Luck.ji, '铁镜重磨', '有志竟成，主意志坚强、终成大器。'),
  Shuli(19, Luck.xiong, '多遮风雨', '遮云蔽月，主多灾、病弱、辛苦。'),
  Shuli(20, Luck.xiong, '屋下藏金', '破灭衰败，主家道衰、短寿、破财。'),
  Shuli(21, Luck.ji, '明月光照', '光华灿灿，主独立权威、首领之格。'),
  Shuli(22, Luck.xiong, '秋草逢霜', '百事不如意，主挫折、中途夭折。'),
  Shuli(23, Luck.ji, '壮丽果敢', '旭日东升，主气势旺盛、大业成就。'),
  Shuli(24, Luck.ji, '家门余庆', '金钱丰盈，主家门富贵、子孙荫庇。'),
  Shuli(25, Luck.ji, '英俊刚毅', '资性英敏，主才能出众、性格刚毅。'),
  Shuli(26, Luck.xiong, '变怪奇异', '波澜起伏，主波折、英雄气短。'),
  Shuli(27, Luck.xiong, '欲望无止', '欲望太强，主自大、多灾、半途中折。'),
  Shuli(28, Luck.xiong, '阔水浮萍', '豪杰气概，主遭难、孤独、配偶不利。'),
  Shuli(29, Luck.ji, '泉舟顺展', '智谋优秀，主财力归命、归顺大吉。'),
  Shuli(30, Luck.xiong, '浮沉不定', '绝死逢生，主浮沉、多变、不得安宁。'),
  Shuli(31, Luck.ji, '春日花开', '智勇得志，主富贵、心性健全、大吉。'),
  Shuli(32, Luck.ji, '宝马金鞍', '侥幸多望，主贵人提携、财源广进。'),
  Shuli(33, Luck.ji, '升天之火', '旭日升天，主权威旺盛、刚毅果断。'),
  Shuli(34, Luck.xiong, '破家破业', '破家破业，主灾难频生、家业凋零。'),
  Shuli(35, Luck.ji, '高楼望月', '温和平静，主优雅、稳健、有余裕。'),
  Shuli(36, Luck.xiong, '波澜重叠', '波澜重叠，主辛苦、漂浮、英雄无用武。'),
  Shuli(37, Luck.ji, '猛虎出林', '权威显达，主独立、单枪匹马成大业。'),
  Shuli(38, Luck.banJI, '磨铁成针', '意志薄弱，主努力可成、半好半坏。'),
  Shuli(39, Luck.ji, '富贵繁荣', '富贵至极，主平安、福寿绵长。'),
  Shuli(40, Luck.xiong, '退安享福', '退安享福，主盛极转衰、宜退守。'),
  Shuli(41, Luck.ji, '德望高大', '纯阳独秀，主德望、名利双收、大吉。'),
  Shuli(42, Luck.xiong, '寒蝉在柳', '十事不成，主博学多能但难成大事。'),
  Shuli(43, Luck.xiong, '散财破产', '散财之象，主破财、事业难成。'),
  Shuli(44, Luck.xiong, '烦闷懊恼', '破家亡身，主家破、身危、多愁。'),
  Shuli(45, Luck.ji, '顺风挂帆', '新生泰然，主顺风得意、大业成就。'),
  Shuli(46, Luck.xiong, '载宝沉舟', '破船载宝，主破财、载难、中途受挫。'),
  Shuli(47, Luck.ji, '点铁成金', '开花结果，主权威、富贵、开花结实。'),
  Shuli(48, Luck.ji, '青松立鹤', '智谋兼备，主德望、功名、青史留名。'),
  Shuli(49, Luck.xiong, '吉凶难分', '吉凶参半，主先吉后凶、转赋变动。'),
  Shuli(50, Luck.xiong, '吉凶互见', '一成一败，主成败起伏、晚景凄凉。'),
  Shuli(51, Luck.banJI, '一盛一衰', '盛衰参半，主浮沉、需靠自力。'),
  Shuli(52, Luck.ji, '眼望星辰', '先见之明，主眼光远大、大业成就。'),
  Shuli(53, Luck.xiong, '忧愁困苦', '内忧外患，主多愁、多苦、难发展。'),
  Shuli(54, Luck.xiong, '多难悲运', '难成之象，主难成、辛苦、家庭破裂。'),
  Shuli(55, Luck.xiong, '外美内苦', '外祥内苦，主外表光鲜内里愁苦。'),
  Shuli(56, Luck.xiong, '浪里孤舟', '浪里孤舟，主漂浮、无依、晚景凄凉。'),
  Shuli(57, Luck.ji, '寒雪青松', '寒松青翠，主努力达成、寒门贵子。'),
  Shuli(58, Luck.banJI, '晚行遇福', '先苦后甘，主晚景好转、晚福绵长。'),
  Shuli(59, Luck.xiong, '寒蝉悲啼', '无能无谋，主毫无作为、意气消沉。'),
  Shuli(60, Luck.xiong, '无谋之人', '黑暗无光，主无谋、破败、孤苦。'),
  Shuli(61, Luck.ji, '名利双收', '名利双收，主荣耀、富贵、昌隆。'),
  Shuli(62, Luck.xiong, '衰败孤独', '衰败孤独，主孤独、衰败、无成。'),
  Shuli(63, Luck.ji, '万物化育', '万物育化，主富贵、繁荣、舟归平岸。'),
  Shuli(64, Luck.xiong, '骨肉分离', '骨肉分离，主离散、家破、孤独。'),
  Shuli(65, Luck.ji, '富贵至极', '富贵长寿，主大富贵、福寿绵长。'),
  Shuli(66, Luck.xiong, '暗黑浮沉', '暗黑浮沉，主浮沉、多变、愁苦。'),
  Shuli(67, Luck.ji, '通达畅旺', '长命富贵，主事业通达、财禄丰厚。'),
  Shuli(68, Luck.ji, '兴旺立业', '智慧兴起，主立业、智慧、家业兴旺。'),
  Shuli(69, Luck.xiong, '非业破运', '非业破运，主破败、家散、坐立不定。'),
  Shuli(70, Luck.xiong, '废颓不振', '废颓家运，主家运衰、凄凉、无聊。'),
  Shuli(71, Luck.banJI, '劳神费力', '劳碌无功，主劳碌、半成半败。'),
  Shuli(72, Luck.xiong, '先甘后苦', '先甘后苦，主先甜后苦、晚景凄惨。'),
  Shuli(73, Luck.banJI, '忧心劳神', '志高力微，主心比天高、命比纸薄。'),
  Shuli(74, Luck.xiong, '秋叶落寞', '无能孤独，主无能、孤独、家业荒废。'),
  Shuli(75, Luck.banJI, '退守安静', '退守可安，主退则吉、进则凶。'),
  Shuli(76, Luck.xiong, '倾覆离散', '倾覆离散，主破家、离散、大凶。'),
  Shuli(77, Luck.banJI, '先苦后甘', '前凶后吉，主前半生苦、后半生好转。'),
  Shuli(78, Luck.xiong, '晚景不遇', '晚景不遇，主晚景萧条、壮志难酬。'),
  Shuli(79, Luck.xiong, '挽回乏力', '挽回乏力，主身衰、家败、无能为力。'),
  Shuli(80, Luck.xiong, '凶星入命', '最凶之数，主家破人亡、凶灾横祸。'),
  Shuli(81, Luck.ji, '万物回春', '最吉之数，主还本归元、大吉大利。'),
];

Shuli getShuli(int n) {
  final num = ((n - 1) % 80) + 1;
  for (final s in shuli81) {
    if (s.num == num) return s;
  }
  return shuli81.first;
}

class SancaiConfig {
  final String pattern;
  final Luck luck;
  final String meaning;
  const SancaiConfig(this.pattern, this.luck, this.meaning);
}

const sancaiConfigs = <SancaiConfig>[
  SancaiConfig('木→火→土', Luck.ji, '木生火、火生土，三才连续相生，大吉。主顺遂、福泽绵长。'),
  SancaiConfig('火→土→金', Luck.ji, '火生土、土生金，连续相生，大吉。主稳健、名利双收。'),
  SancaiConfig('土→金→水', Luck.ji, '土生金、金生水，连续相生，大吉。主智慧、财源广进。'),
  SancaiConfig('金→水→木', Luck.ji, '金生水、水生木，连续相生，大吉。主进取、生机勃勃。'),
  SancaiConfig('水→木→火', Luck.ji, '水生木、木生火，连续相生，大吉。主发展、事业兴旺。'),
  SancaiConfig('水→火→金', Luck.xiong, '水克火、火克金，连续相克，大凶。主多病、是非、动荡。'),
  SancaiConfig('火→金→木', Luck.xiong, '火克金、金克木，连续相克，大凶。主破败、刑伤。'),
  SancaiConfig('木→土→水', Luck.xiong, '木克土、土克水，连续相克，凶。主家庭不和、事业受阻。'),
  SancaiConfig('金→木→土', Luck.xiong, '金克木、木克土，连续相克，凶。主孤克、骨肉缘薄。'),
];

const controversy = <String>[
  '起源：日本熊崎健翁 1928 年发明，非中国古典传承。中国古代有数理思想，但五格剖象法是近代成型体系。',
  '只看笔画，不看字义字音：「死」「病」等字若笔画凑成吉数，按五格也算好名——明显不合理。',
  '脱离个人八字：完全不考虑命主的生辰喜忌，名字好坏与八字无关。',
  '同音不同字差异大：「张三」和「张叁」笔画不同，吉凶结论却差很多。',
  '正统命理界评价：多作「软参考」使用，不作核心依据。起名公司流行是因为它好算、好卖、能标准化。',
  '正确用法：八字定喜用（决定补什么五行）→ 选字满足八字 → 同时算五格尽量让核心格（人格/地格/总格）落吉数。八字为里，五格为表。',
];

const relationToBazi =
    '八字看「生辰」定喜用五行（决定名字该补什么），五格看「名字笔画」断数理吉凶。两者是平行系统：八字是"该补什么"，五格是"名字数字好不好看"。现代起名常两者并用——以八字喜用为先，五格作软约束。';
