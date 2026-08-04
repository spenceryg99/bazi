enum Wuxing { mu, huo, tu, jin, shui }

extension WuxingX on Wuxing {
  String get label => switch (this) {
        Wuxing.mu => '木',
        Wuxing.huo => '火',
        Wuxing.tu => '土',
        Wuxing.jin => '金',
        Wuxing.shui => '水',
      };
  static Wuxing fromLabel(String s) => const {
        '木': Wuxing.mu,
        '火': Wuxing.huo,
        '土': Wuxing.tu,
        '金': Wuxing.jin,
        '水': Wuxing.shui,
      }[s]!;
}

enum Yinyang { yang, yin }

extension YinyangX on Yinyang {
  String get label => this == Yinyang.yang ? '阳' : '阴';
}

enum Season { spring, summer, autumn, winter }

extension SeasonX on Season {
  String get label => switch (this) {
        Season.spring => '春',
        Season.summer => '夏',
        Season.autumn => '秋',
        Season.winter => '冬',
      };
  static Season fromLabel(String s) => const {
        '春': Season.spring,
        '夏': Season.summer,
        '秋': Season.autumn,
        '冬': Season.winter,
      }[s]!;
}

enum DizhiCategory { siZheng, siSheng, siKu }

extension DizhiCategoryX on DizhiCategory {
  String get label => switch (this) {
        DizhiCategory.siZheng => '四正',
        DizhiCategory.siSheng => '四生',
        DizhiCategory.siKu => '四库',
      };
}

enum CangganLevel { zhu, zhong, yu }

extension CangganLevelX on CangganLevel {
  String get label => switch (this) {
        CangganLevel.zhu => '主',
        CangganLevel.zhong => '中',
        CangganLevel.yu => '余',
      };
}

class Etymology {
  final String guhu;
  final String shuowen;
  final String benyi;
  final String whyChosen;
  const Etymology({
    required this.guhu,
    required this.shuowen,
    required this.benyi,
    required this.whyChosen,
  });
}

class Tiangan {
  final String char;
  final String pinyin;
  final int order;
  final Yinyang yinyang;
  final Wuxing wuxing;
  final String imagery;
  final Etymology etymology;
  final String memory;

  const Tiangan({
    required this.char,
    required this.pinyin,
    required this.order,
    required this.yinyang,
    required this.wuxing,
    required this.imagery,
    required this.etymology,
    required this.memory,
  });
}

class CangganItem {
  final String stem;
  final Wuxing wuxing;
  final CangganLevel level;
  const CangganItem({required this.stem, required this.wuxing, required this.level});
}

class Dizhi {
  final String char;
  final String pinyin;
  final int order;
  final Yinyang yinyang;
  final Wuxing wuxing;
  final Season season;
  final String animal;
  final String hour;
  final DizhiCategory category;
  final bool isPure;
  final List<CangganItem> canggan;
  final Etymology etymology;
  final String memory;

  const Dizhi({
    required this.char,
    required this.pinyin,
    required this.order,
    required this.yinyang,
    required this.wuxing,
    required this.season,
    required this.animal,
    required this.hour,
    required this.category,
    required this.isPure,
    required this.canggan,
    required this.etymology,
    required this.memory,
  });
}

enum SubjectType { tiangan, dizhi }

class Question {
  final String id;
  final String subject;
  final SubjectType subjectType;
  final String field;
  final String fieldLabel;
  final String prompt;
  final List<String> options;
  final String answer;
  final String explanation;
  final String? category;

  const Question({
    required this.id,
    required this.subject,
    required this.subjectType,
    required this.field,
    required this.fieldLabel,
    required this.prompt,
    required this.options,
    required this.answer,
    required this.explanation,
    this.category,
  });
}

class FieldStat {
  int total;
  int correct;
  FieldStat({this.total = 0, this.correct = 0});
}

class Progress {
  int total;
  int correct;
  final Map<String, FieldStat> byField;
  Progress({this.total = 0, this.correct = 0, Map<String, FieldStat>? byField})
      : byField = byField ?? {};
}
