import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/presentation/cycle_phase_style.dart';
import '../core/theme/app_theme.dart';
import '../l10n/l10n.dart';

/// Inputs for [CycleDial]. All values come from the analysis API and the
/// user's recorded cycles; nothing is estimated here.
class CycleDialData {
  const CycleDialData({
    required this.cycleDay,
    required this.cycleLength,
    required this.ovulationDay,
    required this.periodDays,
    this.windowStartDay,
    this.windowEndDay,
  });

  final int? cycleDay;
  final int? cycleLength;
  final int? ovulationDay;

  /// Length of the latest recorded period (start → end date), if the end
  /// date was recorded.
  final int? periodDays;
  final int? windowStartDay;
  final int? windowEndDay;

  bool get hasSegments => cycleLength != null && cycleLength! > 0;

  /// Display mapping of a cycle day to a phase. Mirrors the backend's
  /// `calculate_phase_for_cycle_day` so the dial agrees with the API.
  CyclePhaseKind? phaseForDay(int day) {
    if (periodDays != null && day <= periodDays!) {
      return CyclePhaseKind.menstrual;
    }
    final ovulation = ovulationDay;
    if (ovulation == null) {
      return null;
    }
    if (day < ovulation) {
      return CyclePhaseKind.follicular;
    }
    if (day == ovulation) {
      return CyclePhaseKind.ovulatory;
    }
    return CyclePhaseKind.luteal;
  }
}

/// Circular day-by-day cycle visualization: one segment per estimated
/// cycle day, colored by phase, with elapsed days solid and upcoming days
/// tinted. A thin outer arc marks the estimated ovulation window.
class CycleDial extends StatelessWidget {
  const CycleDial({
    super.key,
    required this.data,
    required this.child,
    this.size = 280,
    this.semanticLabel,
  });

  final CycleDialData data;
  final Widget child;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, progress, child) => CustomPaint(
            painter: _DialPainter(data: data, progress: progress),
            child: child,
          ),
          child: Center(
            child: Padding(padding: EdgeInsets.all(size * 0.17), child: child),
          ),
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({required this.data, required this.progress});

  final CycleDialData data;
  final double progress;

  static const _stroke = 15.0;
  static const _todayStroke = 25.0;
  static const _outerPad = 14.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - _outerPad - _todayStroke / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (!data.hasSegments) {
      _paintTrack(canvas, rect, radius);
      return;
    }

    final total = data.cycleLength!;
    final today = data.cycleDay;
    final perDay = 2 * math.pi / total;
    final gap = math.min(0.035, perDay * 0.28);
    const top = -math.pi / 2;
    final visibleDays = (total * progress).ceil();

    for (var day = 1; day <= total && day <= visibleDays; day++) {
      final phase = data.phaseForDay(day);
      final base = phase?.color ?? AppColors.textFaint;
      final isToday = today != null && day == today.clamp(1, total);
      final isPast = today != null && day < today;
      final color = isToday || isPast ? base : base.withValues(alpha: 0.26);
      canvas.drawArc(
        rect,
        top + (day - 1) * perDay + gap / 2,
        perDay - gap,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isToday ? _todayStroke : _stroke
          ..color = color,
      );
    }

    // Estimated ovulation window, drawn just outside the ring.
    final windowStart = data.windowStartDay;
    final windowEnd = data.windowEndDay;
    if (windowStart != null && windowEnd != null && progress > 0.6) {
      final start = windowStart.clamp(1, total);
      final end = windowEnd.clamp(1, total);
      if (end >= start) {
        final outer = Rect.fromCircle(
          center: center,
          radius: radius + _todayStroke / 2 + 6,
        );
        canvas.drawArc(
          outer,
          top + (start - 1) * perDay + gap / 2,
          (end - start + 1) * perDay - gap,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round
            ..color = PhaseColors.ovulatory.withValues(
              alpha: ((progress - 0.6) / 0.4).clamp(0, 1),
            ),
        );
      }
    }

    // Day-one tick so the ring has an origin.
    final tickStart = Offset(center.dx, center.dy - radius + _stroke / 2 + 4);
    canvas.drawLine(
      tickStart,
      tickStart.translate(0, 6),
      Paint()
        ..color = AppColors.textFaint
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintTrack(Canvas canvas, Rect rect, double radius) {
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..color = AppColors.surfaceAlt;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    // Without an estimated length, show elapsed days as a single soft arc
    // only when a cycle day is known (never invents phase boundaries).
    final day = data.cycleDay;
    if (day != null && day > 0) {
      final fraction = (day / 35).clamp(0.04, 1.0) * progress;
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * fraction,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _stroke
          ..strokeCap = StrokeCap.round
          ..color = AppColors.primary.withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.data != data;
}

/// Horizontal legend for the phase colors used by the dial.
class PhaseLegend extends StatelessWidget {
  const PhaseLegend({
    super.key,
    this.phases = CyclePhaseKind.values,
    this.highlight,
  });

  final List<CyclePhaseKind> phases;
  final CyclePhaseKind? highlight;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      alignment: WrapAlignment.center,
      children: [
        for (final phase in phases)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: phase.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                phase.label(context.l10n),
                style: style?.copyWith(
                  color: phase == highlight
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                  fontWeight: phase == highlight
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
