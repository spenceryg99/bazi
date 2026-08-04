import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../providers/progress_provider.dart';
import '../../providers/wrong_book_provider.dart';
import '../../shared/utils/haptic.dart';
import '../../shared/widgets/large_title_scroll.dart';
import '../../shared/widgets/section.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    final wrong = ref.watch(wrongBookProvider);
    final rate = p.total == 0 ? 0.0 : p.correct / p.total;
    final weak = ref.read(wrongBookProvider.notifier).weakCategories();

    return Scaffold(
      body: LargeTitleScroll(
        title: '我的',
        children: [
          Row(
            children: [
              _stat('累计答题', '${p.total}'),
              const SizedBox(width: 8),
              _stat('正确率', '${(rate * 100).toStringAsFixed(1)}%'),
              const SizedBox(width: 8),
              _stat('错题本', '${wrong.length}', highlight: wrong.isNotEmpty),
            ],
          ),
          Section(
            header: '薄弱分类',
            footer: wrong.isEmpty ? null : '错题连续答对 2 次自动移出错题本',
            children: weak.isEmpty
                ? [_tip(wrong.isEmpty ? '还没有错题，继续加油！' : '暂无薄弱分类')]
                : [for (final w in weak.take(8)) _weakRow(w.key, w.value)],
          ),
          Section(
            header: '数据管理',
            children: [
              _action(
                CupertinoIcons.delete,
                '清空错题本',
                wrong.isEmpty ? null : () { Haptic.tap(); ref.read(wrongBookProvider.notifier).clear(); },
                color: AppColors.wrong,
              ),
              _action(
                CupertinoIcons.arrow_counterclockwise,
                '重置进度',
                () { Haptic.tap(); ref.read(progressProvider.notifier).reset(); },
                color: AppColors.text,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: highlight ? AppColors.wrong : AppColors.accent,
                  fontFamily: '.SF Pro Display',
                  letterSpacing: -0.5,
                )),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  Widget _tip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Center(child: Text(text, style: const TextStyle(color: AppColors.textTertiary, fontSize: 13))),
    );
  }

  Widget _weakRow(String key, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Expanded(child: Text(key, style: const TextStyle(fontSize: 15))),
          Text('$count 错',
              style: const TextStyle(fontSize: 14, color: AppColors.wrong, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String title, VoidCallback? onTap, {Color? color}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? AppColors.text),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(fontSize: 16, color: color ?? AppColors.text))),
            const Icon(CupertinoIcons.chevron_right, size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
