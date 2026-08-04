import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../domain/quiz_generator.dart';
import '../../providers/progress_provider.dart';
import '../../providers/quiz_session_provider.dart';
import '../../providers/wrong_book_provider.dart';
import '../../shared/widgets/question_card.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  QuizScope _scope = QuizScope.all;
  String _dm = '';

  static const _scopeOptions = <(QuizScope, String)>[
    (QuizScope.all, '全部'),
    (QuizScope.tiangan, '天干'),
    (QuizScope.dizhi, '地支'),
    (QuizScope.canggan, '藏干'),
    (QuizScope.relations, '关系'),
    (QuizScope.lunming, '论命'),
    (QuizScope.xingming, '姓名学'),
    (QuizScope.zhenquan, '子平真诠'),
    (QuizScope.shishen, '十神'),
    (QuizScope.advanced, '进阶'),
  ];

  static const _stems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

  int _count(QuizScope s) {
    if (s == QuizScope.shishen) return _dm.isEmpty ? 0 : genShishenQuestions(_dm).length;
    return getQuestionCount(s);
  }

  void _start() {
    if (_scope == QuizScope.shishen && _dm.isEmpty) return;
    ref.read(quizSessionProvider.notifier).start(buildQueue(_scope, dm: _dm.isEmpty ? null : _dm));
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizSessionProvider);
    if (!session.started) return _setup;
    if (session.finished) return _done(session);
    return _play(session);
  }

  Widget get _setup => Scaffold(
        appBar: AppBar(title: const Text('答题训练')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            const Text('每轮 10 题，答错附详细讲解',
                style: TextStyle(fontSize: 13, color: AppColors.textDim)),
            const SizedBox(height: 24),
            const Text('选择范围', style: TextStyle(fontSize: 13, color: AppColors.textDim)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.1,
              children: [
                for (final o in _scopeOptions)
                  _scopeButton(o.$1, o.$2, _count(o.$1)),
              ],
            ),
            if (_scope == QuizScope.shishen) ...[
              const SizedBox(height: 16),
              const Text('选择日主', style: TextStyle(fontSize: 12, color: AppColors.textDim)),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1.4,
                children: [
                  for (final s in _stems)
                    GestureDetector(
                      onTap: () => setState(() => _dm = s),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _dm == s ? AppColors.accent.withValues(alpha: 0.12) : AppColors.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _dm == s ? AppColors.accent : AppColors.borderSoft,
                            width: 1.5,
                          ),
                        ),
                        child: Text(s,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _dm == s ? AppColors.accent : AppColors.textSoft,
                            )),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _scope == QuizScope.shishen && _dm.isEmpty ? null : _start,
              child: const Text('开始答题'),
            ),
          ],
        ),
      );

  Widget _scopeButton(QuizScope v, String label, int count) {
    final on = _scope == v;
    return GestureDetector(
      onTap: () => setState(() => _scope = v),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: on ? AppColors.accent : AppColors.borderSoft,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 15,
                  color: on ? AppColors.accent : AppColors.textSoft,
                )),
            const SizedBox(height: 2),
            Text('$count', style: TextStyle(fontSize: 11, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }

  Widget _play(QuizSession session) {
    final q = session.current;
    if (q == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text('${session.index + 1} / ${session.total}　✓ ${session.correctCount}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          LinearProgressIndicator(
            value: (session.index + 1) / session.total,
            backgroundColor: AppColors.bgCard,
            color: AppColors.accent,
            minHeight: 4,
          ),
          const SizedBox(height: 16),
          QuestionCard(
            key: ValueKey(q.id),
            question: q,
            correctAutoMs: 2200,
            wrongAutoMs: 0,
            nextLabel: '看完讲解，下一题 →',
            onAnswered: (ok) {
              ref.read(progressProvider.notifier).record(q.fieldLabel, ok);
              if (!ok) ref.read(wrongBookProvider.notifier).markWrong(q);
              if (ok) ref.read(quizSessionProvider.notifier).incCorrect();
            },
            onNext: () => ref.read(quizSessionProvider.notifier).next(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: session.index == 0 ? null : () => ref.read(quizSessionProvider.notifier).prev(),
                  child: const Text('上一题'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => ref.read(quizSessionProvider.notifier).next(),
                  child: const Text('跳过'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _done(QuizSession session) {
    final correct = session.correctCount;
    final total = session.total;
    final verdict = correct == total
        ? '💯 全对！地基已稳'
        : correct >= total * 0.8
            ? '👍 不错，再练几轮'
            : correct >= total * 0.6
                ? '💪 及格，继续巩固'
                : '📖 多翻学习模式，回头再战';
    return Scaffold(
      appBar: AppBar(title: const Text('答题训练')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$correct / $total',
                  style: TextStyle(fontSize: 56, fontWeight: FontWeight.w700, color: AppColors.accent)),
              const SizedBox(height: 14),
              Text(verdict,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: AppColors.textSoft)),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _start,
                child: const Text('再来一轮'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => ref.read(quizSessionProvider.notifier).reset(),
                child: const Text('换范围'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
