import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('挑战')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_outlined, size: 56, color: AppColors.accent),
            const SizedBox(height: 12),
            const Text('挑战模式 · 即将上线', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
