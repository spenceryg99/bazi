import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/dizhi_relations.dart';

class RelationWheel extends StatelessWidget {
  const RelationWheel({super.key, this.size = 320});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WheelPainter(), size: Size.square(size));
  }
}

class _WheelPainter extends CustomPainter {
  static const _branches = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  Offset _pos(double cx, double cy, double r, int i) {
    final a = (i * 30 - 90) * pi / 180;
    return Offset(cx + r * cos(a), cy + r * sin(a));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 24;

    final circlePaint = Paint()
      ..color = const Color(0xFF2A2A33)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(cx, cy), r, circlePaint);

    for (final rel in relations) {
      final paint = Paint()
        ..color = Color(rel.color).withValues(alpha: 0.55)
        ..strokeWidth = 1.5;
      for (final p in rel.pairs) {
        if (p.members.length >= 4) continue;
        for (int i = 0; i < p.members.length; i++) {
          for (int j = i + 1; j < p.members.length; j++) {
            final a = _branches.indexOf(p.members[i]);
            final b = _branches.indexOf(p.members[j]);
            if (a < 0 || b < 0) continue;
            canvas.drawLine(_pos(cx, cy, r, a), _pos(cx, cy, r, b), paint);
          }
        }
      }
    }

    for (int i = 0; i < 12; i++) {
      final p = _pos(cx, cy, r, i);
      final tp = TextPainter(
        text: TextSpan(
          text: _branches[i],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFECECF2)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
