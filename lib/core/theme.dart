import 'package:flutter/material.dart';

import 'app_colors.dart';

const _fontFamily = '.SF Pro Text';
const _ff = -0.4;

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        onPrimary: Colors.black,
        secondary: AppColors.accent,
        onSecondary: Colors.black,
        surface: AppColors.bg,
        onSurface: AppColors.text,
        surfaceContainerHighest: AppColors.bgElev,
        outline: AppColors.separator,
      ),
      cardColor: AppColors.bgCard,
      dividerColor: AppColors.separator,
      canvasColor: AppColors.bg,
      fontFamily: _fontFamily,
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xF0000000),
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          letterSpacing: _ff,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
        height: 56,
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
              fontFamily: _fontFamily,
              fontSize: 10,
              fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: _ff,
            )),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: _ff,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: AppColors.separator, width: 1),
          textStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: _ff),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgElev,
        selectedColor: AppColors.accent,
        labelStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide.none,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.accent, linearTrackColor: AppColors.bgElev),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgElev,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
        labelStyle: const TextStyle(fontFamily: _fontFamily, color: AppColors.textTertiary, fontSize: 13),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.separator, thickness: 0.5, space: 0.5),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
    return base;
  }
}

const _textTheme = TextTheme(
  displayLarge: TextStyle(fontFamily: '.SF Pro Display', fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: 0.37, height: 1.1, color: AppColors.text),
  displayMedium: TextStyle(fontFamily: '.SF Pro Display', fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 0.36, color: AppColors.text),
  displaySmall: TextStyle(fontFamily: '.SF Pro Display', fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: _ff, color: AppColors.text),
  headlineMedium: TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: _ff, color: AppColors.text),
  titleLarge: TextStyle(fontFamily: _fontFamily, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: _ff, color: AppColors.text),
  titleMedium: TextStyle(fontFamily: _fontFamily, fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: _ff, color: AppColors.text),
  titleSmall: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: _ff, color: AppColors.textSecondary),
  bodyLarge: TextStyle(fontFamily: _fontFamily, fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: _ff, height: 1.4, color: AppColors.text),
  bodyMedium: TextStyle(fontFamily: _fontFamily, fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: _ff, height: 1.4, color: AppColors.text),
  bodySmall: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: _ff, height: 1.35, color: AppColors.textSecondary),
  labelLarge: TextStyle(fontFamily: _fontFamily, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: _ff, color: AppColors.text),
  labelMedium: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: _ff, color: AppColors.textSecondary),
  labelSmall: TextStyle(fontFamily: _fontFamily, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: _ff, color: AppColors.textTertiary),
);
