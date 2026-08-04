import 'package:flutter/services.dart';

class Haptic {
  Haptic._();

  static void tap() => HapticFeedback.lightImpact();

  static void select() => HapticFeedback.selectionClick();

  static void light() => HapticFeedback.lightImpact();

  static void medium() => HapticFeedback.mediumImpact();

  static void correct() => HapticFeedback.lightImpact();

  static void wrong() => HapticFeedback.heavyImpact();
}
