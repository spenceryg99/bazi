import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

enum Wuxing { mu, huo, tu, jin, shui }

extension WuxingX on Wuxing {
  String get label => switch (this) {
        Wuxing.mu => '木',
        Wuxing.huo => '火',
        Wuxing.tu => '土',
        Wuxing.jin => '金',
        Wuxing.shui => '水',
      };

  Color get color => switch (this) {
        Wuxing.mu => AppColors.mu,
        Wuxing.huo => AppColors.huo,
        Wuxing.tu => AppColors.tu,
        Wuxing.jin => AppColors.jin,
        Wuxing.shui => AppColors.shui,
      };
}

class WuxingBadge extends StatelessWidget {
  const WuxingBadge(this.wuxing, {super.key, this.label});
  final Wuxing wuxing;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: wuxing.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label ?? wuxing.label,
        style: TextStyle(color: wuxing.color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
