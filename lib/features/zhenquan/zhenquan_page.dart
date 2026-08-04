import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/zhenquan.dart';

class ZhenquanPage extends StatefulWidget {
  const ZhenquanPage({super.key});

  @override
  State<ZhenquanPage> createState() => _ZhenquanPageState();
}

class _ZhenquanPageState extends State<ZhenquanPage> {
  int _vol = 1;
  String? _expanded;

  static const _volLabels = {
    1: '基础原理',
    2: '用神体系',
    3: '杂气·墓库·吉凶神',
    4: '六亲与行运',
    5: '格局分论',
  };
  static const _volNums = {1: '一', 2: '二', 3: '三', 4: '四', 5: '五'};

  @override
  Widget build(BuildContext context) {
    final chapters = zhenquanChapters.where((c) => c.volume == _vol).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('子平真诠 · 白话文精解')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(10)),
            child: Text('清·沈孝瞻 原著　|　逐句白话翻译·注解，格局派命理入门必读',
                style: TextStyle(fontSize: 13, color: AppColors.textSoft, height: 1.5)),
          ),
          Row(
            children: [
              for (final v in [1, 2, 3, 4, 5])
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _vol = v;
                      _expanded = null;
                    }),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _vol == v ? AppColors.accent.withValues(alpha: 0.08) : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _vol == v ? AppColors.accent : AppColors.borderSoft,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(_volNums[v]!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _vol == v ? AppColors.accent : AppColors.textDim)),
                          Text(_volLabels[v]!, style: TextStyle(fontSize: 10, color: _vol == v ? AppColors.accent : AppColors.textDim), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (final ch in chapters) _chapterCard(ch),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _chapterCard(ZhenquanChapter ch) {
    final open = _expanded == ch.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: open ? AppColors.accent : AppColors.borderSoft),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = open ? null : ch.id),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(child: Text(ch.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                  Icon(open ? Icons.expand_less : Icons.chevron_right, color: AppColors.textDim, size: 18),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderSoft))),
                    child: Text(ch.summary, style: TextStyle(fontSize: 13, color: AppColors.textSoft, height: 1.6)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.06),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                      border: Border(left: BorderSide(color: AppColors.accent, width: 3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('核心', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(ch.coreIdea, style: TextStyle(fontSize: 13, color: AppColors.text, height: 1.6)),
                      ],
                    ),
                  ),
                  for (final cpt in ch.concepts)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.bgElev, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cpt.term, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accent)),
                          const SizedBox(height: 2),
                          Text(cpt.def, style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
