import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/geju.dart';
import '../../data/lunming.dart';

class LunmingPage extends StatefulWidget {
  const LunmingPage({super.key});

  @override
  State<LunmingPage> createState() => _LunmingPageState();
}

class _LunmingPageState extends State<LunmingPage> {
  int _activeCase = 0;
  String? _expandedGe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('子平论命流程')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('子平三书', [
            for (final c in classics)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgElev,
                  borderRadius: BorderRadius.circular(10),
                  border: Border(left: BorderSide(color: AppColors.accent, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.accent)),
                    const SizedBox(height: 2),
                    Text('${c.author}　·　${c.school}', style: TextStyle(fontSize: 11, color: AppColors.textDim)),
                    const SizedBox(height: 6),
                    Text(c.core, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
                    const SizedBox(height: 4),
                    Text('「${c.role}」', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.tu)),
                  ],
                ),
              ),
          ]),
          for (final s in schools)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: Color(s.color), width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(s.color))),
                  const SizedBox(height: 6),
                  Text(s.core, style: TextStyle(fontSize: 13, color: AppColors.textSoft, height: 1.6)),
                  const SizedBox(height: 6),
                  Text('📕 ${s.classics}', style: TextStyle(fontSize: 12, color: AppColors.textDim)),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '用神：', style: TextStyle(fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w600)),
                        TextSpan(text: s.yongshenLogic, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          _section('六步流程对比', [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final s in schools)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(s.color)))),
                            child: Text('${s.shortName}派', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(s.color))),
                          ),
                          for (final st in s.steps) ...[
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 18, height: 18,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Color(s.color), shape: BoxShape.circle),
                                  child: Text('${st.order}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(st.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                      Text(st.detail, style: TextStyle(fontSize: 9, color: AppColors.textDim, height: 1.3)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ]),
          _section('三派差异', [_compareTable()]),
          _section('🌡️ 调候用神速查（《穷通宝鉴》节选）', [
            Text('按日主×季节查调候喜用，寒暖失衡时优先查此表', style: TextStyle(fontSize: 11, color: AppColors.textDim)),
            const SizedBox(height: 8),
            for (final t in tiaohouTable)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.bgElev,
                  borderRadius: BorderRadius.circular(10),
                  border: Border(left: BorderSide(color: AppColors.shui, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(t.dm, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Text(t.season, style: TextStyle(fontSize: 11, color: AppColors.textDim)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text('首用：${t.first}　次用：${t.second}', style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 3),
                    Text(t.note, style: TextStyle(fontSize: 11, color: AppColors.textDim, height: 1.4)),
                  ],
                ),
              ),
          ]),
          _section('经典案例 · 两派分别取用', [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < classicCases.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(classicCases[i].title),
                        selected: _activeCase == i,
                        onSelected: (_) => setState(() => _activeCase = i),
                        selectedColor: AppColors.accent,
                        labelStyle: TextStyle(fontSize: 12, color: _activeCase == i ? Colors.white : AppColors.textSoft),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _caseBody(classicCases[_activeCase]),
          ]),
          _section('现代融合做法', [
            for (int i = 0; i < modernFusion.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${i + 1}. ', style: TextStyle(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w600)),
                    Expanded(child: Text(modernFusion[i], style: TextStyle(fontSize: 13, color: AppColors.textSoft, height: 1.6))),
                  ],
                ),
              ),
          ]),
          _section('学习路径建议', [
            for (int i = 0; i < learningPath.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22, height: 22,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                      child: Text('${i + 1}', style: const TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(learningPath[i].phase, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text(learningPath[i].content, style: TextStyle(fontSize: 12, color: AppColors.textDim)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ]),
          _section('八正格速查（点格名看详情）', [
            for (final g in allGe) _gejuItem(g),
          ]),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 13, color: AppColors.textDim, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _compareTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              _cell('维度', 52, AppColors.textDim, bold: true, small: true),
              _cell('格局派', 0, const Color(0xFFB85CD1), bold: true, small: true),
              _cell('旺衰派', 0, AppColors.mu, bold: true, small: true),
              _cell('调候派', 0, AppColors.shui, bold: true, small: true),
            ],
          ),
        ),
        for (final c in comparePoints)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.bgElev, borderRadius: BorderRadius.circular(6)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cell(c.aspect, 52, AppColors.text, bold: true),
                _cell(c.geju, 0, const Color(0xFFB85CD1)),
                _cell(c.wangshuai, 0, AppColors.mu),
                _cell(c.tiaohou, 0, AppColors.shui),
              ],
            ),
          ),
      ],
    );
  }

  Widget _cell(String t, double w, Color c, {bool bold = false, bool small = false}) {
    return Expanded(
      flex: w > 0 ? 0 : 1,
      child: SizedBox(
        width: w > 0 ? w : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(t,
              style: TextStyle(fontSize: small ? 10 : 11, color: c, fontWeight: bold ? FontWeight.w600 : FontWeight.normal, height: 1.3)),
        ),
      ),
    );
  }

  Widget _caseBody(ClassicCase c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.bgElev, borderRadius: BorderRadius.circular(10)),
          child: Text(c.bazi, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
        ),
        const SizedBox(height: 10),
        Text(c.analysis, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.6)),
        const SizedBox(height: 10),
        _caseSchool('格局派', c.gejuSchool.geju, c.gejuSchool.yongshen, c.gejuSchool.reason, const Color(0xFFB85CD1), '格局'),
        _caseSchool('旺衰派', c.wangshuaiSchool.strength, c.wangshuaiSchool.yongshen, c.wangshuaiSchool.reason, AppColors.mu, '旺衰'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '差异：', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text)),
                TextSpan(text: c.compare, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _caseSchool(String name, String top, String ys, String reason, Color color, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgElev,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text('$label：$top', style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
          Text('用神：$ys', style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
          const SizedBox(height: 4),
          Text(reason, style: TextStyle(fontSize: 12, color: AppColors.textDim, fontStyle: FontStyle.italic, height: 1.5)),
        ],
      ),
    );
  }

  Widget _gejuItem(Geju g) {
    final c = g.category == GejuCategory.zheng ? const Color(0xFFB85CD1) : AppColors.shui;
    final open = _expandedGe == g.name;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.bgElev,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: c, width: 3)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => _expandedGe = open ? null : g.name),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Text(g.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(999)),
                    child: Text(g.category.label, style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                  const Spacer(),
                  Icon(open ? Icons.expand_less : Icons.chevron_right, color: AppColors.textDim, size: 18),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _gLine('取格', g.monthlyRule),
                  _gLine('成格', g.chengGe),
                  _gLine('破格', g.poGe),
                  _gLine('相神', g.xiangShen),
                  _gLine('含义', g.meaning),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _gLine(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: '$k：', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text)),
            TextSpan(text: v, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
