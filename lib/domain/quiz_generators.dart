import 'dart:math';

import '../data/advanced.dart';
import '../data/dizhi.dart';
import '../data/tiangan.dart';
import '../data/types.dart';

final _rng = Random();

List<T> shuffle<T>(List<T> arr) {
  final a = List<T>.from(arr);
  for (int i = a.length - 1; i > 0; i--) {
    final j = _rng.nextInt(i + 1);
    final tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
  }
  return a;
}

List<String> makeOptions(String correct, List<String> pool) {
  final distractors = shuffle(pool.where((x) => x != correct).toList()).take(3).toList();
  return shuffle([correct, ...distractors]);
}

class _TgField {
  final String field;
  final String label;
  final List<String> pool;
  final String Function(Tiangan) pick;
  const _TgField(this.field, this.label, this.pool, this.pick);
}

final _tgFields = <_TgField>[
  _TgField('yinyang', '阴阳', ['阳', '阴'], (t) => t.yinyang.label),
  _TgField('wuxing', '五行', wuxingList.map((w) => w.label).toList(), (t) => t.wuxing.label),
];

class _DzField {
  final String field;
  final String label;
  final List<String> pool;
  final String Function(Dizhi) pick;
  const _DzField(this.field, this.label, this.pool, this.pick);
}

final _dzFields = <_DzField>[
  _DzField('yinyang', '阴阳', ['阳', '阴'], (d) => d.yinyang.label),
  _DzField('wuxing', '五行', wuxingList.map((w) => w.label).toList(), (d) => d.wuxing.label),
  _DzField('season', '季节', ['春', '夏', '秋', '冬'], (d) => d.season.label),
  _DzField('animal', '生肖', dizhi.map((d) => d.animal).toList(), (d) => d.animal),
  _DzField('category', '类别', ['四正', '四生', '四库'], (d) => d.category.label),
  _DzField('isPure', '是否纯（四正为纯）', ['纯', '不纯'], (d) => d.isPure ? '纯' : '不纯'),
  _DzField('canggan', '藏干', dizhi.map((d) => d.canggan.map((c) => c.stem).join()).toList(),
      (d) => d.canggan.map((c) => c.stem).join()),
];

List<Question> genTianganQuestions() {
  return [
    for (final t in tiangan)
      for (final f in _tgFields)
        Question(
          id: 'tg-${t.char}-${f.field}',
          subject: t.char,
          subjectType: SubjectType.tiangan,
          field: f.field,
          fieldLabel: f.label,
          prompt: '「${t.char}」（${t.pinyin}）的${f.label}是？',
          options: makeOptions(f.pick(t), f.pool),
          answer: f.pick(t),
          explanation: '${t.imagery}。\n【说文】${t.etymology.shuowen}\n【本义】${t.etymology.benyi}\n【记忆】${t.memory}',
        ),
  ];
}

List<Question> genDizhiQuestions() {
  return [
    for (final d in dizhi)
      for (final f in _dzFields)
        Question(
          id: 'dz-${d.char}-${f.field}',
          subject: d.char,
          subjectType: SubjectType.dizhi,
          field: f.field,
          fieldLabel: f.label,
          prompt: '「${d.char}」（${d.pinyin}）的${f.label}是？',
          options: makeOptions(f.pick(d), f.pool),
          answer: f.pick(d),
          explanation: '${d.category.label}·${d.season.label}季·${d.animal}。\n【说文】${d.etymology.shuowen}\n【本义】${d.etymology.benyi}\n【记忆】${d.memory}',
        ),
  ];
}

List<Question> genCangganQuestions() {
  final qs = <Question>[];
  final mainPool = dizhi.map((d) => '${d.canggan.first.stem}（${d.canggan.first.wuxing.label}）').toList();
  for (final d in dizhi) {
    final main = d.canggan.first;
    final mainAns = '${main.stem}（${main.wuxing.label}）';
    qs.add(Question(
      id: 'cg-main-${d.char}', subject: d.char, subjectType: SubjectType.dizhi,
      field: 'canggan', fieldLabel: '主气藏干', category: '藏干 · 主气',
      prompt: '「${d.char}」的主气（本气）藏干是？',
      options: makeOptions(mainAns, mainPool), answer: mainAns,
      explanation: '「${d.char}」（${d.category.label}）藏干：${d.canggan.map((c) => '${c.stem}(${c.wuxing.label},${c.level.label})').join(' / ')}。\n${d.memory}',
    ));
    final fullAns = d.canggan.map((c) => c.stem).join();
    final fullPool = dizhi.map((x) => x.canggan.map((c) => c.stem).join()).toList();
    qs.add(Question(
      id: 'cg-full-${d.char}', subject: d.char, subjectType: SubjectType.dizhi,
      field: 'canggan', fieldLabel: '完整藏干', category: '藏干 · 完整',
      prompt: '「${d.char}」的完整藏干是？（按主/中/余顺序）',
      options: makeOptions(fullAns, fullPool), answer: fullAns,
      explanation: '「${d.char}」（${d.category.label}）藏 ${d.canggan.length} 个：${d.canggan.map((c) => c.stem).join('、')}。\n${d.memory}',
    ));
    final n = d.canggan.length;
    qs.add(Question(
      id: 'cg-cnt-${d.char}', subject: d.char, subjectType: SubjectType.dizhi,
      field: 'canggan', fieldLabel: '藏干个数', category: '藏干 · 个数',
      prompt: '「${d.char}」一共藏了几个天干？',
      options: makeOptions('$n个', ['1个', '2个', '3个']), answer: '$n个',
      explanation: '${d.char}是${d.category.label}，藏 $n 个：${d.canggan.map((c) => c.stem).join('、')}。',
    ));
  }
  return qs;
}

List<Question> genAdvancedQuestions() {
  final qs = <Question>[];

  for (final dm in stemInfo.keys) {
    for (final tg in stemInfo.keys) {
      if (dm == tg) continue;
      final answer = getTenGod(dm, tg);
      qs.add(Question(
        id: 'ss-$dm-$tg', subject: '$dm→$tg', subjectType: SubjectType.tiangan,
        field: 'advanced', fieldLabel: '十神', category: '十神判定',
        prompt: '日主「$dm」见「$tg」，是十神中的哪一个？',
        options: makeOptions(answer, tenGodPool), answer: answer,
        explanation: '日主$dm见$tg → $answer。判定法：先看五行关系定大类(比劫/印/食伤/财/官杀)，再看阴阳同异分正偏——同性为偏，异性为正。',
      ));
    }
  }

  for (final season in seasonRules.keys) {
    for (final elem in wuxingList) {
      final answer = getSeasonState(season, elem).label;
      qs.add(Question(
        id: 'wx-$season-${elem.label}', subject: '$season/${elem.label}', subjectType: SubjectType.dizhi,
        field: 'advanced', fieldLabel: '旺相休囚死', category: '旺相休囚死',
        prompt: '$season季，五行「${elem.label}」处于什么状态？',
        options: makeOptions(answer, ['旺', '相', '休', '囚', '死']), answer: answer,
        explanation: '$season季${seasonRules[season]![SeasonState.wang]!.label}气当令。口诀：当令者旺、令生者相、生令者休、克令者囚、令克者死。→ ${elem.label}为「$answer」。',
      ));
    }
  }

  for (final a in wuxingList) {
    final sheng = shengMap[a]!.label;
    qs.add(Question(
      id: 'sk-sheng-${a.label}', subject: a.label, subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '五行相生', category: '五行生克',
      prompt: '五行「${a.label}」生什么？',
      options: makeOptions(sheng, wuxingList.map((w) => w.label).toList()), answer: sheng,
      explanation: '${a.label}生$sheng。口诀：木生火、火生土、土生金、金生水、水生木。',
    ));
    final ke = keMap[a]!.label;
    qs.add(Question(
      id: 'sk-ke-${a.label}', subject: a.label, subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '五行相克', category: '五行生克',
      prompt: '五行「${a.label}」克什么？',
      options: makeOptions(ke, wuxingList.map((w) => w.label).toList()), answer: ke,
      explanation: '${a.label}克$ke。口诀：木克土、土克水、水克火、火克金、金克木。',
    ));
  }

  for (final h in tianganWuhe) {
    final a = h.pair[0], b = h.pair[1];
    qs.add(Question(
      id: 'he-hua-$a$b', subject: '$a$b', subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '天干五合', category: '五合 · 化气',
      prompt: '天干「$a」与「$b」合，化出什么五行？',
      options: makeOptions(h.result.label, wuxingList.map((w) => w.label).toList()), answer: h.result.label,
      explanation: '$a$b合化${h.result.label}（${h.imagery}）。\n${wuhePrinciple.huaqi}',
    ));
    qs.add(Question(
      id: 'he-rev-$a', subject: a, subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '天干五合', category: '五合 · 配对',
      prompt: '天干「$a」与哪个天干相合？',
      options: makeOptions(b, allStems.where((x) => x != b && x != a).toList()), answer: b,
      explanation: '$a（序数${h.order[0]}）与 $b（序数${h.order[1]}）隔五相合 → $a$b合化${h.result.label}（${h.imagery}）。',
    ));
  }

  for (final ju in sanheJu) {
    final a = ju.branches[0], b = ju.branches[1], c = ju.branches[2];
    qs.add(Question(
      id: 'sanhe-$a$b$c', subject: '$a$b$c', subjectType: SubjectType.dizhi,
      field: 'advanced', fieldLabel: '三合局', category: '三合局',
      prompt: '「$a＋$b＋$c」三合，合成什么局？',
      options: makeOptions(ju.element.label, wuxingList.map((w) => w.label).toList()), answer: ju.element.label,
      explanation: '$a$b$c合${ju.element.label}局。四组三合：申子辰合水、亥卯未合木、寅午戌合火、巳酉丑合金。',
    ));
  }

  for (final entry in siKu.entries) {
    qs.add(Question(
      id: 'ku-${entry.key}', subject: entry.key, subjectType: SubjectType.dizhi,
      field: 'advanced', fieldLabel: '四库（墓库）', category: '四库',
      prompt: '「${entry.key}」是什么五行的墓库？',
      options: makeOptions(entry.value.label, wuxingList.map((w) => w.label).toList()), answer: entry.value.label,
      explanation: '${entry.key}是${entry.value.label}库。对应三合局：辰水库(申子辰)、未木库(亥卯未)、戌火库(寅午戌)、丑金库(巳酉丑)。',
    ));
  }

  return qs;
}
