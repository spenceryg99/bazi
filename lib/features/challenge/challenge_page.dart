import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../data/types.dart';
import '../../domain/quiz_generator.dart';
import '../../providers/progress_provider.dart';
import '../../providers/wrong_book_provider.dart';
import '../../shared/widgets/large_title_scroll.dart';
import '../../shared/widgets/question_card.dart';

class ChallengePage extends ConsumerStatefulWidget {
  const ChallengePage({super.key});

  @override
  ConsumerState<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends ConsumerState<ChallengePage> {
  static const _duration = 60;
  static const _scopes = <(QuizScope, String)>[
    (QuizScope.all, '全部'),
    (QuizScope.tiangan, '天干'),
    (QuizScope.dizhi, '地支'),
    (QuizScope.canggan, '藏干'),
    (QuizScope.relations, '关系'),
    (QuizScope.lunming, '论命'),
    (QuizScope.xingming, '姓名学'),
    (QuizScope.advanced, '进阶'),
  ];

  QuizScope _scope = QuizScope.all;
  bool _started = false;
  bool _finished = false;
  int _timeLeft = _duration;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _answered = 0;
  Question? _current;
  Timer? _timer;

  void _pickNext() {
    final pool = getQuestionPool(_scope);
    if (pool.isEmpty) return;
    _current = shuffle(pool).first;
    setState(() {});
  }

  void _start() {
    setState(() {
      _started = true;
      _finished = false;
      _timeLeft = _duration;
      _score = 0;
      _streak = 0;
      _maxStreak = 0;
      _answered = 0;
    });
    _pickNext();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) _end();
    });
  }

  void _end() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _finished = true;
      _current = null;
    });
  }

  void _onAnswered(bool ok) {
    if (_current != null) {
      ref.read(progressProvider.notifier).record(_current!.fieldLabel, ok);
      if (!ok) ref.read(wrongBookProvider.notifier).markWrong(_current!);
    }
    setState(() => _answered++);
    if (ok) {
      setState(() {
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
        _score += 10 + (_streak - 1).clamp(0, 5) * 2;
      });
    } else {
      setState(() => _streak = 0);
    }
  }

  void _onNext() {
    if (_timeLeft > 0) _pickNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return _setup;
    if (_finished) return _done;
    return _play;
  }

  Widget get _setup => Scaffold(
        body: LargeTitleScroll(
          title: '挑战',
          children: [
            const Text('限时 60 秒，连击加倍，看你能答多少',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 2.2,
              children: [
                for (final o in _scopes)
                  _scopeChip(o.$1, o.$2),
              ],
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _start,
              child: const Text('开始挑战'),
            ),
          ],
        ),
      );

  Widget _scopeChip(QuizScope v, String label) {
    final on = _scope == v;
    return GestureDetector(
      onTap: () => setState(() => _scope = v),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: on ? AppColors.accent : AppColors.borderSoft, width: 1.5),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, color: on ? AppColors.accent : AppColors.textSoft)),
      ),
    );
  }

  Widget get _play => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('⏱ ${_timeLeft}s',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _timeLeft <= 10 ? AppColors.wrong : AppColors.text,
                  )),
              const SizedBox(width: 16),
              Text('得分 $_score', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.accent)),
              if (_streak >= 2) ...[
                const SizedBox(width: 16),
                Text('🔥 $_streak 连击', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.huo)),
              ],
            ],
          ),
        ),
        body: _current == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  QuestionCard(
                    key: ValueKey(_current!.id),
                    question: _current!,
                    correctAutoMs: 900,
                    wrongAutoMs: 900,
                    showExplanation: false,
                    nextLabel: '跳过讲解 →',
                    onAnswered: _onAnswered,
                    onNext: _onNext,
                  ),
                ],
              ),
      );

  Widget get _done => Scaffold(
        appBar: AppBar(title: const Text('⚡ 60秒挑战')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$_score', style: TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: AppColors.accent)),
                const SizedBox(height: 4),
                Text('最终得分', style: TextStyle(fontSize: 14, color: AppColors.textDim)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('答了 $_answered 题', style: TextStyle(fontSize: 13, color: AppColors.textSoft)),
                    const SizedBox(width: 20),
                    Text('最高 $_maxStreak 连击', style: TextStyle(fontSize: 13, color: AppColors.textSoft)),
                  ],
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => setState(() {
                    _started = false;
                    _finished = false;
                  }),
                  child: const Text('再来一次'),
                ),
              ],
            ),
          ),
        ),
      );
}
