import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/types.dart';

final progressProvider = NotifierProvider<ProgressNotifier, Progress>(ProgressNotifier.new);

class ProgressNotifier extends Notifier<Progress> {
  static const _key = 'bazi-progress-v1';
  SharedPreferences? _prefs;

  @override
  Progress build() {
    _load();
    return Progress();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_key);
    if (raw != null) {
      final parts = raw.split('|');
      final p = Progress(
        total: int.tryParse(parts[0]) ?? 0,
        correct: int.tryParse(parts[1]) ?? 0,
      );
      state = p;
    }
  }

  void record(String field, bool isCorrect) {
    final stat = (state.byField[field] ??= FieldStat());
    stat.total++;
    if (isCorrect) stat.correct++;
    state = Progress(
      total: state.total + 1,
      correct: state.correct + (isCorrect ? 1 : 0),
      byField: state.byField,
    );
    _save();
  }

  void reset() {
    state = Progress();
    _save();
  }

  Future<void> _save() async {
    await _prefs?.setString(_key, '${state.total}|${state.correct}');
  }
}
