import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('答题训练')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_note_outlined, size: 56, color: AppColors.accent),
            const SizedBox(height: 12),
            const Text('答题模式 · 题库迁移中', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text('每轮 10 题，答错附详细讲解',
                style: TextStyle(fontSize: 13, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}
