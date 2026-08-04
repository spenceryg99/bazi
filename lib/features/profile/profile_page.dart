import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insights_outlined, size: 56, color: AppColors.accent),
            const SizedBox(height: 12),
            const Text('答题统计 · 迁移中', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text('累计 / 正确率 / 错题本 / 薄弱点',
                style: TextStyle(fontSize: 13, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}
