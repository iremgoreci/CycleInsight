import 'package:flutter/material.dart';

import '../../core/presentation/cycle_phase_style.dart';
import '../../core/theme/app_theme.dart';

/// A 0–[max] track showing the recorded min–max span as a tinted band and
/// the average as a ringed marker. Used for wellbeing summaries.
class RangeStrip extends StatelessWidget {
  const RangeStrip({
    super.key,
    required this.color,
    this.minimum,
    this.maximum,
    this.average,
    this.max = 5,
    this.height = 22,
  });

  final Color color;
  final int? minimum;
  final int? maximum;
  final double? average;
  final int max;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: CustomPaint(
          size: Size.infinite,
          painter: _RangePainter(
            color: color,
            minimum: minimum,
            maximum: maximum,
            average: average,
            max: max,
          ),
        ),
      ),
    );
  }
}

class _RangePainter extends CustomPainter {
  _RangePainter({
    required this.color,
    required this.minimum,
    required this.maximum,
    required this.average,
    required this.max,
  });

  final Color color;
  final int? minimum;
  final int? maximum;
  final double? average;
  final int max;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 7.0;
    final width = size.width - inset * 2;
    final cy = size.height / 2;
    double x(num v) => inset + width * (v / max);

    // Track and integer ticks.
    canvas.drawRRect(
      RRect.fromLTRBR(
        inset,
        cy - 3,
        size.width - inset,
        cy + 3,
        const Radius.circular(3),
      ),
      Paint()..color = AppColors.surfaceAlt,
    );
    final tick = Paint()
      ..color = AppColors.outline
      ..strokeWidth = 1;
    for (var i = 0; i <= max; i++) {
      canvas.drawLine(Offset(x(i), cy + 6), Offset(x(i), cy + 9), tick);
    }

    if (minimum != null && maximum != null) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          x(minimum!) - 3,
          cy - 3,
          x(maximum!) + 3,
          cy + 3,
          const Radius.circular(3),
        ),
        Paint()..color = color.withValues(alpha: 0.32),
      );
    }
    if (average != null) {
      final c = Offset(x(average!.clamp(0, max)), cy);
      canvas.drawCircle(c, 7.5, Paint()..color = AppColors.surface);
      canvas.drawCircle(c, 5.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_RangePainter old) =>
      old.color != color ||
      old.minimum != minimum ||
      old.maximum != maximum ||
      old.average != average;
}

/// −1 … +1 scale with a marker at [value]. Neutral track, center tick at
/// zero; the marker takes sage for positive and lavender for negative
/// association (two poles, neutral midpoint).
class CorrelationScale extends StatelessWidget {
  const CorrelationScale({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.figure.copyWith(
      fontSize: 11,
      color: AppColors.textMuted,
    );
    return ExcludeSemantics(
      child: Column(
        children: [
          SizedBox(
            height: 22,
            child: CustomPaint(
              size: Size.infinite,
              painter: _CorrelationPainter(value: value.clamp(-1, 1)),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text('−1', style: style),
              const Spacer(),
              Text('0', style: style),
              const Spacer(),
              Text('+1', style: style),
            ],
          ),
        ],
      ),
    );
  }
}

class _CorrelationPainter extends CustomPainter {
  _CorrelationPainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 7.0;
    final width = size.width - inset * 2;
    final cy = size.height / 2;
    final zero = inset + width / 2;
    final vx = inset + width * (value + 1) / 2;
    final color = value >= 0 ? AppColors.primary : AppColors.lavender;

    canvas.drawRRect(
      RRect.fromLTRBR(
        inset,
        cy - 2,
        size.width - inset,
        cy + 2,
        const Radius.circular(2),
      ),
      Paint()..color = AppColors.surfaceAlt,
    );
    canvas.drawRect(
      Rect.fromLTRB(
        value >= 0 ? zero : vx,
        cy - 2,
        value >= 0 ? vx : zero,
        cy + 2,
      ),
      Paint()..color = color.withValues(alpha: 0.4),
    );
    canvas.drawLine(
      Offset(zero, cy - 7),
      Offset(zero, cy + 7),
      Paint()
        ..color = AppColors.textFaint
        ..strokeWidth = 1.2,
    );
    canvas.drawCircle(Offset(vx, cy), 7.5, Paint()..color = AppColors.surface);
    canvas.drawCircle(Offset(vx, cy), 5.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CorrelationPainter old) => old.value != value;
}

/// Stacked bar of counts per phase with 2px gaps between segments.
class PhaseDistributionBar extends StatelessWidget {
  const PhaseDistributionBar({
    super.key,
    required this.distribution,
    this.height = 6,
  });

  final Map<String, int> distribution;
  final double height;

  @override
  Widget build(BuildContext context) {
    final entries = [
      for (final phase in CyclePhaseKind.values)
        if ((distribution[phase.apiValue] ?? 0) > 0)
          (phase, distribution[phase.apiValue]!),
    ];
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (var i = 0; i < entries.length; i++) ...[
                if (i > 0) const SizedBox(width: 2),
                Expanded(
                  flex: entries[i].$2,
                  child: ColoredBox(color: entries[i].$1.color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
