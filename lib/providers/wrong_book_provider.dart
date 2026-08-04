import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/types.dart';

class WrongRecord {
  final String questionId;
  int wrongCount;
  int correctStreak;
  String lastField;
  String lastCategory;
  WrongRecord({
    required this.questionId,
    this.wrongCount = 1,
    this.correctStreak = 0,
    this.lastField = '',
    this.lastCategory = '',
  });

  Map<String, dynamic> toJson() => {
        'id': questionId,
        'wrong': wrongCount,
        'streak': correctStreak,
        'field': lastField,
        'cat': lastCategory,
      };

  factory WrongRecord.fromJson(Map<String, dynamic> j) => WrongRecord(
        questionId: j['id'] as String,
        wrongCount: j['wrong'] as int? ?? 1,
        correctStreak: j['streak'] as int? ?? 0,
        lastField: j['field'] as String? ?? '',
        lastCategory: j['cat'] as String? ?? '',
      );
}

final wrongBookProvider =
    NotifierProvider<WrongBookNotifier, List<WrongRecord>>(WrongBookNotifier.new);

class WrongBookNotifier extends Notifier<List<WrongRecord>> {
  static const _key = 'bazi-wrong-book-v1';
  SharedPreferences? _prefs;

  @override
  List<WrongRecord> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_key);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        state = list.map((e) => WrongRecord.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
  }

  void markWrong(Question q) {
    final records = List<WrongRecord>.from(state);
    final i = records.indexWhere((r) => r.questionId == q.id);
    if (i >= 0) {
      records[i].wrongCount++;
      records[i].correctStreak = 0;
      records[i].lastField = q.fieldLabel;
      records[i].lastCategory = q.category ?? '';
    } else {
      records.add(WrongRecord(
        questionId: q.id,
        lastField: q.fieldLabel,
        lastCategory: q.category ?? '',
      ));
    }
    state = records;
    _save();
  }

  void markCorrect(Question q) {
    final records = List<WrongRecord>.from(state);
    final i = records.indexWhere((r) => r.questionId == q.id);
    if (i < 0) return;
    records[i].correctStreak++;
    if (records[i].correctStreak >= 2) {
      records.removeAt(i);
    }
    state = records;
    _save();
  }

  void clear() {
    state = [];
    _save();
  }

  List<MapEntry<String, int>> weakCategories() {
    final m = <String, int>{};
    for (final r in state) {
      final key = r.lastCategory.isEmpty ? r.lastField : r.lastCategory;
      if (key.isEmpty) continue;
      m[key] = (m[key] ?? 0) + 1;
    }
    final entries = m.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  Future<void> _save() async {
    await _prefs?.setString(_key, jsonEncode(state.map((r) => r.toJson()).toList()));
  }
}
