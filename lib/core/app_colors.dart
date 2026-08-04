import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const bg = Color(0xFF000000);
  static const bgCard = Color(0xFF1C1C1E);
  static const bgElev = Color(0xFF2C2C2E);
  static const bgCardHover = Color(0xFF3A3A3C);

  static const separator = Color(0x33EBEBF5);
  static const border = separator;
  static const borderSoft = separator;

  static const text = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x99EBEBF5);
  static const textTertiary = Color(0x4DEBEBF5);
  static const textSoft = textSecondary;
  static const textDim = textTertiary;

  static const mu = Color(0xFF5AD07A);
  static const huo = Color(0xFFFF6961);
  static const tu = Color(0xFFE8C062);
  static const jin = Color(0xFFB8BEC6);
  static const shui = Color(0xFF5AC8FA);

  static const correct = Color(0xFF32D74B);
  static const wrong = Color(0xFFFF453A);
  static const accent = Color(0xFFE0A458);

  static Color wuxing(String name) => switch (name) {
        '木' => mu,
        '火' => huo,
        '土' => tu,
        '金' => jin,
        '水' => shui,
        _ => textTertiary,
      };
}
