import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/types.dart';
import '../../shared/utils/haptic.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.question,
    this.correctAutoMs = 0,
    this.wrongAutoMs = 0,
    this.showExplanation = true,
    this.nextLabel = '下一题 →',
    this.onAnswered,
    this.onNext,
  });

  final Question question;
  final int correctAutoMs;
  final int wrongAutoMs;
  final bool showExplanation;
  final String nextLabel;
  final void Function(bool isCorrect)? onAnswered;
  final VoidCallback? onNext;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? _selected;
  bool _answered = false;
  Timer? _timer;

  bool get _isCorrect => _selected == widget.question.answer;

  bool get _isManual =>
      _answered && ((_isCorrect ? widget.correctAutoMs : widget.wrongAutoMs) == 0);

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _timer?.cancel();
      _timer = null;
      _selected = null;
      _answered = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _choose(String opt) {
    if (_answered) return;
    Haptic.tap();
    setState(() {
      _selected = opt;
      _answered = true;
    });
    widget.onAnswered?.call(_isCorrect);
    if (widget.showExplanation) {
      if (_isCorrect) {
        Haptic.correct();
      } else {
        Haptic.wrong();
      }
    }
    final delay = _isCorrect ? widget.correctAutoMs : widget.wrongAutoMs;
    if (delay > 0) {
      _timer = Timer(Duration(milliseconds: delay), _doNext);
    }
  }

  void _doNext() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _selected = null;
      _answered = false;
    });
    widget.onNext?.call();
  }

  Color? _optColor(String opt) {
    if (!_answered) return null;
    if (opt == widget.question.answer) return AppColors.correct;
    if (opt == _selected) return AppColors.wrong;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q.subject, style: TextStyle(fontSize: 15, color: AppColors.textDim)),
              const SizedBox(height: 8),
              Text(q.prompt, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, height: 1.5)),
              if (q.category != null) ...[
                const SizedBox(height: 10),
                Text(q.category!, style: TextStyle(fontSize: 11, color: AppColors.accent)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        for (final opt in q.options) ...[
          _option(opt),
          const SizedBox(height: 10),
        ],
        if (_answered) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_isCorrect ? Icons.check_circle : Icons.cancel,
                        color: _isCorrect ? AppColors.correct : AppColors.wrong, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _isCorrect ? '答对了' : '正确答案：${q.answer}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _isCorrect ? AppColors.correct : AppColors.wrong,
                      ),
                    ),
                  ],
                ),
                if (widget.showExplanation) ...[
                  const SizedBox(height: 10),
                  Text(q.explanation,
                      style: TextStyle(fontSize: 13.5, height: 1.7, color: AppColors.textSoft)),
                ] else ...[
                  const SizedBox(height: 6),
                  Text(_isManual ? '' : '自动跳转中…',
                      style: TextStyle(fontSize: 12, color: AppColors.textDim)),
                ],
                if (_isManual) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _doNext,
                      child: Text(widget.nextLabel),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _option(String opt) {
    final color = _optColor(opt);
    return GestureDetector(
      onTap: () => _choose(opt),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: color != null
              ? (color == AppColors.correct ? AppColors.correct.withValues(alpha: 0.12) : AppColors.wrong.withValues(alpha: 0.12))
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color ?? AppColors.borderSoft,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(opt, style: const TextStyle(fontSize: 17)),
            ),
            if (_answered && opt == widget.question.answer)
              Icon(Icons.check, color: AppColors.correct, size: 20),
            if (_answered && opt == _selected && opt != widget.question.answer)
              Icon(Icons.close, color: AppColors.wrong, size: 20),
            if (_answered && opt != _selected && opt != widget.question.answer)
              Icon(Icons.remove, color: AppColors.textDim.withValues(alpha: 0.3), size: 16),
          ],
        ),
      ),
    );
  }
}
