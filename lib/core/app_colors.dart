import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const bg = Color(0xFF0D0D10);
  static const bgElev = Color(0xFF16161B);
  static const bgCard = Color(0xFF1C1C22);
  static const bgCardHover = Color(0xFF23232B);
  static const border = Color(0xFF2A2A33);
  static const borderSoft = Color(0xFF20202A);

  static const text = Color(0xFFECECF2);
  static const textSoft = Color(0xFFA7A7B3);
  static const textDim = Color(0xFF6B6B78);

  static const mu = Color(0xFF3FA66A);
  static const huo = Color(0xFFE0564B);
  static const tu = Color(0xFFC89A3A);
  static const jin = Color(0xFF9AA3AD);
  static const shui = Color(0xFF3B7DD8);

  static const correct = Color(0xFF3FA66A);
  static const wrong = Color(0xFFE0564B);
  static const accent = Color(0xFFB88DFF);

  static Color wuxing(String name) => switch (name) {
        '木' => mu,
        '火' => huo,
        '土' => tu,
        '金' => jin,
        '水' => shui,
        _ => textDim,
      };
}
