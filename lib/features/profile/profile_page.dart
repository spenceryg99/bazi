import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../providers/progress_provider.dart';
import '../../providers/wrong_book_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    final wrong = ref.watch(wrongBookProvider);
    final rate = p.total == 0 ? 0.0 : p.correct / p.total;
    final weak = ref.read(wrongBookProvider.notifier).weakCategories();

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Row(
            children: [
              _stat('累计答题', '${p.total}'),
              const SizedBox(width: 12),
              _stat('正确率', '${(rate * 100).toStringAsFixed(1)}%'),
              const SizedBox(width: 12),
              _stat('错题本', '${wrong.length}'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('薄弱分类', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              if (wrong.isNotEmpty)
                TextButton(
                  onPressed: () => ref.read(wrongBookProvider.notifier).clear(),
                  child: Text('清空', style: TextStyle(fontSize: 13, color: AppColors.wrong)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (weak.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(wrong.isEmpty ? '还没有错题，继续加油！' : '暂无薄弱分类',
                    style: TextStyle(color: AppColors.textDim, fontSize: 13)),
              ),
            )
          else
            for (final w in weak.take(8)) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(w.key, style: const TextStyle(fontSize: 14))),
                    Text('${w.value} 错',
                        style: TextStyle(fontSize: 13, color: AppColors.wrong, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => ref.read(progressProvider.notifier).reset(),
              child: Text('重置进度', style: TextStyle(color: AppColors.textDim)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.accent)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}
