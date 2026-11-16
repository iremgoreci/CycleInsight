import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/presentation/cycle_phase_style.dart';
import '../core/theme/app_theme.dart';

/// The CycleInsight mark: four arcs proportioned like an example 28-day
/// cycle (5 · 8 · 2 · 13 days), echoing the cycle dial on the Today screen.
class PhaseSpectrumMark extends StatelessWidget {
  const PhaseSpectrumMark({super.key, this.size = 22, this.strokeWidth});

  final double size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _MarkPainter(strokeWidth: strokeWidth ?? size * 0.16),
        ),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter({required this.strokeWidth});

  final double strokeWidth;

  static const _segments = [
    (5, CyclePhaseKind.menstrual),
    (8, CyclePhaseKind.follicular),
    (2, CyclePhaseKind.ovulatory),
    (13, CyclePhaseKind.luteal),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - strokeWidth) / 2,
    );
    const total = 28;
    const gap = 0.2;
    var start = -math.pi / 2;
    for (final (days, phase) in _segments) {
      final sweep = days / total * 2 * math.pi;
      canvas.drawArc(
        rect,
        start + gap / 2,
        sweep - gap,
        false,
        Paint()
          ..color = phase.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_MarkPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth;
}

/// Mark + wordmark lockup.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.markSize = 22,
    this.fontSize = 17,
    this.showMark = true,
  });

  final double markSize;
  final double fontSize;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'CycleInsight',
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showMark) ...[
                PhaseSpectrumMark(size: markSize),
                SizedBox(width: markSize * 0.42),
              ],
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Cycle'),
                    TextSpan(
                      text: 'Insight',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
