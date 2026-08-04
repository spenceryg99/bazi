import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/types.dart';
import '../domain/quiz_generator.dart';

class QuizSession {
  final List<Question> queue;
  final int index;
  final int correctCount;
  final bool started;
  final bool finished;

  const QuizSession({
    this.queue = const [],
    this.index = 0,
    this.correctCount = 0,
    this.started = false,
    this.finished = false,
  });

  QuizSession copyWith({
    List<Question>? queue,
    int? index,
    int? correctCount,
    bool? started,
    bool? finished,
  }) =>
      QuizSession(
        queue: queue ?? this.queue,
        index: index ?? this.index,
        correctCount: correctCount ?? this.correctCount,
        started: started ?? this.started,
        finished: finished ?? this.finished,
      );

  Question? get current => index < queue.length ? queue[index] : null;
  int get total => queue.length;
}

final quizSessionProvider =
    NotifierProvider<QuizSessionNotifier, QuizSession>(QuizSessionNotifier.new);

class QuizSessionNotifier extends Notifier<QuizSession> {
  @override
  QuizSession build() => const QuizSession();

  void start(List<Question> queue) {
    state = QuizSession(queue: shuffle(queue), index: 0, correctCount: 0, started: true);
    if (state.total == 0) {
      state = state.copyWith(finished: true);
    }
  }

  void next() {
    if (state.index < state.total - 1) {
      state = state.copyWith(index: state.index + 1);
    } else {
      state = state.copyWith(finished: true);
    }
  }

  void prev() {
    if (state.index > 0) state = state.copyWith(index: state.index - 1);
  }

  void incCorrect() => state = state.copyWith(correctCount: state.correctCount + 1);

  void reset() => state = const QuizSession();
}

List<Question> buildQueue(QuizScope scope, {String? dm}) {
  if (scope == QuizScope.shishen && dm != null) {
    return shuffle(genShishenQuestions(dm));
  }
  final pool = getQuestionPool(scope);
  final q = shuffle(pool);
  return q.length > 10 ? q.take(10).toList() : q;
}
