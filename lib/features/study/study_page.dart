import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('天干地支 · 释义')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _entryCard(
            context,
            title: '地支六大关系',
            subtitle: '六合 · 六冲 · 三合 · 三刑 · 三会 · 六害',
            gradient: const [Color(0x26B88DFF), Color(0x1A3B7DD8)],
          ),
          _entryCard(
            context,
            title: '子平论命流程',
            subtitle: '格局派 vs 旺衰派 · 标准次序 + 八正格',
            gradient: const [Color(0x26B85CD1), Color(0x1A3FA66A)],
          ),
          _entryCard(
            context,
            title: '姓名学 · 五格剖象法',
            subtitle: '五格 + 81 数理（≠ 八字）',
            gradient: const [Color(0x26C89A3A), Color(0x1A9AA3AD)],
          ),
          const SizedBox(height: 16),
          Text('数据迁移中', textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textDim, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _entryCard(BuildContext context,
      {required String title, required String subtitle, required List<Color> gradient}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient.first.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(fontSize: 11, color: AppColors.textDim)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.accent),
        ],
      ),
    );
  }
}
