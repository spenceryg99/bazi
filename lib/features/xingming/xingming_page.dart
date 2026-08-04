import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/xingming.dart';

class XingmingPage extends StatefulWidget {
  const XingmingPage({super.key});

  @override
  State<XingmingPage> createState() => _XingmingPageState();
}

class _XingmingPageState extends State<XingmingPage> {
  final _surname = TextEditingController(text: '11');
  final _ming1 = TextEditingController(text: '3');
  final _ming2 = TextEditingController(text: '0');

  int _num(TextEditingController c) => int.tryParse(c.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final s = _num(_surname), m1 = _num(_ming1), m2 = _num(_ming2);
    final hasM2 = m2 > 0;
    final tian = s + 1;
    final ren = s + m1;
    final di = hasM2 ? m1 + m2 : m1 + 1;
    final zong = s + m1 + (hasM2 ? m2 : 0);
    final wai = zong - ren + 1;
    final grids = [
      ('天格', tian), ('人格', ren), ('地格', di), ('外格', wai), ('总格', zong),
    ];
    final sancai = '${strokeToWuxing(tian)}→${strokeToWuxing(ren)}→${strokeToWuxing(di)}';

    return Scaffold(
      appBar: AppBar(title: const Text('姓名学 · 五格剖象法')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.wrong.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.wrong.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.6),
                children: [
                  const TextSpan(text: '⚠️ ', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.wrong)),
                  TextSpan(text: '姓名学 ≠ 八字命理', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.wrong)),
                  const TextSpan(text: '。五格剖象法是熊崎式姓名数理体系，看名字笔画吉凶；八字看出生时间。两者平行，详见底部争议。'),
                ],
              ),
            ),
          ),
          _section('五格定义', [
            for (final g in wuGe)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.bgElev, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(g.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(999)),
                          child: Text(g.yun, style: TextStyle(fontSize: 11, color: AppColors.accent)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(g.meaning, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '算法：', style: TextStyle(fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w600)),
                          TextSpan(text: g.algorithm, style: TextStyle(fontSize: 12, color: AppColors.textDim)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ]),
          _section('🧮 五格计算器', [
            Text('输入康熙繁体笔画（单字名第二字填 0）', style: TextStyle(fontSize: 11, color: AppColors.textDim)),
            const SizedBox(height: 10),
            Row(
              children: [
                _input('姓笔画', _surname),
                const SizedBox(width: 8),
                _input('名第1字', _ming1),
                const SizedBox(width: 8),
                _input('名第2字', _ming2),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                for (final g in grids)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bgElev,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(top: BorderSide(color: AppColors.wuxing(strokeToWuxing(g.$2)), width: 3)),
                      ),
                      child: _calcGrid(g.$1, g.$2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.bgElev, borderRadius: BorderRadius.circular(10)),
              child: Text('三才配置：$sancai', style: const TextStyle(fontSize: 13)),
            ),
          ]),
          _section('81 数理吉凶表', [
            Container(
              constraints: const BoxConstraints(maxHeight: 480),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shuli81.length,
                itemBuilder: (_, i) {
                  final s = shuli81[i];
                  final c = s.luck == Luck.ji
                      ? AppColors.correct
                      : s.luck == Luck.xiong
                          ? AppColors.wrong
                          : AppColors.tu;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.bgElev,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(left: BorderSide(color: c, width: 3)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 28, child: Text('${s.num}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(s.keyword, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(s.luck.label, style: TextStyle(fontSize: 10, color: c)),
                                ],
                              ),
                              Text(s.meaning, style: TextStyle(fontSize: 11, color: AppColors.textDim, height: 1.3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
          _section('三才配置（天/人/地五行组合）', [
            for (final c in sancaiConfigs)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.bgElev,
                  borderRadius: BorderRadius.circular(10),
                  border: Border(left: BorderSide(color: c.luck == Luck.ji ? AppColors.correct : c.luck == Luck.xiong ? AppColors.wrong : AppColors.tu, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(c.pattern, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Text(c.luck.label, style: TextStyle(fontSize: 11, color: c.luck == Luck.ji ? AppColors.correct : c.luck == Luck.xiong ? AppColors.wrong : AppColors.tu)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(c.meaning, style: TextStyle(fontSize: 11, color: AppColors.textDim, height: 1.4)),
                  ],
                ),
              ),
          ]),
          _section('与八字的关系', [
            Text(relationToBazi, style: TextStyle(fontSize: 13, color: AppColors.textSoft, height: 1.7)),
          ]),
          _section('⚠️ 争议与边界', [
            for (final c in controversy)
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(fontSize: 12, color: AppColors.wrong)),
                    Expanded(child: Text(c, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.6))),
                  ],
                ),
              ),
          ]),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textDim)),
          const SizedBox(height: 4),
          TextField(
            controller: c,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.borderSoft)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.accent)),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _calcGrid(String name, int num) {
    final s = getShuli(num);
    final wx = strokeToWuxing(num);
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 11, color: AppColors.textDim)),
        Text('$num', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        Text('五行 $wx', style: TextStyle(fontSize: 10, color: AppColors.textSoft)),
        Text(s.luck.label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: s.luck == Luck.ji ? AppColors.correct : s.luck == Luck.xiong ? AppColors.wrong : AppColors.tu)),
        Text(s.keyword, style: TextStyle(fontSize: 10, color: AppColors.textDim), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
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
}
