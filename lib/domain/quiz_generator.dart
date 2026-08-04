import '../data/types.dart';
import 'quiz_generators.dart';
import 'quiz_generators2.dart';

export 'quiz_generators.dart' show shuffle, makeOptions;
export 'quiz_generators2.dart' show genShishenQuestions;

enum QuizScope { all, tiangan, dizhi, canggan, relations, lunming, xingming, advanced, zhenquan, shishen }

final List<Question> _allQuestions = [
  ...genTianganQuestions(),
  ...genDizhiQuestions(),
  ...genCangganQuestions(),
  ...genRelationQuestions(),
  ...genLunmingQuestions(),
  ...genXingmingQuestions(),
  ...genAdvancedQuestions(),
  ...genZhenquanQuestions(),
];

List<Question> getQuestionPool(QuizScope scope) {
  switch (scope) {
    case QuizScope.tiangan:
      return genTianganQuestions();
    case QuizScope.dizhi:
      return genDizhiQuestions();
    case QuizScope.canggan:
      return genCangganQuestions();
    case QuizScope.relations:
      return genRelationQuestions();
    case QuizScope.lunming:
      return genLunmingQuestions();
    case QuizScope.xingming:
      return genXingmingQuestions();
    case QuizScope.advanced:
      return genAdvancedQuestions();
    case QuizScope.zhenquan:
      return genZhenquanQuestions();
    case QuizScope.shishen:
      return [];
    case QuizScope.all:
      return List<Question>.from(_allQuestions);
  }
}

List<Question> getRandomQuestions(QuizScope scope, int count) {
  return shuffle(getQuestionPool(scope)).take(count).toList();
}

int getQuestionCount(QuizScope scope) => getQuestionPool(scope).length;

List<Question> getAllQuestionPool() => _allQuestions;

Question? getQuestionById(String id) {
  for (final q in _allQuestions) {
    if (q.id == id) return q;
  }
  return null;
}
