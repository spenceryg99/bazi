import '../data/advanced.dart';
import '../data/dizhi.dart';
import '../data/dizhi_relations.dart';
import '../data/geju.dart';
import '../data/lunming.dart';
import '../data/types.dart';
import '../data/xingming.dart';
import '../data/zhenquan.dart';
import 'quiz_generators.dart';

List<Question> genRelationQuestions() {
  final qs = <Question>[];
  final allNames = relations.map((r) => r.name).toList();
  final resultPool = <String>[];
  for (final r in relations) {
    for (final p in r.pairs) {
      if (p.result != null) resultPool.add(p.result!);
    }
  }

  for (final r in relations) {
    for (final p in r.pairs) {
      if (p.members.length >= 4) continue;
      final key = p.members.join();
      qs.add(Question(
        id: 'rel-pair-${r.id.name}-$key', subject: key, subjectType: SubjectType.dizhi,
        field: 'advanced', fieldLabel: '地支关系', category: '${r.name} · 配对',
        prompt: '「${p.members.join(' + ')}」属于哪种地支关系？',
        options: makeOptions(r.name, allNames), answer: r.name,
        explanation: '${p.members.join('+')} = ${r.name}${p.result != null ? '（${p.result}）' : ''}。\n【取象】${p.meaning}\n【口诀】${r.koujue}',
      ));
    }
  }

  for (final r in relations) {
    for (final p in r.pairs) {
      if (p.result == null) continue;
      qs.add(Question(
        id: 'rel-res-${r.id.name}-${p.members.join()}', subject: p.members.join(),
        subjectType: SubjectType.dizhi, field: 'advanced', fieldLabel: '地支关系', category: '${r.name} · 结果',
        prompt: '「${p.members.join(' + ')}」${r.name}${r.id == RelationId.liuhe ? '化' : '成'}什么？',
        options: makeOptions(p.result!, resultPool), answer: p.result!,
        explanation: '${p.members.join('+')} = ${r.name}（${p.result}）。\n【取象】${p.meaning}',
      ));
    }
  }

  final applyMap = <RelationId, String>{
    RelationId.liuhe: '和睦联结、人缘好',
    RelationId.liuchong: '动荡变动、冲突离散',
    RelationId.sanhe: '势力合伙、该五行主导',
    RelationId.sanxing: '刑伤官非、恩怨纠纷',
    RelationId.sanhui: '一方专旺、行业集中',
    RelationId.liuhai: '暗伤阻隔、骨肉不和',
  };
  final applyPool = applyMap.values.toList();
  for (final r in relations) {
    qs.add(Question(
      id: 'rel-app-${r.id.name}', subject: r.name, subjectType: SubjectType.dizhi,
      field: 'advanced', fieldLabel: '地支关系', category: '${r.name} · 应用',
      prompt: '「${r.name}」在八字中主要主什么事？',
      options: makeOptions(applyMap[r.id]!, applyPool), answer: applyMap[r.id]!,
      explanation: '${r.summary}\n\n【原理】${r.principle}\n【应用】${applyMap[r.id]}',
    ));
  }

  for (final t in trickyCombos) {
    qs.add(Question(
      id: 'rel-trick-${t.members.join()}', subject: t.members.join(), subjectType: SubjectType.dizhi,
      field: 'advanced', fieldLabel: '地支关系', category: '关系 · 辨析',
      prompt: '「${t.members.join(' + ')}」最容易混淆，它的正确关系是？',
      options: makeOptions(t.correct, [t.correct, t.wrong, '六合', '六冲']), answer: t.correct,
      explanation: '易错辨析：${t.note}\n\n正确答案：${t.correct}。',
    ));
  }

  for (final b in allBranches) {
    for (final r in relations) {
      for (final p in r.pairs) {
        if (!p.members.contains(b) || p.members.length >= 4) continue;
        final partners = p.members.where((x) => x != b).toList();
        if (partners.isEmpty) continue;
        final partner = partners.first;
        qs.add(Question(
          id: 'rel-net-$b-${r.id.name}', subject: b, subjectType: SubjectType.dizhi,
          field: 'advanced', fieldLabel: '地支关系', category: '关系 · 单支网络',
          prompt: '「$b」的${r.name}对象是？',
          options: makeOptions(partner, allBranches), answer: partner,
          explanation: '「$b」的${r.name}对象是「$partner」。\n${p.members.join('+')} = ${r.name}${p.result != null ? '（${p.result}）' : ''}。',
        ));
        break;
      }
    }
  }

  const judgeStmts = [
    ('「寅卯辰会东方木」', '正确', '寅卯辰同属东方春季，三会东方木局，正确。'),
    ('「巳酉丑会西方金」', '错误', '错！巳酉丑是三合金局（生旺墓），不是三会。三会西方金是申酉戌。'),
    ('「申子辰合水局」', '正确', '申（水长生）+子（水帝旺）+辰（水墓库）=三合水局，正确。'),
    ('「亥子丑合水局」', '错误', '错！亥子丑同方位同季=三会北方水，不是三合。三合水局是申子辰。'),
    ('「寅亥合化木」', '正确', '寅亥合化木（亥藏甲通寅甲），正确。'),
    ('「寅亥六冲」', '错误', '错！寅亥是六合化木。寅申才是六冲（金克木）。'),
    ('「卯辰六害」', '正确', '卯辰相害（卯合戌、辰冲戌→害），正确。'),
    ('「卯戌六害」', '错误', '错！卯戌是六合化火。卯辰才是六害。'),
    ('「寅巳申是无恩之刑」', '正确', '寅巳申循环相刑=无恩之刑，主忘恩负义，正确。'),
    ('「子卯是恃势之刑」', '错误', '错！子卯是无礼之刑（子水生卯木太过）。恃势之刑是丑戌未。'),
  ];
  for (final s in judgeStmts) {
    qs.add(Question(
      id: 'rel-judge-${s.$1}', subject: '判断题', subjectType: SubjectType.dizhi,
      field: 'advanced', fieldLabel: '地支关系', category: '关系 · 找错判断',
      prompt: '${s.$1}——这句话对吗？', options: ['正确', '错误'], answer: s.$2,
      explanation: s.$3,
    ));
  }

  for (final c in caseExamples) {
    qs.add(Question(
      id: 'rel-case-${caseExamples.indexOf(c)}', subject: '案例', subjectType: SubjectType.dizhi,
      field: 'advanced', fieldLabel: '地支关系', category: '关系 · 案例',
      prompt: c, options: makeOptions(c, caseExamples), answer: c,
      explanation: c,
    ));
  }

  return qs;
}

List<Question> genLunmingQuestions() {
  final qs = <Question>[];
  final gejuNames = zhengGe.map((g) => g.name).toList();

  for (final dm in stemWuxing.keys) {
    for (final mb in branchMainStem.keys) {
      final main = branchMainStem[mb]!;
      final dmWx = stemWuxing[dm]!;
      final dmYy = stemYinyang[dm]!;
      final stemYy = stemYinyang[main.stem]!;
      final sameYy = dmYy == stemYy;
      final result = computeShishenGeju(dmWx, main.wuxing, sameYy);
      if (result.geju == '建禄/月劫格') continue;
      qs.add(Question(
        id: 'geju-id-$dm-$mb', subject: '$dm/$mb', subjectType: SubjectType.tiangan,
        field: 'advanced', fieldLabel: '论命', category: '格局 · 识别',
        prompt: '日主「$dm」（$dmWx），月令「$mb」，本气「${main.stem}」（${main.wuxing}）透干。是什么格局？',
        options: makeOptions(result.geju, gejuNames), answer: result.geju,
        explanation: '$dm（$dmYy$dmWx）生于$mb月，本气${main.stem}（$stemYy${main.wuxing}）。对日主为「${result.shishen}」→ ${result.geju}。',
      ));
    }
  }

  final allPo = allGe.map((g) => g.poGe).toList();
  final allXiang = allGe.map((g) => g.xiangShen).toList();
  for (final g in allGe) {
    qs.add(Question(
      id: 'geju-po-${g.name}', subject: g.name, subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '论命', category: '格局 · 破神',
      prompt: '「${g.name}」最怕什么「破格之神」？',
      options: makeOptions(g.poGe, allPo), answer: g.poGe,
      explanation: '${g.name}：${g.meaning}\n\n破格之神：${g.poGe}\n相神（救应）：${g.xiangShen}',
    ));
    qs.add(Question(
      id: 'geju-xiang-${g.name}', subject: g.name, subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '论命', category: '格局 · 相神',
      prompt: '「${g.name}」的「相神」（成格护格之神）是？',
      options: makeOptions(g.xiangShen, allXiang), answer: g.xiangShen,
      explanation: '${g.name}：${g.meaning}\n\n相神 = ${g.xiangShen}。',
    ));
  }

  final thPool = tiaohouTable.map((t) => t.first).toList();
  for (final t in tiaohouTable) {
    qs.add(Question(
      id: 'ys-th-table-${t.dm}-${t.season}', subject: '${t.dm}/${t.season}', subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '论命', category: '用神 · 调候查表',
      prompt: '${t.dm} 生于 ${t.season}，按《穷通宝鉴》调候首用？',
      options: makeOptions(t.first, thPool), answer: t.first,
      explanation: '${t.dm} 生于 ${t.season}：首用 ${t.first}，次用 ${t.second}。\n${t.note}',
    ));
  }

  return qs;
}

List<Question> genXingmingQuestions() {
  final qs = <Question>[];
  final yunPool = ['主运（核心，性格、中年）', '前运（青年、子女）', '后运（晚年、整体）', '副运（人际、外围）', '先天运（祖上、父母）'];
  for (final g in wuGe) {
    qs.add(Question(
      id: 'xm-def-${g.name}', subject: g.name, subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '姓名学', category: '姓名学 · 五格定义',
      prompt: '五格里「${g.name}」代表什么运势？',
      options: makeOptions(g.yun, yunPool), answer: g.yun,
      explanation: '【${g.name}】${g.meaning}\n运势：${g.yun}\n算法：${g.algorithm}\n\n⚠️ 姓名学 ≠ 八字。',
    ));
  }
  for (final tail in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
    final wx = strokeWuxing[tail]!;
    qs.add(Question(
      id: 'xm-wx-$tail', subject: '尾数$tail', subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '姓名学', category: '姓名学 · 五行对应',
      prompt: '姓名笔画尾数为「$tail」，对应什么五行？',
      options: makeOptions(wx, ['木', '火', '土', '金', '水']), answer: wx,
      explanation: '笔画尾数 $tail → 五行 $wx\n对应表：1,2木 / 3,4火 / 5,6土 / 7,8金 / 9,0水。',
    ));
  }
  final luckSamples = [
    (1, '吉'), (4, '凶'), (6, '吉'), (9, '凶'), (11, '吉'), (14, '凶'),
    (15, '吉'), (18, '吉'), (24, '吉'), (34, '凶'), (81, '吉'), (80, '凶'),
  ];
  for (final s in luckSamples) {
    final shuli = getShuli(s.$1);
    qs.add(Question(
      id: 'xm-luck-${s.$1}', subject: '${s.$1}', subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '姓名学', category: '姓名学 · 吉凶',
      prompt: '数理「${s.$1}」是吉还是凶？',
      options: makeOptions(s.$2, ['吉', '凶', '半吉']), answer: s.$2,
      explanation: '数理 ${s.$1}：${shuli.keyword}（${s.$2}）。\n${shuli.meaning}\n\n⚠️ 姓名学 ≠ 八字。',
    ));
  }
  final scPool = ['吉', '凶', '半吉'];
  for (final c in sancaiConfigs) {
    qs.add(Question(
      id: 'xm-sc-${c.pattern}', subject: c.pattern, subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '姓名学', category: '姓名学 · 三才',
      prompt: '三才配置「${c.pattern}」是吉是凶？',
      options: makeOptions(c.luck.label, scPool), answer: c.luck.label,
      explanation: '${c.pattern}：${c.luck.label}\n${c.meaning}',
    ));
  }
  return qs;
}

List<Question> genZhenquanQuestions() {
  return zhenquanQuestions
      .map((q) => Question(
            id: q.id,
            subject: q.category,
            subjectType: SubjectType.tiangan,
            field: 'advanced',
            fieldLabel: '子平真诠',
            prompt: q.prompt,
            options: q.options,
            answer: q.answer,
            explanation: q.explanation,
            category: q.category,
          ))
      .toList();
}

const _shishenToGeju = {
  '比肩': '建禄格',
  '劫财': '月劫格',
  '食神': '食神格',
  '伤官': '伤官格',
  '正财': '正财格',
  '偏财': '偏财格',
  '正官': '正官格',
  '七杀（偏官）': '七杀格',
  '正印': '正印格',
  '偏印（枭神）': '偏印格',
};

List<Question> genShishenQuestions(String dm) {
  final qs = <Question>[];
  for (final tg in allStems) {
    final tenGod = getTenGod(dm, tg);
    qs.add(Question(
      id: 'ss10-god-$dm-$tg', subject: '$dm/$tg', subjectType: SubjectType.tiangan,
      field: 'advanced', fieldLabel: '十神', category: '十神关系',
      prompt: '「$dm」见「$tg」，是什么十神关系？',
      options: makeOptions(tenGod, tenGodPool), answer: tenGod,
      explanation: '日主$dm见$tg → 十神：$tenGod。',
    ));
  }
  final gejuPool = _shishenToGeju.values.toSet().toList();
  for (final dz in dizhi) {
    for (final cg in dz.canggan) {
      final tenGod = getTenGod(dm, cg.stem);
      final geju = _shishenToGeju[tenGod] ?? '正格';
      qs.add(Question(
        id: 'ss10-geju-$dm-${dz.char}-${cg.stem}', subject: '$dm/${dz.char}/${cg.stem}',
        subjectType: SubjectType.tiangan, field: 'advanced', fieldLabel: '格局', category: '格局识别',
        prompt: '日主「$dm」，月令「${dz.char}」，透「${cg.stem}」\n这是什么格局？',
        options: makeOptions(geju, gejuPool), answer: geju,
        explanation: '日主$dm，月令${dz.char}，透${cg.stem}为「$tenGod」→ $geju。',
      ));
    }
  }
  return qs;
}
