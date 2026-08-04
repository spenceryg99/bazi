import 'types.dart';

const wuxingList = <Wuxing>[Wuxing.mu, Wuxing.huo, Wuxing.tu, Wuxing.jin, Wuxing.shui];

const shengMap = <Wuxing, Wuxing>{
  Wuxing.mu: Wuxing.huo,
  Wuxing.huo: Wuxing.tu,
  Wuxing.tu: Wuxing.jin,
  Wuxing.jin: Wuxing.shui,
  Wuxing.shui: Wuxing.mu,
};

const keMap = <Wuxing, Wuxing>{
  Wuxing.mu: Wuxing.tu,
  Wuxing.huo: Wuxing.jin,
  Wuxing.tu: Wuxing.shui,
  Wuxing.jin: Wuxing.mu,
  Wuxing.shui: Wuxing.huo,
};

class StemInfo {
  final Yinyang yinyang;
  final Wuxing wuxing;
  const StemInfo(this.yinyang, this.wuxing);
}

const stemInfo = <String, StemInfo>{
  '甲': StemInfo(Yinyang.yang, Wuxing.mu),
  '乙': StemInfo(Yinyang.yin, Wuxing.mu),
  '丙': StemInfo(Yinyang.yang, Wuxing.huo),
  '丁': StemInfo(Yinyang.yin, Wuxing.huo),
  '戊': StemInfo(Yinyang.yang, Wuxing.tu),
  '己': StemInfo(Yinyang.yin, Wuxing.tu),
  '庚': StemInfo(Yinyang.yang, Wuxing.jin),
  '辛': StemInfo(Yinyang.yin, Wuxing.jin),
  '壬': StemInfo(Yinyang.yang, Wuxing.shui),
  '癸': StemInfo(Yinyang.yin, Wuxing.shui),
};

const allStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

enum TenGod {
  bijian('比肩'),
  jiecai('劫财'),
  zhengyin('正印'),
  pianyin('偏印（枭神）'),
  shishen('食神'),
  shangguan('伤官'),
  zhengcai('正财'),
  piancai('偏财'),
  zhengguan('正官'),
  qisha('七杀（偏官）');

  final String label;
  const TenGod(this.label);
}

const tenGodPool = [
  '比肩', '劫财', '正印', '偏印（枭神）', '食神', '伤官',
  '正财', '偏财', '正官', '七杀（偏官）',
];

String _relation(Wuxing dm, Wuxing target) {
  if (target == dm) return 'same';
  if (shengMap[target] == dm) return 'sheng_me';
  if (shengMap[dm] == target) return 'me_sheng';
  if (keMap[dm] == target) return 'me_ke';
  if (keMap[target] == dm) return 'ke_me';
  return '';
}

String getTenGod(String dmStem, String targetStem) {
  final dm = stemInfo[dmStem];
  final tg = stemInfo[targetStem];
  if (dm == null || tg == null) return '';
  final rel = _relation(dm.wuxing, tg.wuxing);
  final same = dm.yinyang == tg.yinyang;
  switch (rel) {
    case 'same':
      return same ? '比肩' : '劫财';
    case 'sheng_me':
      return same ? '偏印（枭神）' : '正印';
    case 'me_sheng':
      return same ? '食神' : '伤官';
    case 'me_ke':
      return same ? '偏财' : '正财';
    case 'ke_me':
      return same ? '七杀（偏官）' : '正官';
    default:
      return '';
  }
}

enum SeasonState { wang, xiang, xiu, qiu, si }

extension SeasonStateX on SeasonState {
  String get label => switch (this) {
        SeasonState.wang => '旺',
        SeasonState.xiang => '相',
        SeasonState.xiu => '休',
        SeasonState.qiu => '囚',
        SeasonState.si => '死',
      };
}

const seasonRules = <String, Map<SeasonState, Wuxing>>{
  '春': {SeasonState.wang: Wuxing.mu, SeasonState.xiang: Wuxing.huo, SeasonState.xiu: Wuxing.shui, SeasonState.qiu: Wuxing.jin, SeasonState.si: Wuxing.tu},
  '夏': {SeasonState.wang: Wuxing.huo, SeasonState.xiang: Wuxing.tu, SeasonState.xiu: Wuxing.mu, SeasonState.qiu: Wuxing.shui, SeasonState.si: Wuxing.jin},
  '秋': {SeasonState.wang: Wuxing.jin, SeasonState.xiang: Wuxing.shui, SeasonState.xiu: Wuxing.tu, SeasonState.qiu: Wuxing.huo, SeasonState.si: Wuxing.mu},
  '冬': {SeasonState.wang: Wuxing.shui, SeasonState.xiang: Wuxing.mu, SeasonState.xiu: Wuxing.jin, SeasonState.qiu: Wuxing.tu, SeasonState.si: Wuxing.huo},
};

SeasonState getSeasonState(String season, Wuxing elem) {
  final rule = seasonRules[season];
  if (rule == null) return SeasonState.xiu;
  for (final e in rule.entries) {
    if (e.value == elem) return e.key;
  }
  return SeasonState.xiu;
}

class WuheItem {
  final List<String> pair;
  final Wuxing result;
  final List<int> order;
  final String imagery;
  final String imageryMean;
  final String apply;
  const WuheItem(this.pair, this.result, this.order, this.imagery, this.imageryMean, this.apply);
}

const tianganWuhe = <WuheItem>[
  WuheItem(['甲', '己'], Wuxing.tu, [1, 6], '中正之合',
    '甲（阳木）+ 己（阴土）。木克土为夫妻之配，主安分守己、中正平和。',
    '命带甲己合：主人端正、循规蹈矩、有信誉。女命得之主贤妻良母。'),
  WuheItem(['乙', '庚'], Wuxing.jin, [2, 7], '仁义之合',
    '乙（阴木）+ 庚（阳金）。金克木但合，主刚柔并济、恩威并用。',
    '命带乙庚合：主果敢又仁慈、有担当。化金成功则主义气、武职掌权。'),
  WuheItem(['丙', '辛'], Wuxing.shui, [3, 8], '威制之合',
    '丙（阳火）+ 辛（阴金）。火克金，主威严、肃杀、纪律。',
    '命带丙辛合：主有威严、擅管理、宜军法纪律之职。化水成功则主智谋深沉。'),
  WuheItem(['丁', '壬'], Wuxing.mu, [4, 9], '淫慝之合',
    '丁（阴火）+ 壬（阳水）。水火交战、阴阳相惑，主感情纠葛、桃花是非。',
    '命带丁壬合：主多情、人缘好但易招桃花是非。女命尤甚，需防感情纠纷。'),
  WuheItem(['戊', '癸'], Wuxing.huo, [5, 10], '无情之合',
    '戊（阳土）+ 癸（阴水）。土克水、相合无情，主貌合神离、薄情寡义。',
    '命带戊癸合：主夫妻感情薄、貌合神离。化火成功则反主热情，但多生变。'),
];

class WuhePrinciple {
  final String rule, why, huaqi, condition, xiji;
  const WuhePrinciple(this.rule, this.why, this.huaqi, this.condition, this.xiji);
}

const wuhePrinciple = WuhePrinciple(
  '天干序数隔五相合：甲1配己6、乙2配庚7、丙3配辛8、丁4配壬9、戊5配癸10（每对相差5位）。',
  '一说源于河图数理——河图一六共宗(水)、二七同道(火)、三八为朋(木)、四九为友(金)、五十同途(土)，天干按序配河图数，隔五相合。一说源于古天文学，甲己之日日月会于特定星宿。',
  '化气口诀：甲己化土、乙庚化金、丙辛化水、丁壬化木、戊癸化火。化气成功则该五行增力，命局以化出之五行论。',
  '化气三条件（与地支六合化气类似）：①化神当令（生于化出五行之月）②两干紧邻（无隔断）③无克破（无冲克散合）。三条件全满足方真化，否则「合而不化」，只绊住对方令其减力。',
  '合本身无吉凶：合用神→绊（用神减力，凶）；合忌神→制（忌神受羁，吉）。化气成功则该五行主导，喜忌看作用于日主。',
);

class SanheJu {
  final List<String> branches;
  final Wuxing element;
  const SanheJu(this.branches, this.element);
}

const sanheJu = <SanheJu>[
  SanheJu(['申', '子', '辰'], Wuxing.shui),
  SanheJu(['亥', '卯', '未'], Wuxing.mu),
  SanheJu(['寅', '午', '戌'], Wuxing.huo),
  SanheJu(['巳', '酉', '丑'], Wuxing.jin),
];

const siKu = <String, Wuxing>{
  '辰': Wuxing.shui,
  '未': Wuxing.mu,
  '戌': Wuxing.huo,
  '丑': Wuxing.jin,
};
